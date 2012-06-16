	local save_conf_time = 5

local base = _G
local function isValidType(valueType)
  return "number" == valueType or 
         "boolean" == valueType or 
         "string" == valueType
end

-- конвертация переменной в строку
local function valueToString (value)
  local valueType = base.type(value)
  
  if "number" == valueType or "boolean" == valueType then
    result = base.tostring(value)
  else  -- assume it is a string
    -- обратите внимание на флаг "%q"!
    -- этот флаг правильно обрабатывает строки, 
    -- содержащие в себе кавычки и другие управляющие символы
    result = base.string.format("%q", value)
  end
  
  return result
end

local function save_portals (sfile,name, value, saved)
  saved = saved or {}       -- initial value
  sfile:write(name, " = ")
  local valueType = base.type(value)
  if isValidType(valueType) then
    sfile:write(valueToString(value), "\n")
  elseif "table" == valueType then
    if saved[value] then    -- value already saved?
      sfile:write(saved[value], "\n")  -- use its previous name
    else
      saved[value] = name   -- save name for next time
      sfile:write("{}\n")     -- create a new table
      for k,v in base.pairs(value) do      -- save its fields
        -- добавляем проверку ключа таблицы
        local keyType = base.type(k)
        if isValidType(keyType) then
          local fieldname = base.string.format("%s[%s]", name, valueToString(k))
          portal_save(sfile,fieldname, v, saved)
        else
          base.error("cannot save a " .. keyType)
        end
      end
    end
  else
    base.error("cannot save a " .. valueType)
  end
end
	-----------------------------------------------------------------------------
	
local function save_portals ()
		if portals_changed then
			local output = io.open(minetest.get_modpath('portal').."/portal_list.lua", "w")
			portal_save(output,"portal_list", portal_list)
			portal_save(output,"halfportal_list", halfportal_list)
			io.close(output)
			print("Сохранил порталы!!! ")
		end
	end	
	
	local delta = 0
	minetest.register_globalstep(function(dtime)
    delta = delta + dtime
    if delta > save_conf_time then
        delta = 0
		if portals_changed then
			save_portals()
			portals_changed = false
		end
    end
end)

dofile (minetest.get_modpath('portal') .. "/portal_list.lua")
