# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    compare_cron.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asolopov <asolopov@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/03/05 18:12:08 by asolopov          #+#    #+#              #
#    Updated: 2020/03/05 18:12:18 by asolopov         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

sumnew=($(md5sum "$1"))
sumorg=($(cat "$2" | awk '{ print $1 }'))

if [ "$sumnew" != "$sumorg" ]
then
	echo "Different"
	echo "$sumnew" > "$2"
	mail -s "$1 Has been modified" root < mailbody
else
	echo "Equal"
fi