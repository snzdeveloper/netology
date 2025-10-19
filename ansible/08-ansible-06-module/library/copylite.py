# -*- coding: utf-8 -*-

# Copyright: (c) 2017, Ansible Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

from __future__ import (absolute_import, division, print_function)


DOCUMENTATION = r"""
---
module: copylite
version_added: historical
short_description: Copy files to remote locations
description:
    - The M(ansible.snzdeveloper.copylite) module creates a file with defined context.
      File system meta-information (permissions, ownership, etc.) may be set, even when the file or directory already exists on the target system.
      Some meta-information may be copied on request.
    - Get meta-information with the M(ansible.builtin.stat) module.
    - Set meta-information with the M(ansible.builtin.file) module.
    - Use the M(ansible.builtin.fetch) module to copy files from remote locations to the local box.
    - If you need variable interpolation in copied files, use the M(ansible.builtin.template) module.
      Using a variable with the O(content) parameter produces unpredictable results.
    - For Windows targets, use the M(ansible.windows.win_copy) module instead.
options:
  content:
    description:
    - Works only when O(dest) is a file. Creates the file if it does not exist.
    - For advanced formatting or if O(content) contains a variable, use the
      M(ansible.builtin.template) module.
    type: str
    version_added: '1.1'
  dest:
    description:
    - Remote absolute path where the file should be copied to.
    - If O(dest) is a relative path, the starting directory is determined by the remote host.
    - O(dest) should be valid file path/name!
    type: path
    required: yes

notes:
    - The M(ansible.snzdeveloper.copylite) module creates file with defined context.
seealso:
    - module: ansible.builtin.assemble
    - module: ansible.builtin.fetch
    - module: ansible.builtin.file
    - module: ansible.builtin.template
    - module: ansible.posix.synchronize
    - module: ansible.windows.win_copy
author:
    - snzdeveloper
thanks to:
    - Ansible Core Team
    - Michael DeHaan
attributes:
  action:
    support: full
  async:
    support: none
  bypass_host_loop:
    support: none
  check_mode:
    support: full
  diff_mode:
    support: full
  platform:
    platforms: posix
  safe_file_operations:
      support: full
  vault:
    support: full
    version_added: '2.2'
"""

EXAMPLES = r"""
- name: Copy using inline content
  ansible.snzdeveloper.copylite:
    content: '# This file was moved to /etc/other.conf'
    dest: /etc/mine.conf

"""

RETURN = r"""
dest:
    description: Destination file/path.
    returned: success
    type: str
    sample: /path/to/file.txt
gid:
    description: Group id of the file, after execution.
    returned: success
    type: int
    sample: 100
group:
    description: Group of the file, after execution.
    returned: success
    type: str
    sample: httpd
owner:
    description: Owner of the file, after execution.
    returned: success
    type: str
    sample: httpd
uid:
    description: Owner id of the file, after execution.
    returned: success
    type: int
    sample: 100
mode:
    description: Permissions of the target, after execution.
    returned: success
    type: str
    sample: '0644'
size:
    description: Size of the target, after execution.
    returned: success
    type: int
    sample: 1220
state:
    description: State of the target, after execution.
    returned: success
    type: str
    sample: file
"""

import os
import os.path
import tempfile

from ansible.module_utils.common.text.converters import to_bytes, to_native
from ansible.module_utils.basic import AnsibleModule


def main():

    module = AnsibleModule(
        # not checking because of daisy chain to file module
        argument_spec=dict(
            content=dict(type='str', no_log=True),
            dest=dict(type='path', required=True),
        ),
        add_file_common_args=True,
        supports_check_mode=True,
    )

    dest = module.params['dest']
    # Make sure we always have a directory component for later processing
    if os.path.sep not in dest:
        dest = '.{0}{1}'.format(os.path.sep, dest)
    b_dest = to_bytes(dest, errors='surrogate_or_strict')
    content = module.params['content']

    changed = False
    checksum_dest = None
    checksum_src = None
    
    if os.path.exists(b_dest):
        if os.path.islink(b_dest):
            b_dest = os.path.realpath(b_dest)
            dest = to_native(b_dest, errors='surrogate_or_strict')
        
        if os.access(b_dest, os.R_OK) and os.path.isfile(b_dest):
            checksum_dest = module.sha1(dest)
    else:
        if not os.path.exists(os.path.dirname(b_dest)):
            try:
                # os.path.exists() can return false in some
                # circumstances where the directory does not have
                # the execute bit for the current user set, in
                # which case the stat() call will raise an OSError
                os.stat(os.path.dirname(b_dest))
            except OSError as e:
                if "permission denied" in to_native(e).lower():
                    module.fail_json(msg="Destination directory %s is not accessible" % (os.path.dirname(dest)))
            
            module.fail_json(msg="Destination directory %s does not exist" % (os.path.dirname(dest)))

    if not os.access(os.path.dirname(b_dest), os.W_OK) and not module.params['unsafe_writes']:
        module.fail_json(msg="Destination %s not writable" % (os.path.dirname(dest)))

    if not module.check_mode:
        try:
            # allow for conversion from symlink.
            if os.path.islink(b_dest):
                os.unlink(b_dest)
                open(b_dest, 'w').close()

            dummy, b_mysrc = tempfile.mkstemp(dir=os.path.dirname(b_dest))
            f_dest = open(b_mysrc, 'w')
            f_dest.write(content)
            f_dest.close()
            
            checksum_src = module.sha1(b_mysrc)
            
            # at this point we should always have tmp file
            if checksum_src != checksum_dest:
                module.atomic_move(b_mysrc, dest, unsafe_writes=module.params['unsafe_writes'], keep_dest_attrs=True)
                changed = True
                
        except OSError as ex:
            raise Exception(f"Failed to copy context to {dest!r}.") from ex


    res_args = dict(
        dest=dest, changed=changed
    )

    file_args = module.load_file_common_arguments(module.params, path=dest)
    res_args['changed'] = module.set_fs_attributes_if_different(file_args, res_args['changed'])

    module.exit_json(**res_args)


if __name__ == '__main__':
    main()
