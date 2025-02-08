include_guard(DIRECTORY)

function(__internalDefineOptions)
    # Generic CMake options.
    option(BUILD_SHARED_LIBS     "Build Giraffe as a shared library"             ON)

    # Giraffe specific options.
    option(${NS}_ENABLE_EXAMPLES "Build examples for usage of Giraffe"           ON)
    option(${NS}_ENABLE_DOCS     "Build documentation for Giraffe using Doxygen" ON)
    option(${NS}_ENABLE_TESTS    "Build unit tests for Giraffe."                 ON)
endfunction()

function(ConfigureOptions)
    __internalDefineOptions()
endfunction()
