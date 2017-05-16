
{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit uGPU_FFT_HOST;
 
interface

uses GlobalConfig,GlobalConst,GlobalTypes,Platform;

 
type
PGPU_FFT_HOST = ^GPU_FFT_HOST;
GPU_FFT_HOST = record
	mem_flg, mem_map, peri_addr, peri_size : Longword;
end;

var
	GPU_FFT_HOST_list : GPU_FFT_HOST;


type 
	GPU_FFT_HOST_listPointer = ^GPU_FFT_HOST;
   
function gpu_fft_get_host_info(info : PGPU_FFT_HOST):Longword; cdecl; public name 'gpu_fft_get_host_info';
  


implementation
function gpu_fft_get_host_info(info : PGPU_FFT_HOST):Longword; cdecl;
 
 
  begin
 
   info^.peri_addr := PeripheralGetBase;
   info^.peri_size := PeripheralGetsize + 1;

   
  
  //Defaults for Pi1
  info^.mem_flg := $c;   //Note that 0xC is the same as BCM2835_MBOX_MEM_FLAG_L1_NONALLOCATING from BCM2835 unit
  info^.mem_map := 0;
   
  if BUS_ALIAS <> $40000000 then // Pi 2?
  begin
//And 0x4 is the same as BCM2835_MBOX_MEM_FLAG_DIRECT from BCM2835 unit
// ARM cannot see VC4 L2 on Pi 2 
     info^.mem_flg := $4;  
     info^.mem_map  := $0;   
 
  end;
  Result := 0;
end;
 
 	
 end.
