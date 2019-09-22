core_headers = files('''
    ogs-compat.h
    ogs-macros.h
    ogs-pool.h
    ogs-list.h
    ogs-abort.h
    ogs-errno.h
    ogs-strings.h
    ogs-time.h
    ogs-conv.h
    ogs-log.h
    ogs-pkbuf.h
    ogs-memory.h
    ogs-rbtree.h
    ogs-timer.h
    ogs-rand.h
    ogs-thread.h
    ogs-signal.h
    ogs-process.h
    ogs-sockaddr.h
    ogs-socket.h
    ogs-sockpair.h
    ogs-socknode.h
    ogs-udp.h
    ogs-tcp.h
    ogs-queue.h
    ogs-poll.h
    ogs-notify.h
    ogs-tlv.h
    ogs-env.h
    ogs-fsm.h
    ogs-hash.h
    ogs-misc.h
    ogs-getopt.h
    ogs-3gpp-types.h
    abts.h
'''.split())
#install_headers(core_headers, subdir : 'open5gs/core')

core_sources = files('''
    ogs-abort.c
    ogs-errno.c
    ogs-strings.c
    ogs-time.c
    ogs-conv.c
    ogs-log.c
    ogs-pkbuf.c
    ogs-memory.c
    ogs-rbtree.c
    ogs-timer.c
    ogs-rand.c
    ogs-thread.c
    ogs-signal.c
    ogs-process.c
    ogs-sockaddr.c
    ogs-socket.c
    ogs-sockpair.c
    ogs-socknode.c
    ogs-udp.c
    ogs-tcp.c
    ogs-queue.c
    ogs-select.c
    ogs-poll.c
    ogs-notify.c
    ogs-tlv.c
    ogs-env.c
    ogs-fsm.c
    ogs-hash.c
    ogs-misc.c
    ogs-getopt.c
    ogs-3gpp-types.c
    ogs-core.c
    abts.c
'''.split())

libogscore = library('ogscore',
    sources : [core_sources],
    c_args : ['-DHAVE_CONFIG_H=1', '-DOGS_CORE_COMPILATION'],
    install : true,
    include_directories : includes,
    dependencies : [threads,
                    librt,
                    libexecinfo,
                    libsocket],
)

libogscore_dep = declare_dependency(
    link_with : libogscore,
    include_directories : includes,
    dependencies : [threads,
                    librt,
                    libexecinfo,
                    libsocket],
)
