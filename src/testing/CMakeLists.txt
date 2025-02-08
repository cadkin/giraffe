function(TestingDependencies)
    list(
        APPEND DEPENDENCIES
        Giraffe::core
    )

    set(RESULT_VAR "${DEPENDENCIES}" PARENT_SCOPE)
endfunction()

MakeExecutableTarget(
    NAMESPACE             ${GIRAFFE_NAMESPACE}
    TARGET_NAME           "testing"
    EXECUTABLE_NAME       "${GIRAFFE_SHORT_NAME}_testing"
    SOURCES_DIRECTORY     "${CMAKE_CURRENT_LIST_DIR}"
    DEPENDENCIES_FUNCTION TestingDependencies
)
