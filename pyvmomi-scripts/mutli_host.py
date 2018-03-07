import atexit
from getpass import getpass

from pyVim import connect
import cli

"""
This module enables searching for multiple hosts when
searching through folder tree
"""

def setup_args():
    """
    Adds additional args to allow the vm uuid to
    be set.
    """
    parser = cli.build_arg_parser()
    # using j here because -u is used for user
    parser.add_argument('-n', '--name',
                        required=True,
                        nargs='*',
                        help='Names of the VMs you wish to select.')
    my_args = parser.parse_args()
    return cli.prompt_for_password(my_args)

args = setup_args()

        

def get_all_vms_in_folder(folder):
    vm_or_folders = folder.childEntity
    for vm_or_folder in vm_or_folders:
        if hasattr(vm_or_folder, "childEntity"):
            # it's still a folder, look deeper
            for vm in get_all_vms_in_folder(vm_or_folder):
                yield vm  # it's now a VM
        else:
            yield VM(vm_or_folder)  # it's a VM

def get_multiple_vms_in_folder(folder):
    vm_or_folders = folder.childEntity
    for vm_or_folder in vm_or_folders:
        if hasattr(vm_or_folder, "childEntity"):
            # it's still a folder, look deeper
            for vm in get_all_vms_in_folder(vm_or_folder):
                yield vm  # it's now a VM
        else:
            yield VM(vm_or_folder)  # it's a VM

VM = None
if ARGS.uuid:
    VM = SI.content.searchIndex.FindByUuid(None, ARGS.uuid,
                                           True,
                                           True)
elif ARGS.name:
    VM = SI.content.searchIndex.FindByDnsName(None, ARGS.name,
                                              True)
elif ARGS.ip:
    VM = SI.content.searchIndex.FindByIp(None, ARGS.ip, True)

if VM is None:
    raise SystemExit("Unable to locate VirtualMachine.")

print "Found: {0}".format(VM.name)
print "The current powerState is: {0}".format(VM.runtime.powerState)
TASK = VM.ResetVM_Task()
tasks.wait_for_tasks(SI, [TASK])
print "its done."


https://github.com/vmware/pyvmomi/blob/master/sample/poweronvm.py Just update this one to take an array as a CLI arguement.