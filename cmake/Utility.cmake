include_guard(DIRECTORY)

function(PrintArray MESSAGE ARRAY)
    message(STATUS "${MESSAGE}")
    list(APPEND CMAKE_MESSAGE_INDENT "  ")

    if(ARRAY)
        foreach(ELEMENT ${ARRAY})
            message(STATUS "- ${ELEMENT}")
        endforeach()
    else()
        message(STATUS "<empty>")
    endif()

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endfunction()
