function(TestingDependencies)
    find_package(Qt6 REQUIRED COMPONENTS Core Widgets Gui)

    list(
        APPEND DEPENDENCIES
        Giraffe::core
        Qt6::Core
        Qt6::Widgets
        Qt6::Gui
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
