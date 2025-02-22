add_library(hypr-monitor-plugin SHARED main.cpp)
target_link_libraries(hypr-monitor-plugin PRIVATE fmt::fmt)

