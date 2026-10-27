unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ComCtrls, ExtCtrls, IniFiles;

type
  TMain = class(TForm)
    VideoGB: TGroupBox;
    ResLbl: TLabel;
    AspectRatioLbl: TLabel;
    ResolutionsCB: TComboBox;
    AspectRatiosCB: TComboBox;
    XPManifest1: TXPManifest;
    ColorDepthLbl: TLabel;
    ColorDepthCB: TComboBox;
    BrightnessLbl: TLabel;
    BrightnessTB: TTrackBar;
    BrightnessValLbl: TLabel;
    CompatibilityGB: TGroupBox;
    DXWrapperCB: TCheckBox;
    WindowedModeCB: TCheckBox;
    PanelButtons: TPanel;
    ApplyBtn: TButton;
    ExitBtn: TButton;
    AboutBtn: TButton;
    GameCB: TGroupBox;
    ImprovedInterfaceRB: TRadioButton;
    ClassicInterfaceRB: TRadioButton;
    OriginalInterfaceRB: TRadioButton;
    RestoreBtn: TButton;
    ControllerCB: TGroupBox;
    FixControllerButtonsCB: TCheckBox;
    XboxControllerSupportCB: TCheckBox;
    DamageVibrationCB: TCheckBox;
    SaveBtn: TButton;
    AutoLoadCB: TCheckBox;
    VibrationIntensityLbl: TLabel;
    VibrationIntensityTB: TTrackBar;
    VibrationIntensityValueLbl: TLabel;
    SoundFixCB: TCheckBox;
    MenuFixCB: TCheckBox;
    FPSLimit30RB: TRadioButton;
    FPSLimit24RB: TRadioButton;
    procedure AboutBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResolutionsCBChange(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure BrightnessTBChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RestoreBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure VibrationIntensityTBChange(Sender: TObject);
    procedure XboxControllerSupportCBClick(Sender: TObject);
    procedure DXWrapperCBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Main: TMain;
  AppPath, GameExePath, GameCfgPath, SavePath, CurrentLang: string;
  LoadSavesOnce: boolean = false;
  DebugMode: boolean;

  AspectRatiosList: TStringList;
  IDS_ASPECT_RATIO_AUTO, IDS_GAME_NOT_FOUND, IDS_SAVES, IDS_DONE,
  IDS_AUDIO_FIXES, IDS_FPS_LIMIT, IDS_ABOUT, IDS_LAST_UPDATE,
  IDS_SPECIAL_THANKS: string;

implementation

uses Unit2;

{$R *.dfm}

function GetLocaleInformation(flag: integer): string;
var
  pcLCA: array [0..63] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, flag, pcLCA, Length(pcLCA)) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure TMain.AboutBtnClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 1.3.1' + #13#10 +
  IDS_LAST_UPDATE + ' 27.10.26' + #13#10#13#10 +
  IDS_SPECIAL_THANKS + #13#10#13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(IDS_ABOUT), MB_ICONINFORMATION);
end;

procedure TMain.FormCreate(Sender: TObject);
var
  i: integer;
  CurrentResolution: string;
  ForceEnLang: boolean;
begin
  DecimalSeparator:='.';
  ThousandSeparator:=#0;
  AppPath:=ExtractFilePath(ParamStr(0));
  GameExePath:=AppPath + 'SpideyPC.exe';
  GameCfgPath:=AppPath + 'Spidey.cfg';
  SavePath:=AppPath + 'save\SPIDRMAN.DAT';
  RestoreBtn.Enabled:=FileExists(GameExePath + '.bak');
  SaveBtn.Enabled:=FileExists(SavePath);

  DebugMode:=false;
  ForceEnLang:=false;
  for i:=1 to ParamCount do
    if ParamStr(i) = '-en' then
      ForceEnLang:=true
    else if ParamStr(i) = '-debug' then
      DebugMode:=true;

  IDS_ASPECT_RATIO_AUTO:='Auto';
  IDS_GAME_NOT_FOUND:='Game "SpideyPC.exe" not found.' + #13#10 +
    'Extract the archive files to the game''s root folder.';
  IDS_AUDIO_FIXES:='To fix audio crackling, also enable Windows XP compatibility mode in the shortcut properties.';
  IDS_DONE:='Done.';
  IDS_SAVES:=
    'If you have previously saved your game,' + #13#10 +
    'you need to load your save from the settings menu' + #13#10 +
    'before continuing the game.';
  IDS_FPS_LIMIT := 'If you have trouble getting through certain sections, switch to 24 FPS, get past the problematic section, and then switch back.';

  IDS_ABOUT:='About...';
  IDS_LAST_UPDATE:='Last update:';
  IDS_SPECIAL_THANKS:='Special thanks:' + #13#10 +
    'Hemanshu Shekhar - for finding the addresses for FOV and aspect ratio.' + #13#10 +
    'GTRemyLeceau (GTTeancum) - for recompiling the PS1 version and widescreen improvements.' + #13#10 +
    'Elisha Riedlinger (elishacloud) - for DxWrapper.' + #13#10 +
    'Jose Silva (krystalgamer) - for the save editor utility.' + #13#10 +
    'Claude AI - for help with the remaining improvements.';

  CurrentLang:=GetLocaleInformation(LOCALE_SENGLANGUAGE);
  if (CurrentLang = 'Russian') and (not ForceEnLang) then begin
    Caption:='Человек-Паук настройки';
    IDS_GAME_NOT_FOUND := 'Игра "SpideyPC.exe" не найдена.' + #13#10 +
      'Распакуйте файлы из архива в корень папки игры.';

    VideoGB.Caption:='Видео';
    ResLbl.Caption:='Разрешение:';
    AspectRatioLbl.Caption:='Соотношение сторон:';
    IDS_ASPECT_RATIO_AUTO:='Авто';
    ColorDepthLbl.Caption:='Глубина цвета:';
    BrightnessLbl.Caption:='Яркость:';

    GameCB.Caption:='Игра';
    ImprovedInterfaceRB.Caption:='Улучшенный интерфейс (рекомендуется)';
    ImprovedInterfaceRB.Hint:='Некоторые элементы интерфейса выровнены по центру.';
    ClassicInterfaceRB.Caption:='Классический интерфейс';
    ClassicInterfaceRB.Hint:='Некоторые элементы интерфейса растягиваются на весь экран, как в оригинальной игре';
    OriginalInterfaceRB.Caption:='Оригинальный интерфейс (растянутый)';
    MenuFixCB.Caption:='Исправление меню';
    MenuFixCB.Hint:='Исправляет пропорции меню и отображение правой стороны рамки.';
    AutoLoadCB.Caption:='Автозагрузка первого сохранения';

    ControllerCB.Caption:='Контроллер';

    CompatibilityGB.Caption:='Совместимость';
    SoundFixCB.Caption:='Исправление заикания фоновой музыки';
    SoundFixCB.Hint:='Устраняет заикание фоновой музыки на уровне со Скорпионом.';
    DXWrapperCB.Caption:='Совместимость DirectX (DxWrapper)';
    FPSLimit30RB.Caption:='30 FPS (бывают проблемы)';
    FPSLimit24RB.Caption:='24 FPS (полностью проходимо)';
    WindowedModeCB.Caption:='Оконный режим';
    XboxControllerSupportCB.Caption:='Поддержка Xbox контроллеров';
    XboxControllerSupportCB.Hint:='Кнопка "LB/L1" на геймпаде эмулирует нажатие клавиши "A" на клавиатуре, позволяя ввести название сохранения.';
    FixControllerButtonsCB.Caption:='Исправить кнопки геймпада';
    FixControllerButtonsCB.Hint:='Исправляет кнопку подтверждения и пропуск роликов, а также позволяет включать невидимость в костюме "Спайди без границ" (прицел + удар)';
    DamageVibrationCB.Caption:='Вибрация от урона';
    VibrationIntensityLbl.Caption:='Сила вибрации:';

    RestoreBtn.Caption:='Восстановить';
    ApplyBtn.Caption:='Применить';
    SaveBtn.Caption:='Сохранение';
    IDS_AUDIO_FIXES:='Для устранения тресков звука также включите режим совместимости с Windows XP в свойствах ярлыка.';
    IDS_DONE := 'Готово.';
    IDS_SAVES:=
      'Если вы ранее сохранялись в игре необходимо' + #13#10 +
      'загрузить сохранение через меню настроек' + #13#10 +
      'перед продолжением игры.';
    IDS_FPS_LIMIT:='Если у вас возникают проблемы с прохождением некоторых участков, переключитесь на 24 FPS, пройдите проблемный участок и переключитесь обратно.';
    ExitBtn.Caption:='Выход';

    IDS_ABOUT:='О программе...';
    IDS_LAST_UPDATE:='Последнее обновление:';
    IDS_SPECIAL_THANKS:='Особая благодарность:' + #13#10 +
      'Hemanshu Shekhar - за найденные адреса для FOV и соотношения сторон.' + #13#10 +
      'GTRemyLeceau (GTTeancum) - за рекомпиляцию версии игры для PS1 и широкоформатные улучшения.' + #13#10 +
      'Elisha Riedlinger (elishacloud) - за DxWrapper.' + #13#10 +
      'Jose Silva (krystalgamer) - за утилиту для изменения сохранений.' + #13#10 +
      'Claude AI - за помощь в остальных улучшениях.';
  end else
    CurrentLang:='English'; // SavesForm

  Application.Title:=Caption;

  if FileExists(AppPath + 'Resolutions.txt') then
    ResolutionsCB.Items.LoadFromFile(AppPath + 'Resolutions.txt');

  if ResolutionsCB.Items.Count > 0 then
    ResolutionsCB.ItemIndex:=0;

  CurrentResolution:=IntToStr(Screen.Width) + 'x' + IntToStr(Screen.Height);
  for i:=0 to ResolutionsCB.Items.Count - 1 do begin
    if Pos(CurrentResolution, ResolutionsCB.Items[i]) > 0 then begin
      ResolutionsCB.ItemIndex:=i;
      Break;
    end;
  end;

  AspectRatiosList:=TStringList.Create;
  if FileExists(AppPath + 'AspectRatios.txt') then
    AspectRatiosList.LoadFromFile(AppPath + 'AspectRatios.txt');
  AspectRatiosCB.Items.Add(IDS_ASPECT_RATIO_AUTO);
  for i:=0 to AspectRatiosList.Count - 1 do
    AspectRatiosCB.Items.Add(Copy(AspectRatiosList.Strings[i], 1, Pos('=', AspectRatiosList.Strings[i]) - 1));

  if AspectRatiosCB.Items.Count > 0 then
    AspectRatiosCB.ItemIndex:=0;

  // Windows <= Windows XP
  if (Win32MajorVersion < 5) or ((Win32MajorVersion = 5) and (Win32MinorVersion <= 1)) then begin
    DXWrapperCB.Checked:=false;
  end;

  if DebugMode then begin
    ResolutionsCB.Items.Add('1920x810 (21:9)');
    ResolutionsCB.Items.Add('1920x540 (32:9)');
    Caption:=Caption + ' - Debug Mode';
  end;
end;

procedure TMain.ResolutionsCBChange(Sender: TObject);
//var
  //AspectRatiosIndex: Integer;
  //ResText, AspectRatiosText: string;
begin
  {if ResolutionsCB.ItemIndex = -1 then Exit;

  ResText:=ResolutionsCB.Items[ResolutionsCB.ItemIndex];

  if (Pos(' ', ResText) = 0) or (Pos('(', ResText) = 0) then Exit;

  AspectRatiosText:=Copy(ResText, Pos('(', ResText) + 1, Pos(')', ResText) - Pos('(', ResText) - 1);

  AspectRatiosIndex:=AspectRatiosCB.Items.IndexOf(AspectRatiosText);

  if AspectRatiosIndex <> -1 then
    AspectRatiosCB.ItemIndex:=AspectRatiosIndex;}
end;

procedure TMain.ApplyBtnClick(Sender: TObject);
const
  // ===== Music fix / Исправление музыки =====
  // The voice-slot check looked at LOOPING (4) instead of PLAYING (1)
  // Проверка занятости голоса смотрела на LOOPING (4), а не на PLAYING (1)
  VoiceFixFileOffset = $10444F + $40; // = $10448F, byte in "and eax, 4" (83 E0 04) / байт в "and eax, 4"

  // ===== Culling / Отрезка полигонов =====
  CullFileOffset = $73058;
  CullOrig: array[0..6] of Byte = ($0F, $AF, $2D, $5C, $4F, $65, $00);

  // ===== Aspect ratio float / Float соотношения сторон =====
  AspectFileOffset = $150064;

  // ===== PS1 projection matrix / Матрица PS1-проекции =====
  // "imul edx, [654F5C]" scales the X row of the camera matrix by 1.6 (0x1999 / 4096): this is the PS1 non-square pixel fix.
  // Objects drawn through the PS1 projection (Venom tentacles, etc.) must follow the aspect, like the D3D world
  // "imul edx, [654F5C]" масштабирует X-строку матрицы камеры в 1.6 раза (0x1999 / 4096): поправка на неквадратные пиксели PS1.
  // Объекты через PS1-проекцию (тентакли Венома и др.) должны следовать аспекту, как мир на D3D
  ProjXFileOffset = $73279; // VA 0x473279
  ProjXOrig: array[0..6] of Byte = ($0F, $AF, $15, $5C, $4F, $65, $00);

  // ===== HUD wrapper (code cave) / Обёртка HUD (пустое место в коде) =====
  HudCaveVA = $53ACF0;          // free space at the end of .text / пустое место в конце .text
  HudCaveFileOffset = $13ACF0;  // same, file offset / то же, смещение в файле
  PanelCallVA = $45561A;        // call Panel_Display (VA 0045561A)
  PanelCallFileOffset = $5561A; // same, file offset / то же, смещение в файле
  PanelCallOrigRel32 = $102A1;  // original rel32 of this call / исходный rel32 этого вызова
  PanelDisplayVA = $4658C0;     // Panel_Display function / функция Panel_Display
  HudCaveTemplate: array[0..65] of Byte = (
    $C7,$05,$FC,$B5,$61,$00, 0,0,0,0,          // mov [logW], LogicalWidth
    $C7,$05,$14,$86,$62,$00, 0,0,0,0,          // mov [logH], LogicalHeight
    $81,$05,$6C,$F7,$60,$00, 0,0,0,0,          // add [60F76C], HudShiftY (HUD Y shift / сдвиг худа по Y)
    $E8, 0,0,0,0,                              // call Panel_Display
    $81,$2D,$6C,$F7,$60,$00, 0,0,0,0,          // sub [60F76C], HudShiftY
    $C7,$05,$FC,$B5,$61,$00, $00,$02,$00,$00,  // mov [logW], 512
    $C7,$05,$14,$86,$62,$00, $F0,$00,$00,$00,  // mov [logH], 240
    $C3);
  // Positions of the values inside the template / Позиции значений внутри шаблона
  CavePosLogicalWidth = 6;
  CavePosLogicalHeight = 16;
  CavePosShiftYAdd = 26;
  CavePosCallRel32 = 31;
  CavePosShiftYSub = 41;
  CaveCallEndOffset = 35; // offset of the byte after "call" inside the cave / байт после call внутри пещеры

  //HudScale = 0.87; // now calculated from the aspect / теперь считается из аспекта
  // Top group margin (logical units), so the HUD does not move up when scaled down
  // Отступ верхней группы худа от верха (логические единицы), чтобы при уменьшении худ не уезжал вверх
  HudTopMargin = 36;

  // ===== Ultrawide (wider than 16:9) / Ультраширокие экраны (шире 16:9) =====
  // The HUD is laid out as for 16:9 and centered, the rest of the screen is just the picture
  // HUD раскладывается как для 16:9 и центрируется, остальное пространство - просто картинка
  HudMinAspect = 0.75; // 16:9
  // Stubs "add [esp+N], margin; jmp builder" shift the left HUD group (Spider-Man head, health, cartridges)
  // Заглушки "add [esp+N], отступ; jmp функция" сдвигают левую группу HUD (голова Спайдера, здоровье, картриджи)
  HudStubCaveVA = $53AE60;
  HudStubCaveFileOffset = $13AE60;
  HudStubSize = 16;
  HudStubSprite = 0; HudStubBar = 1; HudStubLine = 2; HudStubText = 3;
  BuilderSpriteVA = $462C30;
  BuilderBarVA = $462D60;
  BuilderLineVA = $462FB0;
  TextOutVA = $458700;
  // VA of the "call" instructions of the left group in Panel_Display / VA инструкций "call" левой группы в Panel_Display
  LeftSpriteCalls: array[0..5] of Integer = ($4659C1, $465D70, $465FA0, $4661D7, $4663FB, $466623);
  LeftBarCalls: array[0..2] of Integer = ($4668D1, $466A1B, $466A65);
  LeftLineCalls: array[0..2] of Integer = ($46687B, $466931, $4669C7);
  LeftTextCall = $465A83; // cartridge counter text / текст счётчика картриджей

  // ===== Compass / Компас =====
  // X: $1B0 - arrow / стрелка, $1CA - ring / кольцо; Y: $C7 - arrow / стрелка, $D7 - ring / кольцо
  CompassXOffsets: array[0..8] of Integer = ($63B06, $63B1B, $63B46, $63BC4, $63BD6, $63C38, $63CBC, $63DFA, $64074);
  CompassXOriginal: array[0..8] of Integer = ($1B0, $1B0, $1B0, $1B0, $1B0, $1B0, $1B0, $1CA, $1CA);
  CompassYOffsets: array[0..8] of Integer = ($63A9B, $63AAE, $63B31, $63B96, $63BBF, $63C14, $63CA1, $63DF1, $6406B);
  CompassYOriginal: array[0..8] of Integer = ($C7, $C7, $C7, $C7, $C7, $C7, $C7, $D7, $D7);

  // ===== Reticle (DrawReticle, 0x4C4700) / Прицел =====
  // X sizes are multiplied by 0x66666667 ("mov eax, imm32", twice); scale it by the aspect so it is not stretched
  // Размеры по X умножаются на 0x66666667 ("mov eax, imm32", два раза); масштабируем аспектом, чтобы не растягивался
  // + Police Chopper Chase: search light / gun sight ($42235A) and rotating missile target ($4245A6, $4245CB)
  // + Police Chopper Chase: прожектор / прицел пулемёта ($42235A) и вращающийся прицел ракет ($4245A6, $4245CB)
  ReticleXMulFileOffsets: array[0..4] of Integer = ($C474E, $C4794, $2235A, $245A6, $245CB);
  ReticleXMulOriginal = $66666667;

  // ===== Timer (top center) / Таймер (вверху по центру) =====
  // File offsets of X constants and originals (the last one is the timer text)
  // Смещения констант X в файле и исходные значения (последняя - текст таймера)
  TimerXOffsets: array[0..5] of Integer = ($61F45, $6213E, $62396, $62412, $62469, $6236B);
  TimerXOriginal: array[0..5] of Integer = ($DB, $F1, $DE, $DE, $DE, $EA);

  // ===== Text / Текст =====
  // 8-bit Y constants (cartridge counter, timer text) / 8-битные константы Y (счётчик картриджей, текст таймера)
  TextYOffsets: array[0..1] of Integer = ($65A7A, $62367);
  TextYOriginal: array[0..1] of Byte = ($38, $26);
  TextExtraDownShift = 2; // 1 unit = about 4.5 px at 1080p / 1 единица = около 4.5 px на 1080p

  // ===== Boss HUD / HUD боссов =====
  // Portraits, HP, Mary Jane water bar, etc. / Портреты, HP, полоса Мэри Джейн и т.д.
  BossAnchor = 1.0; // 1.0 - right edge / у правого края, 0.5 - center / по центру
  BossXOffsets: array[0..16] of Integer = ($64317, $64531, $64760, $64974, $64996, $64AC3, $64CD8, $64EF3, $650E2,
    $65124, $65159, $651C9, $653DD, $655EC, $657F6, $6583C, $65871);
  BossXOriginal: array[0..16] of Integer = ($1C0, $1D7, $1D7, $1D3, $1D3, $1C0, $119, $136, $120,
    $120, $171, $1C0, $196, $1B3, $19D, $19D, $1B0);

  // ===== Escape from Doctor Octopus / Побег от Доктора Осьминога =====
  // Horizontal bar (same scheme as the Venom chase) / Горизонтальная полоска (та же схема, что у погони Венома)
  EscapeBarXOffsets: array[0..4] of Integer = ($D0FBC, $D1016, $D10B0, $D1118, $D1172);
  EscapeBarXOriginal: array[0..4] of Integer = ($1BE, $1BE, $8A, $85, $1E0);
  // Vertical radiation bar (right edge, like the boss HUD) / Вертикальная полоска радиации (справа, как HUD боссов)
  EscapeRadiationXOffsets: array[0..4] of Integer = ($D1227, $D129E, $D12F9, $D1393, $D13D8);
  EscapeRadiationXOriginal: array[0..4] of Integer = ($1D6, $1C0, $1D6, $1D2, $1D2);

  // ===== Subway (bottom bar) / Метро (полоска снизу) =====
  // Nudges: start of the wagon loop, left cap, right cap / Нуджи: начало цикла вагонов, левая и правая заглушки
  SubwayNudgeOffsets: array[0..2] of Integer = ($14B44C, $14B45C, $14B46C);
  SubwayNudgeOriginal: array[0..2] of Integer = (6, 7, 6);
  SubwayYOffsets: array[0..3] of Integer = ($48AFB, $48B58, $48BC3, $48C1E);
  SubwayYOriginal: array[0..3] of Integer = ($D3, $D9, $D7, $D7);
  SubwayTrainStartFileOffset = $48AAF; // train start position (value * 4096) / старт позиции поезда (значение * 4096)
  SubwayTrainStartOriginal = $182B80;
  SubwayLoopEndFileOffset = $48B84;    // end of the wagon loop / конец цикла вагонов
  SubwayLoopEndOriginal = $1A4;        // Improved: not shifted, the loop start is shifted instead / Improved: не сдвигаем, сдвигается начало цикла
  SubwayWagonStep = 30;                // wagon step: the bar length must be a multiple of it / шаг вагона: длина полоски кратна ему
  // Train speed: x = (TrainStart - progress * M) >> 12, M = (1 + 2 * K) * N, originally K = 5, N = 16 (M = 176)
  // Скорость поезда: x = (TrainStart - progress * M) >> 12, M = (1 + 2 * K) * N, в оригинале K = 5, N = 16 (M = 176)
  SubwayMulKFileOffset = $48AAA; // lea ecx,[eax+eax*4] (8D 0C 80) -> imul ecx,eax,K (6B C8 K)
  SubwayMulNFileOffset = $48ABC; // shl edx,4 (C1 E2 04) -> imul edx,edx,N (6B D2 N)
  SubwayMulKOriginal: array[0..2] of Byte = ($8D, $0C, $80);
  SubwayMulNOriginal: array[0..2] of Byte = ($C1, $E2, $04);
  SubwayMaxProgress = 9000; // progress at the start (0x2328): the train is at the left end / прогресс в начале (0x2328): поезд у левого края
  SubwayTrainTravel = 386;  // train travel in the original (px) / путь поезда в оригинале (px)

  // ===== Approach bar (Scorpion walks to Jameson) / Полоска "подхода" (Скорпион идёт к Джеймсону) =====
  // Improved: $90 - moving head, $1BE - Jameson head, $8A/$1E0 - segment loop start/end,
  //           $85 - left cap, $1E0 - right cap
  // Improved: $90 - подвижная голова, $1BE - голова Джеймсона, $8A/$1E0 - начало/конец цикла сегментов,
  //           $85 - левая крышка, $1E0 - правая крышка
  ApproachXOffsets: array[0..5] of Integer = ($47A72, $47D16, $47F5E, $48163, $48199, $48398);
  ApproachXOriginal: array[0..5] of Integer = ($90, $1BE, $8A, $1E0, $85, $1E0);
  ApproachMiddleX = 309; // bar center at 4:3 ($85 .. about $1E6) / середина полоски на 4:3 (от $85 до примерно $1E6)
  // Classic: only the right part is stretched (segment length step = 18)
  // Classic: тянется только правая часть (шаг сегмента = 18)
  ApproachSegmentStep = 18;
  ApproachClassicXOffsets: array[0..2] of Integer = ($47D16, $48163, $48398);
  ApproachClassicXOriginal: array[0..2] of Integer = ($1BE, $1E0, $1E0);
  // Moving head step: tables A and B (B is changed so the head reaches the new bar end)
  // Шаг подвижной головы: таблицы A и B (меняем B, чтобы голова доезжала до нового конца полоски)
  ApproachHeadStepOffsets: array[0..3] of Integer = ($14B34C, $14B350, $14B354, $14B358);
  ApproachHeadStepB: array[0..3] of Integer = (59, 59, 46, 33);
  ApproachHeadStepA: array[0..3] of Integer = (16260, 16260, 12660, 9060);

  // ===== Venom chase (function 0x4E7D90) / Погоня за Веномом (функция 0x4E7D90) =====
  VenomChaseXOffsets: array[0..4] of Integer = ($E7F3F, $E815A, $E8379, $E8599, $E87B0);
  VenomChaseXOriginal: array[0..4] of Integer = ($1BE, $1BE, $8A, $85, $1E0);

  // ===== Chase bars (Venom, Doc Ock): Classic stretch / Полоски погони (Веном, Док Ок): растягивание в Classic =====
  // Only the right part moves: head A, head B, right cap / Сдвигается только правая часть: голова A, голова B, правая крышка
  VenomChaseClassicXOffsets: array[0..2] of Integer = ($E7F3F, $E815A, $E87B0);
  EscapeBarClassicXOffsets: array[0..2] of Integer = ($D0FBC, $D1016, $D1172);
  ChaseBarClassicXOriginal: array[0..2] of Integer = ($1BE, $1BE, $1E0);
  ChaseSegmentStep = 18;           // segment step of the loop / шаг сегмента в цикле
  ChaseLoopEndOriginal = $156;     // "cmp esi, 0x156" - end of the segment loop / конец цикла сегментов
  VenomLoopEndFileOffset = $E8549;
  EscapeLoopEndFileOffset = $D10D5;
  // Moving head: offset = progress * 307 / max, 307 = its travel in px; we replace 307 with 307 + stretch
  // Подвижная голова: смещение = progress * 307 / max, 307 - её путь в px; заменяем 307 на 307 + растяжение
  ChaseHeadTravel = 307;
  VenomMoverFileOffset = $E7EC6;   // 14 bytes (with "push ebx") / 14 байт (вместе с "push ebx")
  VenomMoverOriginal: array[0..13] of Byte = ($8B, $C8, $53, $C1, $E1, $04, $03, $C8, $8D, $14, $C9, $8D, $04, $50);
  EscapeMoverFileOffset = $D0F13;  // 13 bytes / 13 байт
  EscapeMoverOriginal: array[0..12] of Byte = ($8B, $C8, $C1, $E1, $04, $03, $C8, $8D, $0C, $C9, $8D, $04, $48);

  // ===== Joystick fixes / Исправления джойстика =====
  // Main menu: confirm button (action 0x10) via a code cave (after the HUD cave: $53ACF0 + 66 = $53AD32)
  // Главное меню: подтверждение джойстиком через пустое место (после HUD-пещеры)
  JoyCaveVA = $53AD40;
  JoyCaveFileOffset = $13AD40;
  JoyMenuCallFileOffset = $93E56;   // call 0x50C180 in the main menu / вызов в главном меню
  JoyMenuCallOrig: array[0..4] of Byte = ($E8, $25, $83, $07, $00);
  JoyMenuCallNew: array[0..4] of Byte = ($E8, $E5, $6E, $0A, $00); // call JoyCaveVA
  JoyCave: array[0..12] of Byte = (
    $81, $4C, $24, $04, $00, $00, $01, $00,  // or dword ptr [esp+4], 0x10000
    $E9, $33, $14, $FD, $FF);                // jmp 0x50C180
  // Single bytes: skip movies and the "Enter" screen with the confirm button instead of Start
  // Одиночные байты: скип роликов и экран «Enter» на кнопке подтверждения вместо Start
  JoyMovieSkipFileOffset = $70851;  // 00 -> 01 (mask 0x7000000 -> 0x7010000)
  JoyEnterScreenFileOffset = $A1894; // 04 -> 01 (mask 0x40010 -> 0x10010)

  // ===== Invisibility (Spidey Unlimited) with a gamepad / Невидимость (Spidey Unlimited) на геймпаде =====
  // The player update ($4B13F0) tests the keyboard scancodes of actions 0x40 and 0x100 only; we test the gamepad buttons too
  // Функция игрока ($4B13F0) проверяет только сканкоды клавиатуры действий 0x40 и 0x100; добавляем кнопки геймпада
  InvisSiteVA = $4B141D;
  InvisSiteEndVA = $4B1479;
  InvisSiteOrig: array[0..10] of Byte = ($50, $6A, $40, $C6, $86, $E4, $0A, $00, $00, $01, $E8);
  InvisNoVA = $4B14BB;             // "not pressed" branch / ветка «не нажато»
  InvisCostumeVA = $5559DC;        // current costume / текущий костюм
  InvisCostumeId = 5;              // Spidey Unlimited
  InvisAttackKeySlotVA = $5683CC;  // key of action 0x40 (the pad button is at +$70) / клавиша действия 0x40 (кнопка геймпада +$70)
  InvisAimKeySlotVA = $5683DC;     // key of action 0x100 / клавиша действия 0x100
  KeyEdgeCheckVA = $50A650;        // key was just pressed / клавиша только что нажата
  PadEdgeCheckVA = $50A680;        // pad button was just pressed / кнопка только что нажата
  InvisCave1VA = $402171;          // 15 bytes of alignment NOPs / 15 байт NOP выравнивания
  InvisCave2VA = $402181;          // 15 bytes
  InvisCave3VA = $402191;          // 15 bytes

  // ===== Autoload save / Автозагрузка сохранения =====
  // Hook: the first instruction of the pad poll function 0x505720 ("mov eax,[66129C]") is replaced with
  // a jmp to the cave. The cave counts the calls and on the AutoLoadPolls-th one loads slot 0 once
  // (Card_Load + the same copying the load menu does).
  // Хук: первая инструкция функции опроса геймпада 0x505720 заменяется на jmp в пещеру. Пещера считает вызовы
  // и на AutoLoadPolls-м один раз загружает слот 0 (Card_Load + то же копирование, что делает меню загрузки).
  AutoLoadCaveFileOffset = $13AD60;       // VA 0x53AD60
  AutoLoadHookFileOffset = $105720;       // VA 0x505720
  AutoLoadHookOrig: array[0..4] of Byte = ($A1, $9C, $12, $66, $00);
  AutoLoadHook: array[0..4] of Byte = ($E9, $3B, $56, $03, $00);
  AutoLoadPolls = 300;                    // pad polls before loading (about 5-10 s) / опросов до загрузки (около 5-10 с)
  AutoLoadPollsPos = 17;                  // position of the 32-bit value inside the cave / позиция 32-битного значения в пещере
  AutoLoadCave: array[0..222] of Byte = (
    $A1, $9C, $12, $66, $00, $FF, $05, $EC, $09, $61, $00, $81,
    $3D, $EC, $09, $61, $00, $2C, $01, $00, $00, $0F, $85, $BF,
    $00, $00, $00, $60, $80, $3D, $88, $66, $5F, $00, $00, $75,
    $07, $B8, $50, $11, $43, $00, $FF, $D0, $C6, $05, $F0, $09,
    $61, $00, $01, $B8, $F0, $C7, $46, $00, $FF, $D0, $C6, $05,
    $F0, $09, $61, $00, $00, $85, $C0, $0F, $85, $90, $00, $00,
    $00, $BE, $B0, $01, $61, $00, $83, $3E, $00, $0F, $84, $82,
    $00, $00, $00, $31, $C0, $8D, $4E, $04, $BA, $2E, $00, $00,
    $00, $A9, $00, $00, $00, $80, $74, $06, $8D, $44, $00, $01,
    $EB, $02, $D1, $E0, $8B, $19, $83, $C1, $04, $01, $D8, $4A,
    $75, $E7, $8B, $0E, $0C, $01, $39, $C1, $75, $57, $B9, $2F,
    $00, $00, $00, $BF, $58, $28, $68, $00, $F3, $A5, $BE, $24,
    $11, $55, $00, $31, $FF, $0F, $BE, $16, $8D, $87, $D3, $0E,
    $55, $00, $52, $8D, $8F, $93, $07, $61, $00, $50, $51, $B8,
    $F0, $EF, $49, $00, $FF, $D0, $83, $C6, $10, $83, $C4, $0C,
    $83, $C7, $19, $81, $FE, $94, $12, $55, $00, $7C, $D6, $B9,
    $90, $00, $00, $00, $BE, $90, $07, $61, $00, $BF, $D0, $0E,
    $55, $00, $F3, $A5, $66, $A5, $B8, $30, $A4, $47, $00, $FF,
    $D0, $61, $E9, $E6, $A8, $FC, $FF);

  // Vibration pulse wait skip while autoload runs / пропуск ожидания вибрации при автозагрузке
  AutoLoadWaitCaveFileOffset = $13AE40;   // VA 0x53AE40
  AutoLoadWaitCave: array[0..14] of Byte = (
    $80, $3D, $F0, $09, $61, $00, $00, $75, $05, $E9, $42, $60, $EF, $FF, $C3);
  AutoLoadWaitSiteFileOffset = $6C92A;    // VA 0x46C92A: call 0x430E90 in Card_Load
  AutoLoadWaitSiteOrig: array[0..4] of Byte = ($E8, $61, $45, $F6, $FF);
  AutoLoadWaitSite: array[0..4] of Byte = ($E8, $11, $E5, $0C, $00);

  // ===== Vibration on damage / Вибрация при получении урона =====
  // Hook in the hero damage handler (0x4BD890), right after HP is subtracted: "mov al,[esp+20h]; test al,al"
  // is replaced with jmp to the cave. The cave calls the game's PAD_Vibrate (0x4794D0) if vibration is enabled
  // in the game and damage > 0. Duration = 8 + damage/128 frames (max 30).
  // Хук в обработчике урона героя, сразу после вычитания HP: "mov al,[esp+20h]; test al,al" заменяется
  // на jmp в пещеру. Пещера вызывает игровую PAD_Vibrate (0x4794D0), если вибрация включена в игре и урон > 0.
  // Длительность = 8 + урон/128 кадров (максимум 30).
  DmgVibeCaveFileOffset = $13AEC0;   // VA 0x53AEC0 (after the HUD stubs / после заглушек HUD)
  DmgVibeHookFileOffset = $BDA81;    // VA 0x4BDA81
  DmgVibeHookOrig: array[0..5] of Byte = ($8A, $44, $24, $20, $84, $C0);
  DmgVibeHook: array[0..5] of Byte = ($E9, $3A, $D4, $07, $00, $90);
  DmgVibeCave: array[0..63] of Byte = (
    $60,$80,$3D,$D3,$28,$68,$00,$00,$74,$2A,$0F,$B7,$45,$08,$85,$C0,
    $74,$22,$C1,$E8,$07,$83,$C0,$08,$83,$F8,$1E,$76,$05,$B8,$1E,$00,
    $00,$00,$68,$64,$00,$00,$00,$6A,$01,$50,$6A,$00,$E8,$DF,$E5,$F3,
    $FF,$83,$C4,$10,$61,$8A,$44,$24,$20,$84,$C0,$E9,$87,$2B,$F8,$FF);

  // ===== Menu fix (pause menu, hints/subtitles, frames) / Исправление меню (пауза, подсказки/субтитры, рамки) =====
  // The 2D menus are laid out on the 512x240 PS1 grid. On a wide screen the grid is wider (MenuLogicalWidth = 512 / aspect):
  //  - the pause menu is drawn on the wide grid and every builder adds the shift M = (MenuLogicalWidth - 512) / 2 to X,
  //    so the menu is centered and not stretched;
  //  - the hints/subtitles are drawn on the wide grid without a shift (they are anchored to the left);
  //  - the hint text box (script text window) is scaled back: x and width * K / 256, K = 256 * 512 / MenuLogicalWidth;
  //  - the right sprite of every frame is pulled to the left so the frame has no gap.
  // Меню раскладываются на сетке PS1 512x240. На широком экране сетка шире (MenuLogicalWidth = 512 / аспект):
  //  - меню паузы рисуется на широкой сетке, а каждый построитель добавляет к X сдвиг M = (MenuLogicalWidth - 512) / 2,
  //    поэтому меню по центру и не растянуто;
  //  - подсказки/субтитры рисуются на широкой сетке без сдвига (привязаны к левому краю);
  //  - текстбокс подсказок (окно текста скриптов) сжимается обратно: x и ширина * K / 256, K = 256 * 512 / MenuLogicalWidth;
  //  - правый спрайт каждой рамки подтягивается влево, чтобы в рамке не было зазора.
  // The variable M lives in the code cave, so .text must be writable (section Characteristics 60000020 -> E0000020)
  // Переменная M лежит в пещере кода, поэтому .text должна быть записываемой (Characteristics секции 60000020 -> E0000020)
  MenuTextSectionFlagsFileOffset = $227; // high byte of .text Characteristics (section header + $24 + 3) / старший байт Characteristics секции .text
  MenuTextSectionFlagsValue = $E0;
  LogicalWidthVA = $61B5FC;              // logical screen width (the PS1 grid) / логическая ширина экрана (сетка PS1)
  // The original pause menu call must be here, otherwise the exe is not the original / здесь должен быть исходный вызов меню паузы, иначе exe не оригинальный
  MenuSiteCheckFileOffset = $5599C;
  MenuSiteCheckOrig: array[0..4] of Byte = ($E8, $4F, $B1, $FE, $FF);

  // Code caves of the menu fix (all inside the free gaps between the other caves, nothing overlaps):
  // Пещеры исправления меню (все в свободных зазорах между остальными пещерами, ничего не пересекается):
  MenuShiftVarVA = $53ACE8;       // 4 bytes: M, zero outside of the pause menu / 4 байта: M, вне меню паузы равна нулю
  MenuFrameHeadCaveVA = $53AD32;  // 14 bytes, after the HUD cave / 14 байт, после пещеры HUD
  MenuTextStubCaveVA = $53AD4D;   // 19 bytes, after the joystick cave / 19 байт, после пещеры джойстика
  MenuLineStubCaveVA = $53AEA0;   // 19 bytes, after the HUD stubs / 19 байт, после заглушек HUD
  MenuFrameTailCaveVA = $53AEB3;  // 10 bytes / 10 байт
  MenuSpriteStubCaveVA = $53AF00; // 22 bytes, after the damage vibration cave / 22 байта, после пещеры вибрации
  MenuSprite2StubCaveVA = $53AF16; // 22 bytes / 22 байта
  MenuBarStubCaveVA = $53AF2C;    // 21 bytes / 21 байт
  MenuPauseWrapCaveVA = $53AF41;  // 46 bytes / 46 байт
  MenuSubtitleWrapCaveVA = $53AF6F; // 36 bytes / 36 байт
  MenuPlainTrimCaveVA = $53AE4F;  // 17 bytes, after the autoload wait cave / 17 байт, после пещеры ожидания автозагрузки
  MenuWindowHookCaveVA = $53AF93; // 69 bytes / 69 байт
  MenuTextBoxHookCaveVA = $53AFD8; // 38 bytes, ends at $53AFFE (the end of the free space in .text) / 38 байт, заканчивается на $53AFFE (конец свободного места в .text)

  // Builders (VA of the first instruction) and the instructions the "jmp" to the stub replaces
  // Построители (VA первой инструкции) и инструкции, которые заменяет "jmp" на заглушку
  MenuBuilderSprite2VA = $462CD0;
  MenuBuilderFrameVA = $4626A0;
  MenuWindowVA = $47A700;
  MenuTextOutDisplaced: array[0..4] of Byte = ($A1, $A8, $D5, $60, $00);              // mov eax,[60D5A8]
  MenuSpriteDisplaced: array[0..7] of Byte = ($8B, $44, $24, $14, $8B, $4C, $24, $10); // mov eax,[esp+14]; mov ecx,[esp+10]
  MenuSprite2Displaced: array[0..7] of Byte = ($8B, $44, $24, $14, $8B, $54, $24, $10); // mov eax,[esp+14]; mov edx,[esp+10]
  MenuBarDisplaced: array[0..6] of Byte = ($8B, $44, $24, $28, $83, $EC, $10);        // mov eax,[esp+28]; sub esp,10
  MenuLineDisplaced: array[0..4] of Byte = ($83, $EC, $0C, $53, $55);                 // sub esp,0C; push ebx; push ebp
  MenuFrameDisplaced: array[0..4] of Byte = ($83, $EC, $0C, $53, $55);                // the same / то же самое
  MenuWindowDisplaced: array[0..9] of Byte = ($51, $33, $C0, $55, $66, $A1, $A6, $D5, $60, $00); // push ecx; xor eax,eax; push ebp; mov ax,[60D5A6]

  // Calls: pause menu, hints/subtitles (3 calls replaced by one wrapper), hint text box
  // Вызовы: меню паузы, подсказки/субтитры (3 вызова заменены одной обёрткой), текстбокс подсказок
  MenuPauseCallVA = $45599C;
  MenuPauseVA = $440AF0;
  MenuSubtitleCallVA = $4556EF;
  MenuSubtitleCalls: array[0..2] of Integer = ($48AA90, $48AE30, $458A40);
  MenuSubtitleNopVA = $4556F4;            // the two other calls are removed / два других вызова убираются
  MenuSubtitleNopCount = 10;
  MenuTextBoxCallVA = $4E262E;            // call of the script text box constructor / вызов конструктора текстбокса скриптов
  MenuTextBoxBuilderVA = $40D650;

  // Frame math / Математика рамок
  MenuFrameTrimWrapped = 3;               // right sprite shift (in real px) of the frames drawn with the shift M / сдвиг правого спрайта (в реальных px) у рамок, рисуемых со сдвигом M
  MenuFrameTrimPlain = 2;                 // the same for the frames without the shift, in logical units / то же для рамок без сдвига, в логических единицах
  // Wide screens need a bit more (checked at 21:9 and 32:9; 16:9 is perfect without it)
  // Широким экранам нужно чуть больше (проверено на 21:9 и 32:9; на 16:9 и так идеально)
  MenuFrameExtraMinWidth = 800;           // from this MenuLogicalWidth (a bit wider than 16:9 = 683) / начиная с такой MenuLogicalWidth (чуть шире 16:9 = 683)
  MenuFrameExtraMaxWidth = 1100;          // up to this one (21:9 = 914..971; 32:9 = 1365 needs no extra) / до такой (21:9 = 914..971; 32:9 = 1365 не требует)
  // The text is not drawn beyond about x = 640 of the logical grid, so the pause menu content shift is limited
  // (the frame still spans the whole screen, the content is a bit left of the center on very wide screens)
  // Текст не рисуется правее примерно x = 640 логической сетки, поэтому сдвиг содержимого меню паузы ограничен
  // (рамка по-прежнему на весь экран, содержимое на очень широких экранах чуть левее центра)
  MenuMaxContentShift = 250;
  MenuFrameExtraTrimStretched = 1;        // frames drawn stretched (main menu, options): right sprite is pulled left by this many units / рамки, растянутые на весь экран (главное меню, настройки): правый спрайт влево на столько единиц
  MenuFrameLeftMinWidth = 1100;           // from this MenuLogicalWidth (32:9 = 1365) / начиная с такой MenuLogicalWidth (32:9 = 1365)
  MenuFrameLeftTrimPause = 1;             // pause frame: left sprite is moved right by this many units / рамка паузы: левый спрайт вправо на столько единиц
  MenuTextBoxPadding = 5;                 // the hint text box is a bit wider / текстбокс подсказок чуть шире
var
  Ini: TIniFile;

  DoneMsg, ResolutionStr: string;

  VoiceContext: array[0..2] of Byte;

  ColorDepthByte, BrightnessByte, NewByte: Byte;
  FileStream: TFileStream;

  ResolutionWidth, ResolutionHeight: Integer;

  AspectRatioBytes: array[0..3] of Byte;
  AspectRatioFloat: Single;

  CullK: Integer;
  CullPatch: array[0..6] of Byte; //, CullRead

  ProjXPatch: array[0..6] of Byte;

  HudScale, HudAspectRatio: Single;

  HudCave: array[0..65] of Byte;
  PanelCallCurrent: array[0..4] of Byte;

  AutoLoadCaveBuf: array[0..222] of Byte;
  AutoLoadPollsValue: Integer;

  // Logical screen size and HUD shifts / Логический размер экрана и сдвиги худа
  LogicalWidth, LogicalHeight, HudShiftY, HudAreaWidth, HudMarginX: Integer;
  PanelCallRel32, CurrentRel32, CaveCallRel32: Integer;
  CompassShiftX, CompassShiftY, TimerShiftX, BossShiftX, ApproachShiftX, SubwayShiftX, ChaseStretchX: Integer;
  SubwayStretchX, SubwayMulK, SubwayMulN, SubwayMulBest, SubwayMulTarget: Integer;

  // Menu fix / Исправление меню
  CaveBuf: array[0..127] of Byte; // the cave being assembled (the biggest one is 66 bytes) / собираемая пещера (самая большая - 66 байт)
  CaveStartVA, CaveLength: Integer;

  // ---------- Helpers / Вспомогательные процедуры ----------

  // Write a 32-bit value at a file offset / Записать 32-битное значение по смещению в файле
  procedure WriteInt32(FileOffset, Value: Integer);
  begin
    FileStream.Seek(FileOffset, soBeginning);
    FileStream.WriteBuffer(Value, 4);
  end;

  // Write a table of 32-bit constants: original value + shift / Записать таблицу констант: исходное значение + сдвиг
  procedure WriteInt32Table(const FileOffsets, OriginalValues: array of Integer; Shift: Integer);
  var
    k: Integer;
  begin
    for k:=0 to High(FileOffsets) do
      WriteInt32(FileOffsets[k], OriginalValues[k] + Shift);
  end;

  // Write one byte / Записать один байт
  procedure WriteByte(FileOffset: Integer; Value: Byte);
  begin
    FileStream.Seek(FileOffset, soBeginning);
    FileStream.WriteBuffer(Value, 1);
  end;

  // Write raw bytes / Записать байты как есть
  procedure WriteBytes(FileOffset: Integer; const Data: array of Byte);
  begin
    FileStream.Seek(FileOffset, soBeginning);
    FileStream.WriteBuffer(Data[0], Length(Data));
  end;

  // imul reg, reg, imm8 (6B ModRM Imm) / умножение на 8-битную константу
  procedure WriteImul8(FileOffset: Integer; ModRM, Imm: Byte);
  var
    Code: array[0..2] of Byte;
  begin
    Code[0]:=$6B; Code[1]:=ModRM; Code[2]:=Imm;
    WriteBytes(FileOffset, Code);
  end;

  // Replace the "progress * 307" code with imul eax, eax, Multiplier + NOPs
  // Заменить код "progress * 307" на imul eax, eax, Multiplier + NOP
  procedure WriteChaseMultiplier(FileOffset, CodeLength: Integer; KeepPushEbx: Boolean; Multiplier: Integer);
  var
    Code: array[0..15] of Byte;
    p: Integer;
  begin
    FillChar(Code, SizeOf(Code), $90); // NOP
    p:=0;
    if KeepPushEbx then begin Code[0]:=$53; p:=1; end; // push ebx
    Code[p]:=$69; Code[p + 1]:=$C0; // imul eax, eax, imm32
    Move(Multiplier, Code[p + 2], 4);
    FileStream.Seek(FileOffset, soBeginning);
    FileStream.WriteBuffer(Code, CodeLength);
  end;

  // Stub: add dword ptr [esp+ArgOffset], Margin; jmp TargetVA / Заглушка: сдвиг аргумента X и переход на функцию
  procedure WriteMarginStub(StubIndex: Integer; ArgOffset: Byte; TargetVA, Margin: Integer);
  var
    Code: array[0..12] of Byte;
    StubVA, Rel: Integer;
  begin
    StubVA:=HudStubCaveVA + StubIndex * HudStubSize;
    Code[0]:=$81; Code[1]:=$44; Code[2]:=$24; Code[3]:=ArgOffset; // add dword ptr [esp+ArgOffset], imm32
    Move(Margin, Code[4], 4);
    Code[8]:=$E9; // jmp TargetVA
    Rel:=TargetVA - (StubVA + 13);
    Move(Rel, Code[9], 4);
    WriteBytes(HudStubCaveFileOffset + StubIndex * HudStubSize, Code);
  end;

  // Redirect the "call" at CallVA to the stub / Перенаправить "call" по адресу CallVA на заглушку
  procedure RedirectCall(CallVA, StubIndex: Integer);
  begin
    WriteInt32(CallVA - $400000 + 1, (HudStubCaveVA + StubIndex * HudStubSize) - (CallVA + 5));
  end;

  // Ultrawide: shift the left HUD group by the margin / Ультраширокий: сдвиг левой группы HUD на отступ
  procedure ApplyLeftHudMargin;
  var
    k: Integer;
  begin
    WriteMarginStub(HudStubSprite, 4, BuilderSpriteVA, HudMarginX); // X - first argument / первый аргумент
    WriteMarginStub(HudStubBar, 8, BuilderBarVA, HudMarginX);       // X - second argument / второй аргумент
    WriteMarginStub(HudStubLine, 8, BuilderLineVA, HudMarginX);
    WriteMarginStub(HudStubText, 4, TextOutVA, HudMarginX);
    for k:=0 to High(LeftSpriteCalls) do RedirectCall(LeftSpriteCalls[k], HudStubSprite);
    for k:=0 to High(LeftBarCalls) do RedirectCall(LeftBarCalls[k], HudStubBar);
    for k:=0 to High(LeftLineCalls) do RedirectCall(LeftLineCalls[k], HudStubLine);
    RedirectCall(LeftTextCall, HudStubText);
  end;

  // ---------- Common part of Classic and Improved / Общая часть Classic и Improved ----------
  procedure ApplyHudCommon;
  var
    k: Integer;
  begin
    // Wrapper around Panel_Display: logical screen size and Y shift
    // Обёртка вокруг Panel_Display: логический размер экрана и сдвиг по Y
    PanelCallRel32:=HudCaveVA - (PanelCallVA + 5);

    // The call must be original or already ours / вызов должен быть исходным или уже нашим
    FileStream.Seek(PanelCallFileOffset, soBeginning);
    FileStream.ReadBuffer(PanelCallCurrent, SizeOf(PanelCallCurrent));
    Move(PanelCallCurrent[1], CurrentRel32, 4);
    //if (PanelCallCurrent[0] <> $E8) or ((CurrentRel32 <> PanelCallOrigRel32) and (CurrentRel32 <> PanelCallRel32)) then Exit;

    // The place must be empty or already ours / место должно быть пустым или уже нашим
    FileStream.Seek(HudCaveFileOffset, soBeginning);
    //FileStream.ReadBuffer(HudCave, SizeOf(HudCave));
    //if (HudCave[0] <> 0) and (HudCave[0] <> $C7) then Exit;

    Move(HudCaveTemplate, HudCave, SizeOf(HudCave));
    Move(LogicalWidth, HudCave[CavePosLogicalWidth], 4);
    Move(LogicalHeight, HudCave[CavePosLogicalHeight], 4);
    Move(HudShiftY, HudCave[CavePosShiftYAdd], 4);
    CaveCallRel32:=PanelDisplayVA - (HudCaveVA + CaveCallEndOffset);
    Move(CaveCallRel32, HudCave[CavePosCallRel32], 4);
    Move(HudShiftY, HudCave[CavePosShiftYSub], 4);

    FileStream.Seek(HudCaveFileOffset, soBeginning);
    FileStream.WriteBuffer(HudCave, SizeOf(HudCave));
    WriteInt32(PanelCallFileOffset + 1, PanelCallRel32);

    // Compass: move to the bottom right corner by the growth of the logical screen
    // Компас: сдвиг в правый нижний угол на прирост логического экрана
    CompassShiftX:=(HudAreaWidth - 512) + HudMarginX;
    // + HudShiftY, because the compass calculates Y with a minus (D7 - [60F76C]) and the common shift raises it
    // + HudShiftY, т.к. компас считает Y с минусом (D7 - [60F76C]) и общий сдвиг его поднимает
    CompassShiftY:=(LogicalHeight - 240) + HudShiftY;
    WriteInt32Table(CompassXOffsets, CompassXOriginal, CompassShiftX);
    WriteInt32Table(CompassYOffsets, CompassYOriginal, CompassShiftY);

    // Timer: center of the logical screen / Таймер: по центру логического экрана
    TimerShiftX:=(HudAreaWidth - 512) div 2 + HudMarginX;
    WriteInt32Table(TimerXOffsets, TimerXOriginal, TimerShiftX);

    // Text a bit lower / Текст чуть ниже
    for k:=0 to High(TextYOffsets) do begin
      NewByte:=TextYOriginal[k] + TextExtraDownShift;
      FileStream.Seek(TextYOffsets[k], soBeginning);
      FileStream.WriteBuffer(NewByte, 1);
    end;

    // Boss HUD: shift to the right (BossAnchor) / HUD боссов: сдвиг вправо (BossAnchor)
    BossShiftX:=Round((HudAreaWidth - 512) * BossAnchor) + HudMarginX;
    WriteInt32Table(BossXOffsets, BossXOriginal, BossShiftX);

    // Escape from Doctor Octopus: vertical radiation bar to the right edge
    // Побег от Доктора Осьминога: вертикальная полоска радиации - к правому краю
    WriteInt32Table(EscapeRadiationXOffsets, EscapeRadiationXOriginal, BossShiftX);

    // Subway: Y as in the original (X depends on the mode, see below)
    // Метро: низ - как в оригинале (X зависит от режима, см. ниже)
    WriteInt32Table(SubwayYOffsets, SubwayYOriginal, CompassShiftY); // same Y shift as the compass / тот же сдвиг по Y, что у компаса

    // Reticle: not stretched on wide screens / Прицел: не растягивается на широких экранах
    for k:=0 to High(ReticleXMulFileOffsets) do
      WriteInt32(ReticleXMulFileOffsets[k], Round(ReticleXMulOriginal * AspectRatioFloat));

    // Ultrawide: the left group goes to the HUD area / Ультраширокий: левая группа уходит в область HUD
    if HudMarginX > 0 then ApplyLeftHudMargin;
  end;

  // ---------- Classic interface: bars run to the screen end, proportions fixed ----------
  // ---------- Classic interface: полоски до конца экрана, пропорции исправлены ----------
  procedure ApplyClassicInterface;
  var
    k, MulKCandidate: Integer; // loop variables must be local / переменные цикла должны быть локальными
  begin
    // Left parts go to the HUD area (zero margin at 16:9 and narrower) / Левые части уходят в область HUD (на 16:9 и уже отступ нулевой)
    WriteInt32Table(ApproachXOffsets, ApproachXOriginal, HudMarginX);
    WriteInt32Table(VenomChaseXOffsets, VenomChaseXOriginal, HudMarginX);
    WriteInt32Table(EscapeBarXOffsets, EscapeBarXOriginal, HudMarginX);

    // Approach bar: stretch to the right, length is a multiple of the segment step
    // Полоска "подхода": тянем вправо, длина кратна шагу сегмента
    ApproachShiftX:=ApproachSegmentStep * Round((HudAreaWidth - 512) / ApproachSegmentStep);
    WriteInt32Table(ApproachClassicXOffsets, ApproachClassicXOriginal, ApproachShiftX + HudMarginX);

    // Moving head step is fitted to the new bar length / ход подвижной головы подгоняем под новую длину полоски
    for k:=0 to High(ApproachHeadStepOffsets) do
      WriteInt32(ApproachHeadStepOffsets[k],
        Round(ApproachHeadStepA[k] / (ApproachHeadStepA[k] / ApproachHeadStepB[k] + ApproachShiftX)));

    // Chase bars (Venom, escape from Doc Ock): stretch the right part, loop end and the moving head travel
    // Полоски погони (Веном, побег от Дока Ока): тянем правую часть, конец цикла и путь подвижной головы
    ChaseStretchX:=ChaseSegmentStep * Round((HudAreaWidth - 512) / ChaseSegmentStep);
    WriteInt32Table(VenomChaseClassicXOffsets, ChaseBarClassicXOriginal, ChaseStretchX + HudMarginX);
    WriteInt32Table(EscapeBarClassicXOffsets, ChaseBarClassicXOriginal, ChaseStretchX + HudMarginX);
    WriteInt32(VenomLoopEndFileOffset, ChaseLoopEndOriginal + ChaseStretchX);
    WriteInt32(EscapeLoopEndFileOffset, ChaseLoopEndOriginal + ChaseStretchX);
    WriteChaseMultiplier(VenomMoverFileOffset, Length(VenomMoverOriginal), True, ChaseHeadTravel + ChaseStretchX);
    WriteChaseMultiplier(EscapeMoverFileOffset, Length(EscapeMoverOriginal), False, ChaseHeadTravel + ChaseStretchX);

    // Subway: the bar stays at the left and is stretched to the right (multiple of the wagon step)
    // Метро: полоска остаётся слева и растягивается вправо (кратно шагу вагона)
    SubwayStretchX:=SubwayWagonStep * Round((HudAreaWidth - 512) / SubwayWagonStep);
    WriteInt32Table(SubwayNudgeOffsets, SubwayNudgeOriginal, HudMarginX);
    WriteInt32(SubwayNudgeOffsets[2], SubwayNudgeOriginal[2] + SubwayStretchX + HudMarginX); // right cap / правая заглушка
    WriteInt32(SubwayLoopEndFileOffset, SubwayLoopEndOriginal + SubwayStretchX); // more wagons / больше вагонов

    // The train must travel the whole new length: M = (1 + 2 * K) * N closest to the target
    // Поезд должен пройти всю новую длину: подбираем M = (1 + 2 * K) * N, ближайшее к нужному
    SubwayMulTarget:=Round((SubwayTrainTravel + SubwayStretchX) * 4096 / SubwayMaxProgress);
    SubwayMulBest:=MaxInt;
    SubwayMulK:=5; SubwayMulN:=16;
    for MulKCandidate:=0 to 127 do // K
      for k:=1 to 127 do // N
        if Abs((1 + 2 * MulKCandidate) * k - SubwayMulTarget) < SubwayMulBest then begin
          SubwayMulBest:=Abs((1 + 2 * MulKCandidate) * k - SubwayMulTarget);
          SubwayMulK:=MulKCandidate;
          SubwayMulN:=k;
        end;
    WriteImul8(SubwayMulKFileOffset, $C8, SubwayMulK); // imul ecx, eax, K
    WriteImul8(SubwayMulNFileOffset, $D2, SubwayMulN); // imul edx, edx, N
    // Start position: the train is at the left end at max progress / стартовая позиция: поезд у левого края при максимальном прогрессе
    WriteInt32(SubwayTrainStartFileOffset, SubwayMaxProgress * (1 + 2 * SubwayMulK) * SubwayMulN + (HudMarginX shl 12));
  end;

  // ---------- Improved interface: bars in the center, length as at 4:3 ----------
  // ---------- Improved interface: полоски по центру, длина как на 4:3 ----------
  procedure ApplyImprovedInterface;
  begin
    // "Approach" and chase bars: screen center, length and proportions as at 4:3 (zero shift at 4:3)
    // Полоски "подхода" и погони: по центру экрана, длина и пропорции как на 4:3 (на 4:3 сдвиг нулевой)
    ApproachShiftX:=Round(HudAreaWidth / 2 - ApproachMiddleX);
    if ApproachShiftX < 0 then ApproachShiftX:=0;
    ApproachShiftX:=ApproachShiftX + HudMarginX; // center of the HUD area / центр области HUD

    WriteInt32Table(ApproachXOffsets, ApproachXOriginal, ApproachShiftX);
    WriteInt32Table(ApproachHeadStepOffsets, ApproachHeadStepB, 0); // original moving head step / исходный ход подвижной головы
    WriteInt32Table(VenomChaseXOffsets, VenomChaseXOriginal, ApproachShiftX);
    WriteInt32Table(EscapeBarXOffsets, EscapeBarXOriginal, ApproachShiftX); // escape from Doc Ock / побег от Дока Ока

    // Subway: bar in the center, original length and train speed
    // Метро: полоска по центру, длина и скорость поезда как в оригинале
    SubwayShiftX:=(HudAreaWidth - 512) div 2 + HudMarginX;
    WriteInt32(SubwayTrainStartFileOffset, SubwayTrainStartOriginal + (SubwayShiftX shl 12));
    WriteInt32(SubwayLoopEndFileOffset, SubwayLoopEndOriginal);
    WriteInt32Table(SubwayNudgeOffsets, SubwayNudgeOriginal, SubwayShiftX);
    WriteBytes(SubwayMulKFileOffset, SubwayMulKOriginal);
    WriteBytes(SubwayMulNFileOffset, SubwayMulNOriginal);
  end;

  // ---------- Menu fix: cave assembler / Исправление меню: мини-ассемблер пещер ----------
  // Start a new cave or patch at StartVA / Начать новую пещеру или патч по адресу StartVA
  procedure CaveBegin(StartVA: Integer);
  begin
    CaveStartVA:=StartVA;
    CaveLength:=0;
  end;

  // Append bytes / Добавить байты
  procedure CaveBytes(const Data: array of Byte);
  var
    k: Integer;
  begin
    for k:=0 to High(Data) do begin
      CaveBuf[CaveLength]:=Data[k];
      Inc(CaveLength);
    end;
  end;

  // Append a 32-bit value / Добавить 32-битное значение
  procedure CaveInt32(Value: Integer);
  begin
    Move(Value, CaveBuf[CaveLength], 4);
    Inc(CaveLength, 4);
  end;

  // Append jmp ($E9) or call ($E8) to TargetVA, rel32 is calculated from the current position
  // Добавить jmp ($E9) или call ($E8) на TargetVA, rel32 считается от текущей позиции
  procedure CaveBranch(Opcode: Byte; TargetVA: Integer);
  begin
    CaveBytes([Opcode]);
    CaveInt32(TargetVA - (CaveStartVA + CaveLength + 4));
  end;

  // Write the assembled bytes into the file / Записать собранные байты в файл
  procedure CaveEnd;
  begin
    FileStream.Seek(CaveStartVA - $400000, soBeginning);
    FileStream.WriteBuffer(CaveBuf, CaveLength);
  end;

  // Replace the code at SiteVA with "jmp TargetVA" + NOPs up to Size bytes / Заменить код по SiteVA на "jmp TargetVA" + NOP до Size байт
  procedure HookJump(SiteVA, TargetVA, Size: Integer);
  begin
    CaveBegin(SiteVA);
    CaveBranch($E9, TargetVA);
    while CaveLength < Size do CaveBytes([$90]); // NOP
    CaveEnd;
  end;

  // Redirect the "call" at SiteVA / Перенаправить "call" по адресу SiteVA
  procedure HookCall(SiteVA, TargetVA: Integer);
  begin
    CaveBegin(SiteVA);
    CaveBranch($E8, TargetVA);
    CaveEnd;
  end;

  // Invisibility with a gamepad - Spidey Unlimited costume (aim + punch) / Невидимость на геймпаде - костюм Спайди без границ (прицел + удар)
  procedure ApplyPadInvisibilityFix;
  var
    InvisCurrent: array[0..10] of Byte;
  begin
    FileStream.Seek(InvisSiteVA - $400000, soBeginning);
    FileStream.ReadBuffer(InvisCurrent, SizeOf(InvisCurrent));
    if not CompareMem(@InvisCurrent, @InvisSiteOrig, SizeOf(InvisSiteOrig)) then Exit; // only the original exe / только оригинальный exe

    // Cave 1: keyboard check, ebp = address of the key slot / проверка клавиши, ebp = адрес ячейки клавиши
    CaveBegin(InvisCave1VA);
    CaveBytes([$6A, $01, $FF, $75, $00]);           // push 1 / push [ebp]
    CaveBranch($E8, KeyEdgeCheckVA);                // call key check
    CaveBranch($E9, InvisCave2VA);
    CaveEnd;
    // Cave 2: pressed -> return, otherwise go on to the pad / нажата -> выход, иначе проверяем геймпад
    CaveBegin(InvisCave2VA);
    CaveBytes([$83, $C4, $08, $85, $C0, $74, $01, $C3]); // add esp,8 / test eax,eax / je +1 / ret
    CaveBranch($E9, InvisCave3VA);
    CaveEnd;
    // Cave 3: the pad button of the same action is at [ebp+$70] / кнопка геймпада того же действия - [ebp+$70]
    CaveBegin(InvisCave3VA);
    CaveBytes([$6A, $01, $FF, $75, $70]);           // push 1 / push [ebp+70h]
    CaveBranch($E8, PadEdgeCheckVA);
    CaveBytes([$83, $C4, $08, $C3]);                // add esp,8 / ret
    CaveEnd;

    // The site: costume 5 and both actions pressed (keyboard or pad) -> go on, otherwise to the "no" branch
    // Место: костюм 5 и оба действия нажаты (клавиатура или геймпад) -> дальше, иначе в ветку «нет»
    CaveBegin(InvisSiteVA);
    CaveBytes([$C6, $86, $E4, $0A, $00, $00, $01]); // mov byte ptr [esi+0AE4h], 1 (the original instruction / исходная инструкция)
    CaveBytes([$33, $ED]);                          // xor ebp, ebp
    CaveBytes([$83, $3D]); CaveInt32(InvisCostumeVA); CaveBytes([InvisCostumeId]); // cmp dword ptr [costume], 5
    CaveBytes([$0F, $85]); CaveInt32(InvisNoVA - (CaveStartVA + CaveLength + 4));  // jne no
    CaveBytes([$BD]); CaveInt32(InvisAttackKeySlotVA); // mov ebp, attack slot
    CaveBranch($E8, InvisCave1VA);
    CaveBytes([$85, $C0, $74, 21]);                 // test eax,eax / je Z
    CaveBytes([$BD]); CaveInt32(InvisAimKeySlotVA);    // mov ebp, aim slot
    CaveBranch($E8, InvisCave1VA);
    CaveBytes([$85, $C0, $74, 7]);                  // test eax,eax / je Z
    CaveBytes([$33, $ED]);                          // xor ebp, ebp
    CaveBranch($E9, InvisSiteEndVA);                // both pressed / оба нажаты
    CaveBytes([$33, $ED]);                          // Z: xor ebp, ebp
    CaveBranch($E9, InvisNoVA);
    while CaveLength < InvisSiteEndVA - InvisSiteVA do CaveBytes([$90]);
    CaveEnd;
  end;

  // Stub of a 2D builder: "add [esp+ArgOffset], M" (shift X), the replaced instructions, jmp back; then the hook
  // Заглушка 2D-построителя: "add [esp+ArgOffset], M" (сдвиг X), замещённые инструкции, jmp назад; затем хук
  procedure WriteMenuStub(StubVA, SiteVA: Integer; ArgOffset: Byte; const Displaced: array of Byte);
  begin
    CaveBegin(StubVA);
    CaveBytes([$A1]); CaveInt32(MenuShiftVarVA);   // mov eax, [M]
    CaveBytes([$01, $44, $24, ArgOffset]);          // add dword ptr [esp+ArgOffset], eax
    CaveBytes(Displaced);                           // the instructions replaced by the hook / инструкции, замещённые хуком
    CaveBranch($E9, SiteVA + Length(Displaced));    // back to the builder / назад в построитель
    CaveEnd;
    HookJump(SiteVA, StubVA, Length(Displaced));    // the hook goes after its cave / хук - после своей пещеры
  end;

  // ---------- Menu fix / Исправление меню ----------
  procedure ApplyMenuFix;
  var
    k, MenuLogicalWidth, MenuShiftX, MenuContentShift, FrameShiftX, TextBoxScale, FrameTrimValue: Integer;
    FrameTrim, FrameLeftTrim, FrameExtraTrim, FrameTotalTrim: Byte;
    MenuSiteCurrent: array[0..4] of Byte;
  begin
    // Only the original exe, and only for screens wider than 4:3 / Только оригинальный exe и только для экранов шире 4:3
    FileStream.Seek(MenuSiteCheckFileOffset, soBeginning);
    FileStream.ReadBuffer(MenuSiteCurrent, SizeOf(MenuSiteCurrent));
    if not CompareMem(@MenuSiteCurrent, @MenuSiteCheckOrig, SizeOf(MenuSiteCheckOrig)) then Exit;

    MenuLogicalWidth:=Round(512 / AspectRatioFloat);
    if MenuLogicalWidth <= 512 then Exit; // 4:3 and narrower: nothing to fix / 4:3 и уже: исправлять нечего
    MenuShiftX:=(MenuLogicalWidth - 512) div 2;     // full shift: the frame spans the whole screen / полный сдвиг: рамка на весь экран
    MenuContentShift:=MenuShiftX;                    // the content shift is limited / сдвиг содержимого ограничен
    if MenuContentShift > MenuMaxContentShift then MenuContentShift:=MenuMaxContentShift;
    TextBoxScale:=Round(256 * 512 / MenuLogicalWidth);
    FrameTrimValue:=Round(MenuFrameTrimWrapped * MenuLogicalWidth / ResolutionWidth);
    if FrameTrimValue < 1 then FrameTrimValue:=1;
    FrameTrim:=FrameTrimValue;
    FrameLeftTrim:=0;
    if MenuLogicalWidth > MenuFrameLeftMinWidth then FrameLeftTrim:=MenuFrameLeftTrimPause;
    FrameTotalTrim:=FrameTrim + FrameLeftTrim;
    // The builders add the limited shift to X, the frame needs the full one: the difference is added here, + the left sprite trim
    // Построители добавляют к X ограниченный сдвиг, а рамке нужен полный: разницу добавляем здесь, + подгонка левого спрайта
    FrameShiftX:=(MenuShiftX - MenuContentShift) + FrameLeftTrim;
    FrameExtraTrim:=0;
    if (MenuLogicalWidth > MenuFrameExtraMinWidth) and (MenuLogicalWidth <= MenuFrameExtraMaxWidth) then FrameExtraTrim:=MenuFrameExtraTrimStretched;

    // .text must be writable: the variable M is in the cave / .text должна быть записываемой: переменная M в пещере
    WriteByte(MenuTextSectionFlagsFileOffset, MenuTextSectionFlagsValue);

    // 2D builders: text, sprite, sprite 2, bar, line / 2D-построители: текст, спрайт, спрайт 2, полоска, линия
    WriteMenuStub(MenuTextStubCaveVA, TextOutVA, 4, MenuTextOutDisplaced);
    WriteMenuStub(MenuSpriteStubCaveVA, BuilderSpriteVA, 4, MenuSpriteDisplaced);
    WriteMenuStub(MenuSprite2StubCaveVA, MenuBuilderSprite2VA, 4, MenuSprite2Displaced);
    WriteMenuStub(MenuBarStubCaveVA, BuilderBarVA, 8, MenuBarDisplaced);
    WriteMenuStub(MenuLineStubCaveVA, BuilderLineVA, 8, MenuLineDisplaced);

    // Frame (X is the argument at [esp+10]): the stub is split in two parts to fit into the gaps
    // Рамка (X - аргумент [esp+10]): заглушка разделена на две части, чтобы уместиться в зазоры
    CaveBegin(MenuFrameHeadCaveVA);
    CaveBytes([$A1]); CaveInt32(MenuShiftVarVA);   // mov eax, [M]
    CaveBytes([$01, $44, $24, $10]);                // add dword ptr [esp+10], eax
    CaveBranch($E9, MenuFrameTailCaveVA);
    CaveEnd;
    CaveBegin(MenuFrameTailCaveVA);
    CaveBytes(MenuFrameDisplaced);
    CaveBranch($E9, MenuBuilderFrameVA + Length(MenuFrameDisplaced));
    CaveEnd;
    HookJump(MenuBuilderFrameVA, MenuFrameHeadCaveVA, Length(MenuFrameDisplaced));

    // Window (0x47A700): with the shift M the window is centered, its right sprite is pulled left and the left one moved right;
    // without M - by 2 units, and the stretched windows (logical width 512) a bit more, see the cave below
    // Окно (0x47A700): при сдвиге M окно центрируется, правый спрайт подтягивается влево, а левый сдвигается вправо;
    // без M - на 2 единицы, а растянутые окна (логическая ширина 512) - чуть больше, см. пещеру ниже
    CaveBegin(MenuWindowHookCaveVA);
    CaveBytes([$A1]); CaveInt32(MenuShiftVarVA);   // mov eax, [M]
    CaveBytes([$85, $C0, $74, $23]);                // test eax, eax; je plain / je без сдвига
    CaveBytes([$8B, $4C, $24, $0C]);                // mov ecx, [esp+0C]          ; width / ширина
    CaveBytes([$69, $C9]); CaveInt32(MenuShiftX);   // imul ecx, ecx, MenuShiftX  ; the full shift, not the limited [M] / полный сдвиг, а не ограниченный [M]
    CaveBytes([$C1, $F9, $08]);                     // sar ecx, 8                 ; t = width * MenuShiftX / 256
    CaveBytes([$89, $C8, $D1, $F8]);                // mov eax, ecx; sar eax, 1    ; eax = t / 2
    CaveBytes([$2D]); CaveInt32(FrameShiftX);       // sub eax, FrameShiftX
    CaveBytes([$29, $44, $24, $04]);                // sub [esp+04], eax          ; x += FrameShiftX - t / 2
    CaveBytes([$83, $E9, FrameTotalTrim]);              // sub ecx, FrameTrim + FrameLeftTrim
    CaveBytes([$01, $4C, $24, $0C]);                // add [esp+0C], ecx          ; width += t - FrameTrim - FrameLeftTrim
    CaveBytes([$EB, $0A]);                          // jmp common / jmp общий
    CaveBytes([$83, $6C, $24, $0C, MenuFrameTrimPlain]); // plain: sub [esp+0C], 2
    CaveBranch($E8, MenuPlainTrimCaveVA);           // call the stretched-window correction / поправка для растянутых окон
    CaveBytes(MenuWindowDisplaced);
    CaveBranch($E9, MenuWindowVA + Length(MenuWindowDisplaced));
    CaveEnd;
    // Stretched windows (logical width = 512): extra trim. The return address is on the stack, so the width is at [esp+10]
    // Растянутые окна (логическая ширина = 512): дополнительная подгонка. Адрес возврата на стеке, поэтому ширина в [esp+10]
    CaveBegin(MenuPlainTrimCaveVA);
    CaveBytes([$66, $81, $3D]); CaveInt32(LogicalWidthVA); CaveBytes([$00, $02]); // cmp word ptr [logW], 512
    CaveBytes([$75, $05]);                          // jne skip
    CaveBytes([$83, $6C, $24, $10, FrameExtraTrim]); // sub [esp+10], FrameExtraTrim
    CaveBytes([$C3]);                               // ret
    CaveEnd;
    HookJump(MenuWindowVA, MenuWindowHookCaveVA, Length(MenuWindowDisplaced));

    // Hint text box: x and width * K / 256, width + padding / Текстбокс подсказок: x и ширина * K / 256, ширина + запас
    CaveBegin(MenuTextBoxHookCaveVA);
    CaveBytes([$69, $44, $24, $04]); CaveInt32(TextBoxScale);           // imul eax,[esp+04],K
    CaveBytes([$C1, $F8, $08, $89, $44, $24, $04]);                     // sar eax,8; mov [esp+04],eax
    CaveBytes([$69, $44, $24, $0C]); CaveInt32(TextBoxScale);           // imul eax,[esp+0C],K
    CaveBytes([$C1, $F8, $08, $83, $C0, MenuTextBoxPadding]);           // sar eax,8; add eax,padding
    CaveBytes([$89, $44, $24, $0C]);                                    // mov [esp+0C],eax
    CaveBranch($E9, MenuTextBoxBuilderVA);
    CaveEnd;
    HookCall(MenuTextBoxCallVA, MenuTextBoxHookCaveVA);

    // Pause menu: M and the wide grid only for the time of the menu / Меню паузы: M и широкая сетка только на время меню
    CaveBegin(MenuPauseWrapCaveVA);
    CaveBytes([$C7, $05]); CaveInt32(MenuShiftVarVA); CaveInt32(MenuContentShift);    // mov [M], MenuContentShift
    CaveBytes([$C7, $05]); CaveInt32(LogicalWidthVA); CaveInt32(MenuLogicalWidth);    // mov [logW], MenuLogicalWidth
    CaveBranch($E8, MenuPauseVA);                                                      // call pause menu / меню паузы
    CaveBytes([$C7, $05]); CaveInt32(MenuShiftVarVA); CaveInt32(0);                   // mov [M], 0
    CaveBytes([$C7, $05]); CaveInt32(LogicalWidthVA); CaveInt32(512);                 // mov [logW], 512
    CaveBytes([$C3]);                                                                  // ret
    CaveEnd;
    HookCall(MenuPauseCallVA, MenuPauseWrapCaveVA);

    // Hints/subtitles: the three calls on the wide grid (M = 0) / Подсказки/субтитры: три вызова на широкой сетке (M = 0)
    CaveBegin(MenuSubtitleWrapCaveVA);
    CaveBytes([$C7, $05]); CaveInt32(LogicalWidthVA); CaveInt32(MenuLogicalWidth);    // mov [logW], MenuLogicalWidth
    for k:=0 to High(MenuSubtitleCalls) do CaveBranch($E8, MenuSubtitleCalls[k]);
    CaveBytes([$C7, $05]); CaveInt32(LogicalWidthVA); CaveInt32(512);                 // mov [logW], 512
    CaveBytes([$C3]);                                                                  // ret
    CaveEnd;
    HookCall(MenuSubtitleCallVA, MenuSubtitleWrapCaveVA);
    CaveBegin(MenuSubtitleNopVA);
    while CaveLength < MenuSubtitleNopCount do CaveBytes([$90]);                      // NOP the other two calls / убрать два других вызова
    CaveEnd;
  end;

  // Write a byte into Spidey.cfg / Записать байт в Spidey.cfg
  procedure WriteCfgByte(Position: Integer; Value: Byte);
  begin
    FileStream.Seek(Position, soBeginning);
    FileStream.WriteBuffer(Value, SizeOf(Byte));
  end;

begin
  if not FileExists(GameExePath) then begin Application.MessageBox(PChar(IDS_GAME_NOT_FOUND), PChar(Caption), MB_ICONWARNING); Exit; end;

  // Original exe backup / Бекап оригинального exe
  if not FileExists(GameExePath + '.bak') then
    CopyFile(PChar(GameExePath), PChar(GameExePath + '.bak'), False)

  // Using the original exe for patch / Используем оригинальный exe для патча
  else // FileExists
    CopyFile(PChar(GameExePath + '.bak'), PChar(GameExePath), False); // Rewrite / Перезапись

  // NOTE: the copy destination was 'Additionally\Spidey.cfg', but the file is checked and opened next to the exe
  // ВАЖНО: раньше копировалось в 'Additionally\Spidey.cfg', а проверяется и открывается файл рядом с exe
  if not FileExists(GameCfgPath) then
    CopyFile(PChar(AppPath + 'Additionally\SpideyDefault.cfg'), PChar(GameCfgPath), True);

  // Resolution / Разрешение
  ResolutionStr:=Trim(ResolutionsCB.Text);
  if Pos(' ', ResolutionStr) > 0 then ResolutionStr:=Copy(ResolutionStr, 1, Pos(' ', ResolutionStr) - 1);
  ResolutionWidth:=StrToInt(Copy(ResolutionStr, 1, Pos('x', ResolutionStr) - 1));
  ResolutionHeight:=StrToInt(Copy(ResolutionStr, Pos('x', ResolutionStr) + 1, Length(ResolutionStr) - Pos('x', ResolutionStr)));

  // Aspect ratio / Соотношение сторон
  if AspectRatiosCB.ItemIndex = 0 then // Auto - 0
    AspectRatioFloat:=(4.0 * ResolutionHeight) / (3.0 * ResolutionWidth)
  else
    AspectRatioFloat:=StrToFloat(Trim(Copy(AspectRatiosList.Strings[AspectRatiosCB.ItemIndex - 1], Pos('=', AspectRatiosList.Strings[AspectRatiosCB.ItemIndex - 1]) + 1, Length(AspectRatiosList.Strings[AspectRatiosCB.ItemIndex - 1]) )));

  // HUD scale: sqrt(X * Y) / X = sqrt(Y / X) = sqrt(AspectRatioFloat), where X = width / 640, Y = height / 480
  // Масштаб худа: sqrt(X * Y) / X = sqrt(Y / X) = sqrt(AspectRatioFloat), где X = ширина / 640, Y = высота / 480
  // 4:3 = 1.0, 16:10 = 0.91, 16:9 = 0.87, 21:9 = 0.76, 32:9 = 0.61
  // Ultrawide: the HUD is laid out as for 16:9 / Ультраширокие: HUD раскладывается как для 16:9
  if AspectRatioFloat < HudMinAspect then HudAspectRatio:=HudMinAspect else HudAspectRatio:=AspectRatioFloat;
  HudScale:=Sqrt(HudAspectRatio);
  if AspectRatioFloat > 1 then HudScale:=1 / AspectRatioFloat; // 5:4: логическая ширина = 512 / for 5:4 the logical width = 512

  // Logical screen size (real aspect) and the HUD area (16:9 at most) with the side margin
  // Логический размер экрана (реальный аспект) и область HUD (не шире 16:9) с боковым отступом
  LogicalWidth:=Round(512 / (AspectRatioFloat * HudScale));
  LogicalHeight:=Round(240 / HudScale);
  HudAreaWidth:=Round(512 / (HudAspectRatio * HudScale));
  HudMarginX:=(LogicalWidth - HudAreaWidth) div 2;
  // How far to lower the HUD so the top margin stays the same / на сколько опустить худ, чтобы отступ сверху остался прежним
  HudShiftY:=Round(HudTopMargin * (1 / HudScale - 1));

  // Culling fix / Исправление отрезки полигонов
  CullK:=Round($1999 * AspectRatioFloat);
  CullPatch[0]:=$69; CullPatch[1]:=$ED;
  CullPatch[2]:=CullK and $FF; CullPatch[3]:=(CullK shr 8) and $FF;
  CullPatch[4]:=0; CullPatch[5]:=0; CullPatch[6]:=$90;

  // PS1 projection fix: imul edx, edx, CullK (69 D2 imm32) + NOP / Исправление PS1-проекции
  ProjXPatch[0]:=$69; ProjXPatch[1]:=$D2;
  Move(CullK, ProjXPatch[2], 4);
  ProjXPatch[6]:=$90;

  // float to bytes (little endian) / float в массив байтов (little endian)
  Move(AspectRatioFloat, AspectRatioBytes, SizeOf(AspectRatioBytes));

  FileStream:=TFileStream.Create(GameExePath, fmOpenReadWrite);
  try
    // HUD: Classic or Improved. Stretch (the third mode) patches nothing - the game's own HUD
    // HUD: Classic или Improved. Stretch (третий режим) ничего не патчит - родной худ игры
    if ClassicInterfaceRB.Checked or ImprovedInterfaceRB.Checked then begin
      ApplyHudCommon;
      if ClassicInterfaceRB.Checked then
        ApplyClassicInterface
      else
        ApplyImprovedInterface;
    end;

    // Menu fix: pause menu, hints/subtitles, frames / Исправление меню: пауза, подсказки/субтитры, рамки
    if MenuFixCB.Checked then
      ApplyMenuFix;

    // Culling / Отрезка полигонов // Optimization aspect ratio
    //FileStream.Seek(CullFileOffset, soBeginning);
    //FileStream.ReadBuffer(CullRead, SizeOf(CullRead));

    //if CompareMem(@CullRead, @CullOrig, SizeOf(CullRead)) or ((CullRead[0] = $69) and (CullRead[1] = $ED)) then begin // patch only the original or our patch / патчим только оригинал или уже наш патч
    FileStream.Seek(CullFileOffset, soBeginning);
    FileStream.WriteBuffer(CullPatch, SizeOf(CullPatch));
    //end;

    // PS1 projection (Venom tentacles, etc.) / PS1-проекция (тентакли Венома и др.)
    WriteBytes(ProjXFileOffset, ProjXPatch);

    // Aspect Ratio
    FileStream.Seek(AspectFileOffset, soBeginning);
    FileStream.WriteBuffer(AspectRatioBytes, SizeOf(AspectRatioBytes));

    // Music / Музыка: the voice slot is busy while the sound is PLAYING, not only while it is looped
    // слот голоса занят, пока звук играет (PLAYING), а не только пока он зациклен
    FileStream.Seek(VoiceFixFileOffset - 2, soBeginning);
    FileStream.ReadBuffer(VoiceContext, SizeOf(VoiceContext));
    if (VoiceContext[0] = $83) and (VoiceContext[1] = $E0) and ((VoiceContext[2] = $04) or (VoiceContext[2] = $01)) then begin
      if SoundFixCB.Checked then NewByte:=$01 else NewByte:=$04; // 01 - fix / исправление, 04 - original / оригинал
      FileStream.Seek(VoiceFixFileOffset, soBeginning);
      FileStream.WriteBuffer(NewByte, 1);
    end;

    // JFix gamepad confirm button / Исправить кнопку подтверждения на геймпаде
    if FixControllerButtonsCB.Checked then begin
      WriteBytes(JoyCaveFileOffset, JoyCave);
      WriteBytes(JoyMenuCallFileOffset, JoyMenuCallNew);
      WriteByte(JoyMovieSkipFileOffset, $01);
      WriteByte(JoyEnterScreenFileOffset, $01);
      ApplyPadInvisibilityFix;
    end;

    // Autoload the save at start / Автозагрузка сохранения при старте
    if AutoLoadCB.Checked then begin
      FileStream.Seek(AutoLoadHookFileOffset, soBeginning);
      FileStream.ReadBuffer(PanelCallCurrent, SizeOf(AutoLoadHookOrig));
      if CompareMem(@PanelCallCurrent, @AutoLoadHookOrig, SizeOf(AutoLoadHookOrig)) then begin
        // Cave with the polls count / пещера с числом опросов
        Move(AutoLoadCave, AutoLoadCaveBuf, SizeOf(AutoLoadCave));
        AutoLoadPollsValue:=AutoLoadPolls;
        Move(AutoLoadPollsValue, AutoLoadCaveBuf[AutoLoadPollsPos], 4);
        WriteBytes(AutoLoadCaveFileOffset, AutoLoadCaveBuf);

        // Skip the vibration wait during autoload / пропуск ожидания вибрации при автозагрузке
        WriteBytes(AutoLoadWaitCaveFileOffset, AutoLoadWaitCave);
        WriteBytes(AutoLoadWaitSiteFileOffset, AutoLoadWaitSite);

        // The hook goes last, when both caves are in place / хук пишем последним, когда пещеры уже на месте
        WriteBytes(AutoLoadHookFileOffset, AutoLoadHook);
      end;
    end;

    // Vibration on damage / Вибрация при получении урона
    if DamageVibrationCB.Checked then begin
      FileStream.Seek(DmgVibeHookFileOffset, soBeginning);
      FileStream.ReadBuffer(PanelCallCurrent, SizeOf(DmgVibeHookOrig));
      if CompareMem(@PanelCallCurrent, @DmgVibeHookOrig, SizeOf(DmgVibeHookOrig)) then begin
        WriteBytes(DmgVibeCaveFileOffset, DmgVibeCave);  // cave first / сначала пещера
        WriteBytes(DmgVibeHookFileOffset, DmgVibeHook);  // hook last / хук последним
      end;
    end;

  finally
    FileStream.Free;
  end;

  // Resolution, color depth, brightness / Разрешение, глубина цвета, яркость
  FileStream:=TFileStream.Create(GameCfgPath, fmOpenReadWrite);
  try
    // Width / Ширина
    WriteCfgByte(0, ResolutionWidth and $FF);
    WriteCfgByte(1, (ResolutionWidth shr 8) and $FF);

    // Height / Высота
    WriteCfgByte(4, ResolutionHeight and $FF);
    WriteCfgByte(5, (ResolutionHeight shr 8) and $FF);

    // Color depth / Глубина цвета
    ColorDepthByte:=StrToInt(ColorDepthCB.Items[ColorDepthCB.ItemIndex]);
    //ColorDepthByte:=StrToInt('$' + IntToHex(StrToInt(ColorDepthCB.Items.Strings[ColorDepthCB.ItemIndex]), 2));
    WriteCfgByte(8, ColorDepthByte);

    // Brightness / Яркость
    //BrightnessByte:=StrToInt('$' + IntToHex(BrightnessTB.Position, 2));
    BrightnessByte:=BrightnessTB.Position;
    WriteCfgByte($0C, BrightnessByte);
  finally
    FileStream.Free;
  end;

  if DXWrapperCB.Checked then begin
    if not FileExists(AppPath + 'ddraw.dll') then
      CopyFile(PChar(AppPath + 'Additionally\DxWrapper\ddraw.dll'), PChar(AppPath + 'ddraw.dll'), False);
    if not FileExists(AppPath + 'dxwrapper.dll') then
      CopyFile(PChar(AppPath + 'Additionally\DxWrapper\dxwrapper.dll'), PChar(AppPath + 'dxwrapper.dll'), False);
    if not FileExists(AppPath + 'dxwrapper.ini') then begin
      CopyFile(PChar(AppPath + 'Additionally\DxWrapper\dxwrapper.ini'), PChar(AppPath + 'dxwrapper.ini'), False);
      Ini:=TIniFile.Create(AppPath + 'dxwrapper.ini');
      Ini.WriteString('General', 'DisableLogging', ' 1');
      Ini.Free;
    end;

    Ini:=TIniFile.Create(AppPath + 'dxwrapper.ini');
    if WindowedModeCB.Checked then begin
      Ini.WriteString('d3d9', 'EnableWindowMode', ' 1');
      Ini.WriteString('d3d9', 'WindowModeBorder', ' 1');
      Ini.WriteString('Dd7to9', 'DdrawOverrideWidth ', ' ' + IntToStr(ResolutionWidth));
      Ini.WriteString('Dd7to9', 'DdrawOverrideHeight', ' ' + IntToStr(ResolutionHeight));
    end else begin
      Ini.WriteString('d3d9', 'EnableWindowMode', ' 0');
      Ini.WriteString('d3d9', 'WindowModeBorder', ' 0');
      Ini.WriteString('Dd7to9', 'DdrawOverrideWidth ', ' 0');
      Ini.WriteString('Dd7to9', 'DdrawOverrideHeight', ' 0');
    end;
    if FPSLimit30RB.Checked then
      Ini.WriteString('d3d9', 'LimitPerFrameFPS', ' 30')
    else
      Ini.WriteString('d3d9', 'LimitPerFrameFPS', ' 24');
    Ini.Free;
  end else begin
    if FileExists(AppPath + 'ddraw.dll') then
      DeleteFile(AppPath + 'ddraw.dll');
    if FileExists(AppPath + 'dxwrapper.dll') then
      DeleteFile(AppPath + 'dxwrapper.dll');
    if FileExists(AppPath + 'dxwrapper.ini') then
      DeleteFile(AppPath + 'dxwrapper.ini');
  end;

  if XboxControllerSupportCB.Checked then begin
    if not FileExists(AppPath + 'dinput8.dll') then
      CopyFile(PChar(AppPath + 'Additionally\DInputAdvance\dinput8.dll'), PChar(AppPath + 'dinput8.dll'), False);
    if not FileExists(AppPath + 'dinput8.ini') then
      CopyFile(PChar(AppPath + 'Additionally\DInputAdvance\dinput8.ini'), PChar(AppPath + 'dinput8.ini'), False);
    Ini:=TIniFile.Create(AppPath + 'dinput8.ini');
    Ini.WriteInteger('XPad', 'RumbleScale', VibrationIntensityTB.Position * 10);
    Ini.Free;
  end else begin
    if FileExists(AppPath + 'dinput8.dll') then
      DeleteFile(AppPath + 'dinput8.dll');
    if FileExists(AppPath + 'dinput8.ini') then
      DeleteFile(AppPath + 'dinput8.ini');
  end;

  DoneMsg:=IDS_DONE + #13#10#13#10 + IDS_AUDIO_FIXES;
  if FPSLimit30RB.Checked then
    DoneMsg:=DoneMsg + #13#10#13#10 + IDS_FPS_LIMIT;
  if AutoLoadCB.Checked = false then
    DoneMsg:=DoneMsg + #13#10#13#10 + IDS_SAVES;

  Application.MessageBox(PChar(DoneMsg), PChar(Caption), MB_ICONINFORMATION);
  Close;
end;

procedure TMain.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.BrightnessTBChange(Sender: TObject);
begin
  BrightnessValLbl.Caption:=IntToStr(BrightnessTB.Position);
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AspectRatiosList.Free;
end;

procedure TMain.RestoreBtnClick(Sender: TObject);
begin
  if not FileExists(GameExePath + '.bak') then Exit;
  if CopyFile(PChar(GameExePath + '.bak'), PChar(GameExePath), False) then // Rewrite / Перезапись
    DeleteFile(GameExePath + '.bak');
  Application.MessageBox(PChar(IDS_DONE), PChar(Caption), MB_ICONINFORMATION);
  Close;
end;

procedure TMain.SaveBtnClick(Sender: TObject);
begin
  SavesForm.ShowModal;
end;

procedure TMain.VibrationIntensityTBChange(Sender: TObject);
begin
  VibrationIntensityValueLbl.Caption:=IntToStr(VibrationIntensityTB.Position * 10) + '%';
end;

procedure TMain.XboxControllerSupportCBClick(Sender: TObject);
begin
  VibrationIntensityTB.Enabled:=XboxControllerSupportCB.Checked;
end;

procedure TMain.DXWrapperCBClick(Sender: TObject);
begin
  WindowedModeCB.Enabled:=DXWrapperCB.Checked;
  FPSLimit30RB.Enabled:=DXWrapperCB.Checked;
  FPSLimit24RB.Enabled:=DXWrapperCB.Checked;
end;

end.
