unit Sounds;

interface

uses System.SysUtils, System.Classes, Controls, Winapi.Windows, Vcl.MPlayer;

type
  TSoundManager = class(TComponent)
  private
    SoundTrackPlayer: TMediaPlayer;
    EffectPlayer: TMediaPlayer;

    DropLines: string;
    EndOfGame: string;
    SoundTrack: string;

    procedure PlayEffect(const FileName: string);

    procedure PlayerMusicNotify(Sender: TObject);
  public

    Constructor Create(AOwner: TComponent); override;

    procedure NotifyDropLine;
    procedure NotifyGameOver;

    procedure StartMusic;
    procedure StopMusic;
  end;

implementation

const
  FN_DropLines: string = 'DropLines.wav';
  FN_EndOfGame: string = 'EndOfGame.wav';

  FN_SoundTrack: string = 'Korobeiniki - Piano.mp3';

var MusicPath: string;

Constructor TSoundManager.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  SoundTrackPlayer := TMediaPlayer.Create(AOwner);
  if AOwner is TWinControl then
    SoundTrackPlayer.Parent := TWinControl(AOwner);

  EffectPlayer := TMediaPlayer.Create(AOwner);
  if AOwner is TWinControl then
    EffectPlayer.Parent := TWinControl(AOwner);

  SoundTrackPlayer.Visible := false;
  SoundTrackPlayer.Notify := True;
  SoundTrackPlayer.OnNotify := PlayerMusicNotify;

  EffectPlayer.Visible := false;
  EffectPlayer.Notify := False;

  MusicPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Sounds\';

  DropLines := MusicPath + FN_DropLines;
  EndOfGame := MusicPath + FN_EndOfGame;
  SoundTrack := MusicPath + FN_SoundTrack;

  SoundTrackPlayer.FileName := SoundTrack;
  SoundTrackPlayer.Open;
  SoundTrackPlayer.Stop;

end;

procedure TSoundManager.NotifyDropLine;
begin
  PlayEffect(DropLines);
end;

procedure TSoundManager.NotifyGameOver;
begin
  PlayEffect(EndOfGame);
end;

procedure TSoundManager.StartMusic;
begin
  if SoundTrackPlayer.Mode <> mpOpen then
    SoundTrackPlayer.Open;

  SoundTrackPlayer.Play;
end;

procedure TSoundManager.StopMusic;
begin
  SoundTrackPlayer.Stop;
end;

procedure TSoundManager.PlayEffect(const FileName: string);
begin
  EffectPlayer.FileName := FileName;

  if EffectPlayer.Mode <> mpOpen then
    EffectPlayer.Open;

  EffectPlayer.Play;
end;

procedure TSoundManager.PlayerMusicNotify(Sender: TObject);
begin
  if SoundTrackPlayer.Mode = mpPlaying then
    SoundTrackPlayer.Play;
end;

end.

