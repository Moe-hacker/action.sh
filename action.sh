#!/bin/sh
debug() {
    #
    # $*: debug message
    #
    # print the debug message
    # This need $DEBUG is set.
    if [ "x$DEBUG" = "x" ]; then
        return
    fi
    echo
    if [ "x$*" = "x" ]; then
        echo "\033[33mdebug: \033[0m"
    else
        echo "\033[33m$*\033[0m"
    fi
}
error() {
    #
    # $*: error message
    #
    # print the error message and exit with error
    echo "\033[31m$*\033[0m"
    echo "\033[31mWe got an error, please check the error message above.\033[0m"
    exit 1
}
ok() {
    #
    # $*: ok message
    #
    # print the ok message
    if [ "x$*" = "x" ]; then
        echo "\033[32mok\033[0m"
    else
        echo "\033[32m$*\033[0m"
    fi
}
not_ok() {
    #
    # $*: not ok message
    #
    # print the not ok message
    if [ "x$*" = "x" ]; then
        echo "\033[33mno\033[0m"
    else
        echo "\033[33m$*\033[0m"
    fi
}
info() {
    #
    # $*: info message
    #
    # print the info message
    if [ "x$*" = "x" ]; then
        printf "${BASE_COLOR}info: \033[0m"
    else
        printf "${BASE_COLOR}$*\033[0m"
    fi
}
check_tool() {
    #
    # $1: tool command
    # $2: var name
    #
    # check if the tool is available
    # if not, exit with error
    # for example:
    # check_tool "python3" PYTHON3
    # If $PYTHON3 is set, we will check if $PYTHON3 is available,
    # or if we found command python3, $PYTHON3 will be set to the path of python3
    info "checking for $1: "
    if [ "x$(eval echo \$$2)" = "x" ]; then
        debug "$2 not set"
        if command -v $1 >/dev/null 2>&1; then
            export $2=$(command -v $1)
            ok "$(eval echo \$$2)"
        else
            error "not found"
        fi
    else
        debug "$2 is set to \"$(eval echo \$$2)\""
        if command -v $(eval echo \$$2) >/dev/null 2>&1; then
            ok "$(eval echo \$$2) (as preset by user)"
        else
            error "not found (as preset by user)"
        fi
    fi
    debug "$2 is set to \"$(eval echo \$$2)\""
}
test_and_add_cflag() {
    #
    # $1: compiler
    # $2: flag
    # $3: libs
    # $4: var name
    #
    # check if the compiler supports the flag
    # if true, add the flag to the var name
    # if not, do nothing
    # for example:
    # test_and_add_cflag "${CC}" "-fPIC" $LIBS CFLAGS
    # then if the compiler supports -fPIC, it will be added to CFLAGS
    TEMP_CC="$1"
    TEMP_CFLAG="$2"
    TEMP_LIBS="$3"
    TEMP_VAR="$4"
    info "checking whether the compiler supports $TEMP_CFLAG: "
    debug "LIBS is set to \"$TEMP_LIBS\" and $TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\", check for \"$TEMP_CFLAG\""
    if echo "int main(void){}" | $TEMP_CC $TEMP_CFLAG $(eval echo \$$TEMP_VAR) -x c -o /dev/null - $TEMP_LIBS >/dev/null 2>&1; then
        ok
        export $TEMP_VAR="$(eval echo \$$TEMP_VAR) $TEMP_CFLAG"
    else
        not_ok
    fi
    debug "$TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\""
}
test_and_add_lib() {
    #
    # $1: compiler
    # $2: flag
    # $3: compiler flag
    # $4: var name
    #
    # check if we can link with the flag
    # if true, add the flag to the var name
    # if not, do nothing
    # for example:
    # test_and_add_lib "${CC}" "-lcap" $CFLASG LIBS
    # then if  we can link with -lcap, it will be added to LIBS
    TEMP_CC="$1"
    TEMP_LIB="$2"
    TEMP_CFLAG="$3"
    TEMP_VAR="$4"
    info "checking whether we can link with $TEMP_LIB: "
    debug "$TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\", check for \"$TEMP_LIB\""
    if echo "int main(){}" | $TEMP_CC -x c -o /dev/null - $(eval echo \$$TEMP_VAR) $TEMP_LIB >/dev/null 2>&1; then
        ok
        export $TEMP_VAR="$(eval echo \$$TEMP_VAR) $TEMP_LIB"
    else
        not_ok
    fi
    debug "$TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\""
}
check_and_add_cflag() {
    #
    # $1: compiler
    # $2: flag
    # $3: libs
    # $4: var name
    #
    # Same as test_and_add_cflag, but will exit if the flag is not supported
    TEMP_CC="$1"
    TEMP_CFLAG="$2"
    TEMP_LIBS="$3"
    TEMP_VAR="$4"
    info "checking whether the compiler supports $TEMP_CFLAG: "
    debug "LIBS is set to \"$TEMP_LIBS\" and $TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\", check for \"$TEMP_CFLAG\""
    if echo "int main(void){}" | $TEMP_CC $TEMP_CFLAG $(eval echo \$$TEMP_VAR) -x c -o /dev/null - $TEMP_LIBS >/dev/null 2>&1; then
        ok
        export $TEMP_VAR="$(eval echo \$$TEMP_VAR) $TEMP_CFLAG"
    else
        error "no"
    fi
    debug "$TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\""
}
check_and_add_lib() {
    #
    # $1: compiler
    # $2: flag
    # $3: compiler flag
    # $4: var name
    #
    # same as test_and_add_lib, but will exit if the flag is not supported
    TEMP_CC="$1"
    TEMP_LIB="$2"
    TEMP_CFLAG="$3"
    TEMP_VAR="$4"
    info "checking whether we can link with $TEMP_LIB: "
    debug "$TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\", check for \"$TEMP_LIB\""
    if echo "int main(){}" | $TEMP_CC -x c -o /dev/null - $(eval echo \$$TEMP_VAR) $TEMP_LIB >/dev/null 2>&1; then
        ok
        export $TEMP_VAR="$(eval echo \$$TEMP_VAR) $TEMP_LIB"
    else
        error "no"
    fi
    debug "$TEMP_VAR is set to \"$(eval echo \$$TEMP_VAR)\""
}
check_header() {
    #
    # $1: compiler
    # $2 header
    # $3: CFLAGS
    # $4: LIBS
    #
    # check if the header is available
    # if not, exit with error
    # for example:
    # check_header "stdio.h"
    # if the header is not found, it will exit with error
    TEMP_CC="$1"
    TEMP_HEADER="$2"
    TEMP_CFLAGS="$3"
    TEMP_LIBS="$4"
    # check if the header is available
    info "checking for header <$TEMP_HEADER>: "
    debug "CFLAGS is set to \"$TEMP_CFLAGS\", LIBS is set to \"$TEMP_LIBS\""
    if printf "#include <$TEMP_HEADER>\nint main(){}" | $TEMP_CC -x c -o /dev/null $TEMP_CFLAGS - $TEMP_LIBS >/dev/null 2>&1; then
        ok
    else
        error "no"
    fi
}
builtin_read() {
    #
    # $1: prompt
    # $2: var name
    #
    # read a line from stdin
    # if the line is empty, exit with error
    # for example:
    # builtin_read "Enter your name: "
    # if the user enter nothing, it will exit with error
    printf "$1"
    read LINE
    if [ "x$LINE" = "x" ]; then
        error "no input"
    fi
    export $2="$LINE"
}
git_push() {
    while true; do
        printf "\033[34m[0] show diff\033[0m\n"
        printf "\033[34m[1] push\033[0m\n"
        printf "\033[34m[2] exit\033[0m\n"
        builtin_read "\033[32m> " select
        case $select in
        "0")
            git diff --color=always HEAD
            ;;
        "1")
            printf "\033[34mEnter commit message \033[0m\n"
            builtin_read "\033[32m> " MESSAGE
            git_hook
            if [ $? -ne 0 ]; then
                continue
            fi
            git add .
            git commit -m "$MESSAGE"
            git push
            exit 0
            ;;
        "2")
            exit 0
            ;;
        *)
            echo "Invalid option"
            exit 1
            ;;
        esac
    done
}

. ./function.sh

main() {
    if [ "x$BASE_COLOR" = "x" ]; then
        export BASE_COLOR="\033[38;2;254;228;208m"
    fi
    case $1 in
    "push")
        git_push
        ;;
    "configure")
        shift
        configure $*
        ;;
    "format")
        format
        ;;
    esac

}
# script starts here
main "$@"
return $?
