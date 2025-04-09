#pragma once

#include <nlohmann/json.hpp>
#include <string>
#include <unordered_map>
#include <vector>

struct MonitorInfo {
  std::string serial;
  std::string make;
  std::string model;
};

struct Setup {
  std::vector<std::string> match;
  std::vector<std::string> configLines;
};

struct HyprMonitorConfig {
  std::unordered_map<std::string, MonitorInfo> monitors;
  std::unordered_map<std::string, Setup> setups;
};

// Parses the raw JSON string from the Hyprland config
nlohmann::json loadRawJsonConfig();
