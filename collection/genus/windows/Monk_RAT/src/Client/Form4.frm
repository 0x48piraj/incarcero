VERSION 5.00
Begin VB.Form Form4 
   BorderStyle     =   0  'None
   ClientHeight    =   2175
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
   LinkTopic       =   "Form4"
   ScaleHeight     =   2175
   ScaleWidth      =   3255
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "Mouse is now normal."
      ForeColor       =   &H00FFFFFF&
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   1920
      Width           =   3015
   End
   Begin VB.Label Label5 
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
      Left            =   1680
      MouseIcon       =   "Form4.frx":0000
      MousePointer    =   99  'Custom
      TabIndex        =   4
      Top             =   1440
      Width           =   1455
   End
   Begin VB.Label Label4 
      Alignment       =   2  'Center
      BackColor       =   &H00000000&
      Caption         =   "&Reversed"
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
      Left            =   120
      MouseIcon       =   "Form4.frx":08CA
      MousePointer    =   99  'Custom
      TabIndex        =   3
      Top             =   1440
      Width           =   1455
   End
   Begin VB.Label Label2 
      Caption         =   "This option lets you swap mouse buttons (Right click where you normally use the left button and vice versa."
      Height          =   855
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
      MouseIcon       =   "Form4.frx":1194
      MousePointer    =   99  'Custom
      TabIndex        =   0
      Top             =   0
      Width           =   255
   End
   Begin VB.Label Label1 
      BackColor       =   &H00000000&
      Caption         =   " Mouse Buttons"
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
      Height          =   1935
      Left            =   0
      Top             =   240
      Width           =   3255
   End
   Begin VB.Shape Shape3 
      BackColor       =   &H00404040&
      BackStyle       =   1  'Opaque
      Height          =   240
      Left            =   0
      Top             =   1920
      Width           =   3255
   End
End
Attribute VB_Name = "Form4"
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

Private Sub Label4_Click()
    Form1.Winsock1.SendData "OTHER"
    Label6.Caption = "Mouse is now reversed."
End Sub

Private Sub Label5_Click()
    Form1.Winsock1.SendData "NORMAL"
    Label6.Caption = "Mouse is now normal."
End Sub
