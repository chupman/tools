#!/bin/bash

KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAoSWkLlqz2colV0mTieBm8YNRxs3z9AOSVFcmktazdpW79/FVcmf//wka4TIHnfB+HkCAxBxMKWpIZN3hxEStrn3LErLdRtvi4nQTVDXzBa+7bRLx77bvutaaqDlKV68udDN1ydeYy23UM7cJ5IMCTzFjfRIT23NEmVy5zCNh/pnbWEegD4urj6CJXFfSywBZTWxqL58vPRsMN7VigzRNc13g0w2hMRoYFHINuAJMrJzZheeb8VX0T57LQ6JMlvy/QadMsWqflNy5uSGja0JwrCSdgzojLD7581nK5XVbCuGOj8Uu6VMppqAKSJVG9Wp2CXfQIS1HMSbIzETYy92EYQ== root@x3650m2001"

test -d /root/.ssh
if [ $? -eq 0 ]; then
	echo "`date`,/root/.ssh/ was already present on `hostname`"
	test -f /root/.ssh/authorized_keys
		if [ $? -eq 0 ]; then
			cp -f /root/.ssh/authorized_keys /root/.ssh/authorized_keys_backup.`date +"%Y%m%d"`
				if [ $? != 0 ]; then
					echo "`date`, there was an error backing up /root/.ssh/authorized_keys on `hostname` "
				else
					echo "`date`,/root/.ssh/authorized_keys was successfully backed up as /root/.ssh/authorized_keys.bak on `hostname`"
					chmod 600 /root/.ssh/authorized_keys
						if [ $? != 0 ]; then
							echo "`date`, unable to set permissions on /root/.ssh/authorized_keys on `hostname`"
						else
							grep "$KEY" /root/.ssh/authorized_keys
								if [ $? -eq 0 ]
									then echo "`date`SSH Key was already present in /root/.ssh/authorized_keys on `hostname`"
								else
									echo $KEY >> /root/.ssh/authorized_keys
										if [ $? -eq 0 ]
											then echo "`date`SSH Key was successfully added to /root/.ssh/authorized_keys on `hostname`"
										else
											echo "`date`, unable to add Key to /root/.ssh/authorized_keys on `hostname`"
										fi
								fi
						fi
										
				fi
		else 
			touch /root/.ssh/authorized_keys 
				if [ $? != 0 ]; then
					echo "`date`, there was an error creating /root/.ssh/authorized_keys on `hostname` "
				else
					chmod 600 /root/.ssh/authorized_keys
						if [ $? != 0 ]; then
							echo "`date`, unable to set permissions on /root/.ssh/authorized_keys on `hostname`"
						else
							echo $KEY >> /root/.ssh/authorized_keys
								if [ $? -eq 0 ]
									then echo "`date`SSH Key was successfully added to /root/.ssh/authorized_keys on `hostname`"
								else
									echo "`date`, unable to add Key to /root/.ssh/authorized_keys on `hostname`"
								fi
						fi
				fi
		fi
else
	mkdir /root/.ssh/
		if [ $? != 0 ]
			then echo "`date` could not create directory /root/.ssh/ on `hostname`"
		else
			touch /root/.ssh/authorized_keys
				if [ $? != 0 ]
					then echo "`date` could not create file /root/.ssh/authorized_keys on `hostname`"
				else
					chmod 600 /root/.ssh/authorized_keys
						if [ $? != 0 ]
							then echo "`date`, unable to set permissions on /root/.ssh/authorized_keys on `hostname`"
						else
							echo $KEY >> /root/.ssh/authorized_keys
								if [ $? -eq 0 ]
									then echo "`date`SSH Key was successfully added to /root/.ssh/authorized_keys on `hostname`"
										else
											echo "`date`, unable to add Key to /root/.ssh/authorized_keys on `hostname`"
									
								fi
						fi
				fi
		fi
fi


	
