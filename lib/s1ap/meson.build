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

s1ap_headers = files('''
	conv.h
    message.h 
'''.split())
install_headers(s1ap_headers, install_dir : join_paths(pkgincludedir, 's1ap'))

s1ap_sources = files('''
    conv.c 
    message.c
'''.split())

libs1ap = library('s1ap',
    sources : [s1ap_sources],
    c_args : ['-DHAVE_CONFIG_H=1', '-DOGS_S1AP_COMPILATION'],
    install : true,
    install_dir : pkglibdir,
    include_directories : includes,
    dependencies : libs1apasn1c_dep,
)

libs1ap_dep = declare_dependency(
    link_with : libs1ap,
    include_directories : includes,
    dependencies : libs1apasn1c_dep,
)
