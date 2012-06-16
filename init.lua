--
--
-- 		Author: Nemo08, Hackeridze, and whiskers75 (fixed it up)
--		Portal mod
--
	local version = "0.0.4"
--
--	

	local portals_content_conf = minetest.get_modpath('portal').."/portals_content"
	
	
	portal_list = {}
	halfportal_list = {} -- unfinished portals
	portals_changed = false

	
	
	dofile (minetest.get_modpath('portal') .. "/base_implement.lua")



---------- PENTAS -----------
function add_penta_portal(name,pos)

	if check_activated_portal_integrity(pos) == false then return false; end

	local nameinbase =  false
	for i,j in pairs(portal_list) do
		if j.name == name then
			nameinbase =  false
			return nil
		end
	end
	if nameinbase ==  false then
		portal_list[pos.x .."_" .. pos.y .. "_" .. pos.z] = { 	builder = placername, --this portal add to portal_list
			type ="public",
			portaltype = "penta",
			size = size,
			exname = j,
			state = "penta",
			dir = dirang,
			myx = pos.x,
			myy = pos.y,
			myz = pos.z,
			name = name,
		}
		portals_changed = true
		--save_portals () *** this line crashes Minetest! ***
		print("penta "..name.." added")
		minetest.chat_send_all('Portal ' .. name.. ' made!')
		return true
	end
end

function get_penta_portal_pos(name)
	for i,j in pairs(portal_list) do
		if (j.name == name)and(j.portaltype == "penta") then
			return {x =j.myx,y=j.myy,z=j.myz}
		end
	end
	return false
end

function remove_penta_portal(name)
	local p_pos = get_penta_portal_pos(name)
	if p_pos ~= false then
		portal_list[p_pos.x .."_" .. p_pos.y .. "_" .. p_pos.z] = nil
		portals_changed = true
		save_portals ()
		print("[Portal] Penta "..name .." removed!")
		minetest.chat_send_all('Portal ' .. name.. ' removed!')
		deactivate_activated_portal(p_pos)
		return true
	else
		return false
	end
end

function remove_penta_portal_pos(pos,dispersion)
	if dispersion == nil then
		dispersion = 0
	end
	for i,j in pairs(portal_list) do
		if (j.myx <= (pos.x+dispersion))and(j.myx >= (pos.x-dispersion))and(j.myy <= (pos.y+dispersion))and(j.myy >= (pos.y-dispersion))
			and(j.myz <= (pos.z+dispersion))and(j.myz >= (pos.z-dispersion))then
			deactivate_activated_portal({x=j.myx,y=j.muy,z=j.myz})
			portal_list[j.myx .."_" .. j.myy .. "_" .. j.myz] = nil
			save_portals ()
			print("[Portal] Penta "..name .." removed!")
			minetest.chat_send_all('Portal ' .. name.. ' removed!')
			return true
		end
	end
	return nil
end

function move_player_to_penta_name(player_obj,pname)
	local to_pos = get_penta_portal_pos(pname)
	if to_pos ~= false then
		print("[Portal] Player "..player_obj:get_player_name().." teleports to penta '" ..pname.."'!")
		player_obj:setpos({x =to_pos.x,y=to_pos.y+0.5,z=to_pos.z})
		if check_activated_portal_integrity(to_pos) == false then
			remove_penta_portal(pname)
			print("[Portal] Penta "..pname.." broken!")
		end
		return true
	else
		print("[Portal] No any pentas with name "..pname.."!")
		return false
	end
end

-------------------------------------------------------------------------------

local replace_node = function(pos, n)
	minetest.env:remove_node(pos)
	minetest.env:add_node(pos, {name = n})
end

local texture = "obsidian_block.png"

check_portal_integrity = function(pos)
	local co = 1
	for i=-1,1 do
		for j=-1,1 do
			p = {x = pos.x+j,y = pos.y,z = pos.z+i}
			if minetest.env:get_node(p).name~="portal:baph_" .. co then return false; end
			co = co +1 
		end
	end
	return true
end

check_activated_portal_integrity = function(pos)
	local co = 1
	for i=-1,1 do
		for j=-1,1 do
			p = {x = pos.x+j,y = pos.y-0.2,z = pos.z+i}
			if minetest.env:get_node(p).name~="portal:baph_" .. co .. "_act" then return false; end
			co = co +1 
		end
	end
	return true
end

deactivate_activated_portal = function(pos)
	if pos == false then return; end
	local co = 1
	for i=-1,1 do
		for j=-1,1 do
			p = {x = pos.x+j,y = pos.y,z = pos.z+i}
			if minetest.env:get_node(p).name=="portal:baph_" .. co .. "_act" then
				replace_node(p,"portal:baph_" .. co)
			end
			co = co +1 
		end
	end
	print("[Portal] Penta deactivated!")
	return true
end


for i = 1, 9 do 
	minetest.register_node("portal:baph_" .. i, {
		tile_images = {"baph_obs.png^baph" .. i .. ".png",texture,texture,texture,texture,texture},
		inventory_image = minetest.inventorycube("obsidian_block.png"),
		is_ground_content = true,
		material = minetest.digprop_glasslike(5.0),
		dug_item = 'node "obsidian:obsidian_block" 1',
	})

	minetest.register_node("portal:baph_" .. i .. "_act", {
		tile_images = {"baph" .. i .. "_a.png",texture,texture,texture,texture,texture},
		inventory_image = "baph" .. i .. "_a.png",
		inventory_image = minetest.inventorycube("obsidian_block.png"),
		is_ground_content = true,
		diggable = false,
		--material = minetest.digprop_glasslike(5.0),
		dug_item = 'node "obsidian:obsidian_block" 1',
		light_source = 14-1,
	})
end

minetest.register_on_punchnode(function(pos, node, puncher)
	local tool = puncher.get_wielded_item(puncher)
    if (tool == nil) or (tool.name ~= "obsidian:obsidian_knife") then return; end
	if (node.name == "obsidian:obsidian_block")or minetest.env:get_node(p).name=="portal:baph_5" then 
		local co = 1
		for i=-1,1 do
			for j=-1,1 do
				p = {x = pos.x+j,y = pos.y,z = pos.z+i}
				if minetest.env:get_node(p).name=="obsidian:obsidian_block" then 
					replace_node(p,"portal:baph_" .. co)
				end
				co = co +1 
			end
		end
	end
end)

minetest.register_on_chat_message(function(name, message)
	local cmd = "/activate"
	if message:sub(0, #cmd) == cmd then
		print("activate")
		local cmd = "/activate"
		local pname = string.match(message, cmd.." (.*)")
		if pname == nil then
			minetest.chat_send_player(name, 'usage: '..cmd..' portal_name')
			return true -- Handled chat message
		end

		local player = minetest.env:get_player_by_name(name)
		local pos = player:getpos()
		pos.y = pos.y -0.2
		print("[Portal] Trying to activete " .. pos.x..' ' .. pos.y..' ' .. pos.z..'...')

		if (check_portal_integrity(pos)) then 
			minetest.chat_send_player(name, "Portal activated.")

			local co = 1
			for i=-1,1 do
				for j=-1,1 do
					p = {x = pos.x+j,y = pos.y,z =pos.z+i}
					replace_node(p,"portal:baph_" .. co .. "_act")
					co = co +1 
				end
			end
			add_penta_portal(pname,pos)
		end
		return true
	end
end)

minetest.register_on_chat_message(function(name, message)
	local cmd = "/tp"
	if message:sub(0, #cmd) == cmd then
		local pname = string.match(message, cmd.." (.*)")
		if pname == nil then
			minetest.chat_send_player(name, 'usage: '..cmd..' portal_name')
			return true -- Handled chat message
		end
		local player = minetest.env:get_player_by_name(name)
		local pos = player:getpos()
		pos.y = pos.y -0.2
		if check_activated_portal_integrity(pos) == false then
			minetest.chat_send_player(name,"Started portal broken!")
			deactivate_activated_portal(pos)
			return true
		elseif move_player_to_penta_name(player,pname) == true then
			minetest.chat_send_player(name,'You teleported to ' .. pname.. '!')
			return true
		else
			minetest.chat_send_player(name,' Can\'t teleport you to ' .. pname.. '!')
			return true
		end
	end
end)

minetest.register_on_chat_message(function(name, message)
	local cmd = "/deactivate"
	if message:sub(0, #cmd) == cmd then
		local pname = string.match(message, cmd.." (.*)")
		if pname == nil then
			local player = minetest.env:get_player_by_name(name)
			local pos = player:getpos()
			pos.y = pos.y -0.2
			if deactivate_activated_portal(pos) == false then
				minetest.chat_send_player(name, 'usage: '..cmd..' portal_name')
			else
				minetest.chat_send_player(name,'Portal under you deactivated')
			end
			return true -- Handled chat message
		end
		local player = minetest.env:get_player_by_name(name)
		local pos = player:getpos()
		pos.y = pos.y -0.2
		
		if (remove_penta_portal(pname) == false) then
			deactivate_activated_portal(get_penta_portal_pos(pname))
			return true
		end
		return true
	end
end)
-------------------------------------------------------------------------------
print("[Portal " .. version .. "] Loaded!")
