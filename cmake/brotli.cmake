set(BROTLI_SRC_DIR "${SRC_DIR}/brotli/c")
set(BROTLI_OUT_DIR "${OUT_DIR}/brotli")

file(GLOB BROTLI_COMMON_SRCS "${BROTLI_SRC_DIR}/common/*.c")
file(GLOB BROTLI_DEC_SRCS "${BROTLI_SRC_DIR}/dec/*.c")
file(GLOB BROTLI_ENC_SRCS "${BROTLI_SRC_DIR}/enc/*.c")


add_library(brotli STATIC
    ${BROTLI_COMMON_SRCS}
    ${BROTLI_DEC_SRCS}
    ${BROTLI_ENC_SRCS}
)

target_include_directories(brotli PUBLIC ${BROTLI_SRC_DIR}/include)

target_compile_options(brotli PRIVATE -Werror -O2)

target_compile_definitions(brotli PRIVATE
    -DBROTLI_HAVE_LOG2=1
    -DOS_LINUX
)

target_link_libraries(brotli PUBLIC m)

set_target_properties(brotli PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${BROTLI_OUT_DIR}/lib/${ANDROID_ABI}"
)


add_executable(brotli-bin "${BROTLI_SRC_DIR}/tools/brotli.c")
target_link_libraries(brotli-bin PRIVATE brotli)
target_compile_options(brotli-bin PRIVATE -Werror)
set_target_properties(brotli-bin PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${BROTLI_OUT_DIR}/bin/${ANDROID_ABI}"
    OUTPUT_NAME "brotli"
)


add_custom_command(
    TARGET brotli POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${BROTLI_SRC_DIR}/include"
        "${BROTLI_OUT_DIR}/include"
)


if(CMAKE_STRIP AND CMAKE_RANLIB)
    add_custom_command(
        TARGET brotli POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-debug $<TARGET_FILE:brotli>
        COMMAND ${CMAKE_RANLIB} $<TARGET_FILE:brotli>
    )
endif()

if(CMAKE_STRIP)
    add_custom_command(
        TARGET brotli-bin POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-all $<TARGET_FILE:brotli-bin>
    )
endif()

configure_file(${BROTLI_SRC_DIR}/../LICENSE ${BROTLI_OUT_DIR}/LICENSE COPYONLY)