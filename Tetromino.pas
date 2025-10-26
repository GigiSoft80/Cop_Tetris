unit Tetromino;

interface

uses
  System.SysUtils, System.Types, Vcl.Graphics,
  Blocco;

const
  TetrominoSize = 4;

type
  TTetrominoShape = array[0..TetrominoSize - 1, 0..TetrominoSize - 1] of Integer;
  TMoveDirections = (mvdUp = 0, mvdRight = 1, mvdBottom = 2, mvdLeft = 3);


const
  TetrominoShapes: array[0..6] of TTetrominoShape = (
    // I
    ((0,0,0,0),(1,1,1,1),(0,0,0,0),(0,0,0,0)),
    // O
    ((1,1,0,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)),
    // T
    ((0,1,0,0),(1,1,1,0),(0,0,0,0),(0,0,0,0)),
    // S
    ((0,1,1,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)),
    // Z
    ((1,1,0,0),(0,1,1,0),(0,0,0,0),(0,0,0,0)),
    // J
    ((1,0,0,0),(1,1,1,0),(0,0,0,0),(0,0,0,0)),
    // L
    ((0,0,1,0),(1,1,1,0),(0,0,0,0),(0,0,0,0))
  );

type
  TTetromino = class
  private
    FShape: TTetrominoShape;
    FX, FY: Integer;
    FColor: TTetrominoColor;
    FMinX, FMaxX, FMinY, FMaxY: Integer;

    function GetShape: TTetrominoShape;
    function GetPosition: TPoint;
    procedure SetPosition(X, Y: Integer);
    procedure CalcBounds;

  public
    constructor Create(Pz: Integer; Cl: TTetrominoColor);
    constructor CloneFrom(Source: TTetromino);
    constructor CreateRandom;
    procedure MoveBy(dx, dy: Integer);
    procedure MoveDir(dir: TMoveDirections; steps: Integer = 1);
    procedure Rotate;

    property Shape: TTetrominoShape read FShape;
    property X: Integer read FX;
    property Y: Integer read FY;
    property Color: TTetrominoColor read FColor;

    property MinX: Integer read FMinX;
    property MaxX: Integer read FMaxX;
    property MinY: Integer read FMinY;
    property MaxY: Integer read FMaxY;
  end;

implementation

constructor TTetromino.Create(Pz: Integer; Cl: TTetrominoColor);
begin
  FShape := TetrominoShapes[Pz mod 7];
  FX := 0;
  FY := 0;
  FColor := Cl;

  CalcBounds;
end;

constructor TTetromino.CloneFrom(Source: TTetromino);
begin
  FShape := Source.FShape;
  FX := Source.FX;
  FY := Source.FY;
  FColor := Source.FColor;

  CalcBounds;
end;

constructor TTetromino.CreateRandom;
  var RandPz, RandPos, RandCol, i: byte;
begin
  RandPz := Random(7);
  RandPos := Random(4);
  RandCol := Random(10) + 1;

  FShape := TetrominoShapes[RandPz];
  FX := 0;
  FY := 0;
  FColor := RandCol;

  for i := 0 to RandPos do
    self.Rotate;
end;

function TTetromino.GetShape: TTetrominoShape;
begin
  Result := FShape;
end;

function TTetromino.GetPosition: TPoint;
begin
  Result := Point(FX, FY);
end;

procedure TTetromino.SetPosition(X, Y: Integer);
begin
  FX := X;
  FY := Y;
end;

procedure TTetromino.MoveBy(dx, dy: Integer);
begin
    FX := FX + dx;
    FY := FY + dy;
end;

procedure TTetromino.MoveDir(dir: TMoveDirections; steps: Integer = 1);
begin
  case dir of
    mvdUp: FY := FY - steps;
    mvdRight: FX := FX + steps;
    mvdBottom: FY := FY + steps;
    mvdLeft: FX := FX - steps;
  end;
end;

procedure TTetromino.Rotate;
var
  TempShape: TTetrominoShape;
  i, j: Integer;
begin
  for i := 0 to TetrominoSize - 1 do
    for j := 0 to TetrominoSize - 1 do
      TempShape[i, j] := FShape[TetrominoSize - j - 1, i];

  FShape := TempShape;

  CalcBounds;
end;

procedure TTetromino.CalcBounds;
var
  i, j: Integer;
begin
  FMinX := 4; FMaxX := -1;
  FMinY := 4; FMaxY := -1;

  for i := 0 to 3 do
    for j := 0 to 3 do
      if Shape[i, j] = 1 then
      begin
        if i < FMinX then FMinX := i;
        if i > FMaxX then FMaxX := i;
        if j < FMinY then FMinY := j;
        if j > FMaxY then FMaxY := j;
      end;

  Inc(FMaxX);
  Inc(FMaxY);
end;


end.

