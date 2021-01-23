#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Off

imgX := -1
imgY := -1
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
CoordMode Pixel
Loop {
	ImageSearch, imgX, imgY, 0, 0, A_ScreenWidth, A_ScreenHeight, *80 C:\Users\Admin\Desktop\cs_accepter\accept.bmp
	if (imgX > 0 or imgY > 0) {
		xy := imgX . "," . imgY
		whr.Open("GET", "http://localhost:3000", true)
		whr.SetRequestHeader("Cookie", xy)
		whr.Send()
		whr.WaitForResponse()
		break
	}
}
	

