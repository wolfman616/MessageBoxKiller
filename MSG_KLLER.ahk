#persistent
#singleinstance force
#WinActivateforce
DetectHiddenWindows on
SetTitleMatchMode RegEx
;SetTitleMatchMode, slow ;sendlevel 99

WIN_TARGET_DESC=Information
MSG_WIN_TARGET=%WIN_TARGET_DESC%
MessageBoxKill(MSG_WIN_TARGET)
EventX:=0x0010 ;EVENT_SYSTEM_DIALOGSTART
OnEventX(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WIN_TARGET_DESC=Information
	MSG_WIN_TARGET=%WIN_TARGET_DESC%
	MessageBoxKill(MSG_WIN_TARGET)
	}
;You may need a different criteria in closign target msgbox
MessageBoxKill(Target_MSGBOX) {
	If WinExist(Target_MSGBOX) {		
		winactivate
		send n
		}
}
hWinEventHook := DllCall("SetWinEventHook", "UInt", EventX, "UInt", EventX, "Ptr", 0, "Ptr", (lpfnWinEventProc := RegisterCallback("OnEventX", "")), "UInt", 0, "UInt", 0, "UInt", WINEVENT_OUTOFCONTEXT := 0x0000 | WINEVENT_SKIPOWNPROCESS := 0x0002)

OnExit("AtExit")
AtExit() {
	global hWinEventHook, lpfnWinEventProc
	if (hWinEventHook)
		DllCall("UnhookWinEvent", "Ptr", hWinEventHook), hWinEventHook := 0
	if (lpfnWinEventProc)
		DllCall("GlobalFree", "Ptr", lpfnWinEventProc, "Ptr"), lpfnWinEventProc := 0	
	return 0
	}

