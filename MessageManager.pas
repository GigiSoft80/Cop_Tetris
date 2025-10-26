unit MessageManager;

interface

uses
  Vcl.StdCtrls;

type
  TStringArray = array of string;

procedure AssignMsgBox(const Box: TListBox);
procedure ShowMessage(Msg: string; Clr: boolean = true); overload;
procedure ShowMessage(const ArrMsg: array of string; Clr: boolean = true); overload;

implementation

var
  MsgBox: TListBox;

procedure AssignMsgBox(const Box: TListBox);
begin
  MsgBox := Box;
end;

procedure ShowMessage(Msg: string; Clr: boolean = true);
begin
  if (Clr) then MsgBox.Items.Clear;

  MsgBox.items.Add(Msg);
end;

procedure ShowMessage(const ArrMsg: array of string; Clr: boolean = true);
begin
  if (Clr) then MsgBox.Items.Clear;

  MsgBox.items.AddStrings(ArrMsg);
end;

end.
