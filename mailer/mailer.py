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

import argparse
import getpass
import csv
import email
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
import smtplib
from string import Template
import pprint

def getArgs():
    """
    Supports the command-line arguments listed below.
    """
    parser = argparse.ArgumentParser(
        description='Arguments for smtp server, creds, and input files')
    parser.add_argument('-s', '--host', required=False, action='store',
                        help='Remote smtp server to connect use')
    parser.add_argument('--port', required=False, action='store',
                        default='25',
                        help='port for the smtp server')
    parser.add_argument('--subject', required=False, action='store',
                        help='subject for email message')
    parser.add_argument('--sender', required=False, action='store',
                        help='email address message will be sent as')
    parser.add_argument('-u', '--user', required=False, action='store',
                        help='username/email for smtp')
    parser.add_argument('-p', '--password', required=False, action='store',
                        help='Password to use for smtp')
    parser.add_argument('--prompt',  required=False, action='store',
                        help='Promt for password to use for smtp')
    parser.add_argument('--silent', required=False, action='store_true',
                        help='supress output to screen')
    parser.add_argument('-t', '--test', required=False, action='store_true',
                        help='Display resulting emails in stdout and do not send')
    parser.add_argument('--csvfile', required=False, action='store',
                        help='Filename and path of csv file')
    parser.add_argument('--template', required=False, action='store',
                        help='Filename and path of csv file')
    parser.add_argument('--config', required=False, action='store',
                        help='config file with auth, server, and subject')
    args = parser.parse_args()
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
