unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ComCtrls;

type
  TMain = class(TForm)
    VideoGB: TGroupBox;
    ResLbl: TLabel;
    AspectRatioLbl: TLabel;
    ApplyBtn: TButton;
    ExitBtn: TButton;
    AboutBtn: TButton;
    ResolutionsCB: TComboBox;
    AspectRatiosCB: TComboBox;
    XPManifest1: TXPManifest;
    ColorDepthLbl: TLabel;
    ColorDepthCB: TComboBox;
    BrightnessLbl: TLabel;
    TrackBar1: TTrackBar;
    BrightnessValLbl: TLabel;
    procedure AboutBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResolutionsCBChange(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  AspectRatiosList: TStringList;
  IDS_GAME_NOT_FOUND, IDS_DONE, IDS_ABOUT, IDS_LAST_UPDATE, IDS_SPECIAL_THANKS: string;

implementation

{$R *.dfm}

function GetLocaleInformation(flag: integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, flag, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure TMain.AboutBtnClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 1.0' + #13#10 +
  IDS_LAST_UPDATE + ' 10.07.24' + #13#10#13#10 +
  IDS_SPECIAL_THANKS + #13#10#13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  i: integer;
begin
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Resolutions.txt') then
    ResolutionsCB.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Resolutions.txt');

  AspectRatiosList:=TStringList.Create;
  if FileExists(ExtractFilePath(ParamStr(0)) + 'AspectRatios.txt') then
    AspectRatiosList.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'AspectRatios.txt');
  for i:=0 to AspectRatiosList.Count - 1 do
    AspectRatiosCB.Items.Add(Copy(AspectRatiosList.Strings[i], 1, Pos('=', AspectRatiosList.Strings[i]) - 1));
  if ResolutionsCB.Items.Count > 0 then
    ResolutionsCB.ItemIndex:=0;

  if AspectRatiosCB.Items.Count > 0 then
    AspectRatiosCB.ItemIndex:=0;

  IDS_GAME_NOT_FOUND:='The game "SpideyPC.exe" was not found.';
  IDS_DONE:='Done.' + #13#10#13#10 + 'For the game to work correctly on new Windows' + #13#10 + 'you will need the dgVoodoo2 library and a frame limit of up to 30.';
  IDS_ABOUT:='About...';
  IDS_LAST_UPDATE:='Last update:';
  IDS_SPECIAL_THANKS:='Many thanks to Hemanshu Shekhar' + #13#10 + 'for the addresses found.';
  if GetLocaleInformation(LOCALE_SENGLANGUAGE) = 'Russian' then begin
    Caption:='Человек-Паук настройки';
    IDS_GAME_NOT_FOUND:='Игра "SpideyPC.exe" не найдена.';

    VideoGB.Caption:='Видео';
    ResLbl.Caption:='Разрешение:';
    AspectRatioLbl.Caption:='Соотношение сторон:';
    ColorDepthLbl.Caption:='Глубина цвета:';
    BrightnessLbl.Caption:='Яркость:';

    ApplyBtn.Caption:='Применить';
    IDS_DONE:='Готово.' + #13#10#13#10 + 'Для корректной работы игры на новых Windows' + #13#10 + 'понадобится библиотека dgVoodoo2 и ограничение кадров до 30.';
    ExitBtn.Caption:='Выход';

    IDS_ABOUT:='О программе...';
    IDS_LAST_UPDATE:='Последнее обновление:';
    IDS_SPECIAL_THANKS:='Большое спасибо Hemanshu Shekhar' + #13#10 + 'за найденные адреса.';
  end;
  Application.Title:=Caption;
end;

procedure TMain.ResolutionsCBChange(Sender: TObject);
var
  AspectRatiosIndex: Integer;
  ResText, AspectRatiosText: string;
begin
  if ResolutionsCB.ItemIndex = -1 then Exit;

  ResText:=ResolutionsCB.Items[ResolutionsCB.ItemIndex];

  if (Pos(' ', ResText) = 0) or (Pos('(', ResText) = 0) then Exit;

  AspectRatiosText:=Copy(ResText, Pos('(', ResText) + 1, Pos(')', ResText) - Pos('(', ResText) - 1);

  AspectRatiosIndex:=AspectRatiosCB.Items.IndexOf(AspectRatiosText);

  if AspectRatiosIndex <> -1 then
    AspectRatiosCB.ItemIndex:=AspectRatiosIndex;
end;

procedure TMain.ApplyBtnClick(Sender: TObject);
var
  ResStr: string;

  AspectRatioByte, ColorDepthByte, BrightnessByte: Byte;
  FileStream: TFileStream;

  ResWidth, ResHeight: integer;

  HighByte, LowByte: Byte;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + 'SpideyPC.exe') then begin Application.MessageBox(PChar(IDS_GAME_NOT_FOUND), PChar(Caption), MB_ICONWARNING); Exit; end;

  if not FileExists(ExtractFilePath(ParamStr(0)) + 'Spidey.cfg') then
    CopyFile(PChar(ExtractFilePath(ParamStr(0)) + 'SpideyDefault.cfg'), PChar(ExtractFilePath(ParamStr(0)) + 'Spidey.cfg'), True);

  ResStr:=Trim(ResolutionsCB.Text);
  if Pos(' ', ResStr) > 0 then ResStr := Copy(ResStr, 1, Pos(' ', ResStr) - 1);
  ResWidth:=StrToInt(Copy(ResStr, 1, Pos('x', ResStr) - 1));
  ResHeight:=StrToInt(Copy(ResStr, Pos('x', ResStr) + 1, Length(ResStr) - Pos('x', ResStr)));
  AspectRatioByte:=StrToInt('$' + Copy(AspectRatiosList.Strings[AspectRatiosCB.ItemIndex], Pos('=', AspectRatiosList.Strings[AspectRatiosCB.ItemIndex]) + 1, Length(AspectRatiosList.Strings[AspectRatiosCB.ItemIndex])) );

  // Aspect Ratio
  FileStream:=TFileStream.Create('SpideyPC.exe', fmOpenReadWrite);
  try
    FileStream.Seek(StrToInt('$150066'), soBeginning);
    FileStream.WriteBuffer(AspectRatioByte, SizeOf(Byte));
  finally
    FileStream.Free;
  end;

  // Resolution
  FileStream:=TFileStream.Create('Spidey.cfg', fmOpenReadWrite);
  try
    // Width
    HighByte:=(ResWidth shr 8) and $FF;
    LowByte:=ResWidth and $FF;
    FileStream.Seek(0, soBeginning);
    FileStream.WriteBuffer(LowByte, SizeOf(Byte));

    FileStream.Seek(1, soBeginning);
    FileStream.WriteBuffer(HighByte, SizeOf(Byte));

    // Height
    HighByte:=(ResHeight shr 8) and $FF;
    LowByte:=ResHeight and $FF;
    FileStream.Seek(4, soBeginning);
    FileStream.WriteBuffer(LowByte, SizeOf(Byte));

    FileStream.Seek(5, soBeginning);
    FileStream.WriteBuffer(HighByte, SizeOf(Byte));

    FileStream.Seek(8, soBeginning);
    ColorDepthByte := StrToInt('$' + IntToHex(StrToInt(ColorDepthCB.Items.Strings[ColorDepthCB.ItemIndex]), 2));
    FileStream.WriteBuffer(ColorDepthByte, SizeOf(Byte));

    FileStream.Seek(StrToInt('$0C'), soBeginning);
    BrightnessByte:=StrToInt('$' + IntToHex(TrackBar1.Position, 2));
    FileStream.WriteBuffer(BrightnessByte, SizeOf(Byte));
  finally
    FileStream.Free;
  end;

  Application.MessageBox(PChar(IDS_DONE), PChar(Caption), MB_ICONINFORMATION);
  Close;
end;

procedure TMain.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.TrackBar1Change(Sender: TObject);
begin
  BrightnessValLbl.Caption:=IntToStr(TrackBar1.Position);
end;

end.
