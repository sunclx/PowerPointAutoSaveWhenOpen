#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <GuiButton.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <File.au3>
Opt("GUIOnEventMode", 1)



Local $frmMain, $lblTimer, $btnStart, $btnTask, $btnExtra, $btnInterrupt, $btnNext, $btnDel, $btnAdd, $lv
Local $frmNew, $btnNewOK, $iptNewName, $iptNewPomos
Local $frm,$btnOK,$ipt
Local $startTimeFlag = 0, $duration = 25, $shortBreak = 5, $longBreak = 20, $interval = 4, $startTime = 25
Local $runtime
Local $name, $e, $p, $u, $i
Local $ibtnNew = 0, $ii
Local $ia = 0, $ib = 0, $ic = 0,$iw

_main()

Func _main()
	createmainform()
	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	readDate()
	
	While 1
		If _GUICtrlListView_GetSelectedIndices($lv) <> "" Then
			_GUICtrlButton_Enable($btnStart, True)
			If _GUICtrlListView_GetItemCount($lv) > 1 Then
				_GUICtrlButton_Enable($btnNext, True)
			Else
				_GUICtrlButton_Enable($btnNext, False)
			EndIf
		Else
			_GUICtrlButton_Enable($btnStart, False)
		EndIf
		
		Sleep(100)
		If Not $startTimeFlag = 0 Then
			If $ic < $p Then
				Switch $ia
					Case 0
						If refleshlabel($startTime) Then
							$ia = 1
							$ib = $ib + 1
							$e+=1
							_GUICtrlListView_SetItemText($lv, $iw, $e, 1)
						EndIf
					Case 1
						If Mod($ib, $interval) = 0 Then
							If refleshlabel($longBreak) Then $ia = 2
						Else
							If refleshlabel($shortBreak) Then $ia = 2
						EndIf
						;ConsoleWrite("$ib="&$ib & @CRLF &"$p=" &$p)
					Case 2
						$ia = 0
						$ic = $ic + 1
						;$startTimeFlag = 0
						ConsoleWrite("$ib=" & $ib & @CRLF & "$p=" & $p)
				EndSwitch
			EndIf
		EndIf
	WEnd
EndFunc   ;==>_main

#region ## 界面函数 ###
Func createmainform();#region 主界面  ### START Koda GUI section ###
	;主窗口
	$frmMain = GUICreate("番茄钟", 282, 328, 433, 204)
	GUISetState()
	GUISetOnEvent($GUI_EVENT_CLOSE, "exitMain")
	;菜单
	$mtSet = GUICtrlCreateMenu("设置(&W)")
	$mtSetOpt = GUICtrlCreateMenuItem("选项", $mtSet)
	$mtSetSound = GUICtrlCreateMenuItem("声音", $mtSet)
	$mtSetTime = GUICtrlCreateMenuItem("时间", $mtSet)
	$mtSetAdvance = GUICtrlCreateMenuItem("高级", $mtSet)
	$mtStatics = GUICtrlCreateMenu("数据(&X)")
	$mtVeiw = GUICtrlCreateMenu("视图(&Y)")
	$mtAbout = GUICtrlCreateMenu("关于(&Z)")
	;主窗口控件
	$lblTimer = GUICtrlCreateLabel("25:00", 0, 0, 165, 84)
	GUICtrlSetFont(-1, 50, 400, 0)

	$btnStart = _GUICtrlButton_Create($frmMain, "开始", 170, 2, 107, 49)
	_GUICtrlButton_Enable($btnStart, False)
	$btnNext = _GUICtrlButton_Create($frmMain, "下一个", 170, 56, 107, 25)
	_GUICtrlButton_Enable($btnNext, False)
	$Group1 = GUICtrlCreateGroup("", 0, 88, 281, 49)
	$btnTask = _GUICtrlButton_Create($frmMain, "任务列表", 16, 104, 75, 25)
	$btnExtra = _GUICtrlButton_Create($frmMain, "额外增加", 108, 104, 75, 25)
	$btnInterrupt = _GUICtrlButton_Create($frmMain, "中断", 200, 104, 75, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$btnDel = _GUICtrlButton_Create($frmMain, "删除", 108, 280, 75, 25)
	$btnAdd = _GUICtrlButton_Create($frmMain, "新增", 200, 280, 75, 25)

	$lv = _GUICtrlListView_Create($frmMain, "Name|E|P|U|I", 0, 136, 281, 140)
	_GUICtrlListView_SetExtendedListViewStyle($lv, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
	_GUICtrlListView_SetColumnWidth($lv, 0, 100)
	_GUICtrlListView_SetColumnWidth($lv, 1, 40)
	_GUICtrlListView_SetColumnWidth($lv, 2, 40)
	_GUICtrlListView_SetColumnWidth($lv, 3, 40)
	_GUICtrlListView_SetColumnWidth($lv, 4, 40)

EndFunc   ;==>createmainform

Func creatnewtaskform();#region 新任务界面### START Koda GUI section ###
	$frmNew = GUICreate("新任务", 460, 38, 365, 183)
	GUISetOnEvent($GUI_EVENT_CLOSE, "frmNew")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "frmNew")

	$lblNewName = GUICtrlCreateLabel("事项：", 8, 7, 40, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$iptNewName = GUICtrlCreateInput("", 48, 7, 201, 20)
	$lblNewPomos = GUICtrlCreateLabel("番茄数：", 256, 7, 52, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$iptNewPomos = GUICtrlCreateInput("", 312, 7, 41, 20, BitOR($ES_AUTOHSCROLL, $ES_NUMBER))
	$lblNewPomos2 = GUICtrlCreateLabel("个", 360, 7, 16, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$btnNewOK = _GUICtrlButton_Create($frmNew, "确定", 376, 7, 75, 22)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
EndFunc   ;==>creatnewtaskform
Func createform($name="")
	$frm = GUICreate($name, 314, 41, 192, 124)
	GUISetOnEvent($GUI_EVENT_CLOSE, "frmNew")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "frmNew")

	$ipt = GUICtrlCreateInput("", 8, 8, 209, 24)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$btnOK = _GUICtrlButton_Create($frm, "确定", 232, 8, 75, 25)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)
EndFunc
#endregion ## 界面函数 ###
#region ## 控件函数 ###
Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	#forceref $hWnd, $Msg
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	Local $sText = ""
	$a = _GUICtrlListView_GetItem($lv, _GUICtrlListView_GetSelectedIndices($lv))
	Switch $hCtrl
		Case $btnStart
			If $nNotifyCode = $BN_CLICKED Then btnStart()
			;Switch $nNotifyCode
		Case $btnNewOK
			If $nNotifyCode = $BN_CLICKED Then btnNewOK()
		Case $btnTask
			If $nNotifyCode = $BN_CLICKED Then tasklist()
		Case $btnDel
			If $nNotifyCode = $BN_CLICKED Then del()
		Case $btnAdd
			If $nNotifyCode = $BN_CLICKED Then add()
		Case $btnOK
			If $nNotifyCode = $BN_CLICKED Then add()
			;EndSwitch
			;Return 0 ; Only workout clicking on the button
	EndSwitch
	; Proceed the default AutoIt3 internal message commands.
	; You also can complete let the line out.
	; !!! But only 'Return' (without any value) will not proceed
	; the default AutoIt3-message in the future !!!
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
;~ 	Local $tBuffer
	$hWndListView = $lv
	If Not IsHWnd($hWndListView) Then $hWndListView = GUICtrlGetHandle($hWndListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					itm()
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func uplaned()
EndFunc	
	
Func btnStart()
	Switch $ibtnNew
		Case 0
			setparam()
			$iw= _GUICtrlListView_GetSelectedIndices($lv)
			$startTimeFlag = TimerInit()
			_GUICtrlButton_SetText($btnStart, "停止")
			$ibtnNew = 1
		Case 1
			GUICtrlSetData($lblTimer, "25:00")
			$startTimeFlag = 0
			_GUICtrlButton_SetText($btnStart, "开始")
			$ibtnNew = 0
	EndSwitch
EndFunc   ;==>btnStart

Func exitMain()
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $frmMain, "int", 500, "long", 0x00090000)
	writeDate()
	Exit
EndFunc   ;==>exitMain
Func frmNew()
	GUIDelete ( $frmNew )
	GUIDelete ( $frm )
EndFunc   ;==>frmNew
Func tasklist()
	;GUICtrlSetState($lv,$GUI_HIDE)
	;GUICtrlSetState($btnDel,$GUI_HIDE)
	;GUICtrlSetState($btnAdd,$GUI_HIDE)
	;$a = WinGetClientSize($frmMain)
	;WinMove($frmMain, "", Default, Default, 282 + 6, 328)
	;$lblTimer = GUICtrlCreateLabel("25:00", 0, 0, 165, 84)
	
EndFunc   ;==>tasklist
Func btnNewOK()
	GUISetState(@SW_HIDE, $frmNew)
	If GUICtrlRead($iptNewPomos) > 0 Then
		$it = _GUICtrlListView_AddItem($lv, GUICtrlRead($iptNewName))
		_GUICtrlListView_AddSubItem($lv, $it, 0, 1)
		_GUICtrlListView_AddSubItem($lv, $it, GUICtrlRead($iptNewPomos), 2)
		_GUICtrlListView_AddSubItem($lv, $it, 0, 3)
		_GUICtrlListView_AddSubItem($lv, $it, 0, 4)
		_GUICtrlListView_SetItemSelected($lv, $it)
		setparam()
		_GUICtrlButton_Enable($btnStart, True)
		_GUICtrlButton_SetFocus($btnStart)
	EndIf
EndFunc   ;==>btnNewOK

Func btnOK()
	
	EndFunc
Func add()
	creatnewtaskform()
	GUISetState(@SW_SHOW, $frmNew)
EndFunc   ;==>add

Func del()
	_GUICtrlListView_DeleteItemsSelected($lv)
EndFunc   ;==>del
Func itm()
	
EndFunc   ;==>itm
#endregion ## 控件函数 ###
#region ### 功能函数 ###
Func refleshlabel($startTime = 25)
	$startTime = $startTime * 60
	$duration = Int(TimerDiff($startTimeFlag) / 1000)
	If $duration > $startTime Then
		$startTimeFlag = TimerInit()
		Return True
	EndIf
	$s = Mod($startTime - $duration, 60)
	If $s < 10 Then $s = "0" & $s
	GUICtrlSetData($lblTimer, Int(($startTime - $duration) / 60) & ":" & $s)
	Return False
EndFunc   ;==>refleshlabel

Func newPomo()
	
EndFunc   ;==>newPomo
Func setparam()
	$tmp = _GUICtrlListView_GetSelectedIndices($lv)
	$name = _GUICtrlListView_GetItemText($lv, $tmp, 0)
	$e = _GUICtrlListView_GetItemText($lv, $tmp, 1)
	$p = _GUICtrlListView_GetItemText($lv, $tmp, 2)
	$u = _GUICtrlListView_GetItemText($lv, $tmp, 3)
	$i = _GUICtrlListView_GetItemText($lv, $tmp, 4)
	ConsoleWrite("@$p=" & $p & @CRLF)
EndFunc   ;==>setparam

Func poro($ip, $s = $startTime, $sb = $shortBreak, $lb = $longBreak)
	If $ib < $ip Then
		Switch $ia
			Case 0
				If refleshlabel(0.2) Then $ia = 1
			Case 1
				If refleshlabel(0.1) Then $ia = 2
			Case 2
				$ia = 0
				$ib = $ib + 1
				ConsoleWrite($ib & @CRLF & $p)
		EndSwitch
	EndIf
	$ib = 0
	$startTimeFlag = 0
EndFunc   ;==>poro
Func readDate()
	Local $aRecords
	_FileReadToArray("tomator.ini", $aRecords)
	Local $tmp = StringRegExp($aRecords[1], "\[\d+\]\tname:(.*)\te:(\d+)\tp:(\d+)\tu:(\d+)\ti:(\d+)", 1)
	Local $aItem[UBound($aRecords)][UBound($tmp)]
	ConsoleWrite(UBound($aRecords))
	For $i = 1 To UBound($aRecords) - 1
		$tmp = StringRegExp($aRecords[$i], "\[\d+\]\tname:(.*)\te:(\d+)\tp:(\d+)\tu:(\d+)\ti:(\d+)", 1)
		For $j = 0 To UBound($tmp) - 1
			$aItem[$i - 1][$j] = $tmp[$j]
		Next
	Next
	_GUICtrlListView_AddArray($lv, $aItem)
	_GUICtrlListView_DeleteItem($lv,UBound($aRecords)-1)
EndFunc   ;==>readDate
Func writeDate()
	$x = _GUICtrlListView_GetItemCount($lv)
	$y = _GUICtrlListView_GetColumnCount($lv)
	ConsoleWrite($x)
	Local $s1 = "", $s2 = ""
	For $i = 0 To $x - 1
		$s1 = "[" & $i + 1 & "]"
		$s1&=Chr(9) &"name:"& _GUICtrlListView_GetItemText($lv, $i, 0)
		$s1&=Chr(9) &"e:"& _GUICtrlListView_GetItemText($lv, $i, 1)
		$s1&=Chr(9) &"p:"& _GUICtrlListView_GetItemText($lv, $i, 2)
		$s1&=Chr(9) &"u:"& _GUICtrlListView_GetItemText($lv, $i, 3)
		$s1&=Chr(9) &"i:"& _GUICtrlListView_GetItemText($lv, $i, 4)
		$s2 = $s2 & $s1
		If $i < $x - 1 Then $s2 = $s2 & @CRLF
	Next
	ConsoleWrite($s2)
	$file = FileOpen("tomator.ini", 2)
	FileWrite($file ,$s2)
	FileClose($file )
EndFunc   ;==>writeDate
#endregion ### 功能函数 ###
