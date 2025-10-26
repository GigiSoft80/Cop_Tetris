object FormTetris: TFormTetris
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Tetris Delphi'
  ClientHeight = 506
  ClientWidth = 662
  Color = clBlue
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    662
    506)
  TextHeight = 25
  object PaintBoxGame: TPaintBox
    Left = 10
    Top = 10
    Width = 200
    Height = 400
    Color = clWhite
    ParentColor = False
    OnPaint = PaintBoxGamePaint
  end
  object PaintBoxNext: TPaintBox
    Left = 226
    Top = 264
    Width = 428
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Color = clWhite
    ParentColor = False
    OnPaint = PaintBoxNextPaint
    ExplicitWidth = 397
  end
  object GrpGameState: TGroupBox
    Left = 226
    Top = 8
    Width = 428
    Height = 106
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    ExplicitWidth = 426
    DesignSize = (
      428
      106)
    object lblNumeroLinee: TLabel
      Left = 16
      Top = 59
      Width = 47
      Height = 25
      Caption = 'Lines:'
    end
    object lblPunteggio: TLabel
      Left = 16
      Top = 20
      Width = 51
      Height = 25
      Caption = 'Score:'
    end
    object PaintBox1: TPaintBox
      Left = 144
      Top = 0
      Width = 105
      Height = 105
    end
    object txtNumeroLinee: TEdit
      Left = 80
      Top = 56
      Width = 245
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 0
      Text = '0'
      ExplicitWidth = 243
    end
    object txtPunteggio: TEdit
      Left = 80
      Top = 17
      Width = 333
      Height = 33
      Anchors = [akLeft, akTop, akRight]
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 1
      Text = '0'
      ExplicitWidth = 331
    end
    object BtnStart: TButton
      Left = 343
      Top = 56
      Width = 71
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Start'
      TabOrder = 2
      OnClick = BtnStartClick
      ExplicitLeft = 341
    end
  end
  object tstGameMessages: TListBox
    Left = 226
    Top = 128
    Width = 428
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 25
    ScrollWidth = 1000
    TabOrder = 1
    ExplicitWidth = 426
  end
  object TimerFall: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerFallTimer
  end
end
