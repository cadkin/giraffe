include_guard(DIRECTORY)

include(Utility)

set(EXEC_FOLDER "Executables")

function(MakeExecutableTarget)
    # Setup.
    set(
        one_value_args
        NAMESPACE               # Output target alias namespace.
        TARGET_NAME             # Generated target name.
        EXECUTABLE_NAME         # Output executable name.
        DEPENDENCIES_FUNCTION   # Find dependencies hook function.
        SOURCES_DIRECTORY       # Directory containing module source files.
    )
    cmake_parse_arguments(MakeExecutableTarget "" "${one_value_args}" "" ${ARGN})

    unset(RESULT_VAR)

    message(STATUS ">>> Configuring executable: ${MakeExecutableTarget_NAMESPACE}::${MakeExecutableTarget_TARGET_NAME}")
    list(APPEND CMAKE_MESSAGE_INDENT "    ")

    # Find sources.
    get_filename_component(SOURCES_DIRECTORY "${MakeExecutableTarget_SOURCES_DIRECTORY}" ABSOLUTE)
    message(STATUS "Scanning for modules: ${SOURCES_DIRECTORY}")

    file(GLOB_RECURSE MODULE_SOURCES "${MakeExecutableTarget_SOURCES_DIRECTORY}/**.cxx")
    PrintArray("Module sources:" ${MODULE_SOURCES})

    # Deal with dependencies.
    message(STATUS "Discovering dependencies...")
    if(COMMAND ${MakeExecutableTarget_DEPENDENCIES_FUNCTION})
        list(APPEND CMAKE_MESSAGE_INDENT "    ")
        cmake_language(CALL ${MakeExecutableTarget_DEPENDENCIES_FUNCTION})
        list(POP_BACK CMAKE_MESSAGE_INDENT)

        list(APPEND DEPENDENCIES ${RESULT_VAR})
    else()
        message(
            WARNING
            "Argument DEPENDENCIES_FUNCTION not provided or unavailable (current value: "
            "'${MakeExecutableTarget_DEPENDENCIES_FUNCTION}'). If your target requires no "
            "dependencies, you can ignore this."
        )
        list(APPEND DEPENDENCIES)
    endif()
    PrintArray("Discovered dependencies:" "${DEPENDENCIES}")

    message(STATUS "Generating target...")
    set(EXEC_NAME      "${MakeExecutableTarget_TARGET_NAME}")
    set(FULL_EXEC_NAME "${MakeExecutableTarget_NAMESPACE}::${EXEC_NAME}")

    # Create executable.
    add_executable(${EXEC_NAME})
    target_sources(${EXEC_NAME} PUBLIC FILE_SET CXX_MODULES FILES ${MODULE_SOURCES})
    target_link_libraries(${EXEC_NAME} ${DEPENDENCIES})

    # Configure properties.
    set_target_properties(${EXEC_NAME} PROPERTIES OUTPUT_NAME ${MakeExecutableTarget_EXECUTABLE_NAME})
    set_target_properties(${EXEC_NAME} PROPERTIES FOLDER ${EXEC_FOLDER})

    # Add external alias.
    add_executable(${FULL_EXEC_NAME} ALIAS ${EXEC_NAME})
    list(APPEND NEW_TARGETS "${FULL_EXEC_NAME}")

    # Wrap up.
    PrintArray("Generated targets:" "${NEW_TARGETS}")

    set(RESULT_VAR "${NEW_TARGETS}" PARENT_SCOPE)
    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
