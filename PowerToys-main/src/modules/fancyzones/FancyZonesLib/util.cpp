#include "pch.h"
#include "util.h"

#include <common/display/dpi_aware.h>
#include <common/logger/logger.h>
#include <common/utils/process_path.h>
#include <common/utils/window.h>
#include <common/utils/excluded_apps.h>

#include <array>
#include <complex>

#include <common/display/dpi_aware.h>

#include <FancyZonesLib/FancyZonesWindowProperties.h>

namespace FancyZonesUtils
{
    std::wstring TrimDeviceId(const std::wstring& deviceId)
    {
        // We're interested in the unique part between the first and last #'s
        // Example input: \\?\DISPLAY#DELA026#5&10a58c63&0&UID16777488#{e6f07b5f-ee97-4a90-b076-33f57bf4eaa7}
        // Example output: DELA026#5&10a58c63&0&UID16777488
        static const std::wstring defaultDeviceId = L"FallbackDevice";
        if (deviceId.empty())
        {
            return defaultDeviceId;
        }

        size_t start = deviceId.find(L'#');
        size_t end = deviceId.rfind(L'#');
        if (start != std::wstring::npos && end != std::wstring::npos && start != end)
        {
            size_t size = end - (start + 1);
            return deviceId.substr(start + 1, size);
        }
        else
        {
            return defaultDeviceId;
        }
    }

    typedef BOOL(WINAPI* GetDpiForMonitorInternalFunc)(HMONITOR, UINT, UINT*, UINT*);

    std::wstring GetDisplayDeviceId(const std::wstring& device, std::unordered_map<std::wstring, DWORD>& displayDeviceIdxMap)
    {
        DISPLAY_DEVICE displayDevice{ .cb = sizeof(displayDevice) };
        std::wstring deviceId;
        while (EnumDisplayDevicesW(device.c_str(), displayDeviceIdxMap[device], &displayDevice, EDD_GET_DEVICE_INTERFACE_NAME))
        {
            ++displayDeviceIdxMap[device];

            Logger::info(L"Get display device: {}", displayDevice.DeviceID);

            // Only take active monitors (presented as being "on" by the respective GDI view) and monitors that don't
            // represent a pseudo device used to mirror application drawing.
            if (WI_IsFlagSet(displayDevice.StateFlags, DISPLAY_DEVICE_ACTIVE) &&
                WI_IsFlagClear(displayDevice.StateFlags, DISPLAY_DEVICE_MIRRORING_DRIVER))
            {
                deviceId = displayDevice.DeviceID;
                break;
            }
        }

        if (deviceId.empty())
        {
            Logger::info(L"Didn't find display device, set default");
            deviceId = GetSystemMetrics(SM_REMOTESESSION) ?
                           L"\\\\?\\DISPLAY#REMOTEDISPLAY#" :
                           L"\\\\?\\DISPLAY#LOCALDISPLAY#";
        }

        return deviceId;
    }

    UINT GetDpiForMonitor(HMONITOR monitor) noexcept
    {
        UINT dpi{};
        if (wil::unique_hmodule user32{ LoadLibrary(L"user32.dll") })
        {
            if (auto func = reinterpret_cast<GetDpiForMonitorInternalFunc>(GetProcAddress(user32.get(), "GetDpiForMonitorInternal")))
            {
                func(monitor, 0, &dpi, &dpi);
            }
        }

        if (dpi == 0)
        {
            if (wil::unique_hdc hdc{ GetDC(nullptr) })
            {
                dpi = GetDeviceCaps(hdc.get(), LOGPIXELSX);
            }
        }

        return (dpi == 0) ? DPIAware::DEFAULT_DPI : dpi;
    }

    void OrderMonitors(std::vector<std::pair<HMONITOR, RECT>>& monitorInfo)
    {
        const size_t nMonitors = monitorInfo.size();
        // blocking[i][j] - whether monitor i blocks monitor j in the ordering, i.e. monitor i should go before monitor j
        std::vector<std::vector<bool>> blocking(nMonitors, std::vector<bool>(nMonitors, false));

        // blockingCount[j] - the number of monitors which block monitor j
        std::vector<size_t> blockingCount(nMonitors, 0);

        for (size_t i = 0; i < nMonitors; i++)
        {
            RECT rectI = monitorInfo[i].second;
            for (size_t j = 0; j < nMonitors; j++)
            {
                RECT rectJ = monitorInfo[j].second;
                blocking[i][j] = rectI.top < rectJ.bottom && rectI.left < rectJ.right && i != j;
                if (blocking[i][j])
                {
                    blockingCount[j]++;
                }
            }
        }

        // used[i] - whether the sorting algorithm has used monitor i so far
        std::vector<bool> used(nMonitors, false);

        // the sorted sequence of monitors
        std::vector<std::pair<HMONITOR, RECT>> sortedMonitorInfo;

        for (size_t iteration = 0; iteration < nMonitors; iteration++)
        {
            // Indices of candidates to become the next monitor in the sequence
            std::vector<size_t> candidates;

            // First, find indices of all unblocked monitors
            for (size_t i = 0; i < nMonitors; i++)
            {
                if (blockingCount[i] == 0 && !used[i])
                {
                    candidates.push_back(i);
                }
            }

            // In the unlikely event that there are no unblocked monitors, declare all unused monitors as candidates.
            if (candidates.empty())
            {
                for (size_t i = 0; i < nMonitors; i++)
                {
                    if (!used[i])
                    {
                        candidates.push_back(i);
                    }
                }
            }

            // Pick the lexicographically smallest monitor as the next one
            size_t smallest = candidates[0];
            for (size_t j = 1; j < candidates.size(); j++)
            {
                size_t current = candidates[j];

                // Compare (top, left) lexicographically
                if (std::tie(monitorInfo[current].second.top, monitorInfo[current].second.left) <
                    std::tie(monitorInfo[smallest].second.top, monitorInfo[smallest].second.left))
                {
                    smallest = current;
                }
            }

            used[smallest] = true;
            sortedMonitorInfo.push_back(monitorInfo[smallest]);
            for (size_t i = 0; i < nMonitors; i++)
            {
                if (blocking[smallest][i])
                {
                    blockingCount[i]--;
                }
            }
        }

        monitorInfo = std::move(sortedMonitorInfo);
    }

    bool IsValidGuid(const std::wstring& str)
    {
        GUID id;
        return SUCCEEDED(CLSIDFromString(str.c_str(), &id));
    }

    std::optional<GUID> GuidFromString(const std::wstring& str) noexcept
    {
        GUID id;
        if (SUCCEEDED(CLSIDFromString(str.c_str(), &id)))
        {
            return id;
        }

        return std::nullopt;
    }

    std::optional<std::wstring> GuidToString(const GUID& guid) noexcept
    {
        wil::unique_cotaskmem_string guidString;
        if (SUCCEEDED(StringFromCLSID(guid, &guidString)))
        {
            return guidString.get();
        }

        return std::nullopt;
    }

    std::wstring GenerateUniqueId(HMONITOR monitor, const std::wstring& deviceId, const std::wstring& virtualDesktopId)
    {
        MONITORINFOEXW mi;
        mi.cbSize = sizeof(mi);
        if (!virtualDesktopId.empty() && GetMonitorInfo(monitor, &mi))
        {
            Rect const monitorRect(mi.rcMonitor);
            // Unique identifier format: <parsed-device-id>_<width>_<height>_<virtual-desktop-id>
            return TrimDeviceId(deviceId) +
                   L'_' +
                   std::to_wstring(monitorRect.width()) +
                   L'_' +
                   std::to_wstring(monitorRect.height()) +
                   L'_' +
                   virtualDesktopId;
        }
        return {};
    }

    std::wstring GenerateUniqueIdAllMonitorsArea(const std::wstring& virtualDesktopId)
    {
        std::wstring result{ ZonedWindowProperties::MultiMonitorDeviceID };

        RECT combinedResolution = GetAllMonitorsCombinedRect<&MONITORINFO::rcMonitor>();

        result += L'_';
        result += std::to_wstring(combinedResolution.right - combinedResolution.left);
        result += L'_';
        result += std::to_wstring(combinedResolution.bottom - combinedResolution.top);
        result += L'_';
        result += virtualDesktopId;

        return result;
    }

    size_t ChooseNextZoneByPosition(DWORD vkCode, RECT windowRect, const std::vector<RECT>& zoneRects) noexcept
    {
        using complex = std::complex<double>;
        const size_t invalidResult = zoneRects.size();
        const double inf = 1e100;
        const double eccentricity = 2.0;

        auto rectCenter = [](RECT rect) {
            return complex{
                0.5 * rect.left + 0.5 * rect.right,
                0.5 * rect.top + 0.5 * rect.bottom
            };
        };

        auto distance = [&](complex arrowDirection, complex zoneDirection) {
            double result = inf;

            try
            {
                double scalarProduct = (arrowDirection * conj(zoneDirection)).real();
                if (scalarProduct <= 0.0)
                {
                    return inf;
                }

                // no need to divide by abs(arrowDirection) because it's = 1
                double cosAngle = scalarProduct / abs(zoneDirection);
                double tanAngle = abs(tan(acos(cosAngle)));

                if (tanAngle > 10)
                {
                    // The angle is too wide
                    return inf;
                }

                // find the intersection with the ellipse with given eccentricity and major axis along arrowDirection
                double intersectY = 2 * eccentricity / (1.0 + eccentricity * eccentricity * tanAngle * tanAngle);
                double distanceEstimate = scalarProduct / intersectY;

                if (std::isfinite(distanceEstimate))
                {
                    result = distanceEstimate;
                }
            }
            catch (...)
            {
            }

            return result;
        };
        std::vector<std::pair<size_t, complex>> candidateCenters;
        for (size_t i = 0; i < zoneRects.size(); i++)
        {
            auto center = rectCenter(zoneRects[i]);

            // Offset the zone slightly, to differentiate in case there are overlapping zones
            center += 0.001 * (i + 1);

            candidateCenters.emplace_back(i, center);
        }

        complex directionVector, windowCenter = rectCenter(windowRect);

        switch (vkCode)
        {
        case VK_UP:
            directionVector = { 0.0, -1.0 };
            break;
        case VK_DOWN:
            directionVector = { 0.0, 1.0 };
            break;
        case VK_LEFT:
            directionVector = { -1.0, 0.0 };
            break;
        case VK_RIGHT:
            directionVector = { 1.0, 0.0 };
            break;
        default:
            return invalidResult;
        }

        size_t closestIdx = invalidResult;
        double smallestDistance = inf;

        for (auto [zoneIdx, zoneCenter] : candidateCenters)
        {
            double dist = distance(directionVector, zoneCenter - windowCenter);
            if (dist < smallestDistance)
            {
                smallestDistance = dist;
                closestIdx = zoneIdx;
            }
        }

        return closestIdx;
    }

    RECT PrepareRectForCycling(RECT windowRect, RECT workAreaRect, DWORD vkCode) noexcept
    {
        LONG deltaX = 0, deltaY = 0;
        switch (vkCode)
        {
        case VK_UP:
            deltaY = workAreaRect.bottom - workAreaRect.top;
            break;
        case VK_DOWN:
            deltaY = workAreaRect.top - workAreaRect.bottom;
            break;
        case VK_LEFT:
            deltaX = workAreaRect.right - workAreaRect.left;
            break;
        case VK_RIGHT:
            deltaX = workAreaRect.left - workAreaRect.right;
        }

        windowRect.left += deltaX;
        windowRect.right += deltaX;
        windowRect.top += deltaY;
        windowRect.bottom += deltaY;

        return windowRect;
    }
}
