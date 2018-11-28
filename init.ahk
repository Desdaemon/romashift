if !FileExist("rm_settings.ini") {
	IniWrite, 1, rm_settings.ini, General, InputMode
	IniWrite, 1, rm_settings.ini, General, DoConversion
	IniWrite, 1, rm_settings.ini, General, LeadingSilent
	IniWrite, 0, rm_settings.ini, General, VerboseTip
	IniWrite, 1, rm_settings.ini, System, StartWithWindows
	IniWrite, 0, rm_settings.ini, System, DialogOnStart
	IniWrite, 5, rm_settings.ini, System, RefreshDelay
	; V2.1+
	IniWrite, HangulRomaja.txt, rm_settings.ini, General, ScimTable
	MsgBox, 36,, It looks like this is the first time you've run RomaShift.`r`nWould you like to open the help dialog?
	IfMsgBox Yes
		new_run := 1
}

FileSetAttrib, +H, %appdata%\romashift\*.*

IniRead, R_InputMode, rm_settings.ini, General, InputMode, 1
IniRead, isActive, rm_settings.ini, General, DoConversion, 1
IniRead, R_LeadingSilent, rm_settings.ini, General, LeadingSilent, 1
IniRead, R_VerboseTip, rm_settings.ini, General, VerboseTip, 0
IniRead, R_WindowsBoot, rm_settings.ini, System, StartWithWindows, 1
IniRead, R_OpenDialog, rm_settings.ini, System, DialogOnStart, 0
IniRead, R_RefreshDelay, rm_settings.ini, System, RefreshDelay, 5
; V2.1+
IniRead, R_CurrentTable, rm_settings.ini, General, ScimTable

freq =
t0 =
t1 =
t_sum =
t_avg =
t_count =
t_max =
t_min := 100
DllCall("QueryPerformanceFrequency", "Int64*", freq)

Gosub ScimInit
Gosub NativeInit
Gosub DuboInit


