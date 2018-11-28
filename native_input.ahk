; Native Romaja, no pre-existing IMEs dependencies, perfect for self-installation.
; Hanja conversion available via Korean IME if installed and enabled

; Standard workflow:
; Start: Print initial consonant and update HC accordingly, shift
; ->	 Update medial vowel, build block, shift
; ->	 Update final consonant, build block, reset flags

BlockReset:
HC := 0
MC := 0
TC := 0
current_block := 0
current_empty := 1
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
Gosub TimerStart
Gosub BlockBuild
Gosub BlockShift
Gosub TimerStop
return

BlockBuild:
; builds fblock into character
; replaces the selected character and no more
chara := HC*588 + MC*28 + TC + 44032 ; formula from Wikipedia
hex := Format("0x{:X}",chara)
fblock := Chr(hex)

; debug
Send %fblock%
current_empty := 0
;Gosub TrayInfo
return

;TrayInfo:
;tooltip_text = % "Current block " current_block " HC " HC " MC " MC " TC " TC " chara " fblock " current_empty " current_empty
;Tooltip, %tooltip_text%
;return

; Hotkeys

#If (isActive && R_InputMode = 1)
*Space::
if (current_empty = 0) {
	Send {Right}
}
Send {Space}
Gosub BlockReset
return

Left::
Right::
Up::
Down::
Send {%A_ThisHotkey%}
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
":: ;"
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

