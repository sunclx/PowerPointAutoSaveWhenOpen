#NoTrayIcon
#OnAutoItStartRegister "onlyone"

#region ;**** ���������� ACNWrapper_GUI ****
#PRE_Compression=4
#PRE_Res_requestedExecutionLevel=None
#PRE_Run_Tidy=y
#endregion ;**** ���������� ACNWrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <String.au3>
Opt("WinTitleMatchMode", 2)
#region ### START Koda GUI section ### Form=
$frm = GUICreate("�Զ�����򿪵�PPT", 265, 272, 192, 124)
$grp1 = GUICtrlCreateGroup("�ļ�λ��", 8, 8, 249, 49)
$ipt = GUICtrlCreateInput("D:\09�������ƴ�����", 16, 24, 233, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grp2 = GUICtrlCreateGroup("����ļ�", 8, 64, 249, 193)
$lst = GUICtrlCreateList("", 16, 80, 153, 162)
$btn1 = GUICtrlCreateButton("��ȡ", 176, 88, 75, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$btn2 = GUICtrlCreateButton("��ͣ", 176, 128, 75, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$btn3 = GUICtrlCreateButton("�˳�", 176, 168, 75, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_HIDE)
#endregion ### END Koda GUI section ###


Local $MyPath = "D:\09�������ƴ�����", $MyFile = "", $SourceFile = ""
If Not FileExists($MyPath) Then DirCreate($MyPath)
Local $s = FileGetAttrib($MyPath)
If Not StringRegExp($s, "^.*S.*H.*D.*$") Then FileSetAttrib($MyPath, "+SH", 1)
Global $show
Local $oPPT
HotKeySet("^!p", "show")

While 1
	If WinExists("[TITLE:- PowerPoint;CLASS:PPTFrameClass]") Then
		If WinActive("[CLASS:PPTFrameClass]", "״̬��") Then
			If Not IsObj($oPPT) Then
				$oPPT = ObjGet("", "PowerPoint.Application")
			EndIf
			If IsObj($oPPT) Then
				$SourceFile = $oPPT.ActivePresentation.FullName
				$course = '����'
				$f = FileOpen('dates.txt', 0)
				While 1
					$line = FileReadLine($f)
					If @error = -1 Then ExitLoop
					$array = StringSplit($line, ",")
					$date = @YEAR * 10000 + @MON * 100 + @MDAY
					$i = StringInStr($array[2], String(order()))
					If $date = Int($array[1]) And $i Then
						$course = $array[3]
						ExitLoop
					ElseIf $date < Int($array[1]) Then
						ExitLoop
					EndIf
				WEnd
				FileClose($f)
				Sleep(10000)
				$MyPath1 = $MyPath & "\" & $course
				If Not FileExists($MyPath1) Then DirCreate($MyPath1)
				$MyFile = $MyPath1 & "\" & $oPPT.ActivePresentation.Name
				If FileCopy($SourceFile, $MyPath1, 8) Then
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
			MsgBox(0, "", "��ͣ����ȷ��������")
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
	If WinExists("[TITLE:�Զ�����򿪵�PPT;CLASS:AutoIt v3 GUI]") Then Exit
EndFunc   ;==>onlyone
Func order()
	$time = @HOUR * 60 + @MIN
	Switch $time
		Case 8 * 60 To 8 * 60 + 40
			Return 1
		Case 8 * 60 + 50 To 8 * 60 + 90
			Return 2
		Case 8 * 60 + 100 To 8 * 60 + 140
			Return 3
		Case 8 * 60 + 150 To 8 * 60 + 190
			Return 4
		Case 8 * 60 + 200 To 8 * 60 + 240
			Return 5
		Case 14 * 60 To 14 * 60 + 40
			Return 6
		Case 14 * 60 + 50 To 14 * 60 + 90
			Return 7
		Case 14 * 60 + 100 To 14 * 60 + 140
			Return 8
		Case 14 * 60 + 150 To 14 * 60 + 190
			Return 9
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>order