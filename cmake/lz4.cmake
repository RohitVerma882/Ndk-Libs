set(LZ4_SRC_DIR "${SRC_DIR}/lz4/lib")
set(LZ4_OUT_DIR "${OUT_DIR}/lz4")

add_library(lz4 STATIC
    "${LZ4_SRC_DIR}/lz4.c"
    "${LZ4_SRC_DIR}/lz4hc.c"
    "${LZ4_SRC_DIR}/lz4frame.c"
    "${LZ4_SRC_DIR}/lz4frame_static.h"
    "${LZ4_SRC_DIR}/xxhash.c"
)

target_include_directories(lz4 PUBLIC ${LZ4_SRC_DIR})

target_compile_options(lz4 PRIVATE -Wall -Werror)

set_target_properties(lz4 PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LZ4_OUT_DIR}/lib/${ANDROID_ABI}"
)

file(GLOB_RECURSE LZ4_HDRS "${LZ4_SRC_DIR}/*.h")
set(LZ4_INCLUDE_DIR "${LZ4_OUT_DIR}/include")
foreach(header ${LZ4_HDRS})
    file(RELATIVE_PATH relpath "${LZ4_SRC_DIR}" "${header}")
    set(dest "${LZ4_INCLUDE_DIR}/${relpath}")
    get_filename_component(dest_dir "${dest}" DIRECTORY)
    file(MAKE_DIRECTORY "${dest_dir}")
    file(COPY "${header}" DESTINATION "${dest_dir}")
endforeach()

if(CMAKE_STRIP AND CMAKE_RANLIB)
    add_custom_command(
        TARGET lz4 POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-debug $<TARGET_FILE:lz4>
        COMMAND ${CMAKE_RANLIB} $<TARGET_FILE:lz4>
    )
endif()

configure_file(${LZ4_SRC_DIR}/LICENSE ${LZ4_OUT_DIR}/LICENSE COPYONLY)