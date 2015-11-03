#!/bin/bash

## Don't attempt to run if we are not root
if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

## If we run as sudo, $USER is assigned to 'root' instead of undefined, and `sudo supervisord` doesn't set the default Ideally we would be able to get the actual username when sudo is used, but this is tricky.  Anyway, we never intend to log into RStudio directly as 'root' since it won't work anyway.
if [ "$USERFZI" = root ] || [ "$USERKONSTANZ" = root ]
	then unset USER
fi

## Set defaults for environmental variables in case they are undefined
USERDUMMY=${USERDUMMY:=dummy}
PASSWORDDUMMY=${PASSWORDDUMMY:=dummypw}
EMAILDUMMY=${EMAILDUMMY:=dummy@mail.com}
USERIDDUMMY=${USERIDDUMMY:=1000}
ROOTDUMMY=${ROOTDUMMY:=FALSE}

USERFZI=${USERFZI:=fzi}
PASSWORDFZI=${PASSWORDFZI:=test}
EMAILFZI=${EMAILFZI:=bruns@fzi.de}
USERIDFZI=${USERIDFZI:=1001}
ROOTFZI=${ROOTFZI:=FALSE}

USERKONSTANZ=${USERKONSTANZ:=konstanz}
PASSWORDKONSTANZ=${PASSWORDKONSTANZ:=test}
EMAILKONSTANZ=${EMAILKONSTANZ:=stein@dbvis.inf.uni-konstanz.de}
USERIDKONSTANZ=${USERIDKONSTANZ:=1002}
ROOTKONSTANZ=${ROOTKONSTANZ:=FALSE}

## Things get messy if we have more than one user.
## (Docker cares only about uid, not username; diff users with same uid = confusion)
## RENAME the existing user. (because deleting a user can be trouble, i.e. if we're logged in as that user)
usermod -l $USERDUMMY rstudio
usermod -m -d /home/$USERDUMMY $USERDUMMY
groupmod -n $USERDUMMY rstudio
echo "USER is now $USERDUMMY"

echo "creating new $USERFZI with UID $USERIDFZI"
useradd -m $USERFZI -u $USERIDFZI -d /home/$USERFZI
# mkdir /home/$USERFZI
# chown -R $USERFZI /home/$USERFZI

echo "creating new $USERKONSTANZ with UID $USERIDKONSTANZ"
useradd -m $USERKONSTANZ -u $USERIDKONSTANZ -d /home/$USERKONSTANZ
# mkdir /home/$USERKONSTANZ
# chown -R $USERKONSTANZ /home/$USERKONSTANZ

## Things get messy if we have more than one user.
## (Docker cares only about uid, not username; diff users with same uid = confusion)
# if [ "$USERIDFZI" -ne 1000 ] && [ "$USERIDKONSTANZ" -ne 1000 ]
# ## Configure user with a different USERID if requested.
# 	then
# 		echo "creating new $USERFZI with UID $USERIDFZI"
# 		useradd -m $USERFZI -u $USERIDFZI
# 		mkdir /home/$USERFZI
# 		chown -R $USERFZI /home/$USERFZI
#
#     echo "creating new $USERKONSTANZ with UID $USERIDKONSTANZ"
# 		useradd -m $USERKONSTANZ -u $USERIDKONSTANZ
# 		mkdir /home/$USERKONSTANZ
# 		chown -R $USERKONSTANZ /home/$USERKONSTANZ
# fi

# if [ "$USERIDFZI" -eq 1000 ] && [ "$USERIDKONSTANZ" -ne 1000 ]
#   then
#   	## RENAME the existing user. (because deleting a user can be trouble, i.e. if we're logged in as that user)
#   	usermod -l $DUMMY rstudio
#   	usermod -m -d /home/$DUMMY $DUMMY
#   	groupmod -n $DUMMY rstudio
#   	echo "USER is now $DUMMY"
#
#     echo "creating new $USERFZI with UID $USERIDFZI"
#     useradd -m $USERFZI -u $USERIDFZI
#     mkdir /home/$USERFZI
#     chown -R $USERFZI /home/$USERFZI
#
#     echo "creating new $USERKONSTANZ with UID $USERIDKONSTANZ"
#     useradd -m $USERKONSTANZ -u $USERIDKONSTANZ
#     mkdir /home/$USERKONSTANZ
#     chown -R $USERKONSTANZ /home/$USERKONSTANZ
# fi

# if [ "$USERIDFZI" -ne 1000 ] && [ "$USERIDKONSTANZ" -eq 1000 ]
#   then
#     echo "creating new $USERFZI with UID $USERIDFZI"
# 		useradd -m $USERFZI -u $USERIDFZI
# 		mkdir /home/$USERFZI
# 		chown -R $USERFZI /home/$USERFZI
#
#     ## RENAME the existing user. (because deleting a user can be trouble, i.e. if we're logged in as that user)
#     usermod -l $USERKONSTANZ rstudio
#     usermod -m -d /home/$USERKONSTANZ $USERKONSTANZ
#     groupmod -n $USERKONSTANZ rstudio
#     echo "USER is now $USERKONSTANZ"
# fi
#
# if [ "$USERIDFZI" -eq 1000 ] && [ "$USERIDKONSTANZ" -eq 1000 ]
#   then
#     ## RENAME the existing user. (because deleting a user can be trouble, i.e. if we're logged in as that user)
#   	usermod -l $USERFZI rstudio
#   	usermod -m -d /home/$USERFZI $USERFZI
#   	groupmod -n $USERFZI rstudio
#   	echo "USER is now $USERFZI"
#
#     echo "creating new $USERKONSTANZ with UID $USERIDKONSTANZ"
#     useradd -m $USERKONSTANZ -u ($USERIDKONSTANZ+1)
#     mkdir /home/$USERKONSTANZ
#     chown -R $USERKONSTANZ /home/$USERKONSTANZ
# fi

# Assing password to user
echo "$USERDUMMY:$PASSWORDDUMMY" | chpasswd
echo "$USERFZI:$PASSWORDFZI" | chpasswd
echo "$USERKONSTANZ:$PASSWORDKONSTANZ" | chpasswd

## Configure git for the User. Since root is running this script, cannot use `git config`
echo -e "[user]\n\tname = $USERDUMMY\n\temail = $EMAILDUMMY\n\n[credential]\n\thelper = cache\n\n[push]\n\tdefault = simple\n\n[core]\n\teditor = vim\n" > /home/$USERDUMMY/.gitconfig
echo -e "[user]\n\tname = $USERFZI\n\temail = $EMAILFZI\n\n[credential]\n\thelper = cache\n\n[push]\n\tdefault = simple\n\n[core]\n\teditor = vim\n" > /home/$USERFZI/.gitconfig
echo -e "[user]\n\tname = $USERKONSTANZ\n\temail = $EMAILKONSTANZ\n\n[credential]\n\thelper = cache\n\n[push]\n\tdefault = simple\n\n[core]\n\teditor = vim\n" > /home/$USERKONSTANZ/.gitconfig
echo ".gitconfig written for $USERDUMMY"
echo ".gitconfig written for $USERFZI"
echo ".gitconfig written for $USERKONSTANZ"

## Let user write to /usr/local/lib/R/site.library
addgroup $USERFZI staff
addgroup $USERKONSTANZ staff

# Use Env flag to know if user should be added to sudoers
# if [ "$ROOTDUMMY" == "TRUE" ]
# 	then
# 		adduser $USERFZI sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# 		echo "$USERFZI added to sudoers"
# fi

if [ "$ROOTFZI" == "TRUE" ]
	then
		adduser $USERFZI sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
		echo "$USERFZI added to sudoers"
fi

if [ "$ROOTKONSTANZ" == "TRUE" ]
  then
    adduser $USERKONSTANZ sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    echo "$USERKONSTANZ added to sudoers"
fi


## add these to the global environment so they are avialable to the RStudio user
echo "HTTR_LOCALHOST=$HTTR_LOCALHOST" >> /etc/R/Renviron.site
echo "HTTR_PORT=$HTTR_PORT" >> /etc/R/Renviron.site
#env | cat >> /etc/R/Renviron.site

## User should own their own home directory and all containing files (including these templates)
chown -R $USERFZI /home/$USERFZI
chown -R $USERKONSTANZ /home/$USERKONSTANZ
