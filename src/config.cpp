#include "config.h"
#include <any>
#include <hyprland/src/config/ConfigDataValues.hpp>
#include <hyprland/src/plugins/PluginAPI.hpp>
#include <nlohmann/json.hpp>
#include <string>

extern HANDLE PHANDLE;

nlohmann::json loadRawJsonConfig() {
  const auto raw =
      HyprlandAPI::getConfigValue(PHANDLE, "plugin:HyprMonitor:config");

  if (!raw) {
    HyprlandAPI::addNotification(PHANDLE,
                                 "[HyprMonitor] Config not found (nullptr)",
                                 {1, 0, 0, 1}, 10000);
    return {};
  }

  if (!raw->getValue().has_value()) {
    HyprlandAPI::addNotification(PHANDLE,
                                 "[HyprMonitor] Config found but no value set",
                                 {1, 0.5f, 0, 1}, 10000);
    return {};
  }

  try {
    const auto &configStr = std::any_cast<std::string>(raw->getValue());
    HyprlandAPI::addNotification(PHANDLE, "[HyprMonitor] Config string loaded",
                                 {0.6f, 0.9f, 1.0f, 1}, 10000);

    return nlohmann::json::parse(configStr);
  } catch (const std::exception &e) {
    HyprlandAPI::addNotification(
        PHANDLE, "[HyprMonitor] JSON parsing failed: " + std::string(e.what()),
        {1, 0.3f, 0.3f, 1}, 10000);
    return {};
  }
}
