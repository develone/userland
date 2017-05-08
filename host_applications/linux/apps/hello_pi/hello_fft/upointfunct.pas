
{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit upointfunct;

interface

uses GlobalConfig,GlobalConst,GlobalTypes,Platform;

 
function gpu_fft_ptr_inc(file_desc:Longword;bb:Integer):Longword; cdecl; public name 'gpu_fft_ptr_inc';

implementation
 
 	
function gpu_fft_ptr_inc(file_desc:Longword;bb:Integer):Longword; cdecl;
  
    

	begin
	Result := file_desc + 1;
	end;
end.
