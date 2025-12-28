@echo off
cd /d C:\Users\RicardoValadez\dof-robot> 

robot ^
--output logs/output_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.xml ^
--log logs/log_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%.html ^
--report logs/report_%DATE:~10,4%%DATE:~7,2%%DATE:~4,2%.html ^
scripts\exchange_rate.robot
