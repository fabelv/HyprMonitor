#include <hyprland/src/plugins/PluginAPI.hpp>
#include <stdexcept>
#include <string>

// Global plugin handle
inline HANDLE PHANDLE = nullptr;
// Mandatory function: returns the API version.
// Do not modify this function.
APICALL EXPORT std::string PLUGIN_API_VERSION() {
    return HYPRLAND_API_VERSION;
}

// Called when the plugin is loaded.
APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
    PHANDLE = handle;

    // Retrieve the runtime hash and the compile-time hash.
    const std::string runtimeHash = __hyprland_api_get_hash();
    const std::string compileHash = GIT_COMMIT_HASH;

    // Notify user with both hash values.
    HyprlandAPI::addNotification(PHANDLE,
        "[HyprMonitor] PLUGIN_INIT executed!\n"
        "Compile hash: " + compileHash + "\n"
        "Runtime hash: " + runtimeHash,
        CHyprColor{0.0f, 1.0f, 1.0f, 1.0f},
        5000
    );

    // Version check
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

    return {"HyprMonitor", "A simple test plugin to verify the dev setup.", "Fabio Elvedi", "1.0"};
}


// Called when the plugin is unloaded.
APICALL EXPORT void PLUGIN_EXIT() {
    // Notify that the plugin is being unloaded.
    HyprlandAPI::addNotification(PHANDLE,
        "[HyprMonitor] Plugin unloaded.",
        CHyprColor{1.0f, 1.0f, 0.0f, 1.0f},
        3000
    );
}
