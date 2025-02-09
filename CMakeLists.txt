cmake_minimum_required(VERSION 3.30)

# Allow including of local CMake modules.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(Version)
set(VERSION_JSON "${CMAKE_CURRENT_SOURCE_DIR}/version.json")
FetchCMakeFriendlyVersion()
set(TARGET_VERSION "${RESULT_VAR}")

# https://cmake.org/files/v3.30/cmake-3.30.5.tar.gz

# For import std; support - from CMake 3.30.5 Help/dev/experimental.rst
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "0e5b6991-d74f-4b3d-a41c-cf096e0b2508")
# For automatic package dependencies support - from CMake 3.30.5 Help/dev/experimental.rst
set(CMAKE_EXPERIMENTAL_EXPORT_PACKAGE_DEPENDENCIES "1942b4fa-b2c5-4546-9385-83f254070067")

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
include(SetupInstall)

# Setup project options.
ConfigureOptions()

# Call Giraffe components.
add_subdirectory(src/core)
add_subdirectory(src/testing)

# Install
InstallAll(
    TARGETS "Giraffe::core;Giraffe::testing"
    EXPORT_NAME "${GIRAFFE_NAME}-targets"
    NAMESPACE "${GIRAFFE_NAMESPACE}"
    CONFIG_TEMPLATE "${PROJECT_SOURCE_DIR}/cmake/templates/GiraffeConfig.cmake.in"
)
