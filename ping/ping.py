#!/usr/bin/env python
"""
Written by Chris Hupman
Github: https://github.com/chupman/
Ping subnets provided in a config file or --subnet arg.
Skips the first 3 ips of a network, because I generally use .1 for the gateway
and my provider reserves the first 2 IPs for testing.
Example usage: python ping.py --subnets=[10.0.20.0/24, 10.1.20.0/24. 10.2.20.0/24]
"""
from __future__ import print_function
from __future__ import unicode_literals

import configargparse
import os
import sys
import subprocess
from netaddr import IPAddress

def getArgs():
    """
    Supports the command-line arguments listed below.
    """
    p = configargparse.ArgParser(
        default_config_files=['config.ini'],
        description='Arguments for smtp server, creds, and input files')
    p.add('--silent', required=False, action='store_true',
                        help='supress output to screen')
    p.add('--config', required=False, action='store', is_config_file=True,
                        help='config file with auth, server, and subject')
    p.add('--subnets', required=False, action='append',
                        help='Subnets in the format network/netmask i.e. 10.20.30.40/24')
    args = p.parse_args()
    return args



def main():

    args = getArgs()
    subnets = args.subnets
    DEVNULL = open(os.devnull, 'wb')
    #print("List of subnets to ping:")
    #print(subnets)
    for subnet in subnets:
        startip = IPAddress(subnet.split('/')[0])
        startip  = int(IPAddress(startip))
        mask = subnet.split('/')[1]
        endip = startip + (2 ** ( 32 - int(mask)))
        # One time I put a /17 instead of a /27 in my config and pinged a lot
        # more than I meant to This prompt sanity checks the mask size if 
        # greater than a /22
        if int(mask) < 22:
            yes = set(['yes','y', 'ye', ''])
            no = set(['no','n','nope'])
            startip = str(IPAddress(startip))
            endip = str(IPAddress(endip))
            sys.stdout.write("you entered a mask of: " + mask + " for subnet: "
                             + startip + "\n" +
                             "This will ping all the way through " + endip + 
                             "\n" + "Do you wish to proceed? Please respond" +
                             " with 'yes' or 'no'")
            choice = raw_input().lower()
            if choice in yes:
                continue
            elif choice in no:
                sys.exit()
            else:
                sys.stdout.write("Please respond with 'yes' or 'no'")
        startip = startip + 3
        commands = []
        for ip in range(startip, endip):
            ip = str(IPAddress(ip))
            #response = os.system("ping -c 1 -w 2 " + ip)
            commands.append(["ping", "-c 1", "-w 2", "-q", ip])
            #commands.append("ping -c 1 -w 2 -q " + ip)
        #print(commands)
        # TODO make the pings work with threads http://stackoverflow.com/questions/18114285/python-what-are-the-differences-between-the-threading-and-multiprocessing-modul/18114475
        #processes = [subprocess.Popen(cmd, shell=False) for cmd in commands]
        #for p in processes: 
            print("retcode is " + p.returncode)
            #if p.returncode == 0:
            #    print(poutput + " pinged")
            #else:
            #    print(poutput + "Didn't ping")

# Start program
if __name__ == "__main__":
    main()
