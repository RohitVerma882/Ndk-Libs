set(ZSTD_SRC_DIR "${SRC_DIR}/zstd/lib")
set(ZSTD_OUT_DIR "${OUT_DIR}/zstd")

file(GLOB ZSTD_SRCS "${ZSTD_SRC_DIR}/*/*.c")
file(GLOB_RECURSE ZSTD_HDRS "${ZSTD_SRC_DIR}/*.h")


add_library(zstd STATIC ${ZSTD_SRCS})

target_include_directories(zstd
    PRIVATE
        ${ZSTD_SRC_DIR}/lib/common
    PUBLIC
        ${ZSTD_SRC_DIR}/lib
)

target_compile_definitions(zstd PRIVATE
    -DZSTD_HAVE_WEAK_SYMBOLS=0
    -DZSTD_TRACE=0
)

if(ANDROID_ABI STREQUAL "x86_64")
    target_compile_definitions(zstd PRIVATE -DZSTD_DISABLE_ASM)
endif()

set_target_properties(zstd PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${ZSTD_OUT_DIR}/lib/${ANDROID_ABI}"
)


set(ZSTD_INCLUDE_DIR "${ZSTD_OUT_DIR}/include")
foreach(header ${ZSTD_HDRS})
    file(RELATIVE_PATH relpath "${ZSTD_SRC_DIR}" "${header}")
    set(dest "${ZSTD_INCLUDE_DIR}/${relpath}")
    get_filename_component(dest_dir "${dest}" DIRECTORY)
    file(MAKE_DIRECTORY "${dest_dir}")
    file(COPY "${header}" DESTINATION "${dest_dir}")
endforeach()


if(CMAKE_STRIP AND CMAKE_RANLIB)
    add_custom_command(
        TARGET zstd POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-debug $<TARGET_FILE:zstd>
        COMMAND ${CMAKE_RANLIB} $<TARGET_FILE:zstd>
    )
endif()

configure_file(${ZSTD_SRC_DIR}/../LICENSE ${ZSTD_OUT_DIR}/LICENSE COPYONLY)