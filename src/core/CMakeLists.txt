function(CoreDependencies)
    # NOP
    list(
        APPEND DEPENDENCIES
        # NOP
    )

    set(RESULT_VAR "${DEPENDENCIES}" PARENT_SCOPE)
endfunction()

MakeLibraryTarget(
    NAMESPACE             ${GIRAFFE_NAMESPACE}
    TARGET_NAME           "core"
    LIBRARY_NAME          "${GIRAFFE_SHORT_NAME}_core"
    SOURCES_DIRECTORY     "${CMAKE_CURRENT_LIST_DIR}"
    DEPENDENCIES_FUNCTION CoreDependencies
)
