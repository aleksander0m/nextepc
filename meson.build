project('open5gs', 'c',
    version : '200',
    license : 'AGPL-3.0-or-later',
    default_options : [
        'warning_level=1',
        'c_std=gnu89',
        'prefix=/usr',
        'sysconfdir=/etc',
        'localstatedir=/var',
    ],
    meson_version : '>= 0.46',
)

conf = configuration_data()
conf.set('PROJECT_VERSION', meson.project_version())

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

cc = meson.get_compiler('c')
pkgconfig = import('pkgconfig')
host_system = host_machine.system()

includes = include_directories('src')
add_project_arguments('-include', 'config.h', language : 'c')

config_h = configure_file(
        output : 'config.h',
        configuration : conf)

subdir('src/core')
#Don’t build the tests unless we can run them (either natively or in an exe wrapper)
build_tests = not meson.is_cross_build() or (meson.is_cross_build() and meson.has_exe_wrapper())
if build_tests
endif
