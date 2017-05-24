{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit uxxxx;


interface
uses GlobalConfig,GlobalConst,GlobalTypes,BCM2836,Platform,PlatformARM,PlatformARMv7,HeapManager,Threads;
function GPUExecuteQPU(file_desc:Integer;num_qpus,control,noflush,timeout:LongWord):THandle;cdecl; public name 'execute_qpu';
function GPUEnableQPU(file_desc:Integer;Enable:LongWord):THandle;cdecl; public name 'qpu_enable';

 {Adding structures for ExecuteQPURequest, ExecuteQPUReaponse, and TBCM2836MailboxTagExecuteQPU}
type
 {Execute QPU}
 TBCM2836MailboxTagExecuteQPURequest = record
  NumQPUs:LongWord;
  Control:LongWord;
  NoFlush:LongWord;
  Timeout:LongWord; {Milliseconds}
 end;
 
 TBCM2836MailboxTagExecuteQPUResponse = record
  Status:LongWord; {0 is Success / 0x80000000 is Timeout}
 end;
 
 PBCM2836MailboxTagExecuteQPU = ^TBCM2836MailboxTagExecuteQPU;
 TBCM2836MailboxTagExecuteQPU = record
  Header:TBCM2836MailboxTagHeader;
  case Integer of
  0:(Request:TBCM2836MailboxTagExecuteQPURequest);
  1:(Response:TBCM2836MailboxTagExecuteQPUResponse);
 end; 

{Adding structures for EnableQPURequest, EnableQPUReaponse, and  TBCM2836MailboxTagEnableQPU} 
 type
 {Enable QPU}
 TBCM2836MailboxTagEnableQPURequest = record
  Enable:LongWord;
 
 end;
 
 TBCM2836MailboxTagEnableQPUResponse = record
  Status:LongWord; {0 is Success / 0x80000000 is Timeout}
 end;
 
 PBCM2836MailboxTagEnableQPU = ^TBCM2836MailboxTagEnableQPU;
 TBCM2836MailboxTagEnableQPU = record
  Header:TBCM2836MailboxTagHeader;
  case Integer of
  0:(Request:TBCM2836MailboxTagEnableQPURequest);
  1:(Response:TBCM2836MailboxTagEnableQPUResponse);
 end; 
TGPUExecuteQPU = function(Handle:THandle):LongWord;
TGPUEnableQPU = function(Handle:THandle):LongWord;

 

implementation



function GPUExecuteQPU(file_desc:Integer;num_qpus,control,noflush,timeout:LongWord):THandle;cdecl; public name 'execute_qpu';
var
 Size:LongWord;
 Response:LongWord;
 Header:PBCM2836MailboxHeader;
 Footer:PBCM2836MailboxFooter;
 Tag: PBCM2836MailboxTagExecuteQPU;
 begin
 Result:=INVALID_HANDLE_VALUE;
 
  {Calculate Size}
 Size:=SizeOf(TBCM2836MailboxHeader) + SizeOf(TBCM2836MailboxTagExecuteQPU) + SizeOf(TBCM2836MailboxFooter);
 
  {Allocate Mailbox Buffer}
  Header:=GetNoCacheAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
  if Header = nil then Header:=GetAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
  if Header = nil then Exit;
  try
  {Clear Buffer}
  FillChar(Header^,Size,0);
 
  {Setup Header}
  Header.Size:=Size;
  Header.Code:=BCM2836_MBOX_REQUEST_CODE;
 
  {Setup Tag}
  Tag:=PBCM2836MailboxTagExecuteQPU(PtrUInt(Header) + PtrUInt(SizeOf(TBCM2836MailboxHeader)));
  Tag.Header.Tag:=BCM2836_MBOX_TAG_EXECUTE_QPU;
  Tag.Header.Size:=SizeOf(TBCM2836MailboxTagExecuteQPU) - SizeOf(TBCM2836MailboxTagHeader);
  Tag.Header.Length:=SizeOf(Tag.Request);
  Tag.Request.NumQPUs:=num_qpus;
  Tag.Request.control:=control;
  Tag.Request.noflush:=noflush;
  Tag.Request.timeout:=timeout;  
  {Setup Footer}
  Footer:=PBCM2836MailboxFooter(PtrUInt(Tag) + PtrUInt(SizeOf(TBCM2836MailboxTagExecuteQPU)));
  Footer.Tag:=BCM2836_MBOX_TAG_END;   
  {Call Mailbox}
  if MailboxPropertyCall(BCM2836_MAILBOX_0,BCM2836_MAILBOX0_CHANNEL_PROPERTYTAGS_ARMVC,Header,Response) <> ERROR_SUCCESS then
   begin
    if PLATFORM_LOG_ENABLED then PlatformLogError('GPUExecuteQPU - MailboxPropertyCall Failed');
    Exit;
   end;  

  {Get Result}
 Result:=Tag.Response.Status;
 finally
  FreeMem(Header);
 end; 
 end;
 
 function GPUEnableQPU(file_desc:Integer;Enable:LongWord):THandle;cdecl; public name 'qpu_enable';
var
 Size:LongWord;
 Response:LongWord;
 Header:PBCM2836MailboxHeader;
 Footer:PBCM2836MailboxFooter;
 Tag: PBCM2836MailboxTagEnableQPU;
 begin
 Result:=INVALID_HANDLE_VALUE;
 
   {Calculate Size}
 Size:=SizeOf(TBCM2836MailboxHeader) + SizeOf(TBCM2836MailboxTagEnableQPU) + SizeOf(TBCM2836MailboxFooter);
 
  {Allocate Mailbox Buffer}
  Header:=GetNoCacheAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
  if Header = nil then Header:=GetAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
  if Header = nil then Exit; 
  try
  {Clear Buffer}
  FillChar(Header^,Size,0);
 
  {Setup Header}
  Header.Size:=Size;
  Header.Code:=BCM2836_MBOX_REQUEST_CODE;
 
  {Setup Tag}
  Tag:=PBCM2836MailboxTagEnableQPU(PtrUInt(Header) + PtrUInt(SizeOf(TBCM2836MailboxHeader)));
  Tag.Header.Tag:=BCM2836_MBOX_TAG_ENABLE_QPU;
  Tag.Header.Size:=SizeOf(TBCM2836MailboxTagEnableQPU) - SizeOf(TBCM2836MailboxTagHeader);
  Tag.Header.Length:=SizeOf(Tag.Request);
  Tag.Request.Enable:=Enable;
 
  {Setup Footer}
  Footer:=PBCM2836MailboxFooter(PtrUInt(Tag) + PtrUInt(SizeOf(TBCM2836MailboxTagEnableQPU)));
  Footer.Tag:=BCM2836_MBOX_TAG_END; 
 
  {Call Mailbox}
  if MailboxPropertyCall(BCM2836_MAILBOX_0,BCM2836_MAILBOX0_CHANNEL_PROPERTYTAGS_ARMVC,Header,Response) <> ERROR_SUCCESS then
   begin
    if PLATFORM_LOG_ENABLED then PlatformLogError('GPUEnableQPU - MailboxPropertyCall Failed');
    Exit;
   end; 
  {Get Result}
 Result:=Tag.Response.Status;
 finally 
 FreeMem(Header);
 end;
 end;
end.
