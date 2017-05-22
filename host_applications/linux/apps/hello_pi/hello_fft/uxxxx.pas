{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit uxxxx;

interface
uses GlobalConfig,GlobalConst,GlobalTypes,BCM2836;
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

implementation
 
end.
