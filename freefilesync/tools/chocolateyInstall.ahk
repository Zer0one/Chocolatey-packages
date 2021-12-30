; This script will exit after 60 seconds
SetTimer, TimeOut, 60000

; Installer Windows ID String
; ID String for License Agreement window (Italian)
idText01 = Leggi il seguente contratto di licenza.
; ID String for Installer end window (Italian)
idText02 = Seleziona "Fine" per uscire dall'installazione.

; License Agreement window
SetTitleMatchMode, RegEx
WinWait, ‌ahk_exe i)\\FreeFileSync_\d+\.\d+_Windows_Setup\.\w{3}$, %idText01%
WinGet, id, ID, ahk_exe i)\\FreeFileSync_\d+\.\d+_Windows_Setup\.\w{3}$, %idText01%
DetectHiddenText, Off

WinActivate, ahk_id %id%
Sleep 1000

;;; Accept agreement button
;;; The Controls ID change every run. As a workaround contorls coordinate are used -> Coordinate change with zoom level...

;;; 100% Zoom
;; Click first radio buttuon a try
; Accept agreement button (Try 1)
ControlClick, x48 y361, ahk_id %id%,,,, NA ; ControlClick, > ?$, ahk_id %id%
; Next button (Try 1)
Send {Enter} ;ControlClick, TNewButton4, ahk_id %id%
sleep, 100

;; Check if on the same page and try the second radio button
WinGet, id, ID, ahk_exe i)\\FreeFileSync_\d+\.\d+_Windows_Setup\.\w{3}$, %idText01%
if (id != "") {
  ; Accept agreement button (Try 2)
  ControlClick, x48 y381, ahk_id %id%,,,, NA ; ControlClick, > ?$, ahk_id %id%
  ; Next button (Try 2)
  Send {Enter} ;ControlClick, TNewButton4, ahk_id %id%
  sleep, 100
}

;;; 125% Zoom
;; Click first radio buttuon a try
; Accept agreement button (Try 1)
ControlClick, x56 y426, ahk_id %id%,,,, NA ; ControlClick, > ?$, ahk_id %id%
; Next button (Try 1)
Send {Enter} ;ControlClick, TNewButton4, ahk_id %id%
sleep, 100

;; Check if on the same page and try the second radio button
WinGet, id, ID, ahk_exe i)\\FreeFileSync_\d+\.\d+_Windows_Setup\.\w{3}$, %idText01%
if (id != "") {
  ; Accept agreement button (Try 2)
  ControlClick, x56 y452, ahk_id %id%,,,, NA ; ControlClick, > ?$, ahk_id %id%
  ; Next button (Try 2)
  Send {Enter} ;ControlClick, TNewButton4, ahk_id %id%
  sleep, 100
}

; Next button in Destination Location window
Send {Enter}
sleep, 100 ; ControlClick, TNewButton6, ahk_id %id%

; Next on components page
Send {Enter} ; ControlClick, TNewButton6, ahk_id %id%
sleep, 100

; Next on animal picture page
Send {Enter} ; ControlClick, TNewButton6, ahk_id %id%
sleep, 1000

__Installing:
; ;Keep attempting to close window
; While( WinExist("ahk_id" . id, "...") )
;   sleep, 250
; 
; winget, ActiveControlList, ControlList, ahk_id %id%
; Active := 0
; Loop, Parse, ActiveControlList, `n
; {
;   ControlGet, CanSee, Visible ,, %A_LoopField%, ahk_id %id%
;   ControlGet, CanWork, Enabled ,, %A_LoopField%, ahk_id %id%
;   ControlGetText, RText, %A_LoopField%, ahk_id %id%
;   ControlGetPos, X, Y, W, H, %A_LoopField%, ahk_id %id%
;   If (CanSee and CanWork 
;        and W != 0 and H != 0
;        and InStr(A_LoopField,"button",false))
;     Active += 1
; }
; if (Active <= 1 and WinExist("ahk_id" . id)) 
;   goto __Installing

; ; Close the exection windows raised by the /silent args we don't even pass... !?
; ; Needed only by "official" installation method but cause some issue (see pwsh script for more details)
;  WinWait, FreeFileSync ahk_class #32770
;  WinActivate, FreeFileSync ahk_class #32770
;  Sleep 100
;  Send {Enter}
; 
; WinActivate, ahk_id %id%
; Sleep 1000

; __Ending:
;Keep attempting to close window
WinGet, id, ID, ahk_exe i)\\FreeFileSync_\d+\.\d+_Windows_Setup\.\w{3}$, %idText02%
if (id = "") {
    sleep 500
    goto __Installing
    ; goto __Ending
}

sleep, 250
Send {Enter} ; ControlClick, TNewButton4, ahk_id %id%
ExitApp

TimeOut:
ExitApp 60
