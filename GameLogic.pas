unit GameLogic;

interface

uses
  System.SysUtils, System.Types, System.Classes, Vcl.ExtCtrls, Vcl.Graphics,
  Tetromino, Blocco;

const
  GridWidth = 10;
  GridHeight = 20;

  CellSize: Integer = 40;

type

TGrid = array[0..GridWidth - 1, 0..GridHeight - 1] of Integer;


TAreaGame = class(TComponent)
  private
    FGrid: TGrid;
    FBoxGame: TPaintBox;
    FBoxNextPiece: TPaintBox;
    FLines: Integer;
    FScore: LongInt;

    OffsetX: Integer;
    OffsetY: Integer;
  public
    property Grid: TGrid read FGrid;
    property BoxGame: TPaintBox read FBoxGame write FBoxGame;
    property BoxNextPiece: TPaintBox read FBoxNextPiece write FBoxNextPiece;
    property Lines: Integer read FLines write FLines;
    property Score: LongInt read FScore write FScore;

    procedure DrawGrid;
    procedure DrawCurrentPiece(const Tetromino: TTetromino);
    procedure DrawNextPiece(const Tetromino: TTetromino);
    procedure DrawBlock(Canvas: TCanvas; x, y: integer; col: TColor; border: boolean = false; offset: boolean = false);
    function CreateTetromino: TTetromino;
    procedure PlaceTetromino(const Tetromino: TTetromino);
    procedure MergeTetromino(const Tetromino: TTetromino);
    function CanMove(const Tetromino: TTetromino; dx, dy: Integer): Boolean;
    function ClearFullLines: integer;

    procedure ResetAreaGame;
end;

implementation

procedure TAreaGame.DrawGrid;
var
  x, y: Integer;

begin
  for x := 0 to 9 do
    for y := 0 to 19 do
    begin
      if (Grid[x, y]) = 1 then DrawBlock(FBoxGame.Canvas, x, y, clBlack, true)
                          else DrawBlock(FBoxGame.Canvas, x, y, clWhite);
    end;
end;

procedure TAreaGame.DrawCurrentPiece(const Tetromino: TTetromino);
var
  i, j: Integer;
begin

  if (not Assigned(Tetromino)) then Exit;

  for i := 0 to 3 do
    for j := 0 to 3 do
      if Tetromino.Shape[i, j] = 1 then
      begin
        DrawBlock(FBoxGame.Canvas,
                  Tetromino.X + i,
                  Tetromino.Y + j,
                  TetrominoColors[Tetromino.Color],
                  true)
      end;
end;

procedure TAreaGame.DrawNextPiece(const Tetromino: TTetromino);
var
  i, j: Integer;

begin
  if (not Assigned(Tetromino)) then Exit;

  OffsetX := (FBoxNextPiece.Width - (Tetromino.MaxX - Tetromino.MinX) * CellSize) div 2;
  OffsetY := (FBoxNextPiece.Height - (Tetromino.MaxY - Tetromino.MinY) * CellSize) div 2;

  for i := 0 to 3 do
    for j := 0 to 3 do
      if Tetromino.Shape[i, j] = 1 then
      begin
        DrawBlock(FBoxNextPiece.Canvas,
                  Tetromino.X + i - Tetromino.MinX,
                  Tetromino.Y + j - Tetromino.MinY,
                  TetrominoColors[Tetromino.Color],
                  true,
                  true);
      end;

end;

procedure TAreaGame.DrawBlock(Canvas: TCanvas;
    x, y: integer;
    col: TColor;
    border: boolean = false;
    offset: boolean = false);
var Xo, Xe, Yn, Ys: Integer;
begin
  Xo := x * CellSize;
  Xe := (x + 1) * CellSize;
  Yn := y * CellSize;
  Ys := (y + 1) * CellSize;

  if (offset) then
  begin
    Xo := Xo + OffsetX;
    Xe := Xe + OffsetX;
    Yn := Yn + OffsetY;
    Ys := Ys + OffsetY;
  end;

  Canvas.Brush.Color := col;

  Canvas.Pen.Color := col;
  Canvas.Rectangle(Xo, Yn, Xe, Ys);

  if Border then
  begin
    Canvas.Pen.Width := 2;

    Canvas.Pen.Color := clBlack;
    Canvas.MoveTo(Xe, Yn);
    Canvas.LineTo(Xo, Yn);
    Canvas.LineTo(Xo, Ys);
    Canvas.LineTo(Xe, Ys);
    Canvas.LineTo(Xe, Yn);

    Canvas.Pen.Color := clGray;

    Canvas.MoveTo(Xe - 2, Yn + 2);
    Canvas.LineTo(Xo + 2, Yn + 2);
    Canvas.LineTo(Xo + 2, Ys - 2);

    Canvas.MoveTo(Xe - 4, Yn + 4);
    Canvas.LineTo(Xo + 4, Yn + 4);
    Canvas.LineTo(Xo + 4, Ys - 4);

    Canvas.MoveTo(Xe - 6, Yn + 6);
    Canvas.LineTo(Xo + 6, Yn + 6);
    Canvas.LineTo(Xo + 6, Ys - 6);

    Canvas.Pen.Color := clLtGray;

    Canvas.MoveTo(Xo + 2, Ys - 2);
    Canvas.LineTo(Xe - 2, Ys - 2);
    Canvas.LineTo(Xe - 2, Yn + 2);

    Canvas.MoveTo(Xo + 4, Ys - 4);
    Canvas.LineTo(Xe - 4, Ys - 4);
    Canvas.LineTo(Xe - 4, Yn + 4);

    Canvas.MoveTo(Xo + 6, Ys - 6);
    Canvas.LineTo(Xe - 6, Ys - 6);
    Canvas.LineTo(Xe - 6, Yn + 6);

  end;
end;

function TAreaGame.CreateTetromino: TTetromino;
begin
  Result := TTetromino.CreateRandom;
end;

procedure TAreaGame.PlaceTetromino(const Tetromino: TTetromino);
var
  i, j: Integer;
begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      if Tetromino.Shape[i, j] = 1 then
        FGrid[Tetromino.X + i, Tetromino.Y + j] := 1;
end;

procedure TAreaGame.MergeTetromino(const Tetromino: TTetromino);
begin
  PlaceTetromino(Tetromino);
end;

function TAreaGame.CanMove(const Tetromino: TTetromino; dx, dy: Integer): Boolean;
var
  i, j, nx, ny: Integer;
begin
  for i := 0 to 3 do
    for j := 0 to 3 do
      if Tetromino.Shape[i, j] = 1 then
      begin
        nx := Tetromino.X + i + dx;
        ny := Tetromino.Y + j + dy;
        if (nx < 0) or (nx >= GridWidth) or (ny < 0) or (ny >= GridHeight) then
          Exit(False);
        if Grid[nx, ny] = 1 then
          Exit(False);
      end;

  Result := True;
end;

function TAreaGame.ClearFullLines: Integer;
var
  y, x, i: Integer;
  Full: Boolean;
begin
  Result := 0;
  y := GridHeight - 1;

  while (y > 0) do
  begin
    Full := True;
    for x := 0 to GridWidth - 1 do
      if Grid[x, y] = 0 then
      begin
        Full := False;
        Break;
      end;

    if Full then
    begin
      Inc(Result);

      for i := y downto 1 do
        for x := 0 to GridWidth - 1 do
          FGrid[x, i] := Grid[x, i - 1];
      for x := 0 to GridWidth - 1 do
        FGrid[x, 0] := 0;

      Inc(y); // ricontrolla la stessa riga dopo lo shift
    end;

    Dec(y);
  end;
end;

procedure TAreaGame.ResetAreaGame;
var x, y: Integer;
begin
  FLines := 0;
  FScore := 0;

  for x := 0 to 9 do
    for y := 0 to 19 do
    begin
      FGrid[x, y] := 0;

      DrawBlock(FBoxGame.Canvas, x, y, clWhite);
    end;
end;


end.

