unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TByteArray = array of Byte;

type
  TSavesForm = class(TForm)
    LevelsLV: TListView;
    CompleteGmeBtn: TButton;
    ExitBtn: TButton;
    CurrentCostumeLbl: TLabel;
    CurCostumeCB: TComboBox;
    UnlockedCostumesGB: TGroupBox;
    CostumeSpiderManCB: TCheckBox;
    CostumeSpiderMan2099CB: TCheckBox;
    CostumeSymbioteSpiderManCB: TCheckBox;
    CostumeCaptainUniverseCB: TCheckBox;
    CostumeSpideyUnlimitedCB: TCheckBox;
    CostumeAmazingBagManCB: TCheckBox;
    CostumeScarletSpideyCB: TCheckBox;
    CostumeBenReillyCB: TCheckBox;
    CostumeQuickChangeSpideyCB: TCheckBox;
    CostumePeterParkerCB: TCheckBox;
    procedure LevelsLVDblClick(Sender: TObject);
    procedure CurCostumeCBChange(Sender: TObject);
    procedure CompleteGmeBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CostumeSpiderManCBClick(Sender: TObject);
    procedure CostumeSpiderMan2099CBClick(Sender: TObject);
    procedure CostumeSymbioteSpiderManCBClick(Sender: TObject);
    procedure CostumeCaptainUniverseCBClick(Sender: TObject);
    procedure CostumeSpideyUnlimitedCBClick(Sender: TObject);
    procedure CostumeAmazingBagManCBClick(Sender: TObject);
    procedure CostumeScarletSpideyCBClick(Sender: TObject);
    procedure CostumeBenReillyCBClick(Sender: TObject);
    procedure CostumeQuickChangeSpideyCBClick(Sender: TObject);
    procedure CostumePeterParkerCBClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
  private
    FData: TByteArray;
    FBusy: Boolean;
    procedure FillListView;
    procedure FillCostumeList;
    procedure LoadFile;
    procedure SaveFile;
    procedure UpdateChecksum;
    function  ParseLevel: Integer;
    procedure SetCurrentLevel(Idx: Integer);
    function  ReadMask: Cardinal;
    procedure WriteMask(Mask: Cardinal);
    procedure RefreshUI;
    procedure UnlockCostume;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  CHECKSUM_OFF     = $204;
  LEVELSTR_OFF     = $208;
  PLAYAGAIN_OFF    = $259;
  LEVELS_OFF       = $25A;
  CURCOSTUME_OFF   = $280;
  UNLOCKEDCOST_OFF = $284;
  TOTAL_LEVELS     = 34;

  AREA_SIZES: array[0..7] of Integer = (4,2,5,1,7,4,5,6);

  LEVELS_EN: array[0..33] of string = (
    'Get to the Bank!', 'Bank Approach', 'Hostage Situation', 'Stop the Bomb!',
    'Race to the Buggle', 'Spidey vs. Scorpion!',
    'Police Chopper Chase', 'Missile Attack', 'Building Top Chase',
    'Scale the Girders', 'Police Evaded',
    'Spidey vs. Rhino!',
    'Catch Venom', 'Spidey vs. Venom!', 'Sewer Entrance', 'Sewer Cavern',
    'Subway', 'Sewage Plant', 'Hidden Switches',
    'Tunnel Crawl', 'Venom''s Puzzle', 'The Lizard''s Maze',
    'Spidey vs. Venom Again!',
    'Symbiotes Infest Bugle', 'Elevator Descent', 'Stop the Presses!',
    'Buggle''s Basement', 'Spidey vs. Mysterio!',
    'Waterfront Warehouse', 'Underwater Trench', 'Stopping the Fog',
    'Spidey vs. Doc Ock!', 'Spidey vs. Carnage!', 'Spidey vs. Monster-Ock!'
  );

  LEVELS_RU: array[0..33] of string = (
    'Добраться до банка!', 'Подход к банку', 'Заложники', 'Остановить бомбу!',
    'Гонка к редакции Bugle', 'Спайди против Скорпиона!',
    'Погоня с полицейским вертолётом', 'Ракетная атака', 'Погоня по крышам',
    'Взобраться по балкам', 'Скрыться от полиции',
    'Спайди против Носорога!',
    'Поймать Венома', 'Спайди против Венома!', 'Вход в канализацию',
    'Пещера в канализации', 'Метро', 'Очистные сооружения',
    'Скрытые переключатели',
    'Ползком по туннелю', 'Загадка Венома', 'Лабиринт Ящера',
    'Спайди снова против Венома!',
    'Симбиоты в редакции Bugle', 'Спуск на лифте', 'Остановить печатный станок!',
    'Подвал редакции Bugle', 'Спайди против Мистерио!',
    'Склад на набережной', 'Подводный комплекс', 'Остановить туман',
    'Спайди против Доктора Осьминога!', 'Спайди против Карнажа!',
    'Спайди против Монстра-Ока!'
  );

  HUD_EN: array[0..33] of string = (
    '', '', '', 'Timer Text',
    'Scorpion Run Bar', 'Scorpion Boss HP & Jameson HP',
    '', '', '', '', '',
    'Rhino Boss HP',
    'Venom Run Bar', 'Venom Boss HP', '', '', 'Subway Bar', '', '',
    '', '', '', 'Venom Boss HP & Mary Jane Bottom Bar',
    '', '', '', '', 'Mysterio Boss HP',
    '', '', '',
    'Doctor Octopus Boss HP', 'Carnage Boss HP',
    'Doctor Octopus Run Bar & Radiation Bar'
  );

  HUD_RU: array[0..33] of string = (
    '', '', '', 'Таймер',
    'Полоса погони Скорпиона', 'Здоровье Скорпиона и Джеймсона',
    '', '', '', '', '',
    'Здоровье Носорога',
    'Полоса погони Венома', 'Здоровье Венома', '', '', 'Полоса метро', '', '',
    '', '', '', 'Здоровье Венома и полоса Мэри Джейн',
    '', '', '', '', 'Здоровье Мистерио',
    '', '', '',
    'Здоровье Доктора Ока', 'Здоровье Карнажа',
    'Полоса погони Доктора Ока и радиации'
  );

  COSTUMES_EN: array[0..9] of string = (
    'Spider-Man', 'Spider-Man 2099', 'Symbiote Spider-Man',
    'Captain Universe', 'Spidey Unlimited', 'Amazing Bag Man',
    'Scarlet Spidey', 'Ben Reilly', 'Quick Change Spidey', 'Peter Parker'
  );

  COSTUMES_RU: array[0..9] of string = (
    'Человек-паук', 'Человек-паук 2099', 'Человек-паук-симбиот',
    'Капитан Вселенная', 'Спайди без границ', 'Удивительный Человек-сумка',
    'Алый Паук', 'Бен Рейли', 'Спайди-перевёртыш', 'Питер Паркер'
  );

var
  SavesForm: TSavesForm;

implementation

uses Unit1;

{$R *.dfm}

function L(const Eng, Rus: string): string;
begin
  if CurrentLang = 'Russian' then
    Result:=Rus else
  Result:=Eng;
end;

procedure TSavesForm.FillCostumeList;
var
  i: Integer;
begin
  CurCostumeCB.Items.Clear;
  for i:=0 to High(COSTUMES_EN) do
    CurCostumeCB.Items.Add(L(COSTUMES_EN[i], COSTUMES_RU[i]));

  if CurrentLang ='Russian' then begin
    CostumeSpiderManCB.Caption:=COSTUMES_RU[0];
    CostumeSpiderMan2099CB.Caption:=COSTUMES_RU[1];
    CostumeSymbioteSpiderManCB.Caption:=COSTUMES_RU[2];
    CostumeCaptainUniverseCB.Caption:=COSTUMES_RU[3];
    CostumeSpideyUnlimitedCB.Caption:=COSTUMES_RU[4];
    CostumeAmazingBagManCB.Caption:=COSTUMES_RU[5];
    CostumeScarletSpideyCB.Caption:=COSTUMES_RU[6];
    CostumeBenReillyCB.Caption:=COSTUMES_RU[7];
    CostumeQuickChangeSpideyCB.Caption:=COSTUMES_RU[8];
    CostumePeterParkerCB.Caption:=COSTUMES_RU[9];
  end;
end;

procedure TSavesForm.FillListView;
var
  i, area, lev, acc: Integer;
  item: TListItem;
begin
  LevelsLV.Items.BeginUpdate;
  try
    LevelsLV.Items.Clear;
    for i:=0 to High(LEVELS_EN) do
    begin
      // определяем area/lev для подписи "N-M"
      acc:=0;
      area:=0;
      for lev:=0 to High(AREA_SIZES) do begin
        if i < acc + AREA_SIZES[lev] then begin
          area := lev;
          Break;
        end;
        Inc(acc, AREA_SIZES[lev]);
      end;

      item:=LevelsLV.Items.Add;
      item.Caption:=Format('%d-%d', [area + 1, i - acc + 1]);
      item.SubItems.Add(L(LEVELS_EN[i], LEVELS_RU[i]));
      if DebugMode then
        item.SubItems.Add(L(HUD_EN[i], HUD_RU[i]));
    end;
  finally
    LevelsLV.Items.EndUpdate;
  end;
end;

procedure TSavesForm.LoadFile;
var
  fs: TFileStream;
begin
  fs:=TFileStream.Create(SavePath, fmOpenRead or fmShareDenyNone);
  try
    SetLength(FData, fs.Size);
    if fs.Size > 0 then
      fs.ReadBuffer(FData[0], fs.Size);
  finally
    fs.Free;
  end;
end;

function TSavesForm.ParseLevel: Integer;
var
  s: string;
  p, area, lev, i, acc: Integer;
begin
  Result := -1;
  if Length(FData) < LEVELSTR_OFF + 7 then Exit;

  SetLength(s, 7);
  Move(FData[LEVELSTR_OFF], s[1], 7);
  p:=Pos(#0, s);
  if p > 0 then SetLength(s, p - 1);

  if (Length(s) < 5) or (s[1] <> 'l') or (s[3] <> 'a') then Exit;
  if (s[2] < '1') or (s[2] > '9') then Exit;
  if (s[4] < '1') or (s[4] > '9') then Exit;

  area:=Ord(s[2]) - Ord('1');
  lev:=Ord(s[4]) - Ord('1');
  if (area < 0) or (area > High(AREA_SIZES)) then Exit;
  if (lev  < 0) or (lev  >= AREA_SIZES[area]) then Exit;

  acc:=0;
  for i:=0 to area - 1 do Inc(acc, AREA_SIZES[i]);
  Result:=acc + lev;
end;

function TSavesForm.ReadMask: Cardinal;
begin
  Result:=PCardinal(@FData[UNLOCKEDCOST_OFF])^;
end;

procedure TSavesForm.RefreshUI;
var
  idx: Integer;
  cc, m: Cardinal;
begin
  FBusy:=True;
  try
    idx:=ParseLevel;
    if (idx >= 0) and (idx < LevelsLV.Items.Count) then
    begin
      LevelsLV.Selected:=LevelsLV.Items[idx];
      LevelsLV.Selected.Focused:=True;
      LevelsLV.Selected.MakeVisible(False);
    end else
      LevelsLV.Selected:=nil;

    cc:=PCardinal(@FData[CURCOSTUME_OFF])^;
    if cc <= Cardinal(High(COSTUMES_EN)) then
      CurCostumeCB.ItemIndex:=Integer(cc)
    else
      CurCostumeCB.ItemIndex:=-1;

    m:=ReadMask;
    CostumeSpiderManCB.Checked:=(m and 1) <> 0;
    CostumeSpiderMan2099CB.Checked :=(m and 2) <> 0;
    CostumeSymbioteSpiderManCB.Checked:=(m and 4) <> 0;
    CostumeCaptainUniverseCB.Checked:=(m and 8) <> 0;
    CostumeSpideyUnlimitedCB.Checked:=(m and 16) <> 0;
    CostumeAmazingBagManCB.Checked:=(m and 32) <> 0;
    CostumeScarletSpideyCB.Checked:=(m and 64) <> 0;
    CostumeBenReillyCB.Checked:=(m and 128) <> 0;
    CostumeQuickChangeSpideyCB.Checked:=(m and 256) <> 0;
    CostumePeterParkerCB.Checked:=(m and 512) <> 0;
  finally
    FBusy:=False;
  end;
end;

procedure TSavesForm.SaveFile;
var
  fs: TFileStream;
begin
  UpdateChecksum;
  fs:=TFileStream.Create(SavePath, fmCreate);
  try
    if Length(FData) > 0 then
      fs.WriteBuffer(FData[0], Length(FData));
  finally
    fs.Free;
  end;
end;

procedure TSavesForm.SetCurrentLevel(Idx: Integer);
var
  i, area, lev, acc: Integer;
  s: string;
begin
  if (Idx < 0) or (Idx > High(LEVELS_EN)) then Exit;

  acc:=0;
  area:=0;
  for lev:=0 to High(AREA_SIZES) do
  begin
    if Idx < acc + AREA_SIZES[lev] then
    begin
      area:=lev;
      Break;
    end;
    Inc(acc, AREA_SIZES[lev]);
  end;
  lev:=Idx - acc;

  s:=Format('l%da%d_t', [area + 1, lev + 1]);
  while Length(s) < 7 do s := s + #0;
  Move(s[1], FData[LEVELSTR_OFF], 7);

  for i:=0 to TOTAL_LEVELS - 1 do
    if i < Idx then FData[LEVELS_OFF + i] := 1
    else             FData[LEVELS_OFF + i] := 0;

  FData[PLAYAGAIN_OFF]:=0;
  SaveFile;
  RefreshUI;
end;

procedure TSavesForm.UpdateChecksum;
var
  crc, w: Cardinal;
  i: Integer;
begin
  crc:=0;
  for i:=0 to $2E - 1 do begin
    if (crc and $80000000) <> 0 then
      crc:=(crc shl 1) or 1
    else
      crc:=crc shl 1;
    Move(FData[LEVELSTR_OFF + i * 4], w, 4);
    crc:=crc + w;
  end;
  crc:=crc or 1;
  Move(crc, FData[CHECKSUM_OFF], 4);
end;

procedure TSavesForm.WriteMask(Mask: Cardinal);
begin
  if Length(FData) < UNLOCKEDCOST_OFF + SizeOf(Cardinal) then
    Exit;

  PCardinal(@FData[UNLOCKEDCOST_OFF])^:=Mask;
  SaveFile;
  RefreshUI;
end;

procedure TSavesForm.LevelsLVDblClick(Sender: TObject);
begin
  if FBusy or (LevelsLV.Selected = nil) then Exit;
  SetCurrentLevel(LevelsLV.Selected.Index);
  Application.MessageBox(PChar(IDS_DONE), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TSavesForm.CurCostumeCBChange(Sender: TObject);
begin
  if FBusy or (CurCostumeCB.ItemIndex < 0) then Exit;
  PCardinal(@FData[CURCOSTUME_OFF])^:=Cardinal(CurCostumeCB.ItemIndex);
  SaveFile;
end;

procedure TSavesForm.CompleteGmeBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to TOTAL_LEVELS - 1 do
    FData[LEVELS_OFF + i]:=1;
  FData[PLAYAGAIN_OFF]:=1;
  SaveFile;
  RefreshUI;
  Application.MessageBox(PChar(IDS_DONE), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TSavesForm.FormShow(Sender: TObject);
begin
  if LoadSavesOnce then Exit;
  FillCostumeList;
  FillListView;
  LoadFile;
  RefreshUI;
  LoadSavesOnce:=true;
end;

procedure TSavesForm.FormDestroy(Sender: TObject);
begin
  LoadSavesOnce:=false;
  FData:=nil;
end;

procedure TSavesForm.FormCreate(Sender: TObject);
begin
  if DebugMode then begin
    with LevelsLV.Columns.Add do begin
      Caption:='HUD';
      Width:=180;
    end;
    LevelsLV.Columns[1].Width:=200;
    LevelsLV.Columns[2].Width:=180;
  end;
  if CurrentLang ='Russian' then begin
    Caption:=Main.SaveBtn.Caption;
    ExitBtn.Caption:=Main.ExitBtn.Caption;
    CompleteGmeBtn.Caption:='Пройти игру';
    LevelsLV.Columns[0].Caption:='Этап';
    LevelsLV.Columns[1].Caption:='Уровень';
    if DebugMode then
      LevelsLV.Columns[2].Caption:='Интерфейс';
    CurrentCostumeLbl.Caption:='Текущий костюм:';
    UnlockedCostumesGB.Caption:='Разблокированные костюмы:';
  end;
end;

procedure TSavesForm.UnlockCostume;
var
  m: Cardinal;
begin
  if FBusy then Exit;
  m:=0;
  if CostumeSpiderManCB.Checked then m:=m or 1;
  if CostumeSpiderMan2099CB.Checked then m:=m or 2;
  if CostumeSymbioteSpiderManCB.Checked then m:=m or 4;
  if CostumeCaptainUniverseCB.Checked then m:=m or 8;
  if CostumeSpideyUnlimitedCB.Checked then m:=m or 16;
  if CostumeAmazingBagManCB.Checked then m:=m or 32;
  if CostumeScarletSpideyCB.Checked then m:=m or 64;
  if CostumeBenReillyCB.Checked then m:=m or 128;
  if CostumeQuickChangeSpideyCB.Checked then m:=m or 256;
  if CostumePeterParkerCB.Checked then m:=m or 512;
  WriteMask(m);
end;

procedure TSavesForm.CostumeSpiderManCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeSpiderMan2099CBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeSymbioteSpiderManCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeCaptainUniverseCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeSpideyUnlimitedCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeAmazingBagManCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeScarletSpideyCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeBenReillyCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumeQuickChangeSpideyCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.CostumePeterParkerCBClick(Sender: TObject);
begin
  UnlockCostume;
end;

procedure TSavesForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

end.
