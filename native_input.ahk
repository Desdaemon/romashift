; Native Romaja, no pre-existing IMEs dependencies, perfect for self-installation.
; Hanja conversion available via Korean IME if installed and enabled

;HC := 0 ; Head character, initial consonant
;MC := 0	; Middle character, medial vowels
;TC := 0 ; Tail character, final consonants

;fblock := ""
;current_block := 0
;TC_HC := {0:11,1:0,2:0,3:9,4:2,5:12,6:18,7:3,8:5,9:0,10:6,11:7,12:9,13:16,14:17,15:18,16:6,17:7,18:9,19:9,20:9,21:11,22:12,23:14,24:15,25:16,26:17,27:18}
;TC_prev := {0:0,1:0,2:1,3:1,4:0,5:4,6:4,7:0,8:0,9:8,10:8,11:8,12:8,13:8,14:8,15:8,16:0,17:0,18:17,19:0,20:19,21:0,22:0,23:0,24:0,25:0,26:0,27:0}
;HC_prev := {0:"ㄱ",1:"ㄲ",2:"ㄴ",3:"ㄷ",4:"ㄸ",5:"ㄹ",6:"ㅁ",7:"ㅂ",8:"ㅃ",9:"ㅅ",10:"ㅆ",11:"ㅇ",12:"ㅈ",13:"ㅉ",14:"ㅊ",15:"ㅋ",16:"ㅌ",17:"ㅍ",18:"ㅎ"}
;HC_double := {1:0,4:3,8:7,10:9,13:12}
;MC_prev := {1:0,2:6,3:2,4:"",5:4,6:"",7:6,8:"",9:8,10:9,11:8,12:"",13:"",14:13,15:14,16:13,17:"",18:"",19:18,20:""}

; Standard workflow:
; Start: Print initial consonant and update HC accordingly, shift
; ->	 Update medial vowel, build block, shift
; ->	 Update final consonant, build block, reset flags

BlockReset:
HC := 0
MC := 0
TC := 0
current_block := 0
return

BlockCommit:
Send {Right}
Gosub BlockReset
return

BlockShift:
if (current_block > 3) { ; initial, medial, final, confirm
	Gosub BlockReset
	return 
}
else {
	current_block++
	return
}
return

BlockUpdate:
Gosub BlockBuild
Gosub BlockShift
return

BlockBuild:
; builds fblock into character
; replaces the selected character and no more
chara := HC*588 + MC*28 + TC + 44032 ; formula from Wikipedia
hex := Format("0x{:X}",chara)
fblock := Chr(hex)
; debug
Send %fblock%
return

;TrayInfo:
;tooltip_text = % "Current block " current_block " HC " HC " MC " MC " TC " TC " chara " fblock
;Tooltip, %tooltip_text%
;return

; Hotkeys

#If (isActive && R_InputMode = 1)
*Space::
doDeselect := !(A_PriorKey = "Space") ? "{Right}" : "" 
Send %doDeselect%
Send {Space}
Gosub BlockReset
return

; Punctuations

~::
`::
1::
2::
3::
4::
5::
6::
7::
8::
9::
0::
+1::
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
+0::
-::
=::
,::
.::
/::
`;::
'::
[::
]::
*::
<::
>::
?::
:::
"::
+[::
+]::
_::
+=::
Gosub BlockCommit
Send %A_ThisHotkey%
return

q::
f:: ;commit key
Gosub BlockCommit
return

*Backspace::
if (current_block = 3) {
	if (TC_prev[TC] = 0) {
		current_block--
	}
	TC := TC_prev[TC]
	Gosub BlockBuild
	Send +{Left}
	return
} else if (current_block = 2) {
	if (MC_prev[MC] <> "") {
		MC := MC_prev[MC]
		Gosub BlockBuild
		Send +{Left}
		return
	}
	current_block--
	chara := HC_prev[HC]
	Send %chara%
	Send +{Left}
	return
} else if (current_block = 1) {
	if (HC_double[HC] <> "") {
		HC := HC_double[HC]
		chara := HC_prev[HC]
		Send %chara%
		Send +{Left}
		return
	}
	Send {Backspace}
	Gosub BlockReset
	return
} else {
	Send {Backspace}
	Gosub BlockReset
	return
}
return

h::
; basic consonant
if (current_block = 0) { ;intitial
	HC := 18
	Send ㅎ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 27 
	Gosub BlockUpdate
	Send +{Left}
	return
} else if (current_block = 3 && (TC = 4 || TC = 8)) { ;double final n l
	TC := (TC = 4) ? 6 : 15
	Gosub BlockBuild
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 18
	Send ㅎ
	Send +{Left}
	Gosub BlockShift
	return
}
return

p::
; basic consonant
if (current_block = 0) { ;intitial
	HC := 17
	Send ㅍ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 26
	Gosub BlockUpdate
	Send +{Left}
	return
} else if (current_block = 3 && TC = 8) { ;double final l
	TC := 14
	Gosub BlockBuild
	Send +{Left}
	return
}
else { ;consonant exit
	Gosub BlockCommit
	HC := 17
	Send ㅍ
	Send +{Left}
	Gosub BlockShift
	return
}
return

c::
; basic consonant
if (current_block = 0) { ;intitial
	HC := 14
	Send ㅊ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 23
	Gosub BlockUpdate
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 14
	Send ㅊ
	Send +{Left}
	Gosub BlockShift
	return
}
return

g:: 
; Consonant with double form
if (current_block = 0) { ;initial
	HC := 0
	Send ㄱ
	Send +{Left}
	Gosub BlockShift
	return
} else if (HC = 0 && current_block = 1) { ;double initial
	HC := 1
	Send ㄲ
	Send +{Left}
	return
} else if (current_block = 2) { ;final
	TC := 1
	Gosub BlockUpdate
	Send +{Left}
	return
} else if (current_block = 3 && (TC = 1 || TC = 8)) { ;double final
	TC := (TC = 1) ? 2 : 9
	Gosub BlockBuild
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 0
	Send ㄱ
	Send +{Left}
	Gosub BlockShift
	return
}
return

d:: 
; Consonant with double form
if (current_block = 0) { ;initial
	HC := 3
	Send ㄷ
	Send +{Left}
	Gosub BlockShift
	return
} else if (HC = 3 && current_block = 1) { ;double initial
	HC := 4
	Send ㄸ
	Send +{Left}
	return
} else if (current_block = 2) { ;final
	TC := 7
	Gosub BlockUpdate
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 3
	Send ㄷ
	Send +{Left}
	Gosub BlockShift
	return
}
return

j:: 
; Consonant with double form
if (current_block = 0) { ;initial
	HC := 12
	Send ㅈ
	Send +{Left}
	Gosub BlockShift
	return
} else if (HC = 12 && current_block = 1) { ;double initial
	HC := 13
	Send ㅉ
	Send +{Left}
	return
} else if (current_block = 2) { ;final
	TC := 22
	Gosub BlockUpdate
	Send +{Left}
	return
} else if (current_block = 3 && TC = 4) { ;double final
	TC++
	Gosub BlockBuild
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 12
	Send ㅈ
	Send +{Left}
	Gosub BlockShift
	return
}
return

b:: 
; Consonant with double form
if (current_block = 0) { ;initial
	HC := 7
	Send ㅂ
	Send +{Left}
	Gosub BlockShift
	return
} else if (HC = 7 && current_block = 1) { ;double initial
	HC := 8
	Send ㅃ
	Send +{Left}
	return
} else if (current_block = 2) { ;final
	TC := 17
	Gosub BlockUpdate
	Send +{Left}
	return
} else if (current_block = 3 && TC = 8) { ;double final
	TC := 11
	Gosub BlockBuild
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 7
	Send ㅂ
	Send +{Left}
	Gosub BlockShift
	return
}
return

s:: 
; Consonant with double form
if (current_block = 0) { ;initial
	HC := 9
	Send ㅅ
	Send +{Left}
	Gosub BlockShift
	return
} else if (HC = 9 && current_block = 1) { ;double initial
	HC := 10
	Send ㅆ
	Send +{Left}
	return
} else if (current_block = 2) { ;final
	TC := 19
	Gosub BlockUpdate
	Send +{Left}
	return
} else if (current_block = 3 && (TC = 1 || TC = 8 || TC = 17 || TC = 19)) { ;double final, g l s b 
	if (TC > 8) {
		TC++
	}
	else if (TC = 8) {
		TC := 12
	}
	else {
		TC := 3
	}
	Gosub BlockBuild
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 9
	Send ㅅ
	Send +{Left}
	Gosub BlockShift
	return
}
return

x::
v::
if (current_block = 0) { ;initial
	HC := 11
	Send ㅇ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 21
	Gosub BlockUpdate
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 11
	Send ㅇ
	Send +{Left}
	Gosub BlockShift
	return
}
return

n:: 
if (current_block = 0) { ;initial
	HC := 2
	Send ㄴ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 4
	Gosub BlockUpdate
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 2
	Send ㄴ
	Send +{Left}
	Gosub BlockShift
	return
}
return

k:: 
if (current_block = 0) { ;initial
	HC := 15
	Send ㅋ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 24
	Gosub BlockUpdate
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 15
	Send ㅋ
	Send +{Left}
	Gosub BlockShift
	return
}
return

t:: 
if (current_block = 0) { ;initial
	HC := 16
	Send ㅌ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 25
	Gosub BlockUpdate
	Send +{Left}
	return
} else if (current_block = 3 && TC = 8) { ;double final
	TC := 13
	Gosub BlockBuild
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 16
	Send ㅌ
	Send +{Left}
	Gosub BlockShift
	return
}
return

m:: 
if (current_block = 0) { ;initial
	HC := 6
	Send ㅁ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 16
	Gosub BlockUpdate
	Send +{Left}
	return
}  else if (current_block = 3 && TC = 8) { ;double final
	TC := 10
	Gosub BlockBuild
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 6
	Send ㅁ
	Send +{Left}
	Gosub BlockShift
	return
}
return

l::
r::
if (current_block = 0) { ;initial
	HC := 5
	Send ㄹ
	Send +{Left}
	Gosub BlockShift
	return
} else if (current_block = 2) { ;final
	TC := 8
	Gosub BlockUpdate
	Send +{Left}
	return
} else { ;consonant exit
	Gosub BlockCommit
	HC := 5
	Send ㄹ
	Send +{Left}
	Gosub BlockShift
	return
}
return

; Vowels

a::
if (current_block = 0) { ;silent ieung and medial
	HC := 11 ; ieung character code
	MC := 0
	current_block := 2
	Send 아
	Send +{Left}
	return
}
else if (current_block = 1) { ;medial
	MC := 0
	Gosub BlockUpdate
	Send +{Left}
	return
}
else if (current_block = 2 && (MC = 6 || MC = 8)) {
	MC := MC = 6 ? 2 : 9
	Gosub BlockBuild
	Send +{Left}
	return
}
else { ;consonant theft
	rescue := TC , TC := TC_prev[TC]
	Gosub BlockBuild
	Gosub BlockReset
	HC := TC_HC[rescue]
	MC := 0
	current_block := 2
	Gosub BlockBuild
	Send +{Left}
	return
}
return

i::
if (current_block = 0) { ;silent ieung and medial
	HC := 11 ; ieung character code
	MC := 20
	current_block := 2
	Send 이
	Send +{Left}
	return
}
else if (current_block = 1) { ;medial
	MC := 20
	Gosub BlockUpdate
	Send +{Left}
	return
}
else if (current_block = 2 && (MC = 0 || MC = 8 || MC = 9 || MC = 13 || MC = 18)) { ; a o w u oa
	if (MC = 8 || MC = 13) {
		MC += 3
	}
	else {
		MC++
	}
	Gosub BlockBuild
	Send +{Left}
	return
}
else {
	rescue := TC , TC := TC_prev[TC]
	Gosub BlockBuild
	Gosub BlockReset
	HC := TC_HC[rescue]
	MC := 20
	current_block := 2
	Gosub BlockBuild
	Send +{Left}
	return
}
return

y::
if (current_block = 0) { ;silent ieung and medial
	HC := 11 ; ieung character code
	MC := 6
	current_block := 2
	Send 여
	Send +{Left}
	return
}
else if (current_block = 1) { ;medial
	MC := 6
	Gosub BlockUpdate
	Send +{Left}
	return
}
else {
	rescue := TC , TC := TC_prev[TC]
	Gosub BlockBuild
	Gosub BlockReset
	HC := TC_HC[rescue]
	MC := 6
	current_block := 2
	Gosub BlockBuild
	Send +{Left}
	return
}
return

o::
if (current_block = 0) { ;silent ieung and medial
	HC := 11 ; ieung character code
	MC := 8
	current_block := 2
	Send 오
	Send +{Left}
	return
}
else if (current_block = 1) { ;medial
	MC := 8
	Gosub BlockUpdate
	Send +{Left}
	return
}
else if (current_block = 2 && MC = 6) {
	MC := 12
	Gosub BlockBuild
	Send +{Left}
	return
}
else {
	rescue := TC , TC := TC_prev[TC]
	Gosub BlockBuild
	Gosub BlockReset
	HC := TC_HC[rescue]
	MC := 8
	current_block := 2
	Gosub BlockBuild
	Send +{Left}
	return
}
return

u::
if (current_block = 0) { ;silent ieung and medial
	HC := 11 ; ieung character code
	MC := 13
	current_block := 2
	Send 우
	Send +{Left}
	return
}
else if (current_block = 1) { ;medial
	MC := 13
	Gosub BlockUpdate
	Send +{Left}
	return
}
else if (current_block = 2 && MC = 6) {
	MC := 17
	Gosub BlockBuild
	Send +{Left}
	return
}
else {
	rescue := TC , TC := TC_prev[TC]
	Gosub BlockBuild
	Gosub BlockReset
	HC := TC_HC[rescue]
	MC := 13
	current_block := 2
	Gosub BlockBuild
	Send +{Left}
	return
}
return

w::
if (current_block = 0) { ;silent ieung and medial
	HC := 11 ; ieung character code
	MC := 18
	current_block := 2
	Send 으
	Send +{Left}
	return
}
else if (current_block = 1) { ;medial
	MC := 18
	Gosub BlockUpdate
	Send +{Left}
	return
}
else {
	rescue := TC , TC := TC_prev[TC]
	Gosub BlockBuild
	Gosub BlockReset
	HC := TC_HC[rescue]
	MC := 18
	current_block := 2
	Gosub BlockBuild
	Send +{Left}
	return
}
return

e::
if (current_block = 0) { ;silent ieung and medial
	HC := 11 ; ieung character code
	MC := 4
	current_block := 2
	Send 어
	Send +{Left}
	return
}
else if (current_block = 1) { ;medial
	MC := 4
	Gosub BlockUpdate
	Send +{Left}
	return
}
else if (current_block = 2 && (MC = 2 || MC = 4 || MC = 6 || MC = 13 || MC = 14 )) {
	MC++
	Gosub BlockBuild
	Send +{Left}
	return
}
else {
	rescue := TC , TC := TC_prev[TC]
	Gosub BlockBuild
	Gosub BlockReset
	HC := TC_HC[rescue]
	MC := 4
	current_block := 2
	Gosub BlockBuild
	Send +{Left}
	return
}
return

