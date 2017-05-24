program LibC_GPUFFT_RPi2;

{$mode objfpc}{$H+}

uses
 RaspberryPi2, {<-- Change this to suit which model you have!!}
 GlobalConfig,
 GlobalConst,
 GlobalTypes,
 Platform,
 Threads,
 Console,
 SysUtils,  { TimeToStr & Time }
 { needed by bitmap }
 GraphicsConsole, {Include the GraphicsConsole unit so we can create a graphics window}
 BMPcomn,         {Include the BMPcomn unit from the fpc-image package to give the Bitmap headers}
 Classes,
 { needed by bitmap }
 { needed to use ultibo-tftp  }
 uTFTP,
 Winsock2,
 { needed to use ultibo-tftp  }
 { needed for telnet }
      Shell,
     ShellFilesystem,
     ShellUpdate,
     RemoteShell,
  { needed for telnet }
 ucpugpumailbox,
 uGPU_FFT_HOST,
 uxxxx,
 Logging,
 BCM2709,
 Syscalls;

{$linklib gpufft}
{$linklib libm}
procedure fft_2d; cdecl; external 'libgpufft' name 'fft_2d';

 

var
 Handle:THandle;
 
 
 Count:Integer;
 
 
 IPAddress : string;
 X:LongWord;
 Y:LongWord;
 Width:LongWord;
 Height:LongWord;

function WaitForIPComplete : string;

var

  TCP : TWinsock2TCPClient;

begin

  TCP := TWinsock2TCPClient.Create;

  Result := TCP.LocalAddress;

  if (Result = '') or (Result = '0.0.0.0') or (Result = '255.255.255.255') then

    begin

      while (Result = '') or (Result = '0.0.0.0') or (Result = '255.255.255.255') do

        begin

          sleep (1500);

          Result := TCP.LocalAddress;

        end;

    end;

  TCP.Free;

end;



procedure Msg (Sender : TObject; s : string);

begin

  ConsoleWindowWriteLn (Handle, s);

end;



procedure WaitForSDDrive;

begin

  while not DirectoryExists ('C:\') do sleep (500);

end;

 

begin


 // wait for IP address and SD Card to be initialised.
 WaitForSDDrive;
 IPAddress := WaitForIPComplete;
 {Wait a few seconds for all initialization (like filesystem and network) to be done}
 Sleep(3000);

 

 Handle:=ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_LEFT,True);
 
 
  {Because console logging is disabled by default we need to enable it first.

  This can also be done using the command line parameter CONSOLE_REGISTER_LOGGING=1
  in the cmdline.txt file on the SD card.

  }
 CONSOLE_REGISTER_LOGGING:=True;

 LoggingConsoleDeviceAdd(ConsoleDeviceGetDefault);
 LoggingDeviceSetDefault(LoggingDeviceFindByType(LOGGING_TYPE_CONSOLE));
  Sleep(3000);
  ConsoleWindowWriteLn(Handle,'Sending lots of messages to the log');
  for Count:=1 to 20 do
  begin
   LoggingOutput('Message no ' + IntToStr(Count) + ' sent at ' + DateTimeToStr(Now));

   {Sleep for a random amount of time to mix up the output}
   Sleep(Random(350));
  end;
  
 
 ConsoleWindowWriteLn(Handle, TimeToStr(Time));
 ConsoleWindowWriteLn (Handle, 'TFTP Demo. & GPU fft');
 ConsoleWindowWriteLn(Handle, 'Calling C GPU fft_2d');
  ConsoleWindowWriteLn(Handle,IntToStr(GPU_MEMORY_SIZE));
 fft_2d();
 
  
 ConsoleWindowWriteLn (Handle, 'Local Address ' + IPAddress);
 SetOnMsg (@Msg);
 ConsoleWindowWriteLn(Handle, TimeToStr(Time));
 

 ThreadHalt(0);
end.

