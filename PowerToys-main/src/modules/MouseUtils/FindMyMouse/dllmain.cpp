#include "pch.h"
#include <interface/powertoy_module_interface.h>
#include <common/SettingsAPI/settings_objects.h>
#include "trace.h"
#include "FindMyMouse.h"
#include <thread>
#include <common/utils/logger_helper.h>
#include <common/utils/color.h>
#include <common/utils/string_utils.h>

namespace
{
    const wchar_t JSON_KEY_PROPERTIES[] = L"properties";
    const wchar_t JSON_KEY_VALUE[] = L"value";
    const wchar_t JSON_KEY_ACTIVATION_METHOD[] = L"activation_method";
    const wchar_t JSON_KEY_DO_NOT_ACTIVATE_ON_GAME_MODE[] = L"do_not_activate_on_game_mode";
    const wchar_t JSON_KEY_BACKGROUND_COLOR[] = L"background_color";
    const wchar_t JSON_KEY_SPOTLIGHT_COLOR[] = L"spotlight_color";
    const wchar_t JSON_KEY_OVERLAY_OPACITY[] = L"overlay_opacity";
    const wchar_t JSON_KEY_SPOTLIGHT_RADIUS[] = L"spotlight_radius";
    const wchar_t JSON_KEY_ANIMATION_DURATION_MS[] = L"animation_duration_ms";
    const wchar_t JSON_KEY_SPOTLIGHT_INITIAL_ZOOM[] = L"spotlight_initial_zoom";
    const wchar_t JSON_KEY_EXCLUDED_APPS[] = L"excluded_apps";
    const wchar_t JSON_KEY_SHAKING_MINIMUM_DISTANCE[] = L"shaking_minimum_distance";
}

extern "C" IMAGE_DOS_HEADER __ImageBase;

HMODULE m_hModule;

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
    m_hModule = hModule;
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        Trace::RegisterProvider();
        break;
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
        break;
    case DLL_PROCESS_DETACH:
        Trace::UnregisterProvider();
        break;
    }
    return TRUE;
}

// The PowerToy name that will be shown in the settings.
const static wchar_t* MODULE_NAME = L"FindMyMouse";
// Add a description that will we shown in the module settings page.
const static wchar_t* MODULE_DESC = L"Focus the mouse pointer";

// Implement the PowerToy Module Interface and all the required methods.
class FindMyMouse : public PowertoyModuleIface
{
private:
    // The PowerToy state.
    bool m_enabled = false;

    // Find My Mouse specific settings
    FindMyMouseSettings m_findMyMouseSettings;

    // Load initial settings from the persisted values.
    void init_settings();

    // Helper function to extract the settings
    void parse_settings(PowerToysSettings::PowerToyValues& settings);

public:
    // Constructor
    FindMyMouse()
    {
        LoggerHelpers::init_logger(MODULE_NAME, L"ModuleInterface", LogSettings::findMyMouseLoggerName);
        init_settings();
    };

    // Destroy the powertoy and free memory
    virtual void destroy() override
    {
        delete this;
    }

    // Return the localized display name of the powertoy
    virtual const wchar_t* get_name() override
    {
        return MODULE_NAME;
    }

    // Return the non localized key of the powertoy, this will be cached by the runner
    virtual const wchar_t* get_key() override
    {
        return MODULE_NAME;
    }

    // Return JSON with the configuration options.
    virtual bool get_config(wchar_t* buffer, int* buffer_size) override
    {
        HINSTANCE hinstance = reinterpret_cast<HINSTANCE>(&__ImageBase);

        // Create a Settings object.
        PowerToysSettings::Settings settings(hinstance, get_name());
        settings.set_description(MODULE_DESC);

        return settings.serialize_to_buffer(buffer, buffer_size);
    }

    // Signal from the Settings editor to call a custom action.
    // This can be used to spawn more complex editors.
    virtual void call_custom_action(const wchar_t* action) override
    {
    }

    // Called by the runner to pass the updated settings values as a serialized JSON.
    virtual void set_config(const wchar_t* config) override
    {
        try
        {
            // Parse the input JSON string.
            PowerToysSettings::PowerToyValues values =
                PowerToysSettings::PowerToyValues::from_json_string(config, get_key());

            parse_settings(values);

            FindMyMouseApplySettings(m_findMyMouseSettings);
        }
        catch (std::exception&)
        {
            // Improper JSON.
        }
    }

    // Enable the powertoy
    virtual void enable()
    {
        m_enabled = true;
        Trace::EnableFindMyMouse(true);
        std::thread([=]() { FindMyMouseMain(m_hModule, m_findMyMouseSettings); }).detach();
    }

    // Disable the powertoy
    virtual void disable()
    {
        m_enabled = false;
        Trace::EnableFindMyMouse(false);
        FindMyMouseDisable();
    }

    // Returns if the powertoys is enabled
    virtual bool is_enabled() override
    {
        return m_enabled;
    }
};

// Load the settings file.
void FindMyMouse::init_settings()
{
    try
    {
        // Load and parse the settings file for this PowerToy.
        PowerToysSettings::PowerToyValues settings =
            PowerToysSettings::PowerToyValues::load_from_settings_file(FindMyMouse::get_key());
        parse_settings(settings);
    }
    catch (std::exception&)
    {
        // Error while loading from the settings file. Let default values stay as they are.
    }
}

void FindMyMouse::parse_settings(PowerToysSettings::PowerToyValues& settings)
{
    auto settingsObject = settings.get_raw_json();
    FindMyMouseSettings findMyMouseSettings;
    if (settingsObject.GetView().Size())
    {
        try
        {
            // Parse Activation Method
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_ACTIVATION_METHOD);
            UINT value = (UINT)jsonPropertiesObject.GetNamedNumber(JSON_KEY_VALUE);
            if (value < (int)FindMyMouseActivationMethod::EnumElements)
            {
                findMyMouseSettings.activationMethod = (FindMyMouseActivationMethod)value;
            }
        }
        catch (...)
        {
            Logger::warn("Failed to initialize Activation Method from settings. Will use default value");
        }
        try
        {
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_DO_NOT_ACTIVATE_ON_GAME_MODE);
            findMyMouseSettings.doNotActivateOnGameMode = (bool)jsonPropertiesObject.GetNamedBoolean(JSON_KEY_VALUE);
        }
        catch (...)
        {
            Logger::warn("Failed to get 'do not activate on game mode' setting");
        }
        try
        {
            // Parse background color
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_BACKGROUND_COLOR);
            auto backgroundColor = (std::wstring)jsonPropertiesObject.GetNamedString(JSON_KEY_VALUE);
            uint8_t r, g, b;
            if (!checkValidRGB(backgroundColor, &r, &g, &b))
            {
                Logger::error("Background color RGB value is invalid. Will use default value");
            }
            else
            {
                findMyMouseSettings.backgroundColor = winrt::Windows::UI::ColorHelper::FromArgb(255, r, g, b);
            }
        }
        catch (...)
        {
            Logger::warn("Failed to initialize background color from settings. Will use default value");
        }
        try
        {
            // Parse spotlight color
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_SPOTLIGHT_COLOR);
            auto spotlightColor = (std::wstring)jsonPropertiesObject.GetNamedString(JSON_KEY_VALUE);
            uint8_t r, g, b;
            if (!checkValidRGB(spotlightColor, &r, &g, &b))
            {
                Logger::error("Spotlight color RGB value is invalid. Will use default value");
            }
            else
            {
                findMyMouseSettings.spotlightColor = winrt::Windows::UI::ColorHelper::FromArgb(255, r, g, b);
            }
        }
        catch (...)
        {
            Logger::warn("Failed to initialize spotlight color from settings. Will use default value");
        }
        try
        {
            // Parse Overlay Opacity
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_OVERLAY_OPACITY);
            findMyMouseSettings.overlayOpacity = (UINT)jsonPropertiesObject.GetNamedNumber(JSON_KEY_VALUE);
        }
        catch (...)
        {
            Logger::warn("Failed to initialize Overlay Opacity from settings. Will use default value");
        }
        try
        {
            // Parse Spotlight Radius
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_SPOTLIGHT_RADIUS);
            findMyMouseSettings.spotlightRadius = (UINT)jsonPropertiesObject.GetNamedNumber(JSON_KEY_VALUE);
        }
        catch (...)
        {
            Logger::warn("Failed to initialize Spotlight Radius from settings. Will use default value");
        }
        try
        {
            // Parse Animation Duration
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_ANIMATION_DURATION_MS);
            findMyMouseSettings.animationDurationMs = (UINT)jsonPropertiesObject.GetNamedNumber(JSON_KEY_VALUE);
        }
        catch (...)
        {
            Logger::warn("Failed to initialize Animation Duration from settings. Will use default value");
        }
        try
        {
            // Parse Spotlight Initial Zoom
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_SPOTLIGHT_INITIAL_ZOOM);
            findMyMouseSettings.spotlightInitialZoom = (UINT)jsonPropertiesObject.GetNamedNumber(JSON_KEY_VALUE);
        }
        catch (...)
        {
            Logger::warn("Failed to initialize Spotlight Initial Zoom from settings. Will use default value");
        }
        try
        {
            // Parse Excluded Apps
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_EXCLUDED_APPS);
            std::wstring apps = jsonPropertiesObject.GetNamedString(JSON_KEY_VALUE).c_str();
            std::vector<std::wstring> excludedApps;
            auto excludedUppercase = apps;
            CharUpperBuffW(excludedUppercase.data(), (DWORD)excludedUppercase.length());
            std::wstring_view view(excludedUppercase);
            view = left_trim<wchar_t>(trim<wchar_t>(view));

            while (!view.empty())
            {
                auto pos = (std::min)(view.find_first_of(L"\r\n"), view.length());
                excludedApps.emplace_back(view.substr(0, pos));
                view.remove_prefix(pos);
                view = left_trim<wchar_t>(trim<wchar_t>(view));
            }

            findMyMouseSettings.excludedApps = excludedApps;
        }
        catch (...)
        {
            Logger::warn("Failed to initialize Excluded Apps from settings. Will use default value");
        }
        try
        {
            // Parse Shaking Minimum Distance
            auto jsonPropertiesObject = settingsObject.GetNamedObject(JSON_KEY_PROPERTIES).GetNamedObject(JSON_KEY_SHAKING_MINIMUM_DISTANCE);
            findMyMouseSettings.shakeMinimumDistance = (UINT)jsonPropertiesObject.GetNamedNumber(JSON_KEY_VALUE);
        }
        catch (...)
        {
            Logger::warn("Failed to initialize Shaking Minimum Distance from settings. Will use default value");
        }
    }
    else
    {
        Logger::info("Find My Mouse settings are empty");
    }
    m_findMyMouseSettings = findMyMouseSettings;
}


extern "C" __declspec(dllexport) PowertoyModuleIface* __cdecl powertoy_create()
{
    return new FindMyMouse();
}