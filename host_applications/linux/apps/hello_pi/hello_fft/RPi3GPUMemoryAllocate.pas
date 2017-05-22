 type
 {Enable QPU}
 TBCM2837MailboxTagExecuteQPURequest = record
  Enable:LongWord;
 end;
 
 type
 {Execute QPU}
 TBCM2837MailboxTagExecuteQPURequest = record
  NumQPUs:LongWord;
  Control:LongWord;
  NoFlush:LongWord;
  Timeout:LongWord; {Milliseconds}
 end;
function RPi3GPUMemoryAllocate(Length,Alignment,Flags:LongWord):THandle;
{Allocate GPU Memory from the Mailbox property tags channel}
var
 Size:LongWord;
 Response:LongWord;
 Header:PBCM2837MailboxHeader;
 Footer:PBCM2837MailboxFooter;
 Tag:PBCM2837MailboxTagAllocateMemory;
begin
 {}
 Result:=INVALID_HANDLE_VALUE;
 
 {Calculate Size}
 Size:=SizeOf(TBCM2837MailboxHeader) + SizeOf(TBCM2837MailboxTagAllocateMemory) + SizeOf(TBCM2837MailboxFooter);
 
 {Allocate Mailbox Buffer}
 Header:=GetNoCacheAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
 if Header = nil then Header:=GetAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
 if Header = nil then Exit;
 try
  {Clear Buffer}
  FillChar(Header^,Size,0);
 
  {Setup Header}
  Header.Size:=Size;
  Header.Code:=BCM2837_MBOX_REQUEST_CODE;
 
  {Setup Tag}
  Tag:=PBCM2837MailboxTagAllocateMemory(PtrUInt(Header) + PtrUInt(SizeOf(TBCM2837MailboxHeader)));
  Tag.Header.Tag:=BCM2837_MBOX_TAG_ALLOCATE_MEMORY;
  Tag.Header.Size:=SizeOf(TBCM2837MailboxTagAllocateMemory) - SizeOf(TBCM2837MailboxTagHeader);
  Tag.Header.Length:=SizeOf(Tag.Request);
  Tag.Request.Size:=Length;
  Tag.Request.Alignment:=Alignment;
  Tag.Request.Flags:=Flags;
 
  {Setup Footer}
  Footer:=PBCM2837MailboxFooter(PtrUInt(Tag) + PtrUInt(SizeOf(TBCM2837MailboxTagAllocateMemory)));
  Footer.Tag:=BCM2837_MBOX_TAG_END;
  
  {Call Mailbox}
  if MailboxPropertyCall(BCM2837_MAILBOX_0,BCM2837_MAILBOX0_CHANNEL_PROPERTYTAGS_ARMVC,Header,Response) <> ERROR_SUCCESS then
   begin
    if PLATFORM_LOG_ENABLED then PlatformLogError('GPUMemoryAllocate - MailboxPropertyCall Failed');
    Exit;
   end; 

  {Get Result}
  Result:=Tag.Response.Handle;
 finally
  FreeMem(Header);
 end;
 
 function RPi3GPUMemoryAllocate(Length,Alignment,Flags:LongWord):THandle;
{Allocate GPU Memory from the Mailbox property tags channel}
var
 Size:LongWord;
 Response:LongWord;
 Header:PBCM2837MailboxHeader;
 Footer:PBCM2837MailboxFooter;
 Tag:PBCM2837MailboxTagAllocateMemory;
begin
 {}
 Result:=INVALID_HANDLE_VALUE;
 
 {Calculate Size}
 Size:=SizeOf(TBCM2837MailboxHeader) + SizeOf(TBCM2837MailboxTagAllocateMemory) + SizeOf(TBCM2837MailboxFooter);
 
 {Allocate Mailbox Buffer}
 Header:=GetNoCacheAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
 if Header = nil then Header:=GetAlignedMem(Size,SIZE_16); {Must be 16 byte aligned}
 if Header = nil then Exit;
 try
  {Clear Buffer}
  FillChar(Header^,Size,0);
 
  {Setup Header}
  Header.Size:=Size;
  Header.Code:=BCM2837_MBOX_REQUEST_CODE;
 
  {Setup Tag}
  Tag:=PBCM2837MailboxTagAllocateMemory(PtrUInt(Header) + PtrUInt(SizeOf(TBCM2837MailboxHeader)));
  Tag.Header.Tag:=BCM2837_MBOX_TAG_ALLOCATE_MEMORY;
  Tag.Header.Size:=SizeOf(TBCM2837MailboxTagAllocateMemory) - SizeOf(TBCM2837MailboxTagHeader);
  Tag.Header.Length:=SizeOf(Tag.Request);
  Tag.Request.Size:=Length;
  Tag.Request.Alignment:=Alignment;
  Tag.Request.Flags:=Flags;
 
  {Setup Footer}
  Footer:=PBCM2837MailboxFooter(PtrUInt(Tag) + PtrUInt(SizeOf(TBCM2837MailboxTagAllocateMemory)));
  Footer.Tag:=BCM2837_MBOX_TAG_END;
  
  {Call Mailbox}
  if MailboxPropertyCall(BCM2837_MAILBOX_0,BCM2837_MAILBOX0_CHANNEL_PROPERTYTAGS_ARMVC,Header,Response) <> ERROR_SUCCESS then
   begin
    if PLATFORM_LOG_ENABLED then PlatformLogError('GPUMemoryAllocate - MailboxPropertyCall Failed');
    Exit;
   end; 

  {Get Result}
  Result:=Tag.Response.Handle;
 finally
  FreeMem(Header);
 end;
