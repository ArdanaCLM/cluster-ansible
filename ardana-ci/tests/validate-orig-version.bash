#!/bin/bash
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
set -vx
version=`/usr/bin/apt-cache policy $1 |grep Installed |awk '{print $2}'`
orig_version=`grep $1 /tmp/cluversions | awk '{print $2}'`
if [[ $version == $orig_version ]]
then
  upgradestatus=0
else
  upgradestatus=1
fi
exit $upgradestatus
