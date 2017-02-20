#!/usr/bin/env python
"""
Written by Chris Hupman
Github: https://github.com/chupman/
Take a template file and csv as arguments and send out emails
Example usage: 
python mailer.py -s 9.52.224.217 --from chupman@us.ibm.com \
--subject "*IBM Confidential: Access to SVL Collaboration Center" \
--user chupman@us.ibm.com --prompt
"""
from __future__ import print_function
from __future__ import unicode_literals

import configargparse
import getpass
import csv
import email
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
import smtplib
from string import Template
import pprint
import json

def getArgs():
    """
    Supports the command-line arguments listed below.
    """
    p = configargparse.ArgParser(
        default_config_files=['config.ini', 'mailerconfig.ini'],
        description='Arguments for smtp server, creds, and input files')
    p.add('-s', '--host', required=False, action='store',
                        help='Remote smtp server to connect use')
    p.add('--port', required=False, action='store',
                        default='25',
                        help='port for the smtp server')
    p.add('--subject', required=False, action='store',
                        help='subject for email message')
    p.add('--sender', required=False, action='store',
                        help='email address message will be sent as')
    p.add('-u', '--username', required=False, action='store',
                        help='username/email for smtp')
    p.add('-p', '--password', required=False, action='store',
                        help='Password to use for smtp')
    p.add('--prompt',  required=False, action='store',
                        help='Promt for password to use for smtp')
    p.add('--silent', required=False, action='store_true',
                        help='supress output to screen')
    p.add('--test', required=False, action='store_true',
                        help='Display resulting emails in stdout and do not send')
    p.add('--csvfile', required=False, action='store',
                        help='Filename and path of csv file')
    p.add('--template', required=False, action='store',
                        help='Filename and path of csv file')
    p.add('--config', required=False, action='store', is_config_file=True,
                        help='config file with auth, server, and subject')
    args = p.parse_args()
    return args


def mailer(to, template, args):
    # server = smtplib.SMTP_SSL(args.host, args.port)
    server = smtplib.SMTP(args.host, args.port)

    # Next, log in to the server
    #server.login(args.user, args.password)

    fromaddr = args.sender
    toaddr = to
    msg = MIMEMultipart('alternative')
    msg['From'] = fromaddr
    msg['To'] = toaddr
    msg['Subject'] = args.subject

    body = template
    msg.attach(MIMEText(body, 'plain'))
    server.ehlo()
    if args.port != '25':
        server.starttls()
        server.ehlo()
    text = msg.as_string()
    server.sendmail(fromaddr, toaddr, text)


def main():

    args = getArgs()

    if args.prompt:
        args.password = getpass.getpass(prompt='Enter password for host %s and '
                                   'user %s: ' % (args.host, args.user))

    # First load the template and the csv as variables
    print(args.template)
    rawtemplate = open(args.template)
    template = Template(rawtemplate.read())
    f = open(args.csvfile, 'rb')
    csvdata = csv.reader(f)
    header = csvdata.next()
    #print(header)
    maildict = {}
    fieldnum = len(header)
    for row in csvdata:
        line = str(csvdata.line_num)
        maildict[line] = {}
        for i in range (len(header)):
            maildict[line][header[i]] = row[i]
        result = template.substitute(maildict[line])
        #print(result)
        mailer(maildict[line]["email"], result, args)
    #pprint.pprint(maildict)


# Start program
if __name__ == "__main__":
    main()
