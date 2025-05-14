__init() {
    check_tool "cc" "CC"
    check_tool "strip" "STRIP"
    if [ -e ".git" ]; then
        check_tool "git" "GIT"
    fi
}
__default_cflags() {
    check_and_add_cflag "${CC}" "-std=gnu11" "${LIBS}" CFLAGS
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
__dev_cflags() {
    check_and_add_cflag "${CC}" "-std=gnu11" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-g" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-O0" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fno-omit-frame-pointer" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,-z,norelro" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,-z,execstack" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fno-stack-protector" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wall" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wextra" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-pedantic" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wconversion" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wno-newline-eof" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wno-gnu-zero-variadic-macro-arguments" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fsanitize=address" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,--build-id=sha1" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-ffunction-sections" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-fdata-sections" "${LIBS}" CFLAGS
    test_and_add_cflag "${CC}" "-Wl,--gc-sections" "${LIBS}" CFLAGS
}
__check_libs() {
    test_and_add_lib "${CC}" "-lpthread" "${LIBS}" LIBS
    check_and_add_lib "${CC}" "-lseccomp" "${LIBS}" LIBS
    test_and_add_lib "${CC}" "-lcap" "${LIBS}" LIBS
}

format() {
    info "run shfmt for shell scripts\n"
    shfmt -w -i 4 *.sh
}
git_hook() {
    format
    builtin_read "\033[32mReally? (y/n) \033[0m" DOIT
    if [ "x$DOIT" != "xy" ]; then
        return 1
    fi
    return 0
}
configure() {
    __init
    __default_cflags
    __dev_cflags
    __check_libs
    echo "CFLAGS: ${CFLAGS}"
    echo "LIBS: ${LIBS}"
}
