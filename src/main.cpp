#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/config/ConfigDataValues.hpp>
#include <stdexcept>
#include <string>

inline HANDLE PHANDLE = nullptr;

APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    // Retrieve and verify runtime hash
    const std::string runtimeHash = __hyprland_api_get_hash();
    const std::string compileHash = GIT_COMMIT_HASH;

    HyprlandAPI::addNotification(PHANDLE,
        "[HyprMonitor] PLUGIN_INIT executed!\n"
        "Compile hash: " + compileHash + "\n"
        "Runtime hash: " + runtimeHash,
        CHyprColor{0.0f, 1.0f, 1.0f, 1.0f},
        5000
    );

    if (runtimeHash != compileHash) {
        HyprlandAPI::addNotification(PHANDLE,
            "[HyprMonitor] Mismatched headers! Can't proceed.\n"
            "Compile hash: " + compileHash + "\n"
            "Runtime hash: " + runtimeHash,
            CHyprColor{1.0f, 0.2f, 0.2f, 1.0f},
            5000
        );
        throw std::runtime_error("[HyprMonitor] Version mismatch\n"
                                 "Compile hash: " + compileHash + "\n"
                                 "Runtime hash: " + runtimeHash);
    }

    // Define a test config variable
    HyprlandAPI::addConfigValue(PHANDLE, "plugin:HyprMonitor:test", Hyprlang::CConfigValue((Hyprlang::INT) 0));

    // Retrieve the config value
    auto testValue = HyprlandAPI::getConfigValue(PHANDLE, "plugin:HyprMonitor:test");

    // Parse the value safely
    int testInt = -1; // Default fallback
    if (testValue && testValue->getValue().has_value()) {
        try {
            testInt = std::any_cast<int>(testValue->getValue());
        } catch (const std::bad_any_cast& e) {
            HyprlandAPI::addNotification(PHANDLE,
                "[HyprMonitor] Failed to cast 'test' config value: " + std::string(e.what()),
                CHyprColor{1.0f, 0.2f, 0.2f, 1.0f},
                10000
            );
        }
    }

    // Display the retrieved value
    HyprlandAPI::addNotification(PHANDLE,
        "[HyprMonitor] Config value: test = " + std::to_string(testInt),
        CHyprColor{0.5f, 1.0f, 0.5f, 1.0f},
        10000
    );

    return {"HyprMonitor", "A simple test plugin to verify the dev setup.", "Fabio Elvedi", "1.0"};
}

APICALL EXPORT void PLUGIN_EXIT() {
    HyprlandAPI::addNotification(PHANDLE,
        "[HyprMonitor] Plugin unloaded.",
        CHyprColor{1.0f, 1.0f, 0.0f, 1.0f},
        3000
    );
}

