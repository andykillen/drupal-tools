#!/bin/bash
# nested loop test

site="$1"
target_env="$2"

## always run bits
# Set this to true if you want to run the db update
db_update=false
# Array of all server that we run
servers=("server.tld")
# Array of all modules that should be disabled
disable_modules=("views" "ctoools")
# Array of all modules that should be restarted
restart_modules=("tagmanager")


## run when needed bits
# set this to true if you want to run drush CC all
cc_all=false
# Array of servers that it applies to 
cc_servers=("server.tld")


## the main loop
if [ ${#servers[@]} -gt 0 ];
then
	for s in "${servers[@]}"
	do
	  # check if db update is actually needed (per server)	
	  # often this is disabled (false)
	  if $db_update = true
	  then	
	  echo "starting database update $s"
	  # perform db update
	  drush @$site.$target_env updatedb -l $s --yes
	  fi	
	  # check if anything to delete (array has things in it)
	  # loop disable begin	
	  if [ ${#disable_modules[@]} -gt 0 ];
	  then	
	  	for d in "${disable_modules[@]}"
	  	do
	  		#inner loop begin (modules)
	    	echo "disabling module $d on $s"
	        drush dis $d -l $s --yes
	    	#inner loop end
	  	done
	  fi	
	  # loop disable end

	  # check if any modules need restarting and 
	  # loop restart module start
	  if [ ${#restart_modules[@]} -gt 0 ];
	  then	
	  	for r in "${restart_modules[@]}"
	  	do
	  		#inner loop begin (modules)
	    	echo "restart module $r on $s"
	        drush dis $r -l $s --yes
	        drush en $r -l $s --yes
	    	#inner loop end
	  	done
	  fi	
	  # loop restart module end
	done
fi

## drush cc loop
if [ ${#cc_servers[@]} -gt 0 ];
then
	if $cc_all = true
	then
	  for s in "${cc_servers[@]}"
	  do
	  	drush cc all -l $s
	  done
	fi	
fi