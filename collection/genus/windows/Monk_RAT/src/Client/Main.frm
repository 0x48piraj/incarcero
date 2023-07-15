VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   BorderStyle     =   0  'None
   ClientHeight    =   6720
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6390
   BeginProperty Font 
      Name            =   "Verdana"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "Main.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6720
   ScaleWidth      =   6390
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   4800
      Top             =   3240
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.Frame frmExtras 
      BorderStyle     =   0  'None
      Height          =   2535
      Left            =   3240
      TabIndex        =   19
      Top             =   3960
      Width           =   3000
      Begin VB.Label Label2 
         Caption         =   "Crazy Mouse."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   120
         MouseIcon       =   "Main.frx":08CA
         MousePointer    =   99  'Custom
         TabIndex        =   25
         Top             =   1200
         Width           =   1215
      End
      Begin VB.Label Label25 
         Caption         =   "Cd tray."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   120
         MouseIcon       =   "Main.frx":1194
         MousePointer    =   99  'Custom
         TabIndex        =   24
         Top             =   840
         Width           =   735
      End
      Begin VB.Label Label23 
         Caption         =   "Beep the user."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   120
         MouseIcon       =   "Main.frx":1A5E
         MousePointer    =   99  'Custom
         TabIndex        =   21
         Top             =   480
         Width           =   1335
      End
      Begin VB.Label Label22 
         BackColor       =   &H00000000&
         Caption         =   "Extras"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   0
         TabIndex        =   20
         Top             =   0
         Width           =   3015
      End
   End
   Begin VB.Frame frmCool 
      BorderStyle     =   0  'None
      Height          =   2535
      Left            =   120
      TabIndex        =   13
      Top             =   3960
      Width           =   3000
      Begin VB.Label Label20 
         Caption         =   "Pretend you are deleting his hard drive."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   495
         Left            =   120
         MouseIcon       =   "Main.frx":2328
         MousePointer    =   99  'Custom
         TabIndex        =   18
         Top             =   1560
         Width           =   2535
      End
      Begin VB.Label Label19 
         Caption         =   "Swap mouse buttons."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   120
         MouseIcon       =   "Main.frx":2BF2
         MousePointer    =   99  'Custom
         TabIndex        =   17
         Top             =   1200
         Width           =   1935
      End
      Begin VB.Label Label18 
         Caption         =   "Make the screen turn to black."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   120
         MouseIcon       =   "Main.frx":34BC
         MousePointer    =   99  'Custom
         TabIndex        =   16
         Top             =   840
         Width           =   2655
      End
      Begin VB.Label Label17 
         Caption         =   "Ask if he/she is gay."
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00C00000&
         Height          =   255
         Left            =   120
         MouseIcon       =   "Main.frx":3D86
         MousePointer    =   99  'Custom
         TabIndex        =   15
         Top             =   480
         Width           =   1815
      End
      Begin VB.Label Label16 
         BackColor       =   &H00000000&
         Caption         =   "Cool Things"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FFFFFF&
         Height          =   255
         Left            =   0
         TabIndex        =   14
         Top             =   0
         Width           =   3015
      End
   End
   Begin VB.TextBox txtPort 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   2640
      TabIndex        =   10
      Tag             =   "2"
      Text            =   "1254"
      Top             =   360
      Width           =   735
   End
   Begin VB.TextBox txtIP 
      Appearance      =   0  'Flat
      Height          =   285
      Left            =   480
      TabIndex        =   8
      Tag             =   "1"
      Text            =   "127.0.0.1"
      Top             =   360
      Width           =   1575
   End
   Begin VB.Frame frmStart 
      BorderStyle     =   0  'None
      Height          =   2535
      Left            =   1680
      TabIndex        =   3
      Top             =   840
      Width           =   3000
      Begin VB.PictureBox Picture1 
         Appearance      =   0  'Flat
         BackColor       =   &H80000005&
         ForeColor       =   &H80000008&
         Height          =   1170
         Left            =   120
         Picture         =   "Main.frx":4650
         ScaleHeight     =   1140
         ScaleWidth      =   1530
         TabIndex        =   4
         Top             =   360
         Width           =   1560
      End
      Begin VB.Label Label6 
         Caption         =   "friends. The creator of this program is not responsible for any problems this may cause."
         Height          =   615
         Left            =   120
         TabIndex        =   23
         Top             =   1560
         Width           =   2775
      End
      Begin VB.Label Label5 
         Caption         =   "Monk is a simple program that lets you play pranks on your "
         Height          =   1215
         Left            =   1800
         TabIndex        =   22
         Top             =   360
         Width           =   1095
      End
      Begin VB.Label Label4 
         Caption         =   "Monk Version 1.0.0"
         BeginProperty Font 
            Name            =   "Verdana"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   120
         TabIndex        =   6
         Top             =   0
         Width           =   2775
      End
      Begin VB.Label Label7 
         Caption         =   "[Made by Chimps]"
         ForeColor       =   &H00800000&
         Height          =   255
         Left            =   1320
         TabIndex        =   5
         Top             =   2280
         Width           =   1575
      End
   End
   Begin VB.ListBox List1 
      Appearance      =   0  'Flat
      BackColor       =   &H00E0E0E0&
      Height          =   2565
      Left            =   120
      MouseIcon       =   "Main.frx":A202
      MousePointer    =   99  'Custom
      TabIndex        =   2
      Top             =   840
      Width           =   1455
   End
   Begin VB.Label lblStatus 
      BackStyle       =   0  'Transparent
      Caption         =   "Not connected."
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   3480
      Width           =   3495
   End
   Begin VB.Line Line1 
      X1              =   0
      X2              =   4680
      Y1              =   720
      Y2              =   720
   End
   Begin VB.Label Label10 
      Alignment       =   2  'Center
      Appearance      =   0  'Flat
      BackColor       =   &H00404040&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Connect"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   3480
      MouseIcon       =   "Main.frx":AACC
      MousePointer    =   99  'Custom
      TabIndex        =   11
      Tag             =   "3"
      Top             =   360
      Width           =   1095
   End
   Begin VB.Label Label9 
      Caption         =   "Port:"
      Height          =   255
      Left            =   2160
      TabIndex        =   9
      Top             =   360
      Width           =   495
   End
   Begin VB.Label Label8 
      Caption         =   "Ip:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   360
      Width           =   375
   End
   Begin VB.Shape Shape3 
      BackColor       =   &H00404040&
      BackStyle       =   1  'Opaque
      Height          =   240
      Left            =   0
      Top             =   3480
      Width           =   4695
   End
   Begin VB.Label Label3 
      BackColor       =   &H00404040&
      Caption         =   "x"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   195
      Left            =   4500
      MouseIcon       =   "Main.frx":B396
      MousePointer    =   99  'Custom
      TabIndex        =   1
      Top             =   45
      Width           =   135
   End
   Begin VB.Shape Shape1 
      Height          =   3255
      Left            =   0
      Top             =   240
      Width           =   4695
   End
   Begin VB.Label Label1 
      BackColor       =   &H00000000&
      Caption         =   " Monk 1.0"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   4695
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim X As Long
Dim Y As Long
Private Sub Form_Load()
    'Asign values to the variables
    X = 1680 'left
    Y = 840  'top
    
    'Display frames
    frmStart.Visible = True
    frmCool.Visible = False
    frmExtras.Visible = False
    
    'Align frames
    frmCool.Top = Y
    frmCool.Left = X
    
    frmExtras.Top = Y
    frmExtras.Left = X
    
    'Resize Form
    Form1.Width = 4695
    Form1.Height = 3705
    
    'Add items to the list
    List1.AddItem "Cool things"
    List1.AddItem "Extras"
    List1.AddItem "--------------"
    List1.AddItem "About"
    List1.AddItem "Exit"
End Sub

Private Sub Label1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    'Call the FormDrag Function
    FormDrag Me
End Sub

Private Sub Label10_Click()
On Error GoTo Trouble
    'Connect to server
    Winsock1.RemoteHost = txtIP.Text
    Winsock1.RemotePort = txtPort.Text
    Winsock1.Connect
    
Trouble:
    lblStatus.Caption = "Cannot connect to server.  Try again later."
End Sub

Private Sub Label17_Click()
On Error Resume Next
    Winsock1.SendData "ASKGAY"
End Sub

Private Sub Label18_Click()
    Form2.Show
End Sub

Private Sub Label19_Click()
    Form4.Show
End Sub

Private Sub Label2_Click()
    Form5.Show
End Sub

Private Sub Label20_Click()
    Winsock1.SendData "DELEHARD"
End Sub

Private Sub Label23_Click()
    Winsock1.SendData "BEEP"
End Sub

Private Sub Label25_Click()
    Form3.Show
End Sub

Private Sub Label3_Click()
    'Ask if the user wants to leave
    If MsgBox("Are you sure you want to exit?", vbYesNo) = vbYes Then
        Winsock1.Close
        End
    Else
        Exit Sub
    End If
End Sub

Private Sub List1_Click()
    If List1.Text = "Cool things" Then
        frmCool.Visible = True
        frmStart.Visible = False
        frmExtras.Visible = False
    End If
    
    If List1.Text = "Extras" Then
        frmExtras.Visible = True
        frmCool.Visible = False
        frmStart.Visible = False
    End If
    
    If List1.Text = "About" Then
        frmStart.Visible = True
        frmCool.Visible = False
        frmExtras.Visible = False
    End If
    
    If List1.Text = "Exit" Then
        Label3_Click
    End If
End Sub

Private Sub Winsock1_Connect()
    'Connected
    lblStatus.Caption = "Connected to server.  All yours :)"
End Sub
Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
    'Receive the data and store it in a variable
    Dim INFO As String
    Winsock1.GetData INFO
    
    If INFO = "YES" Then
        MsgBox ("The other computer chose YES")
    Else
        MsgBox ("The other computer chose NO")
    End If
End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    lblStatus.Caption = "You are not connected."
End Sub
