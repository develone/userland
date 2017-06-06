
{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit ucpugpumailbox;

interface

//uses GlobalConfig,GlobalConst,GlobalTypes,BCM2836,Platform,PlatformARM,PlatformARMv7,HeapManager,Threads{$IFDEF CONSOLE_EARLY_INIT},Devices,Framebuffer{$ENDIF}{$IFDEF LOGGING_EARLY_INIT},Logging{$ENDIF},SysUtils;
uses GlobalConfig,GlobalConst,GlobalTypes,BCM2836,Platform,PlatformARM,PlatformARMv7,HeapManager,Threads,Devices,Framebuffer,Logging,SysUtils;

function mem_alloc(file_desc:Integer; size, align, flags:Longword):Longword; cdecl; public name 'mem_alloc';
function mem_free(file_desc:Integer;  handle:Longword):Longword; cdecl; public name 'mem_free';
function mem_lock( file_desc:Integer; handle:Longword):Longword; cdecl; public name 'mem_lock';
function mem_unlock(file_desc:Integer; handle:Longword):Longword; cdecl; public name 'mem_unlock';
function mbox_open():Integer; cdecl; public name 'mbox_open';
function execute_code(file_desc:Pointer; r0, r1, r2, r3, r4, r5:Longword):Longword; cdecl; public name 'execute_code';

function mapmem():Integer; cdecl; public name 'mapmem';
function unmapmem():Integer; cdecl; public name 'unmapmem';

function GPUExecuteQPU(file_desc:Integer;num_qpus,control,noflush,timeout:LongWord):THandle;cdecl; public name 'execute_qpu';
function GPUEnableQPU(file_desc:Integer;Enable:LongWord):THandle;cdecl; public name 'qpu_enable';
implementation
 
function mem_alloc(file_desc:Integer; size, align, flags:Longword):Longword; cdecl; public name 'mem_alloc';

	{platform.pas lines 4973 - 4985
	type
    TGPUMemoryAllocate = function(Length,Alignment,Flags:LongWord):THandle; }

	begin
	Result := GPUMemoryAllocate(size, align, flags);
	end;
	
function mem_free(file_desc:Integer;  handle:Longword):Longword; cdecl; public name 'mem_free';

	{platform.pas lines 4989 - 5001
	type 
    TGPUMemoryRelease = function(Handle:THandle):LongWord; }
    
	begin
	Result := GPUMemoryRelease(handle);
	end;

function mem_lock(file_desc:Integer; handle:Longword):Longword; cdecl; public name 'mem_lock';

	{platform.pas lines 5005 - 5017
	type 
    TGPUMemoryLock = function(Handle:THandle):LongWord; }
    
	begin
	Result := GPUMemoryLock(handle);
	end;

function mem_unlock(file_desc:Integer; handle:Longword):Longword; cdecl; public name 'mem_unlock'; 

	begin
	Result := GPUMemoryUnlock(handle);
	end;
	
function mbox_open():Integer; cdecl; public name 'mbox_open';

	var
	file_desc:Integer;
	
	begin
	Result := file_desc;
	end;

function mapmem():Integer; cdecl; public name 'mapmem';

	var
	file_desc:Integer;
	
	begin
	Result := file_desc;
	end;

function unmapmem():Integer; cdecl; public name 'unmapmem';

	var
	file_desc:Integer;
	
	begin
	Result := file_desc;
	end;
		
function execute_code(file_desc:Pointer; r0, r1, r2, r3, r4, r5:Longword):Longword; cdecl; public name 'execute_code';
 
	{platform.pas lines 5038 - 5050
	type 
    TGPUExecuteCode = function(Address:Pointer;R0,R1,R2,R3,R4,R5:LongWord):LongWord; }  
    
	begin
	Result := GPUExecuteCode(file_desc,R0,R1,R2,R3,R4,R5);
	end;

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
    if PLATFORM_LOG_ENABLED then 
    PlatformLogError('GPUExecuteQPU - MailboxPropertyCall Failed');
	PlatformLogError('NumQPUs ' + IntToStr(Tag.Request.NumQPUs) + ' control ' + '0x' +IntToHex(Tag.Request.control,8));
	PlatformLogError('noflush ' + IntToStr(Tag.Request.noflush) + ' timeout ' + '0x' +IntToHex(Tag.Request.timeout,8));


    Exit;
   end;  
   LoggingOutput('NumQPUs ' + IntToStr(Tag.Request.NumQPUs) + ' control ' + '0x' +IntToHex(Tag.Request.control,8));
   LoggingOutput('noflush ' + IntToStr(Tag.Request.noflush) + ' timeout ' + '0x' +IntToHex(Tag.Request.timeout,8));
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
  LoggingOutput('qpu_enable');
  {Get Result}
 Result:=Tag.Response.Status;
 finally 
 FreeMem(Header);
 end;
 end;
end.
