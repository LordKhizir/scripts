#Create an URL file with an anchor to passed URL
display_usage() {
	echo "Create a minimal html file with link. If no filename is provided, it will be link.url"
	echo "\nUsage: $0 destination_url [filename]\n"
	}

# if less than one arguments supplied, display usage
	if [  $# -le 0 ]
  	then
  		display_usage
  		exit 1
 	fi

  # if no second argument, use default
  	if [  $# -le 1 ]
    	then
        filename="link.url"
    else
        filename=$2
   	fi

echo '[InternetShortcut]\nURL='${1} > $filename
