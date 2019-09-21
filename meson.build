project('open5gs', 'c',
    version : '200',
    license : 'AGPL-3.0-or-later'
    default_options : [
        'warning_level=1',
        'c_std=gnu89',
        'prefix=/usr',
        'sysconfdir=/etc',
        'localstatedir=/var',
    ]
    meson_version : '>= 0.46',
)

conf = configuration_data()
conf.set('PROJECT_VERSION',        meson.project_version())

# join_paths ignores the preceding arguments if an absolute component is
# encountered, so this should canonicalize various paths when they are
# absolute or relative.
prefix = get_option('prefix')
if not prefixdir.startswith('/')
        error('Prefix is not absolute: "@0@"'.format(prefixdir))
endif
bindir = join_paths(prefix, get_option('bindir'))
libdir = join_paths(prefix, get_option('libdir'))
sysconfdir = join_paths(prefixdir, get_option('sysconfdir'))
includedir = join_paths(prefixdir, get_option('includedir'))
datadir = join_paths(prefixdir, get_option('datadir'))
localstatedir = join_paths('/', get_option('localstatedir'))

pkgconfigdatadir = get_option('pkgconfigdatadir') == '' ? join_paths(datadir, 'pkgconfig') : get_option('pkgconfigdatadir')
pkgconfiglibdir = get_option('pkgconfiglibdir') == '' ? join_paths(libdir, 'pkgconfig') : get_option('pkgconfiglibdir')

configinc = include_directories('.')
coreinc = include_directories('core')
cryptinc = include_directories('crypt')


#####################################################################

cc = meson.get_compiler('c')
pkgconfig = import('pkgconfig')

host_system = host_machine.system()

add_project_arguments('-D_GNU_SOURCE', language: 'c')

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
        conf.set(define, 1)
    endif
endforeach

# Check sys_syslist
if cc.has_header_symbol('signal.h', 'sys_siglist')
    conf.set('HAVE_DECL_SYS_SIGLIST', 1,
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
        conf.set(define, 1)
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
        conf.set('STRERROR_R_CHAR_P', 1,
                      description: 'Defined if strerror_r returns char *')
    endif
endif

# Check for backtrace()
libexecinfo = []
if conf.has('HAVE_EXECINFO_H')
    if cc.has_function('backtrace', prefix : '#include <execinfo.h>')
        conf.set('HAVE_BACKTRACE', 1)
    else
        execinfo_dep = cc.find_library('execinfo', required : false)
        if libexecinfo.found() and cc.has_function('backtrace', prefix : '#include <execinfo.h>', dependencies : execinfo_dep)
            conf.set('HAVE_BACKTRACE', 1)
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
    conf.set('HAVE_CLOCK_GETTIME', 1)
elif cc.links(clock_gettime_test_code, args : '-lrt', name : 'clock_gettime in librt')
    conf.set('HAVE_CLOCK_GETTIME', 1)
    librt = cc.find_library('rt')
endif

# Check for /dev/urandom
if run_command('[', '-c', '/dev/urandom', ']').returncode() == 0
    conf.set_quoted('OGS_DEV_RANDOM', '/dev/urandom',
                  description: 'a suitable file to read random data from')
endif

# Check for eventfd()
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
    conf.set('HAVE_EPOLL', 1,
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
        conf.set('HAVE_SIOCGIFADDR', '/**/')
    endif
endif

thread = dependency('threads')

subdir('src')
# Don’t build the tests unless we can run them (either natively or in an exe wrapper)
build_tests = not meson.is_cross_build() or (meson.is_cross_build() and meson.has_exe_wrapper())
if build_tests
  subdir('tests')
endif

config_h = configure_file(
        output : 'config.h',
        configuration : conf)
