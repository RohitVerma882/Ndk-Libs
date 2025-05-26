set(LIBUSB_SRC_DIR "${SRC_DIR}/libusb")
set(LIBUSB_OUT_DIR "${OUT_DIR}/libusb")


add_library(usb STATIC
    ${LIBUSB_SRC_DIR}/libusb/core.c
    ${LIBUSB_SRC_DIR}/libusb/descriptor.c
    ${LIBUSB_SRC_DIR}/libusb/hotplug.c
    ${LIBUSB_SRC_DIR}/libusb/io.c
    ${LIBUSB_SRC_DIR}/libusb/sync.c
    ${LIBUSB_SRC_DIR}/libusb/strerror.c
    ${LIBUSB_SRC_DIR}/libusb/os/linux_usbfs.c
    ${LIBUSB_SRC_DIR}/libusb/os/events_posix.c
    ${LIBUSB_SRC_DIR}/libusb/os/threads_posix.c
    ${LIBUSB_SRC_DIR}/libusb/os/linux_netlink.c
)

target_include_directories(usb
    PRIVATE
        ${LIBUSB_SRC_DIR}/libusb/os
        ${LIBUSB_SRC_DIR}/linux
    PUBLIC
        ${LIBUSB_SRC_DIR}
        ${LIBUSB_SRC_DIR}/libusb 
)

target_compile_definitions(usb PRIVATE
    -DENABLE_LOGGING=1
)

target_compile_options(usb PRIVATE
    -std=gnu11
    -Wall
    -Wextra
    -Wshadow
    -Wunused
    -Wwrite-strings
    -Werror=format-security
    -Werror=implicit-function-declaration
    -Werror=implicit-int
    -Werror=init-self
    -Werror=missing-prototypes
    -Werror=strict-prototypes
    -Werror=undef
    -Werror=uninitialized
)

target_link_libraries(usb PUBLIC log)

set_target_properties(usb PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LIBUSB_OUT_DIR}/lib/${ANDROID_ABI}"
)


file(GLOB_RECURSE LIBUSB_HDRS "${LIBUSB_SRC_DIR}/libusb/*.h")
set(LIBUSB_INCLUDE_DIR "${LIBUSB_OUT_DIR}/include")
foreach(header ${LIBUSB_HDRS})
    file(RELATIVE_PATH relpath "${LIBUSB_SRC_DIR}" "${header}")
    if(relpath MATCHES "/os/")
        continue()
    endif()
    set(dest "${LIBUSB_INCLUDE_DIR}/${relpath}")
    get_filename_component(dest_dir "${dest}" DIRECTORY)
    file(MAKE_DIRECTORY "${dest_dir}")
    file(COPY "${header}" DESTINATION "${dest_dir}")
endforeach()


if(CMAKE_STRIP AND CMAKE_RANLIB)
    add_custom_command(
        TARGET usb POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-debug $<TARGET_FILE:usb>
        COMMAND ${CMAKE_RANLIB} $<TARGET_FILE:usb>
    )
endif()

configure_file(${LIBUSB_SRC_DIR}/NOTICE ${LIBUSB_OUT_DIR}/NOTICE COPYONLY)