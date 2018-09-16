#InstallKeybdHook
#SingleInstance force
; #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; SetKeyDelay, -1

; Update after every major build!
R_CurrentBuild = v1

; Alt+1 toggles
; Alt+2 reloads script

new_run = 

EnvGet, appdata, APPDATA
if !FileExist("%appdata%\romashift") {
	FileCreateDir, %appdata%\romashift
}

FileInstall, rs_on.ico, %appdata%\romashift\rs_on.ico
FileInstall, rs_off.ico, %appdata%\romashift\rs_off.ico
FileInstall, ro_full.png, %appdata%\romashift\ro_full.png
;FileInstall, help1.png, %appdata%\romashift\help1.png
;FileInstall, help2.png, %appdata%\romashift\help2.png
FileInstall, init.ahk, %appdata%\romashift\init.ahk
FileInstall, utils.ahk, %appdata%\romashift\utils.ahk
FileInstall, gui.ahk, %appdata%\romashift\gui.ahk
FileInstall, native_input.ahk, %appdata%\romashift\native_input.ahk
FileInstall, dubeolshift.ahk, %appdata%\romashift\dubeolshift.ahk

SetWorkingDir, %appdata%\romashift

#Include init.ahk
#Include gui.ahk
#Include utils.ahk

new_run := 0

; Initialization finished

#Include native_input.ahk
#Include dubeolshift.ahk








