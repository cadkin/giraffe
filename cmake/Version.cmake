include_guard(DIRECTORY)

function(__internalFetchVersion ${VERSION_JSON})
    file(READ "${VERSION_JSON}" JSON_STR)

    string(JSON MAJOR  GET ${JSON_STR} "major")
    string(JSON MINOR  GET ${JSON_STR} "minor")
    string(JSON PATCH  GET ${JSON_STR} "patch")
    string(JSON SUFFIX GET ${JSON_STR} "suffix")

    string(SUBSTRING "${SUFFIX}" 0 1 SUFFIX_SHORT)

    set(MAJOR  "${MAJOR}"  PARENT_SCOPE)
    set(MINOR  "${MINOR}"  PARENT_SCOPE)
    set(PATCH  "${PATCH}"  PARENT_SCOPE)
    set(SUFFIX "${SUFFIX}" PARENT_SCOPE)

    set(SUFFIX_SHORT "${SUFFIX_SHORT}" PARENT_SCOPE)
endfunction()

function(FetchCMakeFriendlyVersion)
    set(one_value_args VERSION_JSON)
    cmake_parse_arguments(FetchCMakeFriendlyVersion "" "${one_value_args}" "" ${ARGN})

    __internalFetchVersion("${FetchCMakeFriendlyVersion_VERSION_JSON}")

    set(VERSION "${MAJOR}.${MINOR}.${PATCH}.${SUFFIX}")
    set(CMAKE_FRIENDLY_VERSION "${MAJOR}.${MINOR}.${PATCH}")

    message(STATUS "Version: ${VERSION}")
    message(STATUS "CMake friendly version: ${CMAKE_FRIENDLY_VERSION}")

    set(RESULT_VAR "${CMAKE_FRIENDLY_VERSION}" PARENT_SCOPE)
endfunction()

function(FetchApiVersion)
    set(one_value_args VERSION_JSON)
    cmake_parse_arguments(FetchApiVersion "" "${one_value_args}" "" ${ARGN})

    __internalFetchVersion("${FetchApiVersion_VERSION_JSON}")

    set(API_VERSION "v${MAJOR}${MINOR}${SUFFIX_SHORT}")
    message(STATUS "API version: ${API_VERSION}")

    set(RESULT_VAR "${API_VERSION}" PARENT_SCOPE)
endfunction()
