# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    create_user.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/02 19:13:28 by asolopov          #+#    #+#              #
#    Updated: 2020/03/03 11:36:25 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

GRN='\033[0;32m'
NC='\033[0m'

if [ "$1" != "" ]
then
	sudo adduser $1
	echo -e "${GRN}done${NC}"
	read -p "Make user "$1" sudo? (yes/y) `echo $'\n> '`" sudoprompt
	if [ "$sudoprompt" == "yes" ] || [ "$sudoprompt" == "y" ]
	then
		sudo adduser $1 sudo
		echo -e "${GRN}done${NC}"
		read -p "Would you like to relogin? (yes/y) `echo $'\n> '`" restartprompt
		if [ "$restartprompt" == "yes" ] || [ "$restartprompt" == "y" ]
		then
			exit
		fi
	fi
else
	echo "Please add NAME"
fi