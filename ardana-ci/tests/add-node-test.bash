#!/bin/bash
#
# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
# (c) Copyright 2017 SUSE LLC
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#

# $1 server id
# $2 ip-addr
# $3 role
# $4 server-group
# $5 mac-addr
# $6 ilo-ip
# $7 cluster-name
cat <<EOF >> ~/openstack/my_cloud/definition/data/servers.yml
    - id: $1
      ip-addr: $2
      role: $3
      server-group: $4
      mac-addr: $5
      nic-mapping: VAGRANT
      ilo-ip: $6
      ilo-password: password
      ilo-user: admin
EOF

controlplane=~/openstack/my_cloud/definition/data/control_plane.yml
membercount=`grep -nA 10 "$7" $controlplane | grep "member-count:" | cut -d ':' -f2 | xargs`
linenum=`grep -nA 10 "$7" $controlplane | grep "member-count:" | cut -f1 -d"-"`
sed -i ''$linenum's/member-count: '$membercount'/member-count: '$((membercount + 1))'/' $controlplane

serverrole=`grep -nA 10 "$7" $controlplane | grep "server-role:" | cut -f1 -d"-"`
sed -i ''$serverrole' a\
            - '$3'' $controlplane
