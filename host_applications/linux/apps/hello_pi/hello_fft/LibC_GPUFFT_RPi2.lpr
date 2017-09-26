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
 

 uLiftBitmap,
 Logging,
 BCM2709,
 VC4,
 Syscalls;

{$linklib gpufft}
{$linklib libm}
procedure fft_2d; cdecl; external 'libgpufft' name 'fft_2d';

 

var
 Handle:THandle;
 Window:TWindowHandle;
 
 Count:Integer;
 
 
 IPAddress : string;
 X:LongWord;
 Y:LongWord;
 Width:LongWord;
 Height:LongWord;
 DECOMP: Integer;
 ENCODE: Integer;
 TCP_DISTORATIO: Integer;
 FILTER: Integer; 
 COMPRESSION_RATIO : Integer;
 DIS_CR_FLG : Integer;
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

 

 Handle:=ConsoleWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_TOPLEFT,True);
 Window:=GraphicsWindowCreate(ConsoleDeviceGetDefault,CONSOLE_POSITION_BOTTOMLEFT);
 
  {Because console logging is disabled by default we need to enable it first.

  This can also be done using the command line parameter CONSOLE_REGISTER_LOGGING=1
  in the cmdline.txt file on the SD card.

  }
 CONSOLE_REGISTER_LOGGING:=True;

 LoggingConsoleDeviceAdd(ConsoleDeviceGetDefault);
 LoggingDeviceSetDefault(LoggingDeviceFindByType(LOGGING_TYPE_CONSOLE));
  Sleep(3000);
  

  
 
 ConsoleWindowWriteLn(Handle, TimeToStr(Time));
 ConsoleWindowWriteLn (Handle, 'TFTP Demo. & GPU fft');
 ConsoleWindowWriteLn(Handle, 'Calling C GPU fft_2d');
 ConsoleWindowWriteLn(Handle,'GPU_MEMORY_BASE ' + '0x' +IntToHex(GPU_MEMORY_BASE,8));
 ConsoleWindowWriteLn(Handle,'GPU_MEMORY_SIZE ' + '0x' +IntToHex(GPU_MEMORY_SIZE,8));
 fft_2d();
 
 //DrawBitmap(Window,'C:\hello_fft_2d.bmp',0,0,DECOMP,ENCODE,TCP_DISTORATIO,FILTER, COMPRESSION_RATIO,DIS_CR_FLG);
 
 ConsoleWindowWriteLn (Handle, 'Local Address ' + IPAddress);
 SetOnMsg (@Msg);
 ConsoleWindowWriteLn(Handle, TimeToStr(Time));
 

 ThreadHalt(0);
end.

