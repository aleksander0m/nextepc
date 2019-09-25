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

open5gs_headers = files('''
    ogs-core.h
    ogs-s1ap.h
'''.split())
install_headers(open5gs_headers, install_dir : pkgincludedir)

open5gs_not_installed_headers = files('''
    ogs-crypt.h
    ogs-dbi.h
    ogs-sctp.h
    ogs-app.h
    ogs-nas.h
    ogs-diameter.h
    ogs-gtp.h
'''.split())
