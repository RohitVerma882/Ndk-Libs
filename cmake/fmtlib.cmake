set(FMTLIB_SRC_DIR "${SRC_DIR}/fmtlib")
set(FMTLIB_OUT_DIR "${OUT_DIR}/fmtlib")


add_library(fmt STATIC ${FMTLIB_SRC_DIR}/src/format.cc)

target_include_directories(fmt PUBLIC ${FMTLIB_SRC_DIR}/include)

target_compile_options(fmt PRIVATE
    -fno-exceptions
    -UNDEBUG
)

set_target_properties(fmt PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${FMTLIB_OUT_DIR}/lib/${ANDROID_ABI}"
)


add_custom_command(
    TARGET fmt POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${FMTLIB_SRC_DIR}/include"
        "${FMTLIB_OUT_DIR}/include"
)

if(CMAKE_STRIP AND CMAKE_RANLIB)
    add_custom_command(
        TARGET fmt POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-debug $<TARGET_FILE:fmt>
        COMMAND ${CMAKE_RANLIB} $<TARGET_FILE:fmt>
    )
endif()

configure_file(${FMTLIB_SRC_DIR}/LICENSE ${FMTLIB_OUT_DIR}/LICENSE COPYONLY)
configure_file(${FMTLIB_SRC_DIR}/NOTICE ${FMTLIB_OUT_DIR}/NOTICE COPYONLY)