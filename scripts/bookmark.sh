#Create a html file with an anchor to passed URL
display_usage() {
	echo "Create a minimal html file with link. If no filename is provided, it will be url.html"
	echo "\nUsage: $0 link_text destination_url [filename]\n"
	}

# if less than two arguments supplied, display usage
	if [  $# -le 1 ]
  	then
  		display_usage
  		exit 1
 	fi

  # if no third argument, use default
  	if [  $# -le 2 ]
    	then
        filename="url.html"
    else
        filename=$3
   	fi

echo '<html><body><a href="'$2'">'$1'</a></body></html>' > $filename
