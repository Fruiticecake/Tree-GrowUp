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
Gui, Add, Text, x10 y30 w200 h30 , Tips: 小程序设置为全屏并打开仙树页面再开启功能
Gui, Add, Text, x10 y60 w200 h20 vWindowHandle, 窗口句柄: (无)
Gui, Add, Text, x10 y80 w200 h20 vWindowPID, 进程 PID: (无)
Gui, Add, Button, x220 y20 w100 h30 gStartScript, 开启功能
Gui, Add, Button, x220 y70 w100 h30 gStopScript, 停止功能
Gui, Add, CheckBox, x10 y120 vTree, 仙树加速
Gui, Add, CheckBox, x120 y120 vStole, 自动偷桃
Gui, Add, CheckBox, x250 y120 vAuto, 自动领玉
Gui, Show, w330 h160, Tree GrowUp




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
    Gui, Submit, NoHide ; 获取复选框状态
    isRunning := true
    if (tree) {
        SetTimer, treeEvent, 300000
    }
    if (stole) {
        SetTimer, stoleEvent, 30000
    }
    if (auto) {
        SetTimer, autoClickEvent , 3000
    }
    
Return

StopScript:
    isRunning := false
    SetTimer, treeEvent, Off
Return

stoleEvent:

Return

autoClickEvent:

    if hwnd
    {
        ;100 928 #211909  107 932
        WinGetPos, X, Y, Width, Height, ahk_id %hwnd%
        ; 获取指定坐标的像素颜色
        CoordMode, Pixel, Screen
        PixelSearch, Px, Py, X + 100, Y + 928, X + 107, Y + 932, 0x211909, 3, Fast RGB
        if !ErrorLevel
        {
            SetControlDelay -1
            Sleep, 5000 
            ControlClick, x345 y900, ahk_id %hwnd% NA
            Sleep, 5000 
            ControlClick, x345 y900, ahk_id %hwnd% NA
            Sleep, 3000 
            ControlClick, x345 y900, ahk_id %hwnd% NA
        }    

    }

Return

treeEvent:
    if hwnd
    {
        WinSet, AlwaysOnTop, On, ahk_id %hwnd%
        ; 获取指定窗口的相对坐标
        WinGetPos, X, Y, Width, Height, ahk_id %hwnd%

        ; 窗口内的相对坐标
        RelX1 := 461
        RelY1 := 888
        RelX2 := 469
        RelY2 := 898

        ; 转换为屏幕坐标
        AbsX1 := X + RelX1
        AbsY1 := Y + RelY1
        AbsX2 := X + RelX2
        AbsY2 := Y + RelY2
        ; 获取指定坐标的像素颜色
        CoordMode, Pixel, Screen
        ;PixelGetColor, color, absX, absY, RGB
        PixelSearch, Px, Py, AbsX1, AbsY1, AbsX2, AbsY2, 0xDE443B, 3, Fast RGB
        if !ErrorLevel
        {
            SetControlDelay -1
            ControlClick, x446 y901, ahk_id %hwnd% NA
            Sleep, 500 
            PixelSearch, Px, Py, X + 163, Y + 826, AbsX2 + 177, AbsY2 + 835, 0xE1684D, 3, Fast RGB
            
            if !ErrorLevel
            {
                SetControlDelay -1
                ControlClick, x185 y844, ahk_id %hwnd% NA
                Sleep, 500 
                
                ControlClick, x400 y640, ahk_id %hwnd% NA
                Sleep, 500 

                ControlClick, x355 y941, ahk_id %hwnd% NA
                Sleep, 500
                ControlClick, x355 y941, ahk_id %hwnd% NA
                Sleep, 500
            }
            else
            {
                ControlClick, x355 y941, ahk_id %hwnd% NA
                Sleep, 500
                ControlClick, x355 y941, ahk_id %hwnd% NA
                Sleep, 500            
            }

        }            
        else
        {

        }
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

