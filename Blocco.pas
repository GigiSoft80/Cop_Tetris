unit Blocco;

interface
  uses Vcl.Graphics;

const
  Opened: boolean = false;
  Closed: boolean = true;

  TetrominoColors: array[0..10] of TColor = (
    clWhite, clRed, clOlive, clLime, clMoneyGreen, clYellow,
    clBlue, clAqua, clMaroon, clLtGray, clGray);

type
  TTetrominoColor = 0..10;

  TBlocco = class
    private
      FN, FS, FO, FE: boolean;
      FColor: TTetrominoColor;

      procedure SetColor(value: TTetrominoColor);
    public
      property N: boolean read FN write FN;
      property S: boolean read FS write FS;
      property O: boolean read FO write FO;
      property E: boolean read FE write FE;
      property Color: TTetrominoColor read FColor write SetColor;
  end;

implementation

procedure TBlocco.SetColor(value: TTetrominoColor);
begin
  if (FColor = value) then exit;

  FColor := value;

  if (value = 0) then
  begin
    FN := Opened;
    FS := Opened;
    FO := Opened;
    FE := Opened;
  end;
end;

end.
