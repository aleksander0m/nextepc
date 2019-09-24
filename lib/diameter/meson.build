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

diameter_headers = files('''
	message.h
    logger.h
    base.h
'''.split())
#install_headers(diameter_headers, subdir : 'open5gs/diameter')

diameter_sources = files('''
	libapp_sip.c
    message.c
    logger.c
	config.c
    init.c
'''.split())

libfdcore_dep = dependency('libfdcore',
        fallback : ['freeDiameter', 'libfdcore_dep'])

libdiameter = library('diameter',
    sources : [diameter_sources],
    c_args : ['-DHAVE_CONFIG_H=1', '-DOGS_DIAM_COMPILATION'],
    install : true,
    install_dir : ogslibdir,
    include_directories : includes,
    dependencies : [libcore_dep, libfdcore_dep],
)

libdiameter_dep = declare_dependency(
    link_with : libdiameter,
    include_directories : includes,
    dependencies : [libcore_dep, libfdcore_dep],
)
