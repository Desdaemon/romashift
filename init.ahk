if !FileExist("rm_settings.ini") {
	IniWrite, 1, rm_settings.ini, General, InputMode
	IniWrite, 1, rm_settings.ini, General, DoConversion
	IniWrite, 1, rm_settings.ini, General, LeadingSilent
	IniWrite, 0, rm_settings.ini, General, VerboseTip
	IniWrite, 1, rm_settings.ini, System, StartWithWindows
	IniWrite, 0, rm_settings.ini, System, DialogOnStart
	IniWrite, 5, rm_settings.ini, System, RefreshDelay
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

; Initializations for SCIM Romaja

chara := ComObjCreate("Scripting.Dictionary")
current_string = 
current_chara = 
current_key = 

Loop, read, tables/HangulRomaja.txt
{
    LineNumber = %A_Index%
    Loop, parse, A_LoopReadLine, %A_Space%
    {
		if (A_Index = 2) {
			;MsgBox, 4,, Chara %A_LoopField%
			;IfMsgBox No
			;	exit
			chara.item(key_to_append) := A_LoopField
			continue
		}
		;MsgBox, 4,, Key %A_LoopField%
		;IfMsgBox No
		;	exit
		key_to_append := A_LoopField
    }
}

; Initializations for Native Input

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

; Initializations for Dubeolshift

isNormal_U := 0
isNormal_W := 0
isNormal_O := 0
isSilent = True
