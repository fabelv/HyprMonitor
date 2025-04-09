#include <hyprland/src/config/ConfigDataValues.hpp>
#include <hyprland/src/plugins/PluginAPI.hpp>
#include <hyprland/src/version.h>
#include <hyprlang.hpp>
#include <string>

inline HANDLE PHANDLE = nullptr;

APICALL EXPORT std::string PLUGIN_API_VERSION() { return HYPRLAND_API_VERSION; }

APICALL EXPORT PLUGIN_DESCRIPTION_INFO PLUGIN_INIT(HANDLE handle) {
  PHANDLE = handle;

#ifndef HYPRMONITOR_NO_VERSION_CHECK
  const std::string runtimeHash = __hyprland_api_get_hash();
  const std::string compileHash = GIT_COMMIT_HASH;

  if (runtimeHash != compileHash) {
    HyprlandAPI::addNotification(PHANDLE,
                                 "[HyprMonitor] Plugin version mismatch",
                                 {1.0, 0.2, 0.2, 1.0}, 10000);
    throw std::runtime_error("Plugin version mismatch");
  }
#endif

// Register the config field like hy3
#define CONF(NAME, TYPE, VALUE)                                                \
  HyprlandAPI::addConfigValue(PHANDLE, "plugin:HyprMonitor:" NAME,             \
                              Hyprlang::CConfigValue((TYPE)VALUE))

  using Hyprlang::STRING;
  CONF("config", STRING, "");
#undef CONF

  // Read the registered value using the raw pointer
  const auto val =
      HyprlandAPI::getConfigValue(PHANDLE, "plugin:HyprMonitor:config");
  if (val && val->getDataStaticPtr()) {
    const char *configStr = *(const char **)val->getDataStaticPtr();
    HyprlandAPI::addNotification(
        PHANDLE, "[HyprMonitor] Config: " + std::string(configStr),
        {0.2, 1.0, 0.2, 1.0}, 10000);
  } else {
    HyprlandAPI::addNotification(PHANDLE,
                                 "[HyprMonitor] Config not found or empty",
                                 {1.0, 0.5, 0.0, 1.0}, 10000);
  }

  return {"HyprMonitor", "Debugging plugin config", "Fabio Elvedi", "0.1"};
}

APICALL EXPORT void PLUGIN_EXIT() {
  HyprlandAPI::addNotification(PHANDLE, "[HyprMonitor] Plugin unloaded.",
                               {1, 1, 0, 1}, 10000);
}
