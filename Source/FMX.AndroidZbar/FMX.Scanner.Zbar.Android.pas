unit FMX.Scanner.Zbar.Android;

interface


(*
  author by xubzhlin
  mail: 371889755@qq.com


  example scaner code:

  ImageScaner: is a TAndroidZbarImageScaner class;
  Image: is a TAndroidZbarImage class

  width: is the image width;
  height: is the image height;
  data: is the image data;
  len: is then image data length;



  ImageScaner =  TAndroidZbarImageScaner.Create;

  format is only "Y800" or "GRAY".

  Image := TAndroidZbarImage.Create(width, height, 'Y800');
  Image.SetData(data, len);
  ret := ImageScaner.ScanImage(Image);
  if(ret <> 0) then
  begin
    StopScanner;
    Results := FImageScaner.GetResults;
  end;
*)

uses
  System.SysUtils, System.Classes, FMX.Zbar.Android, Androidapi.JNIBridge;

type
  TAndroidZbarImage = class(TObject)
  private
    FZImg: Pzbar_image_t;
    FOnCleanup: TNotifyEvent;
  private
    function FormatToCardinal(Format: string): Cardinal;
    procedure zbar_image_cleanup_handler_t(image: Pzbar_image_t);
  public
    constructor Create(Width: Integer; Height: Integer; Format: string);
    destructor Destroy; override;

    procedure SetData(data: Pointer; len: Integer);
    property OnCleanup: TNotifyEvent read FOnCleanup write FOnCleanup;
  end;

  TAndroidZbarImageScaner = class(TObject)
  private
    FWidth: Integer;
    FHeight: Integer;
    FFormat: Cardinal;
    FScanner: Pzbar_image_scanner_t;
  public
    constructor Create;
    destructor Destroy; override;

    function ScanImage(Image: TAndroidZbarImage): Integer;
    function GetResults: TStrings;
  end;


implementation

{ TAndroidZbarImage }

constructor TAndroidZbarImage.Create(Width, Height: Integer; Format: string);
var
  fmt: Cardinal;
begin
  inherited Create;
  FZImg := zbar_image_create;
  zbar_image_set_size(FZImg, Width, Height);
  fmt := FormatToCardinal(Format);
  zbar_image_set_format(FZImg, fmt);
end;

destructor TAndroidZbarImage.Destroy;
begin
  inherited;
end;


function TAndroidZbarImage.FormatToCardinal(Format: string): Cardinal;
var
  len: Integer;
  LBuffer: TBytes;
  C: Char;
  I: Integer;
begin
  Result := 0;
  len := Length(Format);
  if((len <= 0) or (len > 4)) then
    raise Exception.Create('zbar image formate error');

  LBuffer := TEncoding.Default.GetBytes(Format);
  LBuffer := TEncoding.Default.Convert(TEncoding.Default, TEncoding.UTF8, LBuffer);
  Format := TEncoding.UTF8.GetString(LBuffer);
  for I := Low(Format) to High(Format) do
  begin
    C := Format[i];
    if((C < ' ') or (C > 'Z') or ((C > '9') and (C < 'A'))
      or ((C > ' ') and (C < '0'))) then
    raise Exception.Create('zbar image formate error');
    Result := (Result or ord(C) shl (8 * (i))) and $FFFFFFFF;
  end;
end;


procedure TAndroidZbarImage.SetData(data: Pointer; len: Integer);
begin
  zbar_image_set_data(FZImg, data, len, zbar_image_cleanup_handler_t);
  zbar_image_set_userdata(FZImg, data);
end;

procedure TAndroidZbarImage.zbar_image_cleanup_handler_t(image: Pzbar_image_t);
begin
  zbar_image_set_userdata(image, nil);
  if Assigned(FOnCleanup) then
    FOnCleanup(Self);
  zbar_image_destroy(FZImg);
end;

{ TAndroidZbarImageScaner }

constructor TAndroidZbarImageScaner.Create;
begin
  inherited Create;

  (* Instance barcode scanner *)
  FScanner := zbar_image_scanner_create;
  zbar_image_scanner_set_config(FScanner, ZBAR_NONE, ZBAR_CFG_X_DENSITY, 3);
  zbar_image_scanner_set_config(FScanner, ZBAR_NONE, ZBAR_CFG_Y_DENSITY, 3);
  zbar_image_scanner_set_config(FScanner, ZBAR_NONE, ZBAR_CFG_ENABLE, 0);
  zbar_image_scanner_set_config(FScanner, ZBAR_CODE128, ZBAR_CFG_ENABLE, 1);
  zbar_image_scanner_set_config(FScanner, ZBAR_CODE39, ZBAR_CFG_ENABLE, 1);
  zbar_image_scanner_set_config(FScanner, ZBAR_EAN13, ZBAR_CFG_ENABLE, 1);
  zbar_image_scanner_set_config(FScanner, ZBAR_EAN8, ZBAR_CFG_ENABLE, 1);
  zbar_image_scanner_set_config(FScanner, ZBAR_UPCA, ZBAR_CFG_ENABLE, 1);
  zbar_image_scanner_set_config(FScanner, ZBAR_UPCE, ZBAR_CFG_ENABLE, 1);
end;

destructor TAndroidZbarImageScaner.Destroy;
begin
  zbar_image_scanner_destroy(FScanner);
  inherited;
end;

function TAndroidZbarImageScaner.GetResults: TStrings;
var
  zsyms: Pzbar_symbol_set_t;
  zsym: Pzbar_symbol_t;
  Ret: MarshaledAString;
begin
  Result := TStringList.Create;

  zsyms := zbar_image_scanner_get_results(FScanner);
  if (zsyms <> nil) then
  begin
    zbar_symbol_set_ref(zsyms, 1);
  end;

  zsym := zbar_symbol_set_first_symbol(zsyms);
  while(zsym <> nil) do
  begin
    zbar_symbol_ref(zsym, 1);
    Ret := zbar_symbol_get_data(zsym);
    Result.Add(Ret);
    zsym := zbar_symbol_next(zsym)
  end;

end;

function TAndroidZbarImageScaner.ScanImage(Image: TAndroidZbarImage): Integer;
begin
  Result := zbar_scan_image(FScanner, Image.FZImg);
  if Result < 0 then
    raise Exception.Create('unsupported image format');
end;


end.
