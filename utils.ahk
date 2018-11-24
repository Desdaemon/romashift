ReadSettings:
IniRead, R_InputMode, rm_settings.ini, General, InputMode, 1
IniRead, isActive, rm_settings.ini, General, DoConversion, 1
IniRead, R_LeadingSilent, rm_settings.ini, General, LeadingSilent, 1
IniRead, R_VerboseTip, rm_settings.ini, General, VerboseTip, 0
IniRead, R_WindowsBoot, rm_settings.ini, System, StartWithWindows, 1
IniRead, R_OpenDialog, rm_settings.ini, System, DialogOnStart, 0
IniRead, R_RefreshDelay, rm_settings.ini, System, RefreshDelay, 5
; V2.1+
IniRead, R_CurrentTable, rm_settings.ini, General, ScimTable, "HangulRomaja.txt"
return

Update_isActive:
newActive := isActive ? "enabled" : "disabled"
if R_VerboseTip {
	TrayTip, RomaShift for Dubeolsik, is now %newActive%.,2
}
menuIcon := isActive ? "rs_on.ico" : "rs_off.ico"
Menu, Tray, Icon, icons\%menuIcon%
return

Toggle_isActive:
isActive := !isActive
IniWrite, %isActive%, rm_settings.ini, General, DoConversion
Gosub Update_isActive
Gosub UpdateTrayMenu
return

Update_R_WindowsBoot:
if R_WindowsBoot {
	FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\RomaShift.lnk
}
else {
	FileDelete, %A_Startup%\RomaShift.lnk
}
return

DefaultSettings:
GuiControl, Choose, R_InputMode, 1
GuiControl,, isActive, 1
GuiControl,, R_LeadingSilent, 1
GuiControl,, R_VerboseTip, 0
GuiControl,, R_WindowsBoot, 1
GuiControl,, R_OpenDialog, 0
GuiControl,, R_RefreshDelay, 5
Gosub Update_R_InputMode
return

Terminate:
ExitApp
return

WriteSettingsSub:
IniWrite, %R_InputMode%, rm_settings.ini, General, InputMode
IniWrite, %isActive%, rm_settings.ini, General, DoConversion
IniWrite, %R_LeadingSilent%, rm_settings.ini, General, LeadingSilent
IniWrite, %R_VerboseTip%, rm_settings.ini, General, VerboseTip
IniWrite, %R_WindowsBoot%, rm_settings.ini, System, StartWithWindows
IniWrite, %R_OpenDialog%, rm_settings.ini, System, DialogOnStart
IniWrite, %R_RefreshDelay%, rm_settings.ini, System, RefreshDelay
Gosub Update_R_WindowsBoot
return

UpdateTable:
chara.RemoveAll()
current_string = 
current_chara = 
current_key = 

Loop, read, tables\%R_CurrentTable%
{
    LineNumber := A_Index
    Loop, parse, A_LoopReadLine, %A_Space%
    {
		if (A_Index = 2) {
			chara.item(key_to_append) := A_LoopField
			continue
		}
		key_to_append := A_LoopField
    }
}
return

ResetTable:
MsgBox, 52, Warning, All default tables will be overwritten. Proceed?
IfMsgBox, No
	return
FileCopy, tables\default\*.txt, tables\*.txt, 1
FileSetAttrib, -RH, tables\*.txt,
return

DoReload:
if (R_VerboseTip) {
	TrayTip, RomaShift for Dubeolsik, is now reloading...,1
}
Sleep 1000
Reload
Sleep 1000
TrayTip, RomaShift for Dubeolsik, failed to reload.,3
return

; Hotkey toggle switch
<!1::
Gosub Toggle_isActive
return

<!2::
Gosub DoReload
return