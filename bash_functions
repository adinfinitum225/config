
# Function to call to activate Python3 virtual environment
workon () {
	if [ -z "$1" ];
       	then
		echo "Please enter an enironment name"
	else
		. ~/env/"$1"/bin/activate
	fi
}
