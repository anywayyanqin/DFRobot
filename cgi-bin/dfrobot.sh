#!/bin/bash

function handle_command {
    if [ "${1}" == "start_stream" ]
    then
        LD_LIBRARY_PATH=/opt/mjpg-streamer/ /opt/mjpg-streamer/mjpg_streamer -i "input_raspicam.so -vf -hf -fps 15 -q 50 -ex sports -x 800 -y 600" -o "output_http.so -p 44445 -w /opt/mjpg-streamer/www" > /dev/null 2>&1 &
    elif [ "${1}" == "stop_stream" ]
    then
        kill $(pgrep mjpg_streamer) > /dev/null 2>&1
    fi
}

# CGI POST method handling code below taken from http://tuxx-home.at/cmt.php?article=/2005/06/17/T09_07_39/index.html
if [ "$REQUEST_METHOD" = "POST" ]; then
    read POST_STRING

    # replace all escaped percent signs with a single percent sign
    POST_STRING=$(echo $POST_STRING | sed 's/%%/%/g')

    # replace all ampersands with spaces for easier handling later
    POST_STRING=$(echo $POST_STRING | sed 's/&/ /g')

    # Now $POST_STRING contains 'cmd=<value>' where 'cmd' and '<value>' correspond with the
    # 'name' and 'value' attribute of the button pressed in the client side html file.
    # Filter out <value> and store it in $COMMAND.
    COMMAND="$(echo $POST_STRING | sed -n 's/^.*cmd=\([^ ]*\).*$/\1/p')"

    # Call command handler.
    handle_command $COMMAND
fi

# Now we must return a valid HTTP header to the client, otherwise an "Internal Server Error" will be generated.
# Below are three options:
# 1. Use HTTP header "Content-type" and then add an HTML meta 'refresh' to force a refresh of the page.
#    This has the disadvantage that the refresh is visible, dependent of the browser.
# 2. Use HTTP header "Location" and point it to the original page so this will also refresh the page.
#    This has the disadvantage that the refresh is visible, dependent of the browser.
# 3. Use the HTTP header "Status" and return code 304, which means "Not Modified".
#    This will prevent most browsers from reloading the page and is the preferred method.
#    The disadvantage that the new html content like the robot status is not updated.
# The best option might be to use option 3 when no status update is needed else option 2.

#echo $'Location: ../index1.html\n'
echo $'Status:304\n'

