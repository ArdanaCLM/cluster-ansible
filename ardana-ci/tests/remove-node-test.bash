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

# $1 is server name
# $2 is server role
# $3 is cluster name

controlplane=~/openstack/my_cloud/definition/data/control_plane.yml
sed -i '/id: '$1'/,+9d' ~/openstack/my_cloud/definition/data/servers.yml
sed -i '/'$2'/d' $controlplane
membercount=`grep -nA 10 "$3" $controlplane | grep "member-count:" | cut -d ':' -f2 | xargs`
linenum=`grep -nA 10 "$3" $controlplane | grep member-count | cut -f1 -d"-"`
sed -i ''$linenum's/member-count: '$membercount'/member-count: '$((membercount - 1))'/' $controlplane
