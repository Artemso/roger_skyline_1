# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update_packages.sh                                 :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/05 15:38:49 by asolopov          #+#    #+#              #
#    Updated: 2020/03/05 18:12:03 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

RES='\e[0m'
GREEN='\e[0;32m'

time=$(date)
echo -e $GREEN"Updating Packages..."$RES
echo "" >> /var/log/update_script.log
echo "$time" >> /var/log/update_script.log
apt-get update -y >> /var/log/update_script.log
apt-get upgrade -y >> /var/log/update_script.log

echo -e $GREEN"Done!"$RES
echo "Changes written to /var/log/update_script.log"