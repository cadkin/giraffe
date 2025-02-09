include_guard(DIRECTORY)

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

function(__internalInstallVersion)
    set(one_value_args NAMESPACE)
    cmake_parse_arguments(InstallVersion "" "${one_value_args}" "" ${ARGN})

    string(TOLOWER ${InstallVersion_NAMESPACE} INSTALL_SUBDIR)

    set(CONFIG_FILE "${CMAKE_CURRENT_BINARY_DIR}/${InstallVersion_NAMESPACE}ConfigVersion.cmake")

    write_basic_package_version_file(
        ${CONFIG_FILE}
        COMPATIBILITY AnyNewerVersion
    )

    install(
        FILES ${CONFIG_FILE}
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${INSTALL_SUBDIR}
    )
endfunction()

function(__internalInstallTargets)
    set(one_value_args EXPORT_NAME NAMESPACE)
    set(multi_value_args TARGETS)
    cmake_parse_arguments(InstallTargets "" "${one_value_args}" "${multi_value_args}" ${ARGN})

    string(TOLOWER ${InstallTargets_NAMESPACE} INSTALL_SUBDIR)

    foreach(TARGET ${InstallTargets_TARGETS})
        get_target_property(TARGET_ALIAS ${TARGET} ALIASED_TARGET)
        if(TARGET_ALIAS)
            set(TARGET ${TARGET_ALIAS})
        endif()

        get_target_property(TARGET_TYPE ${TARGET} TYPE)
        if(TARGET_TYPE STREQUAL "EXECUTABLE")
            message(STATUS "Making installable export for executable - ${TARGET}")

            install(
                TARGETS ${TARGET}
                EXPORT ${InstallTargets_EXPORT_NAME}
            )
        elseif((TARGET_TYPE STREQUAL "SHARED_LIBRARY") OR (TARGET_TYPE STREQUAL "STATIC_LIBRARY"))
            message(STATUS "Making installable export for library - ${TARGET}")

            # Make installable.
            install(
                TARGETS ${TARGET}
                EXPORT ${InstallTargets_EXPORT_NAME}
                FILE_SET CXX_MODULES DESTINATION ${CMAKE_INSTALL_LIBDIR}/${INSTALL_SUBDIR}/cxx
                CXX_MODULES_BMI DESTINATION ${CMAKE_INSTALL_LIBDIR}/${INSTALL_SUBDIR}/bmi
            )

            install(
                EXPORT ${InstallTargets_EXPORT_NAME}
                FILE ${InstallTargets_NAMESPACE}-${TARGET}-targets.cmake
                NAMESPACE ${InstallTargets_NAMESPACE}::
                DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${INSTALL_SUBDIR}
                CXX_MODULES_DIRECTORY cxx
            )
        else()
            message(WARNING "Skipping installable for unsupported target type - ${TARGET}")
        endif()
    endforeach()
endfunction()

function(__internalInstallExports)
    set(one_value_args EXPORT_NAME NAMESPACE CONFIG_TEMPLATE)
    cmake_parse_arguments(InstallExports "" "${one_value_args}" "" ${ARGN})

    string(TOLOWER ${InstallExports_NAMESPACE} INSTALL_SUBDIR)

    install(
        EXPORT ${InstallExports_EXPORT_NAME}
        NAMESPACE ${InstallExports_NAMESPACE}::
        DESTINATION lib/cmake/${INSTALL_SUBDIR}
        EXPORT_PACKAGE_DEPENDENCIES
    )

    set(CONFIG_FILE "${CMAKE_CURRENT_BINARY_DIR}/${InstallExports_NAMESPACE}Config.cmake")

    configure_package_config_file(
        ${InstallExports_CONFIG_TEMPLATE} ${CONFIG_FILE}
        INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${INSTALL_SUBDIR}
    )

    install(
        FILES ${CONFIG_FILE}
        DESTINATION lib/cmake/${INSTALL_SUBDIR}
    )
endfunction()

function(InstallAll)
    set(one_value_args EXPORT_NAME NAMESPACE CONFIG_TEMPLATE)
    set(multi_value_args TARGETS)
    cmake_parse_arguments(InstallAll "" "${one_value_args}" "${multi_value_args}" ${ARGN})

    message(STATUS "Creating installable version information.")
    __internalInstallVersion(
        NAMESPACE "${InstallAll_NAMESPACE}"
    )

    message(STATUS "Creating installable target configurations.")
    list(APPEND CMAKE_MESSAGE_INDENT "    ")
    __internalInstallTargets(
        TARGETS ${InstallAll_TARGETS}
        EXPORT_NAME ${InstallAll_EXPORT_NAME}
        NAMESPACE ${InstallAll_NAMESPACE}
    )
    list(POP_BACK CMAKE_MESSAGE_INDENT)

    message(STATUS "Creating installable export.")
    __internalInstallExports(
        EXPORT_NAME ${InstallAll_EXPORT_NAME}
        NAMESPACE ${InstallAll_NAMESPACE}
        CONFIG_TEMPLATE ${InstallAll_CONFIG_TEMPLATE}
    )
endfunction()
