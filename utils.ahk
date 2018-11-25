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

; Initializations for SCIM Romaja
ScimInit:
if (R_InputMode = 3) {
	chara := ComObjCreate("Scripting.Dictionary")
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
}
return
; Initializations for Native Input
NativeInit:
if (R_InputMode = 1) {
	HC := 0 ; Head character, initial consonant
	MC := 0	; Middle character, medial vowels
	TC := 0 ; Tail character, final consonants
	
	fblock := ""
	current_block := 0
	TC_HC := {0:11,1:0,2:0,3:9,4:2,5:12,6:18,7:3,8:5,9:0,10:6,11:7,12:9,13:16,14:17,15:18,16:6,17:7,18:9,19:9,20:9,21:11,22:12,23:14,24:15,25:16,26:17,27:18}
	TC_prev := {0:0,1:0,2:1,3:1,4:0,5:4,6:4,7:0,8:0,9:8,10:8,11:8,12:8,13:8,14:8,15:8,16:0,17:0,18:17,19:0,20:19,21:0,22:0,23:0,24:0,25:0,26:0,27:0}
	HC_prev := {0:"ㄱ",1:"ㄲ",2:"ㄴ",3:"ㄷ",4:"ㄸ",5:"ㄹ",6:"ㅁ",7:"ㅂ",8:"ㅃ",9:"ㅅ",10:"ㅆ",11:"ㅇ",12:"ㅈ",13:"ㅉ",14:"ㅊ",15:"ㅋ",16:"ㅌ",17:"ㅍ",18:"ㅎ"}
	HC_double := {1:0,4:3,8:7,10:9,13:12}
	MC_prev := {1:0,2:6,3:2,4:"",5:4,6:"",7:6,8:"",9:8,10:9,11:8,12:"",13:"",14:13,15:14,16:13,17:"",18:"",19:18,20:""}
}
return

; Initializations for Dubeolshift
DuboInit:
if (R_InputMode = 2) {
	isNormal_U := 0
	isNormal_W := 0
	isNormal_O := 0
	isSilent = True
}
return

; Hotkey toggle switch
<!1::
Gosub Toggle_isActive
return

<!2::
Gosub DoReload
return