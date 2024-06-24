#NoEnv
#SingleInstance Force

;****************************************************************** INFORMATION *******************************************************
Menu Tray, Icon, shell32.dll, 14
Gui +AlwaysOnTop
RunWith(32)
DLLPath:=A_ScriptDir "\USkin.dll"
StylesPath:=A_ScriptDir "\style\"

stylearray:=Object() ;create StyleArray to hold styles
Loop,% StylesPath "*.msstyles"
	stylearray.insert(A_LoopFilename)
total:= stylearray.MaxIndex() ;Get total number of styles
for key, value in stylearray {
	CurrentStyle:=value
	SkinForm(DLLPath,Apply, StylesPath . CurrentStyle)
	SkinForm(DLLPath,"0", StylesPath . CurrentStyle)	
}

SkinForm(DLLPath,Param1 = "Apply", SkinName = ""){
	if(Param1 = Apply){
		DllCall("LoadLibrary", str, DLLPath)
		DllCall(DLLPath . "\USkinInit", Int,0, Int,0, AStr, SkinName)
	}else if(Param1 = 0){
		DllCall(DLLPath . "\USkinExit")
	}
}

; 设置全局变量
global isRunning := false
global hwnd := 0

; 创建 GUI 界面
Gui, Add, Text, x10 y10 w200 h20 vWindowStatus, 未找到“寻道大千”
Gui, Add, Text, x10 y30 w200 h20 , Tips: 小程序设置为全屏并打开仙树页面再开启功能
Gui, Add, Text, x10 y60 w200 h20 vWindowHandle, 窗口句柄: (无)
Gui, Add, Text, x10 y80 w200 h20 vWindowPID, 进程 PID: (无)
Gui, Add, Button, x220 y20 w100 h30 gStartScript, 开启功能
Gui, Add, Button, x220 y70 w100 h30 gStopScript, 停止功能
Gui, Show, w330 h125, Tree GrowUp




; 定时器，每秒检查一次窗口和窗口进程 PID
SetTimer, CheckWindowAndPID, 1000

Return

CheckWindowAndPID:
    ; 检查窗口
    hwnd := WinExist("寻道大千")
    if hwnd
    {
        GuiControl,, WindowStatus, 已找到“寻道大千”
        
        ; 获取窗口进程 PID
        WinGet, pid, PID, ahk_id %hwnd%
        GuiControl,, WindowPID, 窗口进程 PID: %pid%
		GuiControl,, WindowHandle, 窗口句柄: %hwnd%
    }
    else
    {
        GuiControl,, WindowStatus, 未找到“寻道大千”
        GuiControl,, WindowPID, 窗口进程 PID: (无)
    }
Return

StartScript:
    isRunning := true
    SetTimer, ClickInWindow, 3000 ; 每5分钟执行一次
Return

StopScript:
    isRunning := false
    SetTimer, ClickInWindow, Off
Return

ClickInWindow:
    if hwnd
    {
        ; 将点击操作发送到指定窗口
        SetControlDelay -1
        ControlClick, x450 y906, ahk_id %hwnd% NA
        Sleep, 500

        ControlClick, x180 y845, ahk_id %hwnd% NA
        Sleep, 500

        ControlClick, x400 y640, ahk_id %hwnd% NA
        Sleep, 500

        ControlClick, x355 y941, ahk_id %hwnd% NA
        Sleep, 500
        ControlClick, x355 y941, ahk_id %hwnd% NA
        Sleep, 500
    }
Return

GuiClose:
ExitApp
runWith(version){	
	if (A_PtrSize=(version=32?4:8))
		Return
	
	SplitPath,A_AhkPath,,ahkDir ;get directory of AutoHotkey executable
	if (!FileExist(correct := ahkDir "\AutoHotkeyU" version ".exe")){
		MsgBox,0x10,"Error",% "Couldn't find the " version " bit Unicode version of Autohotkey in:`n" correct
		ExitApp
	}
	Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
	ExitApp
}