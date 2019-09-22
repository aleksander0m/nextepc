sources = files(
	'aes-test.c',
    'sha-test.c',
	'abts-main.c',
)

exe = executable('testcrypt',
    sources : [sources],
    include_directories : includes,
    dependencies : [libogscore_dep, libogscrypt_dep],
)

test('testcrypt', exe)
