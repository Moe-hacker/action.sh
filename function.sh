init() {
    check_tool "cc" "CC"
    check_tool "strip" "STRIP"
}
default_cflags() {
    test_and_add_cflag "${CC}" "-ftrivial-auto-var-init=pattern" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fcf-protection=full" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-flto=auto" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fPIE" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-pie" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,-z,relro" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,-z,noexecstack" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,-z,now" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fstack-protector-all" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fstack-clash-protection" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-mshstk" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wno-unused-result" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-O2" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,--build-id=sha1" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-ffunction-sections" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fdata-sections" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,--gc-sections" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,--strip-all" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,--disable-new-dtags" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3 -D_FILE_OFFSET_BITS=64" "${LIBS}" CFLAGS
}
check_libs() {
    test_and_add_lib "${CC}" "-lpthread" "${LIBS}" LIBS
    check_and_add_lib "${CC}" "-lseccomp" "${LIBS}" LIBS
    test_and_add_lib "${CC}" "-lcap" "${LIBS}" LIBS
}
configure(){
    init
    default_cflags
    check_libs
    echo "CFLAGS: ${CFLAGS}"
    echo "LIBS: ${LIBS}"
}