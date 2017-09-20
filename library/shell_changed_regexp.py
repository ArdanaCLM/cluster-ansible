#!/usr/bin/env python
#
# (c) Copyright 2017 Hewlett Packard Enterprise Development LP
# (c) Copyright 2017 SUSE LLC
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

DOCUMENTATION = '''
---
module: shell_changed_regexp
short_description: runs shell command and sets changed attribute as per regexp
description:
   - Runs shell command and sets changed attribute if stdout matches to provided
   regexp. Unlike shell module with changed_when, works even if looped into
   with_items.
options:
   command:
     description:
        - command to run
     required: true
   changed_regexp:
     description:
        - regexp to match to set changed to True
   unchanged_regexp:
     description:
        - regexp to match to set changed to False

'''

EXAMPLES = '''
- shell_changed_regexp:
    command: "a2enmod {{ item }}"
    unchanged_regexp: " already "
  with_items:
    - wsgi
    - proxy
    - proxy_http
  become: yes
'''

import re

def _run_command(module):
    command = module.params['command']
    unchanged_regexp = module.params['unchanged_regexp']
    result, stdout, stderr = module.run_command(command)

    if result != 0:
        module.fail_json(msg="Command '%s' failed with exit code %d:\nstdout: %s\nstderr: %s" % (command, result, stdout, stderr))
    elif re.search(unchanged_regexp, stdout, re.S|re.M):
        module.exit_json(changed = False, result = "Unchanged")
    else:
        module.exit_json(changed = True, result = "Changed")

def main():
    module = AnsibleModule(
        argument_spec = dict(
            command  = dict(required=True),
            changed_regexp = dict(),
            unchanged_regexp = dict()
        ),
    )

    if not module.params.get('changed_regexp') and not module.params.get('unchanged_regexp'):
        module.fail_json(msg="Either changed_regexp or unchanged_regexp should be specified")

    _run_command(module)

from ansible.module_utils.basic import *
if __name__ == '__main__':
    main()
