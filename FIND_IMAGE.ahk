#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Off

; Coordinates of the upper left corner of the image found
imgX := -1
imgY := -1

; Script arguments
PORT := A_Args[1]
IMG_PATH := A_Args[2]

URL := "http://localhost:" . PORT
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")

CoordMode Pixel

Loop {
	ImageSearch, imgX, imgY, 0, 0, A_ScreenWidth, A_ScreenHeight, *80 %IMG_PATH%
	if (imgX > 0 or imgY > 0) {
		xy := imgX . "," . imgY
		whr.Open("POST", URL, true)
		whr.SetRequestHeader("coords", xy)
		whr.Send()
		whr.WaitForResponse()
		break
	}
}

	

