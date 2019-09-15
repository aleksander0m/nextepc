ogs_headers = files(
    'ogs-crypt.h',
)
install_headers(ogs_headers, subdir : 'open5gs')

ogs_sub_headers = files(
	'ogs-aes.h',
    'ogs-aes-cmac.h',
	'ogs-sha1.h',
    'ogs-sha1-hmac.h',
	'ogs-sha2.h',
    'ogs-sha2-hmac.h',
	'milenage.h',
    'snow-3g.h',
    'zuc.h',
    'kasumi.h',
)
install_headers(ogs_sub_headers, subdir : 'open5gs/crypt')

ogs_sources = files(
	'ogs-aes.c',
    'ogs-aes-cmac.c',
	'ogs-sha1.c',
    'ogs-sha1-hmac.c',
	'ogs-sha2.c',
    'ogs-sha2-hmac.c',
	'milenage.c',
    'snow-3g.c',
    'zuc.c',
    'kasumi.c',
)

ogs_c_args = ['-DHAVE_CONFIG_H=1', '-DOGS_CRYPT_COMPILATION']
libogscrypt = library('ogscrypt',
    sources : [ogs_sources],
    version : library_version,
    soversion : soversion,
    darwin_versions : darwin_versions,
    install : true,
    include_directories : configinc,
    dependencies : [thread_dep, network_libs, librt, libogscore_dep],
    c_args : ogs_c_args,
    objc_args : ogs_c_args,
)

libogscrypt_dep = declare_dependency(
  link_with : libogscrypt,
  include_directories : [cryptinc])

pkg.generate(libogscrypt,
    subdirs : ['open5gs'],
    version : ogs_version,
    install_dir : ogs_pkgconfigreldir,
    filebase : 'libogscrypt',
    name : 'OGSCryto',
    description : 'Open5GS Cryptographic Library',
)
