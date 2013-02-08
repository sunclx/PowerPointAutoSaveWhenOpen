#NoTrayIcon
Local $lastSave = ""
Local $MyPath = "D:\09级七年制大四下"
If Not FileExists($MyPath) Then DirCreate($MyPath)
WinWaitActive("[CLASS:PPTFrameClass]", "")
$lastSave = _SaveCopyAs()

Func _SaveCopyAs()
	Local $oPPT
	Local $a = FileGetAttrib($MyPath)
	If Not StringRegExp($a, "^.*S.*H.*D.*$") Then FileSetAttrib($MyPath, "+SH", 1)
	For $i = 1 To 10
		$oPPT = ObjGet("", "PowerPoint.Application")
		If IsObj($oPPT) Then ExitLoop
	Next
	If $i >= 10 Then Return
	Sleep(1000)
	$MyPath = $MyPath & "\" & $oPPT.ActivePresentation.Name
	If Not FileExists($MyPath) Then $oPPT.ActivePresentation.SaveCopyAs($MyPath)
	If FileExists($MyPath) Then
		FileSetAttrib($MyPath, "+SH")
		Return $MyPath
	EndIf
EndFunc   ;==>_SaveCopyAs