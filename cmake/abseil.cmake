set(ABSL_SRC_DIR "${SRC_DIR}/abseil-cpp")
set(ABSL_OUT_DIR "${OUT_DIR}/abseil-cpp")

file(GLOB_RECURSE ABSL_SRCS "${ABSL_SRC_DIR}/absl/*.cc")
file(GLOB_RECURSE ABSL_HDRS "${ABSL_SRC_DIR}/absl/*.h")

set(EXCLUDE_PATTERNS
    "benchmark\\.cc$"
    "benchmarks\\.cc$"
    "_test\\.cc$"
    "_testing\\.cc$"
    "absl/base/spinlock_test_common\\.cc$"
    "absl/hash/internal/print_hash_of\\.cc$"
    "absl/log/internal/test_helpers\\.cc$"
    "absl/log/internal/test_matchers\\.cc$"
    "absl/log/scoped_mock_log\\.cc$"
    "absl/random/internal/gaussian_distribution_gentables\\.cc$"
    "absl/status/internal/status_matchers\\.cc$"
)

set(FILTERED_ABSL_SRCS "")
foreach(src ${ABSL_SRCS})
    set(exclude 0)
    foreach(pat ${EXCLUDE_PATTERNS})
        if(src MATCHES ${pat})
            set(exclude 1)
            break()
        endif()
    endforeach()
    if(NOT exclude)
        list(APPEND FILTERED_ABSL_SRCS "${src}")
    endif()
endforeach()

set(ABSL_SRCS ${FILTERED_ABSL_SRCS} CACHE INTERNAL "Filtered absl sources")


set(ABSL_INCLUDE_DIR "${ABSL_OUT_DIR}/include")
foreach(header ${ABSL_HDRS})
    file(RELATIVE_PATH relpath "${ABSL_SRC_DIR}" "${header}")
    if(relpath MATCHES "/internal/")
        continue()
    endif()
    set(dest "${ABSL_INCLUDE_DIR}/${relpath}")
    get_filename_component(dest_dir "${dest}" DIRECTORY)
    file(MAKE_DIRECTORY "${dest_dir}")
    file(COPY "${header}" DESTINATION "${dest_dir}")
endforeach()


add_library(absl STATIC ${ABSL_SRCS})
target_include_directories(absl
    PRIVATE
        ${ABSL_SRC_DIR}
    PUBLIC
        ${ABSL_INCLUDE_DIR}
)
set_target_properties(absl PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${ABSL_OUT_DIR}/lib/${ANDROID_ABI}"
)


if(CMAKE_STRIP AND CMAKE_RANLIB)
    add_custom_command(
        TARGET absl POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-debug $<TARGET_FILE:absl>
        COMMAND ${CMAKE_RANLIB} $<TARGET_FILE:absl>
    )
endif()

configure_file(${ABSL_SRC_DIR}/LICENSE ${ABSL_OUT_DIR}/LICENSE COPYONLY)