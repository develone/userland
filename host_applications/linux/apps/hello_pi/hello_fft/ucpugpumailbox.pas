
{$mode delphi} {Default to Delphi compatible syntax}
{$H+}          {Default to AnsiString}
{$inline on}   {Allow use of Inline procedures}

unit ucpugpumailbox;

interface

 
uses GlobalConfig,GlobalConst,GlobalTypes,Platform,PlatformARMv7,HeapManager,Threads,Devices,Framebuffer,Logging,SysUtils;

function mem_alloc(file_desc:Integer; size, align, flags:Longword):Longword; cdecl; public name 'mem_alloc';
function mem_free(file_desc:Integer;  handle:Longword):Longword; cdecl; public name 'mem_free';
function mem_lock( file_desc:Integer; handle:Longword):Longword; cdecl; public name 'mem_lock';
function mem_unlock(file_desc:Integer; handle:Longword):Longword; cdecl; public name 'mem_unlock';
function mbox_open():Integer; cdecl; public name 'mbox_open';
function execute_code(file_desc:Pointer; r0, r1, r2, r3, r4, r5:Longword):Longword; cdecl; public name 'execute_code';

function mapmem():Integer; cdecl; public name 'mapmem';
function unmapmem():Integer; cdecl; public name 'unmapmem';

function execute_qpu(file_desc:Integer;num_qpus,control,noflush,timeout:LongWord):THandle;cdecl; public name 'execute_qpu';
function qpu_enable(file_desc:Integer;Enable:LongWord):THandle;cdecl; public name 'qpu_enable';	

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


function execute_qpu(file_desc:Integer;num_qpus,control,noflush,timeout:LongWord):THandle;cdecl; public name 'execute_qpu';
 	begin
	Result := GPUExecuteQPU(num_qpus,control,noflush,timeout);
	end;

function qpu_enable(file_desc:Integer;Enable:LongWord):THandle;cdecl; public name 'qpu_enable';	
 	begin
	Result := GPUEnableQPU(Enable);
	end;
end.

