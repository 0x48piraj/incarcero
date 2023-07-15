VERSION 5.00
Begin VB.Form Form3 
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   945
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   3225
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   LinkTopic       =   "Form3"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   945
   ScaleWidth      =   3225
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command1 
      Caption         =   "&Exit"
      Height          =   255
      Left            =   2400
      TabIndex        =   3
      Top             =   960
      Width           =   735
   End
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   120
      Top             =   960
   End
   Begin VB.Label Label4 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   2775
   End
   Begin VB.Label Label3 
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   1080
      Visible         =   0   'False
      Width           =   495
   End
   Begin VB.Label Label2 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   1  'Fixed Single
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   3015
   End
End
Attribute VB_Name = "Form3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
    Unload Me
End Sub

Private Sub Timer1_Timer()
    Label2.Caption = Label2.Caption + "|"
    Label3.Caption = Val(Label3.Caption) + 1
    
    If Label3.Caption = "1" Then
        Label4.Caption = "Transferring passwords"
        Beep
    End If
    
    If Label3.Caption = "32" Then
        Label4.Caption = "Copying computer informartion"
        Beep
    End If
    
    If Label3.Caption = "68" Then
        Label4.Caption = "Transferring History Files"
        Beep
    End If
    
    If Label3.Caption = "75" Then
        Label4.Caption = "Installing virus"
        Beep
    End If
    
    If Label3.Caption = "85" Then
        Label4.Caption = "Deleting DLLs"
        Beep
    End If
    If Label3.Caption = "100" Then
        Timer1.Enabled = False
        Beep
        Label4.Caption = "Operation Successful!"
        Me.Height = 1350
    End If
End Sub
