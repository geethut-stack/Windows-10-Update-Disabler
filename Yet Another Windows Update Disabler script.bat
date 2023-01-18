::todo:
::cant have one task, so many tasks, one for each trigger
::the ability to adjust local system drive (location of software distribution), where to place script
::hostname if for another system (for host, leave as `hostname`, or set as drive C:\, or remote \\server\dir)
::adjust variables option, where it shows the default, hit enter to not change (just like easy-rsa)
::detection of event IDs

::creation of a task to reverse the process
::running of the task to enable updates
::deletion of the task to enable updates (no disabling of it because it would be manual only)

::consolidate XML files into one
::make task using XML, into same location as the script

::for the future: manage task of another computer

@echo off

:begin

echo Welcome to Yet Another Windows Update Disabler script
echo THIS SCRIPT MUST BE RUN AS ADMIN
echo Recommended usage: run tasks 1, 2, 3, 5, then reboot
echo Places a simple script in C:\Windows,
echo one for enabling updates,
echo and another for disabling and deleting currently downloaded updates
echo and creates tasks in Task Scheduler that will run it as SYSTEM
echo according to events seen in Event Viewer, and per restart
echo this version of the script assumes local system is C:\Windows\
echo feel free to edit the script if your system is non-standard


echo YOU SHOULD RESTART AFTER USING THE SCRIPT


echo Select a task:
echo =============
echo -
echo 1. Plant scripts and XML in C:\Windows for Enabling and Disabling and Task
echo 2. Create Tasks for Disabling
echo 3. Run Disabling Updates Task Now
echo 4. Disable Tasks for Disabling Updates
echo 5. Enable Tasks for Disabling Updates
echo 6. Enable Updates: Make Enabling Updates Task, Run it, then delete all tasks
echo 7. Delete all tasks and scripts
echo 8. Exit
echo -

::hostname=`hostname`

set /p op=Type option number and hit enter: 
if "%op%"=="1" goto op1
if "%op%"=="2" goto op2
if "%op%"=="3" goto op3
if "%op%"=="4" goto op4
if "%op%"=="5" goto op5
if "%op%"=="6" goto op6
if "%op%"=="7" goto op7
if "%op%"=="8" goto exit

echo Please Pick an option
goto begin



:op1
echo you picked option 1

echo Planting NOUPDATES.bat and UPDATESON.bat

ECHO sc stop "wuauserv" >> C:\Windows\NOUPDATES.bat
ECHO sc config "wuauserv" start= disabled >> C:\Windows\NOUPDATES.bat
ECHO sc stop "WaaSMedicSvc" >> C:\Windows\NOUPDATES.bat
ECHO sc config "WaaSMedicSvc" start= disabled >> C:\Windows\NOUPDATES.bat
ECHO sc stop "UsoSvc" >> C:\Windows\NOUPDATES.bat
ECHO sc config "UsoSvc" start= disabled >> C:\Windows\NOUPDATES.bat
ECHO del /S /Q C:\Windows\SoftwareDistribution\* >> C:\Windows\NOUPDATES.bat
ECHO rd /S /Q C:\Windows\SoftwareDistribution >> C:\Windows\NOUPDATES.bat

ECHO sc start "wuauserv" >> C:\Windows\UPDATESON.bat
ECHO sc config "wuauserv" start= auto >> C:\Windows\UPDATESON.bat
ECHO sc start "WaaSMedicSvc" >> C:\Windows\UPDATESON.bat
ECHO sc config "WaaSMedicSvc" start= auto >> C:\Windows\UPDATESON.bat
ECHO sc start "UsoSvc" >> C:\Windows\UPDATESON.bat
ECHO sc config "UsoSvc" start= auto >> C:\Windows\UPDATESON.bat


echo Planting NOUPDATES.xml

del C:\Windows\NOUPDATES.xml

ECHO ^<?xml version="1.0" encoding="UTF-16"?^> >> C:\Windows\NOUPDATES.xml
ECHO ^<Task version="1.4" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^> >> C:\Windows\NOUPDATES.xml
ECHO. ^<RegistrationInfo^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<Date^>2019-01-05T18:50:42.9236704^</Date^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<Author^>SYSTEM^</Author^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<URI^>\TURN OFF WINDOWS UPDATE^</URI^> >> C:\Windows\NOUPDATES.xml
ECHO. ^</RegistrationInfo^> >> C:\Windows\NOUPDATES.xml
ECHO. ^<Triggers^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<LogonTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Enabled^>true^</Enabled^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</LogonTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<EventTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Enabled^>true^</Enabled^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Subscription^>^&lt;QueryList^&gt;^&lt;Query Id="0" Path="Microsoft-Windows-WindowsUpdateClient/Operational"^&gt;^&lt;Select Path="Microsoft-Windows-WindowsUpdateClient/Operational"^&gt;*[System[Provider[@Name='Microsoft-Windows-WindowsUpdateClient'] and EventID=41]]^&lt;/Select^&gt;^&lt;/Query^&gt;^&lt;/QueryList^&gt;^</Subscription^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</EventTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<EventTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Enabled^>true^</Enabled^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Subscription^>^&lt;QueryList^&gt;^&lt;Query Id="0" Path="System"^&gt;^&lt;Select Path="System"^&gt;*[System[Provider[@Name='Microsoft-Windows-WindowsUpdateClient'] and EventID=44]]^&lt;/Select^&gt;^&lt;/Query^&gt;^&lt;/QueryList^&gt;^</Subscription^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</EventTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<BootTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Enabled^>true^</Enabled^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</BootTrigger^> >> C:\Windows\NOUPDATES.xml
ECHO. ^</Triggers^> >> C:\Windows\NOUPDATES.xml
ECHO. ^<Principals^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<Principal id="Author"^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<UserId^>S-1-5-18^</UserId^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<RunLevel^>HighestAvailable^</RunLevel^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</Principal^> >> C:\Windows\NOUPDATES.xml
ECHO. ^</Principals^> >> C:\Windows\NOUPDATES.xml
ECHO. ^<Settings^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<MultipleInstancesPolicy^>Parallel^</MultipleInstancesPolicy^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<DisallowStartIfOnBatteries^>false^</DisallowStartIfOnBatteries^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<StopIfGoingOnBatteries^>false^</StopIfGoingOnBatteries^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<AllowHardTerminate^>true^</AllowHardTerminate^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<StartWhenAvailable^>true^</StartWhenAvailable^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<RunOnlyIfNetworkAvailable^>false^</RunOnlyIfNetworkAvailable^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<IdleSettings^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<StopOnIdleEnd^>false^</StopOnIdleEnd^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<RestartOnIdle^>false^</RestartOnIdle^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</IdleSettings^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<AllowStartOnDemand^>true^</AllowStartOnDemand^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<Enabled^>true^</Enabled^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<Hidden^>false^</Hidden^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<RunOnlyIfIdle^>false^</RunOnlyIfIdle^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<DisallowStartOnRemoteAppSession^>false^</DisallowStartOnRemoteAppSession^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<UseUnifiedSchedulingEngine^>true^</UseUnifiedSchedulingEngine^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<WakeToRun^>false^</WakeToRun^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<ExecutionTimeLimit^>PT1H^</ExecutionTimeLimit^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<Priority^>7^</Priority^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<RestartOnFailure^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Interval^>PT1M^</Interval^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Count^>3^</Count^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</RestartOnFailure^> >> C:\Windows\NOUPDATES.xml
ECHO. ^</Settings^> >> C:\Windows\NOUPDATES.xml
ECHO. ^<Actions Context="Author"^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^<Exec^> >> C:\Windows\NOUPDATES.xml
ECHO.     ^<Command^>"C:\Windows\NOUPDATES.bat"^</Command^> >> C:\Windows\NOUPDATES.xml
ECHO.   ^</Exec^> >> C:\Windows\NOUPDATES.xml
ECHO. ^</Actions^> >> C:\Windows\NOUPDATES.xml
ECHO ^</Task^> >> C:\Windows\NOUPDATES.xml





echo Done!
echo -
echo -
echo -


goto begin









:op2
echo you picked option 2

echo Creating task set NOUPDATES



schtasks /Create /XML C:\Windows\NOUPDATES.xml /TN NOUPDATES



::schtasks /Create /RU SYSTEM /SC ONSTART /EC System /TN NOUPDATES-START /TR "C:\Windows\NOUPDATES.bat" /RL HIGHEST

::schtasks /Create /RU SYSTEM /SC ONLOGON /EC System /TN NOUPDATES-LOGON /TR "C:\Windows\NOUPDATES.bat" /RL HIGHEST

::schtasks /Create /RU SYSTEM /SC ONEVENT /MO *[System[Provider[@Name='Microsoft-Windows-WindowsUpdateClient']]] /EC System /TN NOUPDATES-EVENT /TR "C:\Windows\NOUPDATES.bat" /RL HIGHEST



echo Done!
echo -
echo -
echo -


goto begin










:op3
echo you picked option 3

echo Running Task NOUPDATES

schtasks /Run /TN NOUPDATES

timeout 10

schtasks /End /TN NOUPDATES

echo Done!
echo -
echo -
echo -


goto begin





:op4
echo you picked option 4

echo Disabling Task set NOUPDATES

::schtasks /Change /TN NOUPDATES-START /DISABLE

::schtasks /Change /TN NOUPDATES-LOGON /DISABLE

schtasks /Change /TN NOUPDATES /DISABLE

echo Done!
echo -
echo -
echo -


goto begin




:op5
echo you picked option 5

echo Enabling Task set NOUPDATES

::schtasks /Change /TN NOUPDATES-START /ENABLE

::schtasks /Change /TN NOUPDATES-LOGON /ENABLE

schtasks /Change /TN NOUPDATES /ENABLE

echo Done!
echo -
echo -
echo -


goto begin








:op6
echo you picked option 6

echo enabling windows updates


echo Creating manual task UPDATESON

schtasks /Create /RU SYSTEM /SC ONLOGON /EC System /TN UPDATESON /TR "C:\Windows\UPDATESON.bat" /RL HIGHEST


schtasks /Run /TN UPDATESON

timeout 10

schtasks /End /TN UPDATESON


::schtasks /Delete /TN UPDATESON
::schtasks /Delete /TN NOUPDATES

goto begin












:op7
echo you picked option 7

echo Removing Scripts and Tasks

::schtasks /Delete /TN NOUPDATES-START

::schtasks /Delete /TN NOUPDATES-LOGON

schtasks /Delete /TN NOUPDATES

schtasks /Delete /TN UPDATESON


del C:\Windows\NOUPDATES.bat
del C:\Windows\NOUPDATES.xml
del C:\Windows\UPDATESON.bat


echo Done!
echo -
echo -
echo -


goto begin








:exit
@exit
