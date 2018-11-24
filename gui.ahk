; Tray menu

Menu, Tray, Add, Native Input, Toggle_R_InputMode, +Radio
Menu, Tray, Add, Dubeolshift, Toggle_R_InputMode, +Radio
Menu, Tray, Add, SCIM Romaja, Toggle_R_InputMode, +Radio
if (R_InputMode = 1) {
	Menu, Tray, Check, Native Input
	Menu, Tray, Uncheck, Dubeolshift
	Menu, Tray, Uncheck, SCIM Romaja
}
else if (R_InputMode = 2) {
	Menu, Tray, Uncheck, Native Input
	Menu, Tray, Check, Dubeolshift
	Menu, Tray, Uncheck, SCIM Romaja
}
else if (R_InputMode = 3) {
	Menu, Tray, Uncheck, Native Input
	Menu, Tray, Uncheck, Dubeolshift
	Menu, Tray, Check, SCIM Romaja
}
Menu, Tray, Add
Menu, Tray, Add, Do character conversion`tAlt+1, Toggle_isActive
Menu, Tray, Add, Automatic silent ieung, Toggle_R_LeadingSilent

Gosub UpdateTrayMenu

Menu, Tray, Add
Menu, Tray, Add, Reload script`tAlt+2, DoReload
Menu, Tray, Add, Exit, Terminate
Menu, Tray, Add, Options, OpenDialog

Menu, Tray, Tip, RomaShift %R_CurrentBuild%
Menu, Tray, Default, Options
Gosub Update_isActive
Menu, Tray, NoStandard

;======================================
; Main dialog

Gosub GUI_Initialize
Gosub GUI_Help_Initialize

GUI_Initialize:
Gui, New
Gui +HwndGuiHwnd
Gui, -MaximizeBox -MinimizeBox

Gui, Add, GroupBox, x12 y9 w230 h190 , Options
Gui, Add, Text, x22 y32 w60 h20 +Center, Input Mode
Gui, Add, DropDownList, x92 y29 w140 Choose%R_InputMode% gUpdate_R_InputMode vR_InputMode AltSubmit, Native Input|Dubeolshift|SCIM Romaja
Gui, Add, Text, x22 y59 w60 h20 +Center, SCIM Table
Gui, Add, Text, x92 y59 w90 h20 vR_CurrentTable, %R_CurrentTable%
Gui, Add, Button, x192 y59 w40 h20 , Load

Gui, Add, CheckBox, x22 y79 w150 h20 Checked%isActive% visActive, Do character conversion
Gui, Add, CheckBox, x22 y99 w150 h20 Checked%R_LeadingSilent% vR_LeadingSilent, Automatic silent ieung (ㅇ)
Gui, Add, CheckBox, x22 y119 w150 h20 Checked%R_VerboseTip% vR_VerboseTip, Display all notifications
Gui, Add, Text, x22 y139 w160 h20 , Windows change refresh delay
Gui, Add, Slider, x22 y159 w210 h30 ToolTip +Range1-30 vR_RefreshDelay, %R_RefreshDelay%

Gosub Update_R_InputMode

Gui, Add, GroupBox, x12 y209 w230 h70 , System
Gui, Add, CheckBox, x22 y229 w150 h20 Checked%R_WindowsBoot% vR_WindowsBoot, Start with Windows
Gui, Add, CheckBox, x22 y249 w150 h20 Checked%R_OpenDialog% vR_OpenDialog, Show this dialog on start

Gui, Add, Button, x12 y289 w70 h30 Default, O&K
Gui, Add, Button, x12 y329 w70 h30 gOpenHelpDialog, &Help
Gui, Add, Button, x12 y369 w70 h30 gOpenFolder, &Open Tables Folder

Gui, Add, Button, x92 y289 w70 h30 , &Cancel
Gui, Add, Button, x92 y329 w70 h30 gDefaultSettings, &Restore to Defaults
Gui, Add, Button, x92 y369 w70 h30 gEditTable, &Edit Current Table

Gui, Add, Button, x172 y289 w70 h30 , &Apply
Gui, Add, Button, x172 y329 w70 h30 gTerminate, E&xit
Gui, Add, Button, x172 y369 w70 h30 gResetTable, Reset &Default Tables

if R_OpenDialog {
	Gui, Show, AutoSize, RomaShift %R_CurrentBuild%, Guiwindow
}
return

;======================================
; Help dialog

GUI_Help_Initialize:
Gui Help:New
Gui Help:Add, Picture, x12 y9 w50 h50 , icons\ro_full.png
Gui Help:Font, s26 bold, Segoe UI
Gui Help:Add, Text, x72 y9 w170 h50 , RomaShift
Gui Help:Font
Gui Help:Add, Text, x246 y36 w100 h20 , Revision %R_CurrentBuild%
Gui Help:Add, Button, x12 y479 w370 h30 , &OK
Gui Help:Add, Tab, x12 y69 w370 h400 , Input Modes|Instructions|Vowels (Native Input)|Vowels (Dubeolshift)|Vowels (SCIM Romaja)|About

Gui Help:Tab, Instructions

instructions_text =
(
..: Hotkeys (Default) :..
Alt+1`tToggles character conversion.
Alt+2`tReloads the script.
X/V`tInputs ieung (ㅇ) character.
Q/F`tCommits current character.

..: Installing Korean IME :..
Installing the Korean Input Method Editor (IME) on your system will enable the Dubeolshift input mode and allows for Hanja conversion in Native Input. (default Right Ctrl)

[Note]
The "Go to Region & Language" button can be used to access the settings screen.

- Click the Start button, type "input" and enter "Change keyboards or other input methods"
- In the "Region and Language" screen, go to the "Keyboards and Languages" table
- Click on "Change keyboards..."
- Click on "Add" on the right-hand side
- Scroll down to find Korean, expand the tree and tick "Microsoft IME", then click "OK"
)

Gui Help:Font, s10, Segoe UI
Gui Help:Add, Edit, x22 y119 w350 h300 ReadOnly VScroll, %instructions_text%
Gui Help:Font
Gui Help:Add, Button, x232 y429 w140 h30 gOpenSettings, Go to Region && Language

Gui Help:Tab, Input Modes

input_modes_text =
(
..: Native Input :..
The default input mode of RomaShift.
Bypasses the need to install IMEs in exchange for Hanja conversion.
Consonants are assigned one-to-one to their sounds, e.g. g to ㄱ, k to ㅋ.
Double consonants are double letters, e.g. bb to ㅃ, dd to ㄸ.
Vowels mostly adhere to their spelling with a few exceptions.
The silent ieung is always appended and is much more robust than in Dubeolshift.

..: Dubeolshift :..
Piggybacks off of the Dubeolsik layout, which requires the Korean IME installed and enabled.
Character conversion and Korean IME has to be enabled and disabled separately with the hotkeys Alt+1 and Right Alt respectively.
Consonants are assigned one-to-one to their sounds, e.g. g to ㄱ, k to ㅋ.
Double consonants are uppercase letters, e.g. B to ㅃ, D to ㄸ.
Most vowels depend on the Shift key. Please consult the Vowels tab for more details.
The silent ieung is somewhat unreliable, which can be remedied with manual input. (default X and V)

..: SCIM Romaja :..
A port of the SCIM Hangul Romaja input method for POSIX systems. Functionality is similar to Native Input.
You can modify this input mode by editing %APPDATA%\romashift\tables\HangulRomaja.txt.
If you mess up, use "Reset All Tables".
Mappings are carried over from SCIM, with the following additions:

'yeo' and 'y', 'u' and 'w' are interchangeable if they stand alone.
'c' is interchangeable with 'k' and 'q'.
'f' is the commit key.

Double consonants are either double or uppercase letters.
Complex vowels can be inputted in two ways: sound and spelling.
For example, the vowel ㅙ can be written as 'wae' or 'oai'.
The silent ieung is automatic, whereas the final ieung is always 'ng'.
* NEW V2.1 * "ae", "eu" and "eo" can now be typed as "ev", "uv" and "ov" respectively.
* NEW V2.1 * The manual silent ieung key is "v" and can be used to commit a word quickly.
For example, 한국어 can be typed as either "hangugfeo", "hangugfov", "hangugveo" or "hangugvov".
)

Gui Help:Font, s10, Segoe UI
Gui Help:Add, Edit, x22 y119 w350 h340 ReadOnly VScroll, %input_modes_text%
Gui Help:Font

Gui Help:Font, s16 bold, Segoe UI
Gui Help:Tab, Vowels (Native Input)

e_chara := "ㅓ"
i_chara := "ㅣ"
y_chara := "ㅕ"
a_chara := "ㅏ"
w_chara := "ㅡ"
u_chara := "ㅜ"
o_chara := "ㅗ"

Gui Help:Add, Text, x22 y119 w50 h40 +Center, a
Gui Help:Add, Text, x22 y169 w50 h40 +Center, i
Gui Help:Add, Text, x22 y219 w50 h40 +Center, u
Gui Help:Add, Text, x22 y269 w50 h40 +Center, e
Gui Help:Add, Text, x22 y319 w50 h40 +Center, o
Gui Help:Add, Text, x22 y369 w50 h40 +Center, w
Gui Help:Add, Text, x22 y419 w50 h40 +Center, y
Gui Help:Add, Text, x82 y119 w50 h40 +Center, %a_chara%
Gui Help:Add, Text, x82 y169 w50 h40 +Center, %i_chara%
Gui Help:Add, Text, x82 y219 w50 h40 +Center, %u_chara%
Gui Help:Add, Text, x82 y269 w50 h40 +Center, %e_chara%
Gui Help:Add, Text, x82 y319 w50 h40 +Center, %o_chara%
Gui Help:Add, Text, x82 y369 w50 h40 +Center, %w_chara%
Gui Help:Add, Text, x82 y419 w50 h40 +Center, %y_chara%

eh_chara := "ㅔ"
ih_chara := "ㅐ"
yh_chara := "ㅖ"
ah_chara := "ㅑ"
wh_chara := "ㅒ"
uh_chara := "ㅠ"
oh_chara := "ㅛ"

Gui Help:Add, Text, x142 y119 w50 h40 +Center, ya
Gui Help:Add, Text, x142 y169 w50 h40 +Center, ai
Gui Help:Add, Text, x142 y219 w50 h40 +Center, yu
Gui Help:Add, Text, x142 y269 w50 h40 +Center, ye
Gui Help:Add, Text, x142 y319 w50 h40 +Center, yo
Gui Help:Add, Text, x142 y369 w50 h40 +Center, ee
Gui Help:Add, Text, x142 y419 w50 h40 +Center, yae
Gui Help:Add, Text, x202 y119 w50 h40 +Center, %ah_chara%
Gui Help:Add, Text, x202 y169 w50 h40 +Center, %ih_chara%
Gui Help:Add, Text, x202 y219 w50 h40 +Center, %uh_chara%
Gui Help:Add, Text, x202 y269 w50 h40 +Center, %yh_chara%
Gui Help:Add, Text, x202 y319 w50 h40 +Center, %oh_chara%
Gui Help:Add, Text, x202 y369 w50 h40 +Center, %eh_chara%
Gui Help:Add, Text, x202 y419 w50 h40 +Center, %wh_chara%

ue_chara := "ㅝ"
ueh_chara := "ㅞ"
ui_chara := "ㅟ"
wi_chara := "ㅢ"
oa_chara := "ㅘ"
oi_chara := "ㅚ"
oiH_chara := "ㅙ"

Gui Help:Add, Text, x262 y119 w50 h40 +Center, oa
Gui Help:Add, Text, x262 y169 w50 h40 +Center, oi
Gui Help:Add, Text, x262 y219 w50 h40 +Center, oai
Gui Help:Add, Text, x262 y269 w50 h40 +Center, ue
Gui Help:Add, Text, x262 y319 w50 h40 +Center, uee
Gui Help:Add, Text, x262 y369 w50 h40 +Center, ui
Gui Help:Add, Text, x262 y419 w50 h40 +Center, wi
Gui Help:Add, Text, x322 y119 w50 h40 +Center, %oa_chara%
Gui Help:Add, Text, x322 y169 w50 h40 +Center, %oi_chara%
Gui Help:Add, Text, x322 y219 w50 h40 +Center, %oiH_chara%
Gui Help:Add, Text, x322 y269 w50 h40 +Center, %ue_chara%
Gui Help:Add, Text, x322 y319 w50 h40 +Center, %ueh_chara%
Gui Help:Add, Text, x322 y369 w50 h40 +Center, %ui_chara%
Gui Help:Add, Text, x322 y419 w50 h40 +Center, %wi_chara%

Gui Help:Tab, Vowels (Dubeolshift)

Gui Help:Add, Text, x22 y119 w50 h40 +Center, a
Gui Help:Add, Text, x22 y169 w50 h40 +Center, i
Gui Help:Add, Text, x22 y219 w50 h40 +Center, u
Gui Help:Add, Text, x22 y269 w50 h40 +Center, e
Gui Help:Add, Text, x22 y319 w50 h40 +Center, o
Gui Help:Add, Text, x22 y369 w50 h40 +Center, w
Gui Help:Add, Text, x22 y419 w50 h40 +Center, y
Gui Help:Add, Text, x82 y119 w50 h40 +Center, %a_chara%
Gui Help:Add, Text, x82 y169 w50 h40 +Center, %i_chara%
Gui Help:Add, Text, x82 y219 w50 h40 +Center, %u_chara%
Gui Help:Add, Text, x82 y269 w50 h40 +Center, %e_chara%
Gui Help:Add, Text, x82 y319 w50 h40 +Center, %o_chara%
Gui Help:Add, Text, x82 y369 w50 h40 +Center, %w_chara%
Gui Help:Add, Text, x82 y419 w50 h40 +Center, %y_chara%

Gui Help:Add, Text, x142 y119 w50 h40 +Center, A
Gui Help:Add, Text, x142 y169 w50 h40 +Center, I
Gui Help:Add, Text, x142 y219 w50 h40 +Center, U
Gui Help:Add, Text, x142 y269 w50 h40 +Center, Y
Gui Help:Add, Text, x142 y319 w50 h40 +Center, O
Gui Help:Add, Text, x142 y369 w50 h40 +Center, E
Gui Help:Add, Text, x142 y419 w50 h40 +Center, W
Gui Help:Add, Text, x202 y119 w50 h40 +Center, %ah_chara%
Gui Help:Add, Text, x202 y169 w50 h40 +Center, %ih_chara%
Gui Help:Add, Text, x202 y219 w50 h40 +Center, %uh_chara%
Gui Help:Add, Text, x202 y269 w50 h40 +Center, %yh_chara%
Gui Help:Add, Text, x202 y319 w50 h40 +Center, %oh_chara%
Gui Help:Add, Text, x202 y369 w50 h40 +Center, %eh_chara%
Gui Help:Add, Text, x202 y419 w50 h40 +Center, %wh_chara%

Gui Help:Add, Text, x262 y119 w50 h40 +Center, oa
Gui Help:Add, Text, x262 y169 w50 h40 +Center, oi
Gui Help:Add, Text, x262 y219 w50 h40 +Center, oI
Gui Help:Add, Text, x262 y269 w50 h40 +Center, ue
Gui Help:Add, Text, x262 y319 w50 h40 +Center, uE
Gui Help:Add, Text, x262 y369 w50 h40 +Center, ui
Gui Help:Add, Text, x262 y419 w50 h40 +Center, wi
Gui Help:Add, Text, x322 y119 w50 h40 +Center, %oa_chara%
Gui Help:Add, Text, x322 y169 w50 h40 +Center, %oi_chara%
Gui Help:Add, Text, x322 y219 w50 h40 +Center, %oiH_chara%
Gui Help:Add, Text, x322 y269 w50 h40 +Center, %ue_chara%
Gui Help:Add, Text, x322 y319 w50 h40 +Center, %ueh_chara%
Gui Help:Add, Text, x322 y369 w50 h40 +Center, %ui_chara%
Gui Help:Add, Text, x322 y419 w50 h40 +Center, %wi_chara%

Gui Help:Tab, Vowels (SCIM Romaja)

Gui Help:Add, Text, x22 y119 w50 h40 +Center, a
Gui Help:Add, Text, x22 y169 w50 h40 +Center, i
Gui Help:Add, Text, x22 y219 w50 h40 +Center, u/w
Gui Help:Add, Text, x22 y269 w50 h40 +Center, eo
Gui Help:Add, Text, x22 y319 w50 h40 +Center, o
Gui Help:Add, Text, x22 y369 w50 h40 +Center, eu
Gui Help:Add, Text, x22 y419 w60 h40 +Center, y(eo)
Gui Help:Add, Text, x82 y119 w50 h40 +Center, %a_chara%
Gui Help:Add, Text, x82 y169 w50 h40 +Center, %i_chara%
Gui Help:Add, Text, x82 y219 w50 h40 +Center, %u_chara%
Gui Help:Add, Text, x82 y269 w50 h40 +Center, %e_chara%
Gui Help:Add, Text, x82 y319 w50 h40 +Center, %o_chara%
Gui Help:Add, Text, x82 y369 w50 h40 +Center, %w_chara%
Gui Help:Add, Text, x82 y419 w50 h40 +Center, %y_chara%

Gui Help:Add, Text, x142 y119 w50 h40 +Center, ya
Gui Help:Add, Text, x142 y169 w50 h40 +Center, ae
Gui Help:Add, Text, x142 y219 w50 h40 +Center, yu
Gui Help:Add, Text, x142 y269 w50 h40 +Center, ye
Gui Help:Add, Text, x142 y319 w50 h40 +Center, yo
Gui Help:Add, Text, x142 y369 w50 h40 +Center, e
Gui Help:Add, Text, x142 y419 w50 h40 +Center, yae
Gui Help:Add, Text, x202 y119 w50 h40 +Center, %ah_chara%
Gui Help:Add, Text, x202 y169 w50 h40 +Center, %ih_chara%
Gui Help:Add, Text, x202 y219 w50 h40 +Center, %uh_chara%
Gui Help:Add, Text, x202 y269 w50 h40 +Center, %yh_chara%
Gui Help:Add, Text, x202 y319 w50 h40 +Center, %oh_chara%
Gui Help:Add, Text, x202 y369 w50 h40 +Center, %eh_chara%
Gui Help:Add, Text, x202 y419 w50 h40 +Center, %wh_chara%

Gui Help:Add, Text, x262 y119 w50 h40 +Center, wa
Gui Help:Add, Text, x262 y169 w50 h40 +Center, oe
Gui Help:Add, Text, x262 y219 w50 h40 +Center, wae
Gui Help:Add, Text, x262 y269 w50 h40 +Center, wo
Gui Help:Add, Text, x262 y319 w50 h40 +Center, we
Gui Help:Add, Text, x262 y369 w50 h40 +Center, ui
Gui Help:Add, Text, x262 y419 w50 h40 +Center, eui
Gui Help:Add, Text, x322 y119 w50 h40 +Center, %oa_chara%
Gui Help:Add, Text, x322 y169 w50 h40 +Center, %oi_chara%
Gui Help:Add, Text, x322 y219 w50 h40 +Center, %oiH_chara%
Gui Help:Add, Text, x322 y269 w50 h40 +Center, %ue_chara%
Gui Help:Add, Text, x322 y319 w50 h40 +Center, %ueh_chara%
Gui Help:Add, Text, x322 y369 w50 h40 +Center, %ui_chara%
Gui Help:Add, Text, x322 y419 w50 h40 +Center, %wi_chara%

about_text =
(
..: Tips :..
- The default commit keys are Q and F. Use these to commit the character and move on to the next one.
- Holding Shift in Native Input allows for input of Latin characters, albeit in uppercase.
- In Dubeolshift, the Right Alt key toggles Hangul input regardless of whether character conversion is on or off.
- Hanja conversion is Right Ctrl, and requires the Korean IME installed, enabled and Hangul input enabled.
- Most settings are accessible from the tray icon, including quick toggling character conversion.

..: Settings Explanation :..
Automatic silent ieung (ㅇ):
Attempts to detect silent vowels and append the silent ieung as needed.
Only applicable for Dubeolshift. Native Input and SCIM Romaja automatically inputs the silent ieung.
The default manual ieung keys are X and V and can always be used.

Display all notifications:
Sends a notification every time character conversion is toggled on/off.

Windows change refresh delay:
The delay between checks whether the user is still on the same window, in seconds.
If false, the next vowel typed will have a silent ieung appended.
Requires Automatic silent ieung turned on.
Only applicable for Dubeolshift.

Powered by AutoHotkey %A_AhkVersion%.
Copyright (c) 2018 Viet Dinh.
)

Gui Help:Tab, About
Gui Help:Font, s10 norm
Gui Help:Add, Edit, x22 y119 w350 h340 ReadOnly VScroll, %about_text%
Gui Help:Font

if new_run {
	Gosub OpenHelpDialog
}
return

ButtonApply:
Gui, Submit, NoHide
Gosub WriteSettingsSub
Gosub Update_isActive
Gosub UpdateTrayMenu
if (R_InputMode = 2) {
	Goto SentryLoop
	return
}
return

ButtonOK:
Gui, Submit
Gosub WriteSettingsSub
Gosub Update_isActive
Gosub UpdateTrayMenu
if (R_InputMode = 2) {
	Goto SentryLoop
	return
}
return

ButtonCancel:
Gui, Hide
return

HelpButtonOK:
Gui Help:Hide
return

Update_R_InputMode:
GuiControlGet, toEnable,, R_InputMode
toEnable := (toEnable = 2)?1:0 ; position in DropDownBox
GuiControl, Enable%toEnable%, R_LeadingSilent
GuiControl, Enable%toEnable%, R_RefreshDelay
return

Toggle_R_InputMode:
R_InputMode := A_ThisMenuItemPos
IniWrite, %R_InputMode%, rm_settings.ini, General, InputMode
Gosub UpdateTrayMenu
return

Toggle_R_LeadingSilent:
R_LeadingSilent := !R_LeadingSilent
IniWrite, %R_LeadingSilent%, rm_settings.ini, General, LeadingSilent
Menu, Tray, ToggleCheck, Automatic silent ieung
return

UpdateTrayMenu:
if (R_InputMode = 1) {
	Menu, Tray, Check, Native Input
	Menu, Tray, Uncheck, Dubeolshift
	Menu, Tray, Uncheck, SCIM Romaja
}
else if (R_InputMode = 2) {
	Menu, Tray, Uncheck, Native Input
	Menu, Tray, Check, Dubeolshift
	Menu, Tray, Uncheck, SCIM Romaja
}
else if (R_InputMode = 3) {
	Menu, Tray, Uncheck, Native Input
	Menu, Tray, Uncheck, Dubeolshift
	Menu, Tray, Check, SCIM Romaja
}
Gosub WriteSettingsSub
isActiveTray := isActive?"Check":"Uncheck"
R_LeadingSilentTray := R_LeadingSilent?"Check":"Uncheck"
Menu, Tray, %isActiveTray%, Do character conversion`tAlt+1
Menu, Tray, %R_LeadingSilentTray%, Automatic silent ieung
return

OpenDialog:
Gosub GUI_Initialize
Gui %GuiHwnd%:Show, AutoSize, RomaShift %R_CurrentBuild%, Guiwindow
return

OpenHelpDialog:
Gui Help:Show, AutoSize, RomaShift - Help
return

OpenSettings:
Run, ms-settings:regionlanguage
return

OpenFolder:
Run, explore tables
return

EditTable:
Run, edit tables\%R_CurrentTable%
return

ButtonLoad:
PreviousTable := R_CurrentTable
FileSelectFile, R_CurrentTable,, tables, Select SCIM Table File, Documents (*.txt)
if (ErrorLevel = 0) {
	SplitPath, R_CurrentTable, R_CurrentTable
	IniWrite, %R_CurrentTable%, rm_settings.ini, General, ScimTable
	GuiControl,, R_CurrentTable, %R_CurrentTable%
	Gosub UpdateTable
	return
}
else R_CurrentTable := PreviousTable
return

