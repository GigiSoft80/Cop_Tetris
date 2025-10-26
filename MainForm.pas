unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, Vcl.StdCtrls,
  Tetromino, GameLogic, Blocco, MessageManager, Sounds, Vcl.MPlayer;

const
  MarginSize: Integer = 20;
  LeftArea: Integer = 400;

type
  TFormTetris = class(TForm)
    BtnStart: TButton;
    TimerFall: TTimer;
    PaintBoxGame: TPaintBox;
    PaintBoxNext: TPaintBox;
    GrpGameState: TGroupBox;
    lblNumeroLinee: TLabel;
    txtNumeroLinee: TEdit;
    lblPunteggio: TLabel;
    txtPunteggio: TEdit;
    tstGameMessages: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure PaintBoxGamePaint(Sender: TObject);
    procedure TimerFallTimer(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);

    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure PaintBoxNextPaint(Sender: TObject);
  private
    AreaGame: TAreaGame;
    CurrentPiece: TTetromino;
    NextPiece: TTetromino;
    SoundManager: TSoundManager;

    procedure SpawnNewPiece;
    procedure LockPiece;
    procedure MovePiece(dx, dy: Integer);
    procedure MovePieceDir(dir: TMoveDirections);
    procedure RotatePiece;

    procedure ManagePausa;

    procedure InitGame;
    procedure MakeFormDesign;
    procedure UpdateScore(Sc: integer);
    procedure UpdsteLines(Ln: integer);

  public
    { Public declarations }
  end;

var
  FormTetris: TFormTetris;

implementation

{$R *.dfm}

procedure TFormTetris.FormCreate(Sender: TObject);
begin

  AreaGame := TAreaGame.Create(self);
  AreaGame.BoxGame := self.PaintBoxGame;
  AreaGame.BoxNextPiece := self.PaintBoxNext;

  SoundManager := TSoundManager.Create(self);

  TimerFall.Interval := 500;
  TimerFall.Enabled := False;

  Self.DoubleBuffered := True;
  Self.KeyPreview := True;

  MakeFormDesign;

  Application.OnMessage := AppMessage;

  AssignMsgBox(tstGameMessages);

  InitGame;
end;

procedure TFormTetris.BtnStartClick(Sender: TObject);
begin
  InitGame;

  NextPiece := AreaGame.CreateTetromino;

  SpawnNewPiece;

  SoundManager.StartMusic;

  TimerFall.Enabled := True;
  BtnStart.Enabled := False;
end;

procedure TFormTetris.TimerFallTimer(Sender: TObject);
var
  Temp: TTetromino;
begin
  if not Assigned(CurrentPiece) then Exit;

  Temp := TTetromino.CloneFrom(CurrentPiece);
  Temp.MoveDir(mvdBottom);

  if AreaGame.CanMove(Temp, 0, 0) then
    CurrentPiece.MoveDir(mvdBottom)
  else
  begin
    LockPiece;
  end;

  Temp.Free;
  PaintBoxGame.Invalidate;
end;

procedure TFormTetris.PaintBoxGamePaint(Sender: TObject);
begin
  AreaGame.DrawGrid;
  AreaGame.DrawCurrentPiece(CurrentPiece);
end;

procedure TFormTetris.PaintBoxNextPaint(Sender: TObject);
begin
  PaintBoxNext.Canvas.Brush.Color := clLtGray;
  PaintBoxNext.Canvas.Rectangle(0, 0, PaintBoxNext.Width, PaintBoxNext.Height);

  AreaGame.DrawNextPiece(NextPiece);
end;

procedure TFormTetris.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if Msg.message = WM_KEYDOWN then
  begin
    case Msg.wParam of
      VK_LEFT: MovePieceDir(mvdLeft);
      VK_RIGHT: MovePieceDir(mvdRight);
      VK_DOWN: MovePieceDir(mvdBottom);
      VK_UP: RotatePiece;

      80: ManagePausa; // Tasto 'P'
    end;
    PaintBoxGame.Invalidate;
    Handled := True;
  end;
end;

procedure TFormTetris.MovePiece(dx, dy: Integer);
var
  Temp: TTetromino;
begin
  if (not Assigned(CurrentPiece)) then Exit;

  Temp := TTetromino.CloneFrom(CurrentPiece);
  Temp.MoveBy(dx, dy);

  if AreaGame.CanMove(Temp, 0, 0) then
    CurrentPiece.MoveBy(dx, dy);

  Temp.Free;
end;

procedure TFormTetris.MovePieceDir(dir: TMoveDirections);
var
  Temp: TTetromino;
begin
  if (not Assigned(CurrentPiece)) then Exit;

  Temp := TTetromino.CloneFrom(CurrentPiece);
  Temp.MoveDir(dir);

  if AreaGame.CanMove(Temp, 0, 0) then
    CurrentPiece.MoveDir(dir);

  Temp.Free;

end;

procedure TFormTetris.RotatePiece;
var
  Temp: TTetromino;
begin
  if (not Assigned(CurrentPiece)) then Exit;

  Temp := TTetromino.CloneFrom(CurrentPiece);
  Temp.Rotate;

  if AreaGame.CanMove(Temp, 0, 0) then
    CurrentPiece.Rotate;

  Temp.Free;
end;

procedure TFormTetris.LockPiece;
var
  LinesCleared: Integer;
begin
  AreaGame.MergeTetromino(CurrentPiece);
  LinesCleared := AreaGame.ClearFullLines;

  if LinesCleared > 0 then
  begin
    SoundManager.NotifyDropLine;

    UpdateScore(LinesCleared * 100);
    UpdsteLines(LinesCleared);
  end;

  UpdateScore(4);

  CurrentPiece.Free;
  SpawnNewPiece;

end;

procedure TFormTetris.SpawnNewPiece;
begin
  CurrentPiece := NextPiece;
  CurrentPiece.MoveDir(mvdRight, GridWidth div 2 - 2);

  NextPiece := AreaGame.CreateTetromino;
  PaintBoxNext.Invalidate;

  if not AreaGame.CanMove(CurrentPiece, 0, 0) then
  begin
    TimerFall.Enabled := False;

    SoundManager.StopMusic;
    SoundManager.NotifyGameOver;

    ShowMessage([
      'Game Over!',
      '',
      'Linee cancellate: ' + String(txtNumeroLinee.Text),
      'punteggio: ' + String(txtPunteggio.Text)
    ]);

    BtnStart.Enabled := True;
  end;
end;

procedure TFormTetris.ManagePausa;
begin
  TimerFall.Enabled := not TimerFall.Enabled;
end;

procedure TFormTetris.InitGame;
begin
  AreaGame.ResetAreaGame;

  if (Assigned(CurrentPiece)) then
    CurrentPiece.Free;

  if (Assigned(NextPiece)) then
    NextPiece.Free;

  UpdateScore(0);
  UpdsteLines(0);

  ShowMessage('');
end;

procedure TFormTetris.MakeFormDesign;
Const GrpH = 136;
      MsgH = 200;
begin
  Self.ClientHeight := (GridHeight * CellSize) + (2 * MarginSize);
  Self.ClientWidth := (GridWidth * CellSize) + (2 * MarginSize) + MarginSize + LeftArea;

  PaintBoxGame.Height := 20 * CellSize;
  PaintBoxGame.Width := 10 * CellSize;
  PaintBoxGame.Top := MarginSize;
  PaintBoxGame.Left := MarginSize;

  PaintBoxNext.Height := 6 * CellSize;
  PaintBoxNext.Width := 6 * CellSize;
  // PaintBoxNext.Top := (3 * MarginSize) + GrpH + MsgH;
  PaintBoxNext.Top := Self.ClientHeight - PaintBoxNext.Height - MarginSize;
  PaintBoxNext.Left := (GridWidth * CellSize) + (2 * MarginSize);

  GrpGameState.Top := MarginSize;
  GrpGameState.Left := (GridWidth * CellSize) + (2 * MarginSize);
  GrpGameState.Width := LeftArea;
  GrpGameState.Height := GrpH;

  tstGameMessages.Top := (2 * MarginSize) + GrpH;
  tstGameMessages.Left := (GridWidth * CellSize) + (2 * MarginSize);
  tstGameMessages.Width := LeftArea;
  tstGameMessages.Height := MsgH;

end;

procedure TFormTetris.UpdateScore(Sc: integer);
begin
  AreaGame.Score := AreaGame.Score + Sc;

  txtPunteggio.Text := IntToStr(AreaGame.Score);
end;

procedure TFormTetris.UpdsteLines(Ln: integer);
begin
  AreaGame.Lines := AreaGame.Lines + Ln;

  txtNumeroLinee.Text := IntToStr(AreaGame.Lines);
end;

end.

