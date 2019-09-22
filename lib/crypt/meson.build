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

crypt_headers = files('''
    ogs-aes.h
    ogs-aes-cmac.h
    ogs-sha1.h
    ogs-sha1-hmac.h
    ogs-sha2.h
    ogs-sha2-hmac.h
    milenage.h
    snow-3g.h
    zuc.h
    kasumi.h
'''.split())
#install_headers(crypt_headers, subdir : 'open5gs/crypt')

crypt_sources = files('''
    ogs-aes.c
    ogs-aes-cmac.c
    ogs-sha1.c
    ogs-sha1-hmac.c
    ogs-sha2.c
    ogs-sha2-hmac.c
    milenage.c
    snow-3g.c
    zuc.c
    kasumi.c
'''.split())

libogscrypt = library('ogscrypt',
    sources : [crypt_sources],
    c_args : ['-DHAVE_CONFIG_H=1', '-DOGS_CRYPT_COMPILATION'],
    install : true,
    include_directories : includes,
    dependencies : libogscore_dep,
)

libogscrypt_dep = declare_dependency(
    link_with : libogscrypt,
    include_directories : includes,
    dependencies : libogscore_dep,
)
