@echo on
goto skip_comment
rem  DECtalk for windows CE build script
rem 10-apr-1999	mfg added ARM support and WINce 211 support
rem 08-feb-2000	mfg added Access32 support
rem 08-feb-2000	mfg added email reader build for 211 it is not supported for 200
rem 13-apr-2000 cab added windic build for 211
rem 09-aug-2000 cab removed windic from wce200 build and fix error in name of folder
rem 14-sep-2000 cab Added Ceagent to build
rem 18-oct-2000 cab Added French to build
rem 				Convert .mak to .vcn for make for Embedded Visual studio
rem					Changed VCROOT to embedded tools directory
rem 25-oct-2000	cab	Added makefile for wce211 PALM SIZE PC and WCE300 POCKET PC
rem 26-oct-2000	cab	Removed mailread and windic for PALM SIZE PC
rem 30-oct-2000	cab	Removed dtsample and windic for Pocket PC
rem 11-dec-2000 cab
rem					2. Fixed error of incorrect path to x86em changed to arm
rem 13-dec-2000 cab 1. Added a message of not build for static and dll workspaces.
rem 16-feb-2001 cab	Added error with build process variables
rem 20-feb-2001 cab	1. Fixed errors in goto, labels and if 
rem					2. Created output of errors messages to win_ce.txt
rem	07-mar-2001 cab	Fixed script errors for error outputs
rem	13-mar-2001 cab	Fixed script errors for error outputs
rem 19-mar-2001 cab Fixed error of sh3 to sh
rem 28-mar-2001 cab	Fixed build_log error for cetalk for palm-size
rem 29-mar-2001 cab	1. Fixed missing d for cetalk
rem					2. Removed extra folder from .\dtalkml\build
rem 30-mar-2001 cab	1. Added dtsample for wce300
rem					2. unrem stuff for dtsample
rem					3.change sh3 to sh
rem	05-apr-2001 cab	1. Added force build for dtalkml
rem 13-apr-2001 cab Removed /A option
	
:skip_comment

@echo To override the default settings,
@echo Type the name of this batch file followed by a platform choice: WCE100 WCE101 WCE200 
@echo Example: wcesh WCE200

set PLATFORM=wce200
set ceagent_path=tools\ceagent
set build_wce_static=build\cestatic
set build_wce_dll=build\cedll
set build_static=build\static
set build_dll=build\dll
set INCLUDE=%INCLUDE%

rem bug parameters
set bug_arm_ce=0
set bug_arm_cedll=0
set bug_mips_ce=0
set bug_mips_cedll=0
set bug_sh_cedll=0
set bug_sh_cedll=0
set bug_sh4_ce=0
set bug_sh4_cedll=0
set bug_x86em_ce=0
set bug_x86em_cedll=0

echo *** Building CeAgent ***
cd %ceagent_path%
nmake /NOLOGO /fceAgent.mak CFG="ceAgent - Win32 Release"
if NOT exist .\build\release\ceagent.exe echo Workspace %blddrv%%bldpath%\ceagent.dsw for Win32 Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

rem return to root (rnd\ad\product)
cd ..\..


set VCROOT=D:\Program Files\Microsoft eMbedded Tools
set DEVROOT=D:\Windows CE Tools
set SDKROOT=D:\Windows CE Tools

rem goto :wce_palm
if "%1"=="WCE211" goto build_wce211
if "%1"=="wce211" goto build_wce211
if "%1"=="wce300" goto build_wce300
if "%1"=="WCE300" goto build_wce300
if "%1"=="WCE211ML" goto build_wce211ML
if "%1"=="wce211ml" goto build_wce211ML
if "%1"=="WCE200ML" goto build_wce200ML
if "%1"=="wce200ml" goto build_wce200ML
if "%1"=="WCE300ML" goto build_wce300ML
if "%1"=="wce300ml" goto build_wce300ML

if "%1"=="" goto default
set PLATFORM=%1
goto settings

:default
if "%1"=="" set PLATFORM=WCE200

:settings
set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\MS HPC\include;%DEVROOT%\%PLATFORM%\MS HPC\mfc\include;


rem if been built once move back so we don't have to build again
if exist .\dapi\build\%PLATFORM%\cedll 					move .\dapi\build\%PLATFORM%\cedll .\dapi\build\cedll  
if exist .\dapi\build\%PLATFORM%\cestatic 				move .\dapi\build\%PLATFORM%\cestatic .\dapi\build\cestatic 
if exist .\samplece\CEtalk\build\%PLATFORM%\dll 		move .\samplece\CEtalk\build\%PLATFORM%\dll .\samplece\CEtalk\build\dll  
if exist .\samplece\CEtalk\build\%PLATFORM%\static		move .\samplece\CEtalk\build\%PLATFORM%\static .\samplece\CEtalk\build\static  
if exist .\samplece\Dtsample\build\%PLATFORM%\dll 		move .\samplece\Dtsample\build\%PLATFORM%\dll .\samplece\Dtsample\build\dll 
if exist .\samplece\Dtsample\build\%PLATFORM%\static 	move .\samplece\Dtsample\build\%PLATFORM%\static .\samplece\Dtsample\build\static
if exist .\dtalkml\build\%PLATFORM%\ce					move .\dtalkml\build\%PLATFORM%\ce .\dtalkml\build


rem set paths for DECtalk CE build  WCE200

cd .\dapi\src

@echo make the static and dynamic library version of dectalk for the mips platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\mips;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\mips;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200  CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log 
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib set bug_mips_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll set bug_mips_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE MIPS) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll set bug_mips_cedll=1

@echo make the static and dynamic library versions of dectalk for the sh platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\sh3;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\sh3;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=200  CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib set bug_sh_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll set bug_sh_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE SH3) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll set bug_sh_cedll=1

@echo make the static and dynamic library versions of dectalk for the x86em platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\X86em;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=200  CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce200 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib set bug_x86em_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll set bug_x86em_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Access32" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce200 Win32 (WCE X86EM) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll set bug_x86em_cedll=1

@echo build DTSample

cd .\..\..\samplece\Dtsample

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\mips;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\mips;

if "%bug_mips_ce%"=="1" goto wce200_dtsample_mips_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_dtsample_mips_ce

if "%bug_mips_cedll%"=="1" goto wce200_dtsample_mips_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_dtsample_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\sh3;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\sh3;

if "%bug_sh_ce%"=="1" goto wce200_dtsample_sh_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_dtsample_sh_ce

if "%bug_sh_cedll%"=="1" goto wce200_dtsample_sh_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_dtsample_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce200_dtsample_x86em_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_dtsample_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce200_dtsample_x86em_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce200 Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_dtsample_x86em_cedll

rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug English UK Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug French Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug German Dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"


@echo build CEtalk

cd .\..\CEtalk

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\mips;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\mips;

if "%bug_mips_ce%"=="1" goto wce200_cetalk_mips_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200  Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_cetalk_mips_ce

if "%bug_mips_cedll%"=="1" goto wce200_cetalk_mips_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_cetalk_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\sh3;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\sh3;

if "%bug_sh_ce%"=="1" goto wce200_cetalk_sh_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_cetalk_sh_ce

if "%bug_sh_cedll%"=="1" goto wce200_cetalk_sh_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_cetalk_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce200_cetalk_x86em_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_static%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_cetalk_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce200_cetalk_x86em_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\sp\release\\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist .\%build_dll%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce200 Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce200_cetalk_x86em_cedll

rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Spanish dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Latin American dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug English UK dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug French dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug German dll" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"

cd .\..\..

:build_wce200ML
set PLATFORM=WCE200

set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\MS HPC\include;%DEVROOT%\%PLATFORM%\MS HPC\mfc\include;


@echo bulid dectalk multi language
cd .\dtalkml\src

@echo make the dynamic library versions of dectalk ML for the x86em, mips and sh3 platforms
set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\mips;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\mips;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\build\ce\mips\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkmlce.vcn wce200 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\sh3;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\sh3;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=200  CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\build\ce\sh\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkmlce.vcn wce200 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS HPC\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC\mfc\lib\X86em;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=200 CEConfigName="H/PC Ver. 2.00"
if NOT exist ..\build\ce\x86em\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkmlce.vcn wce20 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

cd .\..\..

deltree /Y .\dapi\build\%PLATFORM%
deltree /Y .\samplece\CEtalk\build\%PLATFORM%
deltree /Y .\samplece\Dtsample\build\%PLATFORM%
deltree /Y .\dtalkml\build\%PLATFORM%

mkdir .\dapi\build\%PLATFORM%
if exist .\dapi\build\cedll 		move .\dapi\build\cedll  .\dapi\build\%PLATFORM%\
if exist .\dapi\build\cestatic 		move .\dapi\build\cestatic .\dapi\build\%PLATFORM%\


mkdir .\samplece\CEtalk\build\%PLATFORM%
if exist .\samplece\CEtalk\build\dll 		move .\samplece\CEtalk\build\dll  .\samplece\CEtalk\build\%PLATFORM%\
if exist .\samplece\CEtalk\build\static 	move .\samplece\CEtalk\build\static  .\samplece\CEtalk\build\%PLATFORM%\

mkdir .\samplece\Dtsample\build\%PLATFORM%
if exist .\samplece\Dtsample\build\dll 			move .\samplece\Dtsample\build\dll .\samplece\Dtsample\build\%PLATFORM%\
if exist .\samplece\Dtsample\build\static 		move .\samplece\Dtsample\build\static  .\samplece\Dtsample\build\%PLATFORM%\

mkdir .\dtalkml\build\%PLATFORM%
if exist .\dtalkml\build\ce 		move .\dtalkml\build\ce  .\dtalkml\build\%PLATFORM%
deltree /Y .\dtalkml\build\ce

if "%1"=="WCE200" goto end


:build_wce211
rem *****Build for MS HPC PRO *********
set PLATFORM=WCE211

set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\MS HPC PRO\include;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\include;

rem reset bug parameters
set bug_arm_ce=0
set bug_arm_cedll=0
set bug_mips_ce=0
set bug_mips_cedll=0
set bug_sh_cedll=0
set bug_sh_cedll=0
set bug_sh4_ce=0
set bug_sh4_cedll=0
set bug_x86em_ce=0
set bug_x86em_cedll=0

rem if been built once move back so we don't have to build again
if exist .\dapi\build\%PLATFORM%\mspro\cedll				move .\dapi\build\%PLATFORM%\mspro\cedll .\dapi\build\cedll
if exist .\dapi\build\%PLATFORM%\mspro\cestatic 			move .\dapi\build\%PLATFORM%\mspro\cestatic .\dapi\build\cestatic
if exist .\samplece\CEtalk\build\%PLATFORM%\mspro\dll 		move .\samplece\CEtalk\build\%PLATFORM%\mspro\dll .\samplece\CEtalk\build\dll
if exist .\samplece\CEtalk\build\%PLATFORM%\mspro\static 	move .\samplece\CEtalk\build\%PLATFORM%\mspro\static .\samplece\CEtalk\build\static
if exist .\samplece\Dtsample\build\%PLATFORM%\mspro\dll 	move .\samplece\Dtsample\build\%PLATFORM%\mspro\dll .\samplece\Dtsample\build\dll
if exist .\samplece\Dtsample\build\%PLATFORM%\mspro\static 	move .\samplece\Dtsample\build\%PLATFORM%\mspro\static .\samplece\Dtsample\build\static
if exist .\samplece\Mailread\build\%PLATFORM%\mspro\dll 	move .\samplece\Mailread\build\%PLATFORM%\mspro\dll .\samplece\Mailread\build\dll
if exist .\samplece\Mailread\build\%PLATFORM%\mspro\static 	move .\samplece\Mailread\build\%PLATFORM%\mspro\static .\samplece\Mailread\build\static
if exist .\samplece\windic\build\%PLATFORM%\mspro\dll 		move .\samplece\windic\build\%PLATFORM%\mspro\dll .\samplece\windic\build\dll
if exist .\samplece\windic\build\%PLATFORM%\mspro\static	move .\samplece\windic\build\%PLATFORM%\mspro\static .\samplece\windic\build\static
if exist .\dtalkml\build\%PLATFORM%\mspro\ce  				move .\dtalkml\build\%PLATFORM%\mspro\ce  .\dtalkml\build

rem set paths for DECtalk CE build  WCE211
cd .\dapi\src

@echo make the static and dynamic library version of dectalk for the arm platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\ARM;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\arm;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\arm\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\us\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\arm\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\sp\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\arm\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\la\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\arm\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\la\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\arm\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\fr\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\arm\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\gr\release\dtstatic.lib set bug_arm_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\us\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\sp\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\la\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\uk\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\fr\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\gr\release\dectalk.dll set bug_arm_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\us\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\sp\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\la\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\uk\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\fr\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\arm\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE ARM) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\gr\access32\dectalk.dll set bug_arm_cedll=1

@echo make the static and dynamic library version of dectalk for the mips platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\MIPS;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\mips;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib set bug_mips_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll set bug_mips_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE MIPS) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll set bug_mips_cedll=1

@echo make the static and dynamic library version of dectalk for the sh3 platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH3;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\sh3;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib set bug_sh_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll set bug_sh_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH3) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll set bug_sh_cedll=1

@echo make the static and dynamic library version of dectalk for the sh4 platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH4;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\sh4;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH4) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh4\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH4) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh4\us\release\dtstatic.lib set bug_sh4_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH4) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh4\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH4) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh4\sp\release\dtstatic.lib set bug_sh4_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH4) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh4\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH4) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh4\la\release\dtstatic.lib set bug_sh4_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH4) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh4\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH4) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh4\uk\release\dtstatic.lib set bug_sh4_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH4) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh4\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH4) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh4\fr\release\dtstatic.lib set bug_sh4_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH4) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\sh4\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE SH4) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh4\gr\release\dtstatic.lib set bug_sh4_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\us\release\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\sp\release\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\la\release\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\uk\release\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\fr\release\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\gr\release\dectalk.dll set bug_sh4_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\us\access32\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\sp\access32\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\la\access32\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\uk\access32\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Access32 French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\fr\access32\dectalk.dll set bug_sh4_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH4) Access32 German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\sh4\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE SH4) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh4\gr\access32\dectalk.dll set bug_sh4_cedll=1

@echo make the static and dynamic library versions of dectalk for the x86em platform
set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\X86em;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Pro Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib set bug_x86em_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll set bug_x86em_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Pro Win32 (WCE X86EM) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll set bug_x86em_cedll=1

@echo build DTSample

cd .\..\..\samplece\Dtsample

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\ARM;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\ARM;

if "%bug_arm_ce%"=="1" goto wce211_pro_dtsample_arm_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_arm_ce

if "%bug_arm_cedll%"=="1" goto wce211_pro_dtsample_arm_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release English Uk Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE ARM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_arm_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\MIPS;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\MIPS;

if "%bug_mips_ce%"=="1" goto wce211_pro_dtsample_mips_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_mips_ce

if "%bug_mips_cedll%"=="1" goto wce211_pro_dtsample_mips_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH3;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\SH3;

if "%bug_sh_ce%"=="1" goto wce211_pro_dtsample_sh_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_sh_ce

if "%bug_sh_cedll%"=="1" goto wce211_pro_dtsample_sh_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH4;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\SH4;

if "%bug_sh4_ce%"=="1" goto wce211_pro_dtsample_sh4_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_sh4_ce

if "%bug_sh4_cedll%"=="1" goto wce211_pro_dtsample_sh4_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH4) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE SH4) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_sh4_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\X86em;

if "%bug_x86em_cedll%"=="1" goto wce211_pro_dtsample_x86em_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce211_pro_dtsample_x86em_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Pro Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_dtsample_x86em_cedll

rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"

@echo build CEtalk

cd .\..\CEtalk

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\ARM;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\ARM;

if "%bug_arm_ce%"=="1" goto wce211_pro_cetalk_arm_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_arm_ce

if "%bug_arm_cedll%"=="1" goto wce211_pro_cetalk_arm_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE ARM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_arm_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\MIPS;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\MIPS;

if "%bug_mips_ce%"=="1" goto wce211_pro_cetalk_mips_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_mips_ce

if "%bug_mips_cedll%"=="1" goto wce211_pro_cetalk_mips_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release  Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH3;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\SH3;

if "%bug_sh_ce%"=="1" goto wce211_pro_cetalk_sh_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_sh_ce

if "%bug_sh_cedll%"=="1" goto wce211_pro_cetalk_sh_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH4;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\SH4;

if "%bug_sh4_ce%"=="1" goto wce211_pro_cetalk_sh4_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_sh4_ce

if "%bug_sh4_cedll%"=="1" goto wce211_pro_cetalk_sh4_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH4) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE SH4) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_sh4_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce211_pro_cetalk_x86em_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11
if NOT exist .\%build_static%\x86em\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce211_pro_cetalk_x86em_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Pro Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_cetalk_x86em_cedll

rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"

@echo build Mailread
cd .\..\Mailread

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\arm;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\arm;

if "%bug_arm_ce%"=="1" goto wce211_pro_mailread_arm_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE ARM) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_arm_ce

if "%bug_arm_cedll%"=="1" goto wce211_pro_mailread_arm_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE ARM) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_arm_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\mips;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\mips;

if "%bug_mips_ce%"=="1" goto wce211_pro_mailread_mips_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_mips_ce

if "%bug_mips_cedll%"=="1" goto wce211_pro_mailread_mips_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE MIPS) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\sh3;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\sh3;

if "%bug_sh_ce%"=="1" goto wce211_pro_mailread_sh_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_sh_ce

if "%bug_sh_cedll%"=="1" goto wce211_pro_mailread_sh_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH3) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_sh_cedll


set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\sh4;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\sh4;

if "%bug_sh4_ce%"=="1" goto wce211_pro_mailread_sh4_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH4) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE SH4) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_sh4_ce

if "%bug_sh4_cedll%"=="1" goto wce211_pro_mailread_sh4_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH4) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE SH4) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_sh4_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce211_pro_mailread_x86em_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce211_pro_mailread_x86em_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE x86em) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread\mailread.vcn for MAILREAD - Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_mailread_x86em_cedll

@echo build windic
cd .\..\windic

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\ARM;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\ARM;

if "%bug_arm_ce%"=="1" goto wce211_pro_windic_arm_ce
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\arm\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_arm_ce

if "%bug_arm_cedll%"=="1" goto wce211_pro_windic_arm_cedll
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\arm\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_arm_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\MIPS;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\MIPS;

if "%bug_mips_ce%"=="1" goto wce211_pro_windic_mips_ce
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\mips\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_mips_ce

if "%bug_mips_cedll%"=="1" goto wce211_pro_windic_mips_cedll
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\mips\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH3;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\SH3;

if "%bug_sh_ce%"=="1" goto wce211_pro_windic_sh_ce
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_sh_ce

if "%bug_sh_cedll%"=="1" goto wce211_pro_windic_sh_cedll
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH4;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\SH4;

if "%bug_sh4_ce%"=="1" goto wce211_pro_windic_sh4_ce
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4 Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4 Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4 Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4 Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4 Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\sh4\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4 Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_sh4_ce

if "%bug_sh4_cedll%"=="1" goto wce211_pro_windic_sh4_cedll
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH4) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\sh4\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE SH4) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_sh4_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\X86em;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce211_pro_windic_x86em_ce
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_static%\x86em\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce211_pro_windic_x86em_cedll
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\us\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\sp\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\la\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\uk\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\fr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist .\%build_dll%\x86em\gr\release\windic.exe echo Workspace %blddrv%%bldpath%\samplece\windic\windic.vcn wce211 Pro Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_pro_windic_x86em_cedll

cd .\..\..
:build_wce211ML
set PLATFORM=WCE211

set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\MS HPC PRO\include;%DEVROOT%\%PLATFORM%\MS HPC PRO\mfc\include;


@echo bulid dectalk multi language

cd .\dtalkml\src

@echo make the dynamic library versions of dectalk ML
set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\ARM;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE ARM) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\build\ce\arm\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkml.vcn wce211 Pro Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH3;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\build\ce\sh\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkml.vcn wce211 Pro Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\SH4;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE SH4) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\build\ce\sh4\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkml.vcn wce211 Pro Win32 (WCE SH4) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\MIPS;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\build\ce\mips\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkml.vcn wce211 Pro Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log


set LIB=%DEVROOT%\%PLATFORM%\MS HPC PRO\lib\X86em;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\build\ce\x86em\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkml.vcn wce211 Pro Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log


cd .\..\..

deltree /y .\dapi\build\%PLATFORM%\mspro
deltree /y .\samplece\CEtalk\build\%PLATFORM%\mspro
deltree /y .\samplece\Dtsample\build\%PLATFORM%\mspro
deltree /y .\samplece\Mailread\build\%PLATFORM%\mspro
deltree /y .\samplece\windic\build\%PLATFORM%\mspro
deltree /y .\dtalkml\build\%PLATFORM%\mspro

mkdir .\dapi\build\%PLATFORM%\mspro
move .\dapi\build\cedll  .\dapi\build\%PLATFORM%\mspro\
move .\dapi\build\cestatic .\dapi\build\%PLATFORM%\mspro\

mkdir .\samplece\CEtalk\build\%PLATFORM%\mspro
move .\samplece\CEtalk\build\dll  .\samplece\CEtalk\build\%PLATFORM%\mspro\
move .\samplece\CEtalk\build\static  .\samplece\CEtalk\build\%PLATFORM%\mspro\

mkdir .\samplece\Dtsample\build\%PLATFORM%\mspro
move .\samplece\Dtsample\build\dll .\samplece\Dtsample\build\%PLATFORM%\mspro\
move .\samplece\Dtsample\build\static  .\samplece\Dtsample\build\%PLATFORM%\mspro\

mkdir .\samplece\Mailread\build\%PLATFORM%\mspro
move .\samplece\Mailread\build\dll     .\samplece\Mailread\build\%PLATFORM%\mspro\
move .\samplece\Mailread\build\static  .\samplece\Mailread\build\%PLATFORM%\mspro\

mkdir .\samplece\windic\build\%PLATFORM%\mspro
move .\samplece\windic\build\dll     .\samplece\windic\build\%PLATFORM%\mspro\
move .\samplece\windic\build\static  .\samplece\windic\build\%PLATFORM%\mspro\

mkdir .\dtalkml\build\%PLATFORM%\mspro
move .\dtalkml\build\ce .\dtalkml\build\%PLATFORM%\mspro
deltree /Y .\dtalkml\build\ce


:wce_palm
rem *****Build for PALM SIZE PC *********

set PLATFORM=WCE211

set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\ms palm size pc\include;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\include;

rem reset parameters
set bug_arm_ce=0
set bug_arm_cedll=0
set bug_mips_ce=0
set bug_mips_cedll=0
set bug_sh_cedll=0
set bug_sh_cedll=0
set bug_sh4_ce=0
set bug_sh4_cedll=0
set bug_x86em_ce=0
set bug_x86em_cedll=0

rem if been built once move back so we don't have to build again

if exist .\dapi\build\%PLATFORM%\palm\cedll 					move .\dapi\build\%PLATFORM%\palm\cedll .\dapi\build\cedll  
if exist .\dapi\build\%PLATFORM%\palm\cestatic  				move .\dapi\build\%PLATFORM%\palm\cestatic .\dapi\build\cestatic 
if exist .\samplece\CEtalk\build\%PLATFORM%\palm\dll 			move .\samplece\CEtalk\build\%PLATFORM%\palm\dll .\samplece\CEtalk\build\dll  
if exist .\samplece\CEtalk\build\%PLATFORM%\palm\static 		move .\samplece\CEtalk\build\%PLATFORM%\palm\static .\samplece\CEtalk\build\static  
if exist .\samplece\Dtsample\build\%PLATFORM%\palm\dll 			move .\samplece\Dtsample\build\%PLATFORM%\palm\dll .\samplece\Dtsample\build\dll 
if exist .\samplece\Dtsample\build\%PLATFORM%\palm\static 		move .\samplece\Dtsample\build\%PLATFORM%\palm\static .\samplece\Dtsample\build\static
rem if exist .\samplece\Mailread\build\%PLATFORM%\palm\dll 		move .\samplece\Mailread\build\%PLATFORM%\palm\dll .\samplece\Mailread\build\dll 
rem if exist .\samplece\Mailread\build\%PLATFORM%\palm\static 	move .\samplece\Mailread\build\%PLATFORM%\palm\static .\samplece\Mailread\build\static
rem if exist .\samplece\windic\build\%PLATFORM%\palm\dll 		move .\samplece\windic\build\%PLATFORM%\palm\dll .\samplece\windic\build\dll 
rem if exist .\samplece\windic\build\%PLATFORM%\palm\static		move .\samplece\windic\build\%PLATFORM%\palm\static .\samplece\windic\build\static
if exist .\dtalkml\build\%PLATFORM%\palm\ce 					move .\dtalkml\build\%PLATFORM%\palm\ce .\dtalkml\build

rem set paths for DECtalk CE build  WCE211
cd .\dapi\src


@echo make the static and dynamic library version of dectalk for the mips platform
set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\MIPS;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\mips;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib set bug_mips_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll set bug_mips_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE MIPS) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll set bug_mips_cedll=1

@echo make the static and dynamic library version of dectalk for the sh4 platform
set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\SH3;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\sh3;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib set bug_sh_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll set bug_sh_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce211 Palm Win32 (WCE SH3) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll set bug_sh_cedll=1


@echo make the static and dynamic library versions of dectalk for the x86em platform
set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\X86em;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\X86em;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211  CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib set bug_x86em_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll echo Workspace %blddrv%dapisrcce.vcn wce211 Palm Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errrors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll echo Workspace %blddrv%dapisrcce.vcn wce211 Palm Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll echo Workspace %blddrv%dapisrcce.vcn wce211 Palm Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll echo Workspace %blddrv%dapisrcce.vcn wce211 Palm Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll echo Workspace %blddrv%dapisrcce.vcn wce211 Palm Win32 (WCE X86EM) Release Dll German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll set bug_x86em_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Access32" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce211 Palm Win32 (WCE X86EM) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll set bug_x86em_cedll=1

@echo build DTSample

cd .\..\..\samplece\Dtsample


set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\MIPS;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\MIPS;

if "%bug_mips_ce%"=="1" goto wce211_palm_dtsample_mips_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_dtsample_mips_ce

if "%bug_mips_cedll%"=="1" goto wce211_palm_dtsample_mips_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release Latin Amercian Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_dtsample_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\SH3;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\SH3;

if "%bug_sh_ce%"=="1" goto wce211_palm_dtsample_sh_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_dtsample_sh_ce

if "%bug_sh_cedll%"=="1" goto wce211_palm_dtsample_sh_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_dtsample_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\X86em;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce211_palm_dtsample_x86em_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_dtsample_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce211_palm_dtsample_x86em_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce211 Palm Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_dtsample_x86em_cedll

rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Spanish Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Latin American Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug English UK Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug French Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug German Dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

@echo build CEtalk

cd .\..\CEtalk


set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\MIPS;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\MIPS;

if "%bug_mips_ce%"=="1" goto wce211_palm_cetalk_mips_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_cetalk_mips_ce

if "%bug_mips_cedll%"=="1" goto wce211_palm_cetalk_mips_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_cetalk_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\SH3;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\SH3;

if "%bug_sh_ce%"=="1" goto wce211_palm_cetalk_sh_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_cetalk_sh_ce

if "%bug_sh_cedll%"=="1" goto wce211_palm_cetalk_sh_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_cetalk_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\X86em;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce211_palm_cetalk_x86em_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_cetalk_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce211_palm_cetalk_x86em_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce211 Palm Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce211_palm_cetalk_x86em_cedll

rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Spanish dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Latin American dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug English UK dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug French dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug German dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"


rem @echo build Mailread
rem cd .\..\Mailread

rem set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\sh3;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\sh3;
rem nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH3) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

rem set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\mips;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\mips;
rem nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE MIPS) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

rem set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\X86em;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\X86em;
rem nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE x86em) Release dll" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"


rem @echo build windic
rem cd .\..\windic

rem set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\MIPS;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\MIPS;

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

rem set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\SH3;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\SH3;

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

rem set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\X86em;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\lib\X86em;

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release French" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release German" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Spanish DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Latin American DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release English UK DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release French DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release German DLL" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"


cd .\..\..
rem :build_wce211ML
set PLATFORM=WCE211

set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\ms palm size pc\include;%DEVROOT%\%PLATFORM%\ms palm size pc\mfc\include;


@echo bulid dectalk multi language

cd .\dtalkml\src

@echo make the dynamic library versions of dectalk ML for the mips, sh3 and x86em platforms

set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\MIPS;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE MIPS) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\build\ce\mips\release\dectalk.dll echo Workspace %blddrv%%bldpath%\src\dtalkmlce.vcn wce211 Palm Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\SH3;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE SH3) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\build\ce\sh\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkmlce.vcn wce211 Palm Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\ms palm size pc\lib\X86em;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE x86em) Release" CESubsystem=windowsce,2.0 CEVersion=211 CEConfigName="Pocket PC"
if NOT exist ..\build\ce\x86em\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\src\dtalkmlce.vcn wce211 Palm Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log


cd .\..\..

deltree /y .\dapi\build\%PLATFORM%\palm
deltree /y .\samplece\CEtalk\build\%PLATFORM%\palm
deltree /y .\samplece\Dtsample\build\%PLATFORM%\palm
rem deltree /y .\samplece\Mailread\build\%PLATFORM%\palm
rem deltree /y .\samplece\windic\build\%PLATFORM%\palm
deltree /y .\dtalkml\build\%PLATFORM%\palm

mkdir .\dapi\build\%PLATFORM%\palm
move .\dapi\build\cedll  .\dapi\build\%PLATFORM%\palm\
move .\dapi\build\cestatic .\dapi\build\%PLATFORM%\palm\

mkdir .\samplece\CEtalk\build\%PLATFORM%\palm
move .\samplece\CEtalk\build\dll  .\samplece\CEtalk\build\%PLATFORM%\palm\
move .\samplece\CEtalk\build\static  .\samplece\CEtalk\build\%PLATFORM%\palm\

mkdir .\samplece\Dtsample\build\%PLATFORM%\palm
move .\samplece\Dtsample\build\dll .\samplece\Dtsample\build\%PLATFORM%\palm\
move .\samplece\Dtsample\build\static  .\samplece\Dtsample\build\%PLATFORM%\palm\

rem mkdir .\samplece\Mailread\build\%PLATFORM%\palm
rem move .\samplece\Mailread\build\dll     .\samplece\Mailread\build\%PLATFORM%\palm\
rem move .\samplece\Mailread\build\static  .\samplece\Mailread\build\%PLATFORM%\palm\

rem mkdir .\samplece\windic\build\%PLATFORM%\palm
rem move .\samplece\windic\build\dll     .\samplece\windic\build\%PLATFORM%\palm\
rem move .\samplece\windic\build\static  .\samplece\windic\build\%PLATFORM%\palm\

mkdir .\dtalkml\build\%PLATFORM%\palm
move .\dtalkml\build\ce	.\dtalkml\build\%PLATFORM%\palm

deltree /Y .\dtalkml\build\ce

:build_wce300
set PLATFORM=WCE300

set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\MS Pocket PC\include;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\include;

rem reset bug parameters
set bug_arm_ce=0
set bug_arm_cedll=0
set bug_mips_ce=0
set bug_mips_cedll=0
set bug_sh_cedll=0
set bug_sh_cedll=0
set bug_sh4_ce=0
set bug_sh4_cedll=0
set bug_x86em_ce=0
set bug_x86em_cedll=0

rem if been built once move back so we don't have to build again

if exist .\dapi\build\%PLATFORM%\cedll 						move .\dapi\build\%PLATFORM%\cedll .\dapi\build\cedll  
if exist .\dapi\build\%PLATFORM%\cestatic 					move .\dapi\build\%PLATFORM%\cestatic .\dapi\build\cestatic 
if exist .\samplece\CEtalk\build\%PLATFORM%\dll 			move .\samplece\CEtalk\build\%PLATFORM%\dll .\samplece\CEtalk\build\dll  
if exist .\samplece\CEtalk\build\%PLATFORM%\static 			move .\samplece\CEtalk\build\%PLATFORM%\static .\samplece\CEtalk\build\static  
if exist .\samplece\Dtsample\build\%PLATFORM%\dll 			move .\samplece\Dtsample\build\%PLATFORM%\dll .\samplece\Dtsample\build\dll 
if exist .\samplece\Dtsample\build\%PLATFORM%\static		move .\samplece\Dtsample\build\%PLATFORM%\static .\samplece\Dtsample\build\static
if exist .\samplece\Mailread\build\%PLATFORM%\dll 			move .\samplece\Mailread\build\%PLATFORM%\dll .\samplece\Mailread\build\dll 
if exist .\samplece\Mailread\build\%PLATFORM%\static		move .\samplece\Mailread\build\%PLATFORM%\static .\samplece\Mailread\build\static
rem if exist .\samplece\windic\build\%PLATFORM%\dll 		move .\samplece\windic\build\%PLATFORM%\dll .\samplece\windic\build\dll 
rem if exist .\samplece\windic\build\%PLATFORM%\static 		move .\samplece\windic\build\%PLATFORM%\static .\samplece\windic\build\static
if exist .\dtalkml\build\%PLATFORM%\ce 						move .\dtalkml\build\%PLATFORM%\ce .\dtalkml\build

rem set paths for DECtalk CE build  WCE300
cd .\dapi\src

@echo make the static and dynamic library version of dectalk for the arm platform
set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\ARM;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\arm\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\us\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300  CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\arm\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\sp\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\arm\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\la\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\arm\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\uk\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\arm\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\fr\release\dtstatic.lib set bug_arm_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE ARM) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\arm\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\arm\gr\release\dtstatic.lib set bug_arm_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\us\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\sp\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\la\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\uk\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\fr\release\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\gr\release\dectalk.dll set bug_arm_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\us\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\sp\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\la\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\uk\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\fr\access32\dectalk.dll set bug_arm_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE ARM) Access32 German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\arm\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE ARM) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\arm\gr\access32\dectalk.dll set bug_arm_cedll=1

@echo make the static and dynamic library version of dectalk for the mips platform
set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\MIPS;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\us\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300  CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\sp\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errorswin_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\la\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\uk\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\fr\release\dtstatic.lib set bug_mips_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\mips\gr\release\dtstatic.lib set bug_mips_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\release\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\release\dectalk.dll set bug_mips_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\us\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\sp\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\la\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\uk\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\fr\access32\dectalk.dll set bug_mips_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE MIPS) Access32 German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="H/PC Pro 2.11"
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE MIPS) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\mips\gr\access32\dectalk.dll set bug_mips_cedll=1

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\SH3;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\us\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300  CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\sp\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\la\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\uk\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\fr\release\dtstatic.lib set bug_sh_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE SH3) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\sh\gr\release\dtstatic.lib set bug_sh_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\release\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\release\dectalk.dll set bug_sh_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\us\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Access32 Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\sp\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Access32 Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\la\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Access32 English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\uk\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Access32 French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\fr\access32\dectalk.dll set bug_sh_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE SH3) Access32 German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE SH3) Access32 German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\sh\gr\access32\dectalk.dll set bug_sh_cedll=1

@echo make the static and dynamic library versions of dectalk for the x86em platform
set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\X86em;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\X86em;

nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release" CESubsystem=windowsce,3.0 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\us\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\sp\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\la\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\uk\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\fr\release\dtstatic.lib set bug_x86em_ce=1
nmake /NOLOGO /f "ce.vcn" CFG="CE - Win32 (WCE x86em) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib echo Workspace %blddrv%%bldpath%\dapi\src\ce.vcn wce300 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_static%\x86em\gr\release\dtstatic.lib set bug_x86em_ce=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\sp\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\la\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\uk\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\fr\release\dectalk.dll set bug_x86em_cedll=1
nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\gr\release\dectalk.dll set bug_x86em_cedll=1

nmake /NOLOGO /f "cedll.vcn" CFG="cedll - Win32 (WCE x86em) Access32" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll echo Workspace %blddrv%%bldpath%\dapi\src\cedll.vcn wce300 Win32 (WCE X86EM) Access32 not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
if NOT exist ..\%build_wce_dll%\x86em\us\access32\dectalk.dll set bug_x86em_cedll=1

rem @echo build DTSample

cd .\..\..\samplece\Dtsample

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\ARM;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\ARM;

if "%bug_arm_ce%"=="1" goto wce300_dtsample_arm_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_arm_ce

if "%bug_arm_cedll%"=="1" goto wce300_dtsample_arm_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Spanish dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release Latin American dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release English UK dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release French dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE ARM) Release German dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE ARM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_arm_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\MIPS;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\MIPS;

if "%bug_mips_ce%"=="1" goto wce300_dtsample_mips_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_mips_ce

if "%bug_mips_cedll%"=="1" goto wce300_dtsample_mips_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Spanish Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release Spansih Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release Latin American Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release English UK Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release French Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE MIPS) Release German Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\SH3;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\SH3;

if "%bug_sh3_ce%"=="1" goto wce300_dtsample_sh3_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_sh3_ce

if "%bug_sh3_cedll%"=="1" goto wce300_dtsample_sh3_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Spanish Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release Latin American Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release English UK Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release French Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE SH3) Release German Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_sh3_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\X86em;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce300_dtsample_x86em_ce
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce300_dtsample_x86em_cedll
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\us\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Spanish Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\sp\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release Latin American Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\la\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release English UK Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\uk\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release French Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\fr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Release German Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\gr\release\dtsample.exe echo Workspace %blddrv%%bldpath%\samplece\dtsample\dtsample.vcn wce300 Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_dtsample_x86em_cedll

rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Spanish Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug Latin American Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug English UK Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug French Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "Dtsample.vcn" CFG="Dtsample - Win32 (WCE x86em) Debug German Dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

@echo build CEtalk

cd .\..\CEtalk

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\ARM;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\ARM;

if "%bug_arm_ce%"=="1" goto wce300_cetalk_arm_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release Latin Americannot build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_arm_ce

if "%bug_arm_cedll%"=="1" goto wce300_cetalk_arm_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Spanish dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release Latin American dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release English UK dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release French dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE ARM) Release German dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE ARM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_arm_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\MIPS;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\MIPS;

if "%bug_mips_ce%"=="1" goto wce300_cetalk_mips_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_mips_ce

if "%bug_mips_cedll%"=="1" goto wce300_cetalk_mips_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Spanish dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release Latin American dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release English UK dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release French dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE MIPS) Release German dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE MIPS) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\SH3;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\SH3;

if "%bug_sh_ce%"=="1" goto wce300_cetalk_sh_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_sh_ce

if "%bug_sh_cedll%"=="1" goto wce300_cetalk_sh_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Spanish dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release Latin American dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release English UK dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release French dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE SH3) Release German dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE SH3) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\X86em;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce300_cetalk_x86em_ce
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release Spanish not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release Latin American not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release English UK not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release French not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release German not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce300_cetalk_x86em_cedll
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\us\release\dtalk_us.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Spanish dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\sp\release\dtalk_sp.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release Spanish Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release Latin American dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\la\release\dtalk_la.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release Latin American Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release English UK dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\uk\release\dtalk_uk.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release English UK Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release French dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\fr\release\dtalk_fr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release French Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Release German dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\gr\release\dtalk_gr.exe echo Workspace %blddrv%%bldpath%\samplece\cetalk\cetalk.vcn wce300 Win32 (WCE X86EM) Release German Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_cetalk_x86em_cedll

rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Spanish dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug Latin American dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug English UK dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug French dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "CEtalk.vcn" CFG="CEtalk - Win32 (WCE x86em) Debug German dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

@echo build Mailread
cd .\..\Mailread

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\arm;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\arm;

if "%bug_arm_ce%"=="1" goto wce300_mailread_arm_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE ARM) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\arm\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_arm_ce

if "%bug_arm_cedll%"=="1" goto wce300_mailread_arm_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE ARM) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\arm\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE ARM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_arm_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\mips;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\mips;

if "%bug_mips_ce%"=="1" goto wce300_mailread_mips_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE MIPS) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\mips\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_mips_ce

if "%bug_mips_cedll%"=="1" goto wce300_mailread_mips_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE MIPS) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\mips\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE MIPS) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_mips_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\sh3;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\sh3;

if "%bug_sh_ce%"=="1" goto wce300_mailread_sh_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH3) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\sh\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_sh_ce

if "%bug_sh_cedll%"=="1" goto wce300_mailread_sh_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE SH3) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\sh\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE SH3) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_sh_cedll

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\X86em;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\X86em;

if "%bug_x86em_ce%"=="1" goto wce300_mailread_x86em_ce
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE x86em) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_static%\x86em\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_x86em_ce

if "%bug_x86em_cedll%"=="1" goto wce300_mailread_x86em_cedll
nmake /NOLOGO /f "Mailread.vcn" CFG="Mailread - Win32 (WCE x86em) Release dll" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist .\%build_dll%\x86em\us\release\mailread.exe echo Workspace %blddrv%%bldpath%\samplece\mailread.vcn for MAILREAD - Win32 (WCE X86EM) Release Dll not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log
:wce300_mailread_x86em_cedll

rem @echo build windic
rem cd .\..\windic

rem set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\X86em;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\X86em;

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Spanish DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release Latin American DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release English UK DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release French DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE x86em) Release German DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

rem set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\ARM;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\ARM;

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Spanish DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release Latin American DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release English UK DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release French DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE ARM) Release German DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

rem set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\SH3;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\SH3;

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Spanish DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release Latin American DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release English UK DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release French DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE SH3) Release German DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

rem set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\MIPS;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\lib\MIPS;

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Spanish" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Latin American" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release English UK" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release French" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release German" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Spanish DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release Latin American DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release English UK DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release French DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
rem nmake /NOLOGO /f "windic.vcn" CFG="windic - Win32 (WCE MIPS) Release German DLL" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"

cd .\..\..
:build_wce300ML
set PLATFORM=WCE300

set PATH=%VCROOT%\Common\EVC\Bin;%VCROOT%\EVC\%PLATFORM%\Bin;%path%
set INCLUDE=%DEVROOT%\%PLATFORM%\MS Pocket PC\include;%DEVROOT%\%PLATFORM%\MS Pocket PC\mfc\include;

@echo bulid dectalk multi language

cd .\dtalkml\src

@echo make the dynamic library versions of dectalk ML for the x86em and arm platforms
set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\X86em;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE x86em) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\build\ce\x86em\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\dtalkmlce.vcn wce300 Win32 (WCE X86EM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\ARM;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE ARM) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\build\ce\arm\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\dtalkmlce.vcn wce300 Win32 (WCE ARM) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\SH3;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE SH3) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\build\ce\sh\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\dtalkmlce.vcn wce300 Win32 (WCE SH3) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

set LIB=%DEVROOT%\%PLATFORM%\MS Pocket PC\lib\MIPS;
rem Force dtalkml Build doen't update otherwise
nmake /NOLOGO /f "DtalkMLCE.vcn" CFG="DTalkML - Win32 (WCE MIPS) Release" CESubsystem=windowsce,3.00 CEVersion=300 CEConfigName="Pocket PC"
if NOT exist ..\build\ce\mips\release\dectalk.dll echo Workspace %blddrv%%bldpath%\dtalkml\dtalkmlce.vcn wce300 Win32 (WCE MIPS) Release not build >> %blddrv%%bldpath%\build_log\errors\win_ce%index%.log

cd .\..\..

deltree /y .\dapi\build\%PLATFORM%
deltree /y .\samplece\CEtalk\build\%PLATFORM%
deltree /y .\samplece\Dtsample\build\%PLATFORM%
deltree /y .\samplece\Mailread\build\%PLATFORM%
rem deltree /y .\samplece\windic\build\%PLATFORM%
deltree /y .\dtalkml\build\%PLATFORM%

mkdir .\dapi\build\%PLATFORM%
move .\dapi\build\cedll  .\dapi\build\%PLATFORM%\
move .\dapi\build\cestatic .\dapi\build\%PLATFORM%\

mkdir .\samplece\CEtalk\build\%PLATFORM%
move .\samplece\CEtalk\build\dll     .\samplece\CEtalk\build\%PLATFORM%\
move .\samplece\CEtalk\build\static  .\samplece\CEtalk\build\%PLATFORM%\

mkdir .\samplece\Dtsample\build\%PLATFORM%
move .\samplece\Dtsample\build\dll     .\samplece\Dtsample\build\%PLATFORM%\
move .\samplece\Dtsample\build\static  .\samplece\Dtsample\build\%PLATFORM%\

mkdir .\samplece\Mailread\build\%PLATFORM%
move .\samplece\Mailread\build\dll     .\samplece\Mailread\build\%PLATFORM%\
move .\samplece\Mailread\build\static  .\samplece\Mailread\build\%PLATFORM%\

rem mkdir .\samplece\windic\build\%PLATFORM%
rem move .\samplece\windic\build\dll     .\samplece\windic\build\%PLATFORM%\
rem move .\samplece\windic\build\static  .\samplece\windic\build\%PLATFORM%\

mkdir .\dtalkml\build\%PLATFORM%
move .\dtalkml\build\ce .\dtalkml\build\%PLATFORM%

deltree /Y .\dtalkml\build\ce


:end
