program Cop_Tetris;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {FormTetris},
  GameLogic in 'GameLogic.pas',
  Tetromino in 'Tetromino.pas',
  Blocco in 'Blocco.pas',
  MessageManager in 'MessageManager.pas',
  Sounds in 'Sounds.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormTetris, FormTetris);
  Application.Run;
end.
