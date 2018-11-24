#InstallKeybdHook
#SingleInstance force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetBatchLines, -1
FileEncoding, UTF-8-RAW

; Update after every major build!
R_CurrentBuild = v2.1

; Alt+1 toggles
; Alt+2 reloads script

new_run = 

EnvGet, appdata, APPDATA
if !FileExist("%appdata%\romashift") {
	FileCreateDir, %appdata%\romashift
	FileCreateDir, %appdata%\romashift\icons
	FileCreateDir, %appdata%\romashift\tables
	FileCreateDir, %appdata%\romashift\tables\default
}
new_root = %appdata%\romashift
FileInstall, icons\rs_on.ico, %new_root%\icons\rs_on.ico
FileInstall, icons\rs_off.ico, %new_root%\icons\rs_off.ico
FileInstall, icons\ro_full.png, %new_root%\icons\ro_full.png
FileInstall, init.ahk, %new_root%\init.ahk
FileInstall, utils.ahk, %new_root%\utils.ahk
FileInstall, gui.ahk, %new_root%\gui.ahk
FileInstall, scim_tables_ko.ahk, %new_root%\scim_tables_ko.ahk
FileInstall, native_input.ahk, %new_root%\native_input.ahk
FileInstall, dubeolshift.ahk, %new_root%\dubeolshift.ahk
; V2.1+
FileInstall, tables\HangulRomaja.txt, %new_root%\tables\HangulRomaja.txt
FileInstall, tables\HangulRomaja_old.txt, %new_root%\tables\HangulRomaja_old.txt
FileInstall, tables\Dubeolsik.txt, %new_root%\tables\Dubeolsik.txt
FileInstall, tables\HangulRomaja.txt, %new_root%\tables\default\HangulRomaja.txt
FileInstall, tables\HangulRomaja_old.txt, %new_root%\tables\default\HangulRomaja_old.txt
FileInstall, tables\Dubeolsik.txt, %new_root%\tables\default\Dubeolsik.txt
FileSetAttrib, +RH, %new_root%\tables\default\*.txt
SetWorkingDir, %new_root%

#Include init.ahk
#Include gui.ahk
#Include utils.ahk

new_run := 0

; Initialization finished

#Include scim_tables_ko.ahk
#Include native_input.ahk
#Include dubeolshift.ahk








