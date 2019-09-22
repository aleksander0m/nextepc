sources = files('''
	aes-test.c
    sha-test.c
	abts-main.c
'''.split())

exe = executable('testcrypt',
    sources : [sources],
    include_directories : includes,
    dependencies : libogscrypt_dep,
)

test('testcrypt', exe)
