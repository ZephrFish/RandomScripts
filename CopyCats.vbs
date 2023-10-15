
'CopyCats
Option Explicit

Dim objFSO, objNetwork, strDriveLetter, strUNCPath

strDriveLetter = "U:"  ' You can choose any available drive letter.
strUNCPath = "\\PATH\TO\UNC\c$"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objNetwork = CreateObject("WScript.Network")

' Map network drive with specific credentials
WScript.Echo "Mapping network drive " & strDriveLetter & " to " & strUNCPath & " with specific credentials..."
objNetwork.MapNetworkDrive strDriveLetter, strUNCPath, False, "DOMAIN\MODIFYME", "PASSWORD"

' Copy the file using the mapped drive
WScript.Echo "Copying file from " & strDriveLetter & "\path\to\file.zip" & " to C:\Users\Public\Temp\..."
objFSO.CopyFile strDriveLetter & "\path\to\file.zip", "C:\Users\Public\Temp\"

' Remove the mapped drive
WScript.Echo "Removing the mapped network drive " & strDriveLetter & "..."
objNetwork.RemoveNetworkDrive strDriveLetter

WScript.Echo "Operation completed."

Set objFSO = Nothing
Set objNetwork = Nothing
