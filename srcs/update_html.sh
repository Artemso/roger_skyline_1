# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    update_html.sh                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/07 15:48:46 by asolopov          #+#    #+#              #
#    Updated: 2020/03/07 15:55:54 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

git pull

sumnew=($(md5sum "srcs/index.html"))
sumold=($(cat "/home/html_md5" | awk '{ print $1 }'))

if [ "$sumnew" != "$sumorg" ]
then
	echo "Different"
	cp srcs/index.html /var/www/html || error_exit
else
	echo "Equal"
fi