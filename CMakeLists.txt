cmake_minimum_required(VERSION 3.30)

# Allow including of local CMake modules.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(Version)
set(VERSION_JSON "${CMAKE_CURRENT_SOURCE_DIR}/version.json")
FetchCMakeFriendlyVersion()
set(TARGET_VERSION "${RESULT_VAR}")

# From CMake 3.30.5 Help/dev/experimental.rst
# https://cmake.org/files/v3.30/cmake-3.30.5.tar.gz
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")

project(
    Giraffe
    LANGUAGES CXX
    VERSION ${TARGET_VERSION}
    DESCRIPTION "An experimental graph library taking full advantage of proposed C++26 features"
    HOMEPAGE_URL "https://github.com/cadkin/giraffe"
)

# Some names and aliases.
set(GIRAFFE_NAME        ${PROJECT_NAME})
set(GIRAFFE_SHORT_NAME  "gir")
set(GIRAFFE_NAMESPACE   "${GIRAFFE_NAME}")
set(GIRAFFE_EXEC_PREFIX "${GIRAFFE_SHORT_NAME}")

set(NS "${GIRAFFE_NAMESPACE}")

# Configure project standards.
set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_MODULE_STD ON)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)

# Include required CMake modules.
include(Options)
include(MakeLibraryTarget)
include(MakeExecutableTarget)

# Setup project options.
ConfigureOptions()

# Call Giraffe components.
add_subdirectory(src/core)
add_subdirectory(src/testing)
