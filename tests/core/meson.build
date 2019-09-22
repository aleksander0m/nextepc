sources = files(
	'list-test.c',
    'pool-test.c',
    'strings-test.c',
    'time-test.c',
    'conv-test.c',
	'log-test.c',
    'pkbuf-test.c',
    'memory-test.c',
    'rbtree-test.c',
    'timer-test.c',
	'thread-test.c',
    'socket-test.c',
    'queue-test.c',
    'poll-test.c',
	'tlv-test.c',
    'fsm-test.c',
    'hash-test.c',
	'abts-main.c',
)

exe = executable('testcore',
    sources : [sources],
    include_directories : includes,
    dependencies : libogscore_dep,
)

test('testcore', exe)
