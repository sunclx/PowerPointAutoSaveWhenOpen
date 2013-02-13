#NoTrayIcon
#OnAutoItStartRegister "onlyone"

#region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_Compression=4
#PRE_Res_requestedExecutionLevel=None
#PRE_Run_Tidy=y
#endregion ;**** 参数创建于 ACNWrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <File.au3>
Opt("WinTitleMatchMode", 2)
#region ### START Koda GUI section ### Form=
$frm = GUICreate("自动保存打开的PPT", 265, 272, 192, 124)
$grp1 = GUICtrlCreateGroup("文件位置", 8, 8, 249, 49)
$ipt = GUICtrlCreateInput("D:\09级七年制大四下", 16, 24, 233, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grp2 = GUICtrlCreateGroup("最近文件", 8, 64, 249, 193)
$lst = GUICtrlCreateList("", 16, 80, 153, 162)
$btn1 = GUICtrlCreateButton("读取", 176, 88, 75, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$btn2 = GUICtrlCreateButton("暂停", 176, 128, 75, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$btn3 = GUICtrlCreateButton("退出", 176, 168, 75, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_HIDE)
#endregion ### END Koda GUI section ###


Local $MyPath = "D:\09级七年制大四下", $MyFile = "", $SourceFile = ""
If Not FileExists($MyPath) Then DirCreate($MyPath)
Local $s = FileGetAttrib($MyPath)
If Not StringRegExp($s, "^.*S.*H.*D.*$") Then FileSetAttrib($MyPath, "+SH", 1)
Global $show
Local $oPPT
HotKeySet("^!p", "show")

While 1
	If WinExists("[TITLE:- PowerPoint;CLASS:PPTFrameClass]") Then
		If WinActive("[CLASS:PPTFrameClass]", "状态栏") Then
			If Not IsObj($oPPT) Then
				$oPPT = ObjGet("", "PowerPoint.Application")
			EndIf
			If IsObj($oPPT) Then
				$SourceFile = $oPPT.ActivePresentation.FullName
				$MyFile = $MyPath & "\" & $oPPT.ActivePresentation.Name
				If FileCopy($SourceFile, $MyPath, 8) Then
					FileSetAttrib($MyFile, "+SH")
				EndIf
			EndIf
			$oPPT = 0
		EndIf
	EndIf
	
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			show()
		Case $msg = $btn1
			_GUICtrlListBox_BeginUpdate($lst)
			_GUICtrlListBox_ResetContent($lst)
			_GUICtrlListBox_InitStorage($lst, 100, 4096)
			_GUICtrlListBox_Dir($lst, $MyPath & "\*.ppt?", BitOR($DDL_HIDDEN, $DDL_SYSTEM))
			_GUICtrlListBox_EndUpdate($lst)
		Case $msg = $btn2
			MsgBox(0, "", "暂停，按确定继续！")
		Case $msg = $btn3
			ExitLoop
	EndSelect
WEnd
Func show()
	$show = Not $show
	If $show Then
		GUISetState(@SW_SHOW, $frm)
	Else
		GUISetState(@SW_HIDE, $frm)
	EndIf
EndFunc   ;==>show
Func onlyone()
	If WinExists("[TITLE:自动保存打开的PPT;CLASS:AutoIt v3 GUI]") Then Exit
EndFunc   ;==>onlyone