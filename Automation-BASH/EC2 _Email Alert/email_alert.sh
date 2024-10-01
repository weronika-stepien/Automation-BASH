#!/bin/bash

<<INFO

Title: AWS RAM Watchdog
Version: 1.0
Author: Weronika Stępień
Purpose: Automatically notifies user when available memory on cloud system drops below a specified threshold
Features:
	* Automated RAM monitoring
	* Email notification
	* Lightweight and efficient

Description:
	This script efficiently monitors the available RAM on virtual machines (in this case 'AWS') and provides proactive alerts when
	the system's memory drops below a defined threshold. By utilizing real-time memory checks and sending email notifications
	to designated recipients.

INFO

TO="your_email@example.com"
ram_free=$(free -gt | grep Total:| awk '{print $4}')

if [ $ram_free -le 1 ]
then
	echo "The RAM space in your virtual machine is ending"

	# WRITING THE EMAIL
	echo "Subject: WARNING - AMAZON AWS VIRTUAL MACHINE - low RAM space."|sendmail $TO
fi
