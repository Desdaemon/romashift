;SCIM Romaja, uses SCIM Hangul Romaja table to provide human-friendly input
;User-customizable, can be adopted for other tables

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
Gosub TimerStart

current_string .= A_ThisHotkey	; append key to stack
Gosub SearchLoop	; search for chara, return chara if exist

; if not exist

theft_string := SubStr(current_string, -1)
theft_result := chara.item(theft_string)	; take last 2 characters for theft

if (theft_result <> "") {
	current_string := SubStr(current_string, 1, -2)
	result := chara.item(current_string)
	
	Send % result theft_result
	Send +{Left}
	current_string := theft_string
	
	Gosub TimerStop
	
	return
} 
else
{
	theft_string := SubStr(theft_string, 2)
	current_string := SubStr(current_string, 1, -1)
	theft_result := chara.item(theft_string)
	result := chara.item(current_string)
	
	Send % result theft_result
	Send +{Left}
	current_string := theft_string
	
	Gosub TimerStop
	
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
Gosub TimerStart
current_key := Format("{:U}", LTrim(A_ThisHotkey, "+"))
current_string .= current_key
Gosub SearchLoop

theft_string := SubStr(current_string, -1)
theft_result := chara.item(theft_string)	; take last 2 characters for theft

if (theft_result <> "") {
	current_string := SubStr(current_string, 1, -2)
	result := chara.item(current_string)
	
	Send % result theft_result
	Send +{Left}
	current_string := theft_string
	
	Gosub TimerStop
	return
}
else
{
	theft_string := SubStr(theft_string, 2)
	current_string := SubStr(current_string, 1, -1)
	theft_result := chara.item(theft_string)
	result := chara.item(current_string)
	
	Send % result theft_result
	Send +{Left}
	current_string := theft_string
	
	Gosub TimerStop
	
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
Gosub TimerStart
current_string := SubStr(current_string, 1, -1)
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
if (current_string <> "")
	Send {Right}
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
	Send %current_chara%+{Left}
	Gosub TimerStop
	
	Exit
}
return


