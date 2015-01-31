#!/usr/bin/env python

import subprocess
import cgi
import cgitb

cgitb.enable()

print "Content-type: text/html\n\n"

# Create instance of FieldStorage 
form = cgi.FieldStorage() 

# Get data from fields
if form.getvalue('Start stream'):
    bashCommand = "LD_LIBRARY_PATH=/opt/mjpg-streamer/ /opt/mjpg-streamer/mjpg_streamer -i \"input_raspicam.so -fps 15 -q 50 -ex sports -x 640 -y 480\" -o \"output_http.so -p 9000 -w /opt/mjpg-streamer/www\" > /dev/null 2>&1 &"
    output = subprocess.check_output(bashCommand, shell=True)
    print "<h1>mjpg_streamer started, output = " + output + "</h1>"

if form.getvalue('Stop stream'):
    bashCommand = "kill $(pgrep mjpg_streamer) > /dev/null 2>&1"
    output = subprocess.check_output(bashCommand, shell=True)
    print "<h1>mjpg_streamer stopped, output = " + output + "</h1>"
