GRN='\033[0;32m'
NC='\033[0m'

if [ "$1" != "" ]
then
	echo -e "${GRN}Unbanning "$1"${NC}"
	echo -e "${GRN}PORT-BAN-HAMMER SAID:${NC}"
	sudo fail2ban-client set port-ban-hammer unbanip "$1"
	echo -e "${GRN}SSHD SAID:${NC}"
	sudo fail2ban-client set sshd unbanip "$1"
	echo -e "${GRN}HTTP-GET-DOS SAID:${NC}"
	sudo fail2ban-client set http-get-dos unbanip "$1"
else
	echo "Usage: ./unbanme.sh \"IP\""
fi