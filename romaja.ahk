#InstallKeybdHook
#SingleInstance force
; #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetBatchLines, -1

; Update after every major build!
R_CurrentBuild = v2

; Alt+1 toggles
; Alt+2 reloads script

new_run = 

EnvGet, appdata, APPDATA
if !FileExist("%appdata%\romashift") {
	FileCreateDir, %appdata%\romashift
	FileCreateDir, %appdata%\romashift\icons
	FileCreateDir, %appdata%\romashift\tables
}

FileInstall, icons\rs_on.ico, %appdata%\romashift\icons\rs_on.ico
FileInstall, icons\rs_off.ico, %appdata%\romashift\icons\rs_off.ico
FileInstall, icons\ro_full.png, %appdata%\romashift\icons\ro_full.png
FileInstall, init.ahk, %appdata%\romashift\init.ahk
FileInstall, utils.ahk, %appdata%\romashift\utils.ahk
FileInstall, gui.ahk, %appdata%\romashift\gui.ahk
FileInstall, scim_tables_ko.ahk, %appdata%\romashift\scim_tables_ko.ahk
FileInstall, native_input.ahk, %appdata%\romashift\native_input.ahk
FileInstall, dubeolshift.ahk, %appdata%\romashift\dubeolshift.ahk
FileInstall, tables\HangulRomaja.txt, %appdata%\romashift\tables\HangulRomaja.txt

SetWorkingDir, %appdata%\romashift

#Include init.ahk
#Include gui.ahk
#Include utils.ahk

new_run := 0

; Initialization finished

#Include scim_tables_ko.ahk
#Include native_input.ahk
#Include dubeolshift.ahk








