	local save_conf_time = 20
	local portal_list = {}
	
	function load_portals ()
	end
	
	function save_portals ()
	end	
	
	tp = {
		physical = true,
		textures ={"default_cobble.png","default_cobble.png","raido_b.png","default_cobble.png","default_cobble.png","default_cobble.png"},
		lastpos={},
		visual = "cube",
		initial_sprite_basepos = {x=0, y=0},
	}
	
	tp.on_punch = function(self, hitter)
		hitter:setpos({x=115,y=3,z=-25})
	end
	
	tp.on_activate = function(self, data)
	end
	
	tp.on_step = function(self, dtime)
	end
	
	minetest.register_entity("t:tp", tp)
	
	------------ Nodes ----------------
	minetest.register_node("t:rune_raido_b", {
	tile_images = {"default_cobble.png","default_cobble.png","default_cobble.png","raido_b.png","default_cobble.png","default_cobble.png"},
	inventory_image = minetest.inventorycube("raido_b.png"),
	is_ground_content = false,
	material = minetest.digprop_dirtlike(1.0),
	metadata_name = "generic",
	dug_item = 'node "t:rune_raido_b" 1',
})

minetest.register_on_placenode(function(pos, newnode, placer)
	if newnode.name == "t:rune_raido_b" then
		local meta = minetest.env:get_meta(pos)
		local n = meta:get_string("state1")
		if n == nil then
			meta:set_string("state1","o")
			meta:set_infotext("o")
		else 
			meta:set_string("state1",n .. "o")
			meta:set_infotext(n .. "o")
		end
		print("Raido!!")
	end
end)