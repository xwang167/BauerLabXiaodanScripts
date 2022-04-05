#pragma once

#include "registry.h"

#include <common/utils/json.h>

#include <filesystem>

namespace fs = std::filesystem;

namespace NonLocalizable
{
    const static wchar_t* MONACO_LANGUAGES_FILE_NAME = L"modules\\FileExplorerPreview\\monaco_languages.json";
    const static wchar_t* ListID = L"list";
    const static wchar_t* ExtensionsID = L"extensions";
    const static std::vector<std::wstring> ExtSVG      = { L".svg" };
    const static std::vector<std::wstring> ExtMarkdown = { L".md", L".markdown", L".mdown", L".mkdn", L".mkd", L".mdwn", L".mdtxt", L".mdtext" };
    const static std::vector<std::wstring> ExtPDF      = { L".pdf" };
    const static std::vector<std::wstring> ExtGCode    = { L".gcode" };
    const static std::vector<std::wstring> ExtSTL      = { L".stl" };
    const static std::vector<std::wstring> ExtNoNoNo   = { 
        L".svgz" //Monaco cannot handle this file type at all; it's a binary file.
    };
}

inline registry::ChangeSet getSvgPreviewHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::preview,
                                  perUser,
                                  L"{ddee2b8a-6807-48a6-bb20-2338174ff779}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } /
                                   LR"d(modules\FileExplorerPreview\PowerToys.SvgPreviewHandler.comhost.dll)d")
                                      .wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.PreviewHandler.Svg.SvgPreviewHandler",
                                  L"Svg Preview Handler",
                                  NonLocalizable::ExtSVG);
}

inline registry::ChangeSet getMdPreviewHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::preview,
                                  perUser,
                                  L"{45769bcc-e8fd-42d0-947e-02beef77a1f5}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.MarkdownPreviewHandler.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.PreviewHandler.Markdown.MarkdownPreviewHandler",
                                  L"Markdown Preview Handler",
                                  NonLocalizable::ExtMarkdown);
}

inline registry::ChangeSet getMonacoPreviewHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;

    // Set up a list of extensions for the preview handler to take over
    std::vector<std::wstring> extensions;

    // Set up a list of extensions that Monaco support but the preview handler shouldn't take over
    std::vector<std::wstring> ExtExclusions;
    ExtExclusions.insert(ExtExclusions.end(), NonLocalizable::ExtMarkdown.begin(), NonLocalizable::ExtMarkdown.end());
    ExtExclusions.insert(ExtExclusions.end(), NonLocalizable::ExtSVG.begin(), NonLocalizable::ExtSVG.end());
    ExtExclusions.insert(ExtExclusions.end(), NonLocalizable::ExtNoNoNo.begin(), NonLocalizable::ExtNoNoNo.end());
    bool IsExcluded = false;

    std::wstring languagesFilePath = fs::path{ installationDir } / NonLocalizable::MONACO_LANGUAGES_FILE_NAME;
    auto json = json::from_file(languagesFilePath);

    if (json)
    {
        try
        {
            auto list = json->GetNamedArray(NonLocalizable::ListID);
            for (uint32_t i = 0; i < list.Size(); ++i)
            {
                auto entry = list.GetObjectAt(i);
                auto extensionsList = entry.GetNamedArray(NonLocalizable::ExtensionsID);

                for (uint32_t j = 0; j < extensionsList.Size(); ++j)
                {
                    auto extension = extensionsList.GetStringAt(j);
                    
                    // Ignore extensions in the exclusion list
                    IsExcluded = false;
                    
                    for (std::wstring k : ExtExclusions)
                    {
                        if (std::wstring{ extension } == k)
                        {
                            IsExcluded = true;
                            break;
                        }
                    }
                    if (IsExcluded) { continue; }
                    extensions.push_back(std::wstring{ extension });
                }
            }
        }
        catch (...)
        {
        }
    }

    return generatePreviewHandler(PreviewHandlerType::preview,
                                  perUser,
                                  L"{afbd5a44-2520-4ae0-9224-6cfce8fe4400}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.MonacoPreviewHandler.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.PreviewHandler.Monaco.MonacoPreviewHandler",
                                  L"Monaco Preview Handler",
                                  extensions);
}

inline registry::ChangeSet getPdfPreviewHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::preview,
                                  perUser,
                                  L"{07665729-6243-4746-95b7-79579308d1b2}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.PdfPreviewHandler.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.PreviewHandler.Pdf.PdfPreviewHandler",
                                  L"Pdf Preview Handler",
                                  NonLocalizable::ExtPDF);
}

inline registry::ChangeSet getGcodePreviewHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::preview,
                                  perUser,
                                  L"{ec52dea8-7c9f-4130-a77b-1737d0418507}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.GcodePreviewHandler.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.PreviewHandler.Gcode.GcodePreviewHandler",
                                  L"G-code Preview Handler",
                                  NonLocalizable::ExtGCode);
}

inline registry::ChangeSet getSvgThumbnailHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::thumbnail,
                                  perUser,
                                  L"{36B27788-A8BB-4698-A756-DF9F11F64F84}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.SvgThumbnailProvider.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.ThumbnailHandler.Svg.SvgThumbnailProvider",
                                  L"Svg Thumbnail Provider",
                                  NonLocalizable::ExtSVG);
}

inline registry::ChangeSet getPdfThumbnailHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::thumbnail,
                                  perUser,
                                  L"{BCC13D15-9720-4CC4-8371-EA74A274741E}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.PdfThumbnailProvider.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.ThumbnailHandler.Pdf.PdfThumbnailProvider",
                                  L"Pdf Thumbnail Provider",
                                  NonLocalizable::ExtPDF);
}

inline registry::ChangeSet getGcodeThumbnailHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::thumbnail,
                                  perUser,
                                  L"{BFEE99B4-B74D-4348-BCA5-E757029647FF}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.GcodeThumbnailProvider.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.ThumbnailHandler.Gcode.GcodeThumbnailProvider",
                                  L"G-code Thumbnail Provider",
                                  NonLocalizable::ExtGCode);
}

inline registry::ChangeSet getStlThumbnailHandlerChangeSet(const std::wstring installationDir, const bool perUser)
{
    using namespace registry::shellex;
    return generatePreviewHandler(PreviewHandlerType::thumbnail,
                                  perUser,
                                  L"{8BC8AFC2-4E7C-4695-818E-8C1FFDCEA2AF}",
                                  get_std_product_version(),
                                  (fs::path{ installationDir } / LR"d(modules\FileExplorerPreview\PowerToys.StlThumbnailProvider.comhost.dll)d").wstring(),
                                  registry::DOTNET_COMPONENT_CATEGORY_CLSID,
                                  L"Microsoft.PowerToys.ThumbnailHandler.Stl.StlThumbnailProvider",
                                  L"Stl Thumbnail Provider",
                                  NonLocalizable::ExtSTL);
}

inline std::vector<registry::ChangeSet> getAllModulesChangeSets(const std::wstring installationDir)
{
    constexpr bool PER_USER = true;
    return { getSvgPreviewHandlerChangeSet(installationDir, PER_USER),
             getMdPreviewHandlerChangeSet(installationDir, PER_USER),
             getMonacoPreviewHandlerChangeSet(installationDir, PER_USER),
             getPdfPreviewHandlerChangeSet(installationDir, PER_USER),
             getGcodePreviewHandlerChangeSet(installationDir, PER_USER),
             getSvgThumbnailHandlerChangeSet(installationDir, PER_USER),
             getPdfThumbnailHandlerChangeSet(installationDir, PER_USER),
             getGcodeThumbnailHandlerChangeSet(installationDir, PER_USER),
             getStlThumbnailHandlerChangeSet(installationDir, PER_USER) };
}
