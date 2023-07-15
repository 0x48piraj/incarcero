Attribute VB_Name = "Module1"
'Used to open and close CD tray
Public Declare Function mciSendString Lib "winmm.dll" _
Alias "mciSendStringA" (ByVal lpstrCommand As String, _
ByVal lpstrReturnString As String, _
ByVal uReturnLength As Long, _
ByVal hwndCallback As Long) As Long

'Swap mouse buttons
Public Declare Function SwapMouseButton Lib "user32" _
(ByVal bSwap As Long) As Long

'Set the position of the cursor
Declare Function SetCursorPos Lib "user32" _
(ByVal x As Long, ByVal y As Long) As Long

