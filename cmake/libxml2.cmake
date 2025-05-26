set(LIBXML2_SRC_DIR "${SRC_DIR}/libxml2")
set(LIBXML2_OUT_DIR "${OUT_DIR}/libxml2")


add_library(xml2 STATIC
    ${LIBXML2_SRC_DIR}/SAX2.c
    ${LIBXML2_SRC_DIR}/buf.c
    ${LIBXML2_SRC_DIR}/c14n.c
    ${LIBXML2_SRC_DIR}/catalog.c
    ${LIBXML2_SRC_DIR}/chvalid.c
    ${LIBXML2_SRC_DIR}/debugXML.c
    ${LIBXML2_SRC_DIR}/dict.c
    ${LIBXML2_SRC_DIR}/encoding.c
    ${LIBXML2_SRC_DIR}/entities.c
    ${LIBXML2_SRC_DIR}/error.c
    ${LIBXML2_SRC_DIR}/globals.c
    ${LIBXML2_SRC_DIR}/hash.c
    ${LIBXML2_SRC_DIR}/legacy.c
    ${LIBXML2_SRC_DIR}/list.c
    ${LIBXML2_SRC_DIR}/parser.c
    ${LIBXML2_SRC_DIR}/parserInternals.c
    ${LIBXML2_SRC_DIR}/pattern.c
    ${LIBXML2_SRC_DIR}/relaxng.c
    ${LIBXML2_SRC_DIR}/schematron.c
    ${LIBXML2_SRC_DIR}/threads.c
    ${LIBXML2_SRC_DIR}/tree.c
    ${LIBXML2_SRC_DIR}/uri.c
    ${LIBXML2_SRC_DIR}/valid.c
    ${LIBXML2_SRC_DIR}/xinclude.c
    ${LIBXML2_SRC_DIR}/xlink.c
    ${LIBXML2_SRC_DIR}/xmlIO.c
    ${LIBXML2_SRC_DIR}/xmlmemory.c
    ${LIBXML2_SRC_DIR}/xmlmodule.c
    ${LIBXML2_SRC_DIR}/xmlreader.c
    ${LIBXML2_SRC_DIR}/xmlregexp.c
    ${LIBXML2_SRC_DIR}/xmlsave.c
    ${LIBXML2_SRC_DIR}/xmlschemas.c
    ${LIBXML2_SRC_DIR}/xmlschemastypes.c
    ${LIBXML2_SRC_DIR}/xmlstring.c
    ${LIBXML2_SRC_DIR}/xmlunicode.c
    ${LIBXML2_SRC_DIR}/xmlwriter.c
    ${LIBXML2_SRC_DIR}/xpath.c
    ${LIBXML2_SRC_DIR}/xpointer.c
)

target_compile_definitions(xml2 PRIVATE
    -DSTATIC_LIBXML=1
)

target_compile_options(xml2 PRIVATE
    -Wall
    -Werror
    -Wno-error=ignored-attributes
    -Wno-missing-field-initializers
    -Wno-self-assign
    -Wno-sign-compare
    -Wno-tautological-pointer-compare
    -Wno-unused-function
    -Wno-unused-parameter
    -fvisibility=hidden
)

target_include_directories(xml2 PUBLIC ${LIBXML2_SRC_DIR}/include)

target_link_libraries(xml2 PUBLIC m z)

set_target_properties(xml2 PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${LIBXML2_OUT_DIR}/lib/${ANDROID_ABI}"
)


file(GLOB_RECURSE LIBXML2_HDRS "${LIBXML2_SRC_DIR}/include/*.h")
set(LIBXML2_INCLUDE_DIR "${LIBXML2_OUT_DIR}/include")
foreach(header ${LIBXML2_HDRS})
    file(RELATIVE_PATH relpath "${LIBXML2_SRC_DIR}" "${header}")
    if(relpath MATCHES "/private/")
        continue()
    endif()
    set(dest "${LIBXML2_INCLUDE_DIR}/${relpath}")
    get_filename_component(dest_dir "${dest}" DIRECTORY)
    file(MAKE_DIRECTORY "${dest_dir}")
    file(COPY "${header}" DESTINATION "${dest_dir}")
endforeach()


if(CMAKE_STRIP AND CMAKE_RANLIB)
    add_custom_command(
        TARGET xml2 POST_BUILD
        COMMAND ${CMAKE_STRIP} --strip-debug $<TARGET_FILE:xml2>
        COMMAND ${CMAKE_RANLIB} $<TARGET_FILE:xml2>
    )
endif()