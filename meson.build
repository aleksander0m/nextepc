# Copyright (C) 2019 by Sukchan Lee <acetcom@gmail.com>

# This file is part of Open5GS.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

project('open5gs', 'c',
    version : '1.0.0',
    license : 'AGPL-3.0-or-later',
    meson_version : '>= 0.51',
    default_options : [
        'warning_level=1',
        'c_std=gnu89',
        'prefix=/usr',
        'sysconfdir=/etc',
        'localstatedir=/var',
    ],
)

conf = configuration_data()
conf.set_quoted('PROJECT_VERSION', meson.project_version())

# join_paths ignores the preceding arguments if an absolute component is
# encountered, so this should canonicalize various paths when they are
# absolute or relative.
prefixdir = get_option('prefix')
if not prefixdir.startswith('/')
        error('Prefix is not absolute: "@0@"'.format(prefixdir))
endif
bindir = join_paths(prefixdir, get_option('bindir'))
libdir = join_paths(prefixdir, get_option('libdir'))
sysconfdir = join_paths(prefixdir, get_option('sysconfdir'))
includedir = join_paths(prefixdir, get_option('includedir'))
datadir = join_paths(prefixdir, get_option('datadir'))
localstatedir = join_paths('/', get_option('localstatedir'))

pkgconfig = import('pkgconfig')
cmake = import('cmake')

cc = meson.get_compiler('c')
host_system = host_machine.system()

# Compiler flags
if cc.get_id() == 'gcc' or cc.get_id() == 'clang'
    possible_cc_flags = [
        '-Wextra',
        '-Wlogical-op',
        '-Werror=missing-include-dirs',
        '-Werror=pointer-arith',
        '-Werror=init-self',
        '-Wfloat-equal',
        ## core: '-Wsuggest-attribute=noreturn',
        ## core: '-Werror=missing-prototypes',
        '-Werror=implicit-function-declaration',
        ## core: '-Werror=missing-declarations',
        '-Werror=return-type',
        '-Werror=incompatible-pointer-types',
        '-Werror=format=2',
        '-Wstrict-prototypes',
        '-Wredundant-decls',
        ## asn1c: '-Wimplicit-fallthrough=5',
        '-Wendif-labels',
        '-Wstrict-aliasing=2',
        '-Wwrite-strings',
        '-Werror=overflow',
        '-Werror=shift-count-overflow',
        '-Werror=shift-overflow=2',
        '-Wdate-time',
        '-Wnested-externs',
        '-Wunused',
        '-Wduplicated-branches',
        '-Wmisleading-indentation',

        '-Wno-sign-compare',
        '-Wno-unused-parameter',
        '-Wno-missing-field-initializers', ## for asn1c

        '-ffast-math',
        '-fdiagnostics-show-option',
        ## TODO : '-fvisibility=hidden',
        '-fstack-protector',
        '-fstack-protector-strong',
        '--param=ssp-buffer-size=4',
    ]
    # --as-needed and --no-undefined are provided by meson by default,
    # run mesonconf to see what is enabled
    possible_link_flags = [
        '-Wl,-z,relro',
        '-Wl,-z,now',
        '-Wl,-z,nodelete',
    ]
    if cc.get_id() == 'clang'
        possible_cc_flags += [
            '-Wno-typedef-redefinition',
            '-Wno-gnu-variable-sized-type-not-at-end',
        ]
    endif

    if get_option('buildtype') != 'debug'
        possible_cc_flags += [
            '-ffunction-sections',
            '-fdata-sections',
        ]

        possible_link_flags += '-Wl,--gc-sections'
    endif
else
    possible_cc_flags = []
    possible_link_flags = []
endif

add_project_arguments(
    cc.get_supported_arguments(possible_cc_flags),
    language : 'c')
add_project_link_arguments(
    cc.get_supported_link_arguments(possible_link_flags),
    language : 'c')

includes = include_directories('''
    include
    lib/asn1c/common
    lib/asn1c/s1ap
    lib
    src
    .
'''.split())

#####################################################################
# Core Library
conf.set('_GNU_SOURCE', true)

headers = ('''
    arpa/inet.h
    ctype.h
    errno.h
    execinfo.h
    fcntl.h
    ifaddrs.h
    netdb.h
    pthread.h
    signal.h
    stdarg.h
    stddef.h
    stdio.h
    stdint.h
    stdbool.h
    stdlib.h
    string.h
    strings.h
    time.h
    sys/time.h
    unistd.h
    net/if.h
    netinet/in.h
    netinet/in_systm.h
    netinet/udp.h
    netinet/tcp.h
    sys/ioctl.h
    sys/param.h
    sys/random.h
    sys/socket.h
    sys/stat.h
    limits.h
    sys/syslimits.h
    sys/types.h
    sys/wait.h
    sys/uio.h
'''.split())

foreach h : headers
    if cc.has_header(h)
        define = 'HAVE_' + h.underscorify().to_upper()
        conf.set(define, 1)
    endif
endforeach

functions = [
    'arc4random',
    'arc4random_buf',
    'getrandom',
    'localtime_r',
    'getifaddrs',
    'getenv',
    'putenv',
    'setenv',
    'unsetenv',
    'strerror_r',
    'eventfd',
    'kqueue',
    'epoll_ctl',
]

foreach f : functions
    if cc.has_function(f)
        define = 'HAVE_' + f.underscorify().to_upper()
        conf.set(define, 1)
        set_variable('have_func_' + f, true)
    else
        set_variable('have_func_' + f, false)
    endif
endforeach

# Check for dependency
threads = dependency('threads')
libexecinfo = cc.find_library('execinfo', required : false)
librt = cc.find_library('rt', required : false)
libsocket = cc.find_library('socket', required : false)

# Check for sys_syslist
if cc.has_header_symbol('signal.h', 'sys_siglist')
    conf.set('HAVE_DECL_SYS_SIGLIST', 1,
            description: 'Define to 1 if you have the declaration of \`sys_siglist\', and to 0 if you don\'t.')
endif

# Check whether strerror_r returns char *
if have_func_strerror_r
    if cc.compiles('''#define _GNU_SOURCE
                      #include <string.h>
                      int func (void) {
                          char error_string[256];
                          char *ptr = strerror_r (-2, error_string, 256);
                          char c = *strerror_r (-2, error_string, 256);
                          return c != 0 && ptr != (void*) 0L;
                      }
                   ''',
                   name : 'strerror_r() returns char *')
        conf.set('STRERROR_R_CHAR_P', 1,
                description: 'Defined if strerror_r returns char *')
    endif
endif

# Check for backtrace()
if conf.has('HAVE_EXECINFO_H')
    if cc.has_function('backtrace', prefix : '#include <execinfo.h>')
        conf.set('HAVE_BACKTRACE', 1)
    elif libexecinfo.found() and cc.has_function('backtrace',
                                                prefix : '#include <execinfo.h>',
                                                dependencies : libexecinfo)
        conf.set('HAVE_BACKTRACE', 1)
    endif
endif    

# Check for clock_gettime()
clock_gettime_test_code = '''
    #include <time.h>
    struct timespec t;
    int main (int argc, char ** argv) {
        return clock_gettime(CLOCK_REALTIME, &t);
    }'''
if cc.links(clock_gettime_test_code, name : 'clock_gettime()')
    conf.set('HAVE_CLOCK_GETTIME', 1)
elif librt.found() and cc.links(clock_gettime_test_code,
                                dependencies : librt,
                                name : 'clock_gettime() in -lrt')
    conf.set('HAVE_CLOCK_GETTIME', 1)
endif

# Check for /dev/urandom
if run_command('[', '-c', '/dev/urandom', ']').returncode() == 0
    conf.set_quoted('OGS_DEV_RANDOM', '/dev/urandom',
                    description: 'a suitable file to read random data from')
endif

# Check for eventfd(2)
if cc.links('''#include <sys/eventfd.h>
               #include <unistd.h>
               int main (int argc, char ** argv) {
                   eventfd (0, EFD_CLOEXEC);
                   return 0;
               }''', name : 'eventfd(2) system call')
    conf.set('HAVE_EVENTFD', 1)
endif

# Check for epoll
if have_func_epoll_ctl
    conf.set('HAVE_EPOLL', 1, description: 'Defined if your system supports the epoll system calls')
endif

# Check for socket
if host_system != 'windows'
    # socket()
    socket_test = '''#include <sys/types.h>
                     #include <sys/socket.h>
                     int main (int argc, char ** argv) {
                         return socket(1, 2, 3);
                     }'''
    if cc.links(socket_test, name : 'socket()')
    elif libsocket.found() and cc.links(socket_test,
                                        dependencies : libsocket,
                                        name : 'socket() in -lsocket')
    else
        error('Could not find socket()')
    endif
endif

config_h = configure_file(
        output : 'config.h',
        configuration : conf)

subdir('include/open5gs')
subdir('lib/core')
subdir('lib/crypt')
subdir('lib/asn1c/common')
subdir('lib/asn1c/s1ap')
subdir('lib/s1ap')
#subdir('lib/diameter')
# Don’t build the tests unless we can run them (either natively or in an exe wrapper)
build_tests = not meson.is_cross_build() or (meson.is_cross_build() and meson.has_exe_wrapper())
if build_tests
    subdir('tests/core')
    subdir('tests/crypt')
endif
