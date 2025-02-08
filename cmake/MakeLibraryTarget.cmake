include_guard(DIRECTORY)

include(Utility)

set(LIB_FOLDER  "Libraries")

function(MakeLibraryTarget)
    # Setup.
    set(
        one_value_args
        NAMESPACE               # Output target alias namespace.
        TARGET_NAME             # Generated target name.
        LIBRARY_NAME            # Output library name.
        DEPENDENCIES_FUNCTION   # Find dependencies hook function.
        SOURCES_DIRECTORY       # Directory containing module source files.
        FORCE_STATIC            # Force this library to be compiled as static.
    )
    cmake_parse_arguments(MakeLibraryTarget "" "${one_value_args}" "" ${ARGN})

    unset(RESULT_VAR)

    message(STATUS ">>> Configuring library: ${MakeLibraryTarget_NAMESPACE}::${MakeLibraryTarget_TARGET_NAME}")
    list(APPEND CMAKE_MESSAGE_INDENT "    ")

    # Find sources.
    get_filename_component(SOURCES_DIRECTORY "${MakeLibraryTarget_SOURCES_DIRECTORY}" ABSOLUTE)
    message(STATUS "Scanning for modules: ${SOURCES_DIRECTORY}")

    file(GLOB_RECURSE MODULE_SOURCES "${MakeLibraryTarget_SOURCES_DIRECTORY}/**.cxx")
    PrintArray("Module sources:" ${MODULE_SOURCES})

    # Deal with dependencies.
    message(STATUS "Discovering dependencies...")
    if(COMMAND ${MakeLibraryTarget_DEPENDENCIES_FUNCTION})
        list(APPEND CMAKE_MESSAGE_INDENT "    ")
        cmake_language(CALL ${MakeLibraryTarget_DEPENDENCIES_FUNCTION})
        list(POP_BACK CMAKE_MESSAGE_INDENT)

        list(APPEND DEPENDENCIES ${RESULT_VAR})
    else()
        message(
            WARNING
            "Argument DEPENDENCIES_FUNCTION not provided or unavailable (current value: "
            "'${MakeLibraryTarget_DEPENDENCIES_FUNCTION}'). If your target requires no "
            "dependencies, you can ignore this."
        )
        list(APPEND DEPENDENCIES)
    endif()
    PrintArray("Discovered dependencies:" "${DEPENDENCIES}")

    message(STATUS "Generating target...")
    set(LIB_NAME      "${MakeLibraryTarget_TARGET_NAME}")
    set(FULL_LIB_NAME "${MakeLibraryTarget_NAMESPACE}::${LIB_NAME}")

    # Create base library.
    add_library(${LIB_NAME})
    target_sources(${LIB_NAME} PUBLIC FILE_SET CXX_MODULES FILES ${MODULE_SOURCES})
    target_link_libraries(${LIB_NAME} ${DEPENDENCIES})

    # Configure properties.
    set_target_properties(${LIB_NAME} PROPERTIES OUTPUT_NAME ${MakeLibraryTarget_LIBRARY_NAME})
    set_target_properties(${LIB_NAME} PROPERTIES FOLDER ${LIB_FOLDER})

    # Add external alias.
    add_library(${FULL_LIB_NAME} ALIAS ${LIB_NAME})
    list(APPEND NEW_TARGETS "${FULL_LIB_NAME}")

    # Wrap up.
    PrintArray("Generated targets:" "${NEW_TARGETS}")

    set(RESULT_VAR "${NEW_TARGETS}" PARENT_SCOPE)
    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
