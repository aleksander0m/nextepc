project('ogslib', 'c',
    version : '2.0.0',
    # NOTE: We keep this pinned at 0.49 because that's what Debian 10 ships
    meson_version : '>= 0.49.2',
    default_options : [
        'warning_level=1',
        'c_std=gnu89'
    ]
)

cc = meson.get_compiler('c')

host_system = host_machine.system()

ogs_version = meson.project_version()
version_arr = ogs_version.split('.')
major_version = version_arr[0].to_int()
minor_version = version_arr[1].to_int()
micro_version = version_arr[2].to_int()

interface_age = minor_version.is_odd() ? 0 : micro_version
binary_age = 100 * minor_version + micro_version

soversion = 0
# Maintain compatibility with previous libtool versioning
# current = minor * 100 + micro
current = binary_age - interface_age
library_version = '@0@.@1@.@2@'.format(soversion, current, interface_age)
darwin_versions = [current + 1, '@0@.@1@'.format(current + 1, interface_age)]

configinc = include_directories('.')
coreinc = include_directories('core')
cryptinc = include_directories('crypt')

ogs_prefix = get_option('prefix')
ogs_bindir = join_paths(ogs_prefix, get_option('bindir'))
ogs_libdir = join_paths(ogs_prefix, get_option('libdir'))
ogs_libexecdir = join_paths(ogs_prefix, get_option('libexecdir'))
ogs_datadir = join_paths(ogs_prefix, get_option('datadir'))
ogs_pkgdatadir = join_paths(ogs_datadir, 'open5gs')
ogs_includedir = join_paths(ogs_prefix, get_option('includedir'))

ogs_pkgconfigreldir = join_paths(ogs_libdir, 'pkgconfig')

add_project_arguments('-D_GNU_SOURCE', language: 'c')

ogs_conf = configuration_data()

ogs_conf.set('OGSCORE_MAJOR_VERSION', major_version)
ogs_conf.set('OGSCORE_MINOR_VERSION', minor_version)
ogs_conf.set('OGSCORE_MICRO_VERSION', micro_version)
ogs_conf.set('OGSCORE_INTERFACE_AGE', interface_age)
ogs_conf.set('OGSCORE_BINARY_AGE', binary_age)
ogs_conf.set_quoted('GETTEXT_PACKAGE', 'libogscore')
ogs_conf.set_quoted('PACKAGE_BUGREPORT', 'acetcom@gmail.com')
ogs_conf.set_quoted('PACKAGE_NAME', 'libogscore')
ogs_conf.set_quoted('PACKAGE_STRING', 'libogscore @0@'.format(meson.project_version()))
ogs_conf.set_quoted('PACKAGE_TARNAME', 'libogscore')
ogs_conf.set_quoted('PACKAGE_URL', '')
ogs_conf.set_quoted('PACKAGE_VERSION', meson.project_version())

ogs_conf.set('_GNU_SOURCE', 1)

headers = [
    'arpa/inet.h',
    'ctype.h',
    'errno.h',
    'execinfo.h',
    'fcntl.h',
    'ifaddrs.h',
    'netdb.h',
    'pthread.h',
    'signal.h',
    'stdarg.h',
    'stddef.h',
    'stdio.h',
    'stdint.h',
    'stdbool.h',
    'stdlib.h',
    'string.h',
    'strings.h',
    'time.h',
    'sys/time.h', # MSC does not come with this by default
    'unistd.h',
    'net/if.h',
    'netinet/in.h',
    'netinet/in_systm.h',
    'netinet/udp.h',
    'netinet/tcp.h',
    'sys/ioctl.h',
    'sys/param.h',
    'sys/random.h',
    'sys/socket.h',
    'sys/stat.h',
    'limits.h',
    'sys/syslimits.h',
    'sys/types.h',
    'sys/wait.h',
    'sys/uio.h',
]

foreach h : headers
    if cc.has_header(h)
        define = 'HAVE_' + h.underscorify().to_upper()
        ogs_conf.set(define, 1)
    endif
endforeach

# Check sys_syslist
if cc.has_header_symbol('signal.h', 'sys_siglist')
    ogs_conf.set('HAVE_DECL_SYS_SIGLIST', 1,
                  description: 'Define to 1 if you have the declaration of \`sys_siglist\', and to 0 if you don\'t.')
endif

# Compiler flags
if cc.get_id() == 'gcc' or cc.get_id() == 'clang'
    warning_c_args = [
        '-Wall',
        '-Wduplicated-branches',
        '-Wimplicit-fallthrough',
        '-Wmisleading-indentation',
        '-Wstrict-prototypes',
        '-Wno-typedef-redefinition',
        '-Wunused',
        '-Werror=declaration-after-statement',
        '-Werror=format=1',
        '-Werror=implicit-function-declaration',
        '-Werror=init-self',
        '-Werror=missing-include-dirs',
        '-Werror=pointer-arith',
    ]
    warning_c_link_args = [
        '-Wl,-z,nodelete',
    ]
else
    warning_c_args = []
    warning_c_link_args = []
endif

add_project_arguments(cc.get_supported_arguments(warning_c_args), language: 'c')

ogs_link_flags = cc.get_supported_link_arguments(warning_c_link_args)

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
        ogs_conf.set(define, 1)
        set_variable('have_func_' + f, true)
    else
        set_variable('have_func_' + f, false)
    endif
endforeach

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
        ogs_conf.set('STRERROR_R_CHAR_P', 1,
                      description: 'Defined if strerror_r returns char *')
    endif
endif

# Check for backtrace()
libexecinfo = []
if ogs_conf.has('HAVE_EXECINFO_H')
    if cc.has_function('backtrace', prefix : '#include <execinfo.h>')
        ogs_conf.set('HAVE_BACKTRACE', 1)
    else
        execinfo_dep = cc.find_library('execinfo', required : false)
        if libexecinfo.found() and cc.has_function('backtrace', prefix : '#include <execinfo.h>', dependencies : execinfo_dep)
            ogs_conf.set('HAVE_BACKTRACE', 1)
            libexecinfo += execinfo_dep
        endif
    endif
endif    

# Check for clock_gettime()
clock_gettime_test_code = '''
    #include <time.h>
    struct timespec t;
    int main (int argc, char ** argv) {
        return clock_gettime(CLOCK_REALTIME, &t);
    }'''
librt = []
if cc.links(clock_gettime_test_code, name : 'clock_gettime')
    ogs_conf.set('HAVE_CLOCK_GETTIME', 1)
elif cc.links(clock_gettime_test_code, args : '-lrt', name : 'clock_gettime in librt')
    ogs_conf.set('HAVE_CLOCK_GETTIME', 1)
    librt = cc.find_library('rt')
endif

# Check for /dev/urandom
if run_command('[', '-c', '/dev/urandom', ']').returncode() == 0
    ogs_conf.set_quoted('OGS_DEV_RANDOM', '/dev/urandom',
                  description: 'a suitable file to read random data from')
endif

# Check for eventfd()
if cc.links('''#include <sys/eventfd.h>
               #include <unistd.h>
               int main (int argc, char ** argv) {
                   eventfd (0, EFD_CLOEXEC);
                   return 0;
               }''', name : 'eventfd(2) system call')
    ogs_conf.set('HAVE_EVENTFD', 1)
endif

# Check for epoll
if have_func_epoll_ctl
    ogs_conf.set('HAVE_EPOLL', 1,
                  description: 'Defined if your system supports the epoll system calls')
endif

# Check for network socket
network_libs = []
network_args = []
if host_system != 'windows'
    # socket()
    socket_test = '''#include <sys/types.h>
                     #include <sys/socket.h>
                     int main (int argc, char ** argv) {
                         return socket(1, 2, 3);
                     }'''
    if not cc.links(socket_test, name : 'socket()')
        if cc.links(socket_test, args : '-lsocket', name : 'socket() in -lsocket')
            network_libs += [ cc.find_library('socket') ]
            network_args += [ '-lsocket' ]
        else
            error('Could not find socket()')
        endif
    endif

    if cc.compiles('''#include <sys/ioctl.h>
                      #include <net/if.h>
                      int main (int argc, char ** argv) {
                          struct ifreq ifr;
                          ioctl(0, SIOCGIFADDR, &ifr);
                          return 0;
                      }''',
                      name : 'ioctl with request SIOCGIFADDR')
        ogs_conf.set('HAVE_SIOCGIFADDR', '/**/')
    endif
endif

thread_dep = dependency('threads')

pkg = import('pkgconfig')

subdir('core')
subdir('crypt')
# Don’t build the tests unless we can run them (either natively or in an exe wrapper)
build_tests = not meson.is_cross_build() or (meson.is_cross_build() and meson.has_exe_wrapper())
if build_tests
#  subdir('tests')
endif

configure_file(output : 'config.h', configuration : ogs_conf)
