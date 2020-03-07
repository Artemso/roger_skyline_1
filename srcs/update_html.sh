# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update_html.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/07 15:48:46 by asolopov          #+#    #+#              #
#    Updated: 2020/03/07 16:52:11 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

cd /home/deploy && git pull

sumnew=($(md5sum "/home/index.html"))
sumold=($(cat "/home/html_md5" | awk '{ print $1 }'))
if [ "$sumnew" != "$sumold" ]
then
	echo "Different"
	cp srcs/index.html /var/www/html || error_exit
	echo "$sumnew" > "/home/html_md5"
else
	echo "Equal"
fi