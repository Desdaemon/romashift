; Dubeolshift, piggybacks on preinstalled Dubeolsik layout to provide Romaja input
; Only option with Hanja conversion by RCtrl (for now?)

; Initialization begins
;isNormal_U := 0
;isNormal_W := 0
;isNormal_O := 0
;isSilent = True

ResetVar:
isNormal_U := 0
isNormal_W := 0
isNormal_O := 0
return

NormalSend:
Send {%chara% DownR}
Send {%chara% Up}
Gosub ResetVar
return

SpecialSend:
Send {d DownR}
Send {d Up}	
Send {%chara% DownR}
Send {%chara% Up}	
Gosub ResetVar
return

UpdateSendCommand:
SendCommand := isSilent ? "SpecialSend" : "NormalSend"
return



; No leading ieung
#If (isActive && !R_LeadingSilent && R_InputMode = 2)
b::q
j::w
d::e
g::r
s::t
m::a
n::s
l::f
r::f
h::g
k::z
t::x
p::v

x::d
v::d ; ieung character

q::
f::
Send {Left}{Right}
return ; commit key

w::n
e::j
i::l
o::h
y::u
u::m
a::k

+w::SendRaw b
+e::SendRaw p
+i::SendRaw o
+o::SendRaw y
+y::SendRaw P
+u::SendRaw O
+a::SendRaw i

; With leading ieung
#If (isActive && R_LeadingSilent && R_InputMode = 2)
b::
chara = q
Gosub NormalSend
isSilent := 0
return

+b::
chara = Q
Gosub NormalSend
isSilent := 0
return

j::
chara = w
Gosub NormalSend
isSilent := 0
return

+j::
chara = W
Gosub NormalSend
isSilent := 0
return

d::
chara = e
Gosub NormalSend
isSilent := 0
return

+d::
chara = E
Gosub NormalSend
isSilent := 0
return

g::
chara = r
Gosub NormalSend
isSilent := 0
return

+g::
chara = R
Gosub NormalSend
isSilent := 0
return

s::
chara = t
Gosub NormalSend
isSilent := 0
return

+s::
chara = T
Gosub NormalSend
isSilent := 0
return 

m::
+m::
chara = a
Gosub NormalSend
isSilent := 0
return

n::
+n::
chara = s
Gosub NormalSend
isSilent := 0
return

l::
+l::
chara = f
Gosub NormalSend
isSilent := 0
return

r::
+r::
chara = f
Gosub NormalSend
isSilent := 0
return

h::
+h::
chara = g
Gosub NormalSend
isSilent := 0
return

k::
+k::
chara = z
Gosub NormalSend
isSilent := 0
return

t::
+t::
chara = x
Gosub NormalSend
isSilent := 0
return

p::
+p::
chara = v
Gosub NormalSend
isSilent := 0
return

c::
+c::
chara = c
Gosub NormalSend
isSilent := 0
return

x::
+x::
v::
+v::
chara = d
Gosub NormalSend
isSilent := 0
return

q::
+q::
f::
+f::
Send {Left}{Right}
Gosub ResetVar
isSilent := 1
return

*Space::
Send {Space}
Gosub ResetVar
isSilent := 1
return

*Enter::
Send {Enter}
Gosub ResetVar
isSilent := 1
return

*Backspace::
Send {Backspace}
isSilent := 0
return

; Vowels

e::
chara = j
if isNormal_W {
	Gosub NormalSend
	isSilent := 1
	return
}
else {
	Gosub UpdateSendCommand
	Gosub %SendCommand%
	isSilent := 1
	return
}
return

i::
pkey := A_PriorKey
chara = l
if InStr("uwo", pkey) {
	Gosub NormalSend
	isSilent := 1
	return
}
else {
	Gosub UpdateSendCommand
	Gosub %SendCommand%
	isSilent := 1
	return
}
return

y::
chara = u
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
return

a::
chara = k
if isNormal_O {
	Gosub NormalSend
	isSilent := 1
	return
}
else {
	Gosub UpdateSendCommand
	Gosub %SendCommand%
	isSilent := 1
	return
}
return

w:: ;old u
chara = m
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
isNormal_U := 1
return

u:: ;old w
chara = n
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
isNormal_W := 1
return

o::
chara = h
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
isNormal_O := 1
return


+e::
chara = p
if isNormal_W {
	Gosub NormalSend
	isSilent := 1
	return
}
else {
	Gosub UpdateSendCommand
	Gosub %SendCommand%
	isSilent := 1
	return
}
return

+i::
chara = o
if isNormal_O {
	Gosub NormalSend
	isSilent := 1
	return
}
else {
	Gosub UpdateSendCommand
	Gosub %SendCommand%
	isSilent := 1
	return
}
return

+y::
chara = P
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
return

+a::
chara = i
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
return

+w:: ;old u
chara = O
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
return

+u:: ;old w
chara = b
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
return

+o::
chara = y
Gosub UpdateSendCommand
Gosub %SendCommand%
isSilent := 1
return

; Sentry loop
SentryLoop:
current_window := WinExist("A")
Loop
{
	sentry_window := WinExist("A")
	if (current_window <> sentry_window) {
		Gosub ResetVar
		isSilent := 1
		current_window := sentry_window
	}
	Sleep, % R_RefreshDelay*1000
	if R_InputMode <> 2
		break
}
return