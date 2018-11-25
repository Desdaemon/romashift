;SCIM Romaja, uses SCIM Hangul Romaja table to provide human-friendly input
;User-customizable, can be adopted for other tables
;SetBatchLines, -1

;chara := ComObjCreate("Scripting.Dictionary")
;current_string = 
;current_chara = 
;current_key = 
;isActive := 0

#If (isActive && R_InputMode = 3)
q::
w::
e::
r::
t::
y::
u::
i::
o::
p::
a::
s::
d::
f::
g::
h::
j::
k::
l::
z::
x::
c::
v::
b::
n::
m::
current_string .= A_ThisHotkey	; append key to stack
;ToolTip, %current_string%, A_CaretX, A_CaretY + 35
Gosub SearchLoop	; search for chara, return chara if exist

; if not exist

theft_string := SubStr(current_string, -1)	; take last 2 characters for theft

if (chara.item(theft_string) <> "") {
	current_string := SubStr(current_string, 1, -2)
	Gosub SubSearchLoop
	Send {Right}
	current_string := theft_string
	Gosub SearchLoop
	return
} else {
	theft_string := SubStr(theft_string, 2)
	current_string := SubStr(current_string, 1, -1)
	Gosub SubSearchLoop
	Send {Right}
	current_string := theft_string
	Gosub SearchLoop
	return
}
return

+q::
+w::
+e::
+r::
+t::
+y::
+u::
+i::
+o::
+p::
+a::
+s::
+d::
+f::
+g::
+h::
+j::
+k::
+l::
+z::
+x::
+c::
+v::
+b::
+n::
+m::
current_key := Format("{:U}", LTrim(A_ThisHotkey, "+"))
current_string .= current_key
;ToolTip, %current_string%, A_CaretX, A_CaretY + 35
Gosub SearchLoop

theft_string := SubStr(current_string, -1)	; take last 2 characters for theft

if (chara.item(theft_string) <> "") {
	current_string := SubStr(current_string, 1, -2)
	Gosub SubSearchLoop
	Send {Right}
	current_string := theft_string
	Gosub SearchLoop
	return
} else {
	theft_string := SubStr(theft_string, 2)
	current_string := SubStr(current_string, 1, -1)
	Gosub SubSearchLoop
	Send {Right}
	current_string := theft_string
	Gosub SearchLoop
	return
}
return

Right::
Left::
Up::
Down::
Send {%A_ThisHotkey%}
current_string = 
return

*Backspace::
current_string := SubStr(current_string, 1, -1)
;ToolTip, %current_string%, A_CaretX, A_CaretY + 35
if (current_string = "") {
	Send {Backspace}
	return
} else {
	Gosub SearchLoop
	return
}
return

+Backspace::
current_string = 
Send {Backspace}
return

Space::
Enter::
;ToolTip,
if (A_PriorKey <> A_ThisHotkey) {
	Send {Right}
}
Send {%A_ThisHotkey%}
current_string = 
return

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
current_string = 
Send {Right}
Send %A_ThisHotkey%
return
; "
SearchLoop:
result := chara.item(current_string)
if (result <> "") {
	current_chara := result
	Send {%current_chara%}
	Send +{Left}
	Exit
}
return

SubSearchLoop:
result := chara.item(current_string)
if (result <> "") {
	current_chara := result
	Send {%current_chara%}
	Send +{Left}
	return
}
return


