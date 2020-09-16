#persistent
#singleinstance force
#WinActivateforce
DetectHiddenWindows on
SetTitleMatchMode RegEx
20_ICO:="C:\Icon\20\delete.ico"
Menu, Tray, NoStandard
Menu, Tray, Icon, %20_ICO%
Menu, submenu1, Add, AHKRR, ahk_r
Menu, Tray, Add, AHK Rare Repo, :submenu1
Global KillCount:=0
WIN_TARGET_DESC=Information
MSG_WIN_TARGET=%WIN_TARGET_DESC%
MessageBoxKill(MSG_WIN_TARGET)
EventX:=0x0010 ;EVENT_SYSTEM_DIALOGSTART
AHK_Rare:="C:\Script\AHK\- Script\AHK-Rare-master\AHKRareTheGui.ahk"
Menu, Tray, Standard
OnEventX(hWinEventHook, event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime) {
	WIN_TARGET_DESC=Information
	MSG_WIN_TARGET=%WIN_TARGET_DESC%
	MessageBoxKill(MSG_WIN_TARGET)
	}

;Other scenarios may require a different method in dispatching target msgbox
MessageBoxKill(Target_MSGBOX) {
	If WinExist(Target_MSGBOX) {		
		winactivate
		send n
		KillCount:= KillCount + 1
		tooltip %KillCount% kills, 4000, 2000
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
return
ahk_r:
run %AHK_Rare%
return