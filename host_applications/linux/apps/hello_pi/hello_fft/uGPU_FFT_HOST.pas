
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
   info^.mem_flg := $c;
   info^.mem_map := 0;
   info^.peri_addr := PeripheralGetBase;
   info^.peri_size := PeripheralGetsize + 1;

   //Add the rest of the implementation here
   
   Result := 0;
end;
 
 	
 end.
