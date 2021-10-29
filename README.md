# arp-aircraft v1.0
a purchase system to buy aircrafts and other flying objects.

# Installation

- Put the resource inside your `resources` folder.
- Import `player_aircrafts.sql` in your database. 
- Convert this resource from `arp` to `qb`. It is QBCore ready, I just made this specificly for my framework name.
- Once you have done that, I recommend to ensure it in your `server.cfg`
- Make sure you include the vehicles in your shared.lua

# Dependencies

This script requires:

- QBCore Framework 
- arp-hangers

# Issues

- There currently is an issue with storing your aircrafts. For some odd reason, they go to the depot instead of back into the garage. Will be fixed in the future
- The garage system uses crappy gui. This will be updated in the future to use nh-context which you can swap out for qb-menu

# Shared.lua

--Aircraft Vehicles--
	["microlight"] = {
		["name"] = "Ultralight",
		["brand"] = "Nagasaki",
		["model"] = "microlight",
		["price"] = 85000,
		["category"] = "Aircraft",
		["hash"] = `microlight`,
		["shop"] = "cardealer",
	},
	["frogger"] = {
		["name"] = "Ultralight",
		["brand"] = "Nagasaki",
		["model"] = "frogger",
		["price"] = 365000,
		["category"] = "Aircraft",
		["hash"] = `frogger`,
		["shop"] = "cardealer",
	},
	["swift2"] = {
		["name"] = "Ultralight",
		["brand"] = "Nagasaki",
		["model"] = "swift2",
		["price"] = 1105000,
		["category"] = "Aircraft",
		["hash"] = `swift2`,
		["shop"] = "cardealer",
	},

Everything above needs to match the config.lua
