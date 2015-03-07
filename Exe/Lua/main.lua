local smMain = require "AAGame/smMain" ;
local mouseControl = require "AAGame/mouseControl"
local G_lastOftenTime = 0

function updateOften()
	local time = ticker.get()
	
	delta = time - G_lastOftenTime
	G_lastOftenTime = time
	sound.update()
	color.update(delta)
end

function AABacktrace(errmsg)
	local backtrace = debug.traceback();
	print("A&A Backtrace: " .. errmsg)
	print(backtrace);
	return errmsg;
end

function AADumpWithCoRoutine(errobj)
	print("AADumpWithCoRoutine msg:")
        local errStr = tostring(errobj) or ""
        if( type(errobj)=='table' ) then
          errStr = "Table: {" .. table.concat(errobj, ',') .. "}"
        end
        print("Error: \"" .. errStr .. "\"")
        --for k,v in pairs(_G) do print("GLOBAL:" , k,v) end
        if( type(errobj)=='thread' ) then
        	print(">>> Showing thread:");
            print(debug.traceback(errobj))
            print("<<<");
        else
            print(debug.traceback('',2))
        end
end

function protected_main()
	print("** MAIN ENTERED **")
	local lastTick = ticker.get();

	mouseControl.InitForJustUI();

	smMain.init();
	while (not smMain:isDone()) do
		local delta = ticker.get() - lastTick;
		
		if (delta < 1) then
			-- Too fast! Slow down and let the CPU cool off
			ticker.sleep(1)
		end
		-- Okay, proceed
		lastTick = ticker.get()
-- TODO:            UpdateCmdqueue() ;
		updateOften()
		smMain:update()
	end
	smMain.finish();
	
	mouseControl.Finish();
end

function main()
	xpcall(protected_main, AABacktrace)
end

-- Run!
main()
