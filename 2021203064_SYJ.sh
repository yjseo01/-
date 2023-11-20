#!/bin/bash

source /etc/environment

declare BLUE='\033[0;44m'
declare RED='\033[0;41m'
declare YELLOW='\033[0;33m'
declare WHITE='\033[0;27m'
declare BLUE_c='\033[0;34m'
declare RETURN='\033[0;0m'
declare REVERSE='\033[0;7m'

touch userlog.txt

declare userlog="userlog.txt"

function getkey() 
{
	escape_char=$(printf "\u1b")
	read -rsn1 mode
	if [[ $mode == $escape_char ]]; then
		read -rsn2 mode
	else
		mode=''
	fi
	case $mode in
		'q') echo QUITTING ; exit ;;
		'[A') echo UP ;;
		'[B') echo DOWN ;;
		'[D') echo LEFT ;;
		'[C') echo RIGHT ;;
		'') echo ENTER;;
		*) >&2 echo 'ERR bad input'; return ;;
	esac
}

function start()
{
        tput reset
	tput clear
	tput sgr0
	tput civis

	tput cup 4 20
	echo " ____   ___  ____ ___ _       _ "
	tput cup 5 20
	echo "/ ___| / _ \\/ ___|_ _| |     / |"
	tput cup 6 20
	echo "\\___ \\| | | \\___ \\| || |     | |"
	tput cup 7 20
	echo " ___) | |_| |___) | || |___  | |"
	tput cup 8 20
	echo "|____/ \\___/|____/___|_____| |_|"
	echo ""
	
	tput cup 10 20
	echo "    _  _____  _    __  ____  __"
	tput cup 11 20
	echo "   / \\|_   _|/ \\   \\ \\/ /\\ \\/ /"
	tput cup 12 20
	echo "  / _ \\ | | / _ \\   \\  /  \\  /"
	tput cup 13 20
	echo " / ___ \\| |/ ___ \\  /  \\  /  \\"
	tput cup 14 20
	echo "/_/   \\_\\_/_/   \\_\\/_/\\_\\/_/\\_\\"
	tput cup 15 20
	echo ""
	tput cup 16 20
	echo "                        2021203064 SYJ"

	_1plogin='\a  1P LOGIN   \a'
	signin='\a   SIGN IN    \a'
	_2plogin='\a  2p LOGIN  \a'
	signout='\a   SIGN OUT   \a'
	join='\a   JOIN   \a'
	_exit='\a   EXIT   \a'

	blank='\a             \a'

	_1ploginid=""
	_2ploginid=""
	

	row=20
	col=20

	if [ "$_1pid" != "" ]
	then
		tput cup 20 20
		echo -en "$BLUE$blank"
		tput cup 20 23
		echo -en "$_1pid"
	else
		tput cup 20 20
		echo -en "$BLUE$_1plogin"
	fi
	if [ "$_2pid" != "" ]
	then
		tput cup 25 20
		echo -en "$BLUE$blank"
		tput cup 25 23
		echo -en "$_2pid"
	else
		tput cup 25 20
		echo -en "$BLUE$_2plogin"
	fi

	tput cup 20 40
	echo -en "$BLUE$signin"
	tput cup 25 40
	echo -en "$BLUE$signout"
	tput cup 30 23
	echo -en "$BLUE$join"
	tput cup 30 37
	echo -en "$BLUE$_exit"

	while :
	do
		key=$(getkey)
		case $key in
			UP) 
				if [ $col -eq 25 ]
				then
					col=20
				elif [ $col -eq 30 ] && [ $row -eq 23 ]
				then
					col=25
					row=20
				elif [ $col -eq 30 ] && [ $row -eq 37 ]
				then
					col=25
					row=40
				fi
				;;
			DOWN)
				if [ $col -eq 20 ]
				then
					col=25
				elif [ $col -eq 25 ] && [ $row -eq 20 ]
				then
					col=30
					row=23
				elif [ $col -eq 25 ] && [ $row -eq 40 ]
				then
					col=30
					row=37
				fi
				;;
			RIGHT) 
				if [ $row -eq 20 ]
				then
					row=40
				elif [ $row -eq 23 ]
				then
					row=37
				fi
				;;
			LEFT)
				if [ $row -eq 40 ]
				then
					row=20
				elif [ $row -eq 37 ]
				then 
					row=23
				fi
				;;
			ENTER)	
				tput clear
				tput sgr0
				tput civis
				if [ $row -eq 20 ] && [ $col -eq 20 ] #1plogin
				then	
					login 1
				elif [ $row -eq 40 ] && [ $col -eq 20 ]
				then
					sign_in
				elif [ $row -eq 20 ] && [ $col -eq 25 ] #2plogin
				then
					login 2
				elif [ $row -eq 40 ] && [ $col -eq 25 ] 
				then
					sign_out
				elif [ $row -eq 23 ] && [ $col -eq 30 ] #join
				then
					if [ "$_1plogin" != "" ] && [ "$_2plogin" != "" ]
					then
						standby
					else
						tput clear
						tput reset
						tput sgr0
						exit
					fi
				elif [ $row -eq 37 ] && [ $col -eq 30 ]	#exit
				then
					tput clear
					tput reset
					tput sgr0
					exit
				fi
				break
				;;
		esac

		tput cup $col $row

		if [ $row -eq 20 ] && [ $col -eq 20 ]
	       	then
			if [ "$_1pid" != "" ]
			then
				tput cup 20 20
				echo -en "$RED$blank"
				tput cup 20 23
				echo -en "$_1pid"
			else
				tput cup 20 20
				echo -en "$RED$_1plogin"
			fi

			if [ "$_2pid" != "" ]
			then
				tput cup 25 20
				echo -en "$BLUE$blank"
				tput cup 25 23
				echo -en "$_2pid"
			else
				tput cup 25 20
				echo -en "$BLUE$_2plogin"
			fi

			tput cup 20 40
			echo -en "$BLUE$signin"
			tput cup 25 40
			echo -en "$BLUE$signout"
			tput cup 30 23
			echo -en "$BLUE$join"
			tput cup 30 37
			echo -en "$BLUE$_exit"

		elif [ $row -eq 40 ] && [ $col -eq 20 ]
		then
			echo -en "$RED$signin"
			if [ "$_1pid" != "" ]
                        then
				tput cup 20 20
                                echo -en "$BLUE$blank"
                                tput cup 20 23
                                echo -en "$_1pid"
                        else
				tput cup 20 20
                                echo -en "$BLUE$_1plogin"
                        fi

                        if [ "$_2pid" != "" ]
                        then
                                tput cup 25 20
                                echo -en "$BLUE$blank"
                                tput cup 25 23
                                echo -en "$_2pid"
                        else
				tput cup 25 20
                                echo -en "$BLUE$_2plogin"
                        fi
			tput cup 25 40
			echo -en "$BLUE$signout"
			tput cup 30 23
			echo -en "$BLUE$join"
			tput cup 30 37
			echo -en "$BLUE$_exit"

		elif [ $row -eq 20 ] && [ $col -eq 25 ] #2plogin 
		then
                        if [ "$_2pid" != "" ]
                        then
				tput cup 25 20
                                echo -en "$RED$blank"
                                tput cup 25 23
                                echo -en "$_2pid"
                        else
				tput cup 25 20
                                echo -en "$RED$_2plogin"
                        fi

                        if [ "$_1pid" != "" ]
                        then
                                tput cup 20 20
                                echo -en "$BLUE$blank"
                                tput cup 20 23
                                echo -en "$_1pid"
                        else
				tput cup 20 20
                                echo -en "$BLUE$_1plogin"
                        fi

			tput cup 20 40
			echo -en "$BLUE$signin"
			tput cup 25 40
			echo -en "$BLUE$signout"
			tput cup 30 23
                        echo -en "$BLUE$join"
                        tput cup 30 37
                        echo -en "$BLUE$_exit"

		elif [ $row -eq 40 ] && [ $col -eq 25 ] #signout
		then
			echo -en "$RED$signout"
			if [ "$_1pid" != "" ]
                        then
				tput cup 20 20
                                echo -en "$BLUE$blank"
                                tput cup 20 23
                                echo -en "$_1pid"
                        else
				tput cup 20 20
                                echo -en "$BLUE$_1plogin"
                        fi

                        if [ "$_2pid" != "" ]
                        then
                                tput cup 25 20
                                echo -en "$BLUE$blank"
                                tput cup 25 23
                                echo -en "$_2pid"
                        else
				tput cup 25 20
                                echo -en "$BLUE$_2plogin"
                        fi

			tput cup 20 40
			echo -en "$BLUE$signin"
			tput cup 30 23
                        echo -en "$BLUE$join"
                        tput cup 30 37
                        echo -en "$BLUE$_exit"

		elif [ $row -eq 23 ] && [ $col -eq 30 ] #join
		then
			echo -en "$RED$join"
			if [ "$_1pid" != "" ]
                        then
				tput cup 20 20
                                echo -en "$BLUE$blank"
                                tput cup 20 23
                                echo -en "$_1pid"
                        else
				tput cup 20 20
                                echo -en "$BLUE$_1plogin"
                        fi

                        if [ "$_2pid" != "" ]
                        then
                                tput cup 25 20
                                echo -en "$BLUE$blank"
                                tput cup 25 23
                                echo -en "$_2pid"
                        else
				tput cup 25 20
                                echo -en "$BLUE$_2plogin"
                        fi

			tput cup 20 40
                        echo -en "$BLUE$signin"
			tput cup 25 40
			echo -en "$BLUE$signout"
			tput cup 30 37
			echo -en "$BLUE$_exit"

		elif [ $row -eq 37 ] && [ $col -eq 30 ] #exit
		then
			echo -en "$RED$_exit"
			if [ "$_1pid" != "" ]
                        then
				tput cup 20 20
                                echo -en "$BLUE$blank"
                                tput cup 20 23
                                echo -en "$_1pid"
                        else
				tput cup 20 20
                                echo -en "$BLUE$_1plogin"
                        fi

                        if [ "$_2pid" != "" ]
                        then
                                tput cup 25 20
                                echo -en "$BLUE$blank"
                                tput cup 25 23
                                echo -en "$_2pid"
                        else
				tput cup 25 20
                                echo -en "$BLUE$_2plogin"
                        fi

                        tput cup 20 40
                        echo -en "$BLUE$signin"
			tput cup 25 40
			echo -en "$BLUE$signout"
			tput cup 30 23
			echo -en "$BLUE$join"

		fi
		tput cup $col $row

	done
	
}

function sign_in()
{
	tput clear
	tput sgr0
	tput civis

	tput cup 4 16
	echo " ____ ___ ____ _   _   ___ _   _"
	tput cup 5 16
	echo "/ ___|_ _/ ___| \\ | | |_ _| \\ | |"
	tput cup 6 16
	echo "\\___ \\| | |  _|  \\| |  | ||  \\| |"
	tput cup 7 16
	echo " ___) | | |_| | |\\  |  | || |\\  |"
	tput cup 8 16
	echo "|____/___\\____|_| \\_| |___|_| \\_|"

	id='\a          ID           \a'
	pw='\a          PW           \a'
	dcheck='\a  Duplicate check  \a'
	signin='\a  SIGN IN  \a'
	_exit='\a    EXIT    \a'

	blank='\a                       \a'

	newid=''
	newpw=''

	dchecked=1

	tput cup 10 9
	echo -en "$BLUE$id"
	tput cup 13 9
	echo -en "$BLUE$pw"
	tput cup 10 45
	echo -en "$BLUE$dcheck"
	tput cup 16 21
	echo -en "$BLUE$signin"
	tput cup 16 33
	echo -en "$BLUE$_exit"

	row=9
	col=10

	while :
	do
		tput cup $col $row
		key=$(getkey)
		case $key in 
			UP)
				if [ $col -eq 13 ]
				then
					row=9
					col=10
				elif [ $col -eq 16 ]
				then
					if [ $row -eq 21 ]
					then
						row=9
						col=13
					elif [ $row -eq 33 ]
					then
						row=45
						col=10
					fi
				fi
				;;
			DOWN)
				if [ $col -eq 10 ]
				then
					if [ $row -eq 9 ]
					then
						row=9
						col=13
					elif [ $row -eq 45 ]
					then
						row=33
						col=16
					fi
				elif [ $col -eq 13 ]
				then
					row=21
					col=16
				fi
				;;
			RIGHT)
				if [ $row -eq 9 ]
				then
					row=45
					col=10
				elif [ $row -eq 21 ]
				then
					row=33
					col=16
				fi
				;;
			LEFT)
				if [ $col -eq 10 ]
				then
					row=9
				elif [ $col -eq 16 ]
				then
					row=21
				fi
				;;
			ENTER)
				if [ $col -eq 10 ] && [ $row -eq 45 ] # duplicant check selected
				then
					if [ $dchecked -eq 0 ]
					then
						dchecked=1
						tput sgr0
						tput civis
						tput cup 21 40

						while read line
						do
							oldid=$(echo $line | awk '{ print $1 }')
							if [ "$oldid" == "$newid" ] && [ "$newid" != "" ]
							then
								dpassed=0
								echo -e "같은 ID 존재     \a"
								sleep 3
								tput clear
								tput reset
								tput sgr0
								exit
							fi
						done < userlog.txt
						dpassed=1
						echo -e "회원 가입 가능   \a"
						tput cup $col $row
					fi

				elif [ $col -eq 16 ] && [ $row -eq 21 ] # signin selected
				then
					if [ $dpassed -eq 1 ] && [ "$newpw" != "" ] # duplicant check passed
					then
						echo "$newid $newpw 0 0" >> $userlog
					else # duplicant check nonpassed
						tput clear
						tput reset
						tput sgr0
						exit
					fi
					dpassed=0
					tput clear
					tput reset
					tput sgr0
					exit

				elif [ $col -eq 16 ] && [ $row -eq 33 ] # exit selected
				then
					tput clear
					tput reset
					tput sgr0
					exit
				fi
				;;
		esac

		if [ $col -eq 10 ] && [ $row -eq 9 ] # id selected
		then
			if [ "$pw" == "$newpw" ] # printing password
			then
                                tput cup 13 9
                                echo -en "$BLUE$blank"
                                tput cup 13 11
                                echo -en "$newpw"
                        else
                                tput cup 13 9
                                echo -en "$BLUE$pw"
                        fi
			tput cup 10 45
			echo -en "$BLUE$dcheck"
			tput cup 16 21
			echo -en "$BLUE$signin"
			tput cup 16 33
			echo -en "$BLUE$_exit"

			tput cup 10 9 # getting input of id
			echo -en "$RED$blank"
			tput cup 10 11 
			read newid
			tput cup $col $row
			id=$newid
			dchecked=0 # need new duplicant check
			tput sgr0
			tput cup 21 40
			echo -e "              \a"

		elif [ $col -eq 13 ] && [ $row -eq 9 ] # password selected
		then
			if [ "$id" == "$newid" ] # printing id
			then
				tput cup 10 9
				echo -en "$BLUE$blank"
				tput cup 10 11
				echo -en "$newid"
			else
				tput cup 10 9
				echo -en "$BLUE$id"
			fi
                        tput cup 10 45
                        echo -en "$BLUE$dcheck"
                        tput cup 16 21
                        echo -en "$BLUE$signin"
                        tput cup 16 33
                        echo -en "$BLUE$_exit"

			tput cup 13 9 # getting input of password
			echo -en "$RED$blank"
			tput cup 13 11
			read newpw
			tput cup $col $row
			pw=$newpw

		elif [ $col -eq 10 ] && [ $row -eq 45 ] # dcheck selected
		then
                        if [ "$id" == "$newid" ] # printing id
                        then
                                tput cup 10 9
                                echo -en "$BLUE$blank"
                                tput cup 10 11
                                echo -en "$newid"
                        else
                                tput cup 10 9
                                echo -en "$BLUE$id"
                        fi

                        if [ "$pw" == "$newpw" ] # printing password
                        then
                                tput cup 13 9
                                echo -en "$BLUE$blank"
                                tput cup 13 11
                                echo -en "$newpw"
                        else
                                tput cup 13 9
                                echo -en "$BLUE$pw"
                        fi
                        tput cup 10 45
                        echo -en "$RED$dcheck"
                        tput cup 16 21
                        echo -en "$BLUE$signin"
                        tput cup 16 33
                        echo -en "$BLUE$_exit"

		elif [ $col -eq 16 ] && [ $row -eq 21 ] # signin selected
		then
                        if [ "$id" == "$newid" ] # printing id
                        then
                                tput cup 10 9
                                echo -en "$BLUE$blank"
                                tput cup 10 11
                                echo -en "$newid"
                        else
                                tput cup 10 9
                                echo -en "$BLUE$id"
                        fi

                        if [ "$pw" == "$newpw" ] # printing password
                        then
                                tput cup 13 9
                                echo -en "$BLUE$blank"
                                tput cup 13 11
                                echo -en "$newpw"
                        else
                                tput cup 13 9
                                echo -en "$BLUE$pw"
                        fi

                        tput cup 10 45
                        echo -en "$BLUE$dcheck"
                        tput cup 16 21
                        echo -en "$RED$signin"
                        tput cup 16 33
                        echo -en "$BLUE$_exit"

		elif [ $col -eq 16 ] && [ $row -eq 33 ] # exit selected
		then
                        if [ "$id" == "$newid" ] # printing id
                        then
                                tput cup 10 9
                                echo -en "$BLUE$blank"
                                tput cup 10 11
                                echo -en "$newid"
                        else
                                tput cup 10 9
                                echo -en "$BLUE$id"
                        fi

                        if [ "$pw" == "$newpw" ] # printing password
                        then
                                tput cup 13 9
                                echo -en "$BLUE$blank"
                                tput cup 13 11
                                echo -en "$newpw"
                        else
                                tput cup 13 9
                                echo -en "$BLUE$pw"
                        fi

                        tput cup 10 45
                        echo -en "$BLUE$dcheck"
                        tput cup 16 21
                        echo -en "$BLUE$signin"
                        tput cup 16 33
                        echo -en "$RED$_exit"
		fi
	done

}

function sign_out()
{
	tput clear
	tput sgr0
	tput civis

	tput cup 4 16
	echo " ____ ___ ____ _   _    ___  _   _ _____"
	tput cup 5 16
	echo "/ ___|_ _/ ___| \\ | |  / _ \\| | | |_   _|"
	tput cup 6 16
	echo "\\___ \\| | |  _|  \\| | | | | | | | | | | "
	tput cup 7 16
	echo " ___) | | |_| | |\\  | | |_| | |_| | | |"
	tput cup 8 16
	echo "|____/___\\____|_| \\_|  \\___/ \\___/  |_|"


	id='\a          ID           \a'
        pw='\a          PW           \a'
        signout='\a  SIGN OUT  \a'
        _exit='\a    EXIT    \a'

	blank='\a                       \a'

	newid=''
	newpw=''

	tput cup 12 22
	echo -en "$BLUE$id"
	tput cup 15 22
	echo -en "$BLUE$pw"
	tput cup 20 18
	echo -en "$BLUE$signout"
	tput cup 20 34
	echo -en "$BLUE$_exit"

	row=22
	col=12

	while :
	do
		key=$(getkey)
		case $key in
			UP)
				if [ $col -eq 15 ]
				then
					col=12
				elif [ $col -eq 20 ]
				then 
					row=22
					col=15
				fi
				;;
			DOWN)
				if [ $col -eq 12 ]
				then
					col=15
				elif [ $col -eq 15 ]
				then
					row=18
					col=20
				fi
				;;
			RIGHT) 
				if [ $row -eq 18 ]
				then
					row=34
				elif [ $row -eq 22 ]
				then
					row=34
					col=20
				fi
				;;
			LEFT)
				if [ $row -eq 34 ]
				then
					row=18
				elif [ $row -eq 22 ]
				then
					row=18
					col=20
				fi
				;;
			ENTER)
				if [ $row -eq 18 ] && [ $col -eq 20 ] # signout selected
				then
					while read line
					do
						oldid=$(echo $line | awk '{ print $1 }')
						oldpw=$(echo $line | awk '{ print $2 }')
						if [ "$oldid" == "$newid" ] && [ "$oldpw" == "$newpw" ]
						then 
							sed -i "/$oldid $oldpw/d" userlog.txt
						fi
					done < userlog.txt
					#if the ID does not exist or the password is different
					tput clear
					tput reset
					tput sgr0
					exit

				elif [ $row -eq 34 ] && [ $col -eq 20 ] # exit selected
				then
					tput clear
					tput reset
					tput sgr0
					exit
				fi
				;;
			esac

			if [ $row -eq 22 ] && [ $col -eq 12 ] # id selected
			then
				if [ "$pw" == "$newpw" ] # printing password
				then
					tput cup 15 22
					echo -en "$BLUE$blank"
					tput cup 15 24
					echo -en "$newpw"
				else
					tput cup 15 22
					echo -en "$BLUE$pw"
				fi
				tput cup 20 18
				echo -en "$BLUE$signout"
				tput cup 20 34
				echo -en "$BLUE$_exit"
				
				tput cup 12 22 # getting input of id
				echo -en "$RED$blank"
				tput cup 12 24
				read newid
				tput cup $col $row
				id=$newid
			elif [ $row -eq 22 ] && [ $col -eq 15 ] # pw selected
			then
				if [ "$id" == "$newid" ] # printing id
				then
					tput cup 12 22
					echo -en "$BLUE$blank"
					tput cup 12 24
					echo -en "$newid"
				else
					tput cup 12 22
					echo -en "$BLUE$id"
				fi
                                tput cup 20 18
                                echo -en "$BLUE$signout"
                                tput cup 20 34
                                echo -en "$BLUE$_exit"

				tput cup 15 22 # getting input of password
				echo -en "$RED$blank"
				tput cup 15 24
				read newpw
				tput cup $col $row
				pw=$newpw
			elif [ $row -eq 18 ] && [ $col -eq 20 ] # signout selected
			then
				if [ "$id" == "$newid" ] # printing id
				then
					tput cup 12 22
					echo -en "$BLUE$blank"
					tput cup 12 24
					echo -en "$newid"
				else
					tput cup 12 22
					echo -en "$BLUE$id"
				fi

				if [ "$pw" == "$newpw" ] # printing password
				then
					tput cup 15 22
					echo -en "$BLUE$blank"
					tput cup 15 24
					echo -en "$newpw"
				else
					tput cup 15 22
					echo -en "$BLUE$pw"
				fi
                                tput cup 20 18
                                echo -en "$RED$signout"
                                tput cup 20 34
                                echo -en "$BLUE$_exit"

			elif [ $row -eq 34 ] && [ $col -eq 20 ] # exit selected
			then
                                if [ "$id" == "$newid" ] # printing id
                                then
                                        tput cup 12 22
                                        echo -en "$BLUE$blank"
                                        tput cup 12 24
                                        echo -en "$newid"
                                else
                                        tput cup 12 22
                                        echo -en "$BLUE$id"
                                fi
                                if [ "$pw" == "$newpw" ] # printing password
                                then
                                        tput cup 15 22
                                        echo -en "$BLUE$blank"
                                        tput cup 15 24
                                        echo -en "$newpw"
                                else
                                        tput cup 15 22
                                        echo -en "$BLUE$pw"
                                fi
                                tput cup 20 18
                                echo -en "$BLUE$signout"
                                tput cup 20 34
                                echo -en "$RED$_exit"

			fi
			
			tput cup $col $row
		done

}

function login()
{
	lgcheck=0
        tput clear
	tput reset
        tput sgr0
	tput civis

	if [ $1 -eq 1 ]
	then
		tput cup 4 16
		echo " _ ____    _     ___   ____ ___ _   _"
		tput cup 5 16
		echo "/ |  _ \\  | |   / _ \\ / ___|_ _| \\ | |"
		tput cup 6 16
		echo "| | |_) | | |  | | | | |  _ | ||  \\| |"
		tput cup 7 16
		echo "| |  __/  | |__| |_| | |_| || || |\\  | "
		tput cup 8 16
		echo "|_|_|     |_____\\___/ \\____|___|_| \\_|"
	elif [ $1 -eq 2 ]
	then 
		tput cup 4 14
		echo " ____  ____    _     ___   ____ ___ _   _"
		tput cup 5 14
		echo "|___ \\|  _ \\  | |   / _ \\ / ___|_ _| \\ | |"
		tput cup 6 14
		echo "  __) | |_) | | |  | | | | |  _ | ||  \\| |"
		tput cup 7 14
		echo " / __/|  __/  | |__| |_| | |_| || || |\\| |"
		tput cup 8 14
		echo "|_____|_|     |_____\\___/ \\____|___|_| \\_|"
	fi

        id='\a          ID           \a'
        pw='\a          PW           \a'
        login='\a  LOGIN  \a'
        _exit='\a    EXIT    \a'

        tput cup 12 22
        echo -en "$BLUE$id"
        tput cup 15 22
        echo -en "$BLUE$pw"
        tput cup 20 18
        echo -en "$BLUE$login"
        tput cup 20 34
        echo -en "$BLUE$_exit"

        row=22
        col=12

	blank='\a                       \a'

	newid=''
	newpw=''

        while :
        do
		key=$(getkey)
                case $key in
                        UP)
                                if [ $col -eq 15 ]
                                then
                                        col=12
                                elif [ $col -eq 20 ]
                                then
                                        row=22
                                        col=15
                                fi
                                ;;
                        DOWN)
                                if [ $col -eq 12 ]
                                then
                                        col=15
                                elif [ $col -eq 15 ]
                                then
                                        row=18
                                        col=20
                                fi
                                ;;
                        RIGHT)
                                if [ $row -eq 18 ]
                                then
                                        row=34
                                elif [ $row -eq 22 ]
                                then
                                        row=34
                                        col=20
                                fi
                                ;;
                        LEFT)
                                if [ $row -eq 34 ]
                                then
                                        row=18
                                elif [ $row -eq 22 ]
                                then
                                        row=18
                                        col=20
                                fi
                                ;;
                        ENTER)
                                if [ $row -eq 18 ] && [ $col -eq 20 ] # login selected
                                then

					while read line
					do
						oldid=$(echo $line | awk '{ print $1 }')
						oldpw=$(echo $line | awk '{ print $2 }')
						win=$(echo $line | awk '{ print $3 }')
						lose=$(echo $line | awk '{ print $4 }')

						if [ "$oldid" == "$newid" ] && [ "$oldpw" == "$newpw" ]
						then
							if [ $1 -eq 1 ]
							then
								tput cup 0 0
								_1pid=$newid
								_1ppw=$newpw
								_1pwin=$win
								_1plose=$lose
								lgcheck=1
								break
							elif [ $1 -eq 2 ]
							then
                                                                if [ "$_1pid" == "$newid" ] && [ "$_1ppw" == "$newpw" ] # already logged in at 1p
                                                                then
                                                                        lgcheck=0
                                                                else
                                                                        _2pid=$newid
                                                                        _2ppw=$newpw
									_2pwin=$win
									_2plose=$lose
                                                                        lgcheck=1
                                                                fi
                                                                break
							fi
						fi
					done < userlog.txt

					if [ $lgcheck -eq 1 ]
					then
						start
					fi
					tput clear
					tput reset
					tput sgr0
					exit

                                elif [ $row -eq 34 ] && [ $col -eq 20 ] # exit selected
                                then
					tput clear
					tput reset
					tput sgr0
                                        exit
                                fi
				;;
		esac

		if [ $row -eq 22 ] && [ $col -eq 12 ] # id selected
		then
			if [ "$pw" == "$newpw" ] # printing password
			then
				tput cup 15 22
				echo -en "$BLUE$blank"
				tput cup 15 24
				echo -en "$newpw"
			else
				tput cup 15 22
				echo -en "$BLUE$pw"
			fi
			tput cup 20 18
			echo -en "$BLUE$login"
			tput cup 20 34
			echo -en "$BLUE$_exit"

                        tput cup 12 22 # getting input of id
                        echo -en "$RED$blank"
			tput cup 12 24
			read newid
			tput cup $col $row
			id=$newid
		elif [ $row -eq 22 ] && [ $col -eq 15 ] # pw selected
		then
			if [ "$id" == "$newid" ] # printing id
			then	
				tput cup 12 22
				echo -en "$BLUE$blank"
				tput cup 12 24
				echo -en "$newid"
			else
				tput cup 12 22
				echo -en "$BLUE$id"
			fi
			tput cup 20 18
			echo -en "$BLUE$login"
			tput cup 20 34
			echo -en "$BLUE$_exit"
			
                        tput cup 15 22 # getting input of password
                        echo -en "$RED$blank"
			tput cup 15 24
			read newpw
			tput cup $col $row
			pw=$newpw
		elif [ $row -eq 18 ] && [ $col -eq 20 ] # login selected
		then
                        if [ "$id" == "$newid" ] # printing id
                        then        
                                tput cup 12 22
                                echo -en "$BLUE$blank"
                                tput cup 12 24
                                echo -en "$newid"
                        else
                                tput cup 12 22
                                echo -en "$BLUE$id"
                        fi  
                        if [ "$pw" == "$newpw" ] # printing password
                        then
                                tput cup 15 22
                                echo -en "$BLUE$blank"
                                tput cup 15 24
                                echo -en "$newpw"
                        else
                                tput cup 15 22
                                echo -en "$BLUE$pw"
                        fi

			tput cup 20 18
			echo -en "$RED$login"
			tput cup 20 34
			echo -en "$BLUE$_exit"

		elif [ $row -eq 34 ] && [ $col -eq 20 ] # exit selected
		then
                        if [ "$id" == "$newid" ] # printing id
                        then
                                tput cup 12 22
                                echo -en "$BLUE$blank"
                                tput cup 12 24
                                echo -en "$newid"
                        else
                                tput cup 12 22
                                echo -en "$BLUE$id"
                        fi

                        if [ "$pw" == "$newpw" ] # printing password
                        then
                                tput cup 15 22
                                echo -en "$BLUE$blank"
                                tput cup 15 24
                                echo -en "$newpw"
                        else
                                tput cup 15 22
                                echo -en "$BLUE$pw"
                        fi
			tput cup 20 18
			echo -en "$BLUE$login"
			tput cup 20 34
			echo -en "$RED$_exit"
		fi
		tput cup $col $row
	done

}

function standby()
{
	tput clear
        tput reset
        tput sgr0
        tput civis

	tput cup 2 25
	echo "    _  _____  _    __  ____  __"
	tput cup 3 25
	echo "   / \\|_   _|/ \\   \\ \\/ /\\ \\/ /"
	tput cup 4 25
	echo "  / _ \\ | | / _ \\   \\  /  \\  / "
	tput cup 5 25
	echo " / ___ \\| |/ ___ \\  /  \\  /  \\ "
	tput cup 6 25
	echo "/_/   \\_\\ /_/   \\_\\/_/\\_\\/_/\\_\\"

	tput cup 8 25
	echo "  _     ___  ____  ______   __"
	tput cup 9 25
	echo " | |   / _ \\| __ )| __ ) \\ / /"
	tput cup 10 25
	echo " | |  | | | |  _ \\|  _ \\\\ V / "
	tput cup 11 25
	echo " | |__| |_| | |_) | |_) || | "
	tput cup 12 25
	echo " |_____\\___/|____/|____/ |_| "

	tput cup 16 15
	echo " _ ____"
	tput cup 17 15
	echo "/ |  _ \\"
	tput cup 18 15
	echo "| | |_) |"
	tput cup 19 15
	echo "| |  __/"
	tput cup 20 15
	echo "|_|_|"

	tput cup 16 40
	echo " ____  ____"
	tput cup 17 40
	echo "|___ \\|  _ \\"
	tput cup 18 40
	echo "  __) | |_) |"
	tput cup 19 40
	echo " / __/|  __/"
	tput cup 20 40
	echo "|_____|_|"

	tput cup 22 12
	echo "ID : $_1pid"
	tput cup 23 12
	echo "WIN : $_1pwin"
	tput cup 24 12
	echo "LOSE : $_1plose"

	tput cup 22 37
	echo "ID : $_2pid"
	tput cup 23 37
	echo "WIN : $_2pwin"
	tput cup 24 37
	echo "LOSE : $_2plose"

	_start="\a   START   \a"
	_exit="\a    EXIT    \a"

	tput cup 26 20
	echo -en "$BLUE$_start"
	tput cup 26 40
	echo -en $BLUE$_exit
	row=20
	col=26

	while :
        do
                key=$(getkey)

		tput cup $col $row
                case $key in
                        RIGHT)
                                if [ $row -eq 20 ]
                                then
                                        row=40
                                fi
                                ;;
			LEFT)
                                if [ $row -eq 40 ]
                                then
                                        row=20
                                fi
                                ;;
			ENTER) 
				if [ $row -eq 20 ]
				then
					selection

				elif [ $row -eq 40 ]
				then
					tput clear
					tput reset
					tput sgr0
					tput civis
					exit

				fi
				;;
		esac
		
		if [ $row -eq 20 ]
		then
			echo -en "$RED$_start"
			tput cup 26 40
			echo -en "$BLUE$_exit"
		elif [ $row -eq 40 ]
		then
			echo -en "$RED$_exit"
			tput cup 26 20
			echo -en "$BLUE$_start"
		fi
	done

}

function selection()
{
	tput clear
	tput reset
	tput sgr0
	tput civis

	tput cup 1 25
        echo "    _  _____  _    __  ____  __"
        tput cup 2 25
        echo "   / \\|_   _|/ \\   \\ \\/ /\\ \\/ /"
        tput cup 3 25
        echo "  / _ \\ | | / _ \\   \\  /  \\  / "
        tput cup 4 25
        echo " / ___ \\| |/ ___ \\  /  \\  /  \\ "
        tput cup 5 25
        echo "/_/   \\_\\ /_/   \\_\\/_/\\_\\/_/\\_\\"

	tput cup 7 15
	echo " __  __    _    ____    ____  _____ _     _____ ____ _____"
	tput cup 8 15
	echo "|  \\/  |  / \\  |  _ \\  / ___|| ____| |   | ____/ ___|_   _|"
	tput cup 9 15
	echo "| |\\/| | / _ \\ | |_) | \\___ \\|  _| | |   |  _|| |     | |"
	tput cup 10 15
	echo "| |  | |/ ___ \\|  __/   ___) | |___| |___| |__| |___  | |"
	tput cup 11 15
	echo "|_|  |_|_/   \\_\\_|     |____/|_____|_____|_____\\____| |_|"

	tput cup 16 10
	echo -n "┌───┬───┬───┬───┬───┬───┬───┬───┐"
	tput cup 17 10
	echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 18 10
	echo -n "├───┼───┼───┼───┼───┼───┼───┼───┤"
	tput cup 19 10
	echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 20 10
        echo -n "├───┼───┼───┼───┼───┼───┼───┼───┤"
	tput cup 21 10
	echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 22 10
        echo -n "├───┼───┼───┼───┼───┼───┼───┼───┤"
	tput cup 23 10
        echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 24 10
        echo -n "├───┼───┼───┼───┼───┼───┼───┼───┤"
	tput cup 25 10
        echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 26 10
        echo -n "├───┼───┼───┼───┼───┼───┼───┼───┤"
	tput cup 27 10
        echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 28 10
        echo -n "├───┼───┼───┼───┼───┼───┼───┼───┤"
	tput cup 29 10
        echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 30 10
        echo -n "├───┼───┼───┼───┼───┼───┼───┼───┤"
	tput cup 31 10
	echo -n "│   │   │   │   │   │   │   │   │"
	tput cup 32 10
	echo -n "└───┴───┴───┴───┴───┴───┴───┴───┘"

	sel="$YELLOW███$WHITE"

	tput cup 16 45
        echo -en "┌───┬───┬───┬───┬───┬───┬───┬───┐"
        tput cup 17 45
        echo -en "│   │   │   │   │   │   │   │   │"
        tput cup 18 45
        echo -en "├───┼───┼───┼───┼───┼───┼───┼───┤"
        tput cup 19 45
        echo -en "│   │$sel│   │   │   │   │$sel│   │"
        tput cup 20 45
        echo -en "├───┼───┼───┼───┼───┼───┼───┼───┤"
        tput cup 21 45
        echo -en "│   │   │$sel│   │   │$sel│   │   │"
        tput cup 22 45
        echo -en "├───┼───┼───┼───┼───┼───┼───┼───┤"
        tput cup 23 45
        echo -en "│   │   │   │$sel│$sel│   │   │   │"
        tput cup 24 45
        echo -en "├───┼───┼───┼───┼───┼───┼───┼───┤"
        tput cup 25 45
        echo -en "│   │   │   │$sel│$sel│   │   │   │"
        tput cup 26 45
        echo -en "├───┼───┼───┼───┼───┼───┼───┼───┤"
        tput cup 27 45
        echo -en "│   │   │$sel│   │   │$sel│   │   │"
        tput cup 28 45
        echo -en "├───┼───┼───┼───┼───┼───┼───┼───┤"
        tput cup 29 45
        echo -en "│   │$sel│   │   │   │   │$sel│   │"
        tput cup 30 45
        echo -en "├───┼───┼───┼───┼───┼───┼───┼───┤"
        tput cup 31 45
        echo -en "│   │   │   │   │   │   │   │   │"
        tput cup 32 45
        echo -en "└───┴───┴───┴───┴───┴───┴───┴───┘"

	map1="\a     MAP 1     \a"
	map2="\a     MAP 2     \a"

	tput cup 35 12
	echo -en "$BLUE$map1"
	tput cup 35 47
	echo -en "$BLUE$map2"
	
	col=35
	row=12

	while :
        do
                key=$(getkey)

                tput cup $col $row
                case $key in
                        RIGHT)
                                if [ $row -eq 12 ]
                                then
                                        row=47
                                fi
                                ;;
                        LEFT)
                                if [ $row -eq 47 ]
                                then
                                        row=12
                                fi
                                ;;
                        ENTER)
                                if [ $row -eq 12 ]
                                then
                                        map_1

                                elif [ $row -eq 47 ]
                                then
					map_2
                                fi
                                ;;
                esac

                if [ $row -eq 12 ] #map1
                then
                        echo -en "$RED$map1"
                        tput cup 35 47
                        echo -en "$BLUE$map2"
                elif [ $row -eq 47 ] #map2
                then
                        echo -en "$RED$map2"
                        tput cup 35 12
                        echo -en "$BLUE$map1"
                fi
	done
}

function map_1()
{
        tput clear
        tput reset
        tput sgr0
        tput civis

        tput cup 1 25
        echo "    _  _____  _    __  ____  __"
        tput cup 2 25
        echo "   / \\|_   _|/ \\   \\ \\/ /\\ \\/ /"
        tput cup 3 25
        echo "  / _ \\ | | / _ \\   \\  /  \\  / "
        tput cup 4 25
        echo " / ___ \\| |/ ___ \\  /  \\  /  \\ "
        tput cup 5 25
        echo "/_/   \\_\\ /_/   \\_\\/_/\\_\\/_/\\_\\"

	tput cup 8 24
        echo -en "┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐"
	tput cup 9 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 10 24
	echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 11 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 12 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 13 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 14 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 15 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 16 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 17 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 18 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 19 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 20 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 21 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 22 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 23 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 24 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 25 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 26 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 27 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 28 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 29 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 30 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 31 24
        echo -en "│     │     │     │     │     │     │     │     │"
	tput cup 32 24
        echo -en "└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘"

	cursor="█████"
	cur_reset="$REVERSE█████$RETURN"
	colored="$BLUE_c█████$RETURN"

	_1pcnt=0
	_2pcnt=0

	col1=(0 0 0 0 0 0 0 0)
	col2=(0 0 0 0 0 0 0 0)
	col3=(0 0 0 0 0 0 0 0)
	col4=(0 0 0 0 0 0 0 0)
	col5=(0 0 0 0 0 0 0 0)
	col6=(0 0 0 0 0 0 0 0)
	col7=(0 0 0 0 0 0 0 0)
	col8=(0 0 0 0 0 0 0 0)
	
	tput cup 34 20
        echo "1p : $_1pcnt"
        tput cup 34 78
        echo "2p : $_2pcnt"

	x=25
	y=9

	while :
	do
		key=$(getkey)

		case $key in
			UP)
				if [ $(expr $y - 3) -ge 9 ]
				then
					y=$(expr $y - 3)
				fi
				;;
			DOWN)
				if [ $(expr $y + 3) -le 30 ]
				then
					y=$(expr $y + 3)
				fi
				;;
			RIGHT)
				if [ $(expr $x + 6) -le 67 ]
				then
					x=$(expr $x + 6)
				fi
				;;
			LEFT)
				if [ $(expr $x - 6) -ge 25 ]
				then
					x=$(expr $x - 6)
				fi
				;;
			ENTER)
				xx=$((($x-25)/6))
				if [ $y -eq 9 ]
				then
					if [ ${col1[$xx]} -eq 0 ]
					then
						_1pcnt=$(expr $_1pcnt + 1)
						col1[$xx]=1
					fi
				elif [ $y -eq 12 ]
				then
					if [ ${col2[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col2[$xx]=1
                                        fi
				elif [ $y -eq 15 ]
				then
					if [ ${col3[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col3[$xx]=1
                                        fi

				elif [ $y -eq 18 ]
				then
					if [ ${col4[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col4[$xx]=1
                                        fi
				elif [ $y -eq 21 ]
				then
					if [ ${col5[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col5[$xx]=1
                                        fi
				elif [ $y -eq 24 ]
				then
					if [ ${col6[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col6[$xx]=1
                                        fi
				elif [ $y -eq 27 ]
				then
					if [ ${col7[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col7[$xx]=1
                                        fi
				elif [ $y -eq 30 ]
				then
					if [ ${col8[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col8[$xx]=1
                                        fi
				fi
				;;
		esac

		for i in {9..30..3}
		do
			if [ $i -eq 9 ]
                        then
				for j in {1..8}
				do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
					if [ ${col1[$jj]} -eq 1 ]
					then
						echo -en $colored
						tput cup $(($i+1)) $((jj*6+25))
						echo -en $colored
					else
						echo -en $cur_reset
						tput cup $(($i+1)) $((jj*6+25))
						echo -en $cur_reset
					fi
				done
			elif [ $i -eq 12 ]
			then
				for j in {1..8}
                                do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
                                        if [ ${col2[$jj]} -eq 1 ]
                                        then
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
					else
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
			elif [ $i -eq 15 ]
			then
				for j in {1..8}
                                do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
                                        if [ ${col3[$jj]} -eq 1 ]
                                        then
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
					else
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
			elif [ $i -eq 18 ]
			then
				for j in {1..8}
                                do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
                                        if [ ${col4[$jj]} -eq 1 ]
                                        then
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored

					else
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
			elif [ $i -eq 21 ]
			then
				for j in {1..8}
                                do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
                                        if [ ${col5[$jj]} -eq 1 ]
					then
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
					else
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
			elif [ $i -eq 24 ]
			then
				for j in {1..8}
				do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
					if [ ${col6[$jj]} -eq 1 ]
					then
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
					else
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
					fi
				done
			elif [ $i -eq 27 ]
			then
				for j in {1..8}
                                do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
                                        if [ ${col7[$jj]} -eq 1 ]
                                        then
                                                echo -en $colored
						tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
					else
                                                echo -en $cur_reset
						tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
			elif [ $i -eq 30 ]
			then
				for j in {1..8}
                                do
					jj=$(($j-1))
					tput cup $i $((jj*6+25))
                                        if [ ${col8[$jj]} -eq 1 ]
                                        then
                                                echo -en $colored
						tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
					else
                                                echo -en $cur_reset
						tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
			fi
		done

		tput cup $y $x
		echo -en $cursor
		tput cup $(($y+1)) $x
		echo -en $cursor

		tput cup 34 20
		echo "1p : $_1pcnt"
		tput cup 34 78
		echo "2p : $_2pcnt"

	done

}

function map_2()
{
	tput clear
        tput reset
        tput sgr0
        tput civis

        tput cup 1 25
        echo "    _  _____  _    __  ____  __"
        tput cup 2 25
        echo "   / \\|_   _|/ \\   \\ \\/ /\\ \\/ /"
        tput cup 3 25
        echo "  / _ \\ | | / _ \\   \\  /  \\  / "
        tput cup 4 25
        echo " / ___ \\| |/ ___ \\  /  \\  /  \\ "
        tput cup 5 25
        echo "/_/   \\_\\ /_/   \\_\\/_/\\_\\/_/\\_\\"

	sel="$YELLOW█████$WHITE"

	tput cup 8 24
        echo -en "┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐"
        tput cup 9 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 10 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 11 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
        tput cup 12 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 13 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 14 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
        tput cup 15 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 16 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 17 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
        tput cup 18 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 19 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 20 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
        tput cup 21 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 22 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 23 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
        tput cup 24 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 25 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 26 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
        tput cup 27 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 28 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 29 24
        echo -en "├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤"
	tput cup 30 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 31 24
        echo -en "│     │     │     │     │     │     │     │     │"
        tput cup 32 24
        echo -en "└─────┴─────┴─────┴─────┴─────┴─────┴─────┴─────┘"

        tput cup 12 31
        echo -en $sel
	tput cup 13 31
	echo -en $sel

        tput cup 12 61
        echo -en $sel
	tput cup 13 61
	echo -en $sel

        tput cup 15 37
        echo -en $sel
	tput cup 16 37
	echo -en $sel

	tput cup 15 55
	echo -en $sel
	tput cup 16 55
	echo -en $sel

        tput cup 18 43
        echo -en $sel
	tput cup 19 43
	echo -en $sel

        tput cup 18 49
        echo -en $sel
	tput cup 19 49
	echo -en $sel

        tput cup 21 43
        echo -en $sel
	tput cup 22 43
	echo -en $sel

        tput cup 21 49 
        echo -en $sel
	tput cup 22 49
	echo -en $sel

        tput cup 24 37
        echo -en $sel
	tput cup 25 37
	echo -en $sel

        tput cup 24 55
        echo -en $sel
	tput cup 25 55
	echo -en $sel

        tput cup 27 31
        echo -en $sel
	tput cup 28 31
	echo -en $sel

	tput cup 27 61
	echo -en $sel
	tput cup 28 61
	echo -en $sel

	cursor="█████"
        cur_reset="$REVERSE█████$RETURN"
        colored="$BLUE_c█████$RETURN"

        _1pcnt=0
        _2pcnt=0

        col1=(0 0 0 0 0 0 0 0)
        col2=(0 0 0 0 0 0 0 0)
        col3=(0 0 0 0 0 0 0 0)
        col4=(0 0 0 0 0 0 0 0)
        col5=(0 0 0 0 0 0 0 0)
        col6=(0 0 0 0 0 0 0 0)
        col7=(0 0 0 0 0 0 0 0)
        col8=(0 0 0 0 0 0 0 0)

        tput cup 34 20
        echo "1p : $_1pcnt"
        tput cup 34 78
        echo "2p : $_2pcnt"

        x=25
        y=9

	while :
        do
                key=$(getkey)

                case $key in
                        UP)
                                if [ $(expr $y - 3) -ge 9 ]
                                then
                                        y=$(expr $y - 3)
                                fi
                                ;;
                        DOWN)
                                if [ $(expr $y + 3) -le 30 ]
                                then
                                        y=$(expr $y + 3)
                                fi
                                ;;
                        RIGHT)
                                if [ $(expr $x + 6) -le 67 ]
                                then
                                        x=$(expr $x + 6)
                                fi
                                ;;
                        LEFT)
                                if [ $(expr $x - 6) -ge 25 ]
                                then
                                        x=$(expr $x - 6)
                                fi
                                ;;
			ENTER)
                                xx=$((($x-25)/6))
                                if [ $y -eq 9 ]
                                then
                                        if [ ${col1[$xx]} -eq 0 ]
                                        then
						_1pcnt=$(expr $_1pcnt + 1)
                                                col1[$xx]=1
                                        fi
                                elif [ $y -eq 12 ] && [ $xx -ne 1 ] && [ $xx -ne 6 ]
                                then
                                        if [ ${col2[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col2[$xx]=1
                                        fi
                                elif [ $y -eq 15 ] && [ $xx -ne 2 ] && [ $xx -ne 5 ]
                                then
                                        if [ ${col3[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col3[$xx]=1
                                        fi

                                elif [ $y -eq 18 ] && [ $xx -ne 3 ] && [ $xx -ne 4 ]
                                then
                                        if [ ${col4[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col4[$xx]=1
                                        fi
                                elif [ $y -eq 21 ] && [ $xx -ne 3 ] && [ $xx -ne 4 ]
                                then
                                        if [ ${col5[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col5[$xx]=1
                                        fi
				elif [ $y -eq 24 ] && [ $xx -ne 2 ] && [ $xx -ne 5 ]
                                then
                                        if [ ${col6[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col6[$xx]=1
                                        fi
                                elif [ $y -eq 27 ] && [ $xx -ne 1 ] && [ $xx -ne 6 ]
                                then
                                        if [ ${col7[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col7[$xx]=1
                                        fi
                                elif [ $y -eq 30 ]
                                then
                                        if [ ${col8[$xx]} -eq 0 ]
                                        then
                                                _1pcnt=$(expr $_1pcnt + 1)
                                                col8[$xx]=1
                                        fi
                                fi
                                ;;
                esac

		for i in {9..30..3}
                do
                        if [ $i -eq 9 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))
                                        if [ ${col1[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
                        elif [ $i -eq 12 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))
                                        if [ ${col2[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi

					if [ $jj -eq 1 ] || [ $jj -eq 6 ]
                                        then
                                                tput cup $i $((jj*6+25))
                                                echo -en $sel
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $sel
                                        fi

                                done

			elif [ $i -eq 15 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))

                                        if [ ${col3[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi

					if [ $jj -eq 2 ] || [ $jj -eq 5 ]
                                        then
                                                tput cup $i $((jj*6+25))
                                                echo -en $sel
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $sel
                                        fi

                                done

			elif [ $i -eq 18 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))

                                        if [ ${col4[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored

                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi

					if [ $jj -eq 3 ] || [ $jj -eq 4 ]
                                        then
                                                tput cup $i $((jj*6+25))
                                                echo -en $sel
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $sel
                                        fi

                                done
                        elif [ $i -eq 21 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))

                                        if [ ${col5[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi

					if [ $jj -eq 3 ] || [ $jj -eq 4 ]
                                        then
                                                tput cup $i $((jj*6+25))
                                                echo -en $sel
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $sel
                                        fi
                                done
			elif [ $i -eq 24 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))
                                        if [ ${col6[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi

					if [ $jj -eq 2 ] || [ $jj -eq 5 ]
                                        then
                                                tput cup $i $((jj*6+25))
                                                echo -en $sel
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $sel
                                        fi

                                done
                        elif [ $i -eq 27 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))
                                        if [ ${col7[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi

					if [ $jj -eq 1 ] || [ $jj -eq 6 ]
                                        then
                                                tput cup $i $((jj*6+25))
                                                echo -en $sel
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $sel
                                        fi

                                done
			elif [ $i -eq 30 ]
                        then
                                for j in {1..8}
                                do
                                        jj=$(($j-1))
                                        if [ ${col8[$jj]} -eq 1 ]
                                        then
						tput cup $i $((jj*6+25))
                                                echo -en $colored
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $colored
                                        else
						tput cup $i $((jj*6+25))
                                                echo -en $cur_reset
                                                tput cup $(($i+1)) $((jj*6+25))
                                                echo -en $cur_reset
                                        fi
                                done
                        fi
                done

                tput cup $y $x
                echo -en $cursor
                tput cup $(($y+1)) $x
                echo -en $cursor

                tput cup 34 20
                echo "1p : $_1pcnt"
                tput cup 34 78
                echo "2p : $_2pcnt"

        done

}
                                                             
function main()
{
	tput civis
	_1pid=""
	_1ppw=""
	_1pwin=0
	_1plose=0

	_2pid=""
	_2pp2=""
	_2pwin=0
	_2plose=0

	start
}

main
