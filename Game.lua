function Game.dump()
	local file = io.open("D:/Work/LuaTest/out/lua.Log","w+")
	if file == nil then
		logError("File Is Not Exist!")
	end

	file:write(Debug.dumptree(_G,"_G"))
	io.close(file)
end
