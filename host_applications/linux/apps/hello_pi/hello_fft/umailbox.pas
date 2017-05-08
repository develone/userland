
{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit umailbox;

interface

uses GlobalConfig,GlobalConst,GlobalTypes,Platform;

function mem_alloc(file_desc:Integer; size, align, flags:Longword):Longword;
function mem_free(file_desc:Integer;  handle:Longword):Longword;
function mem_lock(file_desc:Integer;  handle:Longword):Longword;
function mbox_open():Integer;
function execute_code(file_desc:Integer; r0, r1, r2, r3, r4, r5:Longword):Longword;

implementation
 
function mem_alloc(file_desc:Integer; size, align, flags:Longword):Longword;

	var
	p : array[0..31] of Longword;

	begin
	
 
 	p[0] := 0;
	p[1] := $00000000;
	p[2] := $3000c;//196620 mem_alloc
 
	p[3] := 12; //mem_alloc
	p[4] := 12; //mem_alloc
 
	Result := p[5];
	end;
	

function mem_free(file_desc:Integer;  handle:Longword):Longword;

	var
	p : array[0..31] of Longword;

	begin
	
 
 	p[0] := 0;
	p[1] := $00000000;
	p[2] := $3000f;//196623 mem_free
 	
 
	p[3] := 4; //mem_free
	p[4] := 4; //mem_free
    p[5] := handle; 
	Result := p[5];
	end;

function mem_lock(file_desc:Integer;  handle:Longword):Longword;

	var
	p : array[0..31] of Longword;

	begin
	
 
 	p[0] := 0;
	p[1] := $00000000;
	p[2] := $3000d;//196623 mem_free
 	
 
	p[3] := 4; //mem_free
	p[4] := 4; //mem_free
    p[5] := handle; 
	Result := p[5];
	end;

function mbox_open():Integer;
	var
	file_desc:Integer;
	begin
	Result := file_desc;
	end;
	
function execute_code(file_desc:Integer; r0, r1, r2, r3, r4, r5:Longword):Longword;
	var
	p : array[0..31] of Longword;

	begin
	p[0] := 0;
	p[1] := $00000000;
	p[2] := $30010;
	p[3] := 28; //execute_code
	p[4] := 28; //execute_code
	p[6] := r0;
    p[7] := r1;
    p[8] := r2;
    p[9] := r3;
    p[10] := r4;
    p[11] := r5;
    p[12] := $00000000; // end tag
	Result := p[5];
	end;
end.
