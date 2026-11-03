-- Hey bro, if you see an open script, then why? Yeah, I just don't like Roblox anymore. You can take the script, but please, can you mention me somewhere @Poiuytr, my main Discord account @poiytr12345678. Good luck bro!
local function buildIxaLibrary()
local __Ixa_iconsLicense = [=[MIT License

Copyright (c) 2025 Footages

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]=]
local function __Ixa_searchLower(value)
    return string.lower(tostring(value or ""))
end

local a = (function()
	local __Ixa_guiTweenService = game:GetService("TweenService")
	local __Ixa_guiInputService = game:GetService("UserInputService")
	local __Ixa_guiGuiService = game:GetService("GuiService")
	local __Ixa_guiRunService = game:GetService("RunService")
	local __Ixa_guiHttpService = game:GetService("HttpService")
	local __Ixa_guiPlayers = game:GetService("Players")
	local __Ixa_guiTeleportService = game:GetService("TeleportService")
	local __Ixa_guiMarketplace = game:GetService("MarketplaceService")
	local __Ixa_guiStats = game:GetService("Stats")
	local __Ixa_guiPlayer = __Ixa_guiPlayers.LocalPlayer
	local __Ixa_guiLibrary = {}
	__Ixa_guiLibrary.Flags = {}
	__Ixa_guiLibrary.Windows = {}
	local function __Ixa_guiOptions(m, n)
		local o = {}
		if type(m) == "string" then
			o.Name = m
		elseif type(m) == "table" then
			for p, q in pairs(m) do
				o[p] = q
			end
		end
		for p, q in pairs(n or {}) do
			if o[q] == nil and o[p] ~= nil then
				o[q] = o[p]
			end
		end
		if o.Range then
			o.Min = o.Min or o.Range[1]
			o.Max = o.Max or o.Range[2]
		end
		return o
	end
	local function __Ixa_guiRegister(n, o, p, q, r)
		p._type = r
		p._frame = q
		p._window = n and n.Window
		p._listeners = p._listeners or {}
		local s = n and n.Window
		local t = o.Name or o.Text or o.Title
		p._searchName = type(t) == "string" and t or ""
		p._searchKey = __Ixa_searchLower(p._searchName)
		if n and n._items then
			table.insert(n._items, p)
		end
		if o.Flag then
			__Ixa_guiLibrary.Flags[o.Flag] = p
			if s then
				s:_flagCreated(o.Flag, p)
			end
		end
		p._userVisible = o.Visible ~= false
		function p:IsVisible()
			return p._userVisible
		end
		function p:_isShown()
			return p._userVisible and not p._dependHidden and not (n and n._userVisible == false)
		end
		function p:SetVisible(u)
			u = u and true or false
			if u == p._userVisible or p._destroyed then
				return
			end
			p._userVisible = u
			if not u then
				if p._onHide then
					p._onHide()
				end
				if p.Open and type(p.SetOpen) == "function" then
					p:SetOpen(false)
				end
			end
			if q then
				q.Visible = u and not p._dependHidden
			end
			if s then
				s._controlsDirty = true
			end
		end
		if q and not p._userVisible then
			q.Visible = false
		end
		function p:SetDisabled(u)
			__Ixa_guiLibrary._setDisabled(p, q, u)
		end
		function p:IsDisabled()
			return p.Disabled == true
		end
		if o.Disabled == true then
			p:SetDisabled(true)
		end
		function p:SetDependsOn(u, v)
			p._dependsOn = u
			p._dependsMode = v or p._dependsMode
			p._dependsMet = nil
			if u == nil then
				__Ixa_guiLibrary._applyDepends(p, true)
			elseif s then
				__Ixa_guiLibrary._watchDepends(s, p)
			end
		end
		if o.DependsOn ~= nil then
			p._dependsMode = o.DependsMode
			p:SetDependsOn(o.DependsOn)
		end
		function p:SetTooltip(u)
			p._tooltip = u
			if q and s and not p._tooltipBound then
				p._tooltipBound = true
				s:_attachTooltip(p, q)
			end
		end
		function p:GetTooltip()
			return p._tooltip
		end
		if o.Tooltip ~= nil and o.Tooltip ~= false then
			p:SetTooltip(o.Tooltip)
		end
		function p:Destroy()
			if p._destroyed then
				return
			end
			p._destroyed = true
			if s and s._tipOwner == p then
				s:_hideTooltip()
			end
			for u, v in ipairs(p._listeners) do
				v()
			end
			p._listeners = {}
			if n and n._items then
				local u = table.find(n._items, p)
				if u then
					table.remove(n._items, u)
				end
			end
			if o.Flag and __Ixa_guiLibrary.Flags[o.Flag] == p then
				__Ixa_guiLibrary.Flags[o.Flag] = nil
			end
			if s then
				s._controlsDirty = true
			end
			if q then
				q:Destroy()
			end
		end
		return p
	end
	__Ixa_guiLibrary.Theme = {
		Background = Color3.fromRGB(15, 15, 15),
		Surface = Color3.fromRGB(20, 20, 20),
		Surface2 = Color3.fromRGB(25, 25, 25),
		Surface3 = Color3.fromRGB(50, 50, 50),
		Stroke = Color3.fromRGB(40, 40, 40),
		StrokeHover = Color3.fromRGB(70, 70, 70),
		Accent = Color3.fromRGB(128, 160, 246),
		AccentDark = Color3.fromRGB(12, 12, 12),
		Text = Color3.fromRGB(255, 255, 255),
		Muted = Color3.fromRGB(140, 140, 140),
		Warning = Color3.fromRGB(240, 176, 108),
		Success = Color3.fromRGB(150, 220, 170),
		Error = Color3.fromRGB(240, 120, 120),
	}
	local __Ixa_guiThemeKeys = {
		"Accent",
		"AccentDark",
		"Background",
		"Surface",
		"Surface2",
		"Surface3",
		"Stroke",
		"StrokeHover",
		"Text",
		"Muted",
		"Warning",
		"Success",
		"Error",
	}
	local function __Ixa_guiReadableMuted(p, q, r)
		return Color3.fromRGB(p, q, r)
	end
	function __Ixa_guiLibrary._readableMuted(p, q, r)
		local function s(t)
			local function u(v)
				return v <= 0.03928 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4
			end
			return 0.2126 * u(t.R) + 0.7152 * u(t.G) + 0.0722 * u(t.B)
		end
		local t = s(r)
		for u = 0, 20 do
			local v = p:Lerp(q, u / 20)
			local w = s(v)
			if (math.max(w, t) + 0.05) / (math.min(w, t) + 0.05) >= 4.6 then
				return v
			end
		end
		return q
	end
	local function __Ixa_guiThemePreset(q, r, s, t, u, v, w, x, y, z)
		return {
			Background = __Ixa_guiReadableMuted(table.unpack(q)),
			Surface = __Ixa_guiReadableMuted(table.unpack(r)),
			Surface2 = __Ixa_guiReadableMuted(table.unpack(s)),
			Surface3 = __Ixa_guiReadableMuted(table.unpack(t)),
			Stroke = __Ixa_guiReadableMuted(table.unpack(u)),
			StrokeHover = __Ixa_guiReadableMuted(table.unpack(v)),
			Accent = __Ixa_guiReadableMuted(table.unpack(w)),
			AccentDark = __Ixa_guiReadableMuted(table.unpack(x)),
			Text = __Ixa_guiReadableMuted(table.unpack(y)),
			Muted = __Ixa_guiLibrary._readableMuted(__Ixa_guiReadableMuted(table.unpack(z)), __Ixa_guiReadableMuted(table.unpack(y)), __Ixa_guiReadableMuted(table.unpack(s))),
		}
	end
	__Ixa_guiLibrary.ThemePresets = {
		Midnight = __Ixa_guiThemePreset(
			{ 15, 18, 26 },
			{ 18, 22, 31 },
			{ 22, 26, 37 },
			{ 37, 44, 60 },
			{ 34, 40, 55 },
			{ 70, 84, 112 },
			{ 128, 160, 246 },
			{ 14, 18, 30 },
			{ 228, 232, 242 },
			{ 116, 126, 148 }
		),
		Ocean = __Ixa_guiThemePreset(
			{ 12, 20, 24 },
			{ 15, 24, 29 },
			{ 18, 29, 35 },
			{ 31, 48, 56 },
			{ 29, 44, 52 },
			{ 58, 92, 104 },
			{ 110, 214, 222 },
			{ 10, 24, 28 },
			{ 226, 238, 240 },
			{ 108, 134, 140 }
		),
		Rose = __Ixa_guiThemePreset(
			{ 21, 21, 21 },
			{ 26, 26, 26 },
			{ 31, 31, 31 },
			{ 48, 48, 48 },
			{ 44, 44, 44 },
			{ 92, 116, 50 },
			{ 183, 243, 74 },
			{ 21, 21, 21 },
			{ 243, 243, 238 },
			{ 134, 134, 128 }
		),
		Emerald = __Ixa_guiThemePreset(
			{ 13, 20, 17 },
			{ 16, 24, 20 },
			{ 20, 29, 24 },
			{ 33, 47, 40 },
			{ 30, 44, 37 },
			{ 62, 96, 78 },
			{ 132, 226, 170 },
			{ 12, 26, 18 },
			{ 228, 240, 233 },
			{ 110, 136, 122 }
		),
		Amber = __Ixa_guiThemePreset(
			{ 22, 18, 13 },
			{ 27, 22, 16 },
			{ 32, 26, 19 },
			{ 49, 41, 31 },
			{ 46, 38, 28 },
			{ 100, 82, 58 },
			{ 246, 196, 120 },
			{ 30, 22, 10 },
			{ 242, 236, 226 },
			{ 140, 126, 106 }
		),
		Mono = __Ixa_guiThemePreset(
			{ 16, 16, 17 },
			{ 20, 20, 21 },
			{ 25, 25, 26 },
			{ 40, 40, 42 },
			{ 38, 38, 40 },
			{ 84, 84, 88 },
			{ 236, 236, 240 },
			{ 20, 20, 22 },
			{ 234, 234, 236 },
			{ 122, 122, 128 }
		),
		Nebula = __Ixa_guiThemePreset(
			{ 14, 12, 28 },
			{ 18, 15, 35 },
			{ 23, 19, 43 },
			{ 39, 32, 68 },
			{ 35, 29, 62 },
			{ 84, 68, 140 },
			{ 199, 125, 255 },
			{ 22, 10, 40 },
			{ 236, 230, 252 },
			{ 124, 114, 160 }
		),
		Synthwave = __Ixa_guiThemePreset(
			{ 20, 12, 30 },
			{ 25, 15, 37 },
			{ 31, 18, 45 },
			{ 52, 30, 72 },
			{ 47, 27, 66 },
			{ 110, 58, 150 },
			{ 255, 94, 198 },
			{ 38, 8, 30 },
			{ 250, 232, 246 },
			{ 150, 118, 160 }
		),
		Sakura = __Ixa_guiThemePreset(
			{ 24, 14, 20 },
			{ 29, 17, 24 },
			{ 35, 20, 29 },
			{ 54, 32, 45 },
			{ 50, 29, 41 },
			{ 112, 66, 92 },
			{ 255, 158, 200 },
			{ 36, 12, 24 },
			{ 248, 232, 240 },
			{ 150, 112, 132 }
		),
		Velvet = __Ixa_guiThemePreset(
			{ 20, 10, 16 },
			{ 25, 12, 20 },
			{ 31, 15, 25 },
			{ 50, 25, 40 },
			{ 46, 23, 37 },
			{ 104, 52, 82 },
			{ 222, 110, 170 },
			{ 30, 8, 20 },
			{ 244, 228, 238 },
			{ 142, 106, 126 }
		),
		Crimson = __Ixa_guiThemePreset(
			{ 18, 10, 12 },
			{ 23, 12, 15 },
			{ 28, 14, 18 },
			{ 46, 24, 29 },
			{ 42, 22, 27 },
			{ 104, 46, 56 },
			{ 244, 74, 94 },
			{ 32, 8, 12 },
			{ 244, 230, 232 },
			{ 142, 106, 112 }
		),
		Sunset = __Ixa_guiThemePreset(
			{ 22, 13, 14 },
			{ 27, 16, 17 },
			{ 33, 19, 21 },
			{ 52, 31, 32 },
			{ 48, 28, 30 },
			{ 112, 62, 58 },
			{ 255, 138, 92 },
			{ 34, 14, 8 },
			{ 248, 234, 228 },
			{ 150, 118, 110 }
		),
		Gold = __Ixa_guiThemePreset(
			{ 14, 13, 11 },
			{ 18, 17, 14 },
			{ 23, 21, 17 },
			{ 38, 35, 28 },
			{ 35, 32, 26 },
			{ 92, 80, 54 },
			{ 232, 196, 122 },
			{ 30, 22, 8 },
			{ 240, 234, 222 },
			{ 136, 126, 106 }
		),
		Cyber = __Ixa_guiThemePreset(
			{ 13, 13, 15 },
			{ 17, 17, 19 },
			{ 21, 21, 24 },
			{ 36, 36, 40 },
			{ 33, 33, 37 },
			{ 86, 84, 70 },
			{ 250, 226, 72 },
			{ 30, 26, 4 },
			{ 240, 240, 232 },
			{ 126, 124, 118 }
		),
		Toxic = __Ixa_guiThemePreset(
			{ 11, 14, 11 },
			{ 14, 18, 14 },
			{ 18, 23, 18 },
			{ 31, 39, 30 },
			{ 28, 36, 28 },
			{ 74, 98, 60 },
			{ 184, 255, 74 },
			{ 18, 30, 6 },
			{ 232, 242, 228 },
			{ 116, 134, 110 }
		),
		Matcha = __Ixa_guiThemePreset(
			{ 16, 19, 14 },
			{ 20, 23, 17 },
			{ 24, 28, 21 },
			{ 40, 46, 34 },
			{ 37, 42, 31 },
			{ 84, 98, 70 },
			{ 176, 214, 140 },
			{ 18, 26, 10 },
			{ 236, 240, 228 },
			{ 128, 136, 116 }
		),
		Aurora = __Ixa_guiThemePreset(
			{ 10, 20, 22 },
			{ 12, 25, 27 },
			{ 15, 30, 33 },
			{ 26, 50, 53 },
			{ 24, 45, 48 },
			{ 50, 104, 104 },
			{ 94, 240, 180 },
			{ 6, 30, 22 },
			{ 224, 246, 240 },
			{ 102, 142, 134 }
		),
		Frost = __Ixa_guiThemePreset(
			{ 13, 17, 23 },
			{ 16, 21, 28 },
			{ 20, 26, 34 },
			{ 34, 43, 56 },
			{ 31, 40, 52 },
			{ 72, 92, 118 },
			{ 164, 214, 255 },
			{ 12, 22, 34 },
			{ 230, 238, 246 },
			{ 114, 128, 146 }
		),
		Abyss = __Ixa_guiThemePreset(
			{ 7, 11, 22 },
			{ 9, 14, 28 },
			{ 12, 18, 35 },
			{ 22, 31, 58 },
			{ 20, 28, 52 },
			{ 44, 64, 120 },
			{ 72, 148, 255 },
			{ 6, 14, 34 },
			{ 226, 234, 250 },
			{ 100, 116, 152 }
		),
		Halloween = __Ixa_guiThemePreset(
			{ 18, 12, 20 },
			{ 23, 15, 25 },
			{ 28, 18, 30 },
			{ 46, 30, 48 },
			{ 43, 28, 44 },
			{ 104, 62, 40 },
			{ 255, 138, 36 },
			{ 36, 16, 4 },
			{ 246, 234, 224 },
			{ 146, 120, 128 }
		),
		Haunted = __Ixa_guiThemePreset(
			{ 14, 12, 20 },
			{ 18, 15, 26 },
			{ 22, 18, 32 },
			{ 38, 31, 54 },
			{ 35, 29, 50 },
			{ 70, 96, 64 },
			{ 156, 255, 110 },
			{ 14, 30, 8 },
			{ 232, 240, 228 },
			{ 120, 116, 140 }
		),
		Christmas = __Ixa_guiThemePreset(
			{ 12, 20, 15 },
			{ 15, 25, 19 },
			{ 19, 30, 23 },
			{ 32, 50, 38 },
			{ 30, 46, 35 },
			{ 100, 54, 56 },
			{ 236, 72, 80 },
			{ 34, 8, 10 },
			{ 240, 244, 236 },
			{ 120, 142, 128 }
		),
		Valentine = __Ixa_guiThemePreset(
			{ 24, 12, 17 },
			{ 30, 14, 21 },
			{ 36, 17, 25 },
			{ 58, 27, 40 },
			{ 54, 25, 37 },
			{ 130, 56, 84 },
			{ 255, 92, 140 },
			{ 40, 8, 20 },
			{ 252, 232, 240 },
			{ 160, 112, 132 }
		),
		Lunar = __Ixa_guiThemePreset(
			{ 22, 10, 10 },
			{ 28, 12, 12 },
			{ 34, 15, 14 },
			{ 54, 24, 22 },
			{ 50, 22, 20 },
			{ 130, 92, 40 },
			{ 246, 196, 84 },
			{ 38, 16, 6 },
			{ 250, 236, 222 },
			{ 160, 120, 108 }
		),
		Tropical = __Ixa_guiThemePreset(
			{ 10, 22, 24 },
			{ 12, 27, 30 },
			{ 15, 33, 36 },
			{ 26, 54, 58 },
			{ 24, 50, 54 },
			{ 44, 110, 110 },
			{ 255, 170, 90 },
			{ 36, 18, 6 },
			{ 232, 246, 244 },
			{ 104, 144, 142 }
		),
		Dracula = __Ixa_guiThemePreset(
			{ 24, 25, 33 },
			{ 29, 30, 40 },
			{ 34, 36, 47 },
			{ 52, 55, 70 },
			{ 48, 50, 64 },
			{ 98, 114, 164 },
			{ 189, 147, 249 },
			{ 26, 18, 44 },
			{ 246, 246, 238 },
			{ 126, 132, 168 }
		),
		Coffee = __Ixa_guiThemePreset(
			{ 20, 16, 13 },
			{ 25, 20, 16 },
			{ 30, 24, 19 },
			{ 48, 39, 31 },
			{ 45, 36, 29 },
			{ 104, 82, 62 },
			{ 214, 170, 124 },
			{ 32, 22, 12 },
			{ 240, 230, 218 },
			{ 142, 124, 108 }
		),
	}
	__Ixa_guiLibrary.ThemeName = "Midnight"
	__Ixa_guiLibrary.Assets = {
		Shadow = "rbxassetid://6014261993",
		Glow = "rbxassetid://8992230677",
		Logo = "rbxthumb://type=Asset&id=122212432133342&w=420&h=420",
	}
	local __Ixa_guiIcons = {
		["activity"] = "rbxassetid://94212016861936",
		["app-window"] = "rbxassetid://93142176757189",
		["arrow-down-up"] = "rbxassetid://85780258549577",
		["arrow-up-right"] = "rbxassetid://129280608535523",
		["bell"] = "rbxassetid://97392696311902",
		["box"] = "rbxassetid://101768155599700",
		["check"] = "rbxassetid://93898873302694",
		["chevron-down"] = "rbxassetid://134243273101015",
		["chevron-left"] = "rbxassetid://73780377692148",
		["chevron-right"] = "rbxassetid://92473583511724",
		["chevron-up"] = "rbxassetid://122444883127455",
		["chevrons-up-down"] = "rbxassetid://131833120209646",
		["circle-check"] = "rbxassetid://85262178816537",
		["circle-x"] = "rbxassetid://76821953846248",
		["clipboard-check"] = "rbxassetid://92649798577170",
		["clock"] = "rbxassetid://121808839832144",
		["cloud"] = "rbxassetid://121226497050352",
		["cloud-off"] = "rbxassetid://131907154501444",
		["copy"] = "rbxassetid://78979572434545",
		["cpu"] = "rbxassetid://77549309870247",
		["crosshair"] = "rbxassetid://134242818164054",
		["download"] = "rbxassetid://134814648082393",
		["eye"] = "rbxassetid://100033680381365",
		["eye-off"] = "rbxassetid://135928786788378",
		["flag"] = "rbxassetid://78183383236196",
		["folder"] = "rbxassetid://80846616596607",
		["gamepad-2"] = "rbxassetid://92483947987410",
		["gauge"] = "rbxassetid://110273524101447",
		["globe"] = "rbxassetid://114238209622913",
		["grip-vertical"] = "rbxassetid://137183678565296",
		["heart"] = "rbxassetid://116559368303288",
		["history"] = "rbxassetid://123980022019922",
		["house"] = "rbxassetid://98755624629571",
		["image"] = "rbxassetid://112751259236831",
		["info"] = "rbxassetid://124560466474914",
		["keyboard"] = "rbxassetid://121474456068237",
		["layers"] = "rbxassetid://81973586053257",
		["layout-grid"] = "rbxassetid://81344910161871",
		["link"] = "rbxassetid://131607023382430",
		["list"] = "rbxassetid://113179976918783",
		["list-checks"] = "rbxassetid://99809353635593",
		["list-ordered"] = "rbxassetid://83212528113913",
		["map-pin"] = "rbxassetid://84279202219901",
		["menu"] = "rbxassetid://77021539815611",
		["message-circle"] = "rbxassetid://127255077587058",
		["minimize-2"] = "rbxassetid://116269596042539",
		["monitor"] = "rbxassetid://72664649203050",
		["mouse-pointer-click"] = "rbxassetid://107150227368485",
		["move-diagonal-2"] = "rbxassetid://117298577948096",
		["option"] = "rbxassetid://100776883894054",
		["palette"] = "rbxassetid://86350350950064",
		["panels-top-left"] = "rbxassetid://79858853850600",
		["picture-in-picture-2"] = "rbxassetid://112803319544468",
		["refresh-cw"] = "rbxassetid://138133190015277",
		["rotate-ccw"] = "rbxassetid://110116685948665",
		["search"] = "rbxassetid://121018724060431",
		["search-x"] = "rbxassetid://137319957522951",
		["server"] = "rbxassetid://92188766517878",
		["settings"] = "rbxassetid://80758916183665",
		["share"] = "rbxassetid://87340985053299",
		["shield-alert"] = "rbxassetid://114995877719925",
		["shuffle"] = "rbxassetid://132382786975101",
		["sliders-horizontal"] = "rbxassetid://85538382643347",
		["star"] = "rbxassetid://136141469398409",
		["swords"] = "rbxassetid://81872698913435",
		["table"] = "rbxassetid://109109148250737",
		["target"] = "rbxassetid://87563802520297",
		["terminal"] = "rbxassetid://106783148545356",
		["text-cursor-input"] = "rbxassetid://107551944047171",
		["timer"] = "rbxassetid://85473888890506",
		["toggle-right"] = "rbxassetid://90411952142550",
		["trash-2"] = "rbxassetid://109843431391323",
		["triangle-alert"] = "rbxassetid://125920361880643",
		["type"] = "rbxassetid://133543553793564",
		["user"] = "rbxassetid://81589895647169",
		["user-check"] = "rbxassetid://81775205032725",
		["user-x"] = "rbxassetid://139748155894754",
		["users"] = "rbxassetid://115398113982385",
		["wifi"] = "rbxassetid://104669375183960",
		["x"] = "rbxassetid://110786993356448",
		["zap"] = "rbxassetid://130551565616516",
	}
	__Ixa_guiLibrary.IconsLicense = [==[MIT License

Copyright (c) 2025 Footages

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]==]
	local function __Ixa_guiGetIcons()
		return __Ixa_guiIcons
	end
	function __Ixa_guiLibrary:LoadFont()
		return false
	end
	function __Ixa_guiLibrary:PreloadIcons()
		return __Ixa_guiGetIcons() ~= false
	end
	local function __Ixa_guiAssetUri(w)
		if type(w) == "number" then
			return "rbxassetid://" .. string.format("%.0f", w)
		end
		if type(w) == "string" then
			if w:match("^%d+$") then
				return "rbxassetid://" .. w
			end
			if w:find("^rbxassetid://") or w:find("^rbxasset://") or w:find("^rbxthumb://") or w:find("^http") then
				return w
			end
		end
		return nil
	end
	local function __Ixa_guiResolveIcon(x)
		if typeof(x) == "table" then
			return __Ixa_guiAssetUri(x.Image) or x.Image, x.RectOffset, x.RectSize, true, x.Tint == true
		end
		local y = __Ixa_guiAssetUri(x)
		if y then
			return y, nil, nil, true, false
		end
		if type(x) ~= "string" then
			return nil
		end
		local z = x:gsub("^lucide:", "")
		local A = __Ixa_guiGetIcons()
		if not A then
			return nil
		end
		local B = (A.Icons and A.Icons[z]) or A[z]
		if type(B) == "table" then
			local C = B.Image
			if type(C) == "number" then
				C = "rbxassetid://" .. tostring(C)
			end
			local D = (A.Spritesheets and A.Spritesheets[tostring(C)]) or C
			return D, B.ImageRectPosition, B.ImageRectSize
		elseif type(B) == "string" then
			return B
		end
		warn("[AirFlow] unknown lucide icon: " .. z)
		return nil
	end
	local __Ixa_guiDefaultIcon = "chevron-right"
	local __Ixa_guiFontFamily = "rbxasset://fonts/families/BuilderSans.json"
	__Ixa_guiLibrary.Fonts = {
		Regular = Font.new(__Ixa_guiFontFamily, Enum.FontWeight.Regular),
		Medium = Font.new(__Ixa_guiFontFamily, Enum.FontWeight.Medium),
		Bold = Font.new(__Ixa_guiFontFamily, Enum.FontWeight.SemiBold),
	}
	local __Ixa_guiTheme = __Ixa_guiLibrary.Theme
	local __Ixa_guiAssets = __Ixa_guiLibrary.Assets
	local function __Ixa_guiDecodeBase64(D)
		local E = {}
		local F = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/]]
		for G = 1, #F do
			E[F:byte(G)] = G - 1
		end
		local G = {}
		for H = 1, #D, 4 do
			local I, J, K, L = D:byte(H, H + 3)
			local M = E[I] * 262144 + E[J] * 4096 + (E[K] or 0) * 64 + (E[L] or 0)
			local N, O, P = M // 65536, M // 256 % 256, M % 256
			if L ~= 61 then
				G[#G + 1] = string.char(N, O, P)
			elseif K ~= 61 then
				G[#G + 1] = string.char(N, O)
			else
				G[#G + 1] = string.char(N)
			end
		end
		return table.concat(G)
	end
	__Ixa_guiAssets.Logos = { Robscript = { Logo = __Ixa_guiAssets.Logo } }
	pcall(function()
		if type(writefile) ~= "function" or typeof(getcustomasset) ~= "function" then
			return
		end
		local D = "IxaHub_HallowedAssets"
		if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(D) then
			makefolder(D)
		end
		local function E(F, G)
			local H = D .. "/" .. F
			local padding = G:sub(-2) == "==" and 2 or G:sub(-1) == "=" and 1 or 0
			local expected = math.floor(#G / 4) * 3 - padding
			if type(isfile) == "function" and type(readfile) == "function" then
				local existsOk, exists = pcall(isfile, H)
				if existsOk and exists then
					local readOk, cached = pcall(readfile, H)
					if readOk and type(cached) == "string" and #cached == expected then
						local assetOk, asset = pcall(getcustomasset, H)
						if assetOk and type(asset) == "string" and asset ~= "" then
							return asset
						end
					end
				end
			end
			local I = __Ixa_guiDecodeBase64(G)
			writefile(H, I)
			local K = getcustomasset(H)
			if type(K) == "string" and K ~= "" then
				return K
			end
			return nil
		end
		local F = E(
			"IxaLogo3.png",
			[[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]]
		)
		if F then
			__Ixa_guiAssets.Logo = F
			__Ixa_guiAssets.LogoSmall = E(
				"IxaLogoSmall3.png",
				[[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]]
			)
			__Ixa_guiAssets.LogoTint = false
			__Ixa_guiAssets.Logos.IxaHub = { Logo = __Ixa_guiAssets.Logo, LogoSmall = __Ixa_guiAssets.LogoSmall }
		end
	end)
	local __Ixa_guiFonts = __Ixa_guiLibrary.Fonts
	local __Ixa_guiTouch = __Ixa_guiInputService.TouchEnabled and not __Ixa_guiInputService.KeyboardEnabled
	__Ixa_guiLibrary.Touch = __Ixa_guiTouch
	local __Ixa_guiSidebarWidth = 188
	local __Ixa_guiHeaderHeight = 62
	local __Ixa_guiTabHeight = 34
	local __Ixa_guiCardHeight = __Ixa_guiTouch and 54 or 48
	local __Ixa_guiDescHeight = __Ixa_guiTouch and 70 or 64
	local __Ixa_guiOptionHeight = __Ixa_guiTouch and 40 or 34
	local __Ixa_guiChipHeight = __Ixa_guiTouch and 34 or 28
	local __Ixa_guiProfileHeight = 64
	local __Ixa_guiMinWidth = 176
	local __Ixa_guiBreakpoint = 440
	local __Ixa_guiControlStyles = {
		Card = {
			Compact = false,
			Height = __Ixa_guiCardHeight,
			DescHeight = __Ixa_guiDescHeight,
			Chip = __Ixa_guiChipHeight,
			Option = __Ixa_guiOptionHeight,
			TextSize = 14,
			DescSize = 13,
			TitleHeight = 18,
			DescGap = 20,
			DescLine = 17,
			Slider = __Ixa_guiDescHeight,
		},
		Row = {
			Compact = true,
			Height = __Ixa_guiTouch and 40 or 32,
			DescHeight = __Ixa_guiTouch and 54 or 46,
			Chip = __Ixa_guiTouch and 30 or 24,
			Option = __Ixa_guiTouch and 34 or 28,
			TextSize = 13,
			DescSize = 12,
			TitleHeight = 16,
			DescGap = 17,
			DescLine = 15,
			Slider = __Ixa_guiTouch and 54 or 46,
		},
	}
	local __Ixa_guiTweenCache = {}
	local __Ixa_guiThemeBindings = {}
	local __Ixa_guiThemeCallbacks = {}
	local __Ixa_guiColorKeys = {}
	local __Ixa_guiPruneState = {}
	local __Ixa_guiBindingCount = 0
	local __Ixa_guiPruneLimit = 4000
	local function __Ixa_guiPruneSet(Y, Z)
		for _ in pairs(Y) do
			if _.Parent == nil then
				if __Ixa_guiPruneState[_] then
					Y[_] = nil
					__Ixa_guiPruneState[_] = nil
					if Z then
						__Ixa_guiBindingCount -= 1
					end
				else
					__Ixa_guiPruneState[_] = true
				end
			else
				__Ixa_guiPruneState[_] = nil
			end
		end
	end
	local function __Ixa_guiPruneTheme()
		__Ixa_guiPruneSet(__Ixa_guiThemeBindings, true)
		__Ixa_guiPruneSet(__Ixa_guiThemeCallbacks, false)
		__Ixa_guiPruneLimit = math.max(4000, __Ixa_guiBindingCount * 2)
	end
	local function __Ixa_guiColorKey(_)
		return math.floor(_.R * 255 + 0.5) .. "," .. math.floor(_.G * 255 + 0.5) .. "," .. math.floor(_.B * 255 + 0.5)
	end
	local function __Ixa_guiReindexColors()
		table.clear(__Ixa_guiColorKeys)
		for aa = #__Ixa_guiThemeKeys, 1, -1 do
			local ab = __Ixa_guiThemeKeys[aa]
			__Ixa_guiColorKeys[__Ixa_guiColorKey(__Ixa_guiLibrary.Theme[ab])] = ab
		end
	end
	__Ixa_guiReindexColors()
	local function __Ixa_guiTrackColors(ab, ac)
		if __Ixa_guiLibrary._disposed then
			return
		end
		for ad, ae in pairs(ac) do
			if typeof(ae) == "Color3" then
				local af = __Ixa_guiColorKeys[__Ixa_guiColorKey(ae)]
				local ag = __Ixa_guiThemeBindings[ab]
				if af then
					if not ag then
						ag = {}
						__Ixa_guiThemeBindings[ab] = ag
						__Ixa_guiBindingCount += 1
						if __Ixa_guiBindingCount >= __Ixa_guiPruneLimit then
							__Ixa_guiPruneTheme()
						end
					end
					ag[ad] = af
				elseif ag then
					ag[ad] = nil
				end
			end
		end
	end
	local __Ixa_guiCurrentColors = table.clone(__Ixa_guiLibrary.Theme)
	local __Ixa_guiThemeConnection = nil
	local function __Ixa_guiAssignColors(ae, af, ag)
		for ah, ai in pairs(af) do
			local aj = ag[ai]
			if aj then
				ae[ah] = aj
			end
		end
	end
	local function __Ixa_guiApplyColors(af)
		for ag, ah in pairs(__Ixa_guiThemeBindings) do
			pcall(__Ixa_guiAssignColors, ag, ah, af)
		end
	end
	local function __Ixa_guiAnimateTheme(ag)
		if __Ixa_guiThemeConnection then
			__Ixa_guiThemeConnection:Disconnect()
			__Ixa_guiThemeConnection = nil
		end
		local ah, ai = {}, {}
		for aj, ak in ipairs(__Ixa_guiThemeKeys) do
			local al = __Ixa_guiLibrary.Theme[ak]
			local am = __Ixa_guiCurrentColors[ak] or al
			if am ~= al then
				ah[ak] = am
				ai[ak] = am
			end
		end
		local function aj()
			for ak, al in ipairs(__Ixa_guiThemeKeys) do
				ai[al] = __Ixa_guiLibrary.Theme[al]
				__Ixa_guiCurrentColors[al] = __Ixa_guiLibrary.Theme[al]
			end
			__Ixa_guiApplyColors(ai)
		end
		if ag <= 0 or next(ah) == nil then
			aj()
			return
		end
		local ak = 0
		__Ixa_guiThemeConnection = __Ixa_guiRunService.Heartbeat:Connect(function(al)
			ak += al
			if ak >= ag then
				__Ixa_guiThemeConnection:Disconnect()
				__Ixa_guiThemeConnection = nil
				aj()
				return
			end
			local am = 1 - (1 - ak / ag) ^ 5
			for an, ao in pairs(ah) do
				local ap = ao:Lerp(__Ixa_guiLibrary.Theme[an], am)
				ai[an] = ap
				__Ixa_guiCurrentColors[an] = ap
			end
			__Ixa_guiApplyColors(ai)
		end)
	end
	local function __Ixa_guiBindTheme(ah, ai)
		__Ixa_guiThemeCallbacks[ah] = ai
		ai()
	end
	local function __Ixa_guiTween(ai, aj, ak, al, am, an)
		ak = ak or 0.2
		if not an then
			__Ixa_guiTrackColors(ai, aj)
		end
		if ak <= 0 then
			for ao, ap in pairs(aj) do
				ai[ao] = ap
			end
			return nil
		end
		al = al or Enum.EasingStyle.Quart
		am = am or Enum.EasingDirection.Out
		local ao = ak .. al.Name .. am.Name
		local ap = __Ixa_guiTweenCache[ao]
		if not ap then
			ap = TweenInfo.new(ak, al, am)
			__Ixa_guiTweenCache[ao] = ap
		end
		local aq = __Ixa_guiTweenService:Create(ai, ap, aj)
		aq:Play()
		return aq
	end
	local function __Ixa_guiNew(aj, ak, al)
		local am = Instance.new(aj)
		for an, ao in pairs(ak) do
			if an ~= "Parent" then
				am[an] = ao
			end
		end
		__Ixa_guiTrackColors(am, ak)
		if al then
			for an, ao in ipairs(al) do
				ao.Parent = am
			end
		end
		if ak.Parent then
			am.Parent = ak.Parent
		end
		return am
	end
	__Ixa_guiLibrary.Roundness = 1
	__Ixa_guiLibrary._cornerBases = {}
	local function __Ixa_guiCorner(ak, al)
		al = al or UDim.new(0, 8)
		local am = __Ixa_guiNew(
			"UICorner",
			{ CornerRadius = al.Scale == 0 and UDim.new(0, math.floor(al.Offset * __Ixa_guiLibrary.Roundness + 0.5)) or al, Parent = ak }
		)
		if al.Scale == 0 then
			__Ixa_guiLibrary._cornerBases[am] = al.Offset
		end
		return am
	end
	function __Ixa_guiLibrary._fixedCorner(ak, al)
		return __Ixa_guiNew("UICorner", { CornerRadius = al, Parent = ak })
	end
	function __Ixa_guiLibrary._radius(ak)
		return math.floor(ak * __Ixa_guiLibrary.Roundness + 0.5)
	end
	local function __Ixa_guiStroke(al, am, an, ao)
		return __Ixa_guiNew(
			"UIStroke",
			{
				Color = am or __Ixa_guiTheme.Stroke,
				Transparency = an or 0,
				Thickness = ao or 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = al,
			}
		)
	end
	local function __Ixa_guiPadding(am, an, ao, ap, aq)
		return __Ixa_guiNew(
			"UIPadding",
			{
				PaddingLeft = UDim.new(0, an or 0),
				PaddingRight = UDim.new(0, ao or 0),
				PaddingTop = UDim.new(0, ap or 0),
				PaddingBottom = UDim.new(0, aq or 0),
				Parent = am,
			}
		)
	end
	local function __Ixa_guiLabel(an)
		local ao = {
			BackgroundTransparency = 1,
			TextColor3 = __Ixa_guiTheme.Text,
			TextSize = 14,
			FontFace = __Ixa_guiFonts.Medium,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
		}
		for ap, aq in pairs(an) do
			ao[ap] = aq
		end
		return __Ixa_guiNew("TextLabel", ao)
	end
	local function an(ao, ap, aq, ar, as)
		local at = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = aq,
				Size = ap,
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Glow,
				ImageColor3 = Color3.fromRGB(226, 218, 230),
				ImageTransparency = 1,
				Visible = false,
				ZIndex = 0,
				Parent = ao,
			}
		)
		local au = __Ixa_guiNew("UIGradient", { Rotation = as or 90, Parent = at })
		__Ixa_guiBindTheme(au, function()
			au.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), __Ixa_guiTheme.Accent)
		end)
		return at
	end
	local function ao(ap)
		return __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 0,
				Parent = ap,
			}
		)
	end
	local ap = 1.35
	local function __Ixa_guiApplyIcon(ar, as, at)
		local au, av, aw, ax, ay = __Ixa_guiResolveIcon(as)
		if not au then
			return
		end
		ar.Image = au
		ar.ImageRectOffset = av or Vector2.zero
		ar.ImageRectSize = aw or Vector2.zero
		if (as == __Ixa_guiAssets.Logo or as == __Ixa_guiAssets.LogoSmall) and __Ixa_guiAssets.LogoTint ~= false then
			ay = true
		end
		local az = ax and not ay
		ar:SetAttribute("CustomIcon", az or nil)
		if az then
			__Ixa_guiTween(ar, { ImageColor3 = Color3.new(1, 1, 1) }, 0)
		end
		local aA = ax and not at and as ~= __Ixa_guiAssets.Logo and as ~= __Ixa_guiAssets.LogoSmall and (typeof(as) == "table" and tonumber(
			as.Scale
		) or ap) or 1
		local aB = ar:FindFirstChild("CustomIconScale")
		if aA ~= 1 then
			aB = aB or __Ixa_guiNew("UIScale", { Name = "CustomIconScale", Parent = ar })
			aB.Scale = aA
		elseif aB then
			aB:Destroy()
		end
	end
	local function __Ixa_guiTintIcon(as, at, au, av)
		if as:GetAttribute("CustomIcon") then
			__Ixa_guiTween(as, { ImageTransparency = au and 0 or 0.4 }, av)
		else
			__Ixa_guiTween(as, { ImageColor3 = at }, av)
		end
	end
	local function __Ixa_guiParent()
		local at
		pcall(function()
			if typeof(gethui) == "function" then
				at = gethui()
			end
		end)
		if typeof(at) == "Instance" then
			return at
		end
		local au
		pcall(function()
			au = game:GetService("CoreGui")
			local av = Instance.new("Folder")
			av.Parent = au
			av:Destroy()
		end)
		if au then
			return au
		end
		return __Ixa_guiPlayer:WaitForChild("PlayerGui")
	end
	local at, au = nil, Vector2.zero
	local function __Ixa_guiMousePosition()
		local aw = time()
		if at ~= aw then
			at = aw
			au = __Ixa_guiGuiService:GetGuiInset()
		end
		return __Ixa_guiInputService:GetMouseLocation() - au
	end
	local function __Ixa_guiIsPointerPress(ax)
		return ax.UserInputType == Enum.UserInputType.MouseButton1 or ax.UserInputType == Enum.UserInputType.Touch
	end
	local function __Ixa_guiIsTouch()
		return __Ixa_guiInputService:GetLastInputType() == Enum.UserInputType.Touch
	end
	local function __Ixa_guiClickGuard(az, aA)
		local aB
		az.InputBegan:Connect(function(aC)
			if __Ixa_guiIsPointerPress(aC) then
				local aD = aA()
				aB = aD and aD.CanvasPosition
			end
		end)
		return function()
			local aC = aA()
			return not (aB and aC and (aC.CanvasPosition - aB).Magnitude > 4)
		end
	end
	local function __Ixa_guiContainsPoint(aA, aB)
		local aC, aD = aB.AbsolutePosition, aB.AbsoluteSize
		return aA.X >= aC.X and aA.X <= aC.X + aD.X and aA.Y >= aC.Y and aA.Y <= aC.Y + aD.Y
	end
	local function __Ixa_guiIsPointerMove(aB)
		return aB.UserInputType == Enum.UserInputType.MouseMovement or aB.UserInputType == Enum.UserInputType.Touch
	end
	local function __Ixa_guiIcon(aC, aD, aE, aF)
		local aG = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = aF,
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				Parent = aC,
			}
		)
		local aH = __Ixa_guiNew(
			"ImageLabel",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ImageColor3 = aE, ScaleType = Enum.ScaleType.Fit, Parent = aG }
		)
		__Ixa_guiApplyIcon(aH, aD)
		return aG, aH
	end
	local function aC(aD, aE, aF)
		local aG = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(aE, 0.5),
				Position = UDim2.new(aE, aF, 0.5, 0),
				Size = UDim2.fromOffset(18, 18),
				BackgroundTransparency = 1,
				Parent = aD,
			}
		)
		local aH = {}
		local aI = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ScaleType = Enum.ScaleType.Fit,
				Parent = aG,
			}
		)
		__Ixa_guiApplyIcon(aI, "chevron-down")
		if aI.Image ~= "" then
			function aH:Set(aJ)
				__Ixa_guiTween(
					aI,
					{ Rotation = aJ and 180 or 0, ImageColor3 = aJ and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted },
					0.3,
					Enum.EasingStyle.Quint
				)
			end
			return aH
		end
		aI:Destroy()
		local function aJ(aK, aL)
			return __Ixa_guiLabel({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(18, 18),
				Text = "\u{203a}",
				TextSize = 22,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextTransparency = aL,
				Rotation = aK,
				Parent = aG,
			})
		end
		local aK = aJ(90, 0)
		local aL = aJ(270, 1)
		function aH:Set(aM)
			__Ixa_guiTween(aK, { TextTransparency = aM and 1 or 0 }, 0.2)
			__Ixa_guiTween(aL, { TextTransparency = aM and 0 or 1, TextColor3 = aM and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted }, 0.2)
		end
		return aH
	end
	local __Ixa_guiRipplePool = {}
	local function __Ixa_guiRipple(aF)
		local aG = __Ixa_guiMousePosition()
		local aH = math.max(aF.AbsoluteSize.X, aF.AbsoluteSize.Y) * 2.2
		local aI = table.remove(__Ixa_guiRipplePool)
		if aI and not pcall(function()
			aI.Parent = nil
		end) then
			aI = nil
		end
		if not aI then
			aI = __Ixa_guiNew("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = __Ixa_guiTheme.Accent, BorderSizePixel = 0 })
			__Ixa_guiCorner(aI, UDim.new(1, 0))
		end
		aI.Position = UDim2.fromOffset(aG.X - aF.AbsolutePosition.X, aG.Y - aF.AbsolutePosition.Y)
		aI.Size = UDim2.fromOffset(0, 0)
		aI.BackgroundColor3 = __Ixa_guiTheme.Accent
		aI.BackgroundTransparency = 0.82
		aI.ZIndex = aF.ZIndex + 1
		aI.Parent = aF
		__Ixa_guiTween(aI, { Size = UDim2.fromOffset(aH, aH), BackgroundTransparency = 1 }, 0.55)
		task.delay(0.55, function()
			if aI.Parent ~= aF or not aF.Parent then
				pcall(aI.Destroy, aI)
				return
			end
			aI.Parent = nil
			if #__Ixa_guiRipplePool < 4 then
				table.insert(__Ixa_guiRipplePool, aI)
			else
				aI:Destroy()
			end
		end)
	end
	local function __Ixa_guiFocusStroke(aG)
		if not aG or aG:GetAttribute("Hidden") then
			return
		end
		__Ixa_guiTween(aG, { Color = __Ixa_guiTheme.Accent, Transparency = 0.2 }, 0.08)
		task.delay(0.12, function()
			__Ixa_guiTween(aG, { Color = __Ixa_guiTheme.Stroke, Transparency = 0 }, 0.35)
		end)
	end
	local function __Ixa_guiHoverStroke(aH, aI)
		aH.MouseEnter:Connect(function()
			__Ixa_guiTween(aI, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
		end)
		aH.MouseLeave:Connect(function()
			__Ixa_guiTween(aI, { Color = __Ixa_guiTheme.Stroke }, 0.25)
		end)
	end
	local __Ixa_guiKeyLabels = {
		[Enum.KeyCode.LeftControl] = "LCtrl",
		[Enum.KeyCode.RightControl] = "RCtrl",
		[Enum.KeyCode.LeftShift] = "LShift",
		[Enum.KeyCode.RightShift] = "RShift",
		[Enum.KeyCode.LeftAlt] = "LAlt",
		[Enum.KeyCode.RightAlt] = "RAlt",
		[Enum.KeyCode.Return] = "Enter",
		[Enum.KeyCode.Escape] = "Esc",
		[Enum.KeyCode.Backspace] = "Backspace",
	}
	local function __Ixa_guiKeyName(aJ)
		if aJ == nil then
			return "None"
		end
		return __Ixa_guiKeyLabels[aJ] or aJ.Name
	end
	local function __Ixa_guiCall(aK, ...)
		if type(aK) ~= "function" then
			return
		end
		local aL, aM = pcall(aK, ...)
		if not aL then
			warn("[AirFlow] callback error: " .. tostring(aM))
		end
	end
	local function __Ixa_guiYieldCall(aL)
		local aM = nil
		task.spawn(function()
			aM = table.pack(pcall(aL))
		end)
		while aM == nil do
			task.wait()
		end
		return table.unpack(aM, 1, aM.n)
	end
	local function __Ixa_guiNumberFormat(aM, aN, aO)
		local aP = 0
		local aQ = tostring(aO)
		local aR = aQ:find("%.")
		if aR then
			aP = #aQ - aR
		end
		local aS = "%." .. aP .. "f"
		return {
			snap = function(aT)
				aT = math.floor(aT / aO + 0.5) * aO
				return math.clamp(aT, aM, aN)
			end,
			format = function(aT)
				return string.format(aS, aT)
			end,
		}
	end
	local function __Ixa_guiControlMetrics(aN)
		return aN._metrics or __Ixa_guiControlStyles.Card
	end
	local function __Ixa_guiControlWidth(aO, aP)
		local aQ = aO.AbsoluteSize.X / aP.Scale.Scale
		return math.clamp(math.floor(aQ * 0.48), 90, 220)
	end
	local function __Ixa_guiControlFrame(aP, aQ, aR, aS)
		local aT = __Ixa_guiControlMetrics(aP).Compact
		local aU = {
			Size = UDim2.new(1, 0, 0, aR),
			BackgroundColor3 = __Ixa_guiTheme.Surface2,
			BackgroundTransparency = aT and 1 or 0,
			BorderSizePixel = 0,
			LayoutOrder = aP:_nextOrder(),
			Parent = aP.List,
		}
		if aQ == "TextButton" then
			aU.AutoButtonColor = false
			aU.Text = ""
		end
		local aV = __Ixa_guiNew(aQ, aU)
		aV:SetAttribute("NoDrag", true)
		__Ixa_guiCorner(aV)
		local aW = __Ixa_guiStroke(aV, __Ixa_guiTheme.Stroke, aT and 1 or 0)
		if aT then
			aW:SetAttribute("Hidden", true)
		end
		return aV, aW
	end
	local function aP(aQ, aR, aS, aT, aU)
		aU = aU or __Ixa_guiControlStyles.Card
		local aV, aW
		if aS then
			local aX = math.floor((aU.DescHeight - (aU.DescGap + aU.DescLine)) / 2)
			aV = __Ixa_guiLabel({
				Position = UDim2.fromOffset(14, aX),
				Size = UDim2.new(1, -(14 + aT), 0, aU.TitleHeight),
				Text = aR,
				TextSize = aU.TextSize,
				Parent = aQ,
			})
			aW = __Ixa_guiLabel({
				Position = UDim2.fromOffset(14, aX + aU.DescGap),
				Size = UDim2.new(1, -(14 + aT), 0, aU.DescLine),
				Text = aS,
				TextSize = aU.DescSize,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = aQ,
			})
		else
			aV = __Ixa_guiLabel({
				Position = UDim2.fromOffset(14, 0),
				Size = UDim2.new(1, -(14 + aT), 1, 0),
				Text = aR,
				TextSize = aU.TextSize,
				Parent = aQ,
			})
		end
		return aV, aW
	end
	local function aQ(aR, aS, aT, aU, aV, aW)
		aS = __Ixa_guiOptions(aS, aT)
		local aX = __Ixa_guiControlMetrics(aR)
		local aY = aS.Desc and aX.DescHeight or aX.Height
		local aZ, a_ = __Ixa_guiControlFrame(aR, aU or "Frame", aY, aS)
		__Ixa_guiHoverStroke(aZ, a_)
		local a0, a1
		if aV then
			a0, a1 = aP(aZ, aS.Name or aW, aS.Desc, aV, aX)
		end
		return aS, aZ, a_, aY, a0, a1
	end
	local function aR(aS, aT, aU)
		if aS then
			aS.Size = UDim2.new(1, -(14 + aU), aS.Size.Y.Scale, aS.Size.Y.Offset)
		end
		if aT then
			aT.Size = UDim2.new(1, -(14 + aU), 0, aT.Size.Y.Offset)
		end
	end
	local __Ixa_guiGroup = {}
	__Ixa_guiGroup.__index = __Ixa_guiGroup
	function __Ixa_guiGroup:_nextOrder()
		self._order = self._order + 1
		return self._order
	end
	function __Ixa_guiGroup:Section(aT)
		local aU = not (type(aT) == "table" and aT.Visible == false)
		if type(aT) == "table" then
			aT = aT.Name or aT.Title or ""
		end
		local aV = __Ixa_guiControlMetrics(self).Compact and 14 or 2
		local aW = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, LayoutOrder = self:_nextOrder(), Parent = self.List }
		)
		local aX = __Ixa_guiLabel({
			Position = UDim2.fromOffset(aV, 8),
			Size = UDim2.new(0, 0, 0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = string.upper(aT),
			TextSize = 12,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextTruncate = Enum.TextTruncate.None,
			Parent = aW,
		})
		local aY = aV == 2 and 0 or aV
		local aZ = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -aY, 0, 16),
				Size = UDim2.new(1, -12, 0, 1),
				BackgroundColor3 = __Ixa_guiTheme.Stroke,
				BorderSizePixel = 0,
				Parent = aW,
			}
		)
		local function a_()
			aZ.Size = UDim2.new(1, -(aX.AbsoluteSize.X / self.Window.Scale.Scale + aV + 12 + aY), 0, 1)
		end
		aX:GetPropertyChangedSignal("AbsoluteSize"):Connect(a_)
		task.defer(a_)
		return __Ixa_guiRegister(self, { Visible = aU }, {
			Set = function(a0, a1)
				aX.Text = string.upper(a1)
			end,
		}, aW, "Section")
	end
	function __Ixa_guiGroup:Divider(aT)
		local aU = type(aT) == "table" and (aT.Text or aT.Name) or type(aT) == "string" and aT or nil
		if aU then
			local aV = __Ixa_guiControlMetrics(self).Compact and 14 or 2
			local aW = __Ixa_guiNew(
				"Frame",
				{ Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = self:_nextOrder(), Parent = self.List }
			)
			local aX = __Ixa_guiLabel({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0, 0, 0, 14),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = aU,
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextTruncate = Enum.TextTruncate.None,
				Parent = aW,
			})
			__Ixa_guiPadding(aX, 8, 8)
			local aY = {}
			for aZ, a_ in ipairs({ 0, 1 }) do
				aY[aZ] = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(a_, 0.5),
						Position = UDim2.new(a_, a_ == 0 and aV or -aV, 0.5, 0),
						Size = UDim2.new(0.5, -aV, 0, 1),
						BackgroundColor3 = __Ixa_guiTheme.Stroke,
						BorderSizePixel = 0,
						Parent = aW,
					}
				)
			end
			local function aZ()
				local a_ = aX.AbsoluteSize.X / self.Window.Scale.Scale / 2
				for a0, a1 in ipairs(aY) do
					a1.Size = UDim2.new(0.5, -(aV + a_), 0, 1)
				end
			end
			aX:GetPropertyChangedSignal("AbsoluteSize"):Connect(aZ)
			task.defer(aZ)
			return __Ixa_guiRegister(self, { Visible = not (type(aT) == "table" and aT.Visible == false) }, {
				Set = function(a_, a0)
					aX.Text = tostring(a0)
				end,
			}, aW, "Divider")
		end
		local aV = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = __Ixa_guiTheme.Stroke,
				BorderSizePixel = 0,
				LayoutOrder = self:_nextOrder(),
				Parent = self.List,
			}
		)
		if __Ixa_guiControlMetrics(self).Compact then
			aV.BackgroundTransparency = 1
			aV.Size = UDim2.new(1, 0, 0, 9)
			__Ixa_guiNew(
				"Frame",
				{
					Position = UDim2.fromOffset(14, 4),
					Size = UDim2.new(1, -28, 0, 1),
					BackgroundColor3 = __Ixa_guiTheme.Stroke,
					BorderSizePixel = 0,
					Parent = aV,
				}
			)
		end
		return __Ixa_guiRegister(self, { Visible = not (type(aT) == "table" and aT.Visible == false) }, {}, aV, "Divider")
	end
	function __Ixa_guiGroup:Label(aT)
		aT = __Ixa_guiOptions(aT, { Name = "Text", Title = "Text" })
		local aU = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 18),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = __Ixa_guiLibrary._rich(aT.Text or ""),
			TextSize = 14,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiLibrary._color(aT.Color) or __Ixa_guiTheme.Text,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			RichText = true,
			LayoutOrder = self:_nextOrder(),
			Parent = self.List,
		})
		if __Ixa_guiControlMetrics(self).Compact then
			__Ixa_guiPadding(aU, 14, 14)
		else
			__Ixa_guiPadding(aU, 2, 2)
		end
		local aV = {
			Set = function(aV, aW)
				aU.Text = __Ixa_guiLibrary._rich(aW)
			end,
			Get = function()
				return aU.Text
			end,
			SetColor = function(aV, aW)
				__Ixa_guiTween(aU, { TextColor3 = __Ixa_guiLibrary._color(aW) or __Ixa_guiTheme.Text }, 0.25)
			end,
		}
		if type(aT.Update) == "function" then
			local aW = math.max(tonumber(aT.UpdateRate) or 1, 0.05)
			local aX = true
			aV._listeners = aV._listeners or {}
			table.insert(aV._listeners, function()
				aX = false
			end)
			task.spawn(function()
				while aX and aU.Parent do
					local aY, aZ = __Ixa_guiYieldCall(aT.Update)
					if aY and aZ ~= nil then
						aU.Text = __Ixa_guiLibrary._rich(aZ)
					elseif not aY then
						warn("[AirFlow] label update error: " .. tostring(aZ))
					end
					task.wait(aW)
				end
			end)
			function aV:SetUpdateRate(aY)
				aW = math.max(tonumber(aY) or aW, 0.05)
			end
		end
		return __Ixa_guiRegister(self, aT, aV, aU, "Label")
	end
	function __Ixa_guiGroup:Paragraph(aT)
		aT = __Ixa_guiOptions(aT, { Title = "Name" })
		local aU = __Ixa_guiControlFrame(self, "Frame", 0, aT)
		aU.AutomaticSize = Enum.AutomaticSize.Y
		if __Ixa_guiControlMetrics(self).Compact then
			__Ixa_guiPadding(aU, 14, 14, 6, 8)
		else
			__Ixa_guiPadding(aU, 14, 14, 11, 12)
		end
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = aU })
		__Ixa_guiLabel({ Size = UDim2.new(1, 0, 0, 14), Text = aT.Name or "", LayoutOrder = 1, Parent = aU })
		local aV = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = __Ixa_guiLibrary._rich(aT.Content or ""),
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			TextYAlignment = Enum.TextYAlignment.Top,
			RichText = true,
			LayoutOrder = 2,
			Parent = aU,
		})
		return __Ixa_guiRegister(self, aT, {
			Set = function(aW, aX)
				aV.Text = __Ixa_guiLibrary._rich(aX)
			end,
		}, aU, "Paragraph")
	end
	local function aT(aU, aV)
		local aW = aV.Style == "Primary"
		local aX = __Ixa_guiTouch and 34 or 28
		local aY = aX + 6 + (aV.Desc and 16 or 0)
		local aZ = __Ixa_guiControlFrame(aU, "TextButton", aY, aV)
		local a_ = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(14, 3),
				Size = UDim2.new(1, -28, 0, aX),
				BackgroundColor3 = aW and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3,
				BackgroundTransparency = aW and 0.12 or 0.45,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = aZ,
			}
		)
		__Ixa_guiCorner(a_, UDim.new(0, 6))
		local a0 = __Ixa_guiStroke(a_, aW and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke, aW and 0.4 or 0)
		local a1 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Parent = a_,
			}
		)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = a1,
			}
		)
		local a2 = aW and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Text
		if aV.Icon then
			local a3 = __Ixa_guiNew(
				"ImageLabel",
				{
					Size = UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					ImageColor3 = aW and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Accent,
					ScaleType = Enum.ScaleType.Fit,
					LayoutOrder = 1,
					Parent = a1,
				}
			)
			__Ixa_guiApplyIcon(a3, aV.Icon)
		end
		local a3 = __Ixa_guiLabel({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = aV.Name or "Button",
			TextSize = 13,
			TextColor3 = a2,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 2,
			Parent = a1,
		})
		if aV.Desc then
			__Ixa_guiLabel({
				Position = UDim2.fromOffset(14, aX + 6),
				Size = UDim2.new(1, -28, 0, 14),
				Text = aV.Desc,
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = aZ,
			})
		end
		local a4 = aW and 0.12 or 0.45
		aZ.MouseEnter:Connect(function()
			__Ixa_guiTween(a_, { BackgroundTransparency = aW and 0 or 0.2 }, 0.12)
			__Ixa_guiTween(a0, aW and { Transparency = 0 } or { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
		end)
		aZ.MouseLeave:Connect(function()
			__Ixa_guiTween(a_, { BackgroundTransparency = a4 }, 0.25)
			__Ixa_guiTween(a0, aW and { Transparency = 0.4 } or { Color = __Ixa_guiTheme.Stroke }, 0.25)
		end)
		aZ.MouseButton1Click:Connect(function()
			__Ixa_guiRipple(a_)
			__Ixa_guiCall(aV.Callback)
		end)
		return __Ixa_guiRegister(aU, aV, {
			_title = a3,
			_titleColor = a2,
			_fillHost = a_,
			SetText = function(a5, a6)
				a3.Text = a6
			end,
		}, aZ, "Button")
	end
	function __Ixa_guiGroup:Button(aU)
		aU = __Ixa_guiOptions(aU, { Title = "Name", Description = "Desc" })
		if (aU.Confirm or aU.HoldToConfirm) and not aU._gated then
			return __Ixa_guiLibrary._gateButton(self, aU)
		end
		if __Ixa_guiControlMetrics(self).Compact then
			return aT(self, aU)
		end
		local aV = aU.Style == "Primary"
		local aW = aU.Desc and __Ixa_guiDescHeight or __Ixa_guiCardHeight
		local aX, aY = __Ixa_guiControlFrame(self, "TextButton", aW, aU)
		aX.ClipsDescendants = true
		if aV then
			__Ixa_guiTween(aX, { BackgroundColor3 = __Ixa_guiTheme.Accent, BackgroundTransparency = 0.12 }, 0)
			__Ixa_guiTween(aY, { Color = __Ixa_guiTheme.Accent }, 0)
			aY.Transparency = 0.4
			aX.MouseEnter:Connect(function()
				__Ixa_guiTween(aX, { BackgroundTransparency = 0 }, 0.12)
				__Ixa_guiTween(aY, { Transparency = 0 }, 0.12)
			end)
			aX.MouseLeave:Connect(function()
				__Ixa_guiTween(aX, { BackgroundTransparency = 0.12 }, 0.25)
				__Ixa_guiTween(aY, { Transparency = 0.4 }, 0.25)
			end)
		else
			__Ixa_guiHoverStroke(aX, aY)
		end
		local aZ = aV and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Text
		local a_ = 0
		if aU.Icon then
			__Ixa_guiIcon(aX, aU.Icon, aV and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Accent, UDim2.new(0, 14, 0.5, 0))
			a_ = 26
		end
		local a0 = aP(aX, aU.Name or "Button", aU.Desc, 30)
		if a_ > 0 then
			for a1, a2 in ipairs(aX:GetChildren()) do
				if a2:IsA("TextLabel") then
					a2.Position = a2.Position + UDim2.fromOffset(a_, 0)
					a2.Size = a2.Size - UDim2.fromOffset(a_, 0)
				end
			end
		end
		if aV then
			for a1, a2 in ipairs(aX:GetChildren()) do
				if a2:IsA("TextLabel") then
					__Ixa_guiTween(a2, { TextColor3 = aZ }, 0)
				end
			end
		end
		__Ixa_guiIcon(aX, __Ixa_guiDefaultIcon, aV and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Muted, UDim2.new(1, -30, 0.5, 0))
		aX.MouseButton1Click:Connect(function()
			__Ixa_guiRipple(aX)
			__Ixa_guiCall(aU.Callback)
		end)
		return __Ixa_guiRegister(self, aU, {
			_title = a0,
			_titleColor = aZ,
			_fillHost = aX,
			SetText = function(a1, a2)
				a0.Text = a2
			end,
		}, aX, "Button")
	end
	function __Ixa_guiGroup:Toggle(aU)
		local aV, aW
		aU, aV, aW = aQ(
			self,
			aU,
			{ Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" },
			"TextButton",
			56,
			"Toggle"
		)
		local aX = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -14, 0.5, 0),
				Size = __Ixa_guiTouch and UDim2.fromOffset(44, 24) or UDim2.fromOffset(36, 20),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Parent = aV,
			}
		)
		__Ixa_guiCorner(aX, UDim.new(1, 0))
		__Ixa_guiStroke(aX, __Ixa_guiTheme.Stroke)
		local aY = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 3, 0.5, 0),
				Size = __Ixa_guiTouch and UDim2.fromOffset(18, 18) or UDim2.fromOffset(14, 14),
				BackgroundColor3 = __Ixa_guiTheme.Muted,
				BorderSizePixel = 0,
				Parent = aX,
			}
		)
		__Ixa_guiCorner(aY, UDim.new(1, 0))
		local aZ = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 24, 1, 24),
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Glow,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ImageTransparency = 1,
				ZIndex = 0,
				Parent = aX,
			}
		)
		local a_ = { Value = aU.Default == true }
		local function a0(a1)
			local a2 = a_.Value
			local a3 = a1 and 0.25 or 0
			__Ixa_guiTween(aX, { BackgroundColor3 = a2 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3 }, a3)
			__Ixa_guiTween(aZ, { ImageTransparency = a2 and 0.75 or 1 }, a3)
			local a4 = __Ixa_guiTouch and 18 or 14
			__Ixa_guiTween(
				aY,
				{
					Position = a2 and UDim2.new(0, (__Ixa_guiTouch and 44 or 36) - 3 - a4, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
					BackgroundColor3 = a2 and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Muted,
				},
				a3,
				Enum.EasingStyle.Back
			)
			if a1 then
				__Ixa_guiTween(aY, { Size = UDim2.fromOffset(a4 + 4, a4 - 2) }, 0.08)
				task.delay(0.08, function()
					__Ixa_guiTween(aY, { Size = UDim2.fromOffset(a4, a4) }, 0.2, Enum.EasingStyle.Back)
				end)
			end
		end
		local a1 = false
		function a_:Set(a2, a3)
			a2 = a2 == true
			if a2 == a_.Value then
				return
			end
			a_.Value = a2
			a0(true)
			if not a1 then
				__Ixa_guiFocusStroke(aW)
			end
			if not a3 then
				__Ixa_guiCall(aU.Callback, a2)
			end
		end
		function a_:Get()
			return a_.Value
		end
		a0(false)
		aV.MouseButton1Click:Connect(function()
			a1 = true
			a_:Set(not a_.Value)
			a1 = false
		end)
		local a2 = __Ixa_guiRegister(self, aU, a_, aV, "Toggle")
		if a_.Value then
			__Ixa_guiCall(aU.Callback, true)
		end
		return a2
	end
	function __Ixa_guiGroup:Slider(aU)
		aU = __Ixa_guiOptions(
			aU,
			{ Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default", Increment = "Step" }
		)
		local aV = aU.Min or 0
		local aW = aU.Max or 100
		local aX = aU.Step or 1
		local aY = aU.Suffix or ""
		local aZ = __Ixa_guiNumberFormat(aV, aW, aX)
		local a_ = __Ixa_guiControlMetrics(self)
		local a0 = a_.Compact
		local a1 = a_.Slider
		local a2, a3 = __Ixa_guiControlFrame(self, "Frame", a1, aU)
		__Ixa_guiHoverStroke(a2, a3)
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(14, a0 and 5 or 12),
			Size = UDim2.new(1, -120, 0, 18),
			Text = aU.Name or "Slider",
			TextSize = a_.TextSize,
			Parent = a2,
		})
		local a4 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, a0 and -14 or -10, 0, a0 and 2 or 9),
				Size = UDim2.fromOffset(40, 24),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = a2,
			}
		)
		__Ixa_guiCorner(a4, UDim.new(0, 6))
		local a5 = __Ixa_guiStroke(a4)
		local a6 = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 1, 0),
			TextSize = 13,
			TextColor3 = __Ixa_guiTheme.Accent,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextTruncate = Enum.TextTruncate.None,
			Parent = a4,
		})
		local a7 = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(9, 0),
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Text = "",
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Medium,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				Visible = false,
				Parent = a4,
			}
		)
		__Ixa_guiNew("UISizeConstraint", { MinSize = Vector2.new(14, 0), Parent = a7 })
		local a8 = __Ixa_guiLabel({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = aY,
			TextSize = 13,
			TextColor3 = __Ixa_guiTheme.Accent,
			TextTruncate = Enum.TextTruncate.None,
			Visible = false,
			Parent = a4,
		})
		local a9 = __Ixa_guiNew(
			"TextButton",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 2, Parent = a4 }
		)
		local ba = false
		local function bb(bc)
			local bd
			if ba then
				bd = 9 + a7.AbsoluteSize.X / self.Window.Scale.Scale + a8.TextBounds.X + 9
				a8.Position = UDim2.fromOffset(9 + a7.AbsoluteSize.X / self.Window.Scale.Scale, 0)
			else
				bd = a6.TextBounds.X + 18
			end
			bd = math.max(bd, 36)
			if bc then
				a4.Size = UDim2.fromOffset(bd, 24)
			else
				__Ixa_guiTween(a4, { Size = UDim2.fromOffset(bd, 24) }, 0.2)
			end
		end
		a6:GetPropertyChangedSignal("TextBounds"):Connect(function()
			if not ba then
				bb(false)
			end
		end)
		a7:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if ba then
				bb(false)
			end
		end)
		local bc = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.new(0, 14, 0, a1 - (a0 and 13 or 18)),
				Size = UDim2.new(1, -28, 0, 5),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Parent = a2,
			}
		)
		__Ixa_guiCorner(bc, UDim.new(1, 0))
		local bd =
			__Ixa_guiNew("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = __Ixa_guiTheme.Accent, BorderSizePixel = 0, Parent = bc })
		__Ixa_guiCorner(bd, UDim.new(1, 0))
		local be = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(28, 28),
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Glow,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ImageTransparency = 0.85,
				ZIndex = 2,
				Parent = bc,
			}
		)
		local bf = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(12, 12),
				BackgroundColor3 = __Ixa_guiTheme.Accent,
				BorderSizePixel = 0,
				ZIndex = 3,
				Parent = bc,
			}
		)
		__Ixa_guiCorner(bf, UDim.new(1, 0))
		local bg = __Ixa_guiNew(
			"TextButton",
			{
				Position = UDim2.new(0, 8, 0, a1 - (a0 and 13 or 18) - (__Ixa_guiTouch and 19 or 13)),
				Size = UDim2.new(1, -16, 0, __Ixa_guiTouch and 40 or 28),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 4,
				Parent = a2,
			}
		)
		local bh = { Value = math.clamp(aU.Default or aV, aV, aW) }
		local bi = false
		a9.MouseEnter:Connect(function()
			__Ixa_guiTween(a5, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
		end)
		a9.MouseLeave:Connect(function()
			if not a7:IsFocused() then
				__Ixa_guiTween(a5, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			end
		end)
		a9.MouseButton1Click:Connect(function()
			ba = true
			a7.Text = aZ.format(bh.Value)
			a6.Visible = false
			a7.Visible = true
			a8.Visible = aY ~= ""
			a9.Visible = false
			__Ixa_guiTween(a5, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
			a7:CaptureFocus()
			task.defer(bb, false)
		end)
		a7.FocusLost:Connect(function()
			local bj = tonumber(a7.Text)
			ba = false
			a7.Visible = false
			a8.Visible = false
			a6.Visible = true
			a9.Visible = true
			__Ixa_guiTween(a5, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			if bj then
				bh:Set(bj)
			end
			bb(false)
		end)
		bg.MouseEnter:Connect(function()
			if not bi then
				__Ixa_guiTween(be, { ImageTransparency = 0.78, Size = UDim2.fromOffset(34, 34) }, 0.15)
			end
		end)
		bg.MouseLeave:Connect(function()
			if not bi then
				__Ixa_guiTween(be, { ImageTransparency = 0.85, Size = UDim2.fromOffset(28, 28) }, 0.2)
			end
		end)
		local bj = aZ.snap
		local function bk()
			return (aW - aV) == 0 and 0 or (bh.Value - aV) / (aW - aV)
		end
		local function bl(bm, bn, bo)
			bo = bo or Enum.EasingStyle.Linear
			__Ixa_guiTween(bd, { Size = UDim2.new(bm, 0, 1, 0) }, bn, bo)
			__Ixa_guiTween(bf, { Position = UDim2.new(bm, 0, 0.5, 0) }, bn, bo)
			__Ixa_guiTween(be, { Position = UDim2.new(bm, 0, 0.5, 0) }, bn, bo)
		end
		local function bm(bn, bo)
			bl(bk(), bn, bo)
			a6.Text = aZ.format(bh.Value) .. aY
		end
		local function bn(bo)
			local bp = bk()
			local bq = math.max(bc.AbsoluteSize.X, 1)
			local br = (bp >= bo and 1 or -1) * (5 / bq)
			bl(math.clamp(bp + br, 0, 1), 0.22, Enum.EasingStyle.Quint)
			task.delay(0.22, function()
				if not bi then
					bl(bk(), 0.18, Enum.EasingStyle.Quint)
				end
			end)
			a6.Text = aZ.format(bh.Value) .. aY
		end
		local function bo()
			__Ixa_guiTween(bf, { Size = UDim2.fromOffset(14, 12) }, 0.08)
			__Ixa_guiTween(be, { Size = UDim2.fromOffset(32, 32), ImageTransparency = 0.78 }, 0.12)
			task.delay(0.1, function()
				__Ixa_guiTween(bf, { Size = UDim2.fromOffset(12, 12) }, 0.25, Enum.EasingStyle.Quint)
				__Ixa_guiTween(be, { Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85 }, 0.25)
			end)
		end
		function bh:Set(bp, bq)
			bp = bj(tonumber(bp) or aV)
			if bp == bh.Value then
				return
			end
			local br = bk()
			bh.Value = bp
			if bi then
				bm(0.05)
			else
				bn(br)
				bo()
				__Ixa_guiFocusStroke(a3)
			end
			if not bq then
				__Ixa_guiCall(aU.Callback, bp)
			end
		end
		function bh:Get()
			return bh.Value
		end
		local function bp(bq)
			local br = math.clamp((bq - bc.AbsolutePosition.X) / bc.AbsoluteSize.X, 0, 1)
			bh:Set(aV + (aW - aV) * br)
		end
		bg.InputBegan:Connect(function(bq)
			if __Ixa_guiIsPointerPress(bq) then
				bi = true
				bh.Dragging = true
				__Ixa_guiTween(bf, { Size = UDim2.fromOffset(16, 16) }, 0.15, Enum.EasingStyle.Back)
				__Ixa_guiTween(be, { Size = UDim2.fromOffset(44, 44), ImageTransparency = 0.7 }, 0.15)
				bp(__Ixa_guiMousePosition().X)
			end
		end)
		self.Window:_listen("Changed", function(bq)
			if bi and __Ixa_guiIsPointerMove(bq) then
				bp(__Ixa_guiMousePosition().X)
			end
		end, bh)
		self.Window:_listen("Ended", function(bq)
			if bi and __Ixa_guiIsPointerPress(bq) then
				bi = false
				bh.Dragging = false
				__Ixa_guiTween(bf, { Size = UDim2.fromOffset(12, 12) }, 0.2)
				__Ixa_guiTween(be, { Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85 }, 0.2)
				__Ixa_guiCall(aU.OnRelease, bh.Value)
			end
		end, bh)
		bh.Value = bj(bh.Value)
		bm(0)
		task.defer(bb, true)
		return __Ixa_guiRegister(self, aU, bh, a2, "Slider")
	end
	function __Ixa_guiGroup:Dropdown(aU)
		aU = __Ixa_guiOptions(
			aU,
			{
				Title = "Name",
				Description = "Desc",
				CurrentOption = "Default",
				Value = "Default",
				MultipleOptions = "Multi",
				Values = "Options",
			}
		)
		if aU.Multi and type(aU.Default) ~= "table" and aU.Default ~= nil then
			aU.Default = { aU.Default }
		elseif not aU.Multi and type(aU.Default) == "table" then
			aU.Default = aU.Default[1]
		end
		local aV = aU.Multi == true
		local aW = aU.Options or {}
		local aX, aY, aZ
		aU, aX, aY, aZ = aQ(self, aU, {}, "Frame")
		local a_ = __Ixa_guiControlMetrics(self)
		local a0 = a_.Compact
		local a1 = a_.Chip
		local a2 = self.Window
		local a3 = __Ixa_guiTouch and 34 or 22
		local a4 = aU.MaxRows or 6
		local a5 = a0 and aU.Stacked ~= false
		local a6 = 2
		if a5 then
			a6 = (aU.Name or "") ~= "" and 20 or 2
			a1 = __Ixa_guiTouch and 34 or 30
			aZ = a6 + a1 + 4
			aX.Size = UDim2.new(1, 0, 0, aZ)
		end
		local a7 = __Ixa_guiNew(
			"TextButton",
			{ Size = UDim2.new(1, 0, 0, aZ), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = aX }
		)
		local a8, a9
		if not a5 then
			a8, a9 = aP(a7, aU.Name or "Dropdown", aU.Desc, 180, a_)
		elseif a6 > 2 then
			a8 = __Ixa_guiLabel({
				Position = UDim2.fromOffset(14, 1),
				Size = UDim2.new(1, -28, 0, 16),
				Text = aU.Name,
				TextSize = a_.TextSize,
				Parent = a7,
			})
		end
		local ba = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = a5 and Vector2.zero or Vector2.new(1, 0.5),
				Position = a5 and UDim2.fromOffset(14, a6) or UDim2.new(1, a0 and -14 or -10, 0.5, 0),
				Size = UDim2.fromOffset(60, a1),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = a7,
			}
		)
		__Ixa_guiCorner(ba, UDim.new(0, 6))
		local bb = __Ixa_guiStroke(ba)
		local bc = __Ixa_guiLabel({
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -34, 1, 0),
			TextColor3 = __Ixa_guiTheme.Muted,
			TextSize = 13,
			TextTruncate = Enum.TextTruncate.None,
			ClipsDescendants = true,
			Parent = ba,
		})
		local bd = aC(ba, 1, -6)
		local be = __Ixa_guiLabel({
			Size = UDim2.fromOffset(0, a1),
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 13,
			Visible = false,
			Parent = ba,
		})
		local bf = ""
		local function bg()
			local bh = (a5 and aX.AbsoluteSize.X / a2.Scale.Scale - 28 or a0 and __Ixa_guiControlWidth(aX, a2) or 190) - 10 - 34
			be.Text = bf
			if be.TextBounds.X <= bh then
				return bf
			end
			local bi = bf
			while #bi > 1 do
				bi = bi:sub(1, -2)
				be.Text = bi .. ".."
				if be.TextBounds.X <= bh then
					return bi .. ".."
				end
			end
			return ".."
		end
		local function bh(bi)
			if a5 then
				ba.Size = UDim2.new(1, -28, 0, a1)
				return
			end
			local bj
			if a0 then
				bj = __Ixa_guiControlWidth(aX, a2)
			else
				bj = math.clamp(bc.TextBounds.X + 10 + 34, 60, 190)
			end
			aR(a8, a9, bj + (a0 and 24 or 20))
			if bi then
				ba.Size = UDim2.fromOffset(bj, a1)
			else
				__Ixa_guiTween(ba, { Size = UDim2.fromOffset(bj, a1) }, 0.2)
			end
		end
		bc:GetPropertyChangedSignal("TextBounds"):Connect(function()
			if not a0 then
				bh(false)
			end
		end)
		if a0 then
			local bi, bj = 0, false
			aX:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local bk = aX.AbsoluteSize.X
				if bk == bi then
					return
				end
				bi = bk
				bh(true)
				if not bj then
					bj = true
					task.delay(0.12, function()
						bj = false
						bc.Text = bg()
					end)
				end
			end)
		end
		local bi = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.fromOffset(220, 0),
				BackgroundTransparency = 1,
				Visible = false,
				ZIndex = 45,
				Parent = a2.Body,
			}
		)
		bi:SetAttribute("NoDrag", true)
		local bj = __Ixa_guiNew(
			"ImageLabel",
			{
				Position = UDim2.fromOffset(-18, -12),
				Size = UDim2.new(1, 36, 1, 36),
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Shadow,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(49, 49, 450, 450),
				Parent = bi,
			}
		)
		local bk = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = __Ixa_guiTheme.Background, BorderSizePixel = 0, ClipsDescendants = true, Parent = bi }
		)
		__Ixa_guiCorner(bk, UDim.new(0, 10))
		local bl = __Ixa_guiStroke(bk, __Ixa_guiTheme.Stroke, 1)
		ao(bk)
		local bm = __Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 120), BackgroundTransparency = 1, Parent = bk })
		__Ixa_guiPadding(bm, 8, 8, 8, 8)
		local bn = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = __Ixa_guiTheme.Background, BorderSizePixel = 0, Parent = bm }
		)
		__Ixa_guiCorner(bn, UDim.new(0, 7))
		local bo = __Ixa_guiStroke(bn)
		local bp, bq = __Ixa_guiIcon(bn, "search", __Ixa_guiTheme.Muted, UDim2.new(0, 10, 0.5, 0))
		bp.Size = UDim2.fromOffset(14, 14)
		local br = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(32, 0),
				Size = UDim2.new(1, -40, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				PlaceholderText = aU.SearchPlaceholder or "Search",
				PlaceholderColor3 = __Ixa_guiTheme.Muted,
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ClearTextOnFocus = false,
				Parent = bn,
			}
		)
		br.Focused:Connect(function()
			__Ixa_guiTween(bo, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			__Ixa_guiTween(bq, { ImageColor3 = __Ixa_guiTheme.Accent }, 0.15)
		end)
		br.FocusLost:Connect(function()
			__Ixa_guiTween(bo, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			__Ixa_guiTween(bq, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.2)
		end)
		local bs = __Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Visible = aV, Parent = bm })
		local function bt(bu, bv)
			local bw = __Ixa_guiNew(
				"TextButton",
				{
					Position = bv,
					Size = UDim2.new(0.5, -3, 1, 0),
					BackgroundColor3 = __Ixa_guiTheme.Surface3,
					BackgroundTransparency = 0.35,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ClipsDescendants = true,
					Parent = bs,
				}
			)
			__Ixa_guiCorner(bw, UDim.new(0, 6))
			local bx = __Ixa_guiStroke(bw)
			__Ixa_guiLabel({ Size = UDim2.fromScale(1, 1), Text = bu, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, Parent = bw })
			bw.MouseEnter:Connect(function()
				__Ixa_guiTween(bw, { BackgroundTransparency = 0.05 }, 0.15)
				__Ixa_guiTween(bx, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			end)
			bw.MouseLeave:Connect(function()
				__Ixa_guiTween(bw, { BackgroundTransparency = 0.35 }, 0.25)
				__Ixa_guiTween(bx, { Color = __Ixa_guiTheme.Stroke }, 0.25)
			end)
			bw.MouseButton1Click:Connect(function()
				__Ixa_guiRipple(bw)
			end)
			return bw
		end
		local bu = bt(aU.SelectAllText or "Select all", UDim2.fromOffset(0, 0))
		local bv = bt(aU.ClearAllText or "Clear all", UDim2.new(0.5, 3, 0, 0))
		local bw = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Size = UDim2.new(1, 0, 0, 100),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = UDim2.new(),
				Parent = bm,
			}
		)
		local bx = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, a3),
			Text = aU.NoResultsText or "No results",
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			LayoutOrder = 0,
			Visible = false,
			Parent = bw,
		})
		local by = { Open = false }
		local bz = {}
		local bA = ""
		local bB = {}
		local bC = {}
		local bD = {}
		local bE = a3 + 2
		local function bF()
			local bG = bw.CanvasSize.Y.Offset
			return bG > 0 and bw.AbsoluteCanvasSize.Y / bG or 1
		end
		local function bG(bH)
			local bI = bD[bH]
			if bI == nil then
				bI = string.lower(tostring(bH))
				bD[bH] = bI
			end
			return bI
		end
		local function bH(bI)
			return bA == "" or string.find(bG(bI), bA, 1, true) ~= nil
		end
		local function bI(bJ)
			return (bJ:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
		end
		local function bJ(bK)
			local bL = tostring(bK)
			local bM = bA ~= "" and string.find(string.lower(bL), bA, 1, true)
			if not bM then
				return bI(bL)
			end
			local bN = bM + #bA - 1
			return bI(bL:sub(1, bM - 1))
				.. '<font color="#'
				.. __Ixa_guiTheme.Accent:ToHex()
				.. '"><b>'
				.. bI(bL:sub(bM, bN))
				.. "</b></font>"
				.. bI(bL:sub(bN + 1))
		end
		if aV then
			for bK, bL in ipairs(aU.Default or {}) do
				bz[bL] = true
			end
		elseif aU.Default ~= nil then
			bz[aU.Default] = true
		end
		local function bK()
			if aV then
				local bL = {}
				for bM, bN in ipairs(aW) do
					if bz[bN] then
						table.insert(bL, bN)
					end
				end
				return bL
			end
			for bL, bM in ipairs(aW) do
				if bz[bM] then
					return bM
				end
			end
			return nil
		end
		local function bL(bM, bN)
			local bO, bP = bM.On == true, bM.Hover == true
			__Ixa_guiTween(bM.Frame, { BackgroundTransparency = bP and 0.6 or 1 }, bN)
			__Ixa_guiTween(bM.Label, { TextColor3 = bO and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Text }, bN)
		end
		local function bM(bN, bO)
			local bP = bz[bN.Option] == true
			if bN.On == bP and bO then
				return
			end
			bN.On = bP
			local bQ = bO and 0.18 or 0
			bL(bN, bQ)
			if aV then
				__Ixa_guiTween(bN.Box, { BackgroundColor3 = bP and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface2 }, bQ)
				__Ixa_guiTween(bN.BoxStroke, { Color = bP and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke }, bQ)
			else
				__Ixa_guiTween(
					bN.Bar,
					{ BackgroundTransparency = bP and 0 or 1, Size = UDim2.fromOffset(3, bP and a3 - 10 or 4) },
					bO and 0.3 or 0,
					Enum.EasingStyle.Quint
				)
			end
			__Ixa_guiTween(bN.Check, { ImageTransparency = bP and 0 or 1 }, bQ)
			if bO and bP then
				bN.CheckScale.Scale = 0.5
				__Ixa_guiTween(bN.CheckScale, { Scale = 1 }, 0.3, Enum.EasingStyle.Back)
			else
				bN.CheckScale.Scale = 1
			end
		end
		local function bN(bO)
			local bP = bK()
			if #aW == 0 then
				bf = aU.EmptyText or "None"
			elseif aV then
				if #bP > 2 then
					bf = tostring(bP[1]) .. ", " .. tostring(bP[2]) .. "  +" .. (#bP - 2)
				else
					bf = #bP > 0 and table.concat(bP, ", ") or (aU.NoneText or "None")
				end
			else
				bf = bP ~= nil and tostring(bP) or (aU.NoneText or "None")
			end
			bc.Text = bg()
			local bQ = #aW > 0 and (if aV then #bP > 0 else bP ~= nil)
			__Ixa_guiTween(bc, { TextColor3 = bQ and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted }, bO and 0.15 or 0)
			for bR, bS in ipairs(bB) do
				if bS.Option ~= nil then
					bM(bS, bO)
				end
			end
		end
		local bO
		local function bP()
			return #bC
		end
		local bQ = true
		local bR = Vector2.new(220, 120)
		local bS = false
		local function bT(bU)
			bQ = aU.Searchable ~= false and #aW > (aU.SearchAfter or 0)
			bn.Visible = bQ
			local bV = 0
			if bQ then
				bV += 38
			end
			bs.Position = UDim2.fromOffset(0, bV)
			if aV and #aW > 0 then
				bs.Visible = true
				bV += 34
			else
				bs.Visible = false
			end
			local bW = bP()
			bx.Visible = bW == 0
			local bX = math.clamp(bW, 1, a4)
			local bY = bX * a3 + (bX - 1) * 2
			bw.CanvasSize = UDim2.fromOffset(0, math.max(bW, 1) * (a3 + 2) - 2)
			local bZ = a2.Scale.Scale
			local b_ = a2:_popupHost(aX)
			local b0 = b_.AbsoluteSize.Y / bZ
			local b1 = (ba.AbsolutePosition.Y - b_.AbsolutePosition.Y) / bZ
			local b2 = math.max(b0 - (b1 + ba.AbsoluteSize.Y / bZ) - 14, b1 - 14) - bV - 16
			if b2 >= a3 then
				bY = math.min(bY, b2)
			end
			bw.Position = UDim2.fromOffset(0, bV)
			bw.Size = UDim2.new(1, 0, 0, bY)
			bO()
			local b3 = math.max(math.floor(ba.AbsoluteSize.X / bZ), aU.PopupWidth or 210)
			local b4 = b_.AbsoluteSize.X / bZ
			b3 = math.min(b3, math.max(b4 - 16, 120))
			bR = Vector2.new(b3, bV + bY + 16)
			bm.Size = UDim2.new(1, 0, 0, bR.Y)
			if not bS then
				return
			end
			if bU then
				bi.Size = UDim2.fromOffset(bR.X, bR.Y)
			else
				__Ixa_guiTween(bi, { Size = UDim2.fromOffset(bR.X, bR.Y) }, 0.22, Enum.EasingStyle.Quint)
			end
		end
		local function bU()
			if bA == "" then
				bC = aW
			else
				bC = {}
				for bV, bW in ipairs(aW) do
					if bH(bW) then
						table.insert(bC, bW)
					end
				end
			end
			bO()
		end
		local bV = nil
		local function bW()
			local bX = a2:_popupHost(aX)
			local bY = a2.Scale.Scale
			if bV then
				local bZ = ba.AbsolutePosition + ba.AbsoluteSize / 2
				if not __Ixa_guiContainsPoint(bZ, bV) then
					by:SetOpen(false)
					return
				end
			end
			local bZ = bX.AbsoluteSize / bY
			local b_ = (ba.AbsolutePosition - bX.AbsolutePosition) / bY
			local b0 = ba.AbsoluteSize / bY
			local b1 = math.clamp(b_.X + b0.X, bR.X + 8, math.max(bZ.X - 8, bR.X + 8))
			local b2 = b_.Y + b0.Y + 2
			if b2 + bR.Y > bZ.Y - 8 and b_.Y - 2 - bR.Y >= 8 then
				bi.AnchorPoint = Vector2.new(1, 1)
				bi.Position = UDim2.fromOffset(b1, b_.Y - 2)
				bm.AnchorPoint = Vector2.new(0, 1)
				bm.Position = UDim2.fromScale(0, 1)
			else
				bi.AnchorPoint = Vector2.new(1, 0)
				bi.Position = UDim2.fromOffset(b1, b2)
				bm.AnchorPoint = Vector2.zero
				bm.Position = UDim2.fromScale(0, 0)
			end
		end
		local bX = nil
		local bY = 0
		local bZ = nil
		local function b_()
			if bZ then
				bZ.ScrollingEnabled = true
				bZ = nil
			end
		end
		local function b0()
			bw.CanvasPosition = Vector2.zero
			if aV then
				return
			end
			local b1 = bK()
			if b1 == nil then
				return
			end
			local b2 = table.find(bC, b1)
			if b2 then
				bw.CanvasPosition = Vector2.new(0, math.max(0, (b2 - 2) * bE) * bF())
			end
		end
		local function b1(b2)
			if b2 == by.Open then
				return
			end
			by.Open = b2
			bd:Set(b2)
			__Ixa_guiTween(bb, { Color = b2 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke, Transparency = b2 and 0.35 or 0 }, 0.2)
			__Ixa_guiTween(ba, { BackgroundColor3 = b2 and __Ixa_guiTheme.Surface or __Ixa_guiTheme.Background }, 0.2)
			bY += 1
			if b2 then
				if a2._closePopup and a2._closePopup ~= by._close then
					a2._closePopup()
				end
				a2._closePopup = by._close
				bV = aX:FindFirstAncestorWhichIsA("ScrollingFrame")
				if bV and bV.ScrollingEnabled then
					bZ = bV
					bV.ScrollingEnabled = false
				end
				bi.Parent = a2:_popupHost(aX)
				bA = ""
				br.Text = ""
				br.PlaceholderText = aU.SearchPlaceholder or (#aW > 6 and ("Search " .. #aW .. " options") or "Search")
				bU()
				bT(true)
				bN(false)
				b0()
				bS = true
				bi.Size = UDim2.fromOffset(bR.X, 0)
				bW()
				bi.Visible = true
				__Ixa_guiTween(bi, { Size = UDim2.fromOffset(bR.X, bR.Y) }, 0.3, Enum.EasingStyle.Quint)
				__Ixa_guiTween(bl, { Transparency = 0 }, 0.12)
				__Ixa_guiTween(bj, { ImageTransparency = 0.4 }, 0.3)
				if not bX then
					bX = a2:_listen("Render", bW)
				end
			else
				if a2._closePopup == by._close then
					a2._closePopup = nil
				end
				b_()
				if br:IsFocused() then
					br:ReleaseFocus()
				end
				bS = false
				__Ixa_guiTween(bi, { Size = UDim2.fromOffset(bR.X, 0) }, 0.2, Enum.EasingStyle.Quint)
				__Ixa_guiTween(bj, { ImageTransparency = 1 }, 0.16)
				local b3 = bY
				task.delay(0.14, function()
					if bY == b3 and not by.Open then
						__Ixa_guiTween(bl, { Transparency = 1 }, 0.06)
					end
				end)
				task.delay(0.21, function()
					if bY == b3 and not by.Open then
						bi.Visible = false
						if bX then
							bX()
							bX = nil
						end
					end
				end)
			end
		end
		by._close = function()
			b1(false)
		end
		local function b2()
			bN(true)
			__Ixa_guiCall(aU.Callback, bK())
		end
		local function b3()
			local b4 = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.new(1, -6, 0, a3),
					BackgroundColor3 = __Ixa_guiTheme.Surface3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Visible = false,
					Parent = bw,
				}
			)
			__Ixa_guiCorner(b4, UDim.new(0, 7))
			local b5, b6, b7, b8
			if aV then
				b5 = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 8, 0.5, 0),
						Size = UDim2.fromOffset(18, 18),
						BackgroundColor3 = __Ixa_guiTheme.Surface2,
						BorderSizePixel = 0,
						Parent = b4,
					}
				)
				__Ixa_guiCorner(b5, UDim.new(0, 5))
				b6 = __Ixa_guiStroke(b5, __Ixa_guiTheme.Stroke)
				b8 = __Ixa_guiNew(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(12, 12),
						BackgroundTransparency = 1,
						ImageColor3 = __Ixa_guiTheme.AccentDark,
						ImageTransparency = 1,
						ScaleType = Enum.ScaleType.Fit,
						Parent = b5,
					}
				)
			else
				b7 = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 2, 0.5, 0),
						Size = UDim2.fromOffset(3, 4),
						BackgroundColor3 = __Ixa_guiTheme.Accent,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = b4,
					}
				)
				__Ixa_guiCorner(b7, UDim.new(1, 0))
				b8 = __Ixa_guiNew(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -10, 0.5, 0),
						Size = UDim2.fromOffset(14, 14),
						BackgroundTransparency = 1,
						ImageColor3 = __Ixa_guiTheme.Accent,
						ImageTransparency = 1,
						ScaleType = Enum.ScaleType.Fit,
						Visible = false,
						Parent = b4,
					}
				)
			end
			__Ixa_guiApplyIcon(b8, "check")
			local b9 = __Ixa_guiNew("UIScale", { Parent = b8 })
			local ca = __Ixa_guiLabel({
				Position = UDim2.fromOffset(aV and 36 or 14, 0),
				Size = UDim2.new(1, aV and -44 or -46, 1, 0),
				Text = "",
				TextSize = 13,
				TextColor3 = __Ixa_guiTheme.Text,
				RichText = true,
				Parent = b4,
			})
			local cb = {
				Option = nil,
				Frame = b4,
				Box = b5,
				BoxStroke = b6,
				Bar = b7,
				Check = b8,
				CheckScale = b9,
				Label = ca,
				On = nil,
				Hover = false,
			}
			local cc = __Ixa_guiClickGuard(b4, function()
				return bw
			end)
			b4.MouseEnter:Connect(function()
				if __Ixa_guiIsTouch() then
					return
				end
				cb.Hover = true
				bL(cb, 0.15)
				if b6 and not bz[cb.Option] then
					__Ixa_guiTween(b6, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
				end
			end)
			b4.MouseLeave:Connect(function()
				cb.Hover = false
				bL(cb, 0.25)
				if b6 and not bz[cb.Option] then
					__Ixa_guiTween(b6, { Color = __Ixa_guiTheme.Stroke }, 0.25)
				end
			end)
			b4.MouseButton1Click:Connect(function()
				local cd = cb.Option
				if cd == nil or not cc() then
					return
				end
				if bz[cd] then
					if not aV and aU.AllowNone == false then
						b1(false)
						return
					end
					bz[cd] = nil
				else
					if not aV then
						bz = {}
					end
					bz[cd] = true
				end
				b2()
				if not aV then
					b1(false)
				end
			end)
			return cb
		end
		bO = function()
			if not by.Open then
				return
			end
			local b4 = math.max(math.floor(bw.CanvasPosition.Y / bF() / bE), 1)
			local b5 = math.ceil(bw.Size.Y.Offset / bE) + 3
			for b6 = 1, math.max(b5, #bB) do
				local b7 = b6 <= b5 and b4 + (b6 - b4) % b5 or 0
				local b8 = b6 <= b5 and bC[b7] or nil
				local b9 = bB[b6]
				if b8 == nil then
					if b9 then
						b9.Frame.Visible = false
						b9.Option = nil
					end
				else
					if not b9 then
						b9 = b3()
						bB[b6] = b9
					end
					b9.Frame.Position = UDim2.fromOffset(0, (b7 - 1) * bE)
					local ca = bJ(b8)
					local cb = b9.Option ~= b8
					if cb or b9.Text ~= ca then
						b9.Text = ca
						b9.Label.Text = ca
					end
					if cb then
						b9.Option = b8
						b9.On = nil
						bM(b9, false)
					end
					b9.Frame.Visible = true
				end
			end
		end
		bw:GetPropertyChangedSignal("CanvasPosition"):Connect(bO)
		local function b4()
			table.clear(bD)
			for b5, b6 in ipairs(bB) do
				b6.Option = nil
			end
			bU()
			if by.Open then
				bT(false)
			end
		end
		bu.MouseButton1Click:Connect(function()
			for b5, b6 in ipairs(bC) do
				bz[b6] = true
			end
			b2()
		end)
		bv.MouseButton1Click:Connect(function()
			bz = {}
			b2()
		end)
		function by:Set(b5, b6)
			bz = {}
			if aV then
				for b7, b8 in ipairs(type(b5) == "table" and b5 or { b5 }) do
					bz[b8] = true
				end
			elseif b5 ~= nil then
				bz[b5] = true
			end
			bN(by.Open)
			__Ixa_guiFocusStroke(aY)
			if not b6 then
				__Ixa_guiCall(aU.Callback, bK())
			end
		end
		function by:Get()
			return bK()
		end
		local function b5(b6, b7)
			if type(b6) ~= "table" or type(b7) ~= "table" then
				return b6 == b7
			end
			if #b6 ~= #b7 then
				return false
			end
			for b8, b9 in ipairs(b6) do
				if b7[b8] ~= b9 then
					return false
				end
			end
			return true
		end
		function by:Refresh(b6, b7, b8)
			local b9 = bK()
			aW = b6 or {}
			if not b7 then
				bz = {}
			end
			b4()
			bN(false)
			if not b8 and not b5(b9, bK()) then
				__Ixa_guiCall(aU.Callback, bK())
			end
		end
		function by:SetOptions(b6, b7)
			local b8, b9 = true, false
			if type(b7) == "boolean" then
				b8 = b7
			elseif type(b7) == "table" then
				local ca = b7.KeepSelection
				if ca == nil then
					ca = b7.keepSelection
				end
				if ca ~= nil then
					b8 = ca ~= false
				end
				b9 = b7.Silent == true or b7.silent == true
			end
			by:Refresh(b6, b8, b9)
		end
		function by:GetOptions()
			return table.clone(aW)
		end
		function by:_saveValue()
			local b6 = bK()
			if aV then
				local b7 = {}
				for b8, b9 in ipairs(b6) do
					b7[b9] = true
				end
				for b8 in pairs(bz) do
					if not b7[b8] then
						table.insert(b6, b8)
					end
				end
				return b6
			end
			if b6 == nil then
				b6 = next(bz)
			end
			return b6
		end
		function by:SetOpen(b6)
			b1(b6 == true)
		end
		local b6 = __Ixa_guiClickGuard(a7, function()
			return aX:FindFirstAncestorWhichIsA("ScrollingFrame")
		end)
		a7.MouseButton1Click:Connect(function()
			if b6() then
				b1(not by.Open)
			end
		end)
		a7.MouseEnter:Connect(function()
			if not by.Open and not __Ixa_guiIsTouch() then
				__Ixa_guiTween(bb, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
				__Ixa_guiTween(ba, { BackgroundColor3 = __Ixa_guiTheme.Surface }, 0.15)
			end
		end)
		a7.MouseLeave:Connect(function()
			if not by.Open then
				__Ixa_guiTween(bb, { Color = __Ixa_guiTheme.Stroke }, 0.25)
				__Ixa_guiTween(ba, { BackgroundColor3 = __Ixa_guiTheme.Background }, 0.25)
			end
		end)
		br:GetPropertyChangedSignal("Text"):Connect(function()
			bA = string.lower(br.Text)
			bw.CanvasPosition = Vector2.zero
			bU()
			if by.Open then
				bT(false)
			end
		end)
		by._listeners = {
			function()
				b1(false)
				b_()
				if bX then
					bX()
					bX = nil
				end
				bi:Destroy()
			end,
		}
		a2:_listen("Began", function(b7)
			if not by.Open then
				return
			end
			if b7.KeyCode == Enum.KeyCode.Escape then
				b1(false)
			elseif __Ixa_guiIsPointerPress(b7) then
				local b8 = __Ixa_guiMousePosition()
				if not __Ixa_guiContainsPoint(b8, bi) and not __Ixa_guiContainsPoint(b8, a7) then
					b1(false)
				end
			end
		end, by)
		b4()
		bN(false)
		task.defer(bh, true)
		return __Ixa_guiRegister(self, aU, by, aX, "Dropdown")
	end
	__Ixa_guiLibrary._amountSuffixes = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18 }
	function __Ixa_guiLibrary._parseAmount(aU)
		aU = string.lower(tostring(aU)):gsub("[%s,_%$]", "")
		aU = aU:gsub("kg$", ""):gsub("/s$", "")
		local aV = tonumber(aU)
		if aV then
			return aV
		end
		local aW, aX = aU:match("^(.-)(%a+)$")
		local aY = aX and __Ixa_guiLibrary._amountSuffixes[aX]
		aV = aW and tonumber(aW)
		if aV and aY then
			return aV * aY
		end
		return nil
	end
	function __Ixa_guiGroup:Input(aU)
		local aV, aW, aX, aY, aZ
		aU, aV, aW, aX, aY, aZ = aQ(
			self,
			aU,
			{ Title = "Name", Description = "Desc", PlaceholderText = "Placeholder", CurrentValue = "Default", Value = "Default" },
			"Frame",
			160,
			"Input"
		)
		local a_ = __Ixa_guiControlMetrics(self).Compact
		local a0 = a_ and __Ixa_guiControlMetrics(self).Chip + 2 or 30
		local a1 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, a_ and -14 or -10, 0.5, 0),
				Size = UDim2.fromOffset(170, a0),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BorderSizePixel = 0,
				Parent = aV,
			}
		)
		__Ixa_guiCorner(a1, UDim.new(0, 6))
		local a2 = __Ixa_guiStroke(a1)
		local a3 = aU.Icon
		if a3 then
			__Ixa_guiIcon(a1, a3, __Ixa_guiTheme.Muted, UDim2.new(0, 8, 0.5, 0))
		end
		local a4 = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(a3 and 30 or 8, 0),
				Size = UDim2.new(1, a3 and -38 or -16, 1, 0),
				BackgroundTransparency = 1,
				Text = aU.Default or "",
				PlaceholderText = aU.Placeholder or "",
				PlaceholderColor3 = __Ixa_guiTheme.Muted,
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = a_ and 13 or 14,
				FontFace = __Ixa_guiFonts.Regular,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				TextTruncate = Enum.TextTruncate.None,
				ClipsDescendants = true,
				Parent = a1,
			}
		)
		a1.ClipsDescendants = true
		local a5 = a4.Text
		local a6 = aU.Numeric and __Ixa_guiLibrary._parseAmount(a5) or nil
		if aU.Numeric and not a6 then
			a5 = ""
		end
		local a7 = false
		local a8 = (a3 and 30 or 8) + 8
		local function a9(ba)
			local bb
			if a_ then
				bb = __Ixa_guiControlWidth(aV, self.Window)
			else
				local bc = aV.AbsoluteSize.X / self.Window.Scale.Scale
				local bd = math.clamp(bc - 14 - 110 - 20, 100, 200)
				local be = a4.TextBounds.X
				if #a4.Text == 0 then
					be = math.min(a4.TextBounds.X, 90)
				end
				bb = math.clamp(be + a8 + 12, 90, bd) + (a7 and 8 or 0)
				bb = math.min(bb, bd + 8)
			end
			aR(aY, aZ, bb + (a_ and 24 or 20))
			if ba then
				a1.Size = UDim2.fromOffset(bb, a0)
			else
				__Ixa_guiTween(a1, { Size = UDim2.fromOffset(bb, a0) }, 0.18)
			end
		end
		local ba = 0
		aV:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if aV.AbsoluteSize.X ~= ba then
				ba = aV.AbsoluteSize.X
				a9(true)
			end
		end)
		a4:GetPropertyChangedSignal("Text"):Connect(function()
			a9(false)
		end)
		a4:GetPropertyChangedSignal("TextBounds"):Connect(function()
			a9(false)
		end)
		task.defer(a9, true)
		a4.Focused:Connect(function()
			a7 = true
			__Ixa_guiTween(a2, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			a9(false)
		end)
		a4.FocusLost:Connect(function(bb)
			a7 = false
			__Ixa_guiTween(a2, { Color = __Ixa_guiTheme.Stroke }, 0.15)
			a9(false)
			if aU.Numeric then
				local bc = __Ixa_guiLibrary._parseAmount(a4.Text)
				if not bc then
					a4.Text = a5
					return
				end
				a5, a6 = a4.Text, bc
				__Ixa_guiCall(aU.Callback, bc, bb)
				return
			end
			__Ixa_guiCall(aU.Callback, a4.Text, bb)
		end)
		return __Ixa_guiRegister(self, aU, {
			Set = function(bb, bc, bd)
				local be = a4.Text
				a4.Text = tostring(bc == nil and "" or bc)
				if aU.Numeric then
					local bf = __Ixa_guiLibrary._parseAmount(a4.Text)
					if bf then
						a5, a6 = a4.Text, bf
					else
						a4.Text = a5
						return
					end
				end
				__Ixa_guiFocusStroke(aW)
				if not bd and a4.Text ~= be then
					__Ixa_guiCall(aU.Callback, aU.Numeric and a6 or a4.Text, false)
				end
			end,
			Get = function()
				if aU.Numeric then
					return a6
				end
				return a4.Text
			end,
			_saveValue = aU.Numeric and function()
				return a5
			end or nil,
		}, aV, "Input")
	end
	function __Ixa_guiGroup:Keybind(aU)
		local aV, aW, aX, aY, aZ
		aU, aV, aW, aX, aY, aZ = aQ(
			self,
			aU,
			{ Title = "Name", Description = "Desc", CurrentKeybind = "Default", Value = "Default" },
			"Frame",
			110,
			"Keybind"
		)
		if type(aU.Default) == "string" then
			aU.Default = Enum.KeyCode[aU.Default]
		end
		local a_ = __Ixa_guiControlMetrics(self).Compact
		local a0 = __Ixa_guiControlMetrics(self).Chip
		local a1 = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, a_ and -14 or -10, 0.5, 0),
				Size = UDim2.fromOffset(44, a0),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ClipsDescendants = true,
				Parent = aV,
			}
		)
		__Ixa_guiCorner(a1, UDim.new(0, 6))
		local a2 = __Ixa_guiStroke(a1)
		local a3 = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 1, 0),
			TextSize = 13,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextTruncate = Enum.TextTruncate.None,
			Parent = a1,
		})
		local a4 = { Value = aU.Default, Listening = false }
		local function a5(a6)
			local a7 = math.max(a3.TextBounds.X + 20, __Ixa_guiTouch and 44 or 36)
			aR(aY, aZ, a7 + (a_ and 24 or 20))
			if a6 then
				a1.Size = UDim2.fromOffset(a7, a0)
			else
				__Ixa_guiTween(a1, { Size = UDim2.fromOffset(a7, a0) }, 0.2)
			end
		end
		a3:GetPropertyChangedSignal("TextBounds"):Connect(function()
			a5(false)
		end)
		local function a6()
			a3.Text = a4.Listening and "..." or __Ixa_guiKeyName(a4.Value)
			__Ixa_guiTween(a2, { Color = a4.Listening and __Ixa_guiTheme.StrokeHover or __Ixa_guiTheme.Stroke }, 0.15)
			__Ixa_guiTween(a3, { TextColor3 = a4.Listening and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted }, 0.15)
		end
		function a4:Set(a7, a8)
			local a9 = a4.Listening
			a4.Value = a7
			a4.Listening = false
			a6()
			if not a9 then
				__Ixa_guiFocusStroke(aW)
			end
			if not a8 then
				__Ixa_guiCall(aU.OnChanged, a7)
			end
		end
		a1.MouseButton1Click:Connect(function()
			a4.Listening = not a4.Listening
			a6()
		end)
		self.Window:_listen("Began", function(a7, a8)
			if a7.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end
			if a4.Listening then
				self.Window._consumedKey = a7.KeyCode
				self.Window._consumedAt = os.clock()
				if a7.KeyCode == Enum.KeyCode.Escape then
					a4.Listening = false
					a6()
				else
					a4:Set(a7.KeyCode)
				end
				return
			end
			if not a8 and a4.Value ~= nil and a7.KeyCode == a4.Value then
				__Ixa_guiCall(aU.Callback, a7.KeyCode)
			end
		end, a4)
		a6()
		task.defer(a5, true)
		function a4:Get()
			return a4.Value
		end
		a4._onHide = function()
			if a4.Listening then
				a4.Listening = false
				a6()
			end
		end
		return __Ixa_guiRegister(self, aU, a4, aV, "Keybind")
	end
	function __Ixa_guiGroup:ColorPicker(aU)
		local aV = 194
		local aW, aX, aY
		aU, aW, aX, aY = aQ(
			self,
			aU,
			{ Title = "Name", Description = "Desc", Color = "Default", CurrentValue = "Default", Value = "Default" },
			"Frame"
		)
		aW.ClipsDescendants = true
		local aZ = __Ixa_guiControlMetrics(self)
		local a_ = aZ.Compact
		local a0 = __Ixa_guiNew(
			"TextButton",
			{ Size = UDim2.new(1, 0, 0, aY), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = aW }
		)
		aP(a0, aU.Name or "Color", aU.Desc, 140, aZ)
		local a1 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, a_ and -38 or -34, 0.5, 0),
				Size = UDim2.fromOffset(22, 22),
				BorderSizePixel = 0,
				Parent = a0,
			}
		)
		__Ixa_guiCorner(a1, UDim.new(0, 6))
		__Ixa_guiStroke(a1, __Ixa_guiTheme.Stroke)
		local a2 = __Ixa_guiLabel({
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, a_ and -68 or -64, 0.5, 0),
			Size = UDim2.fromOffset(64, 16),
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = a0,
		})
		local a3 = aC(a0, 1, a_ and -14 or -12)
		local a4 = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(14, aY + 2),
				Size = UDim2.new(1, -28, 0, aV - 12),
				BackgroundTransparency = 1,
				Visible = false,
				Parent = aW,
			}
		)
		local a5 = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.new(1, 0, 0, 118),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				Parent = a4,
			}
		)
		__Ixa_guiCorner(a5, UDim.new(0, 8))
		__Ixa_guiStroke(a5, __Ixa_guiTheme.Stroke)
		local a6 =
			__Ixa_guiNew("UIGradient", { Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 0, 0)), Parent = a5 })
		local a7 = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = a5 }
		)
		__Ixa_guiCorner(a7, UDim.new(0, 8))
		__Ixa_guiNew(
			"UIGradient",
			{
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
				Rotation = 90,
				Parent = a7,
			}
		)
		local function a8(a9, ba)
			local bb = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(ba, ba),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					ZIndex = 3,
					Parent = a9,
				}
			)
			__Ixa_guiCorner(bb, UDim.new(1, 0))
			__Ixa_guiStroke(bb, Color3.new(0, 0, 0), 0.7)
			local bc = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, -4, 1, -4),
					BorderSizePixel = 0,
					ZIndex = 3,
					Parent = bb,
				}
			)
			__Ixa_guiCorner(bc, UDim.new(1, 0))
			return bb, bc
		end
		local a9, ba = a8(a5, 14)
		local bb = __Ixa_guiNew(
			"TextButton",
			{
				Position = UDim2.fromOffset(0, 132),
				Size = UDim2.new(1, 0, 0, 10),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				Parent = a4,
			}
		)
		__Ixa_guiCorner(bb, UDim.new(1, 0))
		__Ixa_guiNew(
			"UIGradient",
			{
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
				}),
				Parent = bb,
			}
		)
		local bc, bd = a8(bb, 16)
		bc.Position = UDim2.fromScale(0, 0.5)
		local be = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(0, 154),
				Size = UDim2.fromOffset(a_ and 110 or 124, 28),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BorderSizePixel = 0,
				Parent = a4,
			}
		)
		__Ixa_guiCorner(be, UDim.new(0, 7))
		local bf = __Ixa_guiStroke(be)
		local bg = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 6, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				BorderSizePixel = 0,
				Parent = be,
			}
		)
		__Ixa_guiCorner(bg, UDim.new(0, 4))
		__Ixa_guiStroke(bg, __Ixa_guiTheme.Stroke)
		local bh = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -38, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				TextTruncate = Enum.TextTruncate.None,
				ClipsDescendants = false,
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				Parent = be,
			}
		)
		local bi = __Ixa_guiLabel({
			Position = UDim2.fromOffset(a_ and 118 or 134, 154),
			Size = UDim2.new(1, a_ and -118 or -134, 0, 28),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = a4,
		})
		local bj = { Open = false }
		local bk, bl, bm = Color3.toHSV(aU.Default or __Ixa_guiTheme.Accent)
		local bn = nil
		local function bo(bp)
			return string.format(
				"#%02X%02X%02X",
				math.floor(bp.R * 255 + 0.5),
				math.floor(bp.G * 255 + 0.5),
				math.floor(bp.B * 255 + 0.5)
			)
		end
		local function bp(bq)
			local br = Color3.fromHSV(bk, bl, bm)
			bj.Value = br
			a1.BackgroundColor3 = br
			bg.BackgroundColor3 = br
			ba.BackgroundColor3 = br
			bd.BackgroundColor3 = Color3.fromHSV(bk, 1, 1)
			a2.Text = bo(br)
			a6.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(bk, 1, 1))
			__Ixa_guiTween(a9, { Position = UDim2.fromScale(bl, 1 - bm) }, bq, Enum.EasingStyle.Quint)
			__Ixa_guiTween(bc, { Position = UDim2.fromScale(bk, 0.5) }, bq, Enum.EasingStyle.Quint)
			if not bh:IsFocused() then
				bh.Text = bo(br)
			end
			bi.Text = string.format(
				"%d  %d  %d",
				math.floor(br.R * 255 + 0.5),
				math.floor(br.G * 255 + 0.5),
				math.floor(br.B * 255 + 0.5)
			)
		end
		local function bq(br, bs)
			bp(br)
			if not bs then
				__Ixa_guiCall(aU.Callback, bj.Value)
			end
		end
		function bj:Set(br, bs)
			bk, bl, bm = Color3.toHSV(br)
			bq(0.25, bs)
			__Ixa_guiFocusStroke(aX)
		end
		function bj:Get()
			return bj.Value
		end
		local function br(bs)
			bj.Open = bs
			__Ixa_guiTween(aW, { Size = UDim2.new(1, 0, 0, bs and (aY + aV) or aY) }, 0.35, Enum.EasingStyle.Quint)
			a3:Set(bs)
			if bs then
				a4.Visible = true
			else
				task.delay(0.35, function()
					if not bj.Open then
						a4.Visible = false
					end
				end)
			end
		end
		function bj:SetOpen(bs)
			br(bs == true)
		end
		a0.MouseButton1Click:Connect(function()
			br(not bj.Open)
		end)
		local function bs(bt)
			bl = math.clamp((bt.X - a5.AbsolutePosition.X) / a5.AbsoluteSize.X, 0, 1)
			bm = 1 - math.clamp((bt.Y - a5.AbsolutePosition.Y) / a5.AbsoluteSize.Y, 0, 1)
			bq(0.04)
		end
		local function bt(bu)
			bk = math.clamp((bu.X - bb.AbsolutePosition.X) / bb.AbsoluteSize.X, 0, 0.999)
			bq(0.04)
		end
		a5.InputBegan:Connect(function(bu)
			if __Ixa_guiIsPointerPress(bu) then
				bn = "sv"
				__Ixa_guiTween(a9, { Size = UDim2.fromOffset(18, 18) }, 0.2, Enum.EasingStyle.Quint)
				bs(__Ixa_guiMousePosition())
			end
		end)
		bb.InputBegan:Connect(function(bu)
			if __Ixa_guiIsPointerPress(bu) then
				bn = "hue"
				__Ixa_guiTween(bc, { Size = UDim2.fromOffset(20, 20) }, 0.2, Enum.EasingStyle.Quint)
				bt(__Ixa_guiMousePosition())
			end
		end)
		self.Window:_listen("Changed", function(bu)
			if not bn or not __Ixa_guiIsPointerMove(bu) then
				return
			end
			local bv = __Ixa_guiMousePosition()
			if bn == "sv" then
				bs(bv)
			else
				bt(bv)
			end
		end, bj)
		self.Window:_listen("Ended", function(bu)
			if bn and __Ixa_guiIsPointerPress(bu) then
				bn = nil
				__Ixa_guiTween(a9, { Size = UDim2.fromOffset(14, 14) }, 0.25, Enum.EasingStyle.Quint)
				__Ixa_guiTween(bc, { Size = UDim2.fromOffset(16, 16) }, 0.25, Enum.EasingStyle.Quint)
			end
		end, bj)
		bh.Focused:Connect(function()
			__Ixa_guiTween(bf, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
		end)
		bh.FocusLost:Connect(function()
			__Ixa_guiTween(bf, { Color = __Ixa_guiTheme.Stroke }, 0.15)
			local bu, bv, bw = bh.Text:match("^%s*#?(%x%x)(%x%x)(%x%x)%s*$")
			if bu then
				bj:Set(Color3.fromRGB(tonumber(bu, 16), tonumber(bv, 16), tonumber(bw, 16)))
			else
				bh.Text = bo(bj.Value)
			end
		end)
		bp(0)
		return __Ixa_guiRegister(self, aU, bj, aW, "ColorPicker")
	end
	function __Ixa_guiGroup:Stepper(aU)
		local aV, aW, aX, aY, aZ
		aU, aV, aW, aX, aY, aZ = aQ(
			self,
			aU,
			{ Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default", Increment = "Step" },
			"Frame",
			150,
			"Stepper"
		)
		local a_ = aU.Min or 0
		local a0 = aU.Max or 100
		local a1 = aU.Step or 1
		local a2 = aU.Suffix or ""
		local a3 = __Ixa_guiNumberFormat(a_, a0, a1)
		local a4 = __Ixa_guiControlMetrics(self).Compact
		local a5 = __Ixa_guiControlMetrics(self).Chip
		local a6 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, a4 and -14 or -10, 0.5, 0),
				Size = UDim2.fromOffset(0, a5),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BorderSizePixel = 0,
				Parent = aV,
			}
		)
		__Ixa_guiCorner(a6, UDim.new(0, 6))
		local a7 = __Ixa_guiStroke(a6)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Parent = a6,
			}
		)
		local function a8(a9, ba)
			local bb = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.fromOffset(a5, a5),
					BackgroundTransparency = 1,
					Text = a9,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextSize = 18,
					FontFace = __Ixa_guiFonts.Medium,
					AutoButtonColor = false,
					LayoutOrder = ba,
					Parent = a6,
				}
			)
			bb.MouseEnter:Connect(function()
				__Ixa_guiTween(bb, { TextColor3 = __Ixa_guiTheme.Accent }, 0.12)
			end)
			bb.MouseLeave:Connect(function()
				__Ixa_guiTween(bb, { TextColor3 = __Ixa_guiTheme.Muted }, 0.2)
			end)
			return bb
		end
		local a9 = a8("\u{2212}", 1)
		local ba = __Ixa_guiLabel({
			Size = UDim2.new(0, 30, 1, 0),
			TextSize = 13,
			TextColor3 = __Ixa_guiTheme.Accent,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 2,
			Parent = a6,
		})
		local bb = a8("+", 3)
		local function bc(bd)
			local be = math.max(ba.TextBounds.X + 12, 30)
			if bd then
				ba.Size = UDim2.new(0, be, 1, 0)
			else
				__Ixa_guiTween(ba, { Size = UDim2.new(0, be, 1, 0) }, 0.2)
			end
		end
		ba:GetPropertyChangedSignal("TextBounds"):Connect(function()
			bc(false)
		end)
		a6:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			aR(aY, aZ, a6.AbsoluteSize.X / self.Window.Scale.Scale + (a4 and 24 or 20))
		end)
		local bd = { Value = math.clamp(aU.Default or a_, a_, a0) }
		local be = a3.snap
		local bf = false
		local function bg()
			ba.Text = a3.format(bd.Value) .. a2
			__Ixa_guiTween(a9, { TextTransparency = bd.Value <= a_ and 0.6 or 0 }, 0.15)
			__Ixa_guiTween(bb, { TextTransparency = bd.Value >= a0 and 0.6 or 0 }, 0.15)
		end
		function bd:Set(bh, bi)
			bh = be(tonumber(bh) or a_)
			if bh == bd.Value then
				return
			end
			bd.Value = bh
			bg()
			if not bf then
				__Ixa_guiFocusStroke(aW)
			end
			if not bi then
				__Ixa_guiCall(aU.Callback, bh)
			end
		end
		function bd:Get()
			return bd.Value
		end
		local function bh(bi)
			bf = true
			bd:Set(bd.Value + bi * a1)
			bf = false
			__Ixa_guiTween(a7, { Color = __Ixa_guiTheme.StrokeHover }, 0.08)
			task.delay(0.12, function()
				__Ixa_guiTween(a7, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			end)
		end
		local function bi(bj, bk)
			local bl = false
			bj.InputBegan:Connect(function(bm)
				if not __Ixa_guiIsPointerPress(bm) then
					return
				end
				bl = true
				bh(bk)
				task.delay(0.4, function()
					while bl do
						bh(bk)
						task.wait(0.07)
					end
				end)
			end)
			bj.InputEnded:Connect(function(bm)
				if __Ixa_guiIsPointerPress(bm) then
					bl = false
				end
			end)
			bj.MouseLeave:Connect(function()
				bl = false
			end)
		end
		bi(a9, -1)
		bi(bb, 1)
		bg()
		task.defer(bc, true)
		return __Ixa_guiRegister(self, aU, bd, aV, "Stepper")
	end
	function __Ixa_guiGroup:Progress(aU)
		aU = __Ixa_guiOptions(aU, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" })
		local aV = __Ixa_guiControlMetrics(self)
		local aW = aV.Compact
		local aX = aW and 6 or 10
		local aY, aZ = __Ixa_guiControlFrame(self, "Frame", (aU.Desc and aV.DescHeight or aV.Height) + aX, aU)
		__Ixa_guiHoverStroke(aY, aZ)
		local a_
		if aU.Desc then
			a_ = math.floor((aV.DescHeight - (aV.DescGap + aV.DescLine)) / 2) - 2
		else
			a_ = aW and 5 or 12
		end
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(14, a_),
			Size = UDim2.new(1, -110, 0, 18),
			Text = aU.Name or "Progress",
			TextSize = aV.TextSize,
			Parent = aY,
		})
		if aU.Desc then
			__Ixa_guiLabel({
				Position = UDim2.fromOffset(14, a_ + aV.DescGap),
				Size = UDim2.new(1, -110, 0, aV.DescLine),
				Text = aU.Desc,
				TextSize = aV.DescSize,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = aY,
			})
		end
		local a0 = __Ixa_guiLabel({
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -14, 0, a_),
			Size = UDim2.fromOffset(90, 18),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextSize = 13,
			TextColor3 = __Ixa_guiLibrary._color(aU.TextColor) or __Ixa_guiTheme.Accent,
			RichText = true,
			Parent = aY,
		})
		local a1 = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.new(0, 14, 1, aW and -12 or -16),
				Size = UDim2.new(1, -28, 0, 5),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Parent = aY,
			}
		)
		__Ixa_guiCorner(a1, UDim.new(1, 0))
		local a2 = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = __Ixa_guiLibrary._color(aU.Color) or __Ixa_guiTheme.Accent, BorderSizePixel = 0, Parent = a1 }
		)
		__Ixa_guiCorner(a2, UDim.new(1, 0))
		local a3 = { Value = math.clamp(aU.Default or 0, 0, 1) }
		local a4 = aU.Format
		local function a5(a6)
			local a7 = a3.Value
			__Ixa_guiTween(a2, { Size = UDim2.new(a7, 0, 1, 0) }, a6, Enum.EasingStyle.Quint)
			if type(a4) == "function" then
				a0.Text = __Ixa_guiLibrary._rich(a4(a7))
			else
				a0.Text = string.format("%d%%", math.floor(a7 * 100 + 0.5))
			end
		end
		function a3:Set(a6, a7)
			a6 = math.clamp(tonumber(a6) or 0, 0, 1)
			if a6 == a3.Value then
				return
			end
			a3.Value = a6
			a5(0.35)
			if not a7 then
				__Ixa_guiCall(aU.Callback, a6)
			end
		end
		function a3:Get()
			return a3.Value
		end
		function a3:SetColor(a6)
			__Ixa_guiTween(a2, { BackgroundColor3 = __Ixa_guiLibrary._color(a6) or __Ixa_guiTheme.Accent }, 0.25)
		end
		function a3:SetTextColor(a6)
			__Ixa_guiTween(a0, { TextColor3 = __Ixa_guiLibrary._color(a6) or __Ixa_guiTheme.Accent }, 0.25)
		end
		__Ixa_guiBindTheme(a0, function()
			a5(0)
		end)
		return __Ixa_guiRegister(self, aU, a3, aY, "Progress")
	end
	function __Ixa_guiGroup:OrderList(aU)
		aU = __Ixa_guiOptions(aU, { Title = "Name", Description = "Desc", Options = "Items", Values = "Items" })
		local aV = __Ixa_guiControlMetrics(self)
		local aW = aV.Compact
		local aX = self.Window
		local aY = __Ixa_guiTouch and 40 or 32
		local aZ = 4
		local a_ = aY + aZ
		local a0 = __Ixa_guiTouch and 34 or 26
		local a1 = __Ixa_guiTouch and 30 or 22
		local a2 = math.max(math.floor(tonumber(aU.MaxRows) or 6), 1)
		local a3 = aU.Numbered ~= false
		local a4 = aU.Arrows ~= false
		local a5 = __Ixa_guiControlFrame(self, "Frame", 0, aU)
		a5.AutomaticSize = Enum.AutomaticSize.Y
		if aW then
			__Ixa_guiPadding(a5, 14, 14, 6, 8)
		else
			__Ixa_guiPadding(a5, 14, 14, 11, 12)
		end
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = a5 })
		local a6 = tostring(aU.Name or "")
		__Ixa_guiLabel({ Size = UDim2.new(1, 0, 0, 18), Text = a6, TextSize = aV.TextSize, Visible = a6 ~= "", LayoutOrder = 1, Parent = a5 })
		if aU.Desc then
			__Ixa_guiLabel({
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = aU.Desc,
				TextSize = aV.DescSize,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 2,
				Parent = a5,
			})
		end
		local a7 = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Size = UDim2.new(1, 0, 0, aY + 2),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = __Ixa_guiTouch and 4 or 3,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0.4,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = UDim2.new(),
				ScrollingEnabled = false,
				LayoutOrder = 3,
				Parent = a5,
			}
		)
		a7:SetAttribute("NoDrag", true)
		local a8 = __Ixa_guiNew("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = a7 })
		local a9 = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, aY),
			Text = tostring(aU.EmptyText or "Nothing to order"),
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			Visible = false,
			Parent = a8,
		})
		local function ba(bb, bc, bd, be, bf)
			bf.BackgroundTransparency = 1
			bf.Text = ""
			bf.AutoButtonColor = false
			bf.Parent = bb
			local bg = __Ixa_guiNew("TextButton", bf)
			local bh = __Ixa_guiNew(
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = __Ixa_guiTouch and UDim2.fromOffset(16, 16) or UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Muted,
					ScaleType = Enum.ScaleType.Fit,
					Parent = bg,
				}
			)
			__Ixa_guiApplyIcon(bh, bc)
			if bh.Image ~= "" then
				return bg, { Object = bh, Color = "ImageColor3", Fade = "ImageTransparency" }
			end
			bh:Destroy()
			local bi = __Ixa_guiLabel({
				Size = UDim2.fromScale(1, 1),
				Text = bd,
				TextSize = 18,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.None,
				Rotation = be,
				Parent = bg,
			})
			return bg, { Object = bi, Color = "TextColor3", Fade = "TextTransparency" }
		end
		local function bb(bc, bd, be, bf)
			__Ixa_guiTween(bc.Object, { [bc.Color] = bd, [bc.Fade] = be }, bf)
		end
		local bc = {}
		local bd = {}
		local be = {}
		local bf = nil
		local bg, bh
		local function bi(bj)
			return 1 + (bj - 1) * a_
		end
		local function bj()
			local bk = {}
			for bl, bm in ipairs(bd) do
				bk[bl] = bm.Value
			end
			return bk
		end
		local function bk(bl)
			local bm = #bd
			for bn, bo in ipairs(bd) do
				bo.Index.Text = tostring(bn)
				if bo ~= bf then
					__Ixa_guiTween(bo.Frame, { Position = UDim2.fromOffset(3, bi(bn)) }, bl and 0 or 0.22, Enum.EasingStyle.Quint)
				end
				if bo.UpIcon then
					__Ixa_guiTween(bo.UpIcon.Object, { [bo.UpIcon.Fade] = bn == 1 and 0.7 or 0 }, bl and 0 or 0.15)
					__Ixa_guiTween(bo.DownIcon.Object, { [bo.DownIcon.Fade] = bn == bm and 0.7 or 0 }, bl and 0 or 0.15)
				end
			end
		end
		local function bl()
			local bm = #bd
			local bn = math.max(bm, 1) * a_ - aZ + 2
			local bo = math.clamp(bm, 1, a2)
			local bp = bo * a_ - aZ + 2
			local bq = bm > a2
			a7.Size = UDim2.new(1, 0, 0, bp)
			a7.CanvasSize = UDim2.fromOffset(0, bn)
			a8.Size = UDim2.new(1, bq and -8 or 0, 0, bn)
			if not bf then
				a7.ScrollingEnabled = bq
			end
			a9.Visible = bm == 0
			local br = math.max(bn - bp, 0)
			if a7.CanvasPosition.Y > br then
				a7.CanvasPosition = Vector2.new(0, br)
			end
		end
		local function bm(bn)
			bc.Value = bj()
			if not bn then
				__Ixa_guiCall(aU.Callback, bj())
			end
		end
		local function bn()
			if a7.ScrollingEnabled then
				return a7
			end
			return a5:FindFirstAncestorWhichIsA("ScrollingFrame")
		end
		local function bo(bp)
			local bq = __Ixa_guiNew(
				"Frame",
				{ Size = UDim2.new(1, -6, 0, aY), BackgroundColor3 = __Ixa_guiTheme.Surface, BorderSizePixel = 0, Parent = a8 }
			)
			__Ixa_guiCorner(bq, UDim.new(0, 7))
			local br = { Value = bp, Frame = bq }
			br.Stroke = __Ixa_guiStroke(bq)
			br.Scale = __Ixa_guiNew("UIScale", { Parent = bq })
			local bs
			bs, br.GripIcon = ba(bq, "grip-vertical", "=", 0, { Size = UDim2.new(0, a0, 1, 0) })
			local bt = a0
			br.Index = __Ixa_guiLabel({
				Position = UDim2.fromOffset(bt, 0),
				Size = UDim2.new(0, 22, 1, 0),
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Accent,
				TextTruncate = Enum.TextTruncate.None,
				Visible = a3,
				Parent = bq,
			})
			if a3 then
				bt += 22
			end
			local bu = a4 and a1 * 2 + 8 or 10
			br.Text = __Ixa_guiLabel({
				Position = UDim2.fromOffset(bt, 0),
				Size = UDim2.new(1, -(bt + bu), 1, 0),
				Text = tostring(bp),
				TextSize = 13,
				Parent = bq,
			})
			local bv = {}
			if a4 then
				local bw, bx
				bw, br.UpIcon = ba(
					bq,
					"chevron-up",
					"\u{203a}",
					-90,
					{ AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -(a1 + 6), 0, 0), Size = UDim2.new(
						0,
						a1,
						1,
						0
					) }
				)
				bx, br.DownIcon = ba(
					bq,
					"chevron-down",
					"\u{203a}",
					90,
					{ AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -4, 0, 0), Size = UDim2.new(0, a1, 1, 0) }
				)
				for by, bz in pairs({ [bw] = -1, [bx] = 1 }) do
					local bA = bz < 0 and br.UpIcon or br.DownIcon
					local bB = __Ixa_guiClickGuard(by, bn)
					by.MouseEnter:Connect(function()
						if not __Ixa_guiIsTouch() then
							__Ixa_guiTween(bA.Object, { [bA.Color] = __Ixa_guiTheme.Accent }, 0.12)
						end
					end)
					by.MouseLeave:Connect(function()
						__Ixa_guiTween(bA.Object, { [bA.Color] = __Ixa_guiTheme.Muted }, 0.2)
					end)
					by.MouseButton1Click:Connect(function()
						if bB() then
							bg(br, bz)
						end
					end)
					table.insert(bv, by)
				end
			end
			bs.InputBegan:Connect(function(bw)
				if __Ixa_guiIsPointerPress(bw) then
					bh(br)
				end
			end)
			bq.InputBegan:Connect(function(bw)
				if bw.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end
				local bx = __Ixa_guiMousePosition()
				for by, bz in ipairs(bv) do
					if __Ixa_guiContainsPoint(bx, bz) then
						return
					end
				end
				bh(br)
			end)
			bq.MouseEnter:Connect(function()
				if not __Ixa_guiIsTouch() and br ~= bf then
					__Ixa_guiTween(br.Stroke, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
					bb(br.GripIcon, __Ixa_guiTheme.Text, 0, 0.12)
				end
			end)
			bq.MouseLeave:Connect(function()
				if br ~= bf then
					__Ixa_guiTween(br.Stroke, { Color = __Ixa_guiTheme.Stroke }, 0.25)
					bb(br.GripIcon, __Ixa_guiTheme.Muted, 0, 0.25)
				end
			end)
			return br
		end
		local function bp(bq)
			local br = {}
			for bs, bt in ipairs(bd) do
				br[bt.Value] = br[bt.Value] or {}
				table.insert(br[bt.Value], bt)
			end
			local bs = {}
			for bt, bu in ipairs(bq) do
				local bv = br[bu]
				local bw = bv and table.remove(bv, 1)
				if not bw then
					bw = bo(bu)
					bw.Frame.Position = UDim2.fromOffset(3, bi(bt))
				end
				bs[bt] = bw
			end
			for bt, bu in pairs(br) do
				for bv, bw in ipairs(bu) do
					bw.Frame:Destroy()
				end
			end
			bd = bs
		end
		local function bq(br, bs)
			local bt = {}
			for bu, bv in ipairs(br) do
				bt[bv] = (bt[bv] or 0) + 1
			end
			local bu = {}
			for bv, bw in ipairs({ bs, br }) do
				for bx, by in ipairs(bw) do
					if (bt[by] or 0) > 0 then
						bt[by] -= 1
						table.insert(bu, by)
					end
				end
			end
			return bu
		end
		local function br(bs)
			local bt = bi(bs) - 1
			local bu = a7.AbsoluteWindowSize.Y / aX.Scale.Scale
			local bv = a7.CanvasPosition.Y
			if bt < bv then
				bv = bt
			elseif bt + aY + 2 > bv + bu then
				bv = bt + aY + 2 - bu
			end
			if bv ~= a7.CanvasPosition.Y then
				__Ixa_guiTween(a7, { CanvasPosition = Vector2.new(0, math.max(bv, 0)) }, 0.2)
			end
		end
		function bg(bs, bt)
			if bf then
				return
			end
			local bu = table.find(bd, bs)
			local bv = bu and bu + bt
			if not bv or bv < 1 or bv > #bd then
				return
			end
			bd[bu], bd[bv] = bd[bv], bd[bu]
			bk(false)
			__Ixa_guiTween(bs.Stroke, { Color = __Ixa_guiTheme.Accent }, 0.08)
			task.delay(0.18, function()
				if bs ~= bf then
					__Ixa_guiTween(bs.Stroke, { Color = __Ixa_guiTheme.Stroke }, 0.3)
				end
			end)
			br(bv)
			bm(false)
		end
		local bs, bt = 0, nil
		local bu, bv, bw = nil, nil, nil
		local function bx(by)
			local bz = aX.Scale.Scale
			local bA = (by.Y - bs - a7.AbsolutePosition.Y) / bz + a7.CanvasPosition.Y
			bA = math.clamp(bA, bi(1), bi(#bd))
			bf.Frame.Position = UDim2.fromOffset(3, bA)
			local bB = math.clamp(math.floor((bA - 1) / a_ + 0.5) + 1, 1, #bd)
			local bC = table.find(bd, bf)
			if bC ~= bB then
				table.remove(bd, bC)
				table.insert(bd, bB, bf)
				bk(false)
			end
		end
		local function by(bz)
			if not bf or not bt then
				return
			end
			local bA = aX.Scale.Scale
			local bB = a7.AbsolutePosition.Y
			local bC = bB + a7.AbsoluteSize.Y
			local bD = aY * bA
			local bE = 0
			if bt.Y < bB + bD then
				bE = -(bB + bD - bt.Y) / bD
			elseif bt.Y > bC - bD then
				bE = (bt.Y - (bC - bD)) / bD
			end
			if bE == 0 then
				return
			end
			local bF = math.max(a7.CanvasSize.Y.Offset - a7.AbsoluteWindowSize.Y / bA, 0)
			local bG = math.clamp(a7.CanvasPosition.Y + math.clamp(bE, -1.5, 1.5) * 360 * bz, 0, bF)
			if bG ~= a7.CanvasPosition.Y then
				a7.CanvasPosition = Vector2.new(0, bG)
				bx(bt)
			end
		end
		function bh(bz)
			if bf or #bd < 2 or bc._destroyed then
				return
			end
			bf = bz
			bu = table.clone(bd)
			bt = __Ixa_guiMousePosition()
			bs = bt.Y - bz.Frame.AbsolutePosition.Y
			bz.Frame.ZIndex = 5
			__Ixa_guiTween(bz.Frame, { BackgroundColor3 = __Ixa_guiTheme.Surface3 }, 0.12)
			__Ixa_guiTween(bz.Stroke, { Color = __Ixa_guiTheme.Accent }, 0.12)
			__Ixa_guiTween(bz.Scale, { Scale = 1.02 }, 0.18, Enum.EasingStyle.Back)
			bb(bz.GripIcon, __Ixa_guiTheme.Accent, 0, 0.12)
			a7.ScrollingEnabled = false
			local bA = a5:FindFirstAncestorWhichIsA("ScrollingFrame")
			if bA and bA.ScrollingEnabled then
				bw = bA
				bA.ScrollingEnabled = false
			end
			bv = aX:_listen("Render", by)
		end
		local function bz(bA)
			local bB = bf
			if not bB then
				return
			end
			bf = nil
			bt = nil
			if bv then
				bv()
				bv = nil
			end
			if bw then
				bw.ScrollingEnabled = true
				bw = nil
			end
			__Ixa_guiTween(bB.Frame, { BackgroundColor3 = __Ixa_guiTheme.Surface }, 0.2)
			__Ixa_guiTween(bB.Stroke, { Color = __Ixa_guiTheme.Stroke }, 0.25)
			__Ixa_guiTween(bB.Scale, { Scale = 1 }, 0.2)
			bb(bB.GripIcon, __Ixa_guiTheme.Muted, 0, 0.25)
			task.delay(0.22, function()
				if bB ~= bf then
					bB.Frame.ZIndex = 1
				end
			end)
			bk(false)
			bl()
			for bC, bD in ipairs(bd) do
				if bu[bC] ~= bD then
					bm(bA)
					break
				end
			end
		end
		aX:_listen("Changed", function(bA)
			if bf and __Ixa_guiIsPointerMove(bA) then
				bt = __Ixa_guiMousePosition()
				bx(bt)
			end
		end, bc)
		aX:_listen("Ended", function(bA)
			if bf and __Ixa_guiIsPointerPress(bA) then
				bz(false)
			end
		end, bc)
		table.insert(bc._listeners, function()
			bz(true)
		end)
		bc._onHide = function()
			bz(false)
		end
		function bc:Set(bA, bB)
			if type(bA) ~= "table" then
				return
			end
			bz(true)
			be = table.clone(bA)
			bp(bq(bj(), be))
			bk(false)
			bl()
			bm(bB)
		end
		function bc:Get()
			return bj()
		end
		function bc:Refresh(bA, bB, bC)
			bz(true)
			bA = type(bA) == "table" and table.clone(bA) or {}
			if bB ~= false then
				bA = bq(bA, bc:_saveValue())
			else
				be = {}
			end
			bp(bA)
			bk(false)
			bl()
			bm(bC)
		end
		function bc:_saveValue()
			local bA = bj()
			local bB = {}
			for bC, bD in ipairs(bA) do
				bB[bD] = (bB[bD] or 0) + 1
			end
			for bC, bD in ipairs(be) do
				if (bB[bD] or 0) > 0 then
					bB[bD] -= 1
				else
					table.insert(bA, bD)
				end
			end
			return bA
		end
		bp(type(aU.Items) == "table" and aU.Items or {})
		bk(true)
		bl()
		bc.Value = bj()
		return __Ixa_guiRegister(self, aU, bc, a5, "OrderList")
	end
	for aU, aV in pairs(table.clone(__Ixa_guiGroup)) do
		if type(aV) == "function" and aU:sub(1, 1) ~= "_" and aU:sub(1, 6) ~= "Create" then
			__Ixa_guiGroup["Create" .. aU] = aV
		end
	end
	local function __Ixa_guiExecutor()
		local aV
		pcall(function()
			if typeof(identifyexecutor) == "function" then
				aV = (identifyexecutor())
			elseif typeof(getexecutorname) == "function" then
				aV = getexecutorname()
			end
		end)
		if type(aV) == "string" and #aV > 0 then
			return aV
		end
		return __Ixa_guiRunService:IsStudio() and "Studio" or "Unknown"
	end
	local function __Ixa_guiCompatibility(aW)
		local aX = __Ixa_guiExecutor()
		local aY = aW.SupportedExecutors
		if type(aY) == "table" then
			local aZ = string.lower(aX)
			for a_, a0 in ipairs(aY) do
				if string.find(aZ, string.lower(tostring(a0)), 1, true) then
					return aX, true, "Your executor is supported and fully compatible."
				end
			end
			return aX, false, "Not on the supported list. Some features may not work."
		end
		local aZ = {
			{ "writefile", writefile },
			{ "readfile", readfile },
			{ "getcustomasset", getcustomasset },
			{ "setclipboard", setclipboard or toclipboard },
			{ "request", request or http_request or (syn and syn.request) },
		}
		local a_ = {}
		for a0, a1 in ipairs(aZ) do
			if type(a1[2]) ~= "function" then
				table.insert(a_, a1[1])
			end
		end
		if #a_ == 0 then
			return aX, true, "Your executor is supported and fully compatible."
		end
		return aX, false, "Missing " .. table.concat(a_, ", ") .. ". Some features may not work."
	end
	local __Ixa_guiDisclaimer = {}
	function __Ixa_guiDisclaimer.Path(aX)
		return tostring(aX) .. "/unsupported_skip.txt"
	end
	function __Ixa_guiDisclaimer.Available()
		return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
	end
	function __Ixa_guiDisclaimer.Saved(aX, aY)
		if not __Ixa_guiDisclaimer.Available() then
			return false
		end
		local aZ = __Ixa_guiDisclaimer.Path(aX)
		local a_, a0 = pcall(function()
			return isfile(aZ) and readfile(aZ) or nil
		end)
		return a_ and a0 == aY
	end
	function __Ixa_guiDisclaimer.Write(aX, aY, aZ)
		if not __Ixa_guiDisclaimer.Available() then
			return false
		end
		return pcall(function()
			if type(isfolder) == "function" and type(makefolder) == "function" then
				local a_ = ""
				for a0 in tostring(aX):gmatch("[^/\\]+") do
					a_ = a_ == "" and a0 or a_ .. "/" .. a0
					if not isfolder(a_) then
						makefolder(a_)
					end
				end
			end
			writefile(aY, aZ)
		end)
	end
	function __Ixa_guiDisclaimer.Save(aX, aY)
		return __Ixa_guiDisclaimer.Write(aX, __Ixa_guiDisclaimer.Path(aX), aY)
	end
	function __Ixa_guiDisclaimer.DisclaimerKey(aX)
		if aX.Id ~= nil then
			return (tostring(aX.Id):gsub("[\r\n]", " "))
		end
		local aY = tostring(aX.Title) .. "\0" .. tostring(aX.Text)
		local aZ = 5381
		for a_ = 1, #aY do
			aZ = (aZ * 33 + aY:byte(a_)) % 4294967296
		end
		return string.format("%08x", aZ)
	end
	function __Ixa_guiDisclaimer.DisclaimerAccepted(aX, aY)
		if not __Ixa_guiDisclaimer.Available() then
			return false
		end
		local aZ = tostring(aX) .. "/disclaimers.txt"
		local a_, a0 = pcall(function()
			return isfile(aZ) and readfile(aZ) or ""
		end)
		if not a_ or type(a0) ~= "string" then
			return false
		end
		for a1 in a0:gmatch("[^\r\n]+") do
			if a1 == aY then
				return true
			end
		end
		return false
	end
	function __Ixa_guiDisclaimer.AcceptDisclaimer(aX, aY)
		if __Ixa_guiDisclaimer.DisclaimerAccepted(aX, aY) then
			return true
		end
		local aZ = tostring(aX) .. "/disclaimers.txt"
		local a_, a0 = pcall(function()
			return isfile(aZ) and readfile(aZ) or ""
		end)
		a0 = a_ and type(a0) == "string" and a0 or ""
		if a0 ~= "" and not a0:match("\n$") then
			a0 ..= "\n"
		end
		return __Ixa_guiDisclaimer.Write(aX, aZ, a0 .. aY .. "\n")
	end
	local __Ixa_guiGameInfoCache = nil
	local function __Ixa_guiGameInfo()
		if __Ixa_guiGameInfoCache == nil then
			local aZ, a_ = pcall(function()
				return __Ixa_guiMarketplace:GetProductInfo(game.PlaceId)
			end)
			__Ixa_guiGameInfoCache = aZ and type(a_) == "table" and a_ or false
		end
		return __Ixa_guiGameInfoCache or nil
	end
	local function __Ixa_guiGameName()
		local a_ = __Ixa_guiGameInfo()
		if a_ and a_.Name then
			return a_.Name
		end
		return __Ixa_guiRunService:IsStudio() and "Studio" or "Unknown game"
	end
	local function __Ixa_guiRegionUnavailable(callback)
		callback("Unavailable")
	end
	local __Ixa_guiNoticeColors = setmetatable({}, {
		__index = function(a1, a2)
			if a2 == "Success" or a2 == "Warning" or a2 == "Error" then
				return __Ixa_guiTheme[a2]
			end
			return nil
		end,
	})
	local __Ixa_guiWindow = {}
	__Ixa_guiWindow.__index = __Ixa_guiWindow
	function __Ixa_guiLibrary._registry()
		local a3, a4 = pcall(function()
			return getgenv and getgenv() or shared
		end)
		a4 = a3 and type(a4) == "table" and a4 or shared
		if type(a4) ~= "table" then
			return nil
		end
		if type(a4.__AirFlowWindows) ~= "table" then
			a4.__AirFlowWindows = {}
		end
		return a4.__AirFlowWindows
	end
	function __Ixa_guiLibrary:SetLogo(a3)
		local a4 = __Ixa_guiLibrary.Assets
		local a5 = a4.Logos and a4.Logos[a3]
		if not a5 and a4.Logos then
			for a6, a7 in pairs(a4.Logos) do
				if a6:lower() == tostring(a3):lower() then
					a5 = a7
					break
				end
			end
		end
		if not a5 then
			warn("[AirFlow] unknown logo: " .. tostring(a3))
			return false
		end
		a4.Logo = a5.Logo
		a4.LogoSmall = a5.LogoSmall
		a4.LogoTint = false
		return true
	end
	function __Ixa_guiLibrary.Window(a3, a4)
		a4 = __Ixa_guiOptions(a4, { Name = "Title", LoadingSubtitle = "Subtitle", ToggleUIKeybind = "Keybind" })
		if a4.Logo ~= nil then
			__Ixa_guiLibrary:SetLogo(a4.Logo)
		end
		if type(a4.Keybind) == "string" then
			a4.Keybind = Enum.KeyCode[a4.Keybind]
		end
		local a5 = a4.Size or UDim2.fromOffset(760, 520)
		local a6 = a4.Keybind or Enum.KeyCode.RightControl
		local a7 = setmetatable(
			{
				Tabs = {},
				CurrentTab = nil,
				Open = true,
				Keybind = a6,
				_connections = {},
				_controls = {},
				_inputListeners = { Began = {}, Changed = {}, Ended = {}, Render = {} },
				_frameSteps = {},
				_destroyed = false,
				_identity = { Names = {}, Avatars = {} },
				_pinned = {},
				Minimized = false,
				_hideName = false,
				_hideAvatar = false,
				Title = a4.Title or "Airflow",
				_logoIcon = a4.Icon or __Ixa_guiAssets.Logo,
				_sessionStart = os.clock(),
				_islandLocked = a4.IslandDraggable == false,
			},
			__Ixa_guiWindow
		)
		local a8 = type(a4.ConfigurationSaving) == "table" and a4.ConfigurationSaving or {}
		a7.ConfigFolder = a8.FolderName or "AirflowUI"
		a7._registryKey = "AirFlow:" .. tostring(a7.ConfigFolder) .. ":" .. tostring(a4.Title or "Airflow")
		table.insert(__Ixa_guiLibrary.Windows, a7)
		local a9 = __Ixa_guiLibrary._registry()
		if a9 then
			local ba = a9[a7._registryKey]
			if type(ba) == "table" and type(ba.Destroy) == "function" then
				pcall(ba.Destroy, ba)
			end
			a9[a7._registryKey] = a7
		end
		a7.ConfigName = a8.FileName
		a7._configListeners = {}
		a7._pendingFlags = {}
		local ba = a4.DefaultTheme or a4.Theme
		if ba ~= nil then
			__Ixa_guiLibrary.DefaultTheme = ba
		end
		a7:_applyDefaultTheme()
		a7._uiScale = math.clamp(tonumber(a4.UIScale) or 1, 0.6, 1.5)
		a7._adaptive = a4.AdaptiveSize ~= false
		a7.UIScale = a7._uiScale
		if a4.Density ~= nil then
			__Ixa_guiLibrary:SetDensity(a4.Density)
		end
		if a4.CornerRadius ~= nil then
			__Ixa_guiLibrary:SetCornerRadius(a4.CornerRadius, true)
		end
		local function bb(bc)
			return function(...)
				for bd, be in ipairs(a7._inputListeners[bc]) do
					be(...)
				end
			end
		end
		local bc = bb("Render")
		table.insert(
			a7._connections,
			__Ixa_guiRunService.RenderStepped:Connect(function(bd)
				bc(bd)
				for be, bf in ipairs(a7._frameSteps) do
					bf(bd)
				end
			end)
		)
		table.insert(a7._connections, __Ixa_guiInputService.InputBegan:Connect(bb("Began")))
		table.insert(a7._connections, __Ixa_guiInputService.InputChanged:Connect(bb("Changed")))
		table.insert(a7._connections, __Ixa_guiInputService.InputEnded:Connect(bb("Ended")))
		local bd = __Ixa_guiNew(
			"ScreenGui",
			{
				Name = a4.Name or "AirflowUI",
				IgnoreGuiInset = true,
				ResetOnSpawn = false,
				DisplayOrder = 999,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			}
		)
		a7.Gui = bd
		local be = __Ixa_guiNew(
			"Frame",
			{
				Name = "Window",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = a5,
				BackgroundTransparency = 1,
				Parent = bd,
			}
		)
		a7.Root = be
		local bf = __Ixa_guiNew("UIScale", { Parent = be })
		a7.Scale = bf
		local bg = __Ixa_guiNew(
			"ImageLabel",
			{
				Position = UDim2.fromOffset(-25, -25),
				Size = UDim2.new(1, 50, 1, 50),
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Shadow,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 0.6,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(49, 49, 450, 450),
				Parent = be,
			}
		)
		a7.Shadow = bg
		a7._shadowRest = 0.6
		local bh = __Ixa_guiNew(
			"CanvasGroup",
			{ Name = "Fader", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, GroupTransparency = 1, ZIndex = 2, Parent = be }
		)
		a7._fader = bh
		a7._bodyAlpha = 1
		local bi = __Ixa_guiNew(
			"Frame",
			{
				Name = "Body",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 2,
				Parent = bh,
			}
		)
		a7.Body = bi
		__Ixa_guiCorner(bi, UDim.new(0, 10))
		a7.BodyStroke = __Ixa_guiStroke(bi, __Ixa_guiTheme.Stroke)
		ao(bi)
		a7._backgroundImage = __Ixa_guiNew(
			"ImageLabel",
			{
				Name = "BackgroundImage",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Crop,
				ImageTransparency = 1,
				Visible = false,
				ZIndex = 0,
				Parent = bi,
			}
		)
		__Ixa_guiCorner(a7._backgroundImage, UDim.new(0, 10))
		a7.BackgroundTransparency = math.clamp(tonumber(a4.BackgroundTransparency) or 0.35, 0, 1)
		a7._backgroundGeneration = 0
		local bj = __Ixa_guiNew(
			"Frame",
			{
				Name = "Sidebar",
				Size = UDim2.new(0, __Ixa_guiSidebarWidth, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = bi,
			}
		)
		a7.Sidebar = bj
		local bk = __Ixa_guiNew(
			"Frame",
			{ Name = "Fill", Size = UDim2.new(1, 24, 1, 0), BackgroundColor3 = __Ixa_guiTheme.Surface, BorderSizePixel = 0, ZIndex = 0, Parent = bj }
		)
		__Ixa_guiCorner(bk, UDim.new(0, 10))
		a7.SidebarFill = bk
		__Ixa_guiNew(
			"Frame",
			{
				Name = "Divider",
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.new(0, 1, 1, 0),
				BackgroundColor3 = __Ixa_guiTheme.Stroke,
				BorderSizePixel = 0,
				ZIndex = 2,
				Parent = bj,
			}
		)
		local bl =
			__Ixa_guiNew("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, __Ixa_guiHeaderHeight), BackgroundTransparency = 1, Parent = bj })
		local bm = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 14, 0.5, 0),
				Size = UDim2.fromOffset(32, 32),
				BackgroundTransparency = 1,
				Image = "",
				ImageColor3 = __Ixa_guiTheme.Accent,
				ScaleType = Enum.ScaleType.Fit,
				Parent = bl,
			}
		)
		__Ixa_guiApplyIcon(bm, a4.Icon or __Ixa_guiAssets.Logo, true)
		local bn = a4.Version or a4.Subtitle
		__Ixa_guiLabel({
			Position = UDim2.new(0, 56, 0.5, bn and -15 or -9),
			Size = UDim2.new(1, -68, 0, 18),
			Text = a7.Title,
			TextSize = 14,
			FontFace = __Ixa_guiFonts.Bold,
			Parent = bl,
		})
		if bn then
			__Ixa_guiLabel({
				Position = UDim2.new(0, 56, 0.5, 3),
				Size = UDim2.new(1, -68, 0, 14),
				Text = tostring(bn),
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = bl,
			})
		end
		local bo = a4.Profile ~= false
		local bp = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Name = "Tabs",
				Position = UDim2.fromOffset(0, __Ixa_guiHeaderHeight),
				Size = UDim2.new(1, 0, 1, -(__Ixa_guiHeaderHeight + (bo and __Ixa_guiProfileHeight + 4 or 12))),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				Parent = bj,
			}
		)
		a7.TabList = bp
		local bq = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(8, 2),
				Size = UDim2.new(1, -16, 0, __Ixa_guiTabHeight),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.35,
				BorderSizePixel = 0,
				Visible = false,
				Parent = bp,
			}
		)
		__Ixa_guiCorner(bq, UDim.new(0, 7))
		local br = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(2, 14),
				BackgroundColor3 = __Ixa_guiTheme.Accent,
				Visible = false,
				BorderSizePixel = 0,
				Parent = bq,
			}
		)
		__Ixa_guiCorner(br, UDim.new(1, 0))
		a7._indicatorPill = br
		a7.Indicator = bq
		local bs = __Ixa_guiNew(
			"Frame",
			{
				Name = "Stack",
				Position = UDim2.fromOffset(8, 2),
				Size = UDim2.new(1, -16, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ZIndex = 2,
				Parent = bp,
			}
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = bs })
		a7._tabStack = bs
		a7:_overflowHint(bj, bp, bs, true, __Ixa_guiTheme.Surface)
		if bo then
			a7:_buildProfile(bj)
		end
		local bt = __Ixa_guiNew(
			"Frame",
			{
				Name = "Content",
				Position = UDim2.fromOffset(__Ixa_guiSidebarWidth + 1, 0),
				Size = UDim2.new(1, -(__Ixa_guiSidebarWidth + 1), 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = bi,
			}
		)
		a7.Content = bt
		a7:_sidebarResize(bj, tonumber(a4.SidebarWidth) or __Ixa_guiSidebarWidth)
		a7._outLayer = __Ixa_guiNew(
			"CanvasGroup",
			{ Name = "TransitionOut", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = bt }
		)
		a7._inLayer = __Ixa_guiNew(
			"CanvasGroup",
			{ Name = "TransitionIn", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 3, Parent = bt }
		)
		local bu = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -14, 0, 14),
				Size = UDim2.fromOffset(34, 34),
				BackgroundColor3 = __Ixa_guiTheme.Surface2,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 5,
				Parent = bt,
			}
		)
		bu:SetAttribute("NoDrag", true)
		local bv = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(20, 20),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ScaleType = Enum.ScaleType.Fit,
				Parent = bu,
			}
		)
		__Ixa_guiApplyIcon(bv, "minimize-2")
		bu.MouseEnter:Connect(function()
			__Ixa_guiTween(bv, { ImageColor3 = __Ixa_guiTheme.Text, Size = UDim2.fromOffset(18, 18) }, 0.2, Enum.EasingStyle.Quint)
		end)
		bu.MouseLeave:Connect(function()
			__Ixa_guiTween(bv, { ImageColor3 = __Ixa_guiTheme.Muted, Size = UDim2.fromOffset(20, 20) }, 0.25, Enum.EasingStyle.Quint)
		end)
		bu.MouseButton1Click:Connect(function()
			a7:Minimize()
		end)
		a7.MinimizeButton = bu
		if a4.Search ~= false then
			a7:_buildSearch(bt)
		end
		local bw = __Ixa_guiNew(
			"Frame",
			{
				Name = "Notifications",
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -20, 1, -20),
				Size = UDim2.new(0, 280, 1, -40),
				BackgroundTransparency = 1,
				Parent = bd,
			}
		)
		local function bx()
			bw.Size = UDim2.new(0, math.min(280, bd.AbsoluteSize.X - 40), 1, -40)
		end
		table.insert(a7._connections, bd:GetPropertyChangedSignal("AbsoluteSize"):Connect(bx))
		__Ixa_guiNew(
			"UIListLayout",
			{
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 4),
				Parent = bw,
			}
		)
		a7.NotifyHolder = bw
		a7._notifyOrder = 0
		a7._toasts = {}
		a7.MaxNotifications = a4.MaxNotifications or 4
		a7._controlsDirty = true
		table.insert(
			a7._connections,
			bi.DescendantAdded:Connect(function()
				a7._controlsDirty = true
			end)
		)
		table.insert(
			a7._connections,
			bi.DescendantRemoving:Connect(function()
				a7._controlsDirty = true
			end)
		)
		a7:SetDragStyle(a4.DragStyle or (a4.DragSkeleton == false and "Off" or "Outline"))
		a7:SetIslandStyle(a4.IslandStyle)
		if a4.Transparent then
			a7:SetTransparent(true)
		end
		if a4.Background then
			task.spawn(a7.SetBackground, a7, a4.Background)
		end
		a7:_enableDrag()
		a7.MaxSize = a4.MaxSize
		a7.KeepOnScreen = a4.KeepOnScreen ~= false
		a7:_enableResize(a4.MinSize or Vector2.new(480, 360))
		if a4.SaveSize ~= false then
			local by = a7
			local bz = { _type = "WindowSize", _listeners = {} }
			function bz:Get()
				local bA = by:GetSize()
				return { Width = bA.X, Height = bA.Y }
			end
			function bz:Set(bA)
				if type(bA) == "table" and tonumber(bA.Width) and tonumber(bA.Height) then
					by:SetSize(Vector2.new(tonumber(bA.Width), tonumber(bA.Height)))
				end
			end
			local bA = type(a4.SaveSize) == "string" and a4.SaveSize or "__WindowSize"
			__Ixa_guiLibrary.Flags[bA] = bz
			a7:_flagCreated(bA, bz)
		end
		table.insert(
			a7._connections,
			__Ixa_guiInputService.InputBegan:Connect(function(by, bz)
				if __Ixa_guiInputService:GetFocusedTextBox() then
					return
				end
				if by.UserInputType == Enum.UserInputType.Keyboard and by.KeyCode == a7.Keybind then
					task.defer(function()
						local bA = a7._consumedKey == by.KeyCode and os.clock() - (a7._consumedAt or 0) < 0.2
						a7._consumedKey = nil
						if not bA and not a7._destroyed then
							if a7.Minimized then
								a7:Restore()
							else
								a7:Toggle(not a7.Open)
							end
						end
					end)
				end
			end)
		)
		pcall(function()
			if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
				syn.protect_gui(bd)
			end
		end)
		local mounted = false
		if type(a4.AttachGui) == "function" then
			local ok, result = pcall(a4.AttachGui, bd)
			mounted = ok and result == true
		end
		if not mounted then
			bd.Parent = a4.Parent or __Ixa_guiParent()
		end
		bf.Scale = 0.9
		bg.ImageTransparency = 1
		a7.BodyStroke.Transparency = 1
		be.Visible = false
		a7:_fitToScreen(true)
		table.insert(
			a7._connections,
			bd:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				a7:_fitToScreen()
				a7:_clampToScreen()
			end)
		)
		local by = a4.ToggleButton
		if by == nil or by == true then
			by = {}
		end
		if type(by) == "table" then
			a7:_createToggleButton(by)
		end
		local bz = a7.ToggleButton ~= nil and a7:_toggleButtonAllowed()
		if (a4.OpenButton ~= nil and a4.OpenButton ~= false) or (a4.OpenButton == nil and __Ixa_guiTouch and not bz) then
			a7:_createOpenButton(type(a4.OpenButton) == "table" and a4.OpenButton or {})
		end
		if a4.Backdrop ~= false then
			a7:_buildBackdrop(type(a4.Backdrop) == "table" and a4.Backdrop or {})
		end
		a7._introDone = false
		if a4.Home ~= false then
			a7:_buildHome(type(a4.Home) == "table" and a4.Home or {})
		end
		local bA = a4.Loading
		if type(bA) == "table" then
			a4.LoadingDuration = bA.Duration or a4.LoadingDuration
			a4.LoadingText = bA.Text or bA.Subtitle or a4.LoadingText
			a4.LoadingSteps = bA.Steps or a4.LoadingSteps
			a4.LoadingTitle = bA.Title or a4.LoadingTitle
			bA = bA.Enabled ~= false
		end
		local bB = {}
		local bC = a4.UnsupportedExecutor
		if bC ~= false then
			bC = type(bC) == "table" and bC or {}
			local bD = a4.SupportedExecutors or (type(a4.Home) == "table" and a4.Home.SupportedExecutors or nil)
			local bE, bF, bG = __Ixa_guiCompatibility({ SupportedExecutors = bD })
			if not bF and not __Ixa_guiDisclaimer.Saved(a7.ConfigFolder, bE) then
				local bH = bC.Block == true
				local bI = a7.ConfigFolder
				table.insert(bB, {
					Title = bC.Title or "Unsupported executor",
					Subtitle = bE,
					Text = bH and ((bC.Text or bG) .. " This script can't run here.") or (bC.Text or bG),
					Icon = "shield-alert",
					Color = __Ixa_guiTheme.Warning,
					ContinueText = "Continue anyway",
					ExitText = "Exit",
					Block = bH,
					RememberText = "Don't ask again on this executor",
					Remember = function()
						__Ixa_guiDisclaimer.Save(bI, bE)
					end,
				})
			end
		end
		local bD = a4.Disclaimer or a4.Disclaimers
		if type(bD) == "string" or (type(bD) == "table" and (bD.Title ~= nil or bD.Text ~= nil)) then
			bD = { bD }
		end
		if type(bD) == "table" then
			for bE, bF in ipairs(bD) do
				if type(bF) == "string" then
					bF = { Text = bF }
				end
				if type(bF) == "table" then
					local bG = __Ixa_guiDisclaimer.DisclaimerKey(bF)
					local bH = a7.ConfigFolder
					local bI = bF.Block == true
					local bJ = bF.Remember ~= false and not bI
					if not (bJ and __Ixa_guiDisclaimer.DisclaimerAccepted(bH, bG)) then
						local bK = bF.Callback
						table.insert(bB, {
							Title = bF.Title or "Disclaimer",
							Subtitle = bF.Subtitle,
							Text = bF.Text or "",
							Icon = bF.Icon or "info",
							Color = bF.Color or __Ixa_guiTheme.Accent,
							ContinueText = bF.AcceptText or "I understand",
							ExitText = bF.DeclineText == nil and "Exit" or bF.DeclineText,
							RememberText = bJ and (bF.RememberText or "Don't show again") or nil,
							Remember = function()
								__Ixa_guiDisclaimer.AcceptDisclaimer(bH, bG)
							end,
							Callback = type(bK) == "function" and bK or nil,
							Block = bI,
						})
					end
				end
			end
		end
		if #bB > 0 then
			a4._prompts = bB
		end
		if bA == false and a4._prompts then
			a4.LoadingDuration = a4.LoadingDuration or 0.5
			bA = true
		end
		if bA == false then
			task.defer(function()
				a7:_playIntro()
			end)
		else
			a7:_showLoader(a4)
		end
		return a7
	end
	__Ixa_guiLibrary.CreateWindow = __Ixa_guiLibrary.Window
	function __Ixa_guiLibrary:Notify(a3)
		local a4 = __Ixa_guiLibrary.Windows[#__Ixa_guiLibrary.Windows]
		if a4 then
			return a4:Notify(a3)
		end
	end
	function __Ixa_guiLibrary:Confirm(a3)
		local a4 = __Ixa_guiLibrary.Windows[#__Ixa_guiLibrary.Windows]
		if a4 then
			return a4:Confirm(a3)
		end
	end
	function __Ixa_guiLibrary:Dialog(a3)
		local a4 = __Ixa_guiLibrary.Windows[#__Ixa_guiLibrary.Windows]
		if a4 then
			return a4:Dialog(a3)
		end
	end
	local function a3(a4, a5, a6)
		local a7 = a4
		while a7 and a7 ~= a5 and a7:IsA("GuiObject") do
			if not a7.Visible then
				return false
			end
			local a8 = a7.Parent
			if
				a8
				and a8 ~= a5
				and a8:IsA("GuiObject")
				and (a8.ClipsDescendants or a8:IsA("ScrollingFrame"))
				and not __Ixa_guiContainsPoint(a6, a8)
			then
				return false
			end
			a7 = a8
		end
		return true
	end
	function __Ixa_guiWindow:_refreshControls()
		local a4 = {}
		for a5, a6 in ipairs(self.Body:GetDescendants()) do
			if a6:IsA("GuiButton") or a6:IsA("TextBox") or a6:GetAttribute("NoDrag") then
				table.insert(a4, a6)
			end
		end
		self._controls = a4
		self._controlsDirty = false
	end
	function __Ixa_guiWindow:_overControl(a4)
		if self._dialog or self:_overPopout(a4) then
			return true
		end
		if self._controlsDirty then
			self:_refreshControls()
		end
		for a5, a6 in ipairs(self._controls) do
			if a6.Parent and __Ixa_guiContainsPoint(a4, a6) and a3(a6, self.Body, a4) then
				return true
			end
		end
		return false
	end
	function __Ixa_guiWindow:_tooltipCard()
		if self._tip then
			return self._tip
		end
		local a4 = __Ixa_guiNew(
			"CanvasGroup",
			{
				Name = "Tooltip",
				Size = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 1,
				GroupTransparency = 1,
				Visible = false,
				ZIndex = 60,
				Parent = self.Gui,
			}
		)
		local a5 = __Ixa_guiNew("UIScale", { Parent = a4 })
		local a6 = 4
		local a7 = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(a6, a6),
				Size = UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Parent = a4,
			}
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = a7 })
		local function a8(a9)
			__Ixa_guiNew(
				"UIStroke",
				{
					Color = Color3.new(0, 0, 0),
					Transparency = 0.35,
					Thickness = 1,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
					Parent = a9,
				}
			)
		end
		local a9 = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.fromOffset(0, 18),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Parent = a7,
			}
		)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = a9,
			}
		)
		local ba = __Ixa_guiNew(
			"ImageLabel",
			{
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ScaleType = Enum.ScaleType.Fit,
				LayoutOrder = 1,
				Parent = a9,
			}
		)
		local bb = __Ixa_guiLabel({
			Size = UDim2.fromOffset(0, 18),
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Bold,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 2,
			Parent = a9,
		})
		a8(bb)
		local bc = __Ixa_guiLabel({
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Medium,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			TextYAlignment = Enum.TextYAlignment.Top,
			LineHeight = 1.1,
			LayoutOrder = 2,
			Parent = a7,
		})
		a8(bc)
		__Ixa_guiNew("UISizeConstraint", { MaxSize = Vector2.new(240, math.huge), Parent = bc })
		local function bd()
			local be = math.max(a5.Scale, 0.01)
			local bf = a7.AbsoluteSize / be
			a4.Size = UDim2.fromOffset(bf.X + a6 * 2, bf.Y + a6 * 2)
		end
		a7:GetPropertyChangedSignal("AbsoluteSize"):Connect(bd)
		local be =
			{ Holder = a4, Scale = a5, Pad = a6, Head = a9, Icon = ba, Title = bb, Body = bc, Shown = false, Fit = bd }
		self._tip = be
		self:_listen("Render", function(bf)
			local bg = self._tipOwner
			if not bg then
				return
			end
			local bh = bg._frame
			if
				bg._destroyed
				or not self.Open
				or self.Minimized
				or not bh
				or not bh.Parent
				or (bg._isShown and not bg:_isShown())
				or not a3(bh, self.Body, bh.AbsolutePosition + bh.AbsoluteSize / 2)
			then
				self:_hideTooltip()
				return
			end
			local bi = __Ixa_guiMousePosition() - self.Gui.AbsolutePosition
			local bj = be.Pad * a5.Scale
			local bk = a4.AbsoluteSize - Vector2.one * bj * 2
			local bl = self.Gui.AbsoluteSize
			local bm, bn
			if be.Touch then
				bm, bn = bi.X - bk.X / 2, bi.Y - bk.Y - 30
			else
				bm, bn = bi.X + 14, bi.Y + 20
				if bm + bk.X > bl.X - 8 then
					bm = bi.X - bk.X - 10
				end
				if bn + bk.Y > bl.Y - 8 then
					bn = bi.Y - bk.Y - 12
				end
			end
			local bo = Vector2.new(
				math.clamp(bm, 8, math.max(8, bl.X - bk.X - 8)),
				math.clamp(bn, 8, math.max(8, bl.Y - bk.Y - 8))
			)
			local bp = be.Position
			if not bp or be.Snap then
				bp = bo + Vector2.new(0, 6)
				be.Snap = false
			else
				bp = bp:Lerp(bo, math.min(bf * 22, 1))
			end
			be.Position = bp
			a4.Position = UDim2.fromOffset(math.floor(bp.X - bj + 0.5), math.floor(bp.Y - bj + 0.5))
		end)
		self:_listen("Began", function(bf)
			if
				self._tipOwner
				and not be.Touch
				and (
					bf.UserInputType == Enum.UserInputType.MouseButton1
					or bf.UserInputType == Enum.UserInputType.MouseButton2
					or bf.UserInputType == Enum.UserInputType.Keyboard
				)
			then
				self:_hideTooltip()
			end
		end)
		return be
	end
	function __Ixa_guiWindow:_showTooltip(a4, a5)
		local a6 = a4._tooltip
		local a7, a8, a9
		if type(a6) == "table" then
			a7, a8, a9 = a6.Text or a6.Content or a6.Desc, a6.Title or a6.Name, a6.Icon
		elseif a6 ~= nil and a6 ~= false then
			a7 = tostring(a6)
		end
		if (a7 == nil or a7 == "") and (a8 == nil or a8 == "") then
			return
		end
		local ba = self:_tooltipCard()
		ba.Title.Text = a8 or ""
		ba.Title.Visible = a8 ~= nil and a8 ~= ""
		ba.Icon.Visible = a9 ~= nil
		if a9 ~= nil then
			__Ixa_guiApplyIcon(ba.Icon, a9)
		end
		ba.Head.Visible = ba.Title.Visible or a9 ~= nil
		ba.Body.Text = a7 or ""
		ba.Body.Visible = a7 ~= nil and a7 ~= ""
		ba.Fit()
		ba.Body.TextColor3 = __Ixa_guiTheme.Text
		ba.Scale.Scale = math.max(self.Scale.Scale, 0.75)
		ba.Touch = a5 == true
		local bb = ba.Shown
		self._tipOwner = a4
		ba.Shown = true
		ba.Generation = (ba.Generation or 0) + 1
		local bc = ba.Holder
		if not bb then
			ba.Snap = true
			bc.Visible = true
			bc.GroupTransparency = 1
			ba.Scale.Scale = ba.Scale.Scale * 0.96
		end
		__Ixa_guiTween(bc, { GroupTransparency = 0 }, 0.14, Enum.EasingStyle.Quad)
		__Ixa_guiTween(ba.Scale, { Scale = math.max(self.Scale.Scale, 0.75) }, 0.18, Enum.EasingStyle.Back)
	end
	function __Ixa_guiWindow:_hideTooltip(a4)
		local a5 = self._tip
		if not a5 or not a5.Shown or (a4 and self._tipOwner ~= a4) then
			return
		end
		self._tipOwner = nil
		self._tipHiddenAt = os.clock()
		a5.Shown = false
		a5.Generation = (a5.Generation or 0) + 1
		local a6 = a5.Generation
		__Ixa_guiTween(a5.Holder, { GroupTransparency = 1 }, 0.1, Enum.EasingStyle.Quad)
		task.delay(0.1, function()
			if a5.Generation == a6 then
				a5.Holder.Visible = false
			end
		end)
	end
	function __Ixa_guiWindow:_attachTooltip(a4, a5)
		local a6, a7, a8 = false, 0, nil
		local function a9(ba, bb)
			a7 += 1
			local bc = a7
			task.delay(ba, function()
				if a7 ~= bc or not a6 or a4._destroyed or self._destroyed then
					return
				end
				if bb and a8 and (__Ixa_guiMousePosition() - a8).Magnitude > 10 then
					return
				end
				self:_showTooltip(a4, bb)
			end)
		end
		table.insert(
			a4._listeners,
			(function()
				local ba = {
					a5.MouseEnter:Connect(function()
						if __Ixa_guiIsTouch() then
							return
						end
						a6 = true
						local ba = os.clock() - (self._tipHiddenAt or 0) < 0.35 or self._tipOwner ~= nil
						a9(ba and 0 or 0.45, false)
					end),
					a5.MouseLeave:Connect(function()
						a6 = false
						a7 += 1
						self:_hideTooltip(a4)
					end),
					a5.InputBegan:Connect(function(ba)
						if ba.UserInputType == Enum.UserInputType.Touch then
							a6 = true
							a8 = __Ixa_guiMousePosition()
							a9(0.5, true)
						end
					end),
					a5.InputEnded:Connect(function(ba)
						if ba.UserInputType == Enum.UserInputType.Touch then
							a6 = false
							a7 += 1
							self:_hideTooltip(a4)
						end
					end),
				}
				return function()
					for bb, bc in ipairs(ba) do
						bc:Disconnect()
					end
				end
			end)()
		)
	end
	__Ixa_guiLibrary.DragStyles = { "Outline", "Brackets", "Ghost", "Frame", "Off" }
	local function a4(a5)
		local a6 = a5.Root
		local a7 = a5.DragStyle or "Outline"
		local a8 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = a6.AnchorPoint,
				Position = a6.Position,
				Size = UDim2.fromOffset(a6.AbsoluteSize.X, a6.AbsoluteSize.Y),
				BackgroundColor3 = a7 == "Ghost" and __Ixa_guiTheme.Background or __Ixa_guiTheme.Accent,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 40,
				Parent = a5.Gui,
			}
		)
		__Ixa_guiCorner(a8, UDim.new(0, 10))
		local a9 = {}
		local function ba(bb, bc)
			local bd = {}
			for be in pairs(bc) do
				bd[be] = 1
			end
			table.insert(a9, { Object = bb, Shown = bc, Hidden = bd })
		end
		local function bb(bc, bd)
			for be, bf in ipairs({ Vector2.new(0, 0), Vector2.new(1, 0), Vector2.new(0, 1), Vector2.new(1, 1) }) do
				local bg = UDim2.new(bf.X, bf.X == 0 and bd or -bd, bf.Y, bf.Y == 0 and bd or -bd)
				for bh, bi in ipairs({ UDim2.fromOffset(bc, 2), UDim2.fromOffset(2, bc) }) do
					local bj = __Ixa_guiNew(
						"Frame",
						{
							AnchorPoint = bf,
							Position = bg,
							Size = bi,
							BackgroundColor3 = __Ixa_guiTheme.Accent,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Parent = a8,
						}
					)
					__Ixa_guiCorner(bj, UDim.new(1, 0))
					ba(bj, { BackgroundTransparency = 0 })
				end
			end
		end
		if a7 == "Brackets" then
			bb(22, 0)
		elseif a7 == "Ghost" then
			ba(a8, { BackgroundTransparency = 0.35 })
			ba(__Ixa_guiStroke(a8, __Ixa_guiTheme.Stroke, 1, 1), { Transparency = 0 })
		elseif a7 == "Frame" then
			ba(__Ixa_guiStroke(a8, __Ixa_guiTheme.StrokeHover, 1, 1), { Transparency = 0 })
		else
			ba(a8, { BackgroundTransparency = 0.92 })
			ba(__Ixa_guiStroke(a8, __Ixa_guiTheme.Accent, 1, 1.5), { Transparency = 0.2 })
			bb(16, 6)
		end
		local bc = __Ixa_guiNew("UIScale", { Scale = 1.02, Parent = a8 })
		for bd, be in ipairs(a9) do
			__Ixa_guiTween(be.Object, be.Shown, 0.15, Enum.EasingStyle.Quad)
		end
		__Ixa_guiTween(bc, { Scale = 1 }, 0.25, Enum.EasingStyle.Quint)
		local function bd()
			for be, bf in ipairs(a9) do
				__Ixa_guiTween(bf.Object, bf.Hidden, 0.2, Enum.EasingStyle.Quad)
			end
			task.delay(0.22, function()
				a8:Destroy()
			end)
		end
		return a8, bd
	end
	function __Ixa_guiWindow:_enableDrag()
		local a5, a6 = false, false
		local a7, a8 = Vector2.zero, Vector2.zero
		local a9 = nil
		local ba, bb = nil, nil
		local function bc()
			local bd = self.Root
			return bd.AbsolutePosition + bd.AbsoluteSize * bd.AnchorPoint - self.Gui.AbsolutePosition
		end
		local function bd()
			if not ba then
				return
			end
			local be = Vector2.new(ba.Position.X.Offset, ba.Position.Y.Offset)
			if self.KeepOnScreen then
				be = self:_clampedCentre(be)
			end
			if self._clampTween then
				self._clampTween:Cancel()
			end
			self._clampTween = __Ixa_guiTween(self.Root, { Position = UDim2.fromOffset(be.X, be.Y) }, 0.3, Enum.EasingStyle.Quint)
			bb()
			ba, bb = nil, nil
		end
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputBegan:Connect(function(be)
				if not __Ixa_guiIsPointerPress(be) then
					return
				end
				if not self.Open or not self.Root.Visible then
					return
				end
				local bf = __Ixa_guiMousePosition()
				if self._resizeActive or (self._grip and __Ixa_guiContainsPoint(bf, self._grip)) then
					return
				end
				if not __Ixa_guiContainsPoint(bf, self.Body) or self:_overControl(bf) then
					return
				end
				if self._clampTween then
					self._clampTween:Cancel()
					self._clampTween = nil
				end
				a5, a6 = true, false
				a8 = bf
				a7 = bf - bc()
			end)
		)
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputEnded:Connect(function(be)
				if not a5 then
					return
				end
				if __Ixa_guiIsPointerPress(be) then
					a5 = false
					a9 = nil
					if ba then
						bd()
					else
						self:_clampToScreen()
					end
				end
			end)
		)
		table.insert(self._frameSteps, function(be)
			if not a5 then
				return
			end
			local bf = __Ixa_guiMousePosition()
			if not a6 and (bf - a8).Magnitude > 3 then
				a6 = true
				if self.DragSkeleton then
					ba, bb = a4(self)
				end
			end
			if not a6 then
				return
			end
			if ba and (not self.Open or not self.Root.Visible) then
				a5 = false
				bd()
				return
			end
			a9 = bf - a7
			local bg = 1 - math.exp(-be * 45)
			if ba then
				local bh = Vector2.new(ba.Position.X.Offset, ba.Position.Y.Offset)
				local bi = bh:Lerp(a9, bg)
				ba.Position = UDim2.fromOffset(bi.X, bi.Y)
			else
				local bh = bc():Lerp(a9, bg)
				self.Root.Position = UDim2.fromOffset(bh.X, bh.Y)
			end
		end)
	end
	function __Ixa_guiWindow:SetDragStyle(a5)
		a5 = table.find(__Ixa_guiLibrary.DragStyles, a5) and a5 or "Outline"
		self.DragStyle = a5
		self.DragSkeleton = a5 ~= "Off"
		return a5
	end
	function __Ixa_guiWindow:GetDragStyle()
		return self.DragStyle
	end
	__Ixa_guiLibrary.IslandStyles = { "Show on Hover", "Always Show" }
	function __Ixa_guiWindow:SetIslandStyle(a5)
		a5 = table.find(__Ixa_guiLibrary.IslandStyles, a5) and a5 or "Show on Hover"
		self.IslandStyle = a5
		if self._islandSettle then
			self._islandSettle()
		end
		return a5
	end
	function __Ixa_guiWindow:GetIslandStyle()
		return self.IslandStyle
	end
	function __Ixa_guiWindow:SetDragSkeleton(a5)
		if a5 == false then
			self:SetDragStyle("Off")
		elseif self.DragStyle == "Off" or not self.DragStyle then
			self:SetDragStyle("Outline")
		end
	end
	function __Ixa_guiWindow:_sidebarResize(a5, a6)
		local a7 = a5:FindFirstChild("Divider")
		local a8 = a6
		local function a9(ba, bb)
			if bb ~= false then
				a8 = ba
			end
			local bc = self.Body.AbsoluteSize.X / self.Scale.Scale - 300
			ba = math.floor(math.clamp(ba, 150, math.max(math.min(300, bc), 150)))
			self.SidebarWidth = ba
			a5.Size = UDim2.new(0, ba, 1, 0)
			self.Content.Position = UDim2.fromOffset(ba + 1, 0)
			self.Content.Size = UDim2.new(1, -(ba + 1), 1, 0)
		end
		self.SetSidebarWidth = function(ba, bb)
			a9(tonumber(bb) or __Ixa_guiSidebarWidth)
		end
		a9(a6)
		local ba = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(0, 6, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 6,
				Parent = a5,
			}
		)
		ba:SetAttribute("NoDrag", true)
		local bb, bc, bd = false, 0, a6
		local function be(bf)
			if a7 then
				__Ixa_guiTween(a7, { BackgroundColor3 = bf and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke }, 0.15)
			end
		end
		ba.MouseEnter:Connect(function()
			be(true)
		end)
		ba.MouseLeave:Connect(function()
			if not bb then
				be(false)
			end
		end)
		ba.InputBegan:Connect(function(bf)
			if bf.UserInputType == Enum.UserInputType.MouseButton1 or bf.UserInputType == Enum.UserInputType.Touch then
				bb, bc, bd = true, bf.Position.X, self.SidebarWidth
				a8 = bd
				be(true)
			end
		end)
		self:_listen("Changed", function(bf)
			if bb and __Ixa_guiIsPointerMove(bf) then
				a9(bd + (bf.Position.X - bc) / self.Scale.Scale)
			end
		end)
		self:_listen("Ended", function(bf)
			if
				bb and (
					bf.UserInputType == Enum.UserInputType.MouseButton1
					or bf.UserInputType == Enum.UserInputType.Touch
				)
			then
				bb = false
				be(false)
			end
		end)
		self.Body:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if not bb then
				a9(a8, false)
			end
		end)
	end
	function __Ixa_guiWindow:SetTransparent(a5)
		self.Transparent = a5 == true
		local a6 = self.Transparent
		self._shadowRest = a6 and 0.85 or 0.6
		__Ixa_guiTween(self.Body, { BackgroundTransparency = a6 and 0.35 or 0 }, 0.25)
		local a7 = a6 and 0.5 or (self.Background and 0.45 or 0)
		__Ixa_guiTween(self.SidebarFill, { BackgroundTransparency = a7 }, 0.25)
		if self.Open and not self.Minimized and self.Root.Visible then
			__Ixa_guiTween(self.Shadow, { ImageTransparency = self._shadowRest }, 0.25)
		end
	end
	local function a5(a6)
		local a7 = {}
		for a8, a9 in ipairs(a6:GetChildren()) do
			if a9:IsA("GuiObject") then
				table.insert(a7, a9)
			end
		end
		table.sort(a7, function(a8, a9)
			return a8.LayoutOrder < a9.LayoutOrder
		end)
		return a7
	end
	local function a6(a7, a8, a9)
		if not a7.Visible and not a9 then
			return
		end
		a7.Visible = false
		task.delay(a8, function()
			if not a7.Parent then
				return
			end
			local ba = __Ixa_guiNew("UIScale", { Scale = 0.94, Parent = a7 })
			a7.Visible = true
			__Ixa_guiTween(ba, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
			task.delay(0.4, function()
				ba:Destroy()
			end)
		end)
	end
	function __Ixa_guiWindow:_revealCards(a7, a8)
		local a9 = a7.CurrentSubTab or a7
		if a9._revealed then
			return
		end
		a9._revealed = true
		local ba = 0
		local function bb(bc)
			a6(bc, (a8 or 0) + ba * 0.035)
			ba += 1
		end
		local bc = a9._columnSet
		for bd, be in ipairs(a5(a9.List)) do
			if bc and be == bc.Holder then
				local bf, bg = a5(bc.Left), a5(bc.Right)
				for bh = 1, math.max(#bf, #bg) do
					if bf[bh] then
						bb(bf[bh])
					end
					if bg[bh] then
						bb(bg[bh])
					end
				end
			else
				bb(be)
			end
		end
	end
	function __Ixa_guiWindow:_playIntro(a7)
		if self._introDone or self._destroyed then
			return
		end
		self._introDone = true
		self:_refreshBackdrop(true)
		task.delay(0.4, function()
			self:_refreshToggleButton()
		end)
		task.delay(1.5, function()
			if not self._destroyed and not self.MiniBar then
				self:_buildMiniBar()
			end
		end)
		if self:GetMinimizeOnStart() then
			task.delay(0.6, function()
				if not self._destroyed and self.Open and not self.Minimized then
					self:Minimize()
				end
			end)
		end
		local a8, a9, ba = self.Root, self.Shadow, self.Scale
		if self.CurrentTab then
			self:_revealCards(self.CurrentTab, a7 and 0.15 or 0.25)
		end
		a8.Visible = true
		if a7 then
			ba.Scale = self._fitScale or 1
			a8.Position = UDim2.fromScale(0.5, 0.5)
			self:_fade(0, 0.3)
			__Ixa_guiTween(self.BodyStroke, { Transparency = 0 }, 0.3)
			__Ixa_guiTween(a9, { ImageTransparency = 0.6 }, 0.3)
		else
			a8.Position = UDim2.new(0.5, 0, 0.5, 24)
			__Ixa_guiTween(ba, { Scale = self._fitScale or 1 }, 0.5, Enum.EasingStyle.Back)
			__Ixa_guiTween(a8, { Position = UDim2.fromScale(0.5, 0.5) }, 0.5, Enum.EasingStyle.Quint)
			self:_fade(0, 0.35)
			__Ixa_guiTween(self.BodyStroke, { Transparency = 0 }, 0.35)
		end
		if not a7 then
			__Ixa_guiTween(a9, { ImageTransparency = 0.6 }, 0.5)
		end
		for bb, bc in ipairs(self.Tabs) do
			a6(bc._button, 0.1 + bb * 0.05, true)
		end
		self.Indicator.Visible = false
		task.delay(0.15 + #self.Tabs * 0.05, function()
			if self.CurrentTab then
				self:_placeIndicator(self.CurrentTab)
			end
		end)
	end
	function __Ixa_guiWindow:_showLoader(a7)
		local a8 = a7.LoadingDuration or 1.6
		local a9 = self.Gui
		local ba = a7.LoadingSteps or { "Preparing interface", "Loading icons", "Almost there" }
		local bb, bc, bd = 340, 22, 24
		local be = 80
		local bf = be + #ba * bd + 18
		local bg = __Ixa_guiNew(
			"CanvasGroup",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 10),
				Size = UDim2.fromOffset(bb, bf),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				GroupTransparency = 1,
				ZIndex = 10,
				Parent = a9,
			}
		)
		local bh = __Ixa_guiCorner(bg, UDim.new(0, 12))
		local bi = __Ixa_guiStroke(bg, __Ixa_guiTheme.Stroke, 1)
		local bj = __Ixa_guiNew("UIScale", { Scale = 0.97, Parent = bg })
		local bk = __Ixa_guiNew(
			"ImageLabel",
			{
				Position = UDim2.fromOffset(-25, -25),
				Size = UDim2.new(1, 50, 1, 50),
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Shadow,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(49, 49, 450, 450),
				ZIndex = 0,
				Parent = bg,
			}
		)
		local bl = __Ixa_guiNew("CanvasGroup", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = bg })
		local bm = __Ixa_guiNew(
			"ImageLabel",
			{
				Position = UDim2.fromOffset(bc, bc),
				Size = UDim2.fromOffset(30, 30),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ScaleType = Enum.ScaleType.Fit,
				Parent = bl,
			}
		)
		__Ixa_guiApplyIcon(bm, a7.Icon or __Ixa_guiAssets.Logo, true)
		local bn = bc + 42
		local bo = __Ixa_guiLabel({
			Position = UDim2.fromOffset(bn, bc - 2),
			Size = UDim2.new(1, -(bn + 70), 0, 18),
			Text = a7.LoadingTitle or a7.Title or "Airflow",
			TextSize = 15,
			FontFace = __Ixa_guiFonts.Bold,
			Parent = bl,
		})
		local bp = __Ixa_guiLabel({
			Position = UDim2.fromOffset(bn, bc + 17),
			Size = UDim2.new(1, -(bn + 70), 0, 15),
			Text = a7.LoadingText or a7.Subtitle or "Loading",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = bl,
		})
		local bq = __Ixa_guiLabel({
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -bc, 0, bc + 6),
			Size = UDim2.fromOffset(56, 16),
			Text = "0%",
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Medium,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = bl,
		})
		__Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(bc, be - 14),
				Size = UDim2.new(1, -bc * 2, 0, 1),
				BackgroundColor3 = __Ixa_guiTheme.Stroke,
				BorderSizePixel = 0,
				Parent = bl,
			}
		)
		local br = {}
		for bs, bt in ipairs(ba) do
			local bu = __Ixa_guiNew(
				"Frame",
				{
					Position = UDim2.fromOffset(bc, be + (bs - 1) * bd),
					Size = UDim2.new(1, -bc * 2, 0, bd),
					BackgroundTransparency = 1,
					Parent = bl,
				}
			)
			local bv = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0, 7, 0.5, 0),
					Size = UDim2.fromOffset(6, 6),
					BackgroundColor3 = __Ixa_guiTheme.Surface3,
					BorderSizePixel = 0,
					Parent = bu,
				}
			)
			__Ixa_guiCorner(bv, UDim.new(1, 0))
			local bw = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0, 7, 0.5, 0),
					Size = UDim2.fromOffset(12, 12),
					BackgroundTransparency = 1,
					Visible = false,
					Parent = bu,
				}
			)
			__Ixa_guiCorner(bw, UDim.new(1, 0))
			local bx = __Ixa_guiNew("UIStroke", { Color = __Ixa_guiTheme.Accent, Thickness = 2, Parent = bw })
			__Ixa_guiNew(
				"UIGradient",
				{
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.5, 0),
						NumberSequenceKeypoint.new(0.501, 1),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Parent = bx,
				}
			)
			local by = __Ixa_guiNew(
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0, 7, 0.5, 0),
					Size = UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Accent,
					ImageTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
					Parent = bu,
				}
			)
			__Ixa_guiApplyIcon(by, "check")
			local bz = __Ixa_guiLabel({
				Position = UDim2.fromOffset(24, 0),
				Size = UDim2.new(1, -24, 1, 0),
				Text = tostring(bt),
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextTransparency = 1,
				Parent = bu,
			})
			br[bs] = { Dot = bv, Spinner = bw, Check = by, Label = bz, State = "pending" }
			task.delay(0.15 + bs * 0.06, function()
				if bg.Parent and br[bs].State == "pending" then
					__Ixa_guiTween(bz, { TextTransparency = 0.45 }, 0.3)
				end
			end)
		end
		local function bs(bt, bu)
			local bv = br[bt]
			if not bv or bv.State == bu then
				return
			end
			bv.State = bu
			bv.Dot.Visible = bu == "pending"
			bv.Spinner.Visible = bu == "active"
			__Ixa_guiTween(bv.Check, { ImageTransparency = bu == "done" and 0 or 1 }, 0.2)
			__Ixa_guiTween(
				bv.Label,
				{ TextTransparency = bu == "pending" and 0.45 or 0, TextColor3 = bu == "active" and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted },
				0.2
			)
		end
		local bt = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Parent = bl,
			}
		)
		local bu =
			__Ixa_guiNew("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = __Ixa_guiTheme.Accent, BorderSizePixel = 0, Parent = bt })
		__Ixa_guiTween(bg, { GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, 0.45, Enum.EasingStyle.Quint)
		__Ixa_guiTween(bj, { Scale = 1 }, 0.45, Enum.EasingStyle.Quint)
		__Ixa_guiTween(bk, { ImageTransparency = 0.55 }, 0.4)
		__Ixa_guiTween(bu, { Size = UDim2.fromScale(0.85, 1) }, a8 * 0.8, Enum.EasingStyle.Quart)
		local bv
		bv = __Ixa_guiRunService.RenderStepped:Connect(function(bw)
			if not bg.Parent then
				bv:Disconnect()
				return
			end
			bq.Text = math.floor(bu.Size.X.Scale * 100 + 0.5) .. "%"
			for bx, by in ipairs(br) do
				if by.State == "active" then
					by.Spinner.Rotation = (by.Spinner.Rotation + bw * 360) % 360
				end
			end
		end)
		task.spawn(__Ixa_guiGetIcons)
		for bw in ipairs(ba) do
			task.delay(a8 * (bw - 1) / #ba, function()
				if not bg.Parent then
					return
				end
				if bw > 1 then
					bs(bw - 1, "done")
				end
				bs(bw, "active")
			end)
		end
		local function bw()
			for bx in ipairs(br) do
				bs(bx, "done")
			end
		end
		local function bx()
			bw()
			__Ixa_guiTween(bl, { GroupTransparency = 1 }, 0.18)
			local by = self._fitScale or 1
			local bz = self.Root.Size
			__Ixa_guiTween(
				bg,
				{ Size = UDim2.fromOffset(bz.X.Offset * by, bz.Y.Offset * by), Position = UDim2.fromScale(0.5, 0.5) },
				0.5,
				Enum.EasingStyle.Quint
			)
			__Ixa_guiTween(bh, { CornerRadius = UDim.new(0, __Ixa_guiLibrary._radius(10)) }, 0.5, Enum.EasingStyle.Quint)
			__Ixa_guiTween(bj, { Scale = 1 }, 0.5, Enum.EasingStyle.Quint)
			task.delay(0.28, function()
				self:_playIntro(true)
				__Ixa_guiTween(bg, { GroupTransparency = 1 }, 0.25)
				__Ixa_guiTween(bi, { Transparency = 1 }, 0.2)
				__Ixa_guiTween(bk, { ImageTransparency = 1 }, 0.2)
			end)
			task.delay(0.6, function()
				bg:Destroy()
			end)
		end
		local function by()
			bw()
			__Ixa_guiTween(bl, { GroupTransparency = 1 }, 0.18)
		end
		local function bz(bA, bB)
			local bC, bD, bE = 360, 24, 220
			local bF = bA.Color or __Ixa_guiTheme.Accent
			local bG = __Ixa_guiNew(
				"CanvasGroup",
				{
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.new(0, bC, 1, 0),
					BackgroundTransparency = 1,
					GroupTransparency = 1,
					ZIndex = 5,
					Parent = bg,
				}
			)
			local bH = __Ixa_guiNew(
				"Frame",
				{
					Position = UDim2.fromOffset(bD, bD),
					Size = UDim2.fromOffset(44, 44),
					BackgroundColor3 = bF,
					BackgroundTransparency = 0.86,
					BorderSizePixel = 0,
					Parent = bG,
				}
			)
			__Ixa_guiCorner(bH, UDim.new(0, 12))
			__Ixa_guiStroke(bH, bF, 1).Transparency = 0.6
			local bI = __Ixa_guiNew(
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(22, 22),
					BackgroundTransparency = 1,
					ImageColor3 = bF,
					ScaleType = Enum.ScaleType.Fit,
					Parent = bH,
				}
			)
			__Ixa_guiApplyIcon(bI, bA.Icon or "info")
			__Ixa_guiLabel({
				Position = UDim2.fromOffset(bD + 58, bA.Subtitle and bD + 3 or bD + 12),
				Size = UDim2.new(1, -(bD * 2 + 58), 0, 20),
				Text = bA.Title,
				TextSize = 17,
				Parent = bG,
			})
			if bA.Subtitle then
				__Ixa_guiLabel({
					Position = UDim2.fromOffset(bD + 58, bD + 25),
					Size = UDim2.new(1, -(bD * 2 + 58), 0, 16),
					Text = tostring(bA.Subtitle),
					TextSize = 13,
					TextColor3 = bF,
					Parent = bG,
				})
			end
			local bJ = __Ixa_guiNew(
				"ScrollingFrame",
				{
					Position = UDim2.fromOffset(bD, bD + 60),
					Size = UDim2.new(1, -bD * 2, 0, 16),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = __Ixa_guiTouch and 4 or 3,
					ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
					ScrollBarImageTransparency = 0.4,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					CanvasSize = UDim2.new(),
					Parent = bG,
				}
			)
			local bK = __Ixa_guiLabel({
				Size = UDim2.new(1, -8, 0, 0),
				Text = tostring(bA.Text),
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = bJ,
			})
			local bL = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, bD, 1, -bD + 4),
					Size = UDim2.new(1, -bD * 2, 0, 34),
					BackgroundTransparency = 1,
					Parent = bG,
				}
			)
			__Ixa_guiNew(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8),
					Parent = bL,
				}
			)
			local bM = false
			local bN = nil
			if not bA.Block and bA.RememberText and __Ixa_guiDisclaimer.Available() then
				local bO = __Ixa_guiTouch and 20 or 16
				bN = __Ixa_guiNew(
					"TextButton",
					{
						AnchorPoint = Vector2.new(0, 1),
						Position = UDim2.new(0, bD, 1, -bD + 4 - 34 - 12),
						Size = UDim2.new(1, -bD * 2, 0, __Ixa_guiTouch and 28 or 22),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						Parent = bG,
					}
				)
				local bP = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.fromScale(0, 0.5),
						Size = UDim2.fromOffset(bO, bO),
						BackgroundColor3 = __Ixa_guiTheme.Surface2,
						BorderSizePixel = 0,
						Parent = bN,
					}
				)
				__Ixa_guiCorner(bP, UDim.new(0, 4))
				local bQ = __Ixa_guiStroke(bP, __Ixa_guiTheme.Stroke, 1)
				local bR = __Ixa_guiNew(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(bO - 4, bO - 4),
						BackgroundTransparency = 1,
						ImageColor3 = __Ixa_guiTheme.AccentDark,
						ImageTransparency = 1,
						ScaleType = Enum.ScaleType.Fit,
						Parent = bP,
					}
				)
				__Ixa_guiApplyIcon(bR, "check")
				local bS = __Ixa_guiLabel({
					Position = UDim2.fromOffset(bO + 8, 0),
					Size = UDim2.new(1, -(bO + 8), 1, 0),
					Text = bA.RememberText,
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Muted,
					Parent = bN,
				})
				bN.MouseEnter:Connect(function()
					__Ixa_guiTween(bQ, { Color = bM and __Ixa_guiTheme.Accent or __Ixa_guiTheme.StrokeHover }, 0.12)
					__Ixa_guiTween(bS, { TextColor3 = __Ixa_guiTheme.Text }, 0.12)
				end)
				bN.MouseLeave:Connect(function()
					__Ixa_guiTween(bQ, { Color = bM and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke }, 0.2)
					__Ixa_guiTween(bS, { TextColor3 = bM and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted }, 0.2)
				end)
				bN.MouseButton1Click:Connect(function()
					bM = not bM
					__Ixa_guiTween(bP, { BackgroundColor3 = bM and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface2 }, 0.15)
					__Ixa_guiTween(bQ, { Color = bM and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke }, 0.15)
					__Ixa_guiTween(bR, { ImageTransparency = bM and 0 or 1 }, 0.15)
					__Ixa_guiTween(bS, { TextColor3 = bM and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted }, 0.15)
				end)
			end
			local bO = false
			local function bP(bQ, bR, bS, bT)
				local bU = __Ixa_guiNew(
					"TextButton",
					{
						Size = UDim2.fromOffset(0, 34),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = bR and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface2,
						BackgroundTransparency = bR and 0.12 or 0,
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						LayoutOrder = bS,
						Parent = bL,
					}
				)
				__Ixa_guiCorner(bU, UDim.new(0, 7))
				local bV = __Ixa_guiStroke(bU, bR and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke, 1)
				bV.Transparency = bR and 0.4 or 0
				__Ixa_guiPadding(bU, 14, 14)
				__Ixa_guiLabel({
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					Text = bQ,
					TextSize = 13,
					TextColor3 = bR and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Text,
					TextXAlignment = Enum.TextXAlignment.Center,
					Parent = bU,
				})
				bU.MouseEnter:Connect(function()
					if bR then
						__Ixa_guiTween(bU, { BackgroundTransparency = 0 }, 0.12)
						__Ixa_guiTween(bV, { Transparency = 0 }, 0.12)
					else
						__Ixa_guiTween(bV, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
					end
				end)
				bU.MouseLeave:Connect(function()
					if bR then
						__Ixa_guiTween(bU, { BackgroundTransparency = 0.12 }, 0.2)
						__Ixa_guiTween(bV, { Transparency = 0.4 }, 0.2)
					else
						__Ixa_guiTween(bV, { Color = __Ixa_guiTheme.Stroke }, 0.2)
					end
				end)
				bU.MouseButton1Click:Connect(function()
					if bO then
						return
					end
					bO = true
					bT()
				end)
			end
			if bA.ExitText ~= false then
				bP(bA.ExitText or "Exit", bA.Block, 1, function()
					if bA.Callback then
						task.spawn(bA.Callback, false)
					end
					__Ixa_guiTween(
						bg,
						{ GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 12) },
						0.25,
						Enum.EasingStyle.Quint
					)
					__Ixa_guiTween(bk, { ImageTransparency = 1 }, 0.2)
					task.delay(0.25, function()
						self:Destroy()
					end)
				end)
			end
			if not bA.Block then
				bP(bA.ContinueText or "Continue", true, 2, function()
					if bM and bA.Remember then
						bA.Remember()
					end
					if bA.Callback then
						task.spawn(bA.Callback, true)
					end
					__Ixa_guiTween(bG, { GroupTransparency = 1 }, 0.15)
					task.delay(0.15, function()
						bG:Destroy()
						bB()
					end)
				end)
			end
			local bQ = false
			local function bR()
				local bS, bT = pcall(function()
					local bS = Instance.new("GetTextBoundsParams")
					bS.Text = bK.Text
					bS.Font = bK.FontFace
					bS.Size = bK.TextSize
					bS.Width = bC - bD * 2 - 8
					return game:GetService("TextService"):GetTextBoundsAsync(bS)
				end)
				return bS and bT and math.ceil(bT.Y) + 2 or bK.TextBounds.Y
			end
			local function bS(bT)
				local bU = math.max(bR(), 16)
				local bV = math.min(bU, bE)
				bK.Size = UDim2.new(1, -8, 0, bU)
				bJ.Size = UDim2.new(1, -bD * 2, 0, bV)
				bJ.CanvasSize = UDim2.fromOffset(0, bU)
				local bW = bD + 60 + bV + 18 + 34 + bD - 4
				if bN then
					bW += bN.Size.Y.Offset + 10
				end
				__Ixa_guiTween(bg, { Size = UDim2.fromOffset(bC, bW) }, bT, Enum.EasingStyle.Quint)
			end
			bK:GetPropertyChangedSignal("TextBounds"):Connect(function()
				if bQ and bg.Parent and bG.Parent then
					bS(0.2)
				end
			end)
			task.delay(0.15, function()
				if not bg.Parent then
					return
				end
				bQ = true
				bS(0.35)
				task.delay(0.12, function()
					__Ixa_guiTween(bG, { GroupTransparency = 0 }, 0.3)
					bH.Size = UDim2.fromOffset(34, 34)
					bH.Position = UDim2.fromOffset(bD + 5, bD + 5)
					__Ixa_guiTween(
						bH,
						{ Size = UDim2.fromOffset(44, 44), Position = UDim2.fromOffset(bD, bD) },
						0.45,
						Enum.EasingStyle.Back
					)
				end)
			end)
		end
		local function bA(bB, bC)
			if not bg.Parent then
				return
			end
			local bD = bB[bC]
			if not bD then
				bx()
				return
			end
			bz(bD, function()
				bA(bB, bC + 1)
			end)
		end
		task.delay(a8, function()
			__Ixa_guiTween(bu, { Size = UDim2.fromScale(1, 1) }, 0.25, Enum.EasingStyle.Quint)
			task.delay(0.25, function()
				if not bg.Parent then
					return
				end
				if a7._prompts then
					by()
					bA(a7._prompts, 1)
				else
					bx()
				end
			end)
		end)
	end
	function __Ixa_guiWindow:_fitToScreen(a7)
		local a8 = self.Gui.AbsoluteSize
		if a8.X == 0 or a8.Y == 0 then
			return
		end
		local a9 = self.Root.Size
		local ba = (self._uiScale or 1) * (self._adaptive ~= false and __Ixa_guiLibrary._adaptiveFactor(a8) or 1)
		local bb = math.min(ba, (a8.X - 24) / math.max(a9.X.Offset, 1), (a8.Y - 24) / math.max(a9.Y.Offset, 1))
		self._fitScale = math.max(bb, 0.45)
		if self._introDone and self.Open then
			if a7 then
				self.Scale.Scale = self._fitScale
			else
				__Ixa_guiTween(self.Scale, { Scale = self._fitScale }, 0.2)
			end
		end
	end
	function __Ixa_guiLibrary._adaptiveFactor(a7)
		if __Ixa_guiTouch then
			return 1
		end
		local a8 = math.min(a7.X / 1920, a7.Y / 1020)
		if a8 > 0.9 and a8 < 1.15 then
			return 1
		end
		return math.clamp(math.floor(a8 * 20 + 0.5) / 20, 0.85, 1.75)
	end
	function __Ixa_guiWindow:SetAdaptiveSize(a7)
		self._adaptive = a7 ~= false
		self:_fitToScreen()
		task.delay(0.22, function()
			if not self._destroyed then
				self:_clampToScreen()
			end
		end)
	end
	function __Ixa_guiWindow:GetAdaptiveSize()
		return self._adaptive ~= false
	end
	function __Ixa_guiWindow:SetUIScale(a7)
		a7 = math.clamp(tonumber(a7) or 1, 0.6, 1.5)
		self.UIScale = a7
		self._uiScale = a7
		self:_fitToScreen()
		task.delay(0.22, function()
			if not self._destroyed then
				self:_clampToScreen()
			end
		end)
	end
	function __Ixa_guiWindow:GetUIScale()
		return self._uiScale or 1
	end
	__Ixa_guiLibrary.DensityModes = { Compact = 0.55, Default = 1, Comfortable = 1.45 }
	__Ixa_guiLibrary.Density = "Default"
	function __Ixa_guiLibrary._spaced(a7, a8)
		if a7 <= 0 then
			return 0
		end
		return math.max(math.floor(a7 * a8 + (a8 - 1) * 4 + 0.5), 0)
	end
	function __Ixa_guiLibrary._space(a7, a8)
		local a9 = __Ixa_guiLibrary.DensityModes[__Ixa_guiLibrary.Density] or 1
		if a7:IsA("UIListLayout") or a7:IsA("UIGridLayout") then
			a7:SetAttribute("Space", a8)
			a7.Padding = UDim.new(0, __Ixa_guiLibrary._spaced(a8, a9))
		elseif a7:IsA("UIPadding") then
			a7:SetAttribute("SpaceL", a8[1])
			a7:SetAttribute("SpaceR", a8[2])
			a7:SetAttribute("SpaceT", a8[3])
			a7:SetAttribute("SpaceB", a8[4])
			a7.PaddingLeft = UDim.new(0, math.floor(a8[1] * math.sqrt(a9) + 0.5))
			a7.PaddingRight = UDim.new(0, math.floor(a8[2] * math.sqrt(a9) + 0.5))
			a7.PaddingTop = UDim.new(0, __Ixa_guiLibrary._spaced(a8[3], a9))
			a7.PaddingBottom = UDim.new(0, __Ixa_guiLibrary._spaced(a8[4], a9))
		end
		return a7
	end
	function __Ixa_guiLibrary:SetDensity(a7)
		if type(a7) == "string" then
			for a8 in pairs(__Ixa_guiLibrary.DensityModes) do
				if a8:lower() == a7:lower() then
					a7 = a8
					break
				end
			end
		end
		if not __Ixa_guiLibrary.DensityModes[a7] then
			a7 = "Default"
		end
		__Ixa_guiLibrary.Density = a7
		for a8, a9 in ipairs(__Ixa_guiLibrary.Windows) do
			if a9.Gui and a9.Gui.Parent then
				for ba, bb in ipairs(a9.Gui:GetDescendants()) do
					local bc = bb:GetAttribute("Space")
					if bc then
						__Ixa_guiLibrary._space(bb, bc)
					elseif bb:GetAttribute("SpaceL") then
						__Ixa_guiLibrary._space(
							bb,
							{
								bb:GetAttribute("SpaceL"),
								bb:GetAttribute("SpaceR"),
								bb:GetAttribute("SpaceT"),
								bb:GetAttribute("SpaceB"),
							}
						)
					end
				end
			end
		end
		return a7
	end
	function __Ixa_guiWindow:SetDensity(a7)
		return __Ixa_guiLibrary:SetDensity(a7)
	end
	function __Ixa_guiWindow:GetDensity()
		return __Ixa_guiLibrary.Density
	end
	function __Ixa_guiWindow:_clampedCentre(a7)
		local a8 = self.Gui.AbsoluteSize
		local a9 = self.Root.AbsoluteSize / 2
		return Vector2.new(
			math.clamp(a7.X, math.min(a9.X, a8.X / 2), math.max(a8.X - a9.X, a8.X / 2)),
			math.clamp(a7.Y, math.min(a9.Y, a8.Y / 2), math.max(a8.Y - a9.Y, a8.Y / 2))
		)
	end
	function __Ixa_guiWindow:_clampToScreen()
		if not self.KeepOnScreen or self._resizeActive then
			return
		end
		local a7 = self.Root
		local a8 = a7.AbsolutePosition + a7.AbsoluteSize / 2 - self.Gui.AbsolutePosition
		local a9 = self:_clampedCentre(a8)
		if (a9 - a8).Magnitude > 0.5 then
			self._clampTween = __Ixa_guiTween(a7, { Position = UDim2.fromOffset(a9.X, a9.Y) }, 0.25, Enum.EasingStyle.Quint)
		end
	end
	function __Ixa_guiWindow:_createOpenButton(a7)
		local a8 = self.Gui
		local a9 = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 14),
				Size = UDim2.fromOffset(0, 40),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 30,
				Parent = a8,
			}
		)
		__Ixa_guiCorner(a9, UDim.new(1, 0))
		__Ixa_guiStroke(a9, __Ixa_guiTheme.Stroke)
		__Ixa_guiPadding(a9, 12, 16)
		local ba = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(20, 20),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 31,
				Parent = a9,
			}
		)
		__Ixa_guiApplyIcon(ba, a7.Icon or __Ixa_guiAssets.LogoSmall or __Ixa_guiAssets.Logo, true)
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(28, 0),
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = a7.Title or "Airflow",
			TextSize = 13,
			TextTruncate = Enum.TextTruncate.None,
			ZIndex = 31,
			Parent = a9,
		})
		self.OpenButton = a9
		local bb, bc = false, false
		local bd = Vector2.zero
		a9.InputBegan:Connect(function(be)
			if __Ixa_guiIsPointerPress(be) then
				bb = true
				bc = false
				bd = __Ixa_guiMousePosition() - a9.AbsolutePosition
			end
		end)
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputChanged:Connect(function(be)
				if not bb then
					return
				end
				if __Ixa_guiIsPointerMove(be) then
					local bf = __Ixa_guiMousePosition() - bd - a8.AbsolutePosition
					if (bf - (a9.AbsolutePosition - a8.AbsolutePosition)).Magnitude > 3 then
						bc = true
					end
					a9.AnchorPoint = Vector2.new(0, 0)
					a9.Position = UDim2.fromOffset(
						math.clamp(bf.X, 0, math.max(a8.AbsoluteSize.X - a9.AbsoluteSize.X, 0)),
						math.clamp(bf.Y, 0, math.max(a8.AbsoluteSize.Y - a9.AbsoluteSize.Y, 0))
					)
				end
			end)
		)
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputEnded:Connect(function(be)
				if bb and __Ixa_guiIsPointerPress(be) then
					bb = false
					if not bc then
						self:Toggle()
					end
				end
			end)
		)
	end
	function __Ixa_guiWindow:_toggleButtonAllowed()
		return self._toggleEnabled and (__Ixa_guiTouch or self._togglePlatform == "Both")
	end
	function __Ixa_guiWindow:_refreshToggleButton()
		local a7 = self.ToggleButton
		if not a7 then
			return
		end
		local a8 = self._introDone and not self._destroyed and self:_toggleButtonAllowed()
		if a8 and not a7.Visible then
			a7.Visible = true
			a7.Size = UDim2.fromOffset(0, 0)
			__Ixa_guiTween(a7, { Size = UDim2.fromOffset(self._toggleSize, self._toggleSize) }, 0.45, Enum.EasingStyle.Quint)
		elseif not a8 then
			a7.Visible = false
		end
		local a9 = self.Minimized or not self.Open
		__Ixa_guiTween(self._toggleStroke, { Color = a9 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke, Transparency = a9 and 0.3 or 0 }, 0.35)
		local ba = self._toggleIcon
		__Ixa_guiTween(ba, { Rotation = a9 and 180 or 0 }, 0.5, Enum.EasingStyle.Quint)
		if not ba:GetAttribute("CustomIcon") then
			__Ixa_guiTween(ba, { ImageColor3 = a9 and __Ixa_guiTheme.Text or __Ixa_guiTheme.Accent }, 0.35)
		end
	end
	function __Ixa_guiWindow:_createToggleButton(a7)
		local a8 = self.Gui
		local a9 = tonumber(a7.Size) or (__Ixa_guiTouch and 56 or 50)
		local ba = math.floor(a9 * 0.46)
		self._toggleEnabled = a7.Enabled ~= false
		self._togglePlatform = a7.Platform == "Both" and "Both" or "Mobile"
		self._toggleSize = a9
		local bb = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = a7.Position or UDim2.new(0, 18 + a9 / 2, 0.5, 0),
				Size = UDim2.fromOffset(a9, a9),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ClipsDescendants = true,
				Visible = false,
				ZIndex = 30,
				Parent = a8,
			}
		)
		__Ixa_guiCorner(bb, UDim.new(0, 12))
		local bc = __Ixa_guiStroke(bb, __Ixa_guiTheme.Stroke)
		local bd = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(ba, ba),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 31,
				Parent = bb,
			}
		)
		local be = __Ixa_guiNew("UIScale", { Parent = bb })
		self.ToggleButton = bb
		self._toggleStroke = bc
		self._toggleIcon = bd
		self:SetToggleButtonIcon(a7.Icon or "layout-grid")
		local bf, bg = false, false
		local bh = Vector2.zero
		bb.InputBegan:Connect(function(bi)
			if __Ixa_guiIsPointerPress(bi) then
				bf = true
				bg = false
				bh = __Ixa_guiMousePosition() - bb.AbsolutePosition
				__Ixa_guiTween(be, { Scale = 0.94 }, 0.18, Enum.EasingStyle.Quint)
			end
		end)
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputChanged:Connect(function(bi)
				if not bf or not __Ixa_guiIsPointerMove(bi) then
					return
				end
				local bj = __Ixa_guiMousePosition() - bh - a8.AbsolutePosition
				if (bj - (bb.AbsolutePosition - a8.AbsolutePosition)).Magnitude > 3 then
					bg = true
				end
				if bg then
					bb.AnchorPoint = Vector2.zero
					bb.Position = UDim2.fromOffset(
						math.clamp(bj.X, 0, math.max(a8.AbsoluteSize.X - bb.AbsoluteSize.X, 0)),
						math.clamp(bj.Y, 0, math.max(a8.AbsoluteSize.Y - bb.AbsoluteSize.Y, 0))
					)
				end
			end)
		)
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputEnded:Connect(function(bi)
				if not bf or not __Ixa_guiIsPointerPress(bi) then
					return
				end
				bf = false
				__Ixa_guiTween(be, { Scale = 1 }, 0.4, Enum.EasingStyle.Quint)
				if bg then
					return
				end
				__Ixa_guiRipple(bb)
				if not self.Open then
					self:Toggle(true)
				elseif self.Minimized then
					self:Restore()
				else
					self:Minimize()
				end
			end)
		)
	end
	function __Ixa_guiWindow:SetToggleButton(a7)
		self._toggleEnabled = a7 ~= false
		self:_refreshToggleButton()
	end
	function __Ixa_guiWindow:SetToggleButtonPlatform(a7)
		self._togglePlatform = a7 == "Both" and "Both" or "Mobile"
		self:_refreshToggleButton()
	end
	function __Ixa_guiWindow:SetToggleButtonIcon(a7)
		local a8 = self._toggleIcon
		if not a8 then
			return
		end
		a8.Image = ""
		__Ixa_guiApplyIcon(a8, a7)
		if a8.Image == "" then
			__Ixa_guiApplyIcon(a8, __Ixa_guiAssets.Logo)
		end
		if not a8:GetAttribute("CustomIcon") then
			__Ixa_guiTween(a8, { ImageColor3 = (self.Minimized or not self.Open) and __Ixa_guiTheme.Text or __Ixa_guiTheme.Accent }, 0)
		end
	end
	function __Ixa_guiWindow:_enableResize(a7)
		local a8 = self.MaxSize or Vector2.new(math.huge, math.huge)
		self._minSize = a7
		local a9 = self.Root
		local ba = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(1, 4, 1, 4),
				Size = UDim2.fromOffset(32, 32),
				BackgroundTransparency = 1,
				Active = true,
				ZIndex = 20,
				Parent = a9,
			}
		)
		self._grip = ba
		local bb = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.fromOffset(12, 12),
				Size = UDim2.fromOffset(26, 26),
				BackgroundTransparency = 1,
				ZIndex = 20,
				Parent = ba,
			}
		)
		__Ixa_guiCorner(bb, UDim.new(0, 10))
		local bc = __Ixa_guiNew("UIStroke", { Color = __Ixa_guiTheme.Muted, Thickness = 2, Transparency = 0.55, Parent = bb })
		__Ixa_guiNew(
			"UIGradient",
			{
				Rotation = 45,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.55, 1),
					NumberSequenceKeypoint.new(0.85, 0),
					NumberSequenceKeypoint.new(1, 0),
				}),
				Parent = bc,
			}
		)
		local function bd(be)
			__Ixa_guiTween(
				bc,
				{ Color = be and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted, Transparency = be and 0 or 0.55 },
				be and 0.15 or 0.3,
				Enum.EasingStyle.Quint
			)
		end
		local be = 20
		local bf = false
		local bg = Vector2.zero
		local bh = Vector2.zero
		local bi = Vector2.zero
		local bj = Vector2.zero
		local bk = Vector2.zero
		local bl = Vector2.zero
		local function bm()
			return Vector2.new(a9.Size.X.Offset, a9.Size.Y.Offset)
		end
		local function bn()
			if a9.AnchorPoint == Vector2.zero then
				return
			end
			if self._clampTween then
				self._clampTween:Cancel()
				self._clampTween = nil
			end
			local bo = a9.AbsolutePosition - self.Gui.AbsolutePosition
			a9.AnchorPoint = Vector2.zero
			a9.Position = UDim2.fromOffset(bo.X, bo.Y)
		end
		local function bo()
			local bp = a9.AbsolutePosition - self.Gui.AbsolutePosition
			local bq = a9.AbsoluteSize / 2
			a9.AnchorPoint = Vector2.new(0.5, 0.5)
			a9.Position = UDim2.fromOffset(bp.X + bq.X, bp.Y + bq.Y)
		end
		local function bp(bq)
			return Vector2.new(
				math.floor(math.clamp(bq.X, a7.X, a8.X) + 0.5),
				math.floor(math.clamp(bq.Y, a7.Y, a8.Y) + 0.5)
			)
		end
		ba.InputBegan:Connect(function(bq)
			if not __Ixa_guiIsPointerPress(bq) or not self.Open then
				return
			end
			if not self._resizeActive then
				bn()
				bi = bm()
				bj = Vector2.zero
				bl = bi
			end
			self._resizeActive = true
			bf = true
			bg = bi
			bh = __Ixa_guiMousePosition()
			bk = bp(bg)
			bd(true)
		end)
		ba.MouseEnter:Connect(function()
			if not bf then
				bd(true)
			end
		end)
		ba.MouseLeave:Connect(function()
			if not bf then
				bd(false)
			end
		end)
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputEnded:Connect(function(bq)
				if bf and __Ixa_guiIsPointerPress(bq) then
					bf = false
					bd(false)
				end
			end)
		)
		table.insert(self._frameSteps, function(bq)
			if not self._resizeActive then
				return
			end
			if bf then
				local br = (__Ixa_guiMousePosition() - bh) / self.Scale.Scale
				bk = bp(bg + br)
			end
			local br = math.min(bq, 1 / 30)
			local bs = math.exp(-be * br)
			local bt = bi - bk
			local bu = (bj + bt * be) * br
			bj = (bj - bu * be) * bs
			bi = bk + (bt + bu) * bs
			local bv = Vector2.new(math.floor(bi.X + 0.5), math.floor(bi.Y + 0.5))
			if bv ~= bl then
				bl = bv
				a9.Size = UDim2.fromOffset(bv.X, bv.Y)
			end
			if not bf and (bi - bk).Magnitude < 0.3 and bj.Magnitude < 3 then
				bi = bk
				bj = Vector2.zero
				bl = bk
				a9.Size = UDim2.fromOffset(bk.X, bk.Y)
				bo()
				self._resizeActive = false
				self:_fitToScreen()
				self:_clampToScreen()
			end
		end)
	end
	function __Ixa_guiWindow:GetSize()
		return Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
	end
	function __Ixa_guiWindow:SetSize(a7, a8)
		if typeof(a7) == "UDim2" then
			a7 = Vector2.new(a7.X.Offset, a7.Y.Offset)
		end
		if typeof(a7) ~= "Vector2" or self._resizeActive then
			return
		end
		local a9 = self._minSize or Vector2.zero
		local ba = self.MaxSize or Vector2.new(math.huge, math.huge)
		a7 = Vector2.new(math.floor(math.clamp(a7.X, a9.X, ba.X) + 0.5), math.floor(math.clamp(a7.Y, a9.Y, ba.Y) + 0.5))
		if a7 == self:GetSize() then
			return
		end
		local bb = (a8 or not self.Root.Visible) and 0 or 0.3
		__Ixa_guiTween(self.Root, { Size = UDim2.fromOffset(a7.X, a7.Y) }, bb, Enum.EasingStyle.Quint)
		task.delay(bb + 0.02, function()
			if not self._destroyed then
				self:_fitToScreen()
				self:_clampToScreen()
			end
		end)
	end
	local a7 = 1
	local a8 = "airflow:"
	local function a9(ba, bb)
		return ba.ConfigFolder .. "/" .. bb .. ".json"
	end
	local function ba()
		return type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
	end
	local function bb(bc)
		if type(isfolder) ~= "function" or type(makefolder) ~= "function" then
			return
		end
		local bd = ""
		for be in tostring(bc):gmatch("[^/\\]+") do
			bd = bd == "" and be or bd .. "/" .. be
			if not isfolder(bd) then
				makefolder(bd)
			end
		end
	end
	local function bc(bd)
		return string.format(
			"%02x%02x%02x",
			math.floor(bd.R * 255 + 0.5),
			math.floor(bd.G * 255 + 0.5),
			math.floor(bd.B * 255 + 0.5)
		)
	end
	local function bd(be)
		if type(be) == "table" then
			if type(be.Hex) == "string" then
				be = be.Hex
			elseif type(be[1]) == "number" then
				return Color3.new(be[1], be[2] or 0, be[3] or 0)
			end
		end
		if type(be) == "string" then
			local bf, bg, bh = be:match("^%s*#?(%x%x)(%x%x)(%x%x)%s*$")
			if bf then
				return Color3.fromRGB(tonumber(bf, 16), tonumber(bg, 16), tonumber(bh, 16))
			end
		end
		return nil
	end
	local function be(bf)
		local bg = bf._type
		local bh = bf:Get()
		if type(bf._saveValue) == "function" then
			bh = bf:_saveValue()
		end
		if bg == "Keybind" then
			return { Type = bg, Value = bh and bh.Name or nil }
		elseif bg == "ColorPicker" then
			return { Type = bg, Value = typeof(bh) == "Color3" and { Hex = bc(bh) } or nil }
		end
		return { Type = bg, Value = bh }
	end
	local function bf(bg, bh, bi)
		local bj = bg._type
		local bk = bh.Value
		if bj == "Keybind" then
			bg:Set(type(bk) == "string" and Enum.KeyCode[bk] or nil, bi)
		elseif bj == "ColorPicker" then
			local bl = bd(bk)
			if bl then
				bg:Set(bl, bi)
			end
		elseif bj == "Dropdown" then
			bg:Set(bk, bi)
		elseif bj == "Toggle" then
			if type(bk) == "boolean" then
				bg:Set(bk, bi)
			end
		elseif bj == "Slider" or bj == "Stepper" or bj == "Progress" then
			local bl = tonumber(bk)
			if bl then
				bg:Set(bl, bi)
			end
		elseif bk ~= nil then
			bg:Set(bk, bi)
		end
	end
	local function bg(bh, bi)
		return type(bi) == "table" and (bi.Type == nil or bi.Type == bh._type)
	end
	local function bh(bi)
		local bj = {}
		if bi and bi._pendingFlags then
			for bk, bl in pairs(bi._pendingFlags) do
				bj[bk] = bl.Entry
			end
		end
		local bk = bi and bi._ignoreFlags or {}
		for bl in pairs(bk) do
			bj[bl] = nil
		end
		for bl, bm in pairs(__Ixa_guiLibrary.Flags) do
			if not bk[bl] and bm._type and type(bm.Get) == "function" then
				local bn, bo = pcall(be, bm)
				if bn then
					bj[bl] = bo
				end
			end
		end
		return bj
	end
	__Ixa_guiLibrary.LoadingOrder = { "Dropdown", "Slider", "Stepper", "Input", "ColorPicker", "Keybind", "Toggle" }
	function __Ixa_guiWindow:SetIgnoreFlags(bi)
		self._ignoreFlags = self._ignoreFlags or {}
		for bj, bk in ipairs(bi or {}) do
			self._ignoreFlags[bk] = true
		end
	end
	function __Ixa_guiWindow:SetLoadingOrder(bi)
		self._loadingOrder = type(bi) == "table" and bi or nil
	end
	function __Ixa_guiWindow:_applyFlags(bi, bj)
		bj = bj == true
		self._pendingFlags = {}
		local bk = self._ignoreFlags or {}
		local bl = self._loadingOrder or __Ixa_guiLibrary.LoadingOrder
		local bm = {}
		for bn, bo in pairs(bi) do
			if not bk[bn] and not (self._startupExcluded and self._startupExcluded[bn]) then
				local bp = __Ixa_guiLibrary.Flags[bn]
				if bp and type(bp.Set) == "function" then
					if bg(bp, bo) then
						table.insert(bm, { Element = bp, Entry = bo, Rank = table.find(bl, bp._type) or 0 })
					end
				elseif type(bo) == "table" then
					self._pendingFlags[bn] = { Entry = bo, Silent = bj }
				end
			end
		end
		table.sort(bm, function(bn, bo)
			return bn.Rank < bo.Rank
		end)
		for bn, bo in ipairs(bm) do
			task.defer(function()
				if not bo.Element._destroyed and not self._destroyed then
					pcall(bf, bo.Element, bo.Entry, bj)
				end
			end)
		end
	end
	function __Ixa_guiWindow:_flagCreated(bi, bj)
		local bk, bl = pcall(be, bj)
		if bk then
			bj._defaultEntry = bl
		end
		local bm = self._pendingFlags and self._pendingFlags[bi]
		if not bm then
			return
		end
		task.defer(function()
			if self._pendingFlags[bi] ~= bm or __Ixa_guiLibrary.Flags[bi] ~= bj or bj._destroyed then
				return
			end
			self._pendingFlags[bi] = nil
			if bg(bj, bm.Entry) then
				pcall(bf, bj, bm.Entry, bm.Silent)
			end
		end)
	end
	function __Ixa_guiWindow:_configChanged()
		for bi, bj in ipairs(self._configListeners) do
			__Ixa_guiCall(bj)
		end
	end
	function __Ixa_guiWindow:OnConfigChanged(bi)
		table.insert(self._configListeners, bi)
		return function()
			local bj = table.find(self._configListeners, bi)
			if bj then
				table.remove(self._configListeners, bj)
			end
		end
	end
	local function bi(bj)
		return type(bj) == "string" and bj ~= "" and not bj:find('[\\/:%*%?"<>|]')
	end
	local function bj(bk, bl, bm)
		return __Ixa_guiHttpService:JSONEncode({ Folder = bk.ConfigFolder, Name = bl, Version = a7, Config = __Ixa_guiHttpService:JSONEncode(bm) })
	end
	local bk = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/]]
	local bl = {}
	for bm = 1, #bk do
		bl[bk:byte(bm)] = bm - 1
	end
	local function bm(bn)
		if #bn % 4 ~= 0 then
			return nil
		end
		local bo = {}
		for bp = 1, #bn, 4 do
			local bq, br = 0, 0
			for bs = 0, 3 do
				local bt = bn:byte(bp + bs)
				local bu = bl[bt]
				if bt == 61 and bp + 3 >= #bn then
					br += 1
					bu = 0
				elseif bu == nil or br > 0 then
					return nil
				end
				bq = bq * 64 + bu
			end
			if br > 2 then
				return nil
			end
			local bs = string.char(bit32.extract(bq, 16, 8), bit32.extract(bq, 8, 8), bit32.extract(bq, 0, 8))
			table.insert(bo, bs:sub(1, 3 - br))
		end
		return table.concat(bo)
	end
	local function bn(bo)
		bo = tostring(bo or ""):match("^%s*(.-)%s*$")
		if bo:sub(1, #a8) == a8 then
			bo = bm((bo:sub(#a8 + 1):gsub("%s", "")))
			if not bo then
				return nil, "invalid config code"
			end
		end
		local bp, bq = pcall(function()
			return __Ixa_guiHttpService:JSONDecode(bo)
		end)
		if not bp or type(bq) ~= "table" then
			return nil, "invalid config code"
		end
		local br = {}
		if type(bq.Config) == "string" or (type(bq.Config) == "table" and bq.Config.Type == nil) then
			br.Folder = type(bq.Folder) == "string" and bq.Folder or nil
			br.Name = type(bq.Name) == "string" and bq.Name or nil
			br.Version = tonumber(bq.Version)
			local bs = bq.Config
			if type(bs) == "string" then
				bp, bs = pcall(function()
					return __Ixa_guiHttpService:JSONDecode(bq.Config)
				end)
				if not bp then
					return nil, "invalid config code"
				end
			end
			if type(bs) ~= "table" then
				return nil, "invalid config code"
			end
			bq = bs
		end
		for bs, bt in pairs(bq) do
			if type(bs) ~= "string" or type(bt) ~= "table" then
				return nil, "invalid config code"
			end
		end
		return bq, br
	end
	local function bo(bp, bq, br)
		if not bi(bq) then
			return false, "invalid config name"
		end
		if not ba() then
			return false, "file API unavailable"
		end
		local bs, bt = pcall(bj, bp, bq, br)
		if not bs then
			return false, "could not encode config"
		end
		bb(bp.ConfigFolder)
		return pcall(writefile, a9(bp, bq), bt)
	end
	local function bp(bq, br)
		if not ba() then
			return nil, "file API unavailable"
		end
		if not bi(br) then
			return nil, "invalid config name"
		end
		local bs = a9(bq, br)
		if not isfile(bs) then
			return nil, "no config named " .. tostring(br)
		end
		local bt, bu = pcall(readfile, bs)
		if not bt or type(bu) ~= "string" then
			return nil, "could not read " .. br
		end
		local bv, bw = bn(bu)
		if not bv then
			return nil, "config is not valid JSON"
		end
		return bv, bw
	end
	function __Ixa_guiWindow:ConfigExists(bq)
		return bi(bq) and ba() and isfile(a9(self, bq)) or false
	end
	function __Ixa_guiWindow:SaveConfig(bq)
		bq = bq or self.ConfigName
		if not bq then
			return false, "no config name"
		end
		local br, bs = bo(self, bq, bh(self))
		if br then
			self.ConfigName = bq
		end
		return br, bs
	end
	function __Ixa_guiWindow:LoadConfig(bq, br)
		bq = bq or self.ConfigName
		if not bq then
			return false, "no config name"
		end
		local bs, bt = bp(self, bq)
		if not bs then
			return false, bt
		end
		self:_applyFlags(bs, br)
		self.ConfigName = bq
		self.LoadedConfig = bq
		self:_configChanged()
		return true
	end
	function __Ixa_guiWindow:DeleteConfig(bq)
		if not ba() or type(delfile) ~= "function" then
			return false, "file API unavailable"
		end
		if not bi(bq) then
			return false, "invalid config name"
		end
		local br = a9(self, bq)
		if not isfile(br) then
			return false, "no config named " .. bq
		end
		local bs, bt = pcall(delfile, br)
		if not bs then
			return false, bt
		end
		if self.LoadedConfig == bq then
			self.LoadedConfig = nil
		end
		self:_configChanged()
		return true
	end
	function __Ixa_guiWindow:RenameConfig(bq, br)
		if not bi(br) then
			return false, "invalid config name"
		end
		if bq == br then
			return true
		end
		if self:ConfigExists(br) then
			return false, br .. " already exists"
		end
		local bs, bt = bp(self, bq)
		if not bs then
			return false, bt
		end
		local bu
		bu, bt = bo(self, br, bs)
		if not bu then
			return false, bt
		end
		if type(delfile) == "function" then
			pcall(delfile, a9(self, bq))
		end
		if self.LoadedConfig == bq then
			self.LoadedConfig = br
		end
		if self.ConfigName == bq then
			self.ConfigName = br
		end
		for bv, bw in ipairs({ "Global", "Account" }) do
			if self:GetAutoload(bw) == bq then
				self:SetAutoload(br, bw)
			end
		end
		self:_configChanged()
		return true
	end
	function __Ixa_guiWindow:ListConfigs()
		local bq = {}
		if type(listfiles) ~= "function" or type(isfolder) ~= "function" or not isfolder(self.ConfigFolder) then
			return bq
		end
		local br, bs = pcall(listfiles, self.ConfigFolder)
		if not br or type(bs) ~= "table" then
			return bq
		end
		for bt, bu in ipairs(bs) do
			local bv = bu:match("([^/\\]+)%.json$")
			if bv then
				table.insert(bq, bv)
			end
		end
		table.sort(bq, function(bt, bu)
			return bt:lower() < bu:lower()
		end)
		return bq
	end
	function __Ixa_guiWindow:ResetConfig(bq)
		self._pendingFlags = {}
		for br, bs in pairs(__Ixa_guiLibrary.Flags) do
			if bs._defaultEntry and type(bs.Set) == "function" then
				pcall(bf, bs, bs._defaultEntry, bq == true)
			end
		end
		self:_configChanged()
		return true
	end
	local function bq(br)
		if type(isfolder) ~= "function" or not isfolder(br) then
			return true
		end
		if type(delfolder) == "function" and pcall(delfolder, br) and not isfolder(br) then
			return true
		end
		if type(listfiles) == "function" then
			local bs, bt = pcall(listfiles, br)
			for bu, bv in ipairs(bs and bt or {}) do
				if isfolder(bv) then
					bq(bv)
				elseif type(delfile) == "function" then
					pcall(delfile, bv)
				end
			end
		end
		if type(delfolder) == "function" then
			pcall(delfolder, br)
		end
		return not isfolder(br)
	end
	function __Ixa_guiWindow:ClearWorkspace()
		local br = bq(self.ConfigFolder)
		self.LoadedConfig = nil
		for bs, bt in ipairs(self._workspaceListeners or {}) do
			__Ixa_guiCall(bt)
		end
		self:_configChanged()
		return br
	end
	function __Ixa_guiWindow:ExportConfig(br)
		local bs, bt
		if br then
			bs, bt = bp(self, br)
			if not bs then
				return nil, bt
			end
		else
			bs = bh(self)
			br = self.LoadedConfig or self.ConfigName
		end
		local bu, bv = pcall(bj, self, br, bs)
		if not bu then
			return nil, "could not encode config"
		end
		return bv
	end
	function __Ixa_guiWindow:DecodeConfig(br)
		return bn(br)
	end
	function __Ixa_guiWindow:ImportConfig(br, bs, bt)
		local bu, bv = bn(br)
		if not bu then
			return false, bv
		end
		if not bt and bv.Folder and bv.Folder ~= self.ConfigFolder then
			return false, "config is for " .. bv.Folder
		end
		if bs == true then
			bs = bv.Name
			if not bi(bs) then
				return false, "config has no usable name"
			end
		end
		if bs then
			local bw, bx = bo(self, bs, bu)
			if not bw then
				return false, bx
			end
		end
		self:_applyFlags(bu)
		if bs then
			self.ConfigName = bs
			self.LoadedConfig = bs
		end
		self:_configChanged()
		return true, nil, bs
	end
	local function br(bs)
		if not ba() or not isfile(bs) then
			return nil
		end
		local bt, bu = pcall(readfile, bs)
		if bt and type(bu) == "string" and bu ~= "" then
			return bu
		end
		return nil
	end
	local function bs(bt)
		if ba() and type(delfile) == "function" and isfile(bt) then
			pcall(delfile, bt)
		end
	end
	local function bt(bu)
		return bu.ConfigFolder .. "/configsettings.txt"
	end
	function __Ixa_guiWindow:_readConfigSettings()
		local bu = br(bt(self))
		if bu then
			local bv, bw = pcall(function()
				return __Ixa_guiHttpService:JSONDecode(bu)
			end)
			if bv and type(bw) == "table" then
				return bw
			end
		end
		return {}
	end
	function __Ixa_guiWindow:_writeConfigSettings(bu)
		if not ba() then
			return false, "file API unavailable"
		end
		local bv = self:_readConfigSettings()
		for bw, bx in pairs(bu) do
			bv[bw] = bx
		end
		bb(self.ConfigFolder)
		return pcall(writefile, bt(self), __Ixa_guiHttpService:JSONEncode(bv))
	end
	local function bu(bv, bw)
		if bw == "Account" then
			return bv.ConfigFolder .. "/autoload_" .. tostring(__Ixa_guiPlayer and __Ixa_guiPlayer.UserId or 0) .. ".txt"
		end
		return bv.ConfigFolder .. "/autoload.txt"
	end
	function __Ixa_guiWindow:GetAutoloadMode()
		return self:_readConfigSettings().AutoloadMode == "Account" and "Account" or "Global"
	end
	function __Ixa_guiWindow:GetAutoload(bv)
		if bv then
			return br(bu(self, bv))
		end
		return br(bu(self, "Account")) or br(bu(self, "Global"))
	end
	function __Ixa_guiWindow:SetAutoload(bv, bw)
		if not ba() then
			return false, "file API unavailable"
		end
		bw = bw or self:GetAutoloadMode()
		local bx, by = true, nil
		if bv == nil or bv == "" then
			bs(bu(self, bw))
			if bw == "Global" then
				bs(bu(self, "Account"))
			end
		else
			bb(self.ConfigFolder)
			bx, by = pcall(writefile, bu(self, bw), tostring(bv))
			if bx and bw == "Global" then
				bs(bu(self, "Account"))
			end
		end
		self:_configChanged()
		return bx, by
	end
	function __Ixa_guiWindow:SetAutoloadMode(bv)
		bv = bv == "Account" and "Account" or "Global"
		if bv == self:GetAutoloadMode() then
			return true
		end
		local bw = self:GetAutoload()
		local bx, by = self:_writeConfigSettings({ AutoloadMode = bv })
		if not bx then
			return false, by
		end
		bs(bu(self, bv == "Account" and "Global" or "Account"))
		if bw then
			return self:SetAutoload(bw, bv)
		end
		self:_configChanged()
		return true
	end
	function __Ixa_guiWindow:GetMinimizeOnStart()
		return self:_readConfigSettings().MinimizeOnStart == true
	end
	function __Ixa_guiWindow:SetMinimizeOnStart(bv)
		return self:_writeConfigSettings({ MinimizeOnStart = bv == true })
	end
	function __Ixa_guiWindow:LoadAutoload(bv)
		if self._autoloaded then
			return false, "autoload already ran"
		end
		self._autoloaded = true
		local bw = self:GetAutoload()
		if not bw then
			return false, "no autoload config"
		end
		local bx, by = self:LoadConfig(bw, bv)
		pcall(
			self.Notify,
			self,
			{
				Title = bx and "Autoload" or "Autoload failed",
				Content = bx and ("Loaded config %q"):format(bw) or tostring(by),
				Type = bx and "Success" or "Error",
				Duration = 3,
			}
		)
		return bx, by
	end
	__Ixa_guiLibrary._themeListeners = {}
	local function bv(bw)
		if typeof(bw) == "Color3" then
			return bw
		elseif type(bw) == "string" then
			local bx, by, bz = bw:match("^%s*#?(%x%x)(%x%x)(%x%x)%s*$")
			if bx then
				return Color3.fromRGB(tonumber(bx, 16), tonumber(by, 16), tonumber(bz, 16))
			end
		elseif type(bw) == "table" then
			local bx, by, bz = bw[1] or bw.R, bw[2] or bw.G, bw[3] or bw.B
			if tonumber(bx) and tonumber(by) and tonumber(bz) then
				return Color3.fromRGB(bx, by, bz)
			end
		end
		return nil
	end
	local function bw(bx)
		return string.format(
			"#%02X%02X%02X",
			math.floor(bx.R * 255 + 0.5),
			math.floor(bx.G * 255 + 0.5),
			math.floor(bx.B * 255 + 0.5)
		)
	end
	__Ixa_guiLibrary._toneTags = {}
	for bx, by in ipairs(__Ixa_guiThemeKeys) do
		__Ixa_guiLibrary._toneTags[string.lower(by)] = by
	end
	function __Ixa_guiLibrary._dependsMet(bx)
		if type(bx) == "function" then
			local by, bz = pcall(bx)
			return by and bz and true or false
		end
		if type(bx) == "string" then
			bx = { Flag = bx }
		end
		if type(bx) ~= "table" then
			return true
		end
		if bx.Flag == nil then
			for by, bz in ipairs(bx) do
				if not __Ixa_guiLibrary._dependsMet(bz) then
					return false
				end
			end
			return true
		end
		local by = __Ixa_guiLibrary.Flags[bx.Flag]
		local bz = false
		if by and type(by.Get) == "function" then
			local bA, bB = pcall(by.Get, by)
			if bA then
				if bx.Value ~= nil then
					local bC = type(bx.Value) == "table" and bx.Value or { bx.Value }
					local bD = type(bB) == "table" and bB or { bB }
					for bE, bF in ipairs(bC) do
						if table.find(bD, bF) then
							bz = true
							break
						end
					end
				else
					bz = bB == true
						or (type(bB) == "number" and bB ~= 0)
						or (type(bB) == "string" and bB ~= "")
						or (type(bB) == "table" and next(bB) ~= nil)
						or typeof(bB) == "EnumItem"
						or typeof(bB) == "Color3"
				end
			end
		end
		if bx.Not then
			bz = not bz
		end
		return bz
	end
	function __Ixa_guiLibrary._applyDepends(bx, by)
		local bz = bx._dependsOn == nil or __Ixa_guiLibrary._dependsMet(bx._dependsOn)
		if bz == bx._dependsMet and not by then
			return
		end
		bx._dependsMet = bz
		local bA = string.lower(tostring(bx._dependsMode or "Hide"))
		if bA == "disable" then
			if bx._dependHidden then
				__Ixa_guiLibrary._setDependHidden(bx, false)
			end
			bx._dependDisabled = not bz
			__Ixa_guiLibrary._setDisabled(bx, bx._frame, bx.Disabled)
		else
			if bx._dependDisabled then
				bx._dependDisabled = false
				__Ixa_guiLibrary._setDisabled(bx, bx._frame, bx.Disabled)
			end
			__Ixa_guiLibrary._setDependHidden(bx, not bz)
		end
	end
	function __Ixa_guiLibrary._setDependHidden(bx, by)
		by = by == true
		if by == (bx._dependHidden == true) then
			return
		end
		bx._dependHidden = by
		if by then
			if bx._onHide then
				bx._onHide()
			end
			if bx.Open and type(bx.SetOpen) == "function" then
				bx:SetOpen(false)
			end
		end
		local bz = bx._frame
		if bz then
			bz.Visible = bx._userVisible ~= false and not by
		end
		if bx._window then
			bx._window._controlsDirty = true
		end
	end
	function __Ixa_guiLibrary._watchDepends(bx, by)
		if not bx._dependents then
			bx._dependents = {}
			local bz = 0
			bx:_listen("Render", function()
				local bA = os.clock()
				if bA - bz < 0.1 then
					return
				end
				bz = bA
				local bB = bx._dependents
				for bC = #bB, 1, -1 do
					local bD = bB[bC]
					if bD._destroyed then
						table.remove(bB, bC)
					elseif bD._dependsOn ~= nil then
						__Ixa_guiLibrary._applyDepends(bD)
					end
				end
			end)
		end
		if not table.find(bx._dependents, by) then
			table.insert(bx._dependents, by)
		end
		__Ixa_guiLibrary._applyDepends(by, true)
	end
	function __Ixa_guiLibrary._setDisabled(bx, by, bz)
		bx.Disabled = bz == true
		if not by then
			return
		end
		local bA = bx.Disabled or bx._dependDisabled == true
		if bA == (bx._covered == true) then
			return
		end
		bx._covered = bA
		if bA then
			if bx._onHide then
				bx._onHide()
			end
			if bx.Open and type(bx.SetOpen) == "function" then
				bx:SetOpen(false)
			end
		end
		local bB = bx._cover
		if not bB then
			bB = __Ixa_guiNew(
				"TextButton",
				{
					Name = "DisabledCover",
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = __Ixa_guiTheme.Surface2,
					BackgroundTransparency = 1,
					AutoButtonColor = false,
					Text = "",
					ZIndex = 20,
					Visible = false,
					Parent = by,
				}
			)
			bB:SetAttribute("NoDrag", true)
			__Ixa_guiCorner(bB)
			bx._cover = bB
		end
		bx._coverGeneration = (bx._coverGeneration or 0) + 1
		local bC = bx._coverGeneration
		if bA then
			bB.Visible = true
			__Ixa_guiTween(bB, { BackgroundTransparency = 0.4 }, 0.15)
		else
			__Ixa_guiTween(bB, { BackgroundTransparency = 1 }, 0.15)
			task.delay(0.16, function()
				if bx._coverGeneration == bC then
					bB.Visible = false
				end
			end)
		end
	end
	function __Ixa_guiLibrary._gateButton(bx, by)
		local bz = by.Callback
		local bA = by.HoldToConfirm == true and 1 or tonumber(by.HoldToConfirm)
		local bB = table.clone(by)
		bB._gated = true
		local bC
		local bD = tostring(by.Name or "Button")
		local bE, bF = false, 0
		local function bG(bH)
			bE = bH
			bF += 1
			if not bC then
				return
			end
			bC._title.Text = bH and tostring(type(by.Confirm) == "string" and by.Confirm or "Click again to confirm")
				or bD
			__Ixa_guiTween(bC._title, { TextColor3 = bH and __Ixa_guiTheme.Warning or bC._titleColor }, 0.15)
		end
		bB.Callback = function()
			if bA then
				return
			end
			if bE then
				bG(false)
				__Ixa_guiCall(bz)
				return
			end
			bG(true)
			local bH = bF
			task.delay(tonumber(by.ConfirmTimeout) or 3, function()
				if bE and bF == bH then
					bG(false)
				end
			end)
		end
		bC = bx:Button(bB)
		local bH = bC.SetText
		bC.SetText = function(bI, bJ)
			bD = tostring(bJ)
			if not bE then
				bH(bI, bJ)
			end
		end
		function bC:Disarm()
			if bE then
				bG(false)
			end
		end
		if bA then
			local bI = bC._fillHost
			local bJ = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.fromScale(0, 1),
					BackgroundColor3 = __Ixa_guiTheme.Accent,
					BackgroundTransparency = 0.7,
					BorderSizePixel = 0,
					ZIndex = 0,
					Parent = bI,
				}
			)
			local bK = 0
			local function bL()
				bK += 1
				__Ixa_guiTween(bJ, { Size = UDim2.fromScale(0, 1) }, 0.2, Enum.EasingStyle.Quint)
			end
			local bM = bC._frame
			bM.InputBegan:Connect(function(bN)
				if
					bN.UserInputType ~= Enum.UserInputType.MouseButton1
					and bN.UserInputType ~= Enum.UserInputType.Touch
				then
					return
				end
				if bC.Disabled or bC._dependDisabled then
					return
				end
				bK += 1
				local bO = bK
				bJ.Size = UDim2.fromScale(0, 1)
				__Ixa_guiTween(bJ, { Size = UDim2.fromScale(1, 1) }, bA, Enum.EasingStyle.Linear)
				task.delay(bA, function()
					if bK == bO and not bC._destroyed then
						bK += 1
						__Ixa_guiTween(bJ, { BackgroundTransparency = 0.45 }, 0.08)
						task.delay(0.12, function()
							bJ.BackgroundTransparency = 0.7
							__Ixa_guiTween(bJ, { Size = UDim2.fromScale(0, 1) }, 0.25, Enum.EasingStyle.Quint)
						end)
						__Ixa_guiCall(bz)
					end
				end)
			end)
			bM.InputEnded:Connect(function(bN)
				if
					bN.UserInputType == Enum.UserInputType.MouseButton1
					or bN.UserInputType == Enum.UserInputType.Touch
				then
					bL()
				end
			end)
			bM.MouseLeave:Connect(bL)
		end
		return bC
	end
	function __Ixa_guiLibrary._color(bx)
		if type(bx) == "string" then
			local by = __Ixa_guiLibrary._toneTags[string.lower(bx)]
			if by then
				return __Ixa_guiTheme[by]
			end
		end
		return bv(bx)
	end
	function __Ixa_guiLibrary._rich(bx)
		bx = tostring(bx == nil and "" or bx)
		if not string.find(bx, "<", 1, true) then
			return bx
		end
		return (
			string.gsub(bx, "<(/?)(%a+%d*)>", function(by, bz)
				local bA = __Ixa_guiLibrary._toneTags[string.lower(bz)]
				if not bA then
					return nil
				end
				if by == "/" then
					return "</font>"
				end
				return '<font color="' .. bw(__Ixa_guiTheme[bA]) .. '">'
			end)
		)
	end
	function __Ixa_guiLibrary.Colorize(...)
		local bx = { ... }
		if bx[1] == __Ixa_guiLibrary then
			table.remove(bx, 1)
		end
		local by, bz = tostring(bx[1] == nil and "" or bx[1]), bx[2]
		local bA = type(bz) == "string" and __Ixa_guiLibrary._toneTags[string.lower(bz)]
		if bA then
			return "<" .. bA .. ">" .. by .. "</" .. bA .. ">"
		end
		local bB = bv(bz)
		if not bB then
			return by
		end
		return '<font color="' .. bw(bB) .. '">' .. by .. "</font>"
	end
	function __Ixa_guiLibrary:SetCornerRadius(bx, by)
		bx = math.clamp(math.floor((tonumber(bx) or 10) + 0.5), 0, 20)
		__Ixa_guiLibrary.Roundness = bx / 10
		for bz, bA in pairs(__Ixa_guiLibrary._cornerBases) do
			if not bz.Parent then
				__Ixa_guiLibrary._cornerBases[bz] = nil
			else
				local bB = UDim.new(0, math.floor(bA * __Ixa_guiLibrary.Roundness + 0.5))
				if by then
					bz.CornerRadius = bB
				else
					__Ixa_guiTween(bz, { CornerRadius = bB }, 0.25, Enum.EasingStyle.Quint)
				end
			end
		end
		return bx
	end
	function __Ixa_guiLibrary:GetCornerRadius()
		return math.floor(__Ixa_guiLibrary.Roundness * 10 + 0.5)
	end
	function __Ixa_guiLibrary:SetTheme(bx, by)
		if __Ixa_guiLibrary._disposed then
			return false
		end
		if type(bx) == "string" then
			local bz = __Ixa_guiLibrary.ThemePresets[bx]
			if not bz then
				return false
			end
			__Ixa_guiLibrary.ThemeName = bx
			bx = bz
		elseif type(bx) ~= "table" then
			return false
		end
		local bz = false
		for bA, bB in ipairs(__Ixa_guiThemeKeys) do
			local bC = bv(bx[bB])
			if bC and bC ~= __Ixa_guiTheme[bB] then
				__Ixa_guiTheme[bB] = bC
				bz = true
			end
		end
		if not bz then
			return true
		end
		__Ixa_guiReindexColors()
		__Ixa_guiPruneTheme()
		__Ixa_guiAnimateTheme(by and 0 or 0.3)
		for bA, bB in pairs(__Ixa_guiThemeCallbacks) do
			if bA.Parent then
				pcall(bB)
			end
		end
		for bA, bB in ipairs(__Ixa_guiLibrary._themeListeners) do
			pcall(bB)
		end
		return true
	end
	function __Ixa_guiLibrary:GetTheme()
		local bx = {}
		for by, bz in ipairs(__Ixa_guiThemeKeys) do
			bx[bz] = __Ixa_guiTheme[bz]
		end
		return bx
	end
	function __Ixa_guiLibrary:SetDefaultTheme(bx)
		__Ixa_guiLibrary.DefaultTheme = bx
		if bx == nil then
			return true
		end
		local by = false
		for bz, bA in ipairs(__Ixa_guiLibrary.Windows) do
			if not bA._destroyed then
				if bA:GetDefaultTheme() then
					return true
				end
				by = true
			end
		end
		return __Ixa_guiLibrary:SetTheme(bx, not by)
	end
	function __Ixa_guiLibrary:GetDefaultTheme()
		return __Ixa_guiLibrary.DefaultTheme
	end
	local function bx(by)
		return by.ConfigFolder .. "/themes"
	end
	function __Ixa_guiWindow:SaveTheme(by)
		if not ba() then
			return false, "file API unavailable"
		end
		if type(by) ~= "string" or by == "" then
			return false, "theme needs a name"
		end
		bb(self.ConfigFolder)
		bb(bx(self))
		local bz = {}
		for bA, bB in ipairs(__Ixa_guiThemeKeys) do
			bz[bB] = bw(__Ixa_guiTheme[bB])
		end
		return pcall(function()
			writefile(bx(self) .. "/" .. by .. ".json", __Ixa_guiHttpService:JSONEncode(bz))
		end)
	end
	function __Ixa_guiWindow:LoadTheme(by, bz)
		if __Ixa_guiLibrary.ThemePresets[by] then
			return __Ixa_guiLibrary:SetTheme(by, bz)
		end
		local bA = br(bx(self) .. "/" .. tostring(by) .. ".json")
		if not bA then
			return false, "no theme named " .. tostring(by)
		end
		local bB, bC = pcall(function()
			return __Ixa_guiHttpService:JSONDecode(bA)
		end)
		if not bB or type(bC) ~= "table" then
			return false, "theme is not valid JSON"
		end
		__Ixa_guiLibrary.ThemeName = by
		return __Ixa_guiLibrary:SetTheme(bC, bz)
	end
	function __Ixa_guiWindow:DeleteTheme(by)
		if not ba() or type(delfile) ~= "function" then
			return false, "file API unavailable"
		end
		local bz = bx(self) .. "/" .. tostring(by) .. ".json"
		if not isfile(bz) then
			return false, "no theme named " .. tostring(by)
		end
		delfile(bz)
		if self:GetDefaultTheme() == by then
			self:SetDefaultTheme(nil)
		end
		return true
	end
	function __Ixa_guiWindow:ListThemes()
		local by = {}
		if type(listfiles) ~= "function" or type(isfolder) ~= "function" or not isfolder(bx(self)) then
			return by
		end
		for bz, bA in ipairs(listfiles(bx(self))) do
			local bB = bA:match("([^/\\]+)%.json$")
			if bB then
				table.insert(by, bB)
			end
		end
		table.sort(by)
		return by
	end
	function __Ixa_guiWindow:GetDefaultTheme()
		return br(bx(self) .. "/default.txt")
	end
	function __Ixa_guiWindow:SetDefaultTheme(by)
		if not ba() then
			return false, "file API unavailable"
		end
		bb(self.ConfigFolder)
		bb(bx(self))
		local bz = bx(self) .. "/default.txt"
		if by == nil or by == "" then
			if isfile(bz) and type(delfile) == "function" then
				pcall(delfile, bz)
			end
			return true
		end
		return pcall(writefile, bz, tostring(by))
	end
	function __Ixa_guiWindow:_applyDefaultTheme()
		local by = self:GetDefaultTheme()
		if by then
			local bz, bA = pcall(self.LoadTheme, self, by, true)
			if bz and bA then
				return
			end
		end
		if __Ixa_guiLibrary.DefaultTheme ~= nil then
			pcall(__Ixa_guiLibrary.SetTheme, __Ixa_guiLibrary, __Ixa_guiLibrary.DefaultTheme, true)
		end
	end
	__Ixa_guiLibrary.BackgroundPresets = {
		["Deep Violet"] = "rbxassetid://136310484943077",
		["Blood Red"] = "rbxassetid://121343473918667",
		["Cyanic"] = "rbxassetid://95656189244173",
		["Amber Glow"] = "rbxassetid://107795771598485",
		["Bloomings"] = "rbxassetid://133541508207801",
		["Lavender Pink"] = "rbxassetid://126107479485287",
	}
	__Ixa_guiLibrary.BackgroundPresetOrder = { "Deep Violet", "Blood Red", "Cyanic", "Amber Glow", "Bloomings", "Lavender Pink" }
	__Ixa_guiLibrary._imageExtensions = { png = true, jpg = true, jpeg = true, webp = true, gif = true, bmp = true }
	function __Ixa_guiWindow:_backgroundFolder()
		return self.ConfigFolder .. "/backgrounds"
	end
	function __Ixa_guiWindow:_trimBackground(by)
		return (tostring(by or ""):match("^%s*(.-)%s*$"))
	end
	function __Ixa_guiWindow:_resolveBackground(by)
		by = self:_trimBackground(by)
		local bz = __Ixa_guiLibrary.BackgroundPresets[by]
		if bz then
			return bz
		end
		if by:match("^%d+$") then
			return "rbxassetid://" .. by
		end
		if
			by:match("^rbxassetid://%d+")
			or by:match("^rbxasset://")
			or by:match("^rbxthumb://")
			or by:match("^https?://www%.roblox%.com/asset")
		then
			return by
		end
		local bA = ba() and typeof(getcustomasset) == "function"
		if by:match("^https?://") then
			if not bA then
				return nil, "web images need writefile and getcustomasset"
			end
			local bB = by:match("^[^?#]+") or by
			local bC = (bB:match("%.(%w+)$") or "png"):lower()
			if not __Ixa_guiLibrary._imageExtensions[bC] then
				bC = "png"
			end
			local bD = (bB:gsub("^https?://", ""):gsub("[^%w]", "_")):sub(-60)
			local bE = self:_backgroundFolder() .. "/cache"
			local bF = bE .. "/" .. bD .. "_" .. #by .. "." .. bC
			if not isfile(bF) then
				local bG, bH = pcall(function()
					local bG = (syn and syn.request) or http_request or request
					if bG then
						local bH = bG({ Url = by, Method = "GET" })
						return bH and bH.Body
					end
					return game:HttpGet(by, true)
				end)
				if not bG or type(bH) ~= "string" or #bH < 128 then
					return nil, "could not download the image"
				end
				local bI = bH:sub(1, 64):lower()
				if bI:find("<!doctype") or bI:find("<html") then
					return nil, "that link is a web page, not an image"
				end
				bb(bE)
				if not pcall(writefile, bF, bH) then
					return nil, "could not save the image"
				end
			end
			local bG, bH = pcall(getcustomasset, bF)
			if bG and type(bH) == "string" and bH ~= "" then
				return bH
			end
			pcall(delfile, bF)
			return nil, "the downloaded file is not an image"
		end
		if bA then
			for bB, bC in ipairs({ self:_backgroundFolder() .. "/" .. by, by }) do
				if isfile(bC) then
					local bD, bE = pcall(getcustomasset, bC)
					if bD and type(bE) == "string" and bE ~= "" then
						return bE
					end
					return nil, "could not load " .. by
				end
			end
		end
		return nil, "no image called " .. by
	end
	function __Ixa_guiWindow:SetBackground(by)
		self._backgroundGeneration += 1
		local bz = self._backgroundGeneration
		local bA = self._backgroundImage
		by = by ~= false and self:_trimBackground(by) or ""
		if by == "" or by == "None" then
			self.Background = nil
			__Ixa_guiTween(bA, { ImageTransparency = 1 }, 0.25)
			task.delay(0.25, function()
				if self._backgroundGeneration == bz then
					bA.Visible = false
					bA.Image = ""
				end
			end)
			self:SetTransparent(self.Transparent)
			return true
		end
		local bB, bC = self:_resolveBackground(by)
		if self._backgroundGeneration ~= bz or self._destroyed then
			return false, "replaced by a newer background"
		end
		if not bB then
			return false, bC
		end
		self.Background = by
		bA.Image = bB
		bA.Visible = true
		__Ixa_guiTween(bA, { ImageTransparency = self.BackgroundTransparency }, 0.3)
		self:SetTransparent(self.Transparent)
		return true
	end
	function __Ixa_guiWindow:GetBackground()
		return self.Background
	end
	function __Ixa_guiWindow:SetBackgroundTransparency(by)
		self.BackgroundTransparency = math.clamp(tonumber(by) or 0.35, 0, 1)
		if self.Background then
			__Ixa_guiTween(self._backgroundImage, { ImageTransparency = self.BackgroundTransparency }, 0.15)
		end
	end
	function __Ixa_guiWindow:ListBackgrounds()
		local by = table.clone(__Ixa_guiLibrary.BackgroundPresetOrder)
		local bz = self:_backgroundFolder()
		if type(listfiles) == "function" and type(isfolder) == "function" and isfolder(bz) then
			local bA = {}
			for bB, bC in ipairs(listfiles(bz)) do
				local bD = bC:match("([^/]+)$")
				local bE = bD and bD:match("%.(%w+)$")
				if bE and __Ixa_guiLibrary._imageExtensions[bE:lower()] then
					table.insert(bA, bD)
				end
			end
			table.sort(bA)
			for bB, bC in ipairs(bA) do
				table.insert(by, bC)
			end
		end
		return by
	end
	local function by(bz, bA, bB)
		local bC = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, -10),
				Size = UDim2.fromOffset(200, 70),
				BackgroundTransparency = 1,
				Parent = bz,
			}
		)
		local bD = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.fromOffset(26, 26),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ImageTransparency = 0.15,
				ScaleType = Enum.ScaleType.Fit,
				Parent = bC,
			}
		)
		__Ixa_guiApplyIcon(bD, bA)
		local bE = __Ixa_guiLabel({
			Position = UDim2.fromOffset(0, 36),
			Size = UDim2.new(1, 0, 0, 16),
			Text = bB,
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = bC,
		})
		return bC, bE, bD
	end
	local function bz(bA, bB)
		bB = bB or 0
		bA.GroupTransparency = 1
		bA.Position = UDim2.fromOffset(0, bB + 14)
		bA.Visible = true
		__Ixa_guiTween(bA, { GroupTransparency = 0, Position = UDim2.fromOffset(0, bB) }, 0.32, Enum.EasingStyle.Quint)
	end
	local function bA(bB)
		bB = math.max(math.floor(bB), 0)
		local bC = math.floor(bB / 86400)
		local bD = math.floor(bB / 3600) % 24
		local bE = math.floor(bB / 60) % 60
		if bC > 0 then
			return string.format("%dd %dh", bC, bD)
		elseif bD > 0 then
			return string.format("%dh %dm", bD, bE)
		elseif bE > 0 then
			return string.format("%dm %ds", bE, bB % 60)
		end
		return string.format("%ds", bB)
	end
	local function bB(bC)
		if type(bC) ~= "string" or bC == "" then
			return "Studio"
		end
		if #bC > 16 then
			return bC:sub(1, 8) .. "..." .. bC:sub(-4)
		end
		return bC
	end
	local function bC(bD)
		local bE = setclipboard or toclipboard or (Clipboard and Clipboard.set)
		if type(bE) ~= "function" then
			return false
		end
		return (pcall(bE, tostring(bD)))
	end
	local function bD(bE)
		local bF = string.format(
			[[https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true]],
			game.PlaceId,
			bE
		)
		local bG, bH = pcall(function()
			return game:HttpGet(bF)
		end)
		if not bG or type(bH) ~= "string" then
			return nil
		end
		local bI, bJ = pcall(function()
			return __Ixa_guiHttpService:JSONDecode(bH)
		end)
		if not bI or type(bJ) ~= "table" or type(bJ.data) ~= "table" then
			return nil
		end
		return bJ.data
	end
	local function bE(bF, bG, bH, bI)
		local bJ = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.fromOffset(30, 16),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = bH,
				Parent = bF,
			}
		)
		__Ixa_guiCorner(bJ, UDim.new(1, 0))
		__Ixa_guiStroke(bJ)
		local bK = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 2, 0.5, 0),
				Size = UDim2.fromOffset(12, 12),
				BackgroundColor3 = __Ixa_guiTheme.Muted,
				BorderSizePixel = 0,
				Parent = bJ,
			}
		)
		__Ixa_guiCorner(bK, UDim.new(1, 0))
		local bL = bG == true
		local function bM(bN)
			local bO = bN and 0.22 or 0
			__Ixa_guiTween(bJ, { BackgroundColor3 = bL and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3 }, bO)
			__Ixa_guiTween(
				bK,
				{
					Position = bL and UDim2.new(0, 16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
					BackgroundColor3 = bL and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Muted,
				},
				bO,
				Enum.EasingStyle.Back
			)
		end
		bJ.MouseButton1Click:Connect(function()
			bL = not bL
			bM(true)
			__Ixa_guiCall(bI, bL)
		end)
		bM(false)
		return bJ
	end
	local function bF(bG, bH, bI, bJ)
		local bK = __Ixa_guiNew(
			"TextButton",
			{
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.45,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ClipsDescendants = true,
				Parent = bG,
			}
		)
		for bL, bM in pairs(bI) do
			bK[bL] = bM
		end
		__Ixa_guiCorner(bK, UDim.new(0, 6))
		local bL = __Ixa_guiStroke(bK)
		local bM = __Ixa_guiLabel({
			Size = UDim2.fromScale(1, 1),
			Text = bH,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = bK,
		})
		if bK.AutomaticSize == Enum.AutomaticSize.X then
			bM.Size = UDim2.new(0, 0, 1, 0)
			bM.AutomaticSize = Enum.AutomaticSize.X
			bM.TextTruncate = Enum.TextTruncate.None
			__Ixa_guiPadding(bK, 14, 14)
		end
		bK.MouseEnter:Connect(function()
			__Ixa_guiTween(bK, { BackgroundTransparency = 0.15 }, 0.12)
			__Ixa_guiTween(bL, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
		end)
		bK.MouseLeave:Connect(function()
			__Ixa_guiTween(bK, { BackgroundTransparency = 0.45 }, 0.25)
			__Ixa_guiTween(bL, { Color = __Ixa_guiTheme.Stroke }, 0.25)
		end)
		bK.MouseButton1Click:Connect(function()
			__Ixa_guiRipple(bK)
			__Ixa_guiCall(bJ)
		end)
		return bK, bM
	end
	local function bG(bH, bI, bJ)
		local bK = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, bI), BackgroundColor3 = __Ixa_guiTheme.Surface2, BorderSizePixel = 0, LayoutOrder = bJ, Parent = bH }
		)
		bK:SetAttribute("NoDrag", true)
		__Ixa_guiCorner(bK, UDim.new(0, 10))
		__Ixa_guiStroke(bK)
		return bK
	end
	local bH = {
		Players = { "users", "Players" },
		Friends = { "user-check", "Friends" },
		Execs = { "zap", "Execs" },
		Session = { "timer", "Session" },
		Uptime = { "timer", "Session" },
		FPS = { "gauge", "FPS" },
		Ping = { "wifi", "Ping" },
		Executor = { "terminal", "Executor" },
		Game = { "gamepad-2", "Game" },
		Region = { "globe", "Region" },
		Time = { "clock", "Time" },
		ServerAge = { "server", "Server age" },
		Memory = { "cpu", "Memory" },
	}
	function __Ixa_guiLibrary._healthColor(bI, bJ, bK, bL)
		if type(bI) ~= "number" then
			return __Ixa_guiTheme.Text
		end
		if bL then
			return bI <= bJ and __Ixa_guiTheme.Success or bI <= bK and __Ixa_guiTheme.Warning or __Ixa_guiTheme.Error
		end
		return bI >= bJ and __Ixa_guiTheme.Success or bI >= bK and __Ixa_guiTheme.Warning or __Ixa_guiTheme.Error
	end
	local function bI(bJ)
		if not ba() then
			return nil
		end
		local bK = bJ .. "/executions.txt"
		local bL = 0
		pcall(function()
			bb(bJ)
			if isfile(bK) then
				bL = tonumber(readfile(bK)) or 0
			end
		end)
		bL += 1
		pcall(writefile, bK, tostring(bL))
		return bL
	end
	local function bJ(bK, bL, bM, bN, bO)
		local bP = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Position = UDim2.fromOffset(0, bM),
				Size = UDim2.new(1, 0, 1, -bM),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0.5,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				Parent = bL,
			}
		)
		__Ixa_guiLibrary._space(__Ixa_guiPadding(bP, 24, 24, 2, 24), { 24, 24, 2, 24 })
		__Ixa_guiLibrary._space(
			__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = bP }),
			8
		)
		bK.List = bP
		bK._items = {}
		bK._groupboxes = {}
		bK._childCount = 0
		bK._emptyText = bO
		bK._empty, bK._emptyCaption = by(bL, bN, bO)
		bP.ChildAdded:Connect(function(bQ)
			if bQ:IsA("GuiObject") then
				bK._childCount += 1
				bK:_refreshEmpty()
			end
		end)
		bP.ChildRemoved:Connect(function(bQ)
			if bQ:IsA("GuiObject") then
				bK._childCount = math.max(bK._childCount - 1, 0)
				bK:_refreshEmpty()
			end
		end)
		bK:_refreshEmpty()
		return bP
	end
	function __Ixa_guiGroup:_refreshEmpty()
		local bK = self._empty
		if not bK then
			return
		end
		if self._subTabs then
			bK.Visible = false
		else
			bK.Visible = self._childCount == 0
		end
	end
	function __Ixa_guiGroup:_columns()
		if self._columnSet then
			return self._columnSet
		end
		local bK = __Ixa_guiNew(
			"Frame",
			{
				Name = "Columns",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 100000,
				Parent = self.List,
			}
		)
		local bL = __Ixa_guiLibrary._space(
			__Ixa_guiNew(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 10),
					Parent = bK,
				}
			),
			10
		)
		local function bM(bN)
			local bO = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.new(0.5, -5, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = bN,
					Parent = bK,
				}
			)
			__Ixa_guiLibrary._space(
				__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = bO }),
				10
			)
			return bO
		end
		local bN = { Holder = bK, Left = bM(1), Right = bM(2), Counts = { 0, 0 }, Stacked = false }
		local bO = self.Window
		local function bP()
			local bQ = bK.AbsoluteSize.X / bO.Scale.Scale
			if bQ <= 0 then
				return
			end
			local bR = bQ < __Ixa_guiBreakpoint
			local bS = bL.Padding.Offset
			if bR == bN.Stacked and bS == bN.Gap then
				return
			end
			bN.Stacked = bR
			bN.Gap = bS
			bL.FillDirection = bR and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
			local bT = bR and UDim2.new(1, 0, 0, 0) or UDim2.new(0.5, -bS / 2, 0, 0)
			bN.Left.Size = bT
			bN.Right.Size = bT
		end
		bK:GetPropertyChangedSignal("AbsoluteSize"):Connect(bP)
		bL:GetPropertyChangedSignal("Padding"):Connect(bP)
		task.defer(bP)
		self._columnSet = bN
		return bN
	end
	function __Ixa_guiGroup:Groupbox(bK, bL)
		if self._groupbox then
			return self.Parent:Groupbox(bK, bL)
		end
		bK = __Ixa_guiOptions(bK, { Title = "Name" })
		if bL ~= nil and bK.Icon == nil then
			bK.Icon = bL
		end
		local bM = self.Window
		local bN = self:_columns()
		local bO = bK.Side
		if bO == "Left" or bO == 1 then
			bO = 1
		elseif bO == "Right" or bO == 2 then
			bO = 2
		else
			bO = bN.Counts[1] <= bN.Counts[2] and 1 or 2
		end
		bN.Counts[bO] += 1
		local bP = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = __Ixa_guiTheme.Surface2,
				BorderSizePixel = 0,
				LayoutOrder = bN.Counts[bO],
				Parent = bO == 1 and bN.Left or bN.Right,
			}
		)
		bP:SetAttribute("NoDrag", true)
		__Ixa_guiCorner(bP, UDim.new(0, 10))
		__Ixa_guiStroke(bP)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = bP })
		local bQ = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = 1,
				Parent = bP,
			}
		)
		__Ixa_guiCorner(bQ, UDim.new(0, 10))
		local bR = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 10),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Parent = bQ,
			}
		)
		local bS = 14
		if bK.Icon then
			local bT = __Ixa_guiNew(
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 14, 0.5, 0),
					Size = UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Accent,
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = 2,
					Parent = bQ,
				}
			)
			__Ixa_guiApplyIcon(bT, bK.Icon)
			bS = 37
		end
		local bT = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -14, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 2,
				Parent = bQ,
			}
		)
		__Ixa_guiApplyIcon(bT, "chevron-down")
		local bU = bK.PopOut ~= false
		local bV, bW
		if bU then
			bV = __Ixa_guiNew(
				"TextButton",
				{
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -34, 0.5, 0),
					Size = UDim2.fromOffset(24, 24),
					BackgroundColor3 = __Ixa_guiTheme.Surface2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 3,
					Parent = bQ,
				}
			)
			__Ixa_guiCorner(bV, UDim.new(0, 6))
			bW = __Ixa_guiNew(
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(13, 13),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Muted,
					ImageTransparency = __Ixa_guiTouch and 0 or 0.45,
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = 3,
					Parent = bV,
				}
			)
			__Ixa_guiApplyIcon(bW, "picture-in-picture-2")
		end
		local bX = __Ixa_guiLabel({
			Position = UDim2.fromOffset(bS, 0),
			Size = UDim2.new(1, -(bS + (bU and 66 or 40)), 1, 0),
			Text = bK.Name or "Groupbox",
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Bold,
			ZIndex = 2,
			Parent = bQ,
		})
		local bY = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = __Ixa_guiTheme.Stroke, BorderSizePixel = 0, LayoutOrder = 2, Parent = bP }
		)
		local bZ = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				LayoutOrder = 3,
				Parent = bP,
			}
		)
		local b_ = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = bZ }
		)
		__Ixa_guiLibrary._space(__Ixa_guiPadding(b_, 0, 0, 6, 8), { 0, 0, 6, 8 })
		__Ixa_guiLibrary._space(
			__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = b_ }),
			2
		)
		local b0 = setmetatable(
			{
				Name = bK.Name or "Groupbox",
				Window = bM,
				Parent = self,
				List = b_,
				Frame = bP,
				_frame = bP,
				_order = 0,
				_groupbox = true,
				_metrics = __Ixa_guiControlStyles.Row,
				_items = {},
			},
			__Ixa_guiGroup
		)
		table.insert(self._groupboxes, b0)
		if type(b0.Name) == "string" and string.lower(b0.Name:match("^%s*(.-)%s*$")) == "menu" then
			task.defer(function()
				if bM._destroyed or bM._minimizeOnStartToggle or not bP.Parent then
					return
				end
				local b1 = b0:CreateMinimizeOnStart()
				local b2 = b1 and b1._frame
				if not b2 then
					return
				end
				local b3
				for b4, b5 in ipairs(b0._items) do
					local b6 = b5._frame
					if
						b5._type == "Button"
						and b6
						and b6.Parent == b2.Parent
						and (not b3 or b6.LayoutOrder < b3.LayoutOrder)
					then
						b3 = b6
					end
				end
				if b3 then
					local b4 = b3.LayoutOrder
					for b5, b6 in ipairs(b2.Parent:GetChildren()) do
						if b6:IsA("GuiObject") and b6 ~= b2 and b6.LayoutOrder >= b4 then
							b6.LayoutOrder += 1
						end
					end
					b2.LayoutOrder = b4
					b0._order += 1
				end
			end)
		end
		local b1 = false
		local b2 = 0
		local function b3(b4, b5)
			b4 = b4 == true
			if b4 == b1 then
				return
			end
			b1 = b4
			b2 += 1
			local b6 = b2
			local b7 = b5 and 0 or 0.32
			if b4 then
				for b8, b9 in ipairs(b0._items) do
					if b9._onHide then
						b9._onHide()
					end
					if b9.Open and type(b9.SetOpen) == "function" then
						b9:SetOpen(false)
					end
				end
			end
			bM._controlsDirty = true
			local b8 = bM.Scale.Scale
			if b4 then
				bZ.AutomaticSize = Enum.AutomaticSize.None
				bZ.Size = UDim2.new(1, 0, 0, bZ.AbsoluteSize.Y / b8)
				__Ixa_guiTween(bZ, { Size = UDim2.new(1, 0, 0, 0) }, b7, Enum.EasingStyle.Quint)
			else
				__Ixa_guiTween(bZ, { Size = UDim2.new(1, 0, 0, b_.AbsoluteSize.Y / b8) }, b7, Enum.EasingStyle.Quint)
				local function b9()
					if b2 == b6 and not b1 then
						bZ.AutomaticSize = Enum.AutomaticSize.Y
						bZ.Size = UDim2.new(1, 0, 0, 0)
					end
				end
				if b7 > 0 then
					task.delay(b7, b9)
				else
					b9()
				end
			end
			local b9 = b5 and 0 or 0.3
			if b4 then
				local function ca()
					if b2 == b6 and b1 then
						bY.Visible = false
						bR.Visible = false
					end
				end
				if b7 > 0 then
					task.delay(b7, ca)
				else
					ca()
				end
			else
				bY.Visible = true
				bR.Visible = true
			end
			__Ixa_guiTween(bT, { Rotation = b4 and -90 or 0 }, b9, Enum.EasingStyle.Quint)
		end
		local function b4(b5)
			local b6 = b5 and 0.15 or 0.25
			__Ixa_guiTween(bT, { ImageColor3 = b5 and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted }, b6)
			if bW and not __Ixa_guiTouch then
				__Ixa_guiTween(bW, { ImageTransparency = b5 and 0 or 0.45 }, b6)
			end
		end
		bQ.MouseEnter:Connect(function()
			b4(true)
		end)
		bQ.MouseLeave:Connect(function()
			b4(false)
		end)
		local b5 = __Ixa_guiClickGuard(bQ, function()
			return bP:FindFirstAncestorWhichIsA("ScrollingFrame")
		end)
		local b6, b7 = false, 0
		local b8, b9, ca, cb, cc
		local cd, ce, cf, cg = nil, nil, false, false
		local ch
		local ci, cj, ck
		local cl, cm = 200, 80
		local cn = false
		local function co()
			return math.max(bM.Scale.Scale, 0.05)
		end
		local function cp(cq)
			return (cq - bM._popLayer.AbsolutePosition) / co()
		end
		local function cq(cr, cs, ct)
			local cu = bM._popLayer.AbsoluteSize / co()
			local cv = 8
			local cw = math.clamp(cr.X, cs / 2 + cv, math.max(cu.X - cs / 2 - cv, cs / 2 + cv))
			local cx = math.clamp(cr.Y, cv, math.max(cu.Y - math.min(ct, 120) - cv, cv))
			return Vector2.new(cw, cx)
		end
		local function cr()
			for cs, ct in ipairs(b0._items) do
				if ct._onHide then
					ct._onHide()
				end
				if ct.Open and type(ct.SetOpen) == "function" then
					ct:SetOpen(false)
				end
			end
		end
		local function cs(ct)
			if bW then
				__Ixa_guiApplyIcon(bW, ct and "minimize-2" or "picture-in-picture-2")
			end
		end
		local ct
		local function cu(cv)
			if b6 or not bU or not bP.Parent or b0._destroyed then
				return
			end
			if b0._settleDock then
				b0._settleDock()
			end
			local cw = bM:_popoutLayer()
			b6 = true
			b0._popped = true
			b7 += 1
			local cx = b7
			cr()
			bM:_closePopups()
			local cy = co()
			local cz = bP.Parent
			local cA = cp(bP.AbsolutePosition)
			local cB = bP.AbsoluteSize.X / cy
			local cC = bP.AbsoluteSize.Y / cy
			cb = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.new(1, 0, 0, cC),
					BackgroundColor3 = __Ixa_guiTheme.Surface2,
					BackgroundTransparency = 0.6,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ClipsDescendants = true,
					LayoutOrder = bP.LayoutOrder,
					Parent = cz,
				}
			)
			cb:SetAttribute("NoDrag", true)
			__Ixa_guiCorner(cb, UDim.new(0, 10))
			__Ixa_guiStroke(cb, __Ixa_guiTheme.Stroke, 1).Transparency = 0.3
			local cD = __Ixa_guiLabel({
				Size = UDim2.new(1, -24, 0, 40),
				Position = UDim2.fromOffset(12, 0),
				Text = __Ixa_guiLibrary._rich(b0.Name) .. '<font transparency="0.4">  \u{b7}  popped out, click to dock</font>',
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextXAlignment = Enum.TextXAlignment.Center,
				RichText = true,
				TextTransparency = 1,
				Parent = cb,
			})
			local cE = cb
			cb.MouseEnter:Connect(function()
				__Ixa_guiTween(cE, { BackgroundTransparency = 0.35 }, 0.15)
			end)
			cb.MouseLeave:Connect(function()
				__Ixa_guiTween(cE, { BackgroundTransparency = 0.6 }, 0.25)
			end)
			cb.MouseButton1Click:Connect(function()
				if cb == cE then
					b0:Dock()
				end
			end)
			__Ixa_guiTween(cb, { Size = UDim2.new(1, 0, 0, 40) }, 0.42, Enum.EasingStyle.Quint)
			__Ixa_guiTween(cD, { TextTransparency = 0 }, 0.3)
			cb.Visible = bP.Visible
			b8 = __Ixa_guiNew(
				"Frame",
				{
					Name = "PopOut",
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.fromOffset(cA.X + cB / 2, cA.Y),
					Size = UDim2.fromOffset(cB, cC),
					BackgroundTransparency = 1,
					Parent = cw,
				}
			)
			b8:SetAttribute("NoDrag", true)
			b9 = __Ixa_guiNew("UIScale", { Parent = b8 })
			ca = __Ixa_guiNew(
				"ImageLabel",
				{
					Position = UDim2.fromOffset(-24, -18),
					Size = UDim2.new(1, 48, 1, 44),
					BackgroundTransparency = 1,
					Image = __Ixa_guiAssets.Shadow,
					ImageColor3 = Color3.new(0, 0, 0),
					ImageTransparency = 1,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(49, 49, 450, 450),
					ZIndex = 0,
					Parent = b8,
				}
			)
			local cF = __Ixa_guiNew(
				"ScrollingFrame",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					CanvasSize = UDim2.new(),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					ScrollBarThickness = 3,
					ScrollBarImageColor3 = __Ixa_guiTheme.Muted,
					VerticalScrollBarInset = Enum.ScrollBarInset.None,
					ElasticBehavior = Enum.ElasticBehavior.Never,
					ZIndex = 1,
					Parent = b8,
				}
			)
			cF:SetAttribute("NoDrag", true)
			local cG = __Ixa_guiTouch and 12 or 7
			local cH = { { -1, -1 }, { 0, -1 }, { 1, -1 }, { -1, 0 }, { 1, 0 }, { -1, 1 }, { 0, 1 }, { 1, 1 } }
			local cI
			for cJ, cK in ipairs(cH) do
				local cL, cM = cK[1], cK[2]
				local cN = __Ixa_guiNew(
					"TextButton",
					{
						AnchorPoint = Vector2.new((cL + 1) / 2, (cM + 1) / 2),
						Position = UDim2.new((cL + 1) / 2, cL * cG / 2, (cM + 1) / 2, cM * cG / 2),
						Size = UDim2.new(
							cL == 0 and 1 or 0,
							cL == 0 and -cG * 2 or cG * 2,
							cM == 0 and 1 or 0,
							cM == 0 and -cG * 2 or cG * 2
						),
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						ZIndex = (cL ~= 0 and cM ~= 0) and 21 or 20,
						Parent = b8,
					}
				)
				cN:SetAttribute("NoDrag", true)
				if cL == 1 and cM == 1 then
					cI = __Ixa_guiNew(
						"ImageLabel",
						{
							AnchorPoint = Vector2.new(1, 1),
							Position = UDim2.new(1, -cG - 2, 1, -cG - 2),
							Size = UDim2.fromOffset(11, 11),
							BackgroundTransparency = 1,
							ImageColor3 = __Ixa_guiTheme.Muted,
							ImageTransparency = 0.35,
							Rotation = 90,
							ScaleType = Enum.ScaleType.Fit,
							ZIndex = 21,
							Parent = cN,
						}
					)
					__Ixa_guiApplyIcon(cI, "move-diagonal-2")
				end
				cN.MouseEnter:Connect(function()
					__Ixa_guiTween(cI, { ImageColor3 = __Ixa_guiTheme.Text, ImageTransparency = 0 }, 0.15)
				end)
				cN.MouseLeave:Connect(function()
					__Ixa_guiTween(cI, { ImageColor3 = __Ixa_guiTheme.Muted, ImageTransparency = 0.35 }, 0.25)
				end)
				cN.InputBegan:Connect(function(cO)
					if not b6 or not __Ixa_guiIsPointerPress(cO) or not b8 then
						return
					end
					local cP, cQ = b8.Size.X.Offset, b8.Size.Y.Offset
					local cR = b8.Position.X.Offset - cP / 2
					local cS = b8.Position.Y.Offset
					ci = Vector2.new(cO.Position.X, cO.Position.Y)
					cj = { cR, cS, cR + cP, cS + cQ, cL, cM }
					cn = false
					cr()
					bM:_closePopups()
				end)
			end
			table.insert(bM._popPanels, b8)
			bP.Parent = cF
			if b0._popWidth then
				cB = math.max(b0._popWidth, cl)
				b8.Size = UDim2.fromOffset(cB, cC)
			end
			ck = b0._popHeight
			bM._controlsDirty = true
			cs(true)
			if cv then
				b9.Scale = 1.025
				ca.ImageTransparency = 0.15
				ct(cx)
				return
			end
			local cJ = cq(b0._popSpot or Vector2.new(cA.X + cB / 2 + 22, cA.Y - 14), cB, cC)
			cn = true
			b9.Scale = 0.97
			__Ixa_guiTween(b8, { Position = UDim2.fromOffset(cJ.X, cJ.Y) }, 0.5, Enum.EasingStyle.Quint)
			__Ixa_guiTween(b9, { Scale = 1 }, 0.55, Enum.EasingStyle.Back)
			__Ixa_guiTween(ca, { ImageTransparency = 0.35 }, 0.4)
			ct(cx)
		end
		function ct(cv)
			task.delay(0.5, function()
				if b7 == cv then
					cn = false
				end
			end)
			local cw = b8
			cc = bM:_listen("Render", function()
				if b8 ~= cw or not cw.Parent then
					return
				end
				local cx = not b1 and ck or nil
				local cy = UDim2.new(1, 0, 0, cx or 0)
				if bP.Size ~= cy then
					bP.Size = cy
				end
				local cz = bP.AbsoluteSize.Y / co()
				local cA = cx or cz
				if not ci and math.abs(cw.Size.Y.Offset - cA) > 0.5 then
					cw.Size = UDim2.fromOffset(cw.Size.X.Offset, cA)
				end
				cw.Visible = bP.Visible
				if cb then
					cb.Visible = bP.Visible
				end
				if not cn and not cd and not ci then
					local cB = Vector2.new(cw.Position.X.Offset, cw.Position.Y.Offset)
					local cC = cq(cB, cw.Size.X.Offset, cA)
					if (cC - cB).Magnitude > 0.5 then
						cw.Position = UDim2.fromOffset(cC.X, cC.Y)
					end
				end
			end)
		end
		local function cv(cw)
			if not b6 then
				return
			end
			b6 = false
			b0._popped = false
			b7 += 1
			cd, cf, cg = nil, false, false
			ci, ch = nil, nil
			bP.Size = UDim2.new(1, 0, 0, 0)
			cr()
			bM:_closePopups()
			local cx, cy, cz, cA, cB = b8, cb, cc, b9, ca
			b8, cb, cc = nil, nil, nil
			cs(false)
			b0._popSpot = Vector2.new(cx.Position.X.Offset, cx.Position.Y.Offset)
			local cC = false
			local function cD()
				if cC then
					return
				end
				cC = true
				if b0._settleDock == cD then
					b0._settleDock = nil
				end
				if cz then
					cz()
				end
				local cE = table.find(bM._popPanels, cx)
				if cE then
					table.remove(bM._popPanels, cE)
				end
				if bP:IsDescendantOf(cx) then
					if cy and cy.Parent and not b0._destroyed then
						bP.Parent = cy.Parent
						bP.LayoutOrder = cy.LayoutOrder
					end
				end
				if cy then
					cy:Destroy()
				end
				if not bP:IsDescendantOf(cx) then
					cx:Destroy()
				end
				cn = false
				bM._controlsDirty = true
			end
			b0._settleDock = cD
			local cE = not cw
				and cy
				and cy.Parent
				and bM.Root.Visible
				and bP.Visible
				and cy.AbsoluteSize.X > 0
				and a3(cy, bM.Body, cy.AbsolutePosition + cy.AbsoluteSize / 2)
			if not cE then
				cD()
				return
			end
			cn = true
			local cF = co()
			local cG = bP.AbsoluteSize.Y / cF
			local cH = cy.AbsoluteSize.X / cF
			__Ixa_guiTween(cy, { Size = UDim2.new(1, 0, 0, cG) }, 0.36, Enum.EasingStyle.Quint)
			local cI = cy:FindFirstChildWhichIsA("TextLabel")
			if cI then
				__Ixa_guiTween(cI, { TextTransparency = 1 }, 0.12)
			end
			local cJ = cp(cy.AbsolutePosition)
			__Ixa_guiTween(
				cx,
				{ Position = UDim2.fromOffset(cJ.X + cH / 2, cJ.Y), Size = UDim2.fromOffset(cH, cG) },
				0.36,
				Enum.EasingStyle.Quint
			)
			__Ixa_guiTween(cA, { Scale = 1 }, 0.2)
			__Ixa_guiTween(cB, { ImageTransparency = 1 }, 0.3)
			task.delay(0.37, cD)
		end
		bQ.InputBegan:Connect(function(cw)
			if not b6 and bU and not __Ixa_guiTouch and __Ixa_guiIsPointerPress(cw) then
				ch = Vector2.new(cw.Position.X, cw.Position.Y)
				return
			end
			if not b6 or not __Ixa_guiIsPointerPress(cw) or not b8 then
				return
			end
			cd = Vector2.new(cw.Position.X, cw.Position.Y)
			ce = Vector2.new(b8.Position.X.Offset, b8.Position.Y.Offset)
			cf = false
			cg = false
		end)
		bM:_listen("Changed", function(cw)
			if not __Ixa_guiIsPointerMove(cw) then
				return
			end
			if ci and b8 then
				local cx = (Vector2.new(cw.Position.X, cw.Position.Y) - ci) / co()
				local cy = bM._popLayer.AbsoluteSize / co()
				local cz = bP.AbsoluteSize.Y / co()
				local cA, cB, cC, cD, cE, cF = table.unpack(cj)
				local cG = math.max(cy.X - 16, cl)
				local cH = cm
				local cI = math.max(cy.Y - 16, cm)
				if cE == 1 then
					cC = cA + math.clamp(cC - cA + cx.X, cl, cG)
				elseif cE == -1 then
					cA = cC - math.clamp(cC - cA - cx.X, cl, cG)
				end
				if cF == 1 then
					cD = cB + math.clamp(cD - cB + cx.Y, cH, cI)
				elseif cF == -1 then
					cB = cD - math.clamp(cD - cB - cx.Y, cH, cI)
				end
				local cJ = cD - cB
				if cF ~= 0 then
					ck = cJ
				end
				b8.Size = UDim2.fromOffset(cC - cA, cJ)
				b8.Position = UDim2.fromOffset((cA + cC) / 2, cB)
				bM._controlsDirty = true
				return
			end
			if ch and not b6 then
				local cx = Vector2.new(cw.Position.X, cw.Position.Y) - ch
				if cx.Magnitude < 2 then
					return
				end
				local cy = ch
				ch = nil
				bM:_popoutLayer()
				local cz = cp(bP.AbsolutePosition) + Vector2.new(bP.AbsoluteSize.X / co() / 2, 0)
				cu(true)
				if not b6 or not b8 then
					return
				end
				cd, ce = cy, cz
				cf, cg = true, true
				cn = false
			end
			if not cd or not b8 then
				return
			end
			local cx = Vector2.new(cw.Position.X, cw.Position.Y) - cd
			if not cf then
				if cx.Magnitude < (__Ixa_guiTouch and 8 or 5) then
					return
				end
				cf, cg = true, true
				cn = false
				cr()
				bM:_closePopups()
				__Ixa_guiTween(b9, { Scale = 1.025 }, 0.18, Enum.EasingStyle.Quint)
				__Ixa_guiTween(ca, { ImageTransparency = 0.15 }, 0.18)
			end
			local cy = cq(ce + cx / co(), b8.Size.X.Offset, b8.Size.Y.Offset)
			b8.Position = UDim2.fromOffset(cy.X, cy.Y)
		end, b0)
		bM:_listen("Ended", function(cw)
			if not __Ixa_guiIsPointerPress(cw) then
				return
			end
			ch = nil
			if ci then
				ci = nil
				if b8 then
					b0._popWidth = b8.Size.X.Offset
					b0._popHeight = ck
					b0._popSpot = Vector2.new(b8.Position.X.Offset, b8.Position.Y.Offset)
				end
			end
			if not cd then
				return
			end
			cd = nil
			if cf and b8 then
				cf = false
				__Ixa_guiTween(b9, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
				__Ixa_guiTween(ca, { ImageTransparency = 0.35 }, 0.3)
				b0._popSpot = Vector2.new(b8.Position.X.Offset, b8.Position.Y.Offset)
			end
		end, b0)
		if bV then
			bV.MouseEnter:Connect(function()
				__Ixa_guiTween(bV, { BackgroundTransparency = 0 }, 0.15)
				__Ixa_guiTween(bW, { ImageColor3 = __Ixa_guiTheme.Text }, 0.15)
			end)
			bV.MouseLeave:Connect(function()
				__Ixa_guiTween(bV, { BackgroundTransparency = 1 }, 0.25)
				__Ixa_guiTween(bW, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.25)
			end)
			bV.MouseButton1Click:Connect(function()
				if b6 then
					cv()
				else
					cu()
				end
			end)
		end
		bQ.MouseButton1Click:Connect(function()
			if cg then
				cg = false
				return
			end
			if b5() then
				b3(not b1)
			end
		end)
		function b0:PopOut()
			cu()
		end
		function b0:Dock()
			cv()
		end
		function b0:IsPoppedOut()
			return b6
		end
		function b0:SetCollapsed(cw)
			b3(cw)
		end
		function b0:Collapse()
			b3(true)
		end
		function b0:Expand()
			b3(false)
		end
		function b0:IsCollapsed()
			return b1
		end
		function b0:SetTitle(cw)
			b0.Name = tostring(cw)
			bX.Text = b0.Name
		end
		b0._userVisible = bK.Visible ~= false
		function b0:IsVisible()
			return b0._userVisible
		end
		function b0:SetVisible(cw)
			cw = cw and true or false
			if cw == b0._userVisible then
				return
			end
			b0._userVisible = cw
			if not cw then
				for cx, cy in ipairs(b0._items) do
					if cy._onHide then
						cy._onHide()
					end
					if cy.Open and type(cy.SetOpen) == "function" then
						cy:SetOpen(false)
					end
				end
			end
			bP.Visible = cw
			bM._controlsDirty = true
		end
		if not b0._userVisible then
			bP.Visible = false
		end
		function b0:Destroy()
			for cw = #b0._items, 1, -1 do
				local cx = b0._items[cw]
				if type(cx.Destroy) == "function" then
					cx:Destroy()
				end
			end
			local cw = b0.Parent
			local cx = table.find(cw._groupboxes, b0)
			if cx then
				table.remove(cw._groupboxes, cx)
			end
			bN.Counts[bO] = math.max(bN.Counts[bO] - 1, 0)
			cv(true)
			b0._destroyed = true
			bM._controlsDirty = true
			bP:Destroy()
		end
		if bK.Collapsed then
			b3(true, true)
		end
		if bK.PoppedOut then
			task.defer(cu)
		end
		return b0
	end
	local function bK(bL)
		return function(bM, bN, bO)
			bN = __Ixa_guiOptions(bN, { Title = "Name" })
			bN.Side = bL
			return bM:Groupbox(bN, bO)
		end
	end
	function __Ixa_guiGroup:CreateMinimizeOnStart(bL)
		bL = bL or {}
		local bM = self.Window
		if bM._minimizeOnStartToggle then
			return bM._minimizeOnStartToggle
		end
		bM._minimizeOnStartToggle = self:CreateToggle({
			Name = bL.Name or "Minimize UI on Start",
			CurrentValue = bM:GetMinimizeOnStart(),
			Callback = function(bN)
				bM:SetMinimizeOnStart(bN)
			end,
		})
		return bM._minimizeOnStartToggle
	end
	__Ixa_guiGroup.CreateGroupbox = __Ixa_guiGroup.Groupbox
	__Ixa_guiGroup.AddGroupbox = __Ixa_guiGroup.Groupbox
	__Ixa_guiGroup.AddLeftGroupbox = bK("Left")
	__Ixa_guiGroup.AddRightGroupbox = bK("Right")
	function __Ixa_guiGroup:Tabbox(bL)
		if self._groupbox then
			return self.Parent:Tabbox(bL)
		end
		bL = __Ixa_guiOptions(bL, { Title = "Name" })
		local bM = self
		local bN = self.Window
		local bO = self:_columns()
		local bP = bL.Side
		if bP == "Left" or bP == 1 then
			bP = 1
		elseif bP == "Right" or bP == 2 then
			bP = 2
		else
			bP = bO.Counts[1] <= bO.Counts[2] and 1 or 2
		end
		bO.Counts[bP] += 1
		local bQ = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = __Ixa_guiTheme.Surface2,
				BorderSizePixel = 0,
				LayoutOrder = bO.Counts[bP],
				Parent = bP == 1 and bO.Left or bO.Right,
			}
		)
		bQ:SetAttribute("NoDrag", true)
		__Ixa_guiCorner(bQ, UDim.new(0, 10))
		__Ixa_guiStroke(bQ)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = bQ })
		local bR = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = __Ixa_guiTheme.Surface3, BorderSizePixel = 0, LayoutOrder = 1, Parent = bQ }
		)
		__Ixa_guiCorner(bR, UDim.new(0, 10))
		__Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 10),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Parent = bR,
			}
		)
		local bS = __Ixa_guiNew("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2, Parent = bR })
		__Ixa_guiNew(
			"UIListLayout",
			{ FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Parent = bS }
		)
		__Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = __Ixa_guiTheme.Stroke, BorderSizePixel = 0, LayoutOrder = 2, Parent = bQ }
		)
		local bT = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				LayoutOrder = 3,
				Parent = bQ,
			}
		)
		local bU = {
			Name = bL.Name or "Tabbox",
			Window = bN,
			Parent = bM,
			Frame = bQ,
			Tabs = {},
			_frame = bQ,
			_userVisible = bL.Visible ~= false,
		}
		local function bV(bW)
			for bX, bY in ipairs(bW._items) do
				if bY._onHide then
					bY._onHide()
				end
				if bY.Open and type(bY.SetOpen) == "function" then
					bY:SetOpen(false)
				end
			end
		end
		local function bW()
			local bX = math.max(#bU.Tabs, 1)
			for bY, bZ in ipairs(bU.Tabs) do
				bZ._button.Size = UDim2.new(1 / bX, 0, 1, 0)
			end
		end
		local function bX(bY, bZ)
			local b_ = bU.Current == bY
			local b0 = bZ and 0 or 0.2
			__Ixa_guiTween(bY._button, { BackgroundTransparency = b_ and 0 or 1 }, b0)
			__Ixa_guiTween(bY._label, { TextColor3 = b_ and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted }, b0)
			__Ixa_guiTween(bY._bar, { BackgroundTransparency = b_ and 0 or 1 }, b0)
			if bY._icon then
				__Ixa_guiTween(bY._icon, { ImageColor3 = b_ and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted }, b0)
			end
		end
		function bU:SelectTab(bY)
			if type(bY) == "string" or type(bY) == "number" then
				local bZ
				for b_, b0 in ipairs(bU.Tabs) do
					if b0.Title == bY or b_ == bY then
						bZ = b0
					end
				end
				bY = bZ
			end
			if not bY or bY._destroyed or bU.Current == bY then
				return
			end
			local bZ = bU.Current
			if bZ then
				bV(bZ)
				bZ._userVisible = false
				bZ.List.Visible = false
			end
			bU.Current = bY
			bY._userVisible = bU._userVisible
			bY.List.Visible = true
			for b_, b0 in ipairs(bU.Tabs) do
				bX(b0, bZ == nil)
			end
			bN._controlsDirty = true
		end
		function bU:AddTab(bY, bZ)
			local b_ = __Ixa_guiOptions(bY, { Title = "Name" })
			if bZ ~= nil and b_.Icon == nil then
				b_.Icon = bZ
			end
			local b0 = b_.Name or ("Tab " .. (#bU.Tabs + 1))
			local b1 = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = __Ixa_guiTheme.Surface2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					LayoutOrder = #bU.Tabs + 1,
					ZIndex = 2,
					Parent = bS,
				}
			)
			local b2 = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, -12, 1, 0),
					BackgroundTransparency = 1,
					ZIndex = 2,
					Parent = b1,
				}
			)
			__Ixa_guiNew(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6),
					Parent = b2,
				}
			)
			local b3
			if b_.Icon then
				b3 = __Ixa_guiNew(
					"ImageLabel",
					{
						Size = UDim2.fromOffset(13, 13),
						BackgroundTransparency = 1,
						ImageColor3 = __Ixa_guiTheme.Muted,
						ScaleType = Enum.ScaleType.Fit,
						LayoutOrder = 1,
						ZIndex = 2,
						Parent = b2,
					}
				)
				__Ixa_guiApplyIcon(b3, b_.Icon)
			end
			local b4 = __Ixa_guiLabel({
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = b0,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Bold,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 2,
				ZIndex = 2,
				Parent = b2,
			})
			local b5 = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0.5, 1),
					Position = UDim2.fromScale(0.5, 1),
					Size = UDim2.new(1, -16, 0, 2),
					BackgroundColor3 = __Ixa_guiTheme.Accent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ZIndex = 3,
					Parent = b1,
				}
			)
			__Ixa_guiCorner(b5, UDim.new(1, 0))
			local b6 = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Visible = false,
					Parent = bT,
				}
			)
			__Ixa_guiLibrary._space(__Ixa_guiPadding(b6, 0, 0, 6, 8), { 0, 0, 6, 8 })
			__Ixa_guiLibrary._space(
				__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = b6 }),
				2
			)
			local b7 = setmetatable(
				{
					Name = bU.Name .. " \u{203a} " .. b0,
					Title = b0,
					Window = bN,
					Parent = bM,
					Tabbox = bU,
					List = b6,
					Frame = bQ,
					_frame = bQ,
					_order = 0,
					_groupbox = true,
					_metrics = __Ixa_guiControlStyles.Row,
					_items = {},
					_userVisible = false,
					_button = b1,
					_label = b4,
					_icon = b3,
					_bar = b5,
				},
				__Ixa_guiGroup
			)
			function b7:IsCollapsed()
				return bU.Current ~= b7
			end
			function b7:Expand()
				bU:SelectTab(b7)
			end
			function b7:Collapse() end
			function b7:Select()
				bU:SelectTab(b7)
			end
			function b7:SetTitle(b8)
				b7.Title = tostring(b8)
				b7.Name = bU.Name .. " \u{203a} " .. b7.Title
				b4.Text = b7.Title
			end
			function b7:Destroy()
				for b8 = #b7._items, 1, -1 do
					local b9 = b7._items[b8]
					if type(b9.Destroy) == "function" then
						b9:Destroy()
					end
				end
				b7._destroyed = true
				local b8 = table.find(bU.Tabs, b7)
				if b8 then
					table.remove(bU.Tabs, b8)
				end
				b8 = table.find(bM._groupboxes, b7)
				if b8 then
					table.remove(bM._groupboxes, b8)
				end
				b1:Destroy()
				b6:Destroy()
				bW()
				if bU.Current == b7 then
					bU.Current = nil
					if bU.Tabs[1] then
						bU:SelectTab(bU.Tabs[1])
					end
				end
				bN._controlsDirty = true
			end
			b1.MouseEnter:Connect(function()
				if bU.Current ~= b7 then
					__Ixa_guiTween(b4, { TextColor3 = __Ixa_guiTheme.Text }, 0.15)
				end
			end)
			b1.MouseLeave:Connect(function()
				if bU.Current ~= b7 then
					__Ixa_guiTween(b4, { TextColor3 = __Ixa_guiTheme.Muted }, 0.15)
				end
			end)
			b1.Activated:Connect(function()
				bU:SelectTab(b7)
			end)
			table.insert(bU.Tabs, b7)
			table.insert(bM._groupboxes, b7)
			bW()
			if not bU.Current then
				bU:SelectTab(b7)
			else
				bX(b7, true)
			end
			return b7
		end
		bU.CreateTab = bU.AddTab
		bU.Tab = bU.AddTab
		function bU:SetTitle(bY)
			bU.Name = tostring(bY)
			for bZ, b_ in ipairs(bU.Tabs) do
				b_.Name = bU.Name .. " \u{203a} " .. b_.Title
			end
		end
		function bU:IsVisible()
			return bU._userVisible
		end
		function bU:SetVisible(bY)
			bY = bY and true or false
			if bY == bU._userVisible then
				return
			end
			bU._userVisible = bY
			if bU.Current then
				if not bY then
					bV(bU.Current)
				end
				bU.Current._userVisible = bY
			end
			bQ.Visible = bY
			bN._controlsDirty = true
		end
		if not bU._userVisible then
			bQ.Visible = false
		end
		function bU:Destroy()
			for bY = #bU.Tabs, 1, -1 do
				bU.Tabs[bY]:Destroy()
			end
			bO.Counts[bP] = math.max(bO.Counts[bP] - 1, 0)
			bU._destroyed = true
			bN._controlsDirty = true
			bQ:Destroy()
		end
		for bY, bZ in ipairs(bL.Tabs or {}) do
			bU:AddTab(bZ)
		end
		return bU
	end
	__Ixa_guiGroup.CreateTabbox = __Ixa_guiGroup.Tabbox
	__Ixa_guiGroup.AddTabbox = __Ixa_guiGroup.Tabbox
	function __Ixa_guiGroup:AddLeftTabbox(bL)
		bL = __Ixa_guiOptions(bL, { Title = "Name" })
		bL.Side = "Left"
		return self:Tabbox(bL)
	end
	function __Ixa_guiGroup:AddRightTabbox(bL)
		bL = __Ixa_guiOptions(bL, { Title = "Name" })
		bL.Side = "Right"
		return self:Tabbox(bL)
	end
	function __Ixa_guiGroup:ButtonRow(bL)
		local bM = type(bL) == "table" and (bL.Buttons or bL) or {}
		local bN = __Ixa_guiControlMetrics(self).Compact
		local bO = __Ixa_guiTouch and 34 or 30
		local bP = __Ixa_guiControlFrame(self, "Frame", bO + (bN and 4 or 14), {})
		local bQ = bN and 14 or 7
		local bR = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(bQ, bN and 2 or 7),
				Size = UDim2.new(1, -bQ * 2, 0, bO),
				BackgroundTransparency = 1,
				Parent = bP,
			}
		)
		local bS = math.max(#bM, 1)
		local bT = { Buttons = {} }
		local bU = {}
		for bV, bW in ipairs(bM) do
			if type(bW) == "string" then
				bW = { Name = bW }
			end
			local bX = bW.Name or bW.Title or "Button"
			table.insert(bU, bX)
			local bY, bZ = bF(
				bR,
				bX,
				{ Position = UDim2.new((bV - 1) / bS, (bV - 1) * 6 / bS, 0, 0), Size = UDim2.new(
					1 / bS,
					-6 * (bS - 1) / bS,
					1,
					0
				) },
				function()
					__Ixa_guiCall(bW.Callback)
				end
			)
			bZ.TextSize = 13
			if bW.Style == "Primary" then
				__Ixa_guiTween(bY, { BackgroundColor3 = __Ixa_guiTheme.Accent, BackgroundTransparency = 0.12 }, 0)
				__Ixa_guiTween(bZ, { TextColor3 = __Ixa_guiTheme.AccentDark }, 0)
			elseif bW.Style == "Danger" then
				__Ixa_guiTween(bZ, { TextColor3 = __Ixa_guiTheme.Error }, 0)
			end
			bT.Buttons[bV] = { Button = bY, Label = bZ }
		end
		function bT:SetText(bV, bW)
			local bX = bT.Buttons[bV]
			if bX then
				bX.Label.Text = tostring(bW)
			end
		end
		return __Ixa_guiRegister(
			self,
			{ Name = table.concat(bU, " "), Visible = not (type(bL) == "table" and bL.Visible == false) },
			bT,
			bP,
			"ButtonRow"
		)
	end
	local function bL(bM, bN, bO, bP)
		local bQ = __Ixa_guiTouch and 34 or 30
		local bR = __Ixa_guiControlFrame(bM, "Frame", bQ + 4, {})
		local bS = __Ixa_guiControlMetrics(bM).Compact and 14 or 7
		local bT
		local bU = bO
			and bF(
				bR,
				bO,
				{
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -bS, 0, 2),
					Size = UDim2.fromOffset(0, bQ),
					AutomaticSize = Enum.AutomaticSize.X,
				},
				function()
					__Ixa_guiCall(bP, bT.Text)
				end
			)
		local bV = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(bS, 2),
				Size = UDim2.new(1, -(bS * 2 + (bU and 70 or 0)), 0, bQ),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BorderSizePixel = 0,
				Parent = bR,
			}
		)
		__Ixa_guiCorner(bV, UDim.new(0, 6))
		local bW = __Ixa_guiStroke(bV)
		bT = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(8, 0),
				Size = UDim2.new(1, -16, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				PlaceholderText = bN,
				PlaceholderColor3 = __Ixa_guiTheme.Muted,
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ClearTextOnFocus = false,
				Parent = bV,
			}
		)
		bT.Focused:Connect(function()
			__Ixa_guiTween(bW, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
		end)
		bT.FocusLost:Connect(function(bX)
			__Ixa_guiTween(bW, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			if bX and bT.Text ~= "" then
				__Ixa_guiCall(bP, bT.Text)
			end
		end)
		if bU then
			local function bX()
				local bY = bU.AbsoluteSize.X / bM.Window.Scale.Scale
				bV.Size = UDim2.new(1, -(bS * 2 + bY + 6), 0, bQ)
			end
			bU:GetPropertyChangedSignal("AbsoluteSize"):Connect(bX)
			task.defer(bX)
		end
		return __Ixa_guiRegister(bM, { Name = bN }, {
			Get = function()
				return bT.Text
			end,
			Set = function(bX, bY)
				bT.Text = tostring(bY or "")
			end,
		}, bR, "ActionInput")
	end
	local function bM(bN)
		return (tostring(bN or ""):match("^%s*(.-)%s*$"))
	end
	local function bN(bO, bP, bQ, bR, bS, bT, bU)
		local bV = __Ixa_guiTouch and 30 or 24
		local bW = bV * (bR or 5) + 8
		local bX = __Ixa_guiControlFrame(bO, "Frame", bW + 4, {})
		local bY = __Ixa_guiControlMetrics(bO).Compact and 14 or 7
		local bZ = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(bY, 2),
				Size = UDim2.new(1, -bY * 2, 0, bW),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = bX,
			}
		)
		__Ixa_guiCorner(bZ, UDim.new(0, 6))
		__Ixa_guiStroke(bZ)
		local b_ = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Position = UDim2.fromOffset(4, 4),
				Size = UDim2.new(1, -8, 1, -8),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 3,
				ScrollBarImageColor3 = __Ixa_guiTheme.Stroke,
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				Parent = bZ,
			}
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = b_ })
		local b0 = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, bV),
			Text = "no configs yet",
			TextColor3 = __Ixa_guiTheme.Muted,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = bZ,
		})
		local b1, b2 = nil, {}
		local function b3(b4)
			for b5, b6 in pairs(b2) do
				local b7 = b5 == b1
				__Ixa_guiTween(b6.Button, { BackgroundTransparency = b7 and 0.82 or 1 }, b4 and 0 or 0.15)
				__Ixa_guiTween(b6.Label, { TextColor3 = b7 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Text }, b4 and 0 or 0.15)
				b6.Bar.Visible = b7
				local b8 = bS and bS(b5) or ""
				b6.Tags.Text = b8
				b6.Label.Size = UDim2.new(1, -(18 + b6.Tags.TextBounds.X + (b8 ~= "" and 6 or 0)), 1, 0)
			end
		end
		local function b4(b5)
			if b1 == b5 then
				return
			end
			b1 = b5
			b3()
			__Ixa_guiCall(bT, b5)
		end
		local b5 = {}
		function b5:Refresh(b6)
			for b7, b8 in pairs(b2) do
				b8.Button:Destroy()
			end
			b2 = {}
			for b7, b8 in ipairs(b6 or {}) do
				local b9 = __Ixa_guiNew(
					"TextButton",
					{
						Size = UDim2.new(1, -4, 0, bV),
						BackgroundColor3 = __Ixa_guiTheme.Accent,
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						LayoutOrder = b7,
						Parent = b_,
					}
				)
				__Ixa_guiCorner(b9, UDim.new(0, 4))
				local ca = __Ixa_guiNew(
					"Frame",
					{
						Position = UDim2.new(0, 0, 0.5, -6),
						Size = UDim2.fromOffset(2, 12),
						BackgroundColor3 = __Ixa_guiTheme.Accent,
						BorderSizePixel = 0,
						Visible = false,
						Parent = b9,
					}
				)
				local cb = __Ixa_guiLabel({
					Position = UDim2.fromOffset(10, 0),
					Size = UDim2.new(1, -18, 1, 0),
					Text = b8,
					TextSize = 13,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = b9,
				})
				local cc = __Ixa_guiLabel({
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -8, 0, 0),
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = b9,
				})
				local cd = 0
				b9.MouseButton1Click:Connect(function()
					if b1 == b8 and os.clock() - cd < 0.35 then
						cd = 0
						__Ixa_guiCall(bU, b8)
						return
					end
					cd = os.clock()
					b4(b8)
				end)
				b9.MouseEnter:Connect(function()
					if b1 ~= b8 then
						__Ixa_guiTween(b9, { BackgroundTransparency = 0.93 }, 0.1)
					end
				end)
				b9.MouseLeave:Connect(function()
					if b1 ~= b8 then
						__Ixa_guiTween(b9, { BackgroundTransparency = 1 }, 0.15)
					end
				end)
				b2[b8] = { Button = b9, Label = cb, Tags = cc, Bar = ca }
			end
			if b1 and not b2[b1] then
				b4(nil)
			end
			b0.Visible = next(b2) == nil
			b3(true)
		end
		function b5:Get()
			return b1
		end
		function b5:Set(b6)
			b4(b6 and b2[b6] and b6 or nil)
		end
		function b5:Repaint()
			b3(true)
		end
		b5:Refresh(bP)
		b5:Set(bQ)
		return __Ixa_guiRegister(bO, { Name = "Configs" }, b5, bX, "PickList")
	end
	local function bO(bP, bQ, bR, bS)
		if bP._groupbox then
			return bP
		end
		local bT = bP:Groupbox({ Name = bQ.Name or bR, Icon = bQ.Icon or bS, Side = bQ.Side })
		bT._manager = true
		return bT
	end
	function __Ixa_guiGroup:ConfigManager(bP)
		bP = __Ixa_guiOptions(bP, { Title = "Name" })
		local bQ = bO(self, bP, "Configs", "folder")
		local bR = self.Window
		local bS = {}
		local bT, bU, bV
		local function bW(bX, bY, bZ)
			bR:Notify({ Title = bY, Content = bZ, Type = bX and "Success" or "Error", Duration = 3 })
		end
		local bX
		local function bY()
			if not bU then
				return
			end
			local bZ = #bR:ListConfigs()
			bU:Set(
				("%d saved  \u{b7}  loaded: %s  \u{b7}  auto: %s"):format(
					bZ,
					bR.LoadedConfig or "none",
					bR:GetAutoload() or "none"
				)
			)
			bT:Repaint()
			if bX then
				local b_ = bT:Get()
				bX:Set(b_ ~= nil and bR:GetAutoload() == b_, true)
			end
		end
		local function bZ()
			local b_ = bT:Get()
			if not b_ then
				bW(false, "No config selected", "Pick one from the list first")
			end
			return b_
		end
		local b_ = bR:ListConfigs()
		local b0 = bR.LoadedConfig or bR:GetAutoload()
		local b1
		bT = bN(bQ, b_, table.find(b_, b0) and b0 or nil, bP.Rows, function(b2)
			local b3 = {}
			if b2 == bR.LoadedConfig then
				table.insert(b3, "loaded")
			end
			if b2 == bR:GetAutoload() then
				table.insert(b3, "auto")
			end
			return table.concat(b3, " \u{b7} ")
		end, function(b2)
			if b1 then
				b1:Set(b2 or "")
			end
			bY()
		end, function(b2)
			bS:Load(b2)
		end)
		bU = bQ:Label("0 saved")
		bQ:Label("Config Name:")
		b1 = bL(bQ, bP.Placeholder or "Type config name here...", nil, function(b2)
			bS:Create(b2)
		end)
		bQ:ButtonRow({ {
			Name = "Save",
			Callback = function()
				bS:Save()
			end,
		}, {
			Name = "Load",
			Callback = function()
				bS:Load()
			end,
		} })
		bQ:ButtonRow({
			{
				Name = "Delete",
				Style = "Danger",
				Callback = function()
					bS:Delete()
				end,
			},
			{
				Name = "Refresh",
				Callback = function()
					bS:Refresh()
				end,
			},
		})
		bX = bQ:Toggle({
			Name = "Auto Load Config",
			Callback = function(b2)
				local b3 = bT:Get()
				if not b3 then
					bW(false, "No config selected", "Pick one from the list first")
				elseif b2 ~= (bR:GetAutoload() == b3) then
					if b2 then
						bS:SetAutoload(b3)
					else
						bS:ClearAutoload()
					end
				end
				bY()
			end,
		})
		bQ:Divider({ Text = "more" })
		bQ:ButtonRow({
			{
				Name = "Rename",
				Callback = function()
					bS:Rename(nil, b1:Get())
				end,
			},
			{
				Name = "Reset",
				Style = "Danger",
				Callback = function()
					bS:Reset()
				end,
			},
		})
		bV = bQ:Dropdown({
			Name = "Autoload mode",
			Stacked = true,
			Options = { "All accounts", "This account" },
			Default = bR:GetAutoloadMode() == "Account" and "This account" or "All accounts",
			AllowNone = false,
			Callback = function(b2)
				bS:SetAutoloadMode(b2 == "This account" and "Account" or "Global")
			end,
		})
		bQ:Divider({ Text = "share" })
		bQ:Button({
			Name = "Copy code",
			Callback = function()
				bS:Export()
			end,
		})
		local b2 = bL(bQ, "paste a config code...", nil, function(b2)
			bS:Import(b2)
		end)
		bQ:Button({
			Name = "Import code",
			Callback = function()
				bS:Import(b2:Get())
			end,
		})
		function bS:Refresh()
			local b3 = bR:ListConfigs()
			local b4 = bT:Get()
			bT:Refresh(b3, true)
			if b4 and not table.find(b3, b4) then
				bT:Set(bR.LoadedConfig and table.find(b3, bR.LoadedConfig) and bR.LoadedConfig or nil, true)
			end
			bY()
		end
		local function b3(b4)
			bS:Refresh()
			bT:Set(b4, true)
		end
		function bS:Create(b4)
			b4 = bM(b4)
			if b4 == "" then
				bW(false, "Name the config", "Type a name before creating it")
				return
			end
			if not bi(b4) then
				bW(false, "Invalid name", 'Names cannot contain \\ / : * ? " < > |')
				return
			end
			local b5, b6 = bR:SaveConfig(b4)
			if b5 then
				bR.LoadedConfig = b4
				b1:Set("")
				b3(b4)
			end
			bW(b5, b5 and "Config created" or "Create failed", b5 and b4 or tostring(b6))
		end
		function bS:Save(b4)
			local b5 = bM(b1:Get())
			if not b4 and b5 ~= "" and b5 ~= bT:Get() then
				return bS:Create(b5)
			end
			b4 = b4 or bT:Get()
			if not b4 then
				local b6 = bM(b1:Get())
				if b6 == "" then
					bW(false, "No config selected", "Pick one from the list or type a name")
					return
				end
				return bS:Create(b6)
			end
			local b6, b7 = bR:SaveConfig(b4)
			if b6 then
				bR.LoadedConfig = b4
				bY()
			end
			bW(b6, b6 and "Config saved" or "Save failed", b6 and b4 or tostring(b7))
		end
		function bS:Load(b4)
			b4 = b4 or bZ()
			if not b4 then
				return
			end
			local b5, b6 = bR:LoadConfig(b4)
			bY()
			bW(b5, b5 and "Config loaded" or "Load failed", b5 and b4 or tostring(b6))
		end
		function bS:Delete(b4)
			b4 = b4 or bZ()
			if not b4 then
				return
			end
			bR:Confirm({
				Title = "Delete config",
				Content = "Remove " .. b4 .. "? This cannot be undone.",
				Icon = "trash-2",
				ConfirmText = "Delete",
				Callback = function()
					local b5, b6 = bR:DeleteConfig(b4)
					if b5 then
						if bR:GetAutoload("Account") == b4 then
							bR:SetAutoload(nil, "Account")
						end
						if bR:GetAutoload("Global") == b4 then
							bR:SetAutoload(nil, "Global")
						end
						bT:Set(nil, true)
					end
					bS:Refresh()
					bW(b5, b5 and "Config deleted" or "Delete failed", b5 and b4 or tostring(b6))
				end,
			})
		end
		function bS:Rename(b4, b5)
			b4 = b4 or bZ()
			if not b4 then
				return
			end
			b5 = bM(b5)
			if b5 == "" then
				bW(false, "Name the config", "Type the new name in the name box")
				return
			end
			if not bi(b5) then
				bW(false, "Invalid name", 'Names cannot contain \\ / : * ? " < > |')
				return
			end
			local b6, b7 = bR:RenameConfig(b4, b5)
			if b6 then
				b1:Set("")
				b3(b5)
			end
			bW(b6, b6 and "Config renamed" or "Rename failed", b6 and (b4 .. " -> " .. b5) or tostring(b7))
		end
		function bS:Reset()
			bR:Confirm({
				Title = "Reset settings",
				Content = [[Put every setting back to its default and delete this script's folder? Saved configs, themes and autoload are removed for good.]],
				Icon = "rotate-ccw",
				ConfirmText = "Reset",
				Callback = function()
					bR:ResetConfig()
					local b4 = bR:ClearWorkspace()
					bR:_applyDefaultTheme()
					bT:Set(nil, true)
					bS:Refresh()
					bV:Set("All accounts", true)
					bW(
						b4,
						b4 and "Settings reset" or "Reset incomplete",
						b4 and "Everything is back to its default"
							or "Some files in " .. bR.ConfigFolder .. " could not be deleted"
					)
				end,
			})
		end
		function bS:SetAutoload(b4)
			b4 = b4 or bZ()
			if not b4 then
				return
			end
			local b5, b6 = bR:SetAutoload(b4)
			bY()
			bW(b5, b5 and "Autoload set" or "Autoload failed", b5 and b4 or tostring(b6))
		end
		function bS:ClearAutoload()
			local b4 = bR:GetAutoload()
			if not b4 then
				bW(false, "No autoload", "Nothing is set to autoload")
				return
			end
			local b5, b6 = bR:SetAutoload(nil)
			bY()
			bW(b5, b5 and "Autoload cleared" or "Clear failed", b5 and b4 or tostring(b6))
		end
		function bS:ToggleAutoload(b4)
			b4 = b4 or bZ()
			if not b4 then
				return
			end
			if bR:GetAutoload() == b4 then
				bS:ClearAutoload()
			else
				bS:SetAutoload(b4)
			end
		end
		function bS:SetAutoloadMode(b4)
			local b5, b6 = bR:SetAutoloadMode(b4)
			local b7 = b4 == "Account" and "This account" or "All accounts"
			if bV:Get() ~= b7 then
				bV:Set(b7, true)
			end
			bW(b5 ~= false, b5 ~= false and "Autoload mode" or "Mode change failed", b5 ~= false and b7 or tostring(b6))
		end
		function bS:Export(b4)
			local b5, b6 = bR:ExportConfig(b4)
			if not b5 then
				bW(false, "Export failed", tostring(b6))
				return nil
			end
			bR:CopyToClipboard(b5, "Config code")
			return b5
		end
		function bS:Import(b4)
			b4 = bM(b4)
			if b4 == "" then
				bW(false, "Nothing to import", "Paste a config code first")
				return
			end
			local b5, b6 = bR:DecodeConfig(b4)
			if not b5 then
				bW(false, "Import failed", "Invalid config code")
				return
			end
			local b7 = bM(b1:Get())
			if b7 == "" then
				b7 = nil
				if bi(b6.Name) then
					b7 = b6.Name
					local b8 = 2
					while bR:ConfigExists(b7) do
						b7 = ("%s (%d)"):format(b6.Name, b8)
						b8 += 1
					end
				end
			elseif not bi(b7) then
				bW(false, "Invalid name", 'Names cannot contain \\ / : * ? " < > |')
				return
			end
			local function b8()
				local b9, ca = bR:ImportConfig(b4, b7, true)
				if b9 then
					b2:Set("")
					if b7 then
						b1:Set("")
						b3(b7)
					end
				end
				bW(
					b9,
					b9 and "Config imported" or "Import failed",
					b9 and (b7 or "Applied to current settings") or tostring(ca)
				)
			end
			if b6.Folder and b6.Folder ~= bR.ConfigFolder then
				bR:Confirm({
					Title = "Different script",
					Content = ([[This config was made for %s. Import it anyway? Only matching settings are applied.]]):format(
						b6.Folder
					),
					Icon = "triangle-alert",
					ConfirmText = "Import",
					Callback = b8,
				})
				return
			end
			b8()
		end
		local b4 = bR:OnConfigChanged(function()
			bS:Refresh()
			if bR.LoadedConfig and bT:Get() == nil then
				bT:Set(bR.LoadedConfig, true)
			end
		end)
		bU._listeners = bU._listeners or {}
		table.insert(bU._listeners, b4)
		bY()
		return bS
	end
	local bP = {
		"Midnight",
		"Nebula",
		"Synthwave",
		"Sakura",
		"Velvet",
		"Rose",
		"Crimson",
		"Sunset",
		"Amber",
		"Gold",
		"Cyber",
		"Toxic",
		"Matcha",
		"Emerald",
		"Aurora",
		"Ocean",
		"Frost",
		"Abyss",
		"Mono",
		"Halloween",
		"Haunted",
		"Christmas",
		"Valentine",
		"Lunar",
		"Tropical",
		"Dracula",
		"Coffee",
	}
	local function bQ()
		local bR, bS = {}, {}
		for bT, bU in ipairs(bP) do
			if __Ixa_guiLibrary.ThemePresets[bU] then
				table.insert(bR, bU)
				bS[bU] = true
			end
		end
		local bT = {}
		for bU in pairs(__Ixa_guiLibrary.ThemePresets) do
			if not bS[bU] then
				table.insert(bT, bU)
			end
		end
		table.sort(bT)
		for bU, bV in ipairs(bT) do
			table.insert(bR, bV)
		end
		return bR
	end
	function __Ixa_guiGroup:ThemeManager(bR)
		bR = __Ixa_guiOptions(bR, { Title = "Name" })
		local bS = bO(self, bR, "Themes", "palette")
		local bT = self.Window
		local bU = {}
		local bV, bW, bX, bY
		local bZ, b_, b0, b1, b2, b3
		local b4, b5, b6, b7
		local b8, b9, ca, cb
		local function cc(cd, ce, cf)
			bT:Notify({ Title = ce, Content = cf, Type = cd and "Success" or "Error", Duration = 3 })
		end
		local function cd()
			local ce = bT:GetDefaultTheme()
			bW:Set("Default theme: " .. (ce or "none"))
			local cf = bV:Get() or bY:Get()
			bX:SetText(2, (cf and cf == ce) and "Clear Default" or "Set Default")
		end
		local function ce()
			local cf = bV:Get()
			if not cf then
				cc(false, "No theme selected", "Pick one from the list first")
			end
			return cf
		end
		bY = bS:Dropdown({
			Name = "Preset",
			Options = bQ(),
			Default = __Ixa_guiLibrary.ThemePresets[__Ixa_guiLibrary.ThemeName or ""] and __Ixa_guiLibrary.ThemeName or nil,
			NoneText = "custom",
			AllowNone = false,
			Callback = function(cf)
				if cf then
					__Ixa_guiLibrary:SetTheme(cf)
					bV:Set(nil, true)
					cd()
				end
			end,
		})
		local cf = bS
		if not self._groupbox and bR.Menu ~= false then
			cf = self:Groupbox({ Name = bR.MenuName or "Menu", Icon = bR.MenuIcon or "monitor", Side = bR.MenuSide
				or bR.Side })
			cf._manager = true
		end
		local cg = {
			None = "None",
			Snow = "Snow",
			Rain = "Rain",
			Ember = "Hell Fire",
			Sakura = "Sakura",
			Fireflies = "Fireflies",
			Matrix = "Matrix",
		}
		if bT._backdrop and bR.Weather ~= false then
			bZ = cf:Dropdown({
				Name = "Weather",
				Options = { "Snow", "Rain", "Hell Fire", "Sakura", "Fireflies", "Matrix", "None" },
				Default = cg[bT.Weather] or "None",
				AllowNone = false,
				Callback = function(ch)
					if ch then
						bT:SetWeather(ch)
					end
				end,
			})
		end
		if bT._backdrop and bR.Weather ~= false then
			b_ = cf:Dropdown({
				Name = "Weather Mode",
				Options = { "Screen", "UI" },
				Default = bT.WeatherMode,
				AllowNone = false,
				Callback = function(ch)
					if ch then
						bT:SetWeatherMode(ch)
					end
				end,
			})
		end
		if bT._backdrop and bR.Dim ~= false then
			b0 = cf:Toggle({
				Name = "Dim",
				Default = bT._backdropDim,
				Callback = function(ch)
					bT:SetDim(ch)
				end,
			})
		end
		if bR.Transparent ~= false then
			b1 = cf:Toggle({
				Name = "Transparent",
				Default = bT.Transparent == true,
				Callback = function(ch)
					bT:SetTransparent(ch)
				end,
			})
		end
		if bR.DragSkeleton ~= false and bR.DragStyle ~= false then
			b2 = cf:Dropdown({
				Name = "Drag Style",
				Options = __Ixa_guiLibrary.DragStyles,
				Default = bT.DragStyle,
				AllowNone = false,
				Callback = function(ch)
					if ch then
						bT:SetDragStyle(ch)
					end
				end,
			})
		end
		if bR.IslandStyle ~= false then
			b3 = cf:Dropdown({
				Name = "Dynamic Island",
				Options = __Ixa_guiLibrary.IslandStyles,
				Default = bT.IslandStyle,
				AllowNone = false,
				Callback = function(ch)
					if ch then
						bT:SetIslandStyle(ch)
					end
				end,
			})
		end
		if bR.AdaptiveSize ~= false then
			ca = cf:Toggle({
				Name = "Adaptive Size",
				Default = bT:GetAdaptiveSize(),
				Callback = function(ch)
					bT:SetAdaptiveSize(ch)
				end,
			})
		end
		if bR.Scale ~= false then
			b8 = cf:Slider({
				Name = "UI Scale",
				Min = 60,
				Max = 150,
				Increment = 5,
				Default = math.floor(bT:GetUIScale() * 100 + 0.5),
				Suffix = "%",
				Callback = function(ch)
					if not (b8 and b8.Dragging) then
						bT:SetUIScale(ch / 100)
					end
				end,
				OnRelease = function(ch)
					bT:SetUIScale(ch / 100)
				end,
			})
		end
		if bR.Density ~= false then
			b9 = cf:Dropdown({
				Name = "Density",
				Options = { "Compact", "Default", "Comfortable" },
				Default = __Ixa_guiLibrary.Density,
				AllowNone = false,
				Callback = function(ch)
					if ch then
						__Ixa_guiLibrary:SetDensity(ch)
					end
				end,
			})
		end
		if bR.CornerRadius ~= false then
			cb = cf:Slider({
				Name = "Corner Radius",
				Min = 0,
				Max = 20,
				Increment = 1,
				Default = __Ixa_guiLibrary:GetCornerRadius(),
				Suffix = "px",
				Callback = function(ch)
					__Ixa_guiLibrary:SetCornerRadius(ch)
				end,
			})
		end
		if bR.Background ~= false then
			b7 = function(ch)
				if ch == nil or ch == "" then
					return "None"
				end
				return table.find(bT:ListBackgrounds(), ch) and ch or nil
			end
			local function ch(ci, cj)
				task.spawn(function()
					local ck, cl = bT:SetBackground(ci)
					if ck and not cj then
						b4:Set(b7(bT.Background), true)
					elseif not ck and cl ~= "replaced by a newer background" then
						cc(false, "Background failed", tostring(cl))
					end
				end)
			end
			local ci = bT:ListBackgrounds()
			table.insert(ci, 1, "None")
			b4 = cf:Dropdown({
				Name = "Background",
				Options = ci,
				Default = b7(bT.Background),
				NoneText = "custom",
				AllowNone = false,
				Callback = function(cj)
					if cj then
						ch(cj, true)
					end
				end,
			})
			b5 = bL(cf, "image id or url", "Set", function(cj)
				cj = bM(cj)
				if cj == "" then
					cc(false, "No image", "Paste an image id or link first")
					return
				end
				ch(cj)
			end)
			b6 = cf:Slider({
				Name = "Background Opacity",
				Min = 0,
				Max = 100,
				Default = math.floor((1 - bT.BackgroundTransparency) * 100 + 0.5),
				Suffix = "%",
				Callback = function(cj)
					bT:SetBackgroundTransparency(1 - cj / 100)
				end,
			})
		end
		local ch = bL(bS, bR.Placeholder or "theme name", "Create", function(ch)
			bU:Create(ch)
		end)
		bV = bS:Dropdown({
			Name = "Theme",
			Options = bT:ListThemes(),
			Default = (function()
				local ci = bT:GetDefaultTheme()
				return ci and not __Ixa_guiLibrary.ThemePresets[ci] and ci or nil
			end)(),
			EmptyText = "no themes",
			NoneText = "select",
			Callback = function()
				cd()
			end,
		})
		bS:ButtonRow({ {
			Name = "Save",
			Callback = function()
				bU:Save()
			end,
		}, {
			Name = "Load",
			Callback = function()
				bU:Load()
			end,
		} })
		bX = bS:ButtonRow({
			{
				Name = "Delete",
				Callback = function()
					bU:Delete()
				end,
			},
			{
				Name = "Set Default",
				Callback = function()
					bU:ToggleDefault()
				end,
			},
		})
		bW = bS:Label("Default theme: none")
		function bU:Refresh()
			bV:Refresh(bT:ListThemes(), true)
			if b4 then
				local ci = bT:ListBackgrounds()
				table.insert(ci, 1, "None")
				b4:Refresh(ci, true, true)
			end
			cd()
		end
		function bU:Create(ci)
			ci = bM(ci)
			if ci == "" then
				cc(false, "Name the theme", "Type a name before creating it")
				return
			end
			if __Ixa_guiLibrary.ThemePresets[ci] then
				cc(false, "Name taken", ci .. " is a built-in preset")
				return
			end
			local cj, ck = bT:SaveTheme(ci)
			bU:Refresh()
			if cj then
				bV:Set(ci, true)
				ch:Set("")
				cd()
			end
			cc(cj, cj and "Theme created" or "Create failed", cj and ci or tostring(ck))
		end
		function bU:Save(ci)
			ci = ci or ce()
			if not ci then
				return
			end
			local cj, ck = bT:SaveTheme(ci)
			cc(cj, cj and "Theme saved" or "Save failed", cj and ci or tostring(ck))
		end
		function bU:Load(ci)
			ci = ci or ce()
			if not ci then
				return
			end
			local cj, ck = bT:LoadTheme(ci)
			if cj then
				bY:Set(nil, true)
			end
			cc(cj ~= false, cj and "Theme loaded" or "Load failed", cj and ci or tostring(ck))
		end
		function bU:Delete(ci)
			ci = ci or ce()
			if not ci then
				return
			end
			bT:Confirm({
				Title = "Delete theme",
				Content = "Remove " .. ci .. "? This cannot be undone.",
				Icon = "trash-2",
				ConfirmText = "Delete",
				Callback = function()
					local cj, ck = bT:DeleteTheme(ci)
					bU:Refresh()
					cc(cj, cj and "Theme deleted" or "Delete failed", cj and ci or tostring(ck))
				end,
			})
		end
		function bU:ToggleDefault(ci)
			ci = ci or bV:Get() or bY:Get()
			if not ci then
				cc(false, "Nothing selected", "Pick a theme or a preset first")
				return
			end
			local cj = bT:GetDefaultTheme() == ci
			local ck, cl = bT:SetDefaultTheme(not cj and ci or nil)
			cd()
			cc(ck ~= false, cj and "Default cleared" or "Default theme set", ck ~= false and ci or tostring(cl))
		end
		if bR.Customize ~= false then
			bS:Divider()
			local ci = bR.Colors
				or {
					{ "Accent", "Accent" },
					{ "Background", "Background" },
					{ "Surface2", "Surface" },
					{ "Text", "Text" },
					{ "Muted", "Muted text" },
				}
			for cj, ck in ipairs(ci) do
				local cl, cm = ck[1], ck[2] or ck[1]
				local cn, co = nil, false
				local cp
				cp = bS:ColorPicker({
					Name = cm,
					Default = __Ixa_guiTheme[cl],
					Callback = function(cq)
						cn = cq
						if co then
							return
						end
						co = true
						task.delay(0.08, function()
							co = false
							__Ixa_guiLibrary:SetTheme({ [cl] = cn }, true)
							bY:Set(nil, true)
						end)
					end,
				})
				table.insert(__Ixa_guiLibrary._themeListeners, function()
					if cp.Value ~= __Ixa_guiTheme[cl] then
						cp:Set(__Ixa_guiTheme[cl], true)
					end
				end)
			end
		end
		if bR.Flag ~= false then
			local ci = type(bR.Flag) == "string" and bR.Flag or "__Theme"
			local cj = { _type = "Theme", _searchName = "Theme", _searchKey = "theme", _listeners = {} }
			function cj:Get()
				local ck = {}
				for cl, cm in ipairs(__Ixa_guiThemeKeys) do
					ck[cm] = bc(__Ixa_guiTheme[cm])
				end
				return {
					Name = bY:Get() or bV:Get(),
					Colors = ck,
					Weather = bZ and bT.Weather or nil,
					WeatherMode = b_ and bT.WeatherMode or nil,
					Dim = if b0 then bT._backdropDim == true else nil,
					Transparent = if b1 then bT.Transparent == true else nil,
					DragStyle = b2 and bT.DragStyle or nil,
					IslandStyle = b3 and bT.IslandStyle or nil,
					CornerRadius = cb and __Ixa_guiLibrary:GetCornerRadius() or nil,
					UIScale = b8 and bT:GetUIScale() or nil,
					AdaptiveSize = if ca then bT:GetAdaptiveSize() else nil,
					Density = b9 and __Ixa_guiLibrary.Density or nil,
					Background = b4 and (bT.Background or "") or nil,
					BackgroundTransparency = b4 and bT.BackgroundTransparency or nil,
				}
			end
			function cj:Set(ck)
				if type(ck) ~= "table" then
					return
				end
				if type(ck.Colors) == "table" then
					__Ixa_guiLibrary:SetTheme(ck.Colors)
				end
				local cl = type(ck.Name) == "string" and ck.Name or nil
				if cl and __Ixa_guiLibrary.ThemePresets[cl] then
					__Ixa_guiLibrary.ThemeName = cl
					bY:Set(cl, true)
					bV:Set(nil, true)
				else
					if cl then
						__Ixa_guiLibrary.ThemeName = cl
					end
					bY:Set(nil, true)
					bV:Set(cl and table.find(bT:ListThemes(), cl) and cl or nil, true)
				end
				if bZ and type(ck.Weather) == "string" then
					bT:SetWeather(ck.Weather)
					bZ:Set(cg[bT.Weather] or "None", true)
				end
				if b_ and type(ck.WeatherMode) == "string" then
					bT:SetWeatherMode(ck.WeatherMode)
					b_:Set(bT.WeatherMode, true)
				end
				if b0 and type(ck.Dim) == "boolean" then
					bT:SetDim(ck.Dim)
					b0:Set(ck.Dim, true)
				end
				if b1 and type(ck.Transparent) == "boolean" then
					bT:SetTransparent(ck.Transparent)
					b1:Set(ck.Transparent, true)
				end
				if b2 and type(ck.DragStyle) == "string" then
					b2:Set(bT:SetDragStyle(ck.DragStyle), true)
				elseif b2 and type(ck.DragSkeleton) == "boolean" then
					bT:SetDragSkeleton(ck.DragSkeleton)
					b2:Set(bT.DragStyle, true)
				end
				if b3 and type(ck.IslandStyle) == "string" then
					b3:Set(bT:SetIslandStyle(ck.IslandStyle), true)
				end
				if cb and tonumber(ck.CornerRadius) then
					cb:Set(__Ixa_guiLibrary:SetCornerRadius(ck.CornerRadius), true)
				end
				if ca and type(ck.AdaptiveSize) == "boolean" then
					bT:SetAdaptiveSize(ck.AdaptiveSize)
					ca:Set(ck.AdaptiveSize, true)
				end
				if b8 and tonumber(ck.UIScale) then
					bT:SetUIScale(tonumber(ck.UIScale))
					b8:Set(math.floor(bT:GetUIScale() * 100 + 0.5), true)
				end
				if b9 and type(ck.Density) == "string" then
					b9:Set(__Ixa_guiLibrary:SetDensity(ck.Density), true)
				end
				if b4 and tonumber(ck.BackgroundTransparency) then
					bT:SetBackgroundTransparency(tonumber(ck.BackgroundTransparency))
					b6:Set(math.floor((1 - bT.BackgroundTransparency) * 100 + 0.5), true)
				end
				if b4 and type(ck.Background) == "string" and ck.Background ~= (bT.Background or "") then
					local cm = ck.Background
					b4:Set(b7(cm), true)
					task.spawn(bT.SetBackground, bT, cm)
				end
				cd()
			end
			__Ixa_guiLibrary.Flags[ci] = cj
			bT:_flagCreated(ci, cj)
		end
		bT._workspaceListeners = bT._workspaceListeners or {}
		table.insert(bT._workspaceListeners, function()
			bV:Set(nil, true)
			bU:Refresh()
		end)
		cd()
		return bU
	end
	__Ixa_guiGroup.CreateButtonRow = __Ixa_guiGroup.ButtonRow
	__Ixa_guiGroup.CreateConfigManager = __Ixa_guiGroup.ConfigManager
	__Ixa_guiGroup.CreateThemeManager = __Ixa_guiGroup.ThemeManager
	local bR = { Plain = 18, Row = 20, Badge = 24, Dot = 20, Bar = 34, Stat = 44 }
	local function bS(bT)
		return __Ixa_guiLibrary._color(bT) or __Ixa_guiTheme.Accent
	end
	local function bT(bU)
		if bU == math.floor(bU) then
			return tostring(math.floor(bU))
		end
		return string.format("%.1f", bU)
	end
	local function bU(bV, bW)
		if type(bV) == "number" and type(bW) == "number" then
			return bV, bW
		end
		if type(bV) == "string" then
			local bX = (bV:gsub(",", ""))
			local bY, bZ = bX:match("^%s*(%-?[%d%.]+)%s*/%s*(%-?[%d%.]+)")
			if bY then
				return tonumber(bY), tonumber(bZ)
			end
		end
		return nil, nil
	end
	function __Ixa_guiGroup:Status(bV)
		bV = __Ixa_guiOptions(bV, { Title = "Name", Text = "Value", Content = "Value", CurrentValue = "Value", Default = "Value" })
		local bW = bR[bV.Style] and bV.Style or "Plain"
		local bX = __Ixa_guiControlMetrics(self).Compact
		local bY = self.Window
		local bZ = bR[bW]
		local b_ = 1
		local b0, b1 = __Ixa_guiControlFrame(self, "Frame", bZ + b_ * 2, bV)
		b0.BackgroundTransparency = 1
		b1.Transparency = 1
		b1:SetAttribute("Hidden", true)
		local b2 = bX and 14 or 2
		local b3 = __Ixa_guiNew(
			"Frame",
			{ Position = UDim2.fromOffset(b2, b_), Size = UDim2.new(1, -b2 * 2, 0, bZ), BackgroundTransparency = 1, Parent = b0 }
		)
		local b4 =
			{ Value = bV.Value, Max = bV.Max, Tone = bV.Tone or "Accent", Name = bV.Name or "", Color = bV.Color
				or bV.ValueColor }
		local b5, b6, b7, b8, b9, ca, cb
		local cc = false
		local function cd()
			return bW == "Plain" and (b4.Name .. ":") or b4.Name
		end
		if bW == "Plain" then
			b0.AutomaticSize = Enum.AutomaticSize.Y
			b3.AutomaticSize = Enum.AutomaticSize.Y
			b5 = __Ixa_guiLabel({
				Size = UDim2.new(0, 0, 0, bZ),
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 14,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Text,
				TextTransparency = 0.4,
				TextTruncate = Enum.TextTruncate.None,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = b3,
			})
			b6 = __Ixa_guiLabel({
				TextSize = 14,
				TextColor3 = __Ixa_guiTheme.Text,
				TextTruncate = Enum.TextTruncate.None,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = b3,
			})
			local ce = bV.Wrap ~= false
			local function cf()
				local cg = b5.TextBounds.X + 5
				b6.Position = UDim2.fromOffset(cg, 0)
				if ce then
					b6.Size = UDim2.new(1, -cg, 0, bZ)
					b6.AutomaticSize = Enum.AutomaticSize.Y
				else
					b6.Size = UDim2.new(0, 0, 0, bZ)
					b6.AutomaticSize = Enum.AutomaticSize.X
				end
				b6.TextWrapped = ce
			end
			b5:GetPropertyChangedSignal("TextBounds"):Connect(cf)
			cf()
			function b4:SetWrap(cg)
				ce = cg ~= false
				cf()
			end
		elseif bW == "Stat" then
			b5 = __Ixa_guiLabel({
				Position = UDim2.fromOffset(0, 1),
				Size = UDim2.new(1, 0, 0, 16),
				TextSize = 13,
				TextColor3 = __Ixa_guiTheme.Text,
				TextTransparency = 0.4,
				Parent = b3,
			})
			b6 = __Ixa_guiLabel({
				Position = UDim2.fromOffset(0, 18),
				Size = UDim2.new(1, 0, 0, 24),
				TextSize = 20,
				FontFace = __Ixa_guiFonts.Bold,
				TextColor3 = __Ixa_guiTheme.Text,
				Parent = b3,
			})
		else
			local ce = 0
			if bW == "Dot" then
				ce = 18
				ca = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0, 5, 0.5, 0),
						Size = UDim2.fromOffset(8, 8),
						BackgroundColor3 = bS(b4.Tone),
						BackgroundTransparency = 0.4,
						BorderSizePixel = 0,
						Parent = b3,
					}
				)
				__Ixa_guiCorner(ca, UDim.new(1, 0))
				b9 = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0, 5, 0.5, 0),
						Size = UDim2.fromOffset(8, 8),
						BackgroundColor3 = bS(b4.Tone),
						BorderSizePixel = 0,
						Parent = b3,
					}
				)
				__Ixa_guiCorner(b9, UDim.new(1, 0))
				if bV.Pulse ~= false then
					__Ixa_guiTweenService:Create(
						ca,
						TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1),
						{ Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1 }
					):Play()
				else
					ca.Visible = false
				end
			end
			local cf = bW == "Bar" and 18 or bZ
			b5 = __Ixa_guiLabel({
				Position = UDim2.fromOffset(ce, 0),
				Size = UDim2.new(0.55, -ce, 0, cf),
				TextSize = 14,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Text,
				TextTransparency = 0.4,
				Parent = b3,
			})
			if bW == "Badge" then
				cc = true
				b7 = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, 0, 0.5, 0),
						Size = UDim2.fromOffset(0, 20),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = bS(b4.Tone),
						BackgroundTransparency = 0.86,
						BorderSizePixel = 0,
						Parent = b3,
					}
				)
				__Ixa_guiCorner(b7, UDim.new(1, 0))
				b8 = __Ixa_guiStroke(b7, bS(b4.Tone), 0.6)
				__Ixa_guiPadding(b7, 10, 10)
				b6 = __Ixa_guiLabel({
					Size = UDim2.new(0, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 14,
					TextColor3 = bS(b4.Tone),
					TextTruncate = Enum.TextTruncate.None,
					Parent = b7,
				})
			else
				b6 = __Ixa_guiLabel({
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.new(0.45, 0, 0, cf),
					TextSize = 14,
					TextColor3 = __Ixa_guiTheme.Text,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = b3,
				})
			end
			if bW == "Bar" then
				local cg = __Ixa_guiNew(
					"Frame",
					{
						Position = UDim2.fromOffset(0, 24),
						Size = UDim2.new(1, 0, 0, 5),
						BackgroundColor3 = __Ixa_guiTheme.Surface3,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Parent = b3,
					}
				)
				__Ixa_guiCorner(cg, UDim.new(1, 0))
				cb = __Ixa_guiNew(
					"Frame",
					{ Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = bS(b4.Tone), BorderSizePixel = 0, Parent = cg }
				)
				__Ixa_guiCorner(cb, UDim.new(1, 0))
			end
		end
		local ce = nil
		local function cf(cg)
			b5.Text = __Ixa_guiLibrary._rich(cd())
			local ch = b4.Value
			local ci = ch == nil and (bV.Placeholder or "-") or tostring(ch)
			if bW == "Bar" then
				local cj, ck = bU(ch, b4.Max)
				if cj and ck then
					b4.Max = ck
					ci = bT(cj) .. " / " .. bT(ck)
					local cl = ck > 0 and math.clamp(cj / ck, 0, 1) or 0
					__Ixa_guiTween(cb, { Size = UDim2.new(cl, 0, 1, 0) }, cg and 0.4 or 0, Enum.EasingStyle.Quint)
				elseif type(ch) == "number" and ch <= 1 then
					ci = string.format("%d%%", math.floor(ch * 100 + 0.5))
					__Ixa_guiTween(cb, { Size = UDim2.new(math.clamp(ch, 0, 1), 0, 1, 0) }, cg and 0.4 or 0, Enum.EasingStyle.Quint)
				end
			end
			ci = __Ixa_guiLibrary._rich((bV.Prefix or "") .. ci .. (bV.Suffix or ""))
			local cj = ce ~= nil and ci ~= ce
			ce = ci
			b6.Text = ci
			local ck = bS(b4.Tone)
			local cl = cg and 0.25 or 0
			local cm = not cc and __Ixa_guiLibrary._color(b4.Color) or __Ixa_guiTheme.Text
			if not cc and not (cj and cg and bV.Flash ~= false) then
				__Ixa_guiTween(b6, { TextColor3 = cm }, cl)
			end
			if b7 then
				__Ixa_guiTween(b7, { BackgroundColor3 = ck }, cl)
				__Ixa_guiTween(b8, { Color = ck }, cl)
				__Ixa_guiTween(b6, { TextColor3 = ck }, cl)
			end
			if b9 then
				__Ixa_guiTween(b9, { BackgroundColor3 = ck }, cl)
				__Ixa_guiTween(ca, { BackgroundColor3 = ck }, 0)
			end
			if cb then
				__Ixa_guiTween(cb, { BackgroundColor3 = ck }, cl)
			end
			if cj and cg and not cc and bV.Flash ~= false then
				__Ixa_guiTween(b6, { TextColor3 = __Ixa_guiTheme.Accent }, 0.08)
				task.delay(0.1, function()
					if b6.Parent then
						__Ixa_guiTween(b6, { TextColor3 = __Ixa_guiLibrary._color(b4.Color) or __Ixa_guiTheme.Text }, 0.45)
					end
				end)
			end
		end
		b5.RichText = true
		b6.RichText = true
		__Ixa_guiBindTheme(b3, function()
			if ce ~= nil then
				cf(false)
			end
		end)
		function b4:Set(cg, ch)
			b4.Value = cg
			if ch ~= nil then
				b4.Max = ch
			end
			cf(true)
		end
		function b4:Get()
			return b4.Value
		end
		function b4:SetTone(cg)
			b4.Tone = cg
			cf(true)
		end
		function b4:SetColor(cg)
			b4.Color = cg
			cf(true)
		end
		function b4:SetName(cg)
			b4.Name = tostring(cg)
			cf(false)
		end
		function b4:Text()
			return b6.Text
		end
		function b4._shownColor()
			if b4.Color ~= nil then
				return __Ixa_guiLibrary._color(b4.Color) or __Ixa_guiTheme.Text
			end
			if bW == "Badge" or bW == "Dot" or bW == "Bar" then
				return bS(b4.Tone)
			end
			return __Ixa_guiTheme.Text
		end
		b4._listeners = {}
		if type(bV.Update) == "function" then
			local cg = math.max(tonumber(bV.UpdateRate) or 1, 0.05)
			local ch = true
			table.insert(b4._listeners, function()
				ch = false
			end)
			task.spawn(function()
				while ch and b0.Parent do
					local ci, cj, ck = __Ixa_guiYieldCall(bV.Update)
					if ci then
						if cj ~= nil then
							b4.Value = cj
						end
						if type(ck) == "number" then
							b4.Max = ck
						elseif type(ck) == "string" or typeof(ck) == "Color3" then
							b4.Tone = ck
						end
						cf(true)
					else
						warn("[AirFlow] status update error: " .. tostring(cj))
					end
					task.wait(cg)
				end
			end)
			function b4:SetUpdateRate(ci)
				cg = math.max(tonumber(ci) or cg, 0.05)
			end
		end
		if bV.Pin then
			table.insert(bY._pinned, b4)
			table.insert(b4._listeners, function()
				local cg = table.find(bY._pinned, b4)
				if cg then
					table.remove(bY._pinned, cg)
				end
			end)
		end
		cf(false)
		return __Ixa_guiRegister(self, bV, b4, b0, "Status")
	end
	function __Ixa_guiGroup:Statuses(bV, bW)
		local bX = {}
		for bY, bZ in ipairs(bV or {}) do
			local b_ = type(bZ) == "table" and table.clone(bZ) or { Name = tostring(bZ) }
			for b0, b1 in pairs(bW or {}) do
				if b_[b0] == nil then
					b_[b0] = b1
				end
			end
			local b0 = self:Status(b_)
			bX[b_.Name or b_.Title or bY] = b0
		end
		return bX
	end
	function __Ixa_guiGroup:StatusList(bV)
		bV = __Ixa_guiOptions(bV, { Title = "Name" })
		local bW = __Ixa_guiControlMetrics(self).Compact
		local bX = self.Window
		local bY = math.max(math.floor(tonumber(bV.MaxRows) or 5), 1)
		local bZ = __Ixa_guiControlFrame(self, "Frame", 0, bV)
		bZ.AutomaticSize = Enum.AutomaticSize.Y
		if bW then
			__Ixa_guiPadding(bZ, 14, 14, 6, 8)
		else
			__Ixa_guiPadding(bZ, 14, 14, 11, 12)
		end
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = bZ })
		local b_ = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 16),
			Text = string.upper(tostring(bV.Name or "")),
			TextSize = 12,
			TextColor3 = __Ixa_guiTheme.Muted,
			Visible = tostring(bV.Name or "") ~= "",
			LayoutOrder = 1,
			Parent = bZ,
		})
		local b0 = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0.4,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				ScrollingEnabled = false,
				LayoutOrder = 2,
				Parent = bZ,
			}
		)
		b0:SetAttribute("NoDrag", true)
		local b1 = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = b0 }
		)
		local b2 = __Ixa_guiPadding(b1, 0, 0, 0, 0)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = b1 })
		local b3 = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 24),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = tostring(bV.EmptyText or "Nothing yet"),
			TextSize = 13,
			LineHeight = 1.1,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 0,
			Parent = b1,
		})
		local b4, b5, b6, b7 = {}, {}, nil, {}
		local b8 = { _listeners = {} }
		local function b9()
			if b8._destroyed then
				return
			end
			local ca = bX.Scale.Scale
			local cb = #b5
			local cc = 0
			if cb == 0 then
				cc = b3.AbsoluteSize.Y / ca
			else
				local cd = math.min(cb, bY)
				for ce = 1, cd do
					cc += b4[ce].Frame.AbsoluteSize.Y / ca
				end
				cc += (cd - 1) * 2
			end
			cc = math.ceil(cc)
			local cd = cb > bY
			b0.ScrollingEnabled = cd
			b2.PaddingRight = UDim.new(0, cd and 8 or 0)
			if b0.Size.Y.Offset ~= cc then
				b0.Size = UDim2.new(1, 0, 0, cc)
			end
			local ce = math.max(b0.AbsoluteCanvasSize.Y - b0.AbsoluteWindowSize.Y, 0) / ca
			if b0.CanvasPosition.Y > ce then
				b0.CanvasPosition = Vector2.new(0, ce)
			end
		end
		local function ca(cb)
			if cb.Value.Visible then
				cb.Text.Size = UDim2.new(1, -(math.ceil(cb.Value.AbsoluteSize.X / bX.Scale.Scale) + 12), 0, 24)
			else
				cb.Text.Size = UDim2.new(1, 0, 0, 24)
			end
		end
		local function cb(cc)
			local cd = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = cc,
					Parent = b1,
				}
			)
			local ce = {
				Frame = cd,
				Text = __Ixa_guiLabel({
					Size = UDim2.new(1, 0, 0, 24),
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = "",
					TextSize = 13,
					LineHeight = 1.1,
					FontFace = __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextWrapped = true,
					TextTruncate = Enum.TextTruncate.None,
					RichText = true,
					Parent = cd,
				}),
				Value = __Ixa_guiLabel({
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.new(0, 0, 0, 24),
					AutomaticSize = Enum.AutomaticSize.X,
					Text = "",
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Medium,
					TextColor3 = __Ixa_guiTheme.Text,
					RichText = true,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.None,
					Visible = false,
					Parent = cd,
				}),
			}
			ce.Connections = {
				cd:GetPropertyChangedSignal("AbsoluteSize"):Connect(b9),
				ce.Value:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					ca(ce)
				end),
			}
			return ce
		end
		local function cc(cd)
			if type(cd) == "table" then
				local ce = cd.Text or cd.Name or cd[1]
				local cf = cd.Tone or cd.Color
				return {
					Text = tostring(ce == nil and "" or ce),
					Value = cd.Value ~= nil and tostring(cd.Value) or nil,
					Tone = (type(cf) == "string" or typeof(cf) == "Color3") and cf or nil,
				}
			end
			return { Text = tostring(cd) }
		end
		local function cd(ce)
			return ce.Text .. "\0" .. (ce.Value or "\1") .. "\0" .. tostring(ce.Tone or "")
		end
		local function ce(cf, cg)
			local ch = cd(cg)
			if cf.Key == ch then
				return
			end
			cf.Key = ch
			cf.Text.Text = __Ixa_guiLibrary._rich(cg.Text)
			local ci = cg.Tone and __Ixa_guiLibrary._color(cg.Tone) or nil
			if cg.Value then
				cf.Value.Text = __Ixa_guiLibrary._rich(cg.Value)
				cf.Value.Visible = true
				__Ixa_guiTween(cf.Value, { TextColor3 = ci or __Ixa_guiTheme.Text }, 0)
				__Ixa_guiTween(cf.Text, { TextColor3 = __Ixa_guiTheme.Muted }, 0)
			else
				cf.Value.Visible = false
				__Ixa_guiTween(cf.Text, { TextColor3 = ci or __Ixa_guiTheme.Muted }, 0)
			end
			ca(cf)
		end
		local function cf(cg)
			for ch, ci in ipairs(cg.Connections) do
				ci:Disconnect()
			end
			cg.Frame:Destroy()
		end
		function b8:Set(cg)
			if type(cg) ~= "table" or b8._destroyed then
				return
			end
			local ch, ci = {}, {}
			b7 = {}
			for cj, ck in ipairs(cg) do
				b7[cj] = type(ck) == "table" and table.clone(ck) or ck
				local cl = cc(ck)
				ch[cj] = cl
				ci[cj] = cd(cl)
			end
			local cj = table.concat(ci, "\2") .. "#" .. #ch
			if cj == b6 then
				return
			end
			b6 = cj
			b5 = ch
			for ck, cl in ipairs(b5) do
				local cm = b4[ck]
				if not cm then
					cm = cb(ck)
					b4[ck] = cm
				end
				ce(cm, cl)
			end
			for ck = #b4, #b5 + 1, -1 do
				cf(b4[ck])
				b4[ck] = nil
			end
			b3.Visible = #b5 == 0
			b9()
		end
		function b8:Get()
			local cg = {}
			for ch, ci in ipairs(b7) do
				cg[ch] = type(ci) == "table" and table.clone(ci) or ci
			end
			return cg
		end
		function b8:Clear()
			b8:Set({})
		end
		function b8:SetName(cg)
			cg = tostring(cg or "")
			b_.Text = string.upper(cg)
			b_.Visible = cg ~= ""
			b8._searchName = cg
			b8._searchKey = __Ixa_searchLower(cg)
		end
		local cg = math.max(tonumber(bV.UpdateRate) or 1, 0.05)
		function b8:SetUpdateRate(ch)
			cg = math.max(tonumber(ch) or cg, 0.05)
		end
		__Ixa_guiBindTheme(b1, function()
			for ch, ci in ipairs(b4) do
				if b5[ch] then
					ci.Key = nil
					ce(ci, b5[ch])
				end
			end
		end)
		local ch = b3:GetPropertyChangedSignal("AbsoluteSize"):Connect(b9)
		table.insert(b8._listeners, function()
			b8._destroyed = true
			ch:Disconnect()
			for ci, cj in ipairs(b4) do
				for ck, cl in ipairs(cj.Connections) do
					cl:Disconnect()
				end
			end
		end)
		local function ci()
			if bX._destroyed or not bX.Open or bX.Minimized or not b8._userVisible then
				return false
			end
			local cj = self
			if cj._groupbox then
				if cj._userVisible == false then
					return false
				end
				cj = cj.Parent
			end
			if cj._isSubTab then
				if cj.Parent.CurrentSubTab ~= cj then
					return false
				end
				cj = cj.Parent
			end
			return bX.CurrentTab == cj
		end
		if type(bV.Update) == "function" then
			local cj = true
			table.insert(b8._listeners, function()
				cj = false
			end)
			task.defer(function()
				local ck = true
				while cj and bZ.Parent do
					if ck or ci() then
						ck = false
						local cl, cm = __Ixa_guiYieldCall(bV.Update)
						if cl then
							if cm ~= nil then
								b8:Set(cm)
							end
						else
							warn("[AirFlow] status list update error: " .. tostring(cm))
						end
					end
					task.wait(cg)
				end
			end)
		end
		b8:Set(bV.Rows or {})
		return __Ixa_guiRegister(self, bV, b8, bZ, "StatusList")
	end
	__Ixa_guiGroup.CreateStatus = __Ixa_guiGroup.Status
	__Ixa_guiGroup.AddStatus = __Ixa_guiGroup.Status
	__Ixa_guiGroup.CreateStatuses = __Ixa_guiGroup.Statuses
	__Ixa_guiGroup.CreateStatusList = __Ixa_guiGroup.StatusList
	__Ixa_guiGroup.AddStatusList = __Ixa_guiGroup.StatusList
	function __Ixa_guiGroup:_mediaCard(bV, bW)
		bV = __Ixa_guiOptions(bV, { Title = "Name", Description = "Desc" })
		local bX = __Ixa_guiControlMetrics(self)
		local bY = bX.Compact
		local bZ = math.clamp(tonumber(bV.Height) or bW, 40, 600)
		local b_ = bY and 14 or 8
		local b0 = type(bV.Name) == "string" and bV.Name ~= ""
		local b1 = bY and 4 or 10
		local b2 = b0 and (b1 + (bV.Desc and 38 or 22)) or (bY and 4 or b_)
		local b3 = b2 + bZ + (bY and 6 or b_)
		local b4, b5 = __Ixa_guiControlFrame(self, "Frame", b3, bV)
		__Ixa_guiHoverStroke(b4, b5)
		local b6, b7
		if b0 then
			b6 = __Ixa_guiLabel({
				Position = UDim2.fromOffset(14, b1),
				Size = UDim2.new(1, -28, 0, bX.TitleHeight),
				Text = bV.Name,
				TextSize = bX.TextSize,
				Parent = b4,
			})
			if bV.Desc then
				b7 = __Ixa_guiLabel({
					Position = UDim2.fromOffset(14, b1 + bX.TitleHeight + 1),
					Size = UDim2.new(1, -28, 0, bX.DescLine),
					Text = bV.Desc,
					TextSize = bX.DescSize,
					FontFace = __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Muted,
					Parent = b4,
				})
			end
		end
		local b8 = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(b_, b2),
				Size = UDim2.new(1, -b_ * 2, 0, bZ),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = b4,
			}
		)
		__Ixa_guiCorner(b8, UDim.new(0, 6))
		__Ixa_guiStroke(b8, __Ixa_guiTheme.Stroke)
		local b9 = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(22, 22),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ImageTransparency = 0.3,
				ScaleType = Enum.ScaleType.Fit,
				Parent = b8,
			}
		)
		local ca = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0.35,
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 3,
				Parent = b8,
			}
		)
		__Ixa_guiNew("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = ca })
		local cb = __Ixa_guiLabel({
			Position = UDim2.fromOffset(10, 8),
			Size = UDim2.new(1, -20, 1, -10),
			TextSize = 12,
			TextColor3 = Color3.new(1, 1, 1),
			ZIndex = 4,
			Parent = ca,
		})
		local function cc(cd)
			cd = cd ~= nil and tostring(cd) or ""
			cb.Text = cd
			ca.Visible = cd ~= ""
		end
		cc(bV.Caption)
		return bV, { Frame = b4, Stroke = b5, Media = b8, Placeholder = b9, Title = b6, Desc = b7, SetCaption = cc }
	end
	function __Ixa_guiGroup:Image(bV)
		local bW
		bV, bW = self:_mediaCard(bV, 160)
		local bX = self.Window
		local bY = bW.Media
		__Ixa_guiApplyIcon(bW.Placeholder, "image")
		local function bZ(b_, b0)
			local b1, b2 = pcall(function()
				return Enum.ScaleType[tostring(b_)]
			end)
			return b1 and b2 or b0
		end
		local b_ = __Ixa_guiNew(
			"ImageLabel",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				ScaleType = bZ(bV.ScaleType or "Crop", Enum.ScaleType.Crop),
				ZIndex = 2,
				Parent = bY,
			}
		)
		__Ixa_guiCorner(b_, UDim.new(0, 6))
		if bV.Color then
			b_.ImageColor3 = bV.Color
		end
		local b0 = { Value = nil }
		local b1 = 0
		function b0:SetImage(b2)
			b1 += 1
			local b3 = b1
			b0.Value = b2
			if b2 == nil or b2 == "" or b2 == "None" then
				__Ixa_guiTween(b_, { ImageTransparency = 1 }, 0.2)
				__Ixa_guiTween(bW.Placeholder, { ImageTransparency = 0.3 }, 0.2)
				return true
			end
			local b4, b5
			if type(b2) == "number" then
				b4 = "rbxassetid://" .. math.floor(b2)
			elseif type(b2) == "string" and ({ avatar = true, headshot = true })[b2:lower()] then
				b4 = "rbxthumb://type=AvatarHeadShot&id=" .. __Ixa_guiPlayer.UserId .. "&w=420&h=420"
			else
				local b6, b7, b8 = pcall(bX._resolveBackground, bX, tostring(b2))
				if b6 then
					b4, b5 = b7, b8
				else
					b5 = tostring(b7)
				end
			end
			if b1 ~= b3 then
				return false, "replaced by a newer image"
			end
			if not b4 then
				warn("[AirFlow] image: " .. tostring(b5))
				return false, b5
			end
			b_.ImageTransparency = 1
			b_.Image = b4
			task.spawn(function()
				local b6 = 0
				while not b_.IsLoaded and b6 < 4 and b1 == b3 and b_.Parent do
					b6 += task.wait(0.05)
				end
				if b1 == b3 and b_.Parent then
					__Ixa_guiTween(b_, { ImageTransparency = 0 }, 0.35)
					__Ixa_guiTween(bW.Placeholder, { ImageTransparency = 1 }, 0.2)
				end
			end)
			return true
		end
		b0.Set = b0.SetImage
		function b0:Get()
			return b0.Value
		end
		function b0:SetCaption(b2)
			bW.SetCaption(b2)
		end
		function b0:SetScaleType(b2)
			b_.ScaleType = bZ(b2, b_.ScaleType)
		end
		function b0:SetColor(b2)
			b_.ImageColor3 = typeof(b2) == "Color3" and b2 or Color3.new(1, 1, 1)
		end
		function b0:SetTitle(b2)
			if bW.Title then
				bW.Title.Text = tostring(b2)
			end
		end
		if bV.Image ~= nil then
			task.spawn(b0.SetImage, b0, bV.Image)
		end
		return __Ixa_guiRegister(self, bV, b0, bW.Frame, "Image")
	end
	function __Ixa_guiGroup:Viewport(bV)
		local bW
		bV, bW = self:_mediaCard(bV, 180)
		local bX = self.Window
		local bY = bW.Media
		__Ixa_guiApplyIcon(bW.Placeholder, "box")
		local bZ = __Ixa_guiNew(
			"ViewportFrame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				Ambient = bV.Ambient or Color3.fromRGB(165, 160, 175),
				LightColor = bV.LightColor or Color3.fromRGB(255, 250, 245),
				LightDirection = Vector3.new(-0.6, -1, -0.8),
				ZIndex = 2,
				Parent = bY,
			}
		)
		local b_ = Instance.new("Camera")
		b_.FieldOfView = math.clamp(tonumber(bV.FieldOfView) or 35, 10, 90)
		b_.Parent = bZ
		bZ.CurrentCamera = b_
		local b0 = Instance.new("WorldModel")
		b0.Parent = bZ
		local b1 = { Model = nil, Spin = bV.Spin ~= false, SpinSpeed = tonumber(bV.SpinSpeed) or 25 }
		local b2 = math.rad(tonumber(bV.Angle) or 0)
		local b3 = math.rad(tonumber(bV.Pitch) or 10)
		local b4 = tonumber(bV.Distance) or 1
		local b5, b6, b7 = nil, 10, CFrame.new()
		local b8 = nil
		local b9 = 0
		local ca, cb, cc = false, 0, 0
		local function cd()
			if not b5 then
				return
			end
			local ce = b7:VectorToWorldSpace(
				Vector3.new(math.sin(b2) * math.cos(b3), math.sin(b3), -math.cos(b2) * math.cos(b3))
			)
			b_.CFrame = CFrame.lookAt(b5 + ce * b6, b5)
		end
		local function ce(cf)
			local cg, ch
			if cf:IsA("Model") then
				cg, ch = cf:GetBoundingBox()
				b7 = cf:GetPivot().Rotation
			elseif cf:IsA("BasePart") then
				cg, ch = cf.CFrame, cf.Size
				b7 = cf.CFrame.Rotation
			else
				return false
			end
			b5 = cg.Position
			local ci = math.max(ch.Magnitude / 2, 0.5)
			b6 = ci / math.tan(math.rad(b_.FieldOfView / 2)) * b4
			cd()
			return true
		end
		local function cf(cg)
			local ch = cg
			if bV.Clone ~= false then
				local ci = cg.Archivable
				pcall(function()
					cg.Archivable = true
				end)
				local cj, ck = pcall(cg.Clone, cg)
				pcall(function()
					cg.Archivable = ci
				end)
				ch = cj and ck or nil
			end
			if not ch then
				return nil
			end
			local function ci(cj)
				if cj:IsA("LuaSourceContainer") or cj:IsA("Sound") or cj:IsA("ForceField") then
					cj:Destroy()
				elseif cj:IsA("BasePart") then
					cj.Anchored = true
					cj.CanCollide = false
				end
			end
			for cj, ck in ipairs(ch:GetDescendants()) do
				pcall(ci, ck)
			end
			if ch:IsA("BasePart") then
				ch.Anchored = true
			end
			local cj = ch:FindFirstChildOfClass("Humanoid")
			if cj then
				cj.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
			return ch
		end
		local function cg(ch)
			if type(ch) == "function" then
				local ci, cj = pcall(ch)
				ch = ci and cj or nil
			end
			if type(ch) == "string" and ({ avatar = true, player = true, character = true })[ch:lower()] then
				ch = __Ixa_guiPlayer
			end
			if typeof(ch) == "Instance" and ch:IsA("Player") then
				local ci = ch.Character
				if not ci then
					ci = ch.CharacterAdded:Wait()
					task.wait(0.5)
				end
				ch = ci
			end
			return typeof(ch) == "Instance" and ch or nil
		end
		function b1:SetModel(ch)
			b9 += 1
			local ci = b9
			b8 = ch
			if b1.Model then
				b1.Model:Destroy()
				b1.Model = nil
			end
			b5 = nil
			if ch == nil then
				__Ixa_guiTween(bZ, { ImageTransparency = 1 }, 0.2)
				__Ixa_guiTween(bW.Placeholder, { ImageTransparency = 0.3 }, 0.2)
				return true
			end
			local cj = cg(ch)
			if b9 ~= ci then
				return false, "replaced by a newer model"
			end
			if not cj then
				return false, "no model to show"
			end
			local ck = cf(cj)
			if not ck then
				return false, "could not copy the model"
			end
			ck.Parent = b0
			b1.Model = ck
			if not ce(ck) then
				ck:Destroy()
				b1.Model = nil
				return false, "not a Model or a part"
			end
			bZ.ImageTransparency = 1
			__Ixa_guiTween(bZ, { ImageTransparency = 0 }, 0.35)
			__Ixa_guiTween(bW.Placeholder, { ImageTransparency = 1 }, 0.2)
			return true
		end
		b1.Set = b1.SetModel
		function b1:Get()
			return b1.Model
		end
		function b1:Refresh()
			return b1:SetModel(b8)
		end
		function b1:SetSpin(ch)
			b1.Spin = ch ~= false
		end
		function b1:SetSpinSpeed(ch)
			b1.SpinSpeed = tonumber(ch) or b1.SpinSpeed
		end
		function b1:SetAngle(ch)
			b2 = math.rad(tonumber(ch) or 0)
			cd()
		end
		function b1:SetCaption(ch)
			bW.SetCaption(ch)
		end
		function b1:SetTitle(ch)
			if bW.Title then
				bW.Title.Text = tostring(ch)
			end
		end
		bY.InputBegan:Connect(function(ch)
			if __Ixa_guiIsPointerPress(ch) and b1.Model then
				ca = true
				cb = __Ixa_guiMousePosition().X
			end
		end)
		bX:_listen("Changed", function(ch)
			if ca and __Ixa_guiIsPointerMove(ch) then
				local ci = __Ixa_guiMousePosition().X
				b2 -= (ci - cb) * 0.012
				cb = ci
				cd()
			end
		end, b1)
		bX:_listen("Ended", function(ch)
			if ca and __Ixa_guiIsPointerPress(ch) then
				ca = false
				cc = os.clock() + 1.5
			end
		end, b1)
		bX:_listen("Render", function(ch)
			if b1.Spin and b5 and not ca and os.clock() >= cc and bX.Open and not bX.Minimized and bW.Frame.Visible then
				b2 += math.rad(b1.SpinSpeed) * ch
				cd()
			end
		end, b1)
		if bV.Model ~= nil then
			task.spawn(b1.SetModel, b1, bV.Model)
		end
		return __Ixa_guiRegister(self, bV, b1, bW.Frame, "Viewport")
	end
	function __Ixa_guiGroup:Table(bV)
		bV = __Ixa_guiOptions(bV, { Title = "Name", Description = "Desc", Data = "Rows", OnRowClick = "Callback" })
		local bW = self.Window
		local bX = __Ixa_guiControlMetrics(self)
		local bY = bX.Compact
		local bZ = tonumber(bV.RowHeight) or (__Ixa_guiTouch and 32 or 26)
		local b_ = math.max(math.floor(tonumber(bV.MaxRows) or 8), 1)
		local b0 = __Ixa_guiTouch and 28 or 24
		local b1 = bY and 12 or 13
		local b2 = bY and 14 or 8
		local b3 = type(bV.Name) == "string" and bV.Name ~= ""
		local b4 = bY and 4 or 10
		local b5 = bV.Search ~= false
		local b6 = __Ixa_guiTouch and 30 or 26
		local b7 = b3 and (b4 + (bV.Desc and 38 or 22)) or (bY and 4 or b2)
		local b8 = b7 + (b5 and b6 + 6 or 0)
		local b9 = bY and 6 or b2
		local ca = bV.Editable == true
		if not ca and type(bV.Columns) == "table" then
			for cb, cc in ipairs(bV.Columns) do
				if type(cc) == "table" and cc.Type ~= nil then
					ca = true
					break
				end
			end
		end
		local cb = ca and bV.AllowAdd ~= false
		local cc = ca and bV.AllowRemove ~= false
		local cd = cb and (__Ixa_guiTouch and 30 or 26) + 6 or 0
		local ce, cf = __Ixa_guiControlFrame(self, "Frame", b8 + b0 + bZ + cd + b9, bV)
		__Ixa_guiHoverStroke(ce, cf)
		local cg
		if b3 then
			cg = __Ixa_guiLabel({
				Position = UDim2.fromOffset(14, b4),
				Size = UDim2.new(1, -28, 0, bX.TitleHeight),
				Text = bV.Name,
				TextSize = bX.TextSize,
				Parent = ce,
			})
			if bV.Desc then
				__Ixa_guiLabel({
					Position = UDim2.fromOffset(14, b4 + bX.TitleHeight + 1),
					Size = UDim2.new(1, -28, 0, bX.DescLine),
					Text = bV.Desc,
					TextSize = bX.DescSize,
					FontFace = __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Muted,
					Parent = ce,
				})
			end
		end
		local ch = ""
		local ci, cj
		if b5 then
			local ck = __Ixa_guiNew(
				"Frame",
				{
					Position = UDim2.fromOffset(b2, b7),
					Size = UDim2.new(1, -b2 * 2, 0, b6),
					BackgroundColor3 = __Ixa_guiTheme.Surface,
					BorderSizePixel = 0,
					Parent = ce,
				}
			)
			ck:SetAttribute("NoDrag", true)
			__Ixa_guiCorner(ck, UDim.new(0, 6))
			local cl = __Ixa_guiStroke(ck)
			local cm, cn = __Ixa_guiIcon(ck, "search", __Ixa_guiTheme.Muted, UDim2.new(0, 9, 0.5, 0))
			cm.Size = UDim2.fromOffset(13, 13)
			cj = __Ixa_guiLabel({
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -9, 0, 0),
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = "",
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextTruncate = Enum.TextTruncate.None,
				Visible = false,
				Parent = ck,
			})
			ci = __Ixa_guiNew(
				"TextBox",
				{
					Position = UDim2.fromOffset(29, 0),
					Size = UDim2.new(1, -90, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					PlaceholderText = bV.SearchPlaceholder or "Search",
					PlaceholderColor3 = __Ixa_guiTheme.Muted,
					TextColor3 = __Ixa_guiTheme.Text,
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Regular,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					ClearTextOnFocus = false,
					Parent = ck,
				}
			)
			ci.Focused:Connect(function()
				__Ixa_guiTween(cl, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
				__Ixa_guiTween(cn, { ImageColor3 = __Ixa_guiTheme.Accent }, 0.15)
			end)
			ci.FocusLost:Connect(function()
				__Ixa_guiTween(cl, { Color = __Ixa_guiTheme.Stroke }, 0.2)
				__Ixa_guiTween(cn, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.2)
			end)
		end
		local ck = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(b2, b8),
				Size = UDim2.new(1, -b2 * 2, 0, b0 + bZ),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = ce,
			}
		)
		__Ixa_guiCorner(ck, UDim.new(0, 6))
		__Ixa_guiStroke(ck, __Ixa_guiTheme.Stroke)
		local cl = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, b0),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.45,
				BorderSizePixel = 0,
				Parent = ck,
			}
		)
		__Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = __Ixa_guiTheme.Stroke,
				BorderSizePixel = 0,
				Parent = cl,
			}
		)
		local cm = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Position = UDim2.fromOffset(0, b0),
				Size = UDim2.new(1, 0, 1, -b0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0.4,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				Parent = ck,
			}
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = cm })
		local cn = __Ixa_guiLabel({
			Position = UDim2.fromOffset(0, b0),
			Size = UDim2.new(1, 0, 0, bZ),
			Text = bV.EmptyText or "Nothing here yet",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = ck,
		})
		local co
		if cb then
			co = __Ixa_guiNew(
				"TextButton",
				{
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, b2, 1, -b9),
					Size = UDim2.new(1, -b2 * 2, 0, cd - 6),
					BackgroundColor3 = __Ixa_guiTheme.Surface,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Text = "",
					Parent = ce,
				}
			)
			co:SetAttribute("NoDrag", true)
			__Ixa_guiCorner(co, UDim.new(0, 6))
			local cp = __Ixa_guiStroke(co)
			local cq = __Ixa_guiLabel({
				Size = UDim2.fromScale(1, 1),
				Text = "+  " .. tostring(bV.AddText or "Add row"),
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = co,
			})
			co.MouseEnter:Connect(function()
				__Ixa_guiTween(cq, { TextColor3 = __Ixa_guiTheme.Text }, 0.12)
				__Ixa_guiTween(cp, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
			end)
			co.MouseLeave:Connect(function()
				__Ixa_guiTween(cq, { TextColor3 = __Ixa_guiTheme.Muted }, 0.2)
				__Ixa_guiTween(cp, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			end)
		end
		local cp = { Rows = {} }
		local cq = nil
		local cr, cs = {}, {}
		local ct = {}
		local cu, cv = nil, false
		local cw = nil
		local cx = { Color3.fromRGB(245, 200, 90), Color3.fromRGB(200, 206, 218), Color3.fromRGB(214, 146, 96) }
		local function cy(cz)
			local cA = type(cz.Align) == "string" and cz.Align:lower() or nil
			if cA == "right" then
				return Enum.TextXAlignment.Right
			elseif cA == "center" or cA == "centre" then
				return Enum.TextXAlignment.Center
			end
			return Enum.TextXAlignment.Left
		end
		local function cz()
			local cA, cB, cC = 0, 0, 0
			for cD, cE in ipairs(cr) do
				local cF = tonumber(cE.Width)
				if cF and cF > 1 then
					cA += cF
				elseif cF and cF > 0 then
					cB += cF
				else
					cC += 1
				end
			end
			local cD = math.max(1 - cB, 0)
			for cE, cF in ipairs(cr) do
				local cG = tonumber(cF.Width)
				local cH
				if cG and cG > 1 then
					cF.UDim = UDim.new(0, cG)
				else
					cH = (cG and cG > 0) and cG or (cC > 0 and cD / cC or 0)
					cF.UDim = UDim.new(cH, -cA * cH)
				end
			end
		end
		local function cA(cB, cC)
			if cC.Rank or cC.Remove then
				return nil
			end
			if cB[1] ~= nil or cC.Key == nil then
				return cB[cC.Index]
			end
			return cB[cC.Key]
		end
		local function cB(cC, cD, cE)
			if type(cD.Format) == "function" then
				local cF, cG = pcall(cD.Format, cC, cE)
				if cF and cG ~= nil then
					return tostring(cG)
				end
			end
			if type(cC) == "number" then
				local cF = cC == math.floor(cC)
				local cG = cF and string.format("%d", cC) or string.format("%.2f", cC)
				local cH, cI, cJ = cG:match("^(%-?)(%d+)(.*)$")
				if cI then
					cI = cI:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
					return cH .. cI .. cJ
				end
				return cG
			end
			if cC == nil then
				return ""
			end
			return tostring(cC)
		end
		local function cC()
			for cD, cE in ipairs(cs) do
				local cF = cE.Column
				local cG = cu ~= nil and cu == cF
				__Ixa_guiTween(cE.Label, { TextColor3 = cG and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted }, 0.15)
				cE.Arrow.Visible = cG
				if cG then
					__Ixa_guiTween(cE.Arrow, { Rotation = cv and 0 or 180 }, 0.2, Enum.EasingStyle.Quint)
				end
			end
		end
		local function cD()
			local cE = {}
			for cF, cG in ipairs(cp.Rows) do
				cE[cF] = { Row = cG, Index = cF }
			end
			if cu then
				local cF = cu
				table.sort(cE, function(cG, cH)
					local cI, cJ = cA(cG.Row, cF), cA(cH.Row, cF)
					local cK, cL = tonumber(cI), tonumber(cJ)
					if cK and cL then
						if cK ~= cL then
							if cv then
								return cK > cL
							end
							return cK < cL
						end
					elseif cI ~= nil and cJ ~= nil then
						local cM, cN = string.lower(tostring(cI)), string.lower(tostring(cJ))
						if cM ~= cN then
							if cv then
								return cM > cN
							end
							return cM < cN
						end
					elseif cI ~= cJ then
						return cI ~= nil
					end
					return cG.Index < cH.Index
				end)
			end
			for cF, cG in ipairs(cE) do
				cG.Rank = cF
			end
			if ch == "" then
				return cE
			end
			local cF = {}
			for cG, cH in ipairs(cE) do
				for cI, cJ in ipairs(cr) do
					if not cJ.Rank and not cJ.Remove then
						local cK = cB(cA(cH.Row, cJ), cJ, cH.Row)
						cK = string.lower((string.gsub(cK, "<[^>]->", "")))
						if string.find(cK, ch, 1, true) then
							table.insert(cF, cH)
							break
						end
					end
				end
			end
			return cF
		end
		local function cE(cF, cG, cH)
			if cF[1] ~= nil or cG.Key == nil then
				cF[cG.Index] = cH
			else
				cF[cG.Key] = cH
			end
		end
		local function cF(cG)
			local cH = string.lower(tostring(cG.Type or ""))
			if cH == "boolean" or cH == "bool" or cH == "switch" then
				return "toggle"
			elseif cH == "select" or cH == "option" then
				return "dropdown"
			end
			return cH
		end
		local cG, cH, cI, cJ, cK, cL
		local cM, cN, cO, cP, cQ = {}, {}, nil, nil, nil
		local function cR()
			if cG then
				cG.Visible = false
				if cJ:IsFocused() then
					cJ:ReleaseFocus()
				end
			end
			cI = nil
			if bW._closePopup == cR then
				bW._closePopup = nil
			end
		end
		local function cS()
			if not cG or not cG.Visible or not cI then
				return
			end
			if not cI.Parent or not cI:IsDescendantOf(ce) then
				cR()
				return
			end
			local cT = cG.Parent
			local cU = math.max(bW.Scale.Scale, 0.01)
			local cV = (cI.AbsolutePosition - cT.AbsolutePosition) / cU
			local cW = cI.AbsoluteSize / cU
			local cX = cT.AbsoluteSize / cU
			local cY, cZ = cG.Size.X.Offset, cG.Size.Y.Offset
			local c_ = cV.Y + cW.Y + 4
			if c_ + cZ > cX.Y - 8 and cV.Y - 4 - cZ >= 8 then
				c_ = cV.Y - 4 - cZ
			end
			cG.Position = UDim2.fromOffset(math.clamp(cV.X, 8, math.max(cX.X - cY - 8, 8)), c_)
		end
		local function cT(cU, cV, cW)
			if bW._closePopup and bW._closePopup ~= cR then
				bW._closePopup()
			end
			if not cG then
				cG = __Ixa_guiNew("Frame", { BackgroundColor3 = __Ixa_guiTheme.Surface2, BorderSizePixel = 0, ZIndex = 45, Visible = false })
				cG:SetAttribute("NoDrag", true)
				__Ixa_guiCorner(cG, UDim.new(0, 6))
				__Ixa_guiStroke(cG, __Ixa_guiTheme.Stroke)
				cK = __Ixa_guiNew(
					"Frame",
					{
						Position = UDim2.fromOffset(4, 4),
						Size = UDim2.new(1, -8, 0, __Ixa_guiTouch and 28 or 24),
						BackgroundColor3 = __Ixa_guiTheme.Surface,
						BorderSizePixel = 0,
						ZIndex = 46,
						Visible = false,
						Parent = cG,
					}
				)
				__Ixa_guiCorner(cK, UDim.new(0, 4))
				local cX = __Ixa_guiStroke(cK)
				local cY, cZ = __Ixa_guiIcon(cK, "search", __Ixa_guiTheme.Muted, UDim2.new(0, 8, 0.5, 0))
				cY.Size = UDim2.fromOffset(12, 12)
				cY.ZIndex = 47
				cJ = __Ixa_guiNew(
					"TextBox",
					{
						Position = UDim2.fromOffset(26, 0),
						Size = UDim2.new(1, -32, 1, 0),
						BackgroundTransparency = 1,
						Text = "",
						PlaceholderText = "Search",
						PlaceholderColor3 = __Ixa_guiTheme.Muted,
						TextColor3 = __Ixa_guiTheme.Text,
						TextSize = 12,
						FontFace = __Ixa_guiFonts.Regular,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextTruncate = Enum.TextTruncate.AtEnd,
						ClearTextOnFocus = false,
						ZIndex = 47,
						Parent = cK,
					}
				)
				cJ.Focused:Connect(function()
					__Ixa_guiTween(cX, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
					__Ixa_guiTween(cZ, { ImageColor3 = __Ixa_guiTheme.Accent }, 0.15)
				end)
				cJ.FocusLost:Connect(function(c_)
					__Ixa_guiTween(cX, { Color = __Ixa_guiTheme.Stroke }, 0.2)
					__Ixa_guiTween(cZ, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.2)
					if c_ and cG.Visible and cP and cN[1] ~= nil then
						cP(cN[1])
					end
				end)
				cJ:GetPropertyChangedSignal("Text"):Connect(function()
					if cO then
						cO()
					end
				end)
				cL = __Ixa_guiLabel({
					Size = UDim2.new(1, 0, 0, __Ixa_guiTouch and 28 or 24),
					Text = "No matches",
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 47,
					Visible = false,
					Parent = cG,
				})
				cH = __Ixa_guiNew(
					"ScrollingFrame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ScrollBarThickness = 2,
						ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
						ScrollingDirection = Enum.ScrollingDirection.Y,
						CanvasSize = UDim2.new(),
						ZIndex = 45,
						Parent = cG,
					}
				)
				__Ixa_guiPadding(cH, 4, 4, 4, 4)
				cH:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					if cQ and cG.Visible then
						cQ()
					end
				end)
				bW:_listen("Began", function(c_)
					if not cG.Visible then
						return
					end
					if c_.KeyCode == Enum.KeyCode.Escape then
						cR()
					elseif __Ixa_guiIsPointerPress(c_) and not __Ixa_guiContainsPoint(__Ixa_guiMousePosition(), cG) then
						cR()
					end
				end, cp)
				bW:_listen("Render", cS, cp)
			end
			cP = function(cX)
				cR()
				if cA(cV, cW) ~= cX then
					cE(cV, cW, cX)
					cp:_edited()
				end
			end
			local cX = cW.Options
			if type(cX) == "function" then
				local cY, cZ = pcall(cX, cV)
				cX = cY and cZ or nil
			end
			cX = type(cX) == "table" and cX or {}
			local cY = cA(cV, cW)
			local cZ = __Ixa_guiTouch and 28 or 24
			local c_ = cZ + 2
			local c0 = {}
			local c1 = cW.Searchable == true
				or (cW.Searchable ~= false and tonumber(cW.SearchAfter) ~= nil and #cX > tonumber(cW.SearchAfter))
			local c2 = c1 and (__Ixa_guiTouch and 28 or 24) + 4 or 0
			cK.Visible = c1
			cJ.Text = ""
			cJ.PlaceholderText = cW.SearchPlaceholder or (#cX > 6 and ("Search " .. #cX .. " options") or "Search")
			local c3 = math.max(bW.Scale.Scale, 0.01)
			local c4 = math.max(cU.AbsoluteSize.X / c3, c1 and 160 or 120)
			local c5 = math.max(math.floor(tonumber(cW.MaxRows) or 6), 1)
			local function c6()
				local c7 = {}
				local c8 = __Ixa_guiNew(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, cZ),
						BackgroundColor3 = __Ixa_guiTheme.Surface3,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AutoButtonColor = false,
						Text = "",
						ZIndex = 46,
						Visible = false,
						Parent = cH,
					}
				)
				__Ixa_guiCorner(c8, UDim.new(0, 4))
				c7.Button = c8
				c7.Label = __Ixa_guiLabel({
					Position = UDim2.fromOffset(8, 0),
					Size = UDim2.new(1, -16, 1, 0),
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Regular,
					ZIndex = 47,
					Parent = c8,
				})
				c8.MouseEnter:Connect(function()
					__Ixa_guiTween(c8, { BackgroundTransparency = 0.25 }, 0.1)
				end)
				c8.MouseLeave:Connect(function()
					__Ixa_guiTween(c8, { BackgroundTransparency = c7.Selected and 0.4 or 1 }, 0.2)
				end)
				c8.MouseButton1Click:Connect(function()
					if c7.Option ~= nil and cP then
						cP(c7.Option)
					end
				end)
				return c7
			end
			cQ = function()
				local c7 = cH.CanvasSize.Y.Offset
				local c8 = c7 > 0 and cH.AbsoluteCanvasSize.Y / c7 or 1
				local c9 = math.max(math.floor(cH.CanvasPosition.Y / c8 / c_), 1)
				local da = c5 + 3
				for db = 1, math.max(da, #cM) do
					local dc = db <= da and c9 + (db - c9) % da or 0
					local dd = db <= da and cN[dc] or nil
					local de = cM[db]
					if dd == nil then
						if de then
							de.Button.Visible = false
							de.Option = nil
						end
					else
						if not de then
							de = c6()
							cM[db] = de
						end
						de.Button.Position = UDim2.fromOffset(0, (dc - 1) * c_)
						if de.Option ~= dd then
							local df = dd == cY
							de.Option = dd
							de.Selected = df
							de.Label.Text = tostring(dd)
							de.Label.TextColor3 = df and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Text
							de.Button.BackgroundTransparency = df and 0.4 or 1
						end
						de.Button.Visible = true
					end
				end
			end
			cO = function()
				local c7 = string.lower(bM(cJ.Text))
				if c7 == "" then
					cN = cX
				else
					cN = {}
					for c8, c9 in ipairs(cX) do
						local da = c0[c9]
						if da == nil then
							da = string.lower(tostring(c9))
							c0[c9] = da
						end
						if string.find(da, c7, 1, true) then
							table.insert(cN, c9)
						end
					end
				end
				local c8 = #cN
				cL.Visible = c8 == 0
				cL.Position = UDim2.fromOffset(0, c2 + 4)
				cH.Position = UDim2.fromOffset(0, c2)
				cH.Size = UDim2.new(1, 0, 1, -c2)
				cH.CanvasSize = UDim2.fromOffset(0, math.max(c8 * c_ - 2, 0) + 8)
				cH.CanvasPosition = Vector2.zero
				cG.Size = UDim2.fromOffset(c4, c2 + math.clamp(c8, 1, c5) * c_ + 6)
				for c9, da in ipairs(cM) do
					da.Option = nil
				end
				cQ()
			end
			cO()
			cG.Parent = bW:_popupHost(ce)
			cI = cU
			cG.Visible = true
			bW._closePopup = cR
			cS()
			if c1 and not __Ixa_guiTouch then
				task.defer(function()
					if cG.Visible and cI == cU then
						cJ:CaptureFocus()
					end
				end)
			end
		end
		local function cU(cV)
			local cW = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.new(1, -6, 1, -6),
					BackgroundColor3 = __Ixa_guiTheme.Surface,
					BackgroundTransparency = 0.15,
					BorderSizePixel = 0,
					Parent = cV,
				}
			)
			cW:SetAttribute("NoDrag", true)
			__Ixa_guiCorner(cW, UDim.new(0, 4))
			return cW, __Ixa_guiStroke(cW)
		end
		local function cV(cW, cX, cY)
			local cZ = cF(cX)
			if cZ == "toggle" then
				local c_ = cy(cX)
				local c0 = c_ == Enum.TextXAlignment.Right and 1 or (c_ == Enum.TextXAlignment.Center and 0.5 or 0)
				local c1 = __Ixa_guiNew(
					"TextButton",
					{
						AnchorPoint = Vector2.new(c0, 0.5),
						Position = UDim2.new(c0, c0 == 1 and -6 or 0, 0.5, 0),
						Size = UDim2.fromOffset(28, 16),
						BackgroundColor3 = __Ixa_guiTheme.Surface3,
						BorderSizePixel = 0,
						AutoButtonColor = false,
						Text = "",
						Parent = cY,
					}
				)
				c1:SetAttribute("NoDrag", true)
				__Ixa_guiCorner(c1, UDim.new(1, 0))
				local c2 = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 2, 0.5, 0),
						Size = UDim2.fromOffset(12, 12),
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						Parent = c1,
					}
				)
				__Ixa_guiCorner(c2, UDim.new(1, 0))
				c1.MouseButton1Click:Connect(function()
					local c3 = cW.Data
					if c3 then
						cE(c3, cX, cA(c3, cX) ~= true)
						cp:_edited()
					end
				end)
				return { Kind = "Toggle", Switch = c1, Knob = c2 }
			elseif cZ == "dropdown" then
				local c_ = cU(cY)
				local c0 = __Ixa_guiNew(
					"TextButton",
					{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, AutoButtonColor = false, Text = "", Parent = c_ }
				)
				local c1 = __Ixa_guiLabel({
					Position = UDim2.fromOffset(6, 0),
					Size = UDim2.new(1, -24, 1, 0),
					TextSize = b1 - 1,
					FontFace = __Ixa_guiFonts.Regular,
					Parent = c0,
				})
				local c2 = __Ixa_guiNew(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -5, 0.5, 0),
						Size = UDim2.fromOffset(10, 10),
						BackgroundTransparency = 1,
						ImageColor3 = __Ixa_guiTheme.Muted,
						ScaleType = Enum.ScaleType.Fit,
						Parent = c0,
					}
				)
				__Ixa_guiApplyIcon(c2, "chevron-down")
				c0.MouseButton1Click:Connect(function()
					if cW.Data then
						if cI == c_ and cG and cG.Visible then
							cR()
						else
							cT(c_, cW.Data, cX)
						end
					end
				end)
				return { Kind = "Dropdown", Label = c1 }
			end
			local c_ = cZ == "number"
			local c0, c1 = cU(cY)
			local c2 = __Ixa_guiNew(
				"TextBox",
				{
					Position = UDim2.fromOffset(6, 0),
					Size = UDim2.new(1, -12, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					PlaceholderText = cX.Placeholder or "",
					PlaceholderColor3 = __Ixa_guiTheme.Muted,
					TextColor3 = __Ixa_guiTheme.Text,
					TextSize = b1 - 1,
					FontFace = __Ixa_guiFonts.Regular,
					TextXAlignment = cy(cX),
					TextTruncate = Enum.TextTruncate.AtEnd,
					ClearTextOnFocus = false,
					Parent = c0,
				}
			)
			local c3 = nil
			c2.Focused:Connect(function()
				__Ixa_guiTween(c1, { Color = __Ixa_guiTheme.Accent }, 0.15)
				c3 = cW.Data
				if c3 then
					local c4 = cA(c3, cX)
					c2.Text = c4 == nil and "" or tostring(c4)
				end
			end)
			c2.FocusLost:Connect(function()
				__Ixa_guiTween(c1, { Color = __Ixa_guiTheme.Stroke }, 0.2)
				local c4 = c3
				c3 = nil
				if not c4 then
					return
				end
				local c5 = c2.Text
				if c_ then
					c5 = __Ixa_guiLibrary._parseAmount(c5)
					if c5 == nil then
						cp:_redraw()
						return
					end
					if cX.Integer then
						c5 = math.floor(c5 + 0.5)
					end
					c5 = math.clamp(c5, tonumber(cX.Min) or -math.huge, tonumber(cX.Max) or math.huge)
				end
				if c5 ~= cA(c4, cX) then
					cE(c4, cX, c5)
					cp:_edited()
				else
					cp:_redraw()
				end
			end)
			return { Kind = "Input", Input = c2, Numeric = c_ }
		end
		local function cW(cX, cY)
			local cZ = __Ixa_guiNew(
				"ImageButton",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Muted,
					ScaleType = Enum.ScaleType.Fit,
					Parent = cY,
				}
			)
			cZ:SetAttribute("NoDrag", true)
			__Ixa_guiApplyIcon(cZ, "x")
			cZ.MouseEnter:Connect(function()
				__Ixa_guiTween(cZ, { ImageColor3 = __Ixa_guiTheme.Error }, 0.12)
			end)
			cZ.MouseLeave:Connect(function()
				__Ixa_guiTween(cZ, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.2)
			end)
			cZ.MouseButton1Click:Connect(function()
				local c_ = cX.Index
				if c_ and cX.Data and cp.Rows[c_] == cX.Data then
					table.remove(cp.Rows, c_)
					cp:_edited()
				end
			end)
			return { Kind = "Remove" }
		end
		local function cX(cY, cZ, c_, c0)
			if cY.Kind == "Toggle" then
				local c1 = cZ == true
				__Ixa_guiTween(cY.Switch, { BackgroundColor3 = c1 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3 }, 0.15)
				__Ixa_guiTween(
					cY.Knob,
					{ Position = c1 and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) },
					0.15,
					Enum.EasingStyle.Quint
				)
			elseif cY.Kind == "Dropdown" then
				cY.Label.Text = cZ == nil and (c_.Placeholder or "Select") or tostring(cZ)
				cY.Label.TextColor3 = cZ == nil and __Ixa_guiTheme.Muted or __Ixa_guiTheme.Text
			elseif cY.Kind == "Input" and not cY.Input:IsFocused() then
				if cZ == nil then
					cY.Input.Text = ""
				else
					cY.Input.Text = cY.Numeric and cB(cZ, c_, c0) or tostring(cZ)
				end
			end
		end
		local function cY()
			local cZ = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.new(1, 0, 0, bZ),
					BackgroundColor3 = __Ixa_guiTheme.Surface3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AutoButtonColor = false,
					Text = "",
					Parent = cm,
				}
			)
			local c_ = __Ixa_guiNew(
				"Frame",
				{
					Position = UDim2.new(0, 3, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 2, 1, -10),
					BackgroundColor3 = __Ixa_guiTheme.Accent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = cZ,
				}
			)
			__Ixa_guiCorner(c_, UDim.new(1, 0))
			local c0 = __Ixa_guiNew("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = cZ })
			__Ixa_guiPadding(c0, 10, 10)
			__Ixa_guiNew(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = c0,
				}
			)
			local c1 = { Frame = cZ, Marker = c_, Cells = {}, Hover = false }
			for c2, c3 in ipairs(cr) do
				local c4 = __Ixa_guiNew(
					"Frame",
					{
						Size = UDim2.new(c3.UDim.Scale, c3.UDim.Offset, 1, 0),
						BackgroundTransparency = 1,
						LayoutOrder = c2,
						Parent = c0,
					}
				)
				local c5 = __Ixa_guiLabel({
					Size = UDim2.new(1, -6, 1, 0),
					TextSize = b1,
					FontFace = c3.Rank and __Ixa_guiFonts.Bold or __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Text,
					TextXAlignment = cy(c3),
					RichText = not c3.Rank,
					Parent = c4,
				})
				local c6
				if c3.Rank then
					c5.Size = UDim2.fromScale(1, 1)
					c5.TextXAlignment = Enum.TextXAlignment.Center
					c6 = __Ixa_guiNew(
						"Frame",
						{
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromOffset(bZ - 8, bZ - 8),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							ZIndex = 0,
							Parent = c4,
						}
					)
					__Ixa_guiCorner(c6, UDim.new(1, 0))
				end
				local c7
				if c3.Remove then
					c5.Visible = false
					c7 = cW(c1, c4)
				elseif ca and c3.Type ~= nil then
					c5.Visible = false
					c7 = cV(c1, c3, c4)
				end
				c1.Cells[c2] = { Label = c5, Badge = c6, Editor = c7 }
			end
			local c2 = __Ixa_guiClickGuard(cZ, function()
				return cm
			end)
			cZ.MouseEnter:Connect(function()
				c1.Hover = true
				__Ixa_guiTween(cZ, { BackgroundTransparency = 0.35 }, 0.1)
			end)
			cZ.MouseLeave:Connect(function()
				c1.Hover = false
				__Ixa_guiTween(
					cZ,
					{ BackgroundColor3 = c1.Highlighted and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3, BackgroundTransparency = c1.Rest
						or 1 },
					0.2
				)
			end)
			cZ.MouseButton1Click:Connect(function()
				if c1.Data and c2() then
					__Ixa_guiCall(bV.Callback, c1.Data, c1.Index)
				end
			end)
			return c1
		end
		local function cZ(c_)
			local c0 = cq or #cp.Rows
			local c1 = math.clamp(c0, 1, b_)
			local c2 = b0 + c1 * bZ
			local c3 = b8 + c2 + cd + b9
			if cw == c3 then
				return
			end
			local c4 = (c_ or cw == nil) and 0 or 0.25
			cw = c3
			__Ixa_guiTween(ck, { Size = UDim2.new(1, -b2 * 2, 0, c2) }, c4, Enum.EasingStyle.Quint)
			__Ixa_guiTween(ce, { Size = UDim2.new(1, 0, 0, c3) }, c4, Enum.EasingStyle.Quint)
		end
		local function c_()
			local c0 = cD()
			for c1, c2 in ipairs(c0) do
				local c3 = ct[c1]
				if not c3 then
					c3 = cY()
					ct[c1] = c3
				end
				local c4 = c2.Row
				c3.Data = c4
				c3.Index = c2.Index
				c3.Frame.LayoutOrder = c1
				c3.Frame.Visible = true
				local c5 = c4.Highlight == true
				if not c5 and type(bV.Highlight) == "function" then
					local c6, c7 = pcall(bV.Highlight, c4, c2.Index)
					c5 = c6 and c7 == true
				end
				c3.Highlighted = c5
				c3.Rest = c5 and 0.86 or (c1 % 2 == 0 and 0.78 or 1)
				if not c3.Hover then
					c3.Frame.BackgroundColor3 = c5 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3
					c3.Frame.BackgroundTransparency = c3.Rest
					__Ixa_guiTrackColors(c3.Frame, { BackgroundColor3 = c3.Frame.BackgroundColor3 })
				end
				c3.Marker.BackgroundTransparency = c5 and 0 or 1
				for c6, c7 in ipairs(cr) do
					local c8 = c3.Cells[c6]
					if c7.Rank then
						local c9 = cx[c2.Rank]
						c8.Label.Text = tostring(c2.Rank)
						c8.Label.TextColor3 = c9 and Color3.fromRGB(28, 22, 18) or __Ixa_guiTheme.Muted
						__Ixa_guiTrackColors(c8.Label, { TextColor3 = c8.Label.TextColor3 })
						c8.Badge.BackgroundColor3 = c9 or __Ixa_guiTheme.Surface3
						c8.Badge.BackgroundTransparency = c9 and 0.05 or 1
					elseif c7.Remove then
					else
						local c9 = cA(c4, c7)
						c8.Label.Text = __Ixa_guiLibrary._rich(cB(c9, c7, c4))
						local da = c7.Color
						if type(da) == "function" then
							local db, dc = pcall(da, c9, c4)
							da = db and dc or nil
						end
						if type(c4.Colors) == "table" then
							local db = c4.Colors[c7.Key or c7.Index]
							if db == nil then
								db = c4.Colors[c7.Index]
							end
							if db ~= nil then
								da = db
							end
						end
						local db = __Ixa_guiLibrary._color(da) or (c5 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Text)
						c8.Label.TextColor3 = db
						__Ixa_guiTrackColors(c8.Label, { TextColor3 = db })
						if c8.Editor then
							cX(c8.Editor, c9, c7, c4)
						end
					end
				end
			end
			for c1 = #c0 + 1, #ct do
				ct[c1].Frame.Visible = false
				ct[c1].Data = nil
			end
			cq = #c0
			cn.Visible = #c0 == 0
			cn.Text = (#c0 == 0 and ch ~= "" and #cp.Rows > 0) and (bV.NoMatchText or "No rows match")
				or (bV.EmptyText or "Nothing here yet")
			if cj then
				cj.Visible = ch ~= ""
				cj.Text = #c0 .. " / " .. #cp.Rows
			end
			cZ()
		end
		local function c0()
			for c1, c2 in ipairs(cs) do
				c2.Frame:Destroy()
			end
			table.clear(cs)
			for c1, c2 in ipairs(ct) do
				c2.Frame:Destroy()
			end
			table.clear(ct)
			local c1 = cl:FindFirstChild("Cells")
				or __Ixa_guiNew(
					"Frame",
					{ Name = "Cells", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = cl }
				)
			if not c1:FindFirstChildOfClass("UIListLayout") then
				__Ixa_guiPadding(c1, 10, 10)
				__Ixa_guiNew(
					"UIListLayout",
					{
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = c1,
					}
				)
			end
			for c2, c3 in ipairs(cr) do
				local c4 = __Ixa_guiNew(
					"TextButton",
					{
						Size = UDim2.new(c3.UDim.Scale, c3.UDim.Offset, 1, 0),
						BackgroundTransparency = 1,
						AutoButtonColor = false,
						Text = "",
						LayoutOrder = c2,
						Parent = c1,
					}
				)
				local c5 = c3.Rank and Enum.TextXAlignment.Center or cy(c3)
				local c6 = c5 == Enum.TextXAlignment.Right
				local c7 = __Ixa_guiLabel({
					Size = UDim2.new(1, c5 == Enum.TextXAlignment.Center and 0 or -16, 1, 0),
					Position = UDim2.fromOffset(c6 and 16 or 0, 0),
					Text = string.upper(c3.Name),
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Bold,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextXAlignment = c5,
					Parent = c4,
				})
				local c8 = __Ixa_guiNew(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 0.5, 0),
						Size = UDim2.fromOffset(12, 12),
						BackgroundTransparency = 1,
						ImageColor3 = __Ixa_guiTheme.Accent,
						ScaleType = Enum.ScaleType.Fit,
						Visible = false,
						Parent = c4,
					}
				)
				__Ixa_guiApplyIcon(c8, "chevron-down")
				local function c9()
					local da = c7.TextBounds.X
					if c6 then
						c8.Position = UDim2.new(1, -(da + 15), 0.5, 0)
					elseif c5 == Enum.TextXAlignment.Center then
						c8.Position = UDim2.new(0.5, da / 2 + 3, 0.5, 0)
					else
						local db = c4.AbsoluteSize.X / math.max(bW.Scale.Scale, 0.01)
						c8.Position = UDim2.new(0, math.clamp(da + 4, 0, math.max(db - 12, 0)), 0.5, 0)
					end
				end
				c7:GetPropertyChangedSignal("TextBounds"):Connect(c9)
				c4:GetPropertyChangedSignal("AbsoluteSize"):Connect(c9)
				task.defer(c9)
				local da = c3.Sortable and not c3.Rank
				if da then
					c4.MouseEnter:Connect(function()
						if cu ~= c3 then
							__Ixa_guiTween(c7, { TextColor3 = __Ixa_guiTheme.Text }, 0.12)
						end
					end)
					c4.MouseLeave:Connect(function()
						if cu ~= c3 then
							__Ixa_guiTween(c7, { TextColor3 = __Ixa_guiTheme.Muted }, 0.2)
						end
					end)
					c4.MouseButton1Click:Connect(function()
						if cu ~= c3 then
							local db = false
							for dc, dd in ipairs(cp.Rows) do
								local de = cA(dd, c3)
								if de ~= nil then
									db = tonumber(de) ~= nil
									break
								end
							end
							cu, cv = c3, db
							c3.FirstDescending = db
						elseif cv == c3.FirstDescending then
							cv = not cv
						else
							cu = nil
						end
						cC()
						c_()
					end)
				end
				table.insert(cs, { Frame = c4, Label = c7, Arrow = c8, Column = c3 })
			end
			cC()
		end
		function cp:SetColumns(c1)
			table.clear(cr)
			if bV.Rank then
				table.insert(cr, { Name = "#", Rank = true, Width = __Ixa_guiTouch and 40 or 36, Sortable = false })
			end
			for c2, c3 in ipairs(type(c1) == "table" and c1 or {}) do
				if type(c3) ~= "table" then
					c3 = { Name = tostring(c3) }
				end
				local c4 = c3.Name or c3.Title or ("Column " .. c2)
				table.insert(
					cr,
					{
						Name = c4,
						Key = c3.Key or c4,
						Index = c2,
						Width = c3.Width,
						Align = c3.Align,
						Format = c3.Format,
						Color = c3.Color,
						Sortable = c3.Sortable ~= false and bV.Sortable ~= false,
						Type = c3.Type,
						Options = c3.Options,
						Min = c3.Min,
						Max = c3.Max,
						Integer = c3.Integer,
						Default = c3.Default,
						Placeholder = c3.Placeholder,
						Searchable = c3.Searchable,
						SearchAfter = c3.SearchAfter,
						SearchPlaceholder = c3.SearchPlaceholder,
						MaxRows = c3.MaxRows,
					}
				)
			end
			if cc then
				table.insert(cr, { Name = "", Remove = true, Width = __Ixa_guiTouch and 30 or 26, Sortable = false })
			end
			cR()
			cu = nil
			cz()
			c0()
			c_()
		end
		local function c1(c2)
			if type(c2) == "number" then
				return cr[c2 + (bV.Rank and 1 or 0)]
			end
			for c3, c4 in ipairs(cr) do
				if not c4.Rank and (c4.Key == c2 or c4.Name == c2) then
					return c4
				end
			end
			return nil
		end
		local function c2()
			if ca then
				__Ixa_guiCall(bV.OnChanged, cp.Rows)
			end
		end
		function cp:_edited()
			c_()
			c2()
		end
		function cp:_redraw()
			c_()
		end
		function cp:_saveValue()
			local c3 = {}
			for c4, c5 in ipairs(cp.Rows) do
				c3[c4] = table.clone(c5)
			end
			return c3
		end
		function cp:SetRows(c3, c4)
			cp.Rows = {}
			for c5, c6 in ipairs(type(c3) == "table" and c3 or {}) do
				c6 = type(c6) == "table" and c6 or { c6 }
				cp.Rows[c5] = ca and table.clone(c6) or c6
			end
			c_()
			if not c4 then
				c2()
			end
		end
		cp.Set = cp.SetRows
		function cp:GetRows()
			return cp.Rows
		end
		cp.Get = cp.GetRows
		function cp:AddRow(c3, c4)
			c3 = type(c3) == "table" and c3 or { c3 }
			if tonumber(c4) then
				table.insert(cp.Rows, math.clamp(math.floor(c4), 1, #cp.Rows + 1), c3)
			else
				table.insert(cp.Rows, c3)
			end
			c_()
			return #cp.Rows
		end
		function cp:UpdateRow(c3, c4)
			if not cp.Rows[c3] then
				return false
			end
			cp.Rows[c3] = type(c4) == "table" and c4 or { c4 }
			c_()
			for c5, c6 in ipairs(ct) do
				if c6.Index == c3 and c6.Frame.Visible then
					local c7 = c6.Highlighted and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3
					__Ixa_guiTween(c6.Frame, { BackgroundColor3 = __Ixa_guiTheme.Accent, BackgroundTransparency = 0.7 }, 0.08)
					task.delay(0.1, function()
						if not c6.Hover then
							__Ixa_guiTween(c6.Frame, { BackgroundColor3 = c7, BackgroundTransparency = c6.Rest }, 0.5)
						end
					end)
					break
				end
			end
			return true
		end
		function cp:RemoveRow(c3)
			if not cp.Rows[c3] then
				return false
			end
			table.remove(cp.Rows, c3)
			c_()
			return true
		end
		function cp:Clear()
			cp:SetRows({})
		end
		function cp:Sort(c3, c4)
			cu = c3 ~= nil and c1(c3) or nil
			cv = c4 == true
			if cu then
				cu.FirstDescending = cv
			end
			cC()
			c_()
		end
		function cp:SetTitle(c3)
			if cg then
				cg.Text = tostring(c3)
			end
		end
		function cp:SetMaxRows(c3)
			b_ = math.max(math.floor(tonumber(c3) or b_), 1)
			cZ()
		end
		cp:SetColumns(bV.Columns or {})
		cp:SetRows(bV.Rows or {}, true)
		function cp:NewRow()
			if type(bV.NewRow) == "function" then
				local c3, c4 = pcall(bV.NewRow)
				if c3 and type(c4) == "table" then
					return c4
				end
			elseif type(bV.NewRow) == "table" then
				return table.clone(bV.NewRow)
			end
			local c3 = {}
			for c4, c5 in ipairs(cr) do
				if not c5.Rank and not c5.Remove then
					local c6 = c5.Default
					if c6 == nil then
						local c7 = cF(c5)
						if c7 == "toggle" then
							c6 = false
						elseif c7 == "number" then
							c6 = tonumber(c5.Min) or 0
						elseif c7 == "dropdown" then
							c6 = type(c5.Options) == "table" and c5.Options[1] or nil
						else
							c6 = ""
						end
					end
					c3[c5.Key] = c6
				end
			end
			return c3
		end
		if co then
			co.MouseButton1Click:Connect(function()
				if ci then
					ci.Text = ""
				end
				table.insert(cp.Rows, cp:NewRow())
				cp:_edited()
				task.defer(function()
					cm.CanvasPosition = Vector2.new(0, 1e7)
				end)
			end)
		end
		if bV.SortBy ~= nil then
			cp:Sort(bV.SortBy, bV.SortDescending ~= false)
		end
		cZ(true)
		if ci then
			ci:GetPropertyChangedSignal("Text"):Connect(function()
				local c3 = string.lower(bM(ci.Text))
				if c3 ~= ch then
					ch = c3
					cm.CanvasPosition = Vector2.zero
					c_()
				end
			end)
		end
		function cp:SetSearch(c3)
			if ci then
				ci.Text = tostring(c3 or "")
			end
		end
		__Ixa_guiBindTheme(ck, c_)
		return __Ixa_guiRegister(self, bV, cp, ce, "Table")
	end
	function __Ixa_guiGroup:Log(bV)
		bV = __Ixa_guiOptions(bV, { Title = "Name", Description = "Desc", Max = "MaxEntries", Limit = "MaxEntries" })
		local bW = __Ixa_guiControlMetrics(self)
		local bX = bW.Compact
		local bY = bX and 14 or 8
		local bZ = type(bV.Name) == "string" and bV.Name ~= ""
		local b_ = bX and 4 or 10
		local b0 = __Ixa_guiTouch and 22 or 20
		local b1 = bX and 12 or 13
		local b2 = math.max(math.floor(tonumber(bV.MaxRows or bV.Lines) or 6), 1)
		local b3 = math.max(math.floor(tonumber(bV.MaxEntries) or 100), 1)
		local b4 = bZ and (b_ + (bV.Desc and 38 or 22)) or (bX and 4 or bY)
		local b5 = bX and 6 or bY
		local b6 = b2 * b0 + 8
		local b7 = bV.Timestamps ~= false
		local b8, b9 = __Ixa_guiControlFrame(self, "Frame", b4 + b6 + b5, bV)
		__Ixa_guiHoverStroke(b8, b9)
		local ca
		if bZ then
			ca = __Ixa_guiLabel({
				Position = UDim2.fromOffset(14, b_),
				Size = UDim2.new(1, -28, 0, bW.TitleHeight),
				Text = bV.Name,
				TextSize = bW.TextSize,
				Parent = b8,
			})
			if bV.Desc then
				__Ixa_guiLabel({
					Position = UDim2.fromOffset(14, b_ + bW.TitleHeight + 1),
					Size = UDim2.new(1, -28, 0, bW.DescLine),
					Text = bV.Desc,
					TextSize = bW.DescSize,
					FontFace = __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Muted,
					Parent = b8,
				})
			end
		end
		local cb = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(bY, b4),
				Size = UDim2.new(1, -bY * 2, 0, b6),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = b8,
			}
		)
		__Ixa_guiCorner(cb, UDim.new(0, 6))
		__Ixa_guiStroke(cb, __Ixa_guiTheme.Stroke)
		local cc = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0.4,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				Parent = cb,
			}
		)
		__Ixa_guiPadding(cc, 8, 8, 4, 4)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = cc })
		local cd = __Ixa_guiLabel({
			Size = UDim2.fromScale(1, 1),
			Text = bV.EmptyText or "Nothing logged yet",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = cb,
		})
		local ce = { Entries = {} }
		local cf = {}
		local cg = 0
		local function ch(ci)
			local cj = cf[ci]
			if not cj then
				return
			end
			local ck = __Ixa_guiLibrary._rich(ci.Text)
			if b7 then
				ck = ('<font color="#%s">%s</font>  %s'):format(
					__Ixa_guiTheme.Muted:ToHex(),
					os.date(bV.TimeFormat or "%H:%M:%S", ci.Time),
					ck
				)
			end
			cj.Text = ck
			cj.TextColor3 = __Ixa_guiLibrary._color(ci.Color) or __Ixa_guiTheme.Text
		end
		local function ci(cj)
			while #ce.Entries > cj do
				local ck = table.remove(ce.Entries, 1)
				if cf[ck] then
					cf[ck]:Destroy()
					cf[ck] = nil
				end
			end
			cd.Visible = #ce.Entries == 0
		end
		local function cj()
			return cc.CanvasPosition.Y >= cc.AbsoluteCanvasSize.Y - cc.AbsoluteWindowSize.Y - 4
		end
		function ce:Push(ck, cl)
			local cm = cj()
			cg += 1
			local cn = { Text = tostring(ck == nil and "" or ck), Color = cl, Time = os.time() }
			table.insert(ce.Entries, cn)
			cf[cn] = __Ixa_guiLabel({
				Size = UDim2.new(1, 0, 0, b0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = b1,
				FontFace = __Ixa_guiFonts.Regular,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None,
				RichText = true,
				LayoutOrder = cg,
				Parent = cc,
			})
			ch(cn)
			ci(b3)
			if cm then
				task.defer(function()
					cc.CanvasPosition = Vector2.new(0, 1e7)
				end)
			end
			return cn
		end
		ce.Add = ce.Push
		ce.Log = ce.Push
		function ce:Clear()
			ci(0)
		end
		function ce:Get()
			local ck = {}
			for cl, cm in ipairs(ce.Entries) do
				ck[cl] = { Text = cm.Text, Color = cm.Color, Time = cm.Time }
			end
			return ck
		end
		function ce:SetTitle(ck)
			if ca then
				ca.Text = tostring(ck)
			end
		end
		function ce:SetMaxEntries(ck)
			b3 = math.max(math.floor(tonumber(ck) or b3), 1)
			ci(b3)
		end
		__Ixa_guiBindTheme(cb, function()
			for ck, cl in ipairs(ce.Entries) do
				ch(cl)
			end
		end)
		return __Ixa_guiRegister(self, bV, ce, b8, "Log")
	end
	__Ixa_guiGroup.CreateLog = __Ixa_guiGroup.Log
	__Ixa_guiGroup.AddLog = __Ixa_guiGroup.Log
	__Ixa_guiGroup.Feed = __Ixa_guiGroup.Log
	__Ixa_guiGroup.CreateFeed = __Ixa_guiGroup.Log
	__Ixa_guiGroup.AddFeed = __Ixa_guiGroup.Log
	__Ixa_guiGroup.CreateImage = __Ixa_guiGroup.Image
	__Ixa_guiGroup.AddImage = __Ixa_guiGroup.Image
	__Ixa_guiGroup.CreateViewport = __Ixa_guiGroup.Viewport
	__Ixa_guiGroup.AddViewport = __Ixa_guiGroup.Viewport
	__Ixa_guiGroup.CreateTable = __Ixa_guiGroup.Table
	__Ixa_guiGroup.AddTable = __Ixa_guiGroup.Table
	__Ixa_guiGroup.CreateLeaderboard = __Ixa_guiGroup.Table
	local function bV(bW)
		if bW.OutFrame then
			bW.OutFrame.Parent = bW.Area
			bW.OutFrame.Visible = false
			bW.OutFrame = nil
		end
		bW.Out.Visible = false
	end
	local function bW(bX)
		if bX.InFrame then
			bX.InFrame.Parent = bX.Area
			bX.InFrame.Position = UDim2.fromOffset(0, 0)
			bX.InFrame = nil
		end
		bX.In.Visible = false
	end
	function __Ixa_guiGroup:_setupSubTabs()
		local bX = self._headerBottom
		local bY = self._page
		local bZ = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Name = "SubTabs",
				Position = UDim2.fromOffset(24, bX - 4),
				Size = UDim2.new(1, -48, 0, 32),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.new(),
				Parent = bY,
			}
		)
		bZ:SetAttribute("NoDrag", true)
		local b_ = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.fromOffset(0, 32),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.35,
				BorderSizePixel = 0,
				Visible = false,
				Parent = bZ,
			}
		)
		__Ixa_guiCorner(b_, UDim.new(0, 8))
		__Ixa_guiStroke(b_, __Ixa_guiTheme.Stroke)
		local b0 = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 2, Parent = bZ }
		)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4),
				Parent = b0,
			}
		)
		self.Window:_overflowHint(bY, bZ, b0, false, __Ixa_guiTheme.Background)
		local b1 = bX + 36
		local b2 = __Ixa_guiNew(
			"Frame",
			{
				Name = "SubPages",
				Position = UDim2.fromOffset(0, b1),
				Size = UDim2.new(1, 0, 1, -b1),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = bY,
			}
		)
		local b3 = {
			Strip = bZ,
			Row = b0,
			Highlight = b_,
			Area = b2,
			Out = __Ixa_guiNew(
				"CanvasGroup",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = b2 }
			),
			In = __Ixa_guiNew(
				"CanvasGroup",
				{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 3, Parent = b2 }
			),
			Generation = 0,
		}
		self._sub = b3
		self._subTabs = {}
		self.List.Visible = false
		self:_refreshEmpty()
		b0:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if self.CurrentSubTab and not b3.Moving then
				self:_placeSubHighlight(self.CurrentSubTab, true)
			end
		end)
	end
	function __Ixa_guiGroup:_placeSubHighlight(bX, bY)
		local bZ = self._sub
		local b_ = self.Window.Scale.Scale
		local b0 = bX._button
		local b1 = b0.AbsoluteSize.X / b_
		if b1 <= 0 then
			return
		end
		local b2 = (b0.AbsolutePosition.X - bZ.Row.AbsolutePosition.X) / b_
		local b3 = { Position = UDim2.fromOffset(b2, 0), Size = UDim2.fromOffset(b1, 32) }
		if bY or not bZ.Highlight.Visible then
			bZ.Highlight.Visible = true
			bZ.Highlight.Position = b3.Position
			bZ.Highlight.Size = b3.Size
		else
			bZ.Moving = true
			__Ixa_guiTween(bZ.Highlight, b3, 0.35, Enum.EasingStyle.Quint)
			task.delay(0.36, function()
				bZ.Moving = false
			end)
		end
		local b4 = bZ.Strip.AbsoluteSize.X / b_
		local b5 = bZ.Strip.CanvasPosition.X
		if b2 < b5 then
			__Ixa_guiTween(bZ.Strip, { CanvasPosition = Vector2.new(math.max(b2 - 8, 0), 0) }, 0.3, Enum.EasingStyle.Quint)
		elseif b2 + b1 > b5 + b4 then
			__Ixa_guiTween(bZ.Strip, { CanvasPosition = Vector2.new(b2 + b1 - b4 + 8, 0) }, 0.3, Enum.EasingStyle.Quint)
		end
	end
	function __Ixa_guiGroup:SubTab(bX, bY)
		if self._groupbox or self._isSubTab then
			return self.Parent:SubTab(bX, bY)
		end
		bX = __Ixa_guiOptions(bX, { Title = "Name", Description = "Desc" })
		if bY ~= nil and bX.Icon == nil then
			bX.Icon = bY
		end
		if not self._subTabs then
			self:_setupSubTabs()
		end
		local bZ = self._sub
		local b_ = #self._subTabs + 1
		local b0 = setmetatable(
			{
				Name = bX.Name or ("Page " .. b_),
				Window = self.Window,
				Parent = self,
				_order = 0,
				_isSubTab = true,
				_index = b_,
				_iconName = bX.Icon,
			},
			__Ixa_guiGroup
		)
		local b1 = __Ixa_guiNew(
			"Frame",
			{ Name = b0.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = bZ.Area }
		)
		b0._frame = b1
		bJ(b0, b1, 0, bX.Icon or self._iconName or "layout-grid", bX.EmptyText or "Nothing here yet")
		local b2 = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = b_,
				Parent = bZ.Row,
			}
		)
		__Ixa_guiPadding(b2, 14, 14)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = b2,
			}
		)
		if bX.Icon then
			local b3 = __Ixa_guiNew(
				"ImageLabel",
				{
					Size = UDim2.fromOffset(14, 14),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Muted,
					ScaleType = Enum.ScaleType.Fit,
					LayoutOrder = 1,
					Parent = b2,
				}
			)
			__Ixa_guiApplyIcon(b3, bX.Icon)
			if b3:GetAttribute("CustomIcon") then
				b3.ImageTransparency = 0.4
			end
			b0._iconImage = b3
		end
		b0._label = __Ixa_guiLabel({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = b0.Name,
			TextSize = 13,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 2,
			Parent = b2,
		})
		b0._button = b2
		b2.MouseEnter:Connect(function()
			if self.CurrentSubTab ~= b0 then
				__Ixa_guiTween(b0._label, { TextColor3 = __Ixa_guiTheme.Text }, 0.12)
			end
		end)
		b2.MouseLeave:Connect(function()
			if self.CurrentSubTab ~= b0 then
				__Ixa_guiTween(b0._label, { TextColor3 = __Ixa_guiTheme.Muted }, 0.2)
			end
		end)
		b2.MouseButton1Click:Connect(function()
			self:SelectSubTab(b0)
		end)
		table.insert(self._subTabs, b0)
		if b_ == 1 then
			self:SelectSubTab(b0, true)
		end
		return b0
	end
	__Ixa_guiGroup.CreateSubTab = __Ixa_guiGroup.SubTab
	__Ixa_guiGroup.AddSubTab = __Ixa_guiGroup.SubTab
	function __Ixa_guiGroup:SelectSubTab(bX, bY)
		if type(bX) ~= "table" then
			for bZ, b_ in ipairs(self._subTabs or {}) do
				if b_.Name == bX or bZ == bX then
					bX = b_
					break
				end
			end
		end
		if type(bX) ~= "table" or not self._sub then
			return
		end
		local bZ = self.CurrentSubTab
		if bZ == bX then
			return
		end
		self.Window:_resetSearch()
		self.Window:_closePopups()
		self.CurrentSubTab = bX
		local b_ = self._sub
		bV(b_)
		bW(b_)
		b_.Generation += 1
		local b0 = b_.Generation
		local b1 = bY and 0 or 0.2
		if bZ then
			__Ixa_guiTween(bZ._label, { TextColor3 = __Ixa_guiTheme.Muted }, b1)
			if bZ._iconImage then
				__Ixa_guiTintIcon(bZ._iconImage, __Ixa_guiTheme.Muted, false, b1)
			end
		end
		__Ixa_guiTween(bX._label, { TextColor3 = __Ixa_guiTheme.Text }, b1)
		if bX._iconImage then
			__Ixa_guiTintIcon(bX._iconImage, __Ixa_guiTheme.Accent, true, b1)
		end
		self:_placeSubHighlight(bX, bY)
		if bY or not bZ then
			if bZ then
				bZ._frame.Visible = false
			end
			bX._frame.Visible = true
			return
		end
		local b2 = bX._index > bZ._index and 1 or -1
		b_.OutFrame = bZ._frame
		bZ._frame.Parent = b_.Out
		b_.Out.GroupTransparency = 0
		b_.Out.Position = UDim2.fromOffset(0, 0)
		b_.Out.Visible = true
		__Ixa_guiTween(b_.Out, { GroupTransparency = 1, Position = UDim2.fromOffset(-b2 * 28, 0) }, 0.2)
		b_.InFrame = bX._frame
		bX._frame.Visible = true
		bX._frame.Parent = b_.In
		b_.In.GroupTransparency = 1
		b_.In.Position = UDim2.fromOffset(b2 * 28, 0)
		b_.In.Visible = true
		__Ixa_guiTween(b_.In, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) }, 0.34, Enum.EasingStyle.Quint)
		task.delay(0.2, function()
			if b_.Generation == b0 then
				bV(b_)
			end
		end)
		task.delay(0.34, function()
			if b_.Generation == b0 then
				bW(b_)
			end
		end)
	end
	__Ixa_guiWindow._searchIcons = {
		Tab = "app-window",
		Page = "panels-top-left",
		Groupbox = "layout-grid",
		Button = "mouse-pointer-click",
		ButtonRow = "mouse-pointer-click",
		Toggle = "toggle-right",
		Slider = "sliders-horizontal",
		Dropdown = "list",
		Input = "text-cursor-input",
		Keybind = "keyboard",
		ColorPicker = "palette",
		Stepper = "chevrons-up-down",
		Progress = "activity",
		Status = "activity",
		StatusList = "activity",
		Label = "type",
		Paragraph = "type",
		OrderList = "list-ordered",
	}
	function __Ixa_guiWindow:_searchResults(bX)
		local bY = {}
		local function bZ(b_, b0)
			if type(b_) ~= "string" or b_ == "" then
				return
			end
			local b1 = string.find(__Ixa_searchLower(b_), bX, 1, true)
			if not b1 then
				return
			end
			b0.Name = b_
			b0.At = b1
			b0.Rank = b1 == 1 and 0 or (string.find(string.sub(b_, b1 - 1, b1 - 1), "[%s%p]") and 1 or 2)
			b0.Order = #bY + 1
			table.insert(bY, b0)
		end
		local function b_(b0)
			return not b0._destroyed
				and b0._type ~= "Section"
				and b0._type ~= "Divider"
				and (b0._isShown == nil or b0:_isShown())
		end
		for b0, b1 in ipairs(self.Tabs) do
			bZ(b1.Name, { Kind = "Tab", Tab = b1, Icon = b1._iconName })
			for b2, b3 in ipairs(b1._subTabs or { b1 }) do
				local b4 = b3._isSubTab and b3 or nil
				local b5 = b1.Name
				if b4 then
					bZ(b4.Name, { Kind = "Page", Tab = b1, Sub = b4, Path = b1.Name })
					b5 = b1.Name .. "  \u{203a}  " .. b4.Name
				end
				if not b3._noSearch then
					for b6, b7 in ipairs(b3._items or {}) do
						if b_(b7) then
							bZ(b7._searchName, { Kind = b7._type, Tab = b1, Sub = b4, Target = b7, Path = b5 })
						end
					end
					for b6, b7 in ipairs(b3._groupboxes or {}) do
						if b7._userVisible ~= false then
							bZ(b7.Name, { Kind = "Groupbox", Tab = b1, Sub = b4, Target = b7, Path = b5 })
							local b8 = b5 .. "  \u{203a}  " .. b7.Name
							for b9, ca in ipairs(b7._items) do
								if b_(ca) then
									bZ(
										ca._searchName,
										{ Kind = ca._type, Tab = b1, Sub = b4, Target = ca, Group = b7, Path = b8 }
									)
								end
							end
						end
					end
				end
			end
		end
		table.sort(bY, function(b0, b1)
			if b0.Rank ~= b1.Rank then
				return b0.Rank < b1.Rank
			end
			return b0.Order < b1.Order
		end)
		return bY
	end
	function __Ixa_guiWindow:_flash(bX, bY)
		for bZ, b_ in ipairs({ "SearchFlash", "SearchGlow" }) do
			local b0 = bX:FindFirstChild(b_)
			if b0 then
				b0:Destroy()
			end
		end
		bY = bY or 8
		local bZ = __Ixa_guiTheme.Accent
		local b_ = bZ:Lerp(Color3.new(1, 1, 1), 0.65)
		local b0 = __Ixa_guiNew(
			"Frame",
			{ Name = "SearchGlow", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 10, Parent = bX }
		)
		__Ixa_guiCorner(b0, UDim.new(0, bY))
		local b1 = __Ixa_guiNew(
			"UIStroke",
			{ Color = bZ, Thickness = 1, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = b0 }
		)
		local b2 = __Ixa_guiNew(
			"Frame",
			{
				Name = "SearchFlash",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = bZ,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 10,
				Parent = bX,
			}
		)
		__Ixa_guiCorner(b2, UDim.new(0, bY))
		local b3 = __Ixa_guiNew(
			"UIGradient",
			{
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.7),
					NumberSequenceKeypoint.new(0.4, 0.55),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(0.6, 0.55),
					NumberSequenceKeypoint.new(1, 0.7),
				}),
				Rotation = 18,
				Offset = Vector2.new(-1, 0),
				Parent = b2,
			}
		)
		local b4 = __Ixa_guiNew(
			"UIStroke",
			{
				Color = Color3.new(1, 1, 1),
				Thickness = 1.6,
				Transparency = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = b2,
			}
		)
		local b5 = __Ixa_guiNew(
			"UIGradient",
			{
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, bZ),
					ColorSequenceKeypoint.new(0.5, b_),
					ColorSequenceKeypoint.new(1, bZ),
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.45),
					NumberSequenceKeypoint.new(0.5, 0),
					NumberSequenceKeypoint.new(1, 0.45),
				}),
				Parent = b4,
			}
		)
		local b6 = pcall(function()
			b1.BorderStrokePosition = Enum.BorderStrokePosition.Inner
			b4.BorderStrokePosition = Enum.BorderStrokePosition.Inner
		end)
		local b7 = b6 and 6 or 3
		if not b6 then
			b0.Position = UDim2.fromOffset(b7 + 1, b7 + 1)
			b0.Size = UDim2.new(1, -(b7 + 1) * 2, 1, -(b7 + 1) * 2)
			b2.Position = UDim2.fromOffset(2, 2)
			b2.Size = UDim2.new(1, -4, 1, -4)
		end
		local b8
		if not bX:FindFirstChildOfClass("UIScale") then
			b8 = __Ixa_guiNew("UIScale", { Scale = 0.975, Parent = bX })
			__Ixa_guiTween(b8, { Scale = 1 }, 0.4, Enum.EasingStyle.Quint)
		end
		__Ixa_guiTween(b2, { BackgroundTransparency = 0.8 }, 0.2, Enum.EasingStyle.Quad)
		__Ixa_guiTween(b4, { Transparency = 0 }, 0.2, Enum.EasingStyle.Quad)
		__Ixa_guiTween(b1, { Thickness = b7, Transparency = 0.72 }, 0.35, Enum.EasingStyle.Quint)
		__Ixa_guiTween(b3, { Offset = Vector2.new(1, 0) }, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
		__Ixa_guiTween(b5, { Rotation = 540 }, 2.2, Enum.EasingStyle.Quad)
		task.spawn(function()
			task.wait(0.75)
			__Ixa_guiTween(b2, { BackgroundTransparency = 0.9 }, 0.35, Enum.EasingStyle.Sine)
			__Ixa_guiTween(b1, { Thickness = b7 / 2, Transparency = 0.85 }, 0.35, Enum.EasingStyle.Sine)
			task.wait(0.35)
			__Ixa_guiTween(b2, { BackgroundTransparency = 0.84 }, 0.3, Enum.EasingStyle.Sine)
			__Ixa_guiTween(b1, { Thickness = b7 * 0.85, Transparency = 0.76 }, 0.3, Enum.EasingStyle.Sine)
			task.wait(0.4)
			__Ixa_guiTween(b2, { BackgroundTransparency = 1 }, 0.55, Enum.EasingStyle.Quad)
			__Ixa_guiTween(b4, { Transparency = 1 }, 0.65, Enum.EasingStyle.Quad)
			__Ixa_guiTween(b1, { Thickness = b7, Transparency = 1 }, 0.65, Enum.EasingStyle.Quad)
			task.wait(0.7)
			b2:Destroy()
			b0:Destroy()
			if b8 then
				b8:Destroy()
			end
		end)
	end
	function __Ixa_guiWindow:_revealResult(bX)
		local bY, bZ, b_, b0 = bX.Tab, bX.Sub, bX.Target, bX.Group
		if self.CurrentTab ~= bY then
			self:SelectTab(bY)
		end
		if bZ then
			bY:SelectSubTab(bZ)
		end
		if not b_ then
			local b1 = bZ and bZ._button or bY._button
			task.delay(0.1, function()
				if b1.Parent then
					self:_flash(b1, bZ and 8 or 10)
				end
			end)
			return
		end
		local b1 = b0 ~= nil and b0:IsCollapsed()
		if b1 then
			b0:Expand()
		end
		local b2 = (bZ or bY).List
		task.spawn(function()
			task.wait()
			task.wait()
			if b1 then
				task.wait(0.3)
			end
			local b3 = b_._frame
			if self._destroyed or b_._destroyed or not b3 or not b3.Parent or not b2 then
				return
			end
			local b4 = self.Scale.Scale
			local b5 = (b3.AbsolutePosition.Y - b2.AbsolutePosition.Y) / b4 + b2.CanvasPosition.Y
			local b6 = b3.AbsoluteSize.Y / b4
			local b7 = b2.AbsoluteWindowSize.Y / b4
			local b8 = math.max(b2.AbsoluteCanvasSize.Y / b4 - b7, 0)
			local b9 = math.clamp(b5 + b6 / 2 - b7 / 2, 0, b8)
			if math.abs(b9 - b2.CanvasPosition.Y) > 2 then
				__Ixa_guiTween(b2, { CanvasPosition = Vector2.new(0, b9) }, 0.45, Enum.EasingStyle.Quint)
				task.wait(0.25)
			end
			if b3.Parent then
				self:_flash(b3, b_._groupbox and 10 or 8)
			end
		end)
	end
	function __Ixa_guiWindow:_resetSearch()
		if self.SearchBox and self.SearchBox.Text ~= "" then
			self.SearchBox.Text = ""
		end
	end
	function __Ixa_guiWindow:_fitTitle(bX)
		local bY = self.SearchBox and (self._searchWidth or __Ixa_guiMinWidth) + 72 or 56
		local bZ = bX._titleX + bY
		bX._title.Size = UDim2.new(1, -bZ, 0, 24)
		if bX._desc then
			bX._desc.Size = UDim2.new(1, -bZ, 0, 16)
		end
	end
	function __Ixa_guiWindow:_buildSearch(bX)
		local bY = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -56, 0, 14),
				Size = UDim2.fromOffset(__Ixa_guiMinWidth, 34),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 5,
				Parent = bX,
			}
		)
		bY:SetAttribute("NoDrag", true)
		local bZ = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				Parent = bY,
			}
		)
		__Ixa_guiCorner(bZ, UDim.new(0, 6))
		local b_ = __Ixa_guiStroke(bZ, __Ixa_guiTheme.Stroke, 0, 1)
		local b0, b1 = __Ixa_guiIcon(bZ, "search", __Ixa_guiTheme.Muted, UDim2.new(0, 9, 0.5, 0))
		b1.Parent.AnchorPoint = Vector2.new(0, 0.5)
		b1.Parent.Size = UDim2.fromOffset(13, 13)
		local b2 = __Ixa_guiNew(
			"ImageButton",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -7, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				Visible = false,
				Parent = bZ,
			}
		)
		__Ixa_guiApplyIcon(b2, "x")
		local b3 = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(28, 0),
				Size = UDim2.new(1, -52, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				PlaceholderText = "Search",
				PlaceholderColor3 = __Ixa_guiTheme.Muted,
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ClearTextOnFocus = false,
				Parent = bZ,
			}
		)
		b2.MouseEnter:Connect(function()
			__Ixa_guiTween(b2, { ImageColor3 = __Ixa_guiTheme.Text }, 0.1)
		end)
		b2.MouseLeave:Connect(function()
			__Ixa_guiTween(b2, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.15)
		end)
		b2.MouseButton1Click:Connect(function()
			b3.Text = ""
			b3:CaptureFocus()
		end)
		b3:GetPropertyChangedSignal("Text"):Connect(function()
			b2.Visible = b3.Text ~= ""
		end)
		bY.MouseEnter:Connect(function()
			if not b3:IsFocused() then
				__Ixa_guiTween(b_, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			end
		end)
		bY.MouseLeave:Connect(function()
			if not b3:IsFocused() then
				__Ixa_guiTween(b_, { Color = __Ixa_guiTheme.Stroke }, 0.25)
			end
		end)
		self.SearchBox = b3
		local b4 = __Ixa_guiTouch and 40 or 34
		local b5 = 8
		local b6 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.fromOffset(300, 0),
				BackgroundTransparency = 1,
				Visible = false,
				ZIndex = 45,
				Parent = self.Body,
			}
		)
		b6:SetAttribute("NoDrag", true)
		local b7 = __Ixa_guiNew(
			"ImageLabel",
			{
				Position = UDim2.fromOffset(-18, -12),
				Size = UDim2.new(1, 36, 1, 36),
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Shadow,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(49, 49, 450, 450),
				Parent = b6,
			}
		)
		local b8 = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundColor3 = __Ixa_guiTheme.Background, BorderSizePixel = 0, ClipsDescendants = true, Parent = b6 }
		)
		__Ixa_guiCorner(b8, UDim.new(0, 10))
		local b9 = __Ixa_guiStroke(b8, __Ixa_guiTheme.Stroke, 1)
		ao(b8)
		local ca = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Position = UDim2.fromOffset(6, 6),
				Size = UDim2.new(1, -12, 1, -12),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = __Ixa_guiTouch and 4 or 3,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0.4,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = UDim2.new(),
				Parent = b8,
			}
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = ca })
		local cb = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, b4),
			Text = "No results",
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			LayoutOrder = 0,
			Visible = false,
			Parent = ca,
		})
		local cc = {}
		local cd = {}
		local ce = 1
		local cf = false
		local cg = 0
		local ch = Vector2.new(300, 0)
		local ci = nil
		local cj
		local function ck()
			local cl = self.Scale.Scale
			local cm = self.Body.AbsolutePosition
			local cn = self.Body.AbsoluteSize.X / cl
			local co = (bY.AbsolutePosition.X + bY.AbsoluteSize.X - cm.X) / cl
			local cp = (bY.AbsolutePosition.Y + bY.AbsoluteSize.Y - cm.Y) / cl + 6
			co = math.clamp(co, ch.X + 8, math.max(cn - 8, ch.X + 8))
			b6.Position = UDim2.fromOffset(co, cp)
		end
		local function cl()
			local cm = self.Scale.Scale
			local cn = self.Body.AbsoluteSize / cm
			local co = (bY.AbsolutePosition.Y + bY.AbsoluteSize.Y - self.Body.AbsolutePosition.Y) / cm + 6
			local cp = math.max(#cc, 1)
			local cq = math.min(cp, b5) * (b4 + 2) - 2 + 12
			cq = math.max(math.min(cq, cn.Y - co - 12), b4 + 12)
			local cr = math.min(math.max(bY.AbsoluteSize.X / cm, 300), math.max(cn.X - 16, 160))
			ch = Vector2.new(cr, cq)
		end
		local function cm()
			for cn, co in ipairs(cc) do
				local cp = cn == ce
				__Ixa_guiTween(co.Button, { BackgroundTransparency = cp and 0.35 or 1 }, 0.12)
				__Ixa_guiTintIcon(co.Icon, cp and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted, cp, 0.12)
			end
		end
		local function cn()
			local co = (ce - 1) * (b4 + 2)
			local cp = ca.AbsoluteWindowSize.Y / self.Scale.Scale
			local cq = ca.CanvasPosition.Y
			if co < cq then
				cq = co
			elseif co + b4 > cq + cp then
				cq = co + b4 - cp
			else
				return
			end
			ca.CanvasPosition = Vector2.new(0, math.max(cq, 0))
		end
		local function co(cp)
			if cp == cf then
				return
			end
			cf = cp
			cg += 1
			local cq = cg
			if cp then
				if self._closePopup and self._closePopup ~= cj then
					self._closePopup()
				end
				self._closePopup = cj
				ck()
				b6.Size = UDim2.fromOffset(ch.X, 0)
				b6.Visible = true
				__Ixa_guiTween(b6, { Size = UDim2.fromOffset(ch.X, ch.Y) }, 0.26, Enum.EasingStyle.Quint)
				__Ixa_guiTween(b9, { Transparency = 0 }, 0.12)
				__Ixa_guiTween(b7, { ImageTransparency = 0.55 }, 0.26)
				if not ci then
					ci = self:_listen("Render", ck)
				end
			else
				if self._closePopup == cj then
					self._closePopup = nil
				end
				__Ixa_guiTween(b6, { Size = UDim2.fromOffset(ch.X, 0) }, 0.18, Enum.EasingStyle.Quint)
				__Ixa_guiTween(b7, { ImageTransparency = 1 }, 0.14)
				task.delay(0.19, function()
					if cg == cq and not cf then
						b6.Visible = false
						b9.Transparency = 1
						if ci then
							ci()
							ci = nil
						end
					end
				end)
			end
		end
		cj = function()
			co(false)
		end
		local function cp(cq)
			if not cq then
				return
			end
			co(false)
			b3.Text = ""
			if b3:IsFocused() then
				b3:ReleaseFocus()
			end
			self:_revealResult(cq)
		end
		local function cq(cr)
			return (string.gsub(string.gsub(string.gsub(cr, "&", "&amp;"), "<", "&lt;"), ">", "&gt;"))
		end
		local function cr(cs)
			for ct, cu in ipairs(cc) do
				cu.Button:Destroy()
			end
			table.clear(cc)
			cd = self:_searchResults(cs)
			ce = 1
			local ct = bc(__Ixa_guiTheme.Accent)
			for cu, cv in ipairs(cd) do
				if cu > 50 then
					break
				end
				local cw = __Ixa_guiNew(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, b4),
						BackgroundColor3 = __Ixa_guiTheme.Surface3,
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						LayoutOrder = cu,
						Parent = ca,
					}
				)
				__Ixa_guiCorner(cw, UDim.new(0, 7))
				local cx = __Ixa_guiNew(
					"Frame",
					{
						Position = UDim2.fromOffset(10, 0),
						Size = UDim2.new(1, -20, 1, 0),
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Parent = cw,
					}
				)
				__Ixa_guiNew(
					"UIListLayout",
					{
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 5),
						Parent = cx,
					}
				)
				local cy = 0
				local cz = nil
				local function cA(cB)
					if not cB then
						return
					end
					cy += 1
					local cC = __Ixa_guiNew(
						"ImageLabel",
						{
							Size = UDim2.fromOffset(14, 14),
							BackgroundTransparency = 1,
							ImageColor3 = __Ixa_guiTheme.Muted,
							ScaleType = Enum.ScaleType.Fit,
							LayoutOrder = cy,
							Parent = cx,
						}
					)
					__Ixa_guiApplyIcon(cC, cB)
					cz = cz or cC
				end
				local function cB(cC, cD, cE)
					cy += 1
					return __Ixa_guiLabel({
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X,
						Text = cC,
						RichText = cE == true,
						TextSize = 13,
						FontFace = cD and __Ixa_guiFonts.Medium or __Ixa_guiFonts.Regular,
						TextColor3 = cD or __Ixa_guiTheme.Muted,
						TextTruncate = Enum.TextTruncate.None,
						LayoutOrder = cy,
						Parent = cx,
					})
				end
				local function cC()
					cB(">")
				end
				local cD, cE, cF = cv.Tab, cv.Sub, cv.Group
				local cG = cv.Kind == "Tab"
				local cH = cv.Kind == "Page"
				local cI = cv.Kind == "Groupbox"
				cA(cD._iconName or "layout-grid")
				if not cG then
					cB(cD.Name)
					if cE then
						cC()
						cA(cE._iconName or "layers")
						if not cH then
							cB(cE.Name)
						end
					end
					if cF and not cI then
						cC()
						cB(cF.Name)
					end
					if not cH then
						cC()
					end
				end
				local cJ = cv.Name
				local cK = cv.At + #cs
				local cL = cq(string.sub(cJ, 1, cv.At - 1))
					.. "<b>"
					.. cq(string.sub(cJ, cv.At, cK - 1))
					.. "</b>"
					.. cq(string.sub(cJ, cK))
				cB(cL, __Ixa_guiTheme.Accent, true)
				local cM = cz
				local cN = __Ixa_guiClickGuard(cw, function()
					return ca
				end)
				cw.MouseEnter:Connect(function()
					if not __Ixa_guiIsTouch() then
						ce = cu
						cm()
					end
				end)
				cw.MouseButton1Click:Connect(function()
					if cN() then
						cp(cv)
					end
				end)
				table.insert(cc, { Button = cw, Icon = cM })
			end
			cb.Visible = #cc == 0
			ca.CanvasSize = UDim2.fromOffset(0, math.max(#cc, 1) * (b4 + 2) - 2)
			ca.CanvasPosition = Vector2.zero
			cm()
			cl()
			if cf then
				ck()
				__Ixa_guiTween(b6, { Size = UDim2.fromOffset(ch.X, ch.Y) }, 0.2, Enum.EasingStyle.Quint)
			end
		end
		local function cs()
			local ct = string.match(__Ixa_searchLower(b3.Text), "^%s*(.-)%s*$")
			if ct == "" then
				co(false)
				return
			end
			cr(ct)
			co(true)
		end
		b3.Focused:Connect(function()
			__Ixa_guiTween(b_, { Color = __Ixa_guiTheme.Accent }, 0.15)
			__Ixa_guiTween(bZ, { BackgroundTransparency = 0 }, 0.15)
			__Ixa_guiTween(b1, { ImageColor3 = __Ixa_guiTheme.Text }, 0.15)
			if b3.Text ~= "" then
				cs()
			end
		end)
		b3.FocusLost:Connect(function(ct)
			__Ixa_guiTween(b_, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			__Ixa_guiTween(bZ, { BackgroundTransparency = 0.2 }, 0.2)
			__Ixa_guiTween(b1, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.2)
			if ct and cf then
				cp(cd[ce])
			end
		end)
		b3:GetPropertyChangedSignal("Text"):Connect(cs)
		self:_listen("Began", function(ct)
			if not cf then
				return
			end
			if ct.KeyCode == Enum.KeyCode.Up or ct.KeyCode == Enum.KeyCode.Down then
				if #cc > 0 then
					local cu = ct.KeyCode == Enum.KeyCode.Up and -1 or 1
					ce = math.clamp(ce + cu, 1, #cc)
					cm()
					cn()
				end
			elseif ct.KeyCode == Enum.KeyCode.Escape then
				co(false)
			elseif __Ixa_guiIsPointerPress(ct) then
				local cu = __Ixa_guiMousePosition()
				if not __Ixa_guiContainsPoint(cu, b6) and not __Ixa_guiContainsPoint(cu, bY) then
					co(false)
				end
			end
		end)
		local function ct()
			local cu = bX.AbsoluteSize.X / self.Scale.Scale
			local cv = math.clamp(math.floor(cu * 0.32), 110, __Ixa_guiMinWidth)
			bY.Size = UDim2.fromOffset(cv, 34)
			if cv ~= self._searchWidth then
				self._searchWidth = cv
				for cw, cx in ipairs(self.Tabs) do
					self:_fitTitle(cx)
				end
			end
		end
		bX:GetPropertyChangedSignal("AbsoluteSize"):Connect(ct)
		task.defer(ct)
	end
	function __Ixa_guiWindow:_trackName(bX, bY)
		table.insert(self._identity.Names, { Label = bX, Kind = bY })
		self:_renderIdentity()
	end
	function __Ixa_guiWindow:_trackAvatar(bX, bY)
		table.insert(self._identity.Avatars, { Image = bX, Placeholder = bY })
		self:_renderIdentity(true)
	end
	function __Ixa_guiWindow:_renderIdentity(bX)
		for bY, bZ in ipairs(self._identity.Names) do
			if bZ.Kind == "User" then
				bZ.Label.Text = self._hideName and "@hidden" or ("@" .. __Ixa_guiPlayer.Name)
			else
				bZ.Label.Text = self._hideName and "Hidden" or __Ixa_guiPlayer.DisplayName
			end
		end
		local bY = bX and 0 or 0.2
		for bZ, b_ in ipairs(self._identity.Avatars) do
			__Ixa_guiTween(b_.Image, { ImageTransparency = self._hideAvatar and 1 or 0 }, bY)
			__Ixa_guiTween(b_.Placeholder, { ImageTransparency = self._hideAvatar and 0.2 or 1 }, bY)
		end
	end
	function __Ixa_guiWindow:SetHideName(bX)
		self._hideName = bX == true
		self:_renderIdentity()
	end
	function __Ixa_guiWindow:SetHideAvatar(bX)
		self._hideAvatar = bX == true
		self:_renderIdentity()
	end
	local function bX(bY, bZ, b_, b0, b1, b2)
		local b3 = __Ixa_guiNew("Frame", { BackgroundColor3 = __Ixa_guiTheme.Surface3, BorderSizePixel = 0, Parent = bZ })
		for b4, b5 in pairs(b_) do
			b3[b4] = b5
		end
		__Ixa_guiCorner(b3, UDim.new(1, 0))
		__Ixa_guiStroke(b3, b0 or __Ixa_guiTheme.Stroke, b1 or 0, b2 or 1)
		local b4 = __Ixa_guiNew(
			"ImageLabel",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(__Ixa_guiPlayer.UserId) .. "&w=150&h=150",
				Parent = b3,
			}
		)
		__Ixa_guiCorner(b4, UDim.new(1, 0))
		local b5 = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.45, 0.45),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Parent = b3,
			}
		)
		__Ixa_guiApplyIcon(b5, "user")
		bY:_trackAvatar(b4, b5)
		return b3
	end
	function __Ixa_guiWindow:_buildProfile(bY)
		__Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, -__Ixa_guiProfileHeight),
				Size = UDim2.new(1, -20, 0, 1),
				BackgroundColor3 = __Ixa_guiTheme.Stroke,
				BorderSizePixel = 0,
				Parent = bY,
			}
		)
		local bZ = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, -8),
				Size = UDim2.new(1, -16, 0, __Ixa_guiProfileHeight - 16),
				BackgroundColor3 = __Ixa_guiTheme.Surface2,
				BackgroundTransparency = 0,
				Text = "",
				AutoButtonColor = false,
				Parent = bY,
			}
		)
		__Ixa_guiCorner(bZ, UDim.new(0, 8))
		local b_ = __Ixa_guiStroke(bZ, __Ixa_guiTheme.Stroke, 0)
		local b0 = bX(
			self,
			bZ,
			{ AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0), Size = UDim2.fromOffset(32, 32) }
		)
		local b1 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 1, 1, 1),
				Size = UDim2.fromOffset(9, 9),
				BackgroundColor3 = __Ixa_guiTheme.Success,
				BorderSizePixel = 0,
				ZIndex = 2,
				Parent = b0,
			}
		)
		__Ixa_guiCorner(b1, UDim.new(1, 0))
		__Ixa_guiStroke(b1, __Ixa_guiTheme.Surface2, 0, 2)
		local b2 = __Ixa_guiLabel({
			Position = UDim2.new(0, 48, 0.5, -15),
			Size = UDim2.new(1, -74, 0, 15),
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Bold,
			Parent = bZ,
		})
		self:_trackName(b2, "Display")
		local b3 = __Ixa_guiLabel({
			Position = UDim2.new(0, 48, 0.5, 1),
			Size = UDim2.new(1, -74, 0, 13),
			Text = "\u{2026}",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = bZ,
		})
		local b4 = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -8, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ScaleType = Enum.ScaleType.Fit,
				Parent = bZ,
			}
		)
		__Ixa_guiApplyIcon(b4, "chevron-right")
		task.spawn(function()
			b3.Text = __Ixa_guiGameName()
		end)
		bZ.MouseEnter:Connect(function()
			if __Ixa_guiIsTouch() then
				return
			end
			__Ixa_guiTween(b_, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
			__Ixa_guiTween(b4, { ImageColor3 = __Ixa_guiTheme.Text, Position = UDim2.new(1, -6, 0.5, 0) }, 0.15)
		end)
		bZ.MouseLeave:Connect(function()
			__Ixa_guiTween(b_, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			__Ixa_guiTween(b4, { ImageColor3 = __Ixa_guiTheme.Muted, Position = UDim2.new(1, -8, 0.5, 0) }, 0.2)
		end)
		bZ.MouseButton1Click:Connect(function()
			if self.Home then
				self:SelectTab(self.Home)
			end
		end)
		self.Profile = bZ
	end
	function __Ixa_guiWindow:Rejoin()
		self:Notify({ Title = "Rejoining", Content = "Teleporting back into this server", Icon = "refresh-cw", Duration = 3 })
		task.spawn(function()
			local bY, bZ = pcall(function()
				if #__Ixa_guiPlayers:GetPlayers() <= 1 or game.JobId == "" then
					__Ixa_guiTeleportService:Teleport(game.PlaceId, __Ixa_guiPlayer)
				else
					__Ixa_guiTeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, __Ixa_guiPlayer)
				end
			end)
			if not bY then
				self:Notify({ Title = "Rejoin failed", Content = tostring(bZ), Type = "Error", Duration = 4 })
			end
		end)
	end
	local function bY(bZ, b_, b0, b1)
		task.spawn(function()
			local b2 = bD(b_)
			if not b2 then
				bZ:Notify({ Title = b1 .. " failed", Content = "Could not load the server list", Type = "Error", Duration = 4 })
				return
			end
			local b3 = {}
			for b4, b5 in ipairs(b2) do
				if type(b5) == "table" and b5.id ~= game.JobId then
					local b6, b7 = tonumber(b5.playing), tonumber(b5.maxPlayers)
					if b6 and b7 and b6 < b7 then
						table.insert(b3, b5)
					end
				end
			end
			local b4 = #b3 > 0 and b0(b3) or nil
			if not b4 then
				bZ:Notify({ Title = b1 .. " failed", Content = "No other open server found", Type = "Warning", Duration = 4 })
				return
			end
			bZ:Notify({
				Title = b1,
				Content = string.format("Joining a server with %d/%d players", b4.playing, b4.maxPlayers),
				Icon = "server",
				Duration = 3,
			})
			local b5, b6 = pcall(function()
				__Ixa_guiTeleportService:TeleportToPlaceInstance(game.PlaceId, b4.id, __Ixa_guiPlayer)
			end)
			if not b5 then
				bZ:Notify({ Title = b1 .. " failed", Content = tostring(b6), Type = "Error", Duration = 4 })
			end
		end)
	end
	function __Ixa_guiWindow:ServerHop()
		bY(self, "Desc", function(bZ)
			return bZ[math.random(1, #bZ)]
		end, "Server hop")
	end
	function __Ixa_guiWindow:JoinLowestServer()
		bY(self, "Asc", function(bZ)
			table.sort(bZ, function(b_, b0)
				return b_.playing < b0.playing
			end)
			return bZ[1]
		end, "Lowest server")
	end
	function __Ixa_guiWindow:CopyToClipboard(bZ, b_)
		local b0 = bC(bZ)
		self:Notify({
			Title = b0 and "Copied" or "Clipboard unavailable",
			Content = b0 and (b_ or tostring(bZ)) or "Your executor has no setclipboard",
			Type = b0 and "Success" or "Error",
			Icon = b0 and "clipboard-check" or nil,
			Duration = 2.5,
		})
		return b0
	end
	function __Ixa_guiWindow:_homeCard(bZ, b_)
		local b0 = bG(bZ, 0, b_)
		b0.AutomaticSize = Enum.AutomaticSize.Y
		__Ixa_guiPadding(b0, 16, 16, 14, 14)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = b0 })
		return b0
	end
	function __Ixa_guiWindow:_homeCaption(bZ, b_, b0)
		return __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 22),
			Text = string.upper(b_),
			TextSize = 12,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = b0,
			Parent = bZ,
		})
	end
	function __Ixa_guiWindow:_homeChip(bZ, b_, b0, b1, b2)
		local b3 = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.fromOffset(0, 24),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = b_,
				Parent = bZ,
			}
		)
		__Ixa_guiCorner(b3, UDim.new(0, 6))
		local b4 = __Ixa_guiStroke(b3)
		__Ixa_guiPadding(b3, 8, 9)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = b3,
			}
		)
		local b5 = __Ixa_guiNew(
			"ImageLabel",
			{
				Size = UDim2.fromOffset(12, 12),
				BackgroundTransparency = 1,
				ImageColor3 = b2 or __Ixa_guiTheme.Muted,
				ScaleType = Enum.ScaleType.Fit,
				LayoutOrder = 1,
				Parent = b3,
			}
		)
		__Ixa_guiApplyIcon(b5, b0)
		local b6 = __Ixa_guiLabel({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = b1,
			TextSize = 12,
			TextColor3 = b2 or __Ixa_guiTheme.Muted,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 2,
			Parent = b3,
		})
		return b3, b6, b5, b4
	end
	function __Ixa_guiWindow:_homeToggleChip(bZ, b_, b0, b1, b2, b3)
		local b4, b5, b6, b7 = self:_homeChip(bZ, b_, b0, b1)
		local b8 = b2 == true
		local function b9(ca)
			__Ixa_guiTween(
				b4,
				{ BackgroundColor3 = b8 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface3, BackgroundTransparency = b8 and 0.85 or 0.2 },
				ca
			)
			__Ixa_guiTween(b7, { Color = b8 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke, Transparency = b8 and 0.6 or 0 }, ca)
			__Ixa_guiTween(b5, { TextColor3 = b8 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted }, ca)
			__Ixa_guiTween(b6, { ImageColor3 = b8 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted }, ca)
		end
		b9(0)
		b4.MouseButton1Click:Connect(function()
			b8 = not b8
			b9(0.2)
			__Ixa_guiCall(b3, b8)
		end)
		return b4
	end
	function __Ixa_guiWindow:_homeProfile(bZ, b_, b0)
		local b1 = bG(bZ, 140, b0)
		b1.ClipsDescendants = true
		local b2 = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -16, 1, 0),
				Size = UDim2.fromOffset(140, 140),
				BackgroundTransparency = 1,
				Image = "rbxthumb://type=AvatarBust&id=" .. tostring(__Ixa_guiPlayer.UserId) .. "&w=420&h=420",
				ScaleType = Enum.ScaleType.Fit,
				Parent = b1,
			}
		)
		__Ixa_guiNew(
			"UIGradient",
			{
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.45, 0),
					NumberSequenceKeypoint.new(1, 0),
				}),
				Parent = b2,
			}
		)
		local b3 = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.6, 0.55),
				Size = UDim2.fromOffset(40, 40),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Parent = b2,
			}
		)
		__Ixa_guiApplyIcon(b3, "user")
		self:_trackAvatar(b2, b3)
		local b4 = UDim2.new(1, -190, 0, 0)
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(22, 20),
			Size = b4 + UDim2.fromOffset(0, 14),
			Text = string.upper(b_.Welcome or "Welcome back"),
			TextSize = 12,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = b1,
		})
		local b5 = __Ixa_guiLabel({
			Position = UDim2.fromOffset(22, 35),
			Size = b4 + UDim2.fromOffset(0, 32),
			TextSize = 26,
			FontFace = __Ixa_guiFonts.Bold,
			Parent = b1,
		})
		self:_trackName(b5, "Display")
		local b6 = __Ixa_guiLabel({
			Position = UDim2.fromOffset(22, 67),
			Size = b4 + UDim2.fromOffset(0, 16),
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = b1,
		})
		self:_trackName(b6, "User")
		local b7 = __Ixa_guiNew(
			"Frame",
			{ Position = UDim2.new(0, 22, 1, -40), Size = UDim2.new(1, -44, 0, 24), BackgroundTransparency = 1, Parent = b1 }
		)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 6),
				Parent = b7,
			}
		)
		local b8 = b_.Tier
		if b8 == nil then
			b8 = "Free"
		end
		if b8 then
			local b9, ca, cb = self:_homeChip(b7, 1, b_.TierIcon or self._logoIcon, tostring(b8), __Ixa_guiTheme.Accent)
			b9.Active = false
			ca.FontFace = __Ixa_guiFonts.Bold
			cb.Size = UDim2.fromOffset(13, 13)
			self.TierLabel = ca
		end
		local b9, ca = self:_homeChip(b7, 2, "clock", "")
		b9.Active = false
		b9.Visible = false
		self:_homeToggleChip(b7, 3, "eye-off", "Name", self._hideName, function(cb)
			self:SetHideName(cb)
		end)
		self:_homeToggleChip(b7, 4, "user-x", "Avatar", self._hideAvatar, function(cb)
			self:SetHideAvatar(cb)
		end)
		return function()
			local cb = b_.Expiry
			if type(cb) == "function" then
				local cc, cd = pcall(cb)
				cb = cc and cd or nil
			end
			if type(cb) == "number" then
				local cc = cb - os.time()
				ca.Text = cc > 0 and (bA(cc) .. " left") or "Expired"
			elseif cb ~= nil then
				ca.Text = tostring(cb)
			end
			b9.Visible = ca.Text ~= ""
		end
	end
	function __Ixa_guiWindow:_homeGraph(bZ, b_, b0, b1, b2, b3)
		local b4 = __Ixa_guiNew("Frame", { BackgroundTransparency = 1, LayoutOrder = b_, Parent = bZ })
		__Ixa_guiLabel({ Size = UDim2.new(0.4, 0, 0, 14), Text = b1, TextSize = 12, TextColor3 = __Ixa_guiTheme.Muted, Parent = b4 })
		local b5 = __Ixa_guiLabel({
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0.6, 0, 0, 14),
			Text = "",
			TextSize = 12,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Right,
			RichText = true,
			Parent = b4,
		})
		local b6 = __Ixa_guiLabel({
			Position = UDim2.fromOffset(0, 15),
			Size = UDim2.new(1, 0, 0, 26),
			Text = "\u{2026}",
			TextSize = 22,
			FontFace = __Ixa_guiFonts.Bold,
			RichText = true,
			Parent = b4,
		})
		local b7 = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(0, 46),
				Size = UDim2.new(1, 0, 0, 28),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = b4,
			}
		)
		__Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = __Ixa_guiTheme.Stroke,
				BorderSizePixel = 0,
				Parent = b7,
			}
		)
		local b8 = __Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 1, -1), BackgroundTransparency = 1, Parent = b7 })
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 1),
				Parent = b8,
			}
		)
		local b9 = 48
		local ca, cb = {}, {}
		for cc = 1, b9 do
			ca[cc] = __Ixa_guiNew(
				"Frame",
				{ Size = UDim2.new(1 / b9, -1, 0, 0), BackgroundColor3 = __Ixa_guiTheme.Muted, BorderSizePixel = 0, LayoutOrder = cc, Parent = b8 }
			)
		end
		local cc = "#" .. __Ixa_guiTheme.Muted:ToHex()
		local function cd(ce)
			b6.Text = ('%d<font size="13" color="%s"> %s</font>'):format(ce, cc, b3 or "")
		end
		local function ce(cf, cg)
			cd(cf)
			table.insert(cb, cf)
			if #cb > b9 then
				table.remove(cb, 1)
			end
			local ch, ci, cj = b2 or 1, math.huge, 0
			for ck, cl in ipairs(cb) do
				ch = math.max(ch, cl)
				ci = math.min(ci, cl)
				cj += cl
			end
			b5.Text = ([[min <font color="#%s">%d</font>   avg <font color="#%s">%d</font>   max <font color="#%s">%d</font>]]):format(
				__Ixa_guiTheme.Text:ToHex(),
				ci,
				__Ixa_guiTheme.Text:ToHex(),
				math.floor(cj / #cb + 0.5),
				__Ixa_guiTheme.Text:ToHex(),
				math.max(table.unpack(cb))
			)
			local ck = b9 - #cb
			for cl, cm in ipairs(ca) do
				local cn = cb[cl - ck]
				local co = b9 - cl
				__Ixa_guiTween(
					cm,
					{
						Size = UDim2.new(1 / b9, -1, cn and math.max(cn / ch, 0.04) or 0, 0),
						BackgroundColor3 = cg,
						BackgroundTransparency = cn and (co == 0 and 0 or 0.45 + 0.35 * co / b9) or 1,
					},
					0.3,
					Enum.EasingStyle.Quint
				)
			end
		end
		return b6, ce
	end
	function __Ixa_guiWindow:_homeFigure(bZ, b_, b0)
		local b1 = __Ixa_guiNew("Frame", { BackgroundTransparency = 1, LayoutOrder = b_, Parent = bZ })
		local b2 =
			__Ixa_guiLabel({ Size = UDim2.new(1, -8, 0, 20), Text = "\u{2026}", TextSize = 15, FontFace = __Ixa_guiFonts.Bold, RichText = true, Parent = b1 })
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(0, 21),
			Size = UDim2.new(1, -8, 0, 14),
			Text = b0,
			TextSize = 12,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = b1,
		})
		return b2
	end
	function __Ixa_guiWindow:_homeAction(bZ, b_, b0, b1, b2)
		local b3 = __Ixa_guiNew(
			"TextButton",
			{
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				ClipsDescendants = true,
				LayoutOrder = b_,
				Parent = bZ,
			}
		)
		__Ixa_guiCorner(b3, UDim.new(0, 8))
		local b4 = __Ixa_guiStroke(b3)
		local b5 = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 11),
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Text,
				ScaleType = Enum.ScaleType.Fit,
				Parent = b3,
			}
		)
		__Ixa_guiApplyIcon(b5, b0)
		__Ixa_guiLabel({
			Position = UDim2.new(0, 4, 0, 32),
			Size = UDim2.new(1, -8, 0, 14),
			Text = b1,
			TextSize = 12,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = b3,
		})
		b3.MouseEnter:Connect(function()
			__Ixa_guiTween(b3, { BackgroundTransparency = 0 }, 0.15, Enum.EasingStyle.Quint)
			__Ixa_guiTween(b4, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			__Ixa_guiTween(b5, { ImageColor3 = __Ixa_guiTheme.Accent }, 0.15)
		end)
		b3.MouseLeave:Connect(function()
			__Ixa_guiTween(b3, { BackgroundTransparency = 0.5 }, 0.25, Enum.EasingStyle.Quint)
			__Ixa_guiTween(b4, { Color = __Ixa_guiTheme.Stroke }, 0.25)
			__Ixa_guiTween(b5, { ImageColor3 = __Ixa_guiTheme.Text }, 0.25)
		end)
		b3.MouseButton1Click:Connect(function()
			__Ixa_guiRipple(b3)
			__Ixa_guiCall(b2)
		end)
		return b3
	end
	function __Ixa_guiWindow:_homeGame(bZ, b_)
		local b0 = self:_homeCard(bZ, b_)
		local b1 =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, LayoutOrder = 1, Parent = b0 })
		local b2 = __Ixa_guiNew(
			"ImageLabel",
			{
				Size = UDim2.fromOffset(44, 44),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150",
				Parent = b1,
			}
		)
		__Ixa_guiCorner(b2, UDim.new(0, 10))
		__Ixa_guiStroke(b2)
		local b3 = __Ixa_guiLabel({
			Position = UDim2.fromOffset(56, 3),
			Size = UDim2.new(1, -56, 0, 20),
			Text = "Loading",
			TextSize = 15,
			FontFace = __Ixa_guiFonts.Bold,
			Parent = b1,
		})
		local b4 = __Ixa_guiLabel({
			Position = UDim2.fromOffset(56, 24),
			Size = UDim2.new(1, -56, 0, 16),
			Text = "",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = b1,
		})
		local b5 = nil
		task.spawn(function()
			local b6 = __Ixa_guiGameInfo()
			b3.Text = b6 and b6.Name or __Ixa_guiGameName()
			b5 = b6 and type(b6.Creator) == "table" and b6.Creator.Name or nil
		end)
		local b6 = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Parent = b0,
			}
		)
		__Ixa_guiPadding(b6, 0, 0, 12, 0)
		__Ixa_guiNew(
			"UIGridLayout",
			{
				CellPadding = UDim2.fromOffset(6, 6),
				CellSize = UDim2.new(0.25, -5, 0, 54),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = b6,
			}
		)
		self:_homeAction(b6, 1, "refresh-cw", "Rejoin", function()
			self:Rejoin()
		end)
		self:_homeAction(b6, 2, "shuffle", "Hop", function()
			self:ServerHop()
		end)
		self:_homeAction(b6, 3, "users", "Lowest", function()
			self:JoinLowestServer()
		end)
		self:_homeAction(b6, 4, "copy", "Job ID", function()
			self:CopyToClipboard(game.JobId, "Job ID")
		end)
		__Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 26),
			Text = "Job " .. bB(game.JobId) .. "  \u{b7}  Place " .. tostring(game.PlaceId),
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			LayoutOrder = 3,
			Parent = b0,
		})
		return function()
			local b7 = #__Ixa_guiPlayers:GetPlayers() .. "/" .. __Ixa_guiPlayers.MaxPlayers .. " players"
			b4.Text = b5 and ("by " .. b5 .. "  \u{b7}  " .. b7) or b7
		end
	end
	function __Ixa_guiWindow:_homeLink(bZ, b_, b0, b1, b2, b3, b4)
		local b5 =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, LayoutOrder = b_, Parent = bZ })
		__Ixa_guiNew(
			"Frame",
			{ Name = "Rule", Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = __Ixa_guiTheme.Stroke, BorderSizePixel = 0, Parent = b5 }
		)
		local b6 = __Ixa_guiIcon(b5, b0, __Ixa_guiTheme.Accent, UDim2.new(0, 0, 0.5, 0))
		b6.Size = UDim2.fromOffset(16, 16)
		local b7 =
			__Ixa_guiLabel({ Position = UDim2.fromOffset(28, 6), Size = UDim2.new(1, -68, 0, 18), Text = b1, TextSize = 13, Parent = b5 })
		local b8 = __Ixa_guiLabel({
			Position = UDim2.fromOffset(28, 24),
			Size = UDim2.new(1, -68, 0, 15),
			Text = b2,
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = b5,
		})
		local b9 = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(30, 30),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				Parent = b5,
			}
		)
		__Ixa_guiCorner(b9, UDim.new(0, 8))
		local ca = __Ixa_guiStroke(b9)
		local cb = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(14, 14),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ScaleType = Enum.ScaleType.Fit,
				Parent = b9,
			}
		)
		__Ixa_guiApplyIcon(cb, b3)
		b9.MouseEnter:Connect(function()
			__Ixa_guiTween(b9, { BackgroundTransparency = 0 }, 0.15, Enum.EasingStyle.Quint)
			__Ixa_guiTween(ca, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			__Ixa_guiTween(cb, { ImageColor3 = __Ixa_guiTheme.Accent }, 0.15)
		end)
		b9.MouseLeave:Connect(function()
			__Ixa_guiTween(b9, { BackgroundTransparency = 0.5 }, 0.25, Enum.EasingStyle.Quint)
			__Ixa_guiTween(ca, { Color = __Ixa_guiTheme.Stroke }, 0.25)
			__Ixa_guiTween(cb, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.25)
		end)
		b9.MouseButton1Click:Connect(function()
			__Ixa_guiCall(b4)
		end)
		return b5, b7, b8
	end
	function __Ixa_guiWindow:_homeLinks(bZ, b_, b0)
		local b1 = {}
		if b_.Discord then
			table.insert(
				b1,
				{ Icon = b_.DiscordIcon or "message-circle", Title = b_.DiscordTitle or "Community", Text = b_.Discord }
			)
		end
		if b_.Website then
			table.insert(
				b1,
				{ Icon = b_.WebsiteIcon or "globe", Title = b_.WebsiteTitle or "Website", Text = b_.Website }
			)
		end
		for b2, b3 in ipairs(b_.Links or {}) do
			table.insert(b1, b3)
		end
		local b2 = b_.Features
		if #b1 == 0 and b2 == false then
			return nil, function() end
		end
		local b3 = self:_homeCard(bZ, b0)
		self:_homeCaption(b3, "Links", 0)
		for b4, b5 in ipairs(b1) do
			local b6 = type(b5.Callback) == "function"
			self:_homeLink(
				b3,
				b4,
				b5.Icon or "link",
				b5.Title or "",
				b5.Text or "",
				b6 and "arrow-up-right" or "copy",
				function()
					if b6 then
						__Ixa_guiCall(b5.Callback)
					else
						self:CopyToClipboard(b5.Copy or b5.Text, b5.Title)
					end
				end
			)
		end
		local b4 = function() end
		if b2 ~= false then
			if type(b2) == "table" then
				self._featuresTitle = b2.Title
				self._features = b2.List or (#b2 > 0 and b2 or nil)
			end
			local b5, b6, b7 = self:_homeLink(
				b3,
				100,
				type(b2) == "table" and b2.Icon or "list-checks",
				type(b2) == "table" and b2.Title or "Feature list",
				"",
				"chevron-right",
				function()
					self:ShowFeatures()
				end
			)
			b4 = function()
				local b8 = type(b2) == "table" and b2.Desc
				b7.Text = b8 or (self:_featureSummary())
			end
			task.defer(b4)
		end
		local b6 = nil
		for b7, b8 in ipairs(b3:GetChildren()) do
			if b8:IsA("Frame") and b8:FindFirstChild("Rule") and (not b6 or b8.LayoutOrder < b6.LayoutOrder) then
				b6 = b8
			end
		end
		if b6 then
			b6.Rule.Visible = false
		end
		return b3, b4
	end
	function __Ixa_guiWindow:_homeExecutor(bZ, b_, b0)
		local b1 =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = b0, Parent = bZ })
		local b2, b3, b4 = __Ixa_guiCompatibility(b_)
		local b6 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 4, 0.5, 0),
				Size = UDim2.fromOffset(7, 7),
				BackgroundColor3 = b3 and __Ixa_guiTheme.Success or __Ixa_guiTheme.Warning,
				BorderSizePixel = 0,
				Parent = b1,
			}
		)
		__Ixa_guiCorner(b6, UDim.new(1, 0))
		local b7 = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(18, 0),
				Size = UDim2.new(1, -170, 1, 0),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = b1,
			}
		)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8),
				Parent = b7,
			}
		)
		__Ixa_guiLabel({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = b2,
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 1,
			Parent = b7,
		})
		__Ixa_guiLabel({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = b4,
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = b3 and __Ixa_guiTheme.Muted or __Ixa_guiTheme.Warning,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 2,
			Parent = b7,
		})
	end
	__Ixa_guiWindow._featureKinds = {
		Toggle = true,
		Slider = true,
		Dropdown = true,
		Input = true,
		Keybind = true,
		ColorPicker = true,
		Stepper = true,
		Button = true,
		ButtonRow = true,
		OrderList = true,
	}
	function __Ixa_guiWindow:_featureGroups()
		local bZ, b_ = {}, {}
		for b0, b1 in ipairs(self.Tabs) do
			if b1 ~= self.Home and b1._userVisible ~= false then
				local b2 = { Name = b1.Name, Icon = b1._iconName, Items = {} }
				for b3, b4 in ipairs(b1._subTabs or { b1 }) do
					local b6 = b4._isSubTab and b4 or nil
					local function b7(b8, b9, ca, cb)
						if type(b8) ~= "string" or b8 == "" then
							return
						end
						local cc = {
							Name = b8,
							Kind = b9._type == "ButtonRow" and "Button" or b9._type,
							Path = cb,
							Result = { Tab = b1, Sub = b6, Target = b9, Group = ca },
						}
						table.insert(b2.Items, cc)
						b_[string.lower(b8)] = b_[string.lower(b8)] or cc
					end
					local function b8(b9, ca, cb)
						if b9._destroyed or not self._featureKinds[b9._type] or (b9._isShown and not b9:_isShown()) then
							return
						end
						if b9._type == "ButtonRow" and b9.Buttons then
							for cc, cd in ipairs(b9.Buttons) do
								b7(cd.Label.Text, b9, ca, cb)
							end
						else
							b7(b9._searchName, b9, ca, cb)
						end
					end
					if not b4._noSearch then
						for b9, ca in ipairs(b4._items or {}) do
							b8(ca, nil, b6 and b6.Name or nil)
						end
						for b9, ca in ipairs(b4._groupboxes or {}) do
							if ca._userVisible ~= false and not ca._manager then
								for cb, cc in ipairs(ca._items) do
									b8(cc, ca, b6 and (b6.Name .. "  \u{203a}  " .. ca.Name) or ca.Name)
								end
							end
						end
					end
				end
				if #b2.Items > 0 then
					table.insert(bZ, b2)
				end
			end
		end
		local b0 = self._features
		if type(b0) ~= "table" then
			return bZ
		end
		local function b1(b2)
			if type(b2) ~= "table" then
				b2 = { Name = b2 }
			end
			local b3 = tostring(b2.Name or b2.Title or b2[1] or "")
			local b4 = b_[string.lower(b3)]
			return {
				Name = b3,
				Desc = b2.Desc or b2.Description,
				Tag = b2.Tag,
				Icon = b2.Icon,
				Kind = b4 and b4.Kind,
				Path = b4 and b4.Path,
				Result = b4 and b4.Result,
				Callback = b2.Callback,
			}
		end
		local b2, b3 = {}, nil
		for b4, b6 in ipairs(b0) do
			if type(b6) == "table" and type(b6.Items) == "table" then
				local b7 = { Name = tostring(b6.Name or b6.Title or "Features"), Icon = b6.Icon, Items = {} }
				for b8, b9 in ipairs(b6.Items) do
					table.insert(b7.Items, b1(b9))
				end
				table.insert(b2, b7)
			else
				if not b3 then
					b3 = { Name = self._featuresTitle or "Features", Items = {} }
					table.insert(b2, b3)
				end
				table.insert(b3.Items, b1(b6))
			end
		end
		return b2
	end
	function __Ixa_guiWindow:_featureSummary()
		local bZ = self:_featureGroups()
		local b_ = 0
		for b0, b1 in ipairs(bZ) do
			b_ += #b1.Items
		end
		local b0 = b_ .. (b_ == 1 and " feature" or " features")
		if type(self._features) ~= "table" and #bZ > 0 then
			b0 ..= " across " .. #bZ .. (#bZ == 1 and " tab" or " tabs")
		end
		return b0, bZ, b_
	end
	function __Ixa_guiWindow:ShowFeatures()
		if self._dialog then
			self._dialog.Close()
		end
		local bZ, b_, b0 = self:_featureSummary()
		local b1 = 16
		local b2 = __Ixa_guiTouch and 44 or 38
		local b3 = self.Body
		local b4 = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 40,
				Parent = b3,
			}
		)
		local b6 = __Ixa_guiNew(
			"CanvasGroup",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 10),
				Size = UDim2.fromOffset(420, 460),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				GroupTransparency = 1,
				Active = true,
				Parent = b4,
			}
		)
		__Ixa_guiCorner(b6, UDim.new(0, 12))
		local b7 = __Ixa_guiStroke(b6, __Ixa_guiTheme.Stroke, 1)
		local b8 = __Ixa_guiNew("UIScale", { Scale = 0.94, Parent = b6 })
		local function b9()
			local ca = self.Scale.Scale
			local cb = b3.AbsoluteSize / ca
			b6.Size = UDim2.fromOffset(math.min(440, cb.X - 24), math.min(480, cb.Y - 24))
		end
		b9()
		local ca = b3:GetPropertyChangedSignal("AbsoluteSize"):Connect(b9)
		local cb = __Ixa_guiIcon(b6, "list-checks", __Ixa_guiTheme.Accent, UDim2.new(0, b1, 0, b1 + 10))
		cb.Size = UDim2.fromOffset(18, 18)
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(b1 + 28, b1),
			Size = UDim2.new(1, -(b1 * 2 + 28 + 36), 0, 18),
			Text = self._featuresTitle or "Features",
			TextSize = 15,
			Parent = b6,
		})
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(b1 + 28, b1 + 19),
			Size = UDim2.new(1, -(b1 * 2 + 28 + 36), 0, 14),
			Text = bZ,
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = b6,
		})
		local cc = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -(b1 - 6), 0, b1 - 6),
				Size = __Ixa_guiTouch and UDim2.fromOffset(40, 40) or UDim2.fromOffset(32, 32),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Parent = b6,
			}
		)
		__Ixa_guiCorner(cc, UDim.new(0, 8))
		local cd = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ScaleType = Enum.ScaleType.Fit,
				Parent = cc,
			}
		)
		__Ixa_guiApplyIcon(cd, "x")
		if cd.Image == "" then
			cd:Destroy()
			__Ixa_guiLabel({
				Size = UDim2.fromScale(1, 1),
				Text = "\u{d7}",
				TextSize = 20,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = cc,
			})
		end
		cc.MouseEnter:Connect(function()
			__Ixa_guiTween(cc, { BackgroundTransparency = 0.5 }, 0.12)
		end)
		cc.MouseLeave:Connect(function()
			__Ixa_guiTween(cc, { BackgroundTransparency = 1 }, 0.2)
		end)
		local ce = b1 + 44
		local cf = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(b1, ce),
				Size = UDim2.new(1, -b1 * 2, 0, __Ixa_guiTouch and 36 or 32),
				BackgroundColor3 = __Ixa_guiTheme.Surface,
				BorderSizePixel = 0,
				Parent = b6,
			}
		)
		__Ixa_guiCorner(cf, UDim.new(0, 7))
		local cg = __Ixa_guiStroke(cf)
		local ch, ci = __Ixa_guiIcon(cf, "search", __Ixa_guiTheme.Muted, UDim2.new(0, 10, 0.5, 0))
		ci.Parent.Size = UDim2.fromOffset(14, 14)
		local cj = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(32, 0),
				Size = UDim2.new(1, -40, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				PlaceholderText = "Search features",
				PlaceholderColor3 = __Ixa_guiTheme.Muted,
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ClearTextOnFocus = false,
				Parent = cf,
			}
		)
		cj.Focused:Connect(function()
			__Ixa_guiTween(cg, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			__Ixa_guiTween(ci, { ImageColor3 = __Ixa_guiTheme.Accent }, 0.15)
		end)
		cj.FocusLost:Connect(function()
			__Ixa_guiTween(cg, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			__Ixa_guiTween(ci, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.2)
		end)
		ce += (__Ixa_guiTouch and 36 or 32) + 10
		local ck = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Position = UDim2.fromOffset(b1, ce),
				Size = UDim2.new(1, -b1 * 2 + 6, 1, -(ce + b1 - 4)),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = __Ixa_guiTouch and 4 or 3,
				ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
				ScrollBarImageTransparency = 0.4,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = UDim2.new(),
				Parent = b6,
			}
		)
		local cl = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = ck }
		)
		local cm = __Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = cl })
		cm:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			ck.CanvasSize = UDim2.fromOffset(0, cm.AbsoluteContentSize.Y / self.Scale.Scale + 4)
		end)
		local cn = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 60),
			Text = b0 == 0 and "No features yet" or "No matches",
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Center,
			LayoutOrder = 0,
			Visible = b0 == 0,
			Parent = cl,
		})
		local co = {}
		local cp = false
		local cq = nil
		function co.Close()
			if cp then
				return
			end
			cp = true
			if self._dialog == co then
				self._dialog = nil
			end
			ca:Disconnect()
			if cq then
				task.defer(cq)
			end
			if cj:IsFocused() then
				cj:ReleaseFocus()
			end
			__Ixa_guiTween(b4, { BackgroundTransparency = 1 }, 0.18)
			__Ixa_guiTween(b6, { Position = UDim2.new(0.5, 0, 0.5, 8), GroupTransparency = 1 }, 0.18, Enum.EasingStyle.Quint)
			__Ixa_guiTween(b8, { Scale = 0.96 }, 0.18, Enum.EasingStyle.Quint)
			__Ixa_guiTween(b7, { Transparency = 1 }, 0.12)
			task.delay(0.2, function()
				b4:Destroy()
			end)
		end
		local cr = {}
		local cs = 0
		for ct, cu in ipairs(b_) do
			cs += 1
			local cv = __Ixa_guiNew(
				"Frame",
				{ Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = cs, Parent = cl }
			)
			local cw = __Ixa_guiIcon(cv, cu.Icon or "layout-grid", __Ixa_guiTheme.Accent, UDim2.new(0, 2, 0, 18))
			cw.Size = UDim2.fromOffset(14, 14)
			__Ixa_guiLabel({
				Position = UDim2.fromOffset(24, 10),
				Size = UDim2.new(1, -70, 0, 16),
				Text = string.upper(cu.Name),
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = cv,
			})
			local cx = __Ixa_guiLabel({
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -4, 0, 10),
				Size = UDim2.new(0, 40, 0, 16),
				Text = tostring(#cu.Items),
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = cv,
			})
			local cy = { Header = cv, Count = cx, Rows = {} }
			for cz, cA in ipairs(cu.Items) do
				cs += 1
				local cB = cA.Desc or cA.Path
				local cC = cA.Result ~= nil or type(cA.Callback) == "function"
				local cD = __Ixa_guiNew(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, cB and b2 + 4 or b2 - 4),
						BackgroundColor3 = __Ixa_guiTheme.Surface2,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Text = "",
						AutoButtonColor = false,
						LayoutOrder = cs,
						Parent = cl,
					}
				)
				__Ixa_guiCorner(cD, UDim.new(0, 8))
				local cE = __Ixa_guiIcon(cD, cA.Icon or self._searchIcons[cA.Kind] or "check", __Ixa_guiTheme.Muted, UDim2.new(0, 10, 0.5, 0))
				cE.Size = UDim2.fromOffset(14, 14)
				local cF = 12 + (cC and 22 or 0)
				local cG
				if cA.Tag then
					cG = __Ixa_guiNew(
						"Frame",
						{
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -(cC and 30 or 10), 0.5, 0),
							Size = UDim2.fromOffset(0, 20),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = __Ixa_guiTheme.Accent,
							BackgroundTransparency = 0.85,
							BorderSizePixel = 0,
							Parent = cD,
						}
					)
					__Ixa_guiCorner(cG, UDim.new(0, 5))
					__Ixa_guiPadding(cG, 7, 7)
					__Ixa_guiLabel({
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X,
						Text = tostring(cA.Tag),
						TextSize = 12,
						TextColor3 = __Ixa_guiTheme.Accent,
						TextTruncate = Enum.TextTruncate.None,
						Parent = cG,
					})
				end
				local cH = __Ixa_guiLabel({
					Position = UDim2.fromOffset(34, cB and 5 or 0),
					Size = UDim2.new(1, -(34 + cF), 0, cB and 18 or b2 - 4),
					Text = cA.Name,
					TextSize = 13,
					Parent = cD,
				})
				local cI
				if cB then
					cI = __Ixa_guiLabel({
						Position = UDim2.fromOffset(34, 23),
						Size = UDim2.new(1, -(34 + cF), 0, 14),
						Text = cB,
						TextSize = 12,
						FontFace = __Ixa_guiFonts.Regular,
						TextColor3 = __Ixa_guiTheme.Muted,
						Parent = cD,
					})
				end
				if cG then
					local function cJ()
						local cK = 34 + cF + cG.AbsoluteSize.X / self.Scale.Scale + 8
						cH.Size = UDim2.new(1, -cK, 0, cH.Size.Y.Offset)
						if cI then
							cI.Size = UDim2.new(1, -cK, 0, 14)
						end
					end
					cG:GetPropertyChangedSignal("AbsoluteSize"):Connect(cJ)
					task.defer(cJ)
				end
				if cC then
					local cJ = __Ixa_guiNew(
						"ImageLabel",
						{
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, -10, 0.5, 0),
							Size = UDim2.fromOffset(14, 14),
							BackgroundTransparency = 1,
							ImageColor3 = __Ixa_guiTheme.Muted,
							ImageTransparency = 0.4,
							ScaleType = Enum.ScaleType.Fit,
							Parent = cD,
						}
					)
					__Ixa_guiApplyIcon(cJ, "arrow-up-right")
				end
				local cJ = __Ixa_guiClickGuard(cD, function()
					return ck
				end)
				cD.MouseEnter:Connect(function()
					if not __Ixa_guiIsTouch() then
						__Ixa_guiTween(cD, { BackgroundTransparency = 0.3 }, 0.12)
					end
				end)
				cD.MouseLeave:Connect(function()
					__Ixa_guiTween(cD, { BackgroundTransparency = 1 }, 0.2)
				end)
				cD.MouseButton1Click:Connect(function()
					if not cC or not cJ() then
						return
					end
					co.Close()
					if cA.Result then
						self:_revealResult(cA.Result)
					end
					__Ixa_guiCall(cA.Callback)
				end)
				table.insert(cy.Rows, { Frame = cD, Key = __Ixa_searchLower(cA.Name .. " " .. (cB or "")) })
			end
			table.insert(cr, cy)
		end
		cj:GetPropertyChangedSignal("Text"):Connect(function()
			local ct = __Ixa_searchLower(cj.Text)
			local cu = false
			for cv, cw in ipairs(cr) do
				local cx = 0
				for cy, cz in ipairs(cw.Rows) do
					local cA = ct == "" or string.find(cz.Key, ct, 1, true) ~= nil
					cz.Frame.Visible = cA
					if cA then
						cx += 1
					end
				end
				cw.Header.Visible = cx > 0
				cw.Count.Text = tostring(cx)
				cu = cu or cx > 0
			end
			cn.Visible = not cu
			ck.CanvasPosition = Vector2.zero
		end)
		cc.MouseButton1Click:Connect(co.Close)
		b4.MouseButton1Click:Connect(co.Close)
		cq = self:_listen("Began", function(ct)
			if ct.KeyCode == Enum.KeyCode.Escape then
				co.Close()
			end
		end)
		self._dialog = co
		__Ixa_guiTween(b4, { BackgroundTransparency = 0.45 }, 0.25)
		__Ixa_guiTween(b6, { Position = UDim2.fromScale(0.5, 0.5), GroupTransparency = 0 }, 0.3, Enum.EasingStyle.Quint)
		__Ixa_guiTween(b8, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
		return co
	end
	function __Ixa_guiWindow:_homeStats(bZ, b_, b0, b1)
		local b2 = b_.Stats or { "Players", "Execs", "Session", "FPS", "Ping" }
		local b3 = self:_homeCard(bZ, b0)
		local b4 =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 76), BackgroundTransparency = 1, LayoutOrder = 1, Parent = b3 })
		__Ixa_guiNew(
			"UIGridLayout",
			{
				CellPadding = UDim2.fromOffset(28, 0),
				CellSize = UDim2.new(0.5, -14, 0, 76),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = b4,
			}
		)
		local b6 = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = __Ixa_guiTheme.Stroke, BorderSizePixel = 0, LayoutOrder = 2, Parent = b3 }
		)
		local b7 = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Parent = b3,
			}
		)
		__Ixa_guiPadding(b7, 0, 0, 12, 0)
		local b8 = __Ixa_guiNew(
			"UIGridLayout",
			{
				CellPadding = UDim2.fromOffset(0, 8),
				CellSize = UDim2.new(0.25, 0, 0, 36),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = b7,
			}
		)
		local b9, ca = {}, {}
		local cb, cc = 0, 0
		for cd, ce in ipairs(b2) do
			local cf = bH[ce]
			if cf and not b9[ce] then
				if ce == "FPS" or ce == "Ping" then
					cb += 1
					b9[ce], ca[ce] =
						self:_homeGraph(b4, cd, cf[1], cf[2], ce == "FPS" and 60 or 100, ce == "FPS" and "fps" or "ms")
				else
					cc += 1
					b9[ce] = self:_homeFigure(b7, cd, cf[2])
				end
			end
		end
		b4.Visible = cb > 0
		b7.Visible = cc > 0
		b6.Visible = cb > 0 and cc > 0
		if cb == 0 then
			__Ixa_guiPadding(b7, 0, 0, 0, 0)
		end
		local function cd()
			local ce = b7.AbsoluteSize.X / self.Scale.Scale
			local cf = math.clamp(cc, 1, ce >= 440 and 5 or 3)
			b8.CellSize = UDim2.new(1 / cf, 0, 0, 36)
		end
		b7:GetPropertyChangedSignal("AbsoluteSize"):Connect(cd)
		task.defer(cd)
		if b9.Executor then
			b9.Executor.Text = __Ixa_guiExecutor()
		end
		if b9.Game then
			b9.Game.Text = "Loading"
			task.spawn(function()
				b9.Game.Text = __Ixa_guiGameName()
			end)
		end
		if b9.Region then
			b9.Region.Text = "Loading"
			__Ixa_guiRegionUnavailable(function(ce)
				b9.Region.Text = ce
			end)
		end
		if b9.Execs then
			local ce = bI(b_.StatsFolder or self.ConfigFolder)
			b9.Execs.Text = ce and tostring(ce) or "\u{2014}"
		end
		if b9.Friends then
			local ce = {}
			local function cf()
				local cg = 0
				for ch, ci in ipairs(__Ixa_guiPlayers:GetPlayers()) do
					if ci ~= __Ixa_guiPlayer then
						local cj = ce[ci.UserId]
						if cj == nil then
							local ck, cl = pcall(function()
								return __Ixa_guiPlayer:IsFriendsWith(ci.UserId)
							end)
							cj = ck and cl == true
							ce[ci.UserId] = cj
						end
						if cj then
							cg += 1
						end
					end
				end
				b9.Friends.Text = tostring(cg)
			end
			task.spawn(cf)
			table.insert(
				self._connections,
				__Ixa_guiPlayers.PlayerAdded:Connect(function()
					task.spawn(cf)
				end)
			)
			table.insert(
				self._connections,
				__Ixa_guiPlayers.PlayerRemoving:Connect(function()
					task.defer(cf)
				end)
			)
		end
		local ce = b9.Session or b9.Uptime
		local cf = os.clock()
		local cg = 0
		self:_listen("Render", function()
			cg += 1
		end)
		local ch = b_.StatColors ~= false
		local function ci(cj, ck)
			if ch and cj.TextColor3 ~= ck then
				__Ixa_guiTween(cj, { TextColor3 = ck }, 0.3)
			end
		end
		return function()
			if b9.FPS then
				ca.FPS(cg, ch and __Ixa_guiLibrary._healthColor(cg, 50, 30) or __Ixa_guiTheme.Muted)
			end
			cg = 0
			if b9.Ping then
				local cj, ck = pcall(function()
					return math.floor(__Ixa_guiPlayer:GetNetworkPing() * 1000)
				end)
				ck = cj and ck or 0
				ca.Ping(ck, ch and __Ixa_guiLibrary._healthColor(ck, 90, 180, true) or __Ixa_guiTheme.Muted)
			end
			if b9.Players then
				b9.Players.Text = #__Ixa_guiPlayers:GetPlayers() .. "/" .. __Ixa_guiPlayers.MaxPlayers
			end
			if ce then
				ce.Text = bA(os.clock() - cf)
			end
			if b9.Time then
				b9.Time.Text = os.date(b_.TimeFormat or "%H:%M")
			end
			if b9.ServerAge then
				b9.ServerAge.Text = bA(workspace.DistributedGameTime)
			end
			if b9.Memory then
				local cj, ck = pcall(function()
					return __Ixa_guiStats:GetTotalMemoryUsageMb()
				end)
				b9.Memory.Text = cj and string.format("%d MB", ck) or "\u{2014}"
				ci(b9.Memory, cj and __Ixa_guiLibrary._healthColor(ck, 1500, 3000, true) or __Ixa_guiTheme.Text)
			end
		end, function()
			cg = 0
		end
	end
	local function bZ(b_, b0)
		local b1 = b_.List
		if type(b0.Content) == "string" then
			local b2 = bG(b1, 0, 1)
			b2.AutomaticSize = Enum.AutomaticSize.Y
			__Ixa_guiPadding(b2, 16, 16, 14, 16)
			__Ixa_guiLabel({
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = b0.Content,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = b2,
			})
		end
		if type(b0.Entries) == "table" then
			for b2, b3 in ipairs(b0.Entries) do
				local b4 = bG(b1, 0, b2 + 1)
				b4.AutomaticSize = Enum.AutomaticSize.Y
				__Ixa_guiPadding(b4, 16, 16, 14, 16)
				__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = b4 })
				local b6 = __Ixa_guiNew(
					"Frame",
					{ Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 1, Parent = b4 }
				)
				__Ixa_guiLabel({ Size = UDim2.new(1, -90, 1, 0), Text = b3.Title or b3.Version or "Update", TextSize = 15, Parent = b6 })
				if b3.Date or b3.Tag then
					local b7 = __Ixa_guiNew(
						"Frame",
						{
							AnchorPoint = Vector2.new(1, 0.5),
							Position = UDim2.new(1, 0, 0.5, 0),
							Size = UDim2.fromOffset(0, 20),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = __Ixa_guiTheme.Surface,
							BorderSizePixel = 0,
							Parent = b6,
						}
					)
					__Ixa_guiCorner(b7, UDim.new(0, 5))
					__Ixa_guiStroke(b7)
					__Ixa_guiPadding(b7, 8, 8)
					__Ixa_guiLabel({
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X,
						Text = b3.Tag or b3.Date,
						TextSize = 12,
						TextColor3 = __Ixa_guiTheme.Muted,
						TextTruncate = Enum.TextTruncate.None,
						Parent = b7,
					})
				end
				local b7 = b3.Content or b3.Body
				if type(b3.Changes) == "table" then
					b7 = "\u{2022} " .. table.concat(b3.Changes, "\n\u{2022} ")
				end
				if b7 then
					__Ixa_guiLabel({
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = b7,
						TextSize = 13,
						FontFace = __Ixa_guiFonts.Regular,
						TextColor3 = __Ixa_guiTheme.Muted,
						TextWrapped = true,
						TextTruncate = Enum.TextTruncate.None,
						TextYAlignment = Enum.TextYAlignment.Top,
						LayoutOrder = 2,
						Parent = b4,
					})
				end
			end
		end
		if type(b0.Build) == "function" then
			__Ixa_guiCall(b0.Build, b_, b1)
		else
			b_._noSearch = true
		end
	end
	function __Ixa_guiWindow:_buildHome(b_)
		self._hideName = b_.HideName == true
		self._hideAvatar = b_.HideAvatar == true
		self:_renderIdentity(true)
		local b0 = self:Tab({ Name = b_.Name or "Home", Desc = b_.Desc, Icon = b_.Icon or "house", PageTitle = b_.Title
			or "Home" })
		b0._order = 100
		self.Home = b0
		local b1 = b_.Pages or b_.Tabs
		local b2 = b0
		if type(b1) == "table" and #b1 > 0 then
			b2 = b0:SubTab({ Name = b_.OverviewName or "Overview", Icon = b_.TabIcon or "layout-grid" })
		end
		b2._noSearch = true
		b2._order = 100
		local b3 = b2.List
		local b4 = self:_homeProfile(b3, b_, 1)
		local b6, b7 = self:_homeStats(b3, b_, 2, b0)
		local b8 = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Parent = b3,
			}
		)
		local b9 =
			__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = b8 })
		local function ca(cb)
			local cc = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = cb,
					Parent = b8,
				}
			)
			__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = cc })
			return cc
		end
		local cb, cc = ca(1), ca(2)
		local cd = self:_homeGame(cb, 1)
		local ce, cf = self:_homeLinks(cc, b_, 1)
		if not ce then
			cc:Destroy()
		end
		local function cg()
			local ch = ce ~= nil and b8.AbsoluteSize.X / self.Scale.Scale >= 540
			b9.FillDirection = ch and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
			local ci = ch and UDim2.new(0.5, -5, 0, 0) or UDim2.new(1, 0, 0, 0)
			cb.Size = ci
			if ce then
				cc.Size = ci
			end
		end
		b8:GetPropertyChangedSignal("AbsoluteSize"):Connect(cg)
		task.defer(cg)
		self:_homeExecutor(b3, b_, 4)
		if type(b1) == "table" then
			for ch, ci in ipairs(b1) do
				bZ(b0:SubTab({ Name = ci.Name or ci.Title or "Page", Icon = ci.Icon }), ci)
			end
		end
		b4()
		b6()
		cd()
		task.spawn(function()
			while not self._destroyed and b0._page.Parent do
				task.wait(1)
				if self.Open and self.CurrentTab == b0 then
					b6()
					b4()
					cd()
					cf()
				else
					b7()
				end
			end
		end)
		return b0
	end
	function __Ixa_guiWindow:Tab(b_, b0)
		b_ = __Ixa_guiOptions(b_, { Title = "Name", Description = "Desc" })
		if b0 ~= nil and b_.Icon == nil then
			b_.Icon = b0
		end
		local b1 = setmetatable({ Name = b_.Name or "Tab", Window = self, _order = 0 }, __Ixa_guiGroup)
		local b2 = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.new(1, 0, 0, __Ixa_guiTabHeight),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				LayoutOrder = #self.Tabs + 1,
				Parent = self._tabStack,
			}
		)
		__Ixa_guiCorner(b2, UDim.new(0, 7))
		local b3 = __Ixa_guiStroke(b2, __Ixa_guiTheme.Stroke, 1)
		b3.Enabled = false
		b1._button = b2
		local b4 = b_.Icon ~= nil
		if b4 then
			local b6 = __Ixa_guiNew(
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0, 20, 0.5, 0),
					Size = UDim2.fromOffset(16, 16),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Muted,
					ScaleType = Enum.ScaleType.Fit,
					Parent = b2,
				}
			)
			__Ixa_guiApplyIcon(b6, b_.Icon)
			if b6:GetAttribute("CustomIcon") then
				b6.ImageTransparency = 0.4
			end
			b1._icon = b6
		end
		b1._label = __Ixa_guiLabel({
			Position = UDim2.fromOffset(b4 and 38 or 14, 0),
			Size = UDim2.new(1, b4 and -46 or -22, 1, 0),
			Text = b1.Name,
			TextSize = 13,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = b2,
		})
		local b6 = __Ixa_guiNew(
			"Frame",
			{ Name = b1.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = self.Content }
		)
		b1._page = b6
		local b7 = 24
		if b4 then
			local b8 = __Ixa_guiIcon(b6, b_.Icon, __Ixa_guiTheme.Accent, UDim2.new(0, 24, 0, 32))
			b8.Size = UDim2.fromOffset(20, 20)
			b7 = 54
		end
		b1._titleX = b7
		b1._title = __Ixa_guiLabel({
			Position = UDim2.fromOffset(b7, 20),
			Size = UDim2.new(1, -b7, 0, 24),
			Text = b_.PageTitle or b1.Name,
			TextSize = 22,
			Parent = b6,
		})
		if b_.Desc then
			b1._desc = __Ixa_guiLabel({
				Position = UDim2.fromOffset(b7, 44),
				Size = UDim2.new(1, -b7, 0, 16),
				Text = b_.Desc,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = b6,
			})
		end
		local b8 = b_.Desc and 70 or 58
		b1._headerBottom = b8
		b1._iconName = b_.Icon
		bJ(b1, b6, b8, b_.Icon or "layout-grid", b_.EmptyText or "Nothing here yet")
		local b9 = __Ixa_guiNew("UIScale", { Parent = b2 })
		local function ca()
			__Ixa_guiTween(b9, { Scale = 1 }, 0.3, Enum.EasingStyle.Quint)
		end
		b2.MouseEnter:Connect(function()
			if self.CurrentTab ~= b1 and not __Ixa_guiIsTouch() then
				__Ixa_guiTween(b2, { BackgroundTransparency = 0.75 }, 0.2, Enum.EasingStyle.Quint)
				__Ixa_guiTween(b1._label, { TextColor3 = __Ixa_guiTheme.Text }, 0.2)
				if b1._icon then
					__Ixa_guiTintIcon(b1._icon, __Ixa_guiTheme.Text, true, 0.2)
				end
			end
		end)
		b2.MouseLeave:Connect(function()
			ca()
			if self.CurrentTab ~= b1 then
				__Ixa_guiTween(b2, { BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Quint)
				__Ixa_guiTween(b1._label, { TextColor3 = __Ixa_guiTheme.Muted }, 0.3)
				if b1._icon then
					__Ixa_guiTintIcon(b1._icon, __Ixa_guiTheme.Muted, false, 0.3)
				end
			end
		end)
		b2.MouseButton1Down:Connect(function()
			__Ixa_guiTween(b9, { Scale = 0.97 }, 0.15, Enum.EasingStyle.Quint)
		end)
		b2.MouseButton1Up:Connect(ca)
		local cb = __Ixa_guiClickGuard(b2, function()
			return self.TabList
		end)
		b2.MouseButton1Click:Connect(function()
			ca()
			if cb() then
				self:SelectTab(b1)
			end
		end)
		b1._stroke = b3
		self:_fitTitle(b1)
		if not self._introDone then
			b2.Visible = false
		end
		table.insert(self.Tabs, b1)
		if #self.Tabs == 1 then
			task.defer(function()
				if not self.CurrentTab then
					self:SelectTab(b1)
				end
			end)
		end
		return b1
	end
	__Ixa_guiWindow.CreateTab = __Ixa_guiWindow.Tab
	function __Ixa_guiWindow:CloudConfigs(b_)
		b_ = __Ixa_guiOptions(b_, { Title = "Name", Description = "Desc" })
		local b0 = self
		local b1 =
			self:Tab({ Name = b_.Name or "Cloud", Desc = b_.Desc, Icon = b_.Icon or "cloud", PageTitle = b_.PageTitle })
		b1._noSearch = true
		b1.List.Visible = false
		if b1._empty then
			b1._empty:Destroy()
			b1._empty = nil
		end
		local b2 = 116
		local b3 = __Ixa_guiTouch and 36 or 32
		local b4 = __Ixa_guiTouch and 30 or 26
		local b6 = { "Popular", "New", "Top", "Installs" }
		local b7 = { Popular = "Popular", New = "Newest", Top = "Top rated", Installs = "Most installed" }
		local b8 = { "All", "Favorites", "Mine", "Installed" }
		local b9 = 40
		local ca = math.max(math.floor(tonumber(b_.DescriptionLimit) or 300), 20)
		local cb = math.max(math.floor(tonumber(b_.PageSize) or 20), 1)
		local cc = type(b_.Tags) == "table" and b_.Tags or {}
		local cd = math.max(math.floor(tonumber(b_.MaxTags) or 3), 0)
		local ce = tostring(b_.StreamerName or "Ouroboros User")
		local cf = { Tab = b1 }
		local cg, ch = {}, {}
		local ci = {}
		local cj, ck, cl = false, 0, 0
		local cm = false
		local cn = { Search = "", Sort = "Popular", Filter = "All", Tag = nil }
		local co, cp = {}, nil
		local cq, cr, cs = {}, nil, 0
		local ct = b0:_readConfigSettings()
		local cu = type(ct.CloudFavorites) == "table" and ct.CloudFavorites or {}
		local cv = type(ct.CloudInstalled) == "table" and ct.CloudInstalled or {}
		if table.find(b6, ct.CloudSort) then
			cn.Sort = ct.CloudSort
		elseif table.find(b6, b_.Sort) then
			cn.Sort = b_.Sort
		end
		local function cw(cx, cy)
			b0:_writeConfigSettings({ [cx] = cy })
		end
		local function cx(cy, cz, cA)
			b0:Notify({ Title = cz, Content = cA, Type = cy and "Success" or "Error", Duration = 3 })
		end
		local function cy()
			return b0._hideName == true
		end
		local function cz(cA)
			local cB = type(cA) == "string" and b0:DecodeConfig(cA)
			if not cB then
				return nil
			end
			local cC = 0
			for cD in pairs(cB) do
				cC += 1
			end
			return cC
		end
		local function cA(cB)
			cB = math.max(math.floor(tonumber(cB) or 0), 0)
			if cB >= 1e6 then
				return (("%.1f"):format(cB / 1e6):gsub("%.0$", "")) .. "m"
			elseif cB >= 1e3 then
				return (("%.1f"):format(cB / 1e3):gsub("%.0$", "")) .. "k"
			end
			return tostring(cB)
		end
		local function cB(cC)
			cC = tonumber(cC)
			if not cC then
				return nil
			end
			local cD = os.time() - cC
			if cD < 60 then
				return "just now"
			elseif cD < 3600 then
				return math.floor(cD / 60) .. "m ago"
			elseif cD < 86400 then
				return math.floor(cD / 3600) .. "h ago"
			elseif cD < 604800 then
				return math.floor(cD / 86400) .. "d ago"
			elseif cD < 2592000 then
				return math.floor(cD / 604800) .. "w ago"
			end
			return os.date("%d %b %Y", cC)
		end
		local function cC(cD)
			return (cD:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"):gsub("'", "&apos;"))
		end
		local function cD(cE)
			local cF = string.lower(cn.Search)
			if cF == "" then
				return cC(cE)
			end
			local cG = string.lower(cE)
			local cH = bc(__Ixa_guiTheme.Accent)
			local cI, cJ = {}, 1
			while true do
				local cK, cL = string.find(cG, cF, cJ, true)
				if not cK then
					break
				end
				table.insert(cI, cC(cE:sub(cJ, cK - 1)))
				table.insert(cI, ('<font color="#%s"><b>%s</b></font>'):format(cH, cC(cE:sub(cK, cL))))
				cJ = cL + 1
			end
			table.insert(cI, cC(cE:sub(cJ)))
			return table.concat(cI)
		end
		local function cE(cF)
			if type(cF) ~= "table" then
				return nil
			end
			local cG = cF.Id ~= nil and tostring(cF.Id) or __Ixa_guiHttpService:GenerateGUID(false)
			local cH = ch[cG] or { Id = cG }
			for cI, cJ in pairs(cF) do
				if cI ~= "Id" then
					cH[cI] = cJ
				end
			end
			cH.Name = tostring(cH.Name or "Untitled")
			cH.Author = tostring(cH.Author or "Unknown")
			cH.Description = cH.Description ~= nil and tostring(cH.Description) or ""
			local cI = {}
			for cJ, cK in ipairs(type(cH.Tags) == "table" and cH.Tags or {}) do
				table.insert(cI, tostring(cK))
			end
			cH.Tags = cI
			cH.Installs = tonumber(cH.Installs) or 0
			cH.Likes = tonumber(cH.Likes) or 0
			cH.Updated = tonumber(cH.Updated or cH.Created)
			cH.Liked = cH.Liked == true
			if type(cH.Code) ~= "string" or cH.Code == "" then
				cH.Code = nil
			end
			cH.Count = tonumber(cH.Count) or cz(cH.Code)
			cH.Mine = cH.Mine == true or tonumber(cH.AuthorId) == __Ixa_guiPlayer.UserId or tonumber(cH.OwnerId) == __Ixa_guiPlayer.UserId
			ch[cG] = cH
			return cH
		end
		local function cF(cG)
			return {
				Id = cG.Id,
				Name = cG.Name,
				Description = cG.Description,
				Author = cG.Author,
				AuthorId = cG.AuthorId,
				Tags = table.clone(cG.Tags),
				Installs = cG.Installs,
				Likes = cG.Likes,
				Liked = cG.Liked,
				Updated = cG.Updated,
				Code = cG.Code,
				Count = cG.Count,
				Folder = cG.Folder,
				Mine = cG.Mine,
			}
		end
		local function cG(cH)
			local cI = cF(cH)
			cI.Code = nil
			cI.Liked = nil
			return cI
		end
		local function cH(cI)
			local cJ = cv[cI.Id]
			if type(cJ) ~= "table" then
				return nil
			end
			if cI.Updated and tonumber(cJ.Updated) and cI.Updated > tonumber(cJ.Updated) then
				return "Update"
			end
			return "Installed"
		end
		local function cI(cJ)
			return type(cJ.Folder) == "string" and cJ.Folder ~= b0.ConfigFolder
		end
		local function cJ(cK, cL, cM, cN, cO)
			local cP = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.fromOffset(cN, cN),
					BackgroundColor3 = __Ixa_guiTheme.Surface2,
					BackgroundTransparency = cO and 1 or 0,
					Text = "",
					AutoButtonColor = false,
					Parent = cK,
				}
			)
			__Ixa_guiCorner(cP, UDim.new(0, 8))
			if not cO then
				__Ixa_guiHoverStroke(cP, __Ixa_guiStroke(cP))
			end
			local cQ = __Ixa_guiNew(
				"ImageLabel",
				{
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(15, 15),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Muted,
					ScaleType = Enum.ScaleType.Fit,
					Parent = cP,
				}
			)
			__Ixa_guiApplyIcon(cQ, cL)
			if cQ.Image == "" then
				cQ:Destroy()
				cQ = __Ixa_guiLabel({
					Size = UDim2.fromScale(1, 1),
					Text = cM,
					TextSize = 15,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextTruncate = Enum.TextTruncate.None,
					Parent = cP,
				})
			end
			return cP, cQ
		end
		local function cK(cL, cM)
			__Ixa_guiTween(cL, { BackgroundColor3 = __Ixa_guiTheme.Accent, BackgroundTransparency = 0.12 }, 0)
			__Ixa_guiTween(cM, { TextColor3 = __Ixa_guiTheme.AccentDark }, 0)
			cM.FontFace = __Ixa_guiFonts.Bold
		end
		local function cL(cM)
			for cN, cO in ipairs(cM:GetChildren()) do
				if cO:IsA("GuiObject") then
					cO:Destroy()
				end
			end
		end
		local function cM(cN, cO, cP, cQ)
			local cR = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.fromOffset(0, b4),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = __Ixa_guiTheme.Surface2,
					Text = "",
					AutoButtonColor = false,
					LayoutOrder = cP,
					Parent = cN,
				}
			)
			cR:SetAttribute("NoDrag", true)
			__Ixa_guiCorner(cR, UDim.new(1, 0))
			local cS = __Ixa_guiStroke(cR)
			__Ixa_guiPadding(cR, 12, 12)
			local cT = __Ixa_guiLabel({
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = cO,
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextTruncate = Enum.TextTruncate.None,
				Parent = cR,
			})
			local cU = { Button = cR, Label = cT }
			function cU.Set(cV, cW)
				local cX = cW and 0 or 0.15
				__Ixa_guiTween(cR, { BackgroundColor3 = cV and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface2 }, cX)
				__Ixa_guiTween(cT, { TextColor3 = cV and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Muted }, cX)
				__Ixa_guiTween(cS, { Transparency = cV and 1 or 0 }, cX)
			end
			if cQ then
				cR.MouseButton1Click:Connect(cQ)
			else
				cR.Active = false
			end
			return cU
		end
		local function cN(cO, cP, cQ)
			local cR = __Ixa_guiLabel({
				Size = UDim2.fromOffset(0, 18),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BackgroundTransparency = 0.2,
				Text = cP,
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = cQ,
				Parent = cO,
			})
			__Ixa_guiCorner(cR, UDim.new(0, 5))
			__Ixa_guiPadding(cR, 7, 7)
			return cR
		end
		local function cO(cP, cQ, cR)
			return __Ixa_guiNew(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, cQ),
					Wraps = cR == true,
					Parent = cP,
				}
			)
		end
		local function cP(cQ, cR)
			return __Ixa_guiNew(
				"UIListLayout",
				{ SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, cR), Parent = cQ }
			)
		end
		local function cQ(cR, cS, cT, cU, cV, cW)
			return __Ixa_guiLabel({
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = cS,
				TextSize = cT,
				FontFace = cW or __Ixa_guiFonts.Regular,
				TextColor3 = cU or __Ixa_guiTheme.Text,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = cV,
				Parent = cR,
			})
		end
		local function cR(cS, cT)
			local cU = __Ixa_guiNew(
				"ScrollingFrame",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 3,
					ScrollBarImageColor3 = __Ixa_guiTheme.Accent,
					ScrollBarImageTransparency = 0.4,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(),
					Visible = cT ~= false,
					Parent = cS,
				}
			)
			cU:SetAttribute("NoDrag", true)
			return cU
		end
		local function cS(cT, cU, cV, cW, cX)
			local cY = cW > b3
			local cZ = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, cW),
					BackgroundColor3 = __Ixa_guiTheme.Surface,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					LayoutOrder = cU,
					Parent = cT,
				}
			)
			__Ixa_guiCorner(cZ, UDim.new(0, 8))
			local c_ = __Ixa_guiStroke(cZ)
			local c0 = __Ixa_guiNew(
				"TextBox",
				{
					Position = UDim2.fromOffset(10, cY and 8 or 0),
					Size = UDim2.new(1, -20, 1, cY and -24 or 0),
					BackgroundTransparency = 1,
					Text = "",
					PlaceholderText = cV,
					PlaceholderColor3 = __Ixa_guiTheme.Muted,
					TextColor3 = __Ixa_guiTheme.Text,
					TextSize = 13,
					FontFace = __Ixa_guiFonts.Regular,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = cY and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
					MultiLine = cY,
					TextWrapped = cY,
					ClearTextOnFocus = false,
					Parent = cZ,
				}
			)
			local c1 = cY
				and __Ixa_guiLabel({
					AnchorPoint = Vector2.new(1, 1),
					Position = UDim2.new(1, -10, 1, -4),
					Size = UDim2.fromOffset(0, 14),
					AutomaticSize = Enum.AutomaticSize.X,
					Text = "",
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Regular,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextTruncate = Enum.TextTruncate.None,
					Parent = cZ,
				})
			c0.Focused:Connect(function()
				__Ixa_guiTween(c_, { Color = __Ixa_guiTheme.StrokeHover }, 0.15)
			end)
			c0.FocusLost:Connect(function()
				__Ixa_guiTween(c_, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			end)
			c0:GetPropertyChangedSignal("Text"):Connect(function()
				local c2 = c0.Text
				local c3 = utf8.len(c2) or #c2
				if cX and c3 > cX then
					local c4 = utf8.offset(c2, cX + 1)
					c0.Text = c4 and c2:sub(1, c4 - 1) or c2:sub(1, cX)
					return
				end
				if c1 then
					c1.Text = cX and (c3 .. "/" .. cX) or ""
				end
			end)
			if c1 and cX then
				c1.Text = "0/" .. cX
			end
			return c0, c_
		end
		local function cT(cU)
			cU = bM((tostring(cU or ""):gsub('[\\/:%*%?"<>|]', "")))
			if cU == "" then
				cU = "Cloud config"
			end
			local cV, cW = cU, 2
			while b0:ConfigExists(cV) do
				cV = ("%s (%d)"):format(cU, cW)
				cW += 1
			end
			return cV
		end
		local cU = b1._headerBottom
		local cV = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(23, cU - 1),
				Size = UDim2.new(1, -46, 1, -(cU + 14)),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Parent = b1._page,
			}
		)
		for cW, cX in ipairs({ "Browse", "Detail", "Publish" }) do
			co[cX] =
				__Ixa_guiNew("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = cV })
			__Ixa_guiPadding(co[cX], 1, 1, 1, 1)
		end
		local function cW(cX)
			if cp == cX then
				return
			end
			local cY = cp
			cp = cX
			if cY then
				cY.Visible = false
			end
			local cZ = cX == co.Browse and -24 or 24
			cX.Position = UDim2.fromOffset(cZ, 0)
			cX.Visible = true
			__Ixa_guiTween(cX, { Position = UDim2.fromOffset(0, 0) }, 0.3, Enum.EasingStyle.Quint)
		end
		local cX = co.Browse
		local cY = __Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, b3), BackgroundTransparency = 1, Parent = cX })
		local cZ, c_ = bF(
			cY,
			"Publish",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
			},
			function()
				cf:OpenPublish()
			end
		)
		cK(cZ, c_)
		cZ.Visible = type(b_.OnPublish) == "function"
		local c0, c1 = cJ(cY, "refresh-cw", "R", b3)
		c0.AnchorPoint = Vector2.new(1, 0)
		local c2 = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, -(b3 + 8), 1, 0), BackgroundColor3 = __Ixa_guiTheme.Surface2, BorderSizePixel = 0, Parent = cY }
		)
		__Ixa_guiCorner(c2, UDim.new(0, 8))
		local c3 = __Ixa_guiStroke(c2)
		local c4, c5 = __Ixa_guiIcon(c2, "search", __Ixa_guiTheme.Muted, UDim2.new(0, 10, 0.5, 0))
		c4.Size = UDim2.fromOffset(14, 14)
		local c6 = __Ixa_guiNew(
			"TextBox",
			{
				Position = UDim2.fromOffset(32, 0),
				Size = UDim2.new(1, -62, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				PlaceholderText = b_.SearchPlaceholder or (__Ixa_guiTouch and "Search configs..." or "Search configs...   ( / )"),
				PlaceholderColor3 = __Ixa_guiTheme.Muted,
				TextColor3 = __Ixa_guiTheme.Text,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				ClipsDescendants = true,
				Parent = c2,
			}
		)
		local c7 = cJ(c2, "x", "x", 24, true)
		c7.AnchorPoint = Vector2.new(1, 0.5)
		c7.Position = UDim2.new(1, -4, 0.5, 0)
		c7.Visible = false
		local c8
		local c9 = 0
		local da = type(ct.CloudRecent) == "table" and ct.CloudRecent or {}
		local db = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(0, b3 + 4),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = __Ixa_guiTheme.Surface2,
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 5,
				Parent = cX,
			}
		)
		__Ixa_guiCorner(db, UDim.new(0, 8))
		__Ixa_guiStroke(db)
		__Ixa_guiPadding(db, 6, 6, 6, 6)
		cP(db, 2)
		local function dc(dd)
			dd = bM(dd)
			if #dd < 2 then
				return
			end
			for de = #da, 1, -1 do
				if string.lower(da[de]) == string.lower(dd) then
					table.remove(da, de)
				end
			end
			table.insert(da, 1, dd)
			while #da > 6 do
				table.remove(da)
			end
			cw("CloudRecent", da)
		end
		local function dd(de)
			de = de and #da > 0 and c6.Text == ""
			if de == db.Visible then
				return
			end
			db.Visible = de
			if not de then
				return
			end
			cL(db)
			local df =
				__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 0, Parent = db })
			__Ixa_guiLabel({
				Position = UDim2.fromOffset(8, 0),
				Size = UDim2.new(1, -60, 1, 0),
				Text = "Recent searches",
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = df,
			})
			local dg = __Ixa_guiNew(
				"TextButton",
				{
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -6, 0, 0),
					Size = UDim2.fromOffset(0, 20),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Text = "Clear",
					TextSize = 12,
					FontFace = __Ixa_guiFonts.Medium,
					TextColor3 = __Ixa_guiTheme.Accent,
					AutoButtonColor = false,
					Parent = df,
				}
			)
			dg.MouseButton1Down:Connect(function()
				da = {}
				cw("CloudRecent", da)
				dd(false)
			end)
			for dh, di in ipairs(da) do
				local dj = __Ixa_guiNew(
					"TextButton",
					{
						Size = UDim2.new(1, 0, 0, __Ixa_guiTouch and 32 or 28),
						BackgroundColor3 = __Ixa_guiTheme.Surface3,
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						LayoutOrder = dh,
						Parent = db,
					}
				)
				__Ixa_guiCorner(dj, UDim.new(0, 6))
				local dk = __Ixa_guiIcon(dj, "history", __Ixa_guiTheme.Muted, UDim2.new(0, 8, 0.5, 0))
				dk.Size = UDim2.fromOffset(13, 13)
				__Ixa_guiLabel({
					Position = UDim2.fromOffset(28, 0),
					Size = UDim2.new(1, -34, 1, 0),
					Text = di,
					TextSize = 13,
					FontFace = __Ixa_guiFonts.Regular,
					Parent = dj,
				})
				dj.MouseEnter:Connect(function()
					__Ixa_guiTween(dj, { BackgroundTransparency = 0.5 }, 0.1)
				end)
				dj.MouseLeave:Connect(function()
					__Ixa_guiTween(dj, { BackgroundTransparency = 1 }, 0.15)
				end)
				dj.MouseButton1Down:Connect(function()
					c9 += 1
					c6.Text = di
					cn.Search = di
					dc(di)
					dd(false)
					c6:ReleaseFocus()
					c8(false)
				end)
			end
		end
		local function de()
			local df = b0.Scale.Scale
			local dg = cZ.Visible and (cZ.AbsoluteSize.X / df + 8) or 0
			c0.Position = UDim2.new(1, -dg, 0, 0)
			c2.Size = UDim2.new(1, -(dg + b3 + 8), 1, 0)
			db.Size = UDim2.new(1, -(dg + b3 + 8), 0, 0)
		end
		cZ:GetPropertyChangedSignal("AbsoluteSize"):Connect(de)
		task.defer(de)
		local df = __Ixa_guiNew(
			"Frame",
			{ Position = UDim2.fromOffset(0, b3 + 7), Size = UDim2.new(1, 0, 0, b4 + 2), BackgroundTransparency = 1, Parent = cX }
		)
		local dg = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -1, 0, 1),
				Size = UDim2.fromOffset(0, b4),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = __Ixa_guiTheme.Surface2,
				Text = "",
				AutoButtonColor = false,
				Parent = df,
			}
		)
		__Ixa_guiCorner(dg, UDim.new(1, 0))
		__Ixa_guiHoverStroke(dg, __Ixa_guiStroke(dg))
		__Ixa_guiPadding(dg, 10, 12)
		cO(dg, 6)
		local dh = __Ixa_guiIcon(dg, "arrow-down-up", __Ixa_guiTheme.Accent, UDim2.new())
		dh.Size = UDim2.fromOffset(13, 13)
		local di = __Ixa_guiLabel({
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = b7[cn.Sort],
			TextSize = 12,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 2,
			Parent = dg,
		})
		local dj = __Ixa_guiNew(
			"ScrollingFrame",
			{
				Size = UDim2.new(1, -120, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.X,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.new(),
				Parent = df,
			}
		)
		dj:SetAttribute("NoDrag", true)
		cO(dj, 6)
		__Ixa_guiPadding(dj, 1, 1, 1, 1)
		local function dk()
			local dl = dg.AbsoluteSize.X / b0.Scale.Scale
			dj.Size = UDim2.new(1, -(dl + 8), 1, 0)
		end
		dg:GetPropertyChangedSignal("AbsoluteSize"):Connect(dk)
		task.defer(dk)
		local dl = b3 + 8 + b4 + 10
		local dm = cR(cX)
		dm.Position = UDim2.fromOffset(0, dl)
		dm.Size = UDim2.new(1, 0, 1, -dl)
		__Ixa_guiPadding(dm, 1, 6, 1, 12)
		cP(dm, 10)
		local dn =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = 0, Parent = dm })
		local dp = __Ixa_guiLabel({
			Size = UDim2.new(1, -100, 1, 0),
			Text = "",
			RichText = true,
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = dn,
		})
		local dq = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.fromOffset(0, 16),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Text = "Clear filters",
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Medium,
				TextColor3 = __Ixa_guiTheme.Accent,
				AutoButtonColor = false,
				Visible = false,
				Parent = dn,
			}
		)
		local dr
		local function ds()
			return cn.Search ~= "" or cn.Tag ~= nil or cn.Filter ~= "All"
		end
		local function dt(du)
			local dv = {}
			if cn.Filter ~= "All" then
				table.insert(dv, "in " .. cn.Filter)
			end
			if cn.Tag then
				table.insert(dv, "tagged " .. cC(cn.Tag))
			end
			if cn.Search ~= "" then
				table.insert(dv, ('matching <font color="#%s">"%s"</font>'):format(bc(__Ixa_guiTheme.Accent), cC(cn.Search)))
			end
			local dw = #dv > 0 and (" " .. table.concat(dv, ", ")) or ""
			if du or (cm and #cg == 0) then
				dp.Text = "Searching" .. dw .. "..."
			else
				local dx = #cg
				dp.Text = ("%d%s config%s%s"):format(dx, cj and "+" or "", (dx == 1 and not cj) and "" or "s", dw)
			end
			dq.Visible = ds()
		end
		local du = nil
		local function dv(dw)
			cm = dw
			if dw and not du then
				c1.Rotation = 0
				du = __Ixa_guiTweenService:Create(
					c1,
					TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1),
					{ Rotation = 360 }
				)
				du:Play()
			elseif not dw and du then
				du:Cancel()
				du = nil
				__Ixa_guiTween(c1, { Rotation = 360 }, 0.35, Enum.EasingStyle.Quint)
			end
			dt()
		end
		local dw = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Parent = dm,
			}
		)
		local dx = __Ixa_guiNew(
			"UIGridLayout",
			{
				CellSize = UDim2.new(1, 0, 0, b2),
				CellPadding = UDim2.fromOffset(8, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = dw,
			}
		)
		local function dy()
			local dz = dm.AbsoluteSize.X / b0.Scale.Scale
			local dA = dz >= 620 and 2 or 1
			dx.CellSize = UDim2.new(1 / dA, -(dA - 1) * 8 / dA, 0, b2)
		end
		dm:GetPropertyChangedSignal("AbsoluteSize"):Connect(dy)
		task.defer(dy)
		local dz = bF(dm, "Load more", { Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 2, Visible = false }, function()
			cf:LoadMore()
		end)
		local dA = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 180), BackgroundTransparency = 1, Visible = false, LayoutOrder = 3, Parent = dm }
		)
		local dB = {}
		local function dC(dD)
			for dE = 1, dD do
				local dF = __Ixa_guiNew(
					"Frame",
					{ BackgroundColor3 = __Ixa_guiTheme.Surface2, BorderSizePixel = 0, LayoutOrder = 100000 + #dB, Parent = dw }
				)
				__Ixa_guiCorner(dF, UDim.new(0, 10))
				__Ixa_guiStroke(dF)
				for dG, dH in ipairs({ { 14, 0.45 }, { 36, 0.3 }, { 58, 0.8 }, { 76, 0.6 } }) do
					local dI = __Ixa_guiNew(
						"Frame",
						{
							Position = UDim2.fromOffset(14, dH[1]),
							Size = UDim2.new(dH[2], -14, 0, dG == 1 and 14 or 10),
							BackgroundColor3 = __Ixa_guiTheme.Surface3,
							BorderSizePixel = 0,
							Parent = dF,
						}
					)
					__Ixa_guiCorner(dI, UDim.new(0, 4))
					__Ixa_guiTweenService:Create(
						dI,
						TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
						{ BackgroundTransparency = 0.65 }
					):Play()
				end
				table.insert(dB, dF)
			end
		end
		local function dD()
			for dE, dF in ipairs(dB) do
				dF:Destroy()
			end
			dB = {}
		end
		local function dE(dF, dG)
			cL(dA)
			dA.Visible = dF ~= nil
			if not dF then
				return
			end
			local dH, dI = by(dA, dF == "error" and "cloud-off" or "search-x", dG)
			dH.Size = UDim2.fromOffset(280, 70)
			dH.Position = UDim2.new(0.5, 0, 0, 60)
			dI.TextWrapped = true
			dI.TextTruncate = Enum.TextTruncate.None
			dI.Size = UDim2.new(1, 0, 0, 32)
			if dF == "error" or ds() then
				bF(
					dA,
					dF == "error" and "Try again" or "Clear filters",
					{
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, 0, 132),
						Size = UDim2.fromOffset(0, 30),
						AutomaticSize = Enum.AutomaticSize.X,
					},
					function()
						if dF == "error" then
							cf:Refresh()
						else
							dr()
						end
					end
				)
			end
			dt()
		end
		local dF, dG, dH
		local function dI(dJ)
			local dK = dJ.Record
			dJ.Title.Text = cD(dK.Name)
			local dL = { "by " .. dK.Author }
			local dM = cB(dK.Updated)
			if dM then
				table.insert(dL, dM)
			end
			if dK.Count then
				table.insert(dL, dK.Count .. (dK.Count == 1 and " setting" or " settings"))
			end
			dJ.Meta.Text = table.concat(dL, "  \u{b7}  ")
			dJ.Desc.Text = dK.Description ~= "" and cD(dK.Description) or "No description"
			dJ.Desc.TextTransparency = dK.Description ~= "" and 0.2 or 0.55
			dJ.Likes.Text = cA(dK.Likes)
			dJ.Installs.Text = cA(dK.Installs)
			__Ixa_guiTween(dJ.Heart, { ImageColor3 = dK.Liked and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted }, 0.15)
			local dN = cH(dK)
			local dO, dP
			if dN == "Update" then
				dO, dP = "UPDATE", __Ixa_guiTheme.Accent
			elseif dN == "Installed" then
				dO, dP = "INSTALLED", __Ixa_guiTheme.Success
			elseif dK.Mine then
				dO, dP = "YOURS", __Ixa_guiTheme.Accent
			elseif cI(dK) then
				dO, dP = "OTHER SCRIPT", __Ixa_guiTheme.Warning
			end
			dJ.Badge.Visible = dO ~= nil
			if dO then
				dJ.Badge.Text = dO
				__Ixa_guiTween(dJ.Badge, { TextColor3 = dP, BackgroundColor3 = dP }, 0)
			end
			dJ.Star.Visible = cu[dK.Id] ~= nil
			dJ.InstallText.Text = dN == "Update" and "Update" or (dN == "Installed" and "Reinstall" or "Install")
			cL(dJ.TagRow)
			for dQ, dR in ipairs(dK.Tags) do
				if dQ > 3 then
					cN(dJ.TagRow, "+" .. (#dK.Tags - 3), dQ)
					break
				end
				cN(dJ.TagRow, dR, dQ)
			end
		end
		local function dJ(dK, dL)
			local dM = __Ixa_guiNew(
				"TextButton",
				{ BackgroundColor3 = __Ixa_guiTheme.Surface2, BorderSizePixel = 0, Text = "", AutoButtonColor = false, LayoutOrder = dL, Parent = dw }
			)
			dM:SetAttribute("NoDrag", true)
			__Ixa_guiCorner(dM, UDim.new(0, 10))
			__Ixa_guiHoverStroke(dM, __Ixa_guiStroke(dM))
			__Ixa_guiPadding(dM, 14, 14, 12, 12)
			local dN = { Record = dK, Frame = dM }
			dN.Title =
				__Ixa_guiLabel({ Size = UDim2.new(1, -110, 0, 18), RichText = true, TextSize = 14, FontFace = __Ixa_guiFonts.Bold, Parent = dM })
			local dO = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.fromScale(1, 0),
					Size = UDim2.fromOffset(0, 18),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Parent = dM,
				}
			)
			local dP = cO(dO, 6)
			dP.HorizontalAlignment = Enum.HorizontalAlignment.Right
			dN.Star = __Ixa_guiLabel({
				Size = UDim2.fromOffset(14, 18),
				Text = "\u{2605}",
				TextSize = 13,
				TextColor3 = __Ixa_guiTheme.Accent,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 1,
				Parent = dO,
			})
			dN.Badge = __Ixa_guiLabel({
				Size = UDim2.fromOffset(0, 17),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 0.85,
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Bold,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 2,
				Parent = dO,
			})
			__Ixa_guiCorner(dN.Badge, UDim.new(0, 5))
			__Ixa_guiPadding(dN.Badge, 6, 6)
			dN.Meta = __Ixa_guiLabel({
				Position = UDim2.fromOffset(0, 20),
				Size = UDim2.new(1, 0, 0, 16),
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				Parent = dM,
			})
			dN.Desc = __Ixa_guiLabel({
				Position = UDim2.fromOffset(0, 41),
				RichText = true,
				Size = UDim2.new(1, 0, 0, 30),
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = dM,
			})
			local dQ = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.fromScale(0, 1),
					Size = UDim2.new(1, 0, 0, 26),
					BackgroundTransparency = 1,
					Parent = dM,
				}
			)
			dN.TagRow = __Ixa_guiNew(
				"Frame",
				{ Size = UDim2.new(1, -190, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, Parent = dQ }
			)
			cO(dN.TagRow, 4)
			local dR, dS = bF(
				dQ,
				"Install",
				{ AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(76, 26) },
				function()
					dG(dK)
				end
			)
			cK(dR, dS)
			dN.InstallText = dS
			local dT = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -86, 0.5, 0),
					Size = UDim2.fromOffset(0, 20),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundTransparency = 1,
					Parent = dQ,
				}
			)
			cO(dT, 4)
			local function dU(dV, dW)
				local dX, dY = __Ixa_guiIcon(dT, dV, __Ixa_guiTheme.Muted, UDim2.new())
				dX.Size = UDim2.fromOffset(12, 12)
				dX.LayoutOrder = dW
				local dZ = __Ixa_guiLabel({
					Size = UDim2.fromOffset(0, 20),
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					TextColor3 = __Ixa_guiTheme.Muted,
					TextTruncate = Enum.TextTruncate.None,
					LayoutOrder = dW + 1,
					Parent = dT,
				})
				return dZ, dY
			end
			dN.Likes, dN.Heart = dU("heart", 1)
			__Ixa_guiNew("Frame", { Size = UDim2.fromOffset(4, 1), BackgroundTransparency = 1, LayoutOrder = 3, Parent = dT })
			dN.Installs = dU("download", 4)
			local dV = __Ixa_guiClickGuard(dM, function()
				return dm
			end)
			dM.MouseButton1Click:Connect(function()
				if dV() then
					if cn.Search ~= "" then
						dc(cn.Search)
					end
					dF(dK)
				end
			end)
			ci[dK.Id] = dN
			dI(dN)
			return dN
		end
		local function dK()
			for dL, dM in pairs(ci) do
				dM.Frame:Destroy()
			end
			ci = {}
			for dL, dM in ipairs(cg) do
				dJ(dM, dL)
			end
		end
		local function dL()
			local dM = cn.Filter == "Favorites" and cu or cv
			local dN = string.lower(cn.Search)
			local dO = {}
			for dP, dQ in pairs(dM) do
				local dR = cn.Filter == "Favorites" and dQ or (type(dQ) == "table" and dQ.Record)
				if type(dR) == "table" then
					dR = table.clone(dR)
					dR.Id = dP
					local dS = cE(dR)
					local dT = dN == ""
						or string.find(string.lower(dS.Name), dN, 1, true)
						or string.find(string.lower(dS.Description), dN, 1, true)
					if dT and cn.Tag then
						dT = table.find(dS.Tags, cn.Tag) ~= nil
					end
					if dT then
						table.insert(dO, dS)
					end
				end
			end
			table.sort(dO, function(dP, dQ)
				if cn.Sort == "New" then
					return (dP.Updated or 0) > (dQ.Updated or 0)
				elseif cn.Sort == "Installs" then
					return dP.Installs > dQ.Installs
				end
				return dP.Likes > dQ.Likes
			end)
			return dO
		end
		local function dM()
			if cn.Filter == "Favorites" then
				return [[No favorites yet. Open a config and press Favorite to keep it here.]]
			elseif cn.Filter == "Installed" then
				return "Nothing installed from the cloud yet"
			elseif cn.Filter == "Mine" then
				return "You haven't published anything yet"
			elseif cn.Search ~= "" or cn.Tag then
				return "No configs match your search"
			end
			return tostring(b_.EmptyText or "No configs shared yet. Be the first!")
		end
		function c8(dN)
			cl += 1
			local dO = cl
			if cn.Filter == "Favorites" or cn.Filter == "Installed" then
				dv(false)
				dD()
				cg = dL()
				cj = false
				dK()
				dz.Visible = false
				dE(#cg == 0 and "empty" or nil, dM())
				return
			end
			if type(b_.OnFetch) ~= "function" then
				dK()
				dE(#cg == 0 and "empty" or nil, dM())
				return
			end
			if dN then
				if not cj then
					return
				end
				ck += 1
			else
				ck = 1
				cg = {}
				dK()
				dm.CanvasPosition = Vector2.zero
			end
			dv(true)
			dD()
			dC(dN and 2 or 4)
			dz.Visible = false
			dE(nil)
			local dP = {
				Search = cn.Search,
				Sort = cn.Sort,
				Filter = cn.Filter,
				Tag = cn.Tag,
				Page = ck,
				PageSize = cb,
				Folder = b0.ConfigFolder,
				UserId = __Ixa_guiPlayer.UserId,
			}
			task.spawn(function()
				local dQ, dR, dS = __Ixa_guiYieldCall(function()
					return b_.OnFetch(dP)
				end)
				if dO ~= cl then
					return
				end
				dv(false)
				dD()
				if not dQ or type(dR) ~= "table" then
					if dN then
						ck -= 1
					end
					if not dQ then
						warn("[AirFlow] cloud OnFetch error: " .. tostring(dR))
					end
					cj = dN and cj or false
					dz.Visible = false
					dE("error", not dQ and "Could not load configs" or tostring(dS or "Could not load configs"))
					return
				end
				cj = dS == true
				local dT = {}
				for dU, dV in ipairs(cg) do
					dT[dV] = true
				end
				for dU, dV in ipairs(dR) do
					local dW = cE(dV)
					if dW and not dT[dW] then
						dT[dW] = true
						table.insert(cg, dW)
						dJ(dW, #cg)
					end
				end
				dz.Visible = cj
				dE(#cg == 0 and "empty" or nil, dM())
			end)
		end
		dm:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			if not cj or cm then
				return
			end
			local dN = b0.Scale.Scale
			local dO = dm.AbsoluteCanvasSize.Y / dN - dm.AbsoluteWindowSize.Y / dN - dm.CanvasPosition.Y
			if dO < 160 then
				c8(true)
			end
		end)
		local dN, dO = {}, {}
		local function dP(dQ)
			for dR, dS in pairs(dN) do
				dS.Set(cn.Filter == dR, dQ)
			end
			for dR, dS in pairs(dO) do
				dS.Set(cn.Tag == dR, dQ)
			end
			di.Text = b7[cn.Sort]
		end
		for dQ, dR in ipairs(b8) do
			if not (dR == "Mine" and b_.MineFilter == false) then
				dN[dR] = cM(dj, dR, dQ, function()
					if cn.Filter ~= dR then
						cn.Filter = dR
						dP()
						c8(false)
					end
				end)
			end
		end
		if #cc > 0 then
			__Ixa_guiNew(
				"Frame",
				{ Size = UDim2.fromOffset(1, 16), BackgroundColor3 = __Ixa_guiTheme.Stroke, BorderSizePixel = 0, LayoutOrder = 10, Parent = dj }
			)
		end
		for dQ, dR in ipairs(cc) do
			dR = tostring(dR)
			dO[dR] = cM(dj, dR, 10 + dQ, function()
				cn.Tag = cn.Tag ~= dR and dR or nil
				dP()
				c8(false)
			end)
		end
		dg.MouseButton1Click:Connect(function()
			local dQ = table.find(b6, cn.Sort) or 1
			cn.Sort = b6[dQ % #b6 + 1]
			cw("CloudSort", cn.Sort)
			dP()
			c8(false)
		end)
		function dr()
			c9 += 1
			c6.Text = ""
			cn.Search, cn.Tag, cn.Filter = "", nil, "All"
			dP()
			c8(false)
		end
		dq.MouseButton1Click:Connect(dr)
		c6:GetPropertyChangedSignal("Text"):Connect(function()
			c7.Visible = c6.Text ~= ""
			dd(c6:IsFocused())
			c9 += 1
			local dQ = c9
			local dR = bM(c6.Text)
			if dR ~= cn.Search then
				dt(true)
			end
			task.delay(0.35, function()
				dR = bM(c6.Text)
				if dQ == c9 and dR ~= cn.Search then
					cn.Search = dR
					c8(false)
				end
			end)
		end)
		c6.Focused:Connect(function()
			__Ixa_guiTween(c3, { Color = __Ixa_guiTheme.Accent }, 0.15)
			__Ixa_guiTween(c5, { ImageColor3 = __Ixa_guiTheme.Accent }, 0.15)
			dd(true)
		end)
		c6.FocusLost:Connect(function(dQ)
			__Ixa_guiTween(c3, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			__Ixa_guiTween(c5, { ImageColor3 = __Ixa_guiTheme.Muted }, 0.2)
			dc(c6.Text)
			task.delay(0.15, function()
				if not c6:IsFocused() then
					dd(false)
				end
			end)
			if dQ then
				c9 += 1
				local dR = bM(c6.Text)
				if dR ~= cn.Search then
					cn.Search = dR
					c8(false)
				end
			end
		end)
		c7.MouseButton1Click:Connect(function()
			c9 += 1
			c6.Text = ""
			if cn.Search ~= "" then
				cn.Search = ""
				c8(false)
			end
		end)
		b0:_listen("Began", function(dQ, dR)
			if dR or dQ.KeyCode ~= Enum.KeyCode.Slash then
				return
			end
			if b0.Open and b0.CurrentTab == b1 and cp == co.Browse and not __Ixa_guiInputService:GetFocusedTextBox() then
				task.defer(function()
					c6:CaptureFocus()
					c6.Text = c6.Text:gsub("/$", "")
				end)
			end
		end, cf)
		c0.MouseButton1Click:Connect(function()
			cf:Refresh()
		end)
		local function dQ(dR, dS, dT)
			if dR.Code then
				dS(dR.Code)
				return
			end
			local function dU(dV)
				if dT then
					dT(dV)
				else
					cx(false, "Could not load config", dV)
				end
			end
			if type(b_.OnFetchCode) ~= "function" then
				dU("This config has no code")
				return
			end
			task.spawn(function()
				local dV, dW, dX = __Ixa_guiYieldCall(function()
					return b_.OnFetchCode(cF(dR))
				end)
				if dV and type(dW) == "string" and dW ~= "" then
					dR.Code = dW
					dR.Count = dR.Count or cz(dW)
					dS(dW)
				else
					dU(tostring(dX or (not dV and "the request failed") or "no code came back"))
				end
			end)
		end
		function dG(dR)
			if dR._busy then
				return
			end
			dR._busy = true
			dQ(dR, function(dS)
				dR._busy = nil
				local dT, dU = b0:DecodeConfig(dS)
				if not dT then
					cx(false, "Install failed", "The config code is invalid")
					return
				end
				local dV = 0
				for dW in pairs(dT) do
					dV += 1
				end
				local dW = cv[dR.Id]
				local dX = nil
				if ba() then
					dX = type(dW) == "table" and type(dW.Name) == "string" and b0:ConfigExists(dW.Name) and dW.Name
						or cT(dR.Name)
				end
				local dY = dU.Folder and dU.Folder ~= b0.ConfigFolder
				local function dZ(d_)
					local d0 = d_ and dX or nil
					local d1, d2 = b0:ImportConfig(dS, d0, true)
					if not d1 then
						cx(false, "Install failed", tostring(d2))
						return
					end
					cv[dR.Id] = { Updated = dR.Updated or os.time(), Name = d0, At = os.time(), Record = cG(dR) }
					cw("CloudInstalled", cv)
					dR.Installs += 1
					dH(dR)
					cx(true, "Config installed", d0 and ("Saved as " .. d0) or "Applied to your current settings")
					if b_.OnInstall then
						task.spawn(__Ixa_guiCall, b_.OnInstall, cF(dR), d0)
					end
				end
				local d_ = ("%s by %s changes %d setting%s."):format(dR.Name, dR.Author, dV, dV == 1 and "" or "s")
				if dY then
					d_ ..= (" It was made for %s, so only matching settings apply."):format(dU.Folder)
				end
				if dX then
					d_ ..= (" Install also saves it as %s; Apply only doesn't."):format(dX)
				end
				local d0 = { { Title = "Cancel" } }
				table.insert(d0, {
					Title = "Apply only",
					Variant = not dX and "Primary" or nil,
					Callback = function()
						dZ(false)
					end,
				})
				if dX then
					table.insert(d0, {
						Title = "Install",
						Variant = "Primary",
						Callback = function()
							dZ(true)
						end,
					})
				end
				b0:Dialog({
					Title = cH(dR) == "Update" and "Update config" or "Install config",
					Content = d_,
					Icon = dY and "triangle-alert" or "download",
					Buttons = d0,
				})
			end, function(dS)
				dR._busy = nil
				cx(false, "Could not load config", dS)
			end)
		end
		local function dR(dS)
			if type(b_.OnLike) ~= "function" or dS._liking then
				return
			end
			local dT = not dS.Liked
			dS.Liked = dT
			dS.Likes = math.max(dS.Likes + (dT and 1 or -1), 0)
			dS._liking = true
			dH(dS)
			task.spawn(function()
				local dU, dV, dW = __Ixa_guiYieldCall(function()
					return b_.OnLike(cF(dS), dT)
				end)
				dS._liking = nil
				if not dU or dV == false then
					dS.Liked = not dT
					dS.Likes = math.max(dS.Likes + (dT and -1 or 1), 0)
					dH(dS)
					cx(false, "Like not saved", tostring(dW or "Try again in a moment"))
				end
			end)
		end
		local function dS(dT)
			local dU = cu[dT.Id] == nil
			cu[dT.Id] = dU and cG(dT) or nil
			cw("CloudFavorites", cu)
			dH(dT)
			b0:Notify({
				Title = dU and "Added to favorites" or "Removed from favorites",
				Content = dT.Name,
				Icon = "star",
				Duration = 2,
			})
		end
		local function dT(dU)
			local dV = table.find(cg, dU)
			if dV then
				table.remove(cg, dV)
			end
			ch[dU.Id] = nil
			local dW = ci[dU.Id]
			if dW then
				dW.Frame:Destroy()
				ci[dU.Id] = nil
			end
			if #cg == 0 and not cm then
				dE("empty", dM())
			end
		end
		local function dU(dV)
			b0:Confirm({
				Title = "Delete config",
				Content = ([[Remove %s from the cloud? People who installed it keep their copy.]]):format(dV.Name),
				Icon = "trash-2",
				ConfirmText = "Delete",
				Callback = function()
					task.spawn(function()
						local dW, dX, dY = __Ixa_guiYieldCall(function()
							return b_.OnDelete(cF(dV))
						end)
						if not dW or dX == false then
							cx(false, "Delete failed", tostring(dY or "Try again in a moment"))
							return
						end
						cu[dV.Id] = nil
						cw("CloudFavorites", cu)
						dT(dV)
						cW(co.Browse)
						cx(true, "Config deleted", dV.Name)
					end)
				end,
			})
		end
		local function dV(dW)
			local dX = type(b_.ReportReasons) == "table" and b_.ReportReasons or { "Broken", "Spam", "Inappropriate" }
			local dY = { { Title = "Cancel" } }
			for dZ, d_ in ipairs(dX) do
				table.insert(dY, {
					Title = tostring(d_),
					Callback = function()
						task.spawn(function()
							local d0, d1 = __Ixa_guiYieldCall(function()
								return b_.OnReport(cF(dW), tostring(d_))
							end)
							local d2 = d0 and d1 ~= false
							cx(
								d2,
								d2 and "Report sent" or "Report failed",
								d2 and "Thanks for letting us know" or "Try again in a moment"
							)
						end)
					end,
				})
			end
			b0:Dialog({ Title = "Report config", Content = ("What's wrong with %s?"):format(dW.Name), Icon = "flag", Buttons = dY })
		end
		local dW = cR(co.Detail)
		__Ixa_guiPadding(dW, 1, 8, 1, 16)
		cP(dW, 10)
		local function dX(dY)
			local dZ = type(dY) == "table" and dY.Value or nil
			if dZ == nil then
				return "None"
			elseif type(dZ) == "boolean" then
				return dZ and "On" or "Off"
			elseif type(dZ) == "number" then
				return (("%.2f"):format(dZ):gsub("%.?0+$", ""))
			elseif type(dZ) == "table" then
				if type(dZ.Hex) == "string" then
					return "#" .. string.upper(dZ.Hex)
				elseif type(dZ.Colors) == "table" then
					local d_ = type(dZ.Name) == "string" and dZ.Name or "Custom"
					if type(dZ.Background) == "string" and dZ.Background ~= "" then
						d_ ..= ", image"
					end
					return d_
				end
				local d_ = {}
				for d0, d1 in ipairs(dZ) do
					d_[d0] = tostring(d1)
				end
				return #d_ > 0 and table.concat(d_, ", ") or "None"
			end
			return tostring(dZ)
		end
		local function dY(dZ)
			local d_, d0 = pcall(__Ixa_guiHttpService.JSONEncode, __Ixa_guiHttpService, type(dZ) == "table" and dZ.Value or nil)
			return d_ and d0 or tostring(dZ)
		end
		local function dZ()
			local d_ = cr
			if not d_ or not cq.Meta then
				return
			end
			cq.Title.Text = d_.Name
			local d0 = { "by " .. d_.Author }
			local d1 = cB(d_.Updated)
			if d1 then
				table.insert(d0, "updated " .. d1)
			end
			if cI(d_) then
				table.insert(d0, "made for " .. d_.Folder)
			end
			cq.Meta.Text = table.concat(d0, "  \u{b7}  ")
			cq.Stats.Text = ("%s like%s  \u{b7}  %s install%s"):format(
				cA(d_.Likes),
				d_.Likes == 1 and "" or "s",
				cA(d_.Installs),
				d_.Installs == 1 and "" or "s"
			)
			if cq.BuiltFor ~= d_ or cq.BuiltMine ~= d_.Mine then
				cq.BuiltFor, cq.BuiltMine = d_, d_.Mine
				local d2 = cq.Actions
				cL(d2)
				local d3 = 0
				local function d4(d5, d6, d7)
					d3 += 1
					local d8, d9 = bF(
						d2,
						d5,
						{ Size = UDim2.new(0, 0, 0, 30), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = d3 },
						d7
					)
					d9.TextSize = 13
					if d6 == "Primary" then
						cK(d8, d9)
					elseif d6 == "Danger" then
						__Ixa_guiTween(d9, { TextColor3 = __Ixa_guiTheme.Error }, 0)
					end
					return d9
				end
				cq.InstallLabel = d4("Install", "Primary", function()
					dG(d_)
				end)
				if type(b_.OnLike) == "function" then
					cq.LikeLabel = d4("Like", nil, function()
						dR(d_)
					end)
				end
				cq.FavoriteLabel = d4("Favorite", nil, function()
					dS(d_)
				end)
				d4("Copy code", nil, function()
					dQ(d_, function(d5)
						b0:CopyToClipboard(d5, "Config code")
					end)
				end)
				if d_.Mine then
					if type(b_.OnUpdate) == "function" then
						d4("Edit", nil, function()
							cf:OpenPublish(d_)
						end)
					end
					if type(b_.OnDelete) == "function" then
						d4("Delete", "Danger", function()
							dU(d_)
						end)
					end
				elseif type(b_.OnReport) == "function" then
					d4("Report", "Danger", function()
						dV(d_)
					end)
				end
			end
			local d2 = cH(d_)
			cq.InstallLabel.Text = d2 == "Update" and "Update" or (d2 == "Installed" and "Reinstall" or "Install")
			if cq.LikeLabel then
				cq.LikeLabel.Text = (d_.Liked and "Liked" or "Like") .. "  \u{b7}  " .. cA(d_.Likes)
			end
			cq.FavoriteLabel.Text = cu[d_.Id] and "Favorited" or "Favorite"
		end
		local function d_(d0, d1)
			local function d2(d3)
				if cs == d1 then
					cq.Summary.Text = d3
				end
			end
			dQ(d0, function(d3)
				if cs ~= d1 then
					return
				end
				local d4 = b0:DecodeConfig(d3)
				if not d4 then
					d2("The config code is invalid")
					return
				end
				local d5 = bh(b0)
				local d6 = {}
				local d7 = 0
				for d8, d9 in pairs(d4) do
					local ea = __Ixa_guiLibrary.Flags[d8]
					local eb = ea ~= nil
					local ec = eb and dY(d9) ~= dY(d5[d8])
					if ec then
						d7 += 1
					end
					table.insert(
						d6,
						{
							Name = ea and ea._searchName ~= "" and ea._searchName or d8,
							Value = dX(d9),
							Known = eb,
							Changed = ec,
							Rank = ec and 0 or (eb and 1 or 2),
						}
					)
				end
				table.sort(d6, function(d8, d9)
					if d8.Rank ~= d9.Rank then
						return d8.Rank < d9.Rank
					end
					return string.lower(d8.Name) < string.lower(d9.Name)
				end)
				d0.Count = #d6
				cq.Summary.Text = d7 == 0 and ("%d settings, all the same as yours"):format(#d6)
					or ("%d settings, %d different from yours"):format(#d6, d7)
				cL(cq.Rows)
				for d8, d9 in ipairs(d6) do
					if d8 > 150 then
						cQ(cq.Rows, ("and %d more"):format(#d6 - 150), 12, __Ixa_guiTheme.Muted, d8)
						break
					end
					local ea = __Ixa_guiNew(
						"Frame",
						{
							Size = UDim2.new(1, 0, 0, 30),
							BackgroundColor3 = __Ixa_guiTheme.Surface2,
							BackgroundTransparency = d9.Changed and 0 or 0.5,
							BorderSizePixel = 0,
							LayoutOrder = d8,
							Parent = cq.Rows,
						}
					)
					__Ixa_guiCorner(ea, UDim.new(0, 7))
					if d9.Changed then
						local eb = __Ixa_guiNew(
							"Frame",
							{
								AnchorPoint = Vector2.new(0, 0.5),
								Position = UDim2.new(0, 10, 0.5, 0),
								Size = UDim2.fromOffset(6, 6),
								BackgroundColor3 = __Ixa_guiTheme.Accent,
								BorderSizePixel = 0,
								Parent = ea,
							}
						)
						__Ixa_guiCorner(eb, UDim.new(1, 0))
					end
					__Ixa_guiLabel({
						Position = UDim2.fromOffset(24, 0),
						Size = UDim2.new(0.55, -24, 1, 0),
						Text = d9.Known and d9.Name or (d9.Name .. "  (not in this script)"),
						TextSize = 12,
						TextColor3 = d9.Known and __Ixa_guiTheme.Text or __Ixa_guiTheme.Muted,
						Parent = ea,
					})
					__Ixa_guiLabel({
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(1, -10, 0, 0),
						Size = UDim2.new(0.45, -10, 1, 0),
						Text = d9.Value,
						TextSize = 12,
						FontFace = __Ixa_guiFonts.Regular,
						TextColor3 = d9.Changed and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted,
						TextXAlignment = Enum.TextXAlignment.Right,
						Parent = ea,
					})
				end
				if ci[d0.Id] then
					dI(ci[d0.Id])
				end
			end, d2)
		end
		function dF(d0)
			cr = d0
			cs += 1
			local d1 = cs
			cL(dW)
			cq = {}
			dW.CanvasPosition = Vector2.zero
			bF(
				dW,
				"Back",
				{ Size = UDim2.new(0, 0, 0, 28), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1 },
				function()
					cW(co.Browse)
				end
			)
			cq.Title = cQ(dW, d0.Name, 20, __Ixa_guiTheme.Text, 2, __Ixa_guiFonts.Bold)
			cq.Meta = cQ(dW, "", 12, __Ixa_guiTheme.Muted, 3)
			if d0.Description ~= "" then
				cQ(dW, d0.Description, 13, __Ixa_guiTheme.Text, 4)
			end
			if #d0.Tags > 0 then
				local d2 = __Ixa_guiNew(
					"Frame",
					{
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						Parent = dW,
					}
				)
				cO(d2, 4, true)
				for d3, d4 in ipairs(d0.Tags) do
					cN(d2, d4, d3)
				end
			end
			cq.Stats = cQ(dW, "", 12, __Ixa_guiTheme.Muted, 6)
			cq.Actions = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 7,
					Parent = dW,
				}
			)
			cO(cq.Actions, 6, true)
			__Ixa_guiNew(
				"Frame",
				{ Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = __Ixa_guiTheme.Stroke, BorderSizePixel = 0, LayoutOrder = 8, Parent = dW }
			)
			cQ(dW, "Settings", 14, __Ixa_guiTheme.Text, 9, __Ixa_guiFonts.Bold)
			cq.Summary = cQ(dW, "Loading settings...", 12, __Ixa_guiTheme.Muted, 10)
			cq.Rows = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = 11,
					Parent = dW,
				}
			)
			cP(cq.Rows, 4)
			dZ()
			cW(co.Detail)
			d_(d0, d1)
		end
		function dH(d0)
			local d1 = ci[d0.Id]
			if d1 then
				dI(d1)
			end
			if cr == d0 and cp == co.Detail then
				dZ()
			end
		end
		local d0 = { Mode = "Publish", Record = nil, Source = false, Tags = {}, Busy = false }
		local d1 = cR(co.Publish)
		__Ixa_guiPadding(d1, 1, 8, 1, 16)
		cP(d1, 8)
		bF(
			d1,
			"Back",
			{ Size = UDim2.new(0, 0, 0, 28), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1 },
			function()
				cW(d0.Mode == "Edit" and d0.Record and co.Detail or co.Browse)
			end
		)
		local d2 = cQ(d1, "Publish a config", 20, __Ixa_guiTheme.Text, 2, __Ixa_guiFonts.Bold)
		cQ(d1, "Name", 12, __Ixa_guiTheme.Muted, 3)
		local d3 = cS(d1, 4, "What is it for?", b3, b9)
		cQ(d1, "Description", 12, __Ixa_guiTheme.Muted, 5)
		local d4 = cS(d1, 6, "What does it do, and how should people use it?", 90, ca)
		local d5 = cQ(d1, "Tags", 12, __Ixa_guiTheme.Muted, 7)
		local d6 = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 8,
				Parent = d1,
			}
		)
		cO(d6, 6, true)
		d5.Visible = #cc > 0 and cd > 0
		d6.Visible = d5.Visible
		cQ(d1, "Settings to share", 12, __Ixa_guiTheme.Muted, 9)
		local d7 = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 10,
				Parent = d1,
			}
		)
		cO(d7, 6, true)
		local d8 = cQ(d1, "", 12, __Ixa_guiTheme.Muted, 11)
		local d9 = cQ(d1, "", 12, __Ixa_guiTheme.Muted, 12)
		local ea = cQ(d1, "", 12, __Ixa_guiTheme.Error, 13)
		ea.Visible = false
		local eb =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 14, Parent = d1 })
		cO(eb, 6)
		local ec, ed = bF(
			eb,
			"Publish",
			{ Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1 },
			function()
				cf:_submit()
			end
		)
		cK(ec, ed)
		bF(
			eb,
			"Cancel",
			{ Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2 },
			function()
				cW(d0.Mode == "Edit" and d0.Record and co.Detail or co.Browse)
			end
		)
		local ee = {}
		local function ef()
			for eg, eh in pairs(ee) do
				eh.Set(table.find(d0.Tags, eg) ~= nil)
			end
			d5.Text = cd > 0 and ("Tags  (%d/%d)"):format(#d0.Tags, cd) or "Tags"
		end
		for eg, eh in ipairs(cc) do
			eh = tostring(eh)
			ee[eh] = cM(d6, eh, eg, function()
				local ei = table.find(d0.Tags, eh)
				if ei then
					table.remove(d0.Tags, ei)
				elseif #d0.Tags < cd then
					table.insert(d0.Tags, eh)
				else
					cx(false, "Too many tags", ("Pick up to %d"):format(cd))
				end
				ef()
			end)
		end
		local function eg(eh)
			if d0.Source == "Keep" then
				return nil, d0.Record and d0.Record.Count
			elseif d0.Source then
				local ei, ej = b0:ExportConfig(d0.Source)
				if not ei then
					return nil, nil, ej
				end
				return ei, cz(ei)
			end
			local ei, ej = pcall(bj, b0, eh ~= "" and eh or "Cloud config", bh(b0))
			if not ei then
				return nil, nil, "could not encode your settings"
			end
			return ej, cz(ej)
		end
		local eh = {}
		local function ei()
			for ej, ek in pairs(eh) do
				ek.Set(ej == (d0.Source or "*current"))
			end
			local ej, ek, el = eg(bM(d3.Text))
			if el then
				d8.Text = tostring(el)
			elseif d0.Source == "Keep" then
				d8.Text = "Keeps the settings already published" .. (ek and (" (" .. ek .. ")") or "")
			else
				d8.Text = ("%d setting%s from %s"):format(
					ek or 0,
					ek == 1 and "" or "s",
					d0.Source or "your current settings"
				)
			end
		end
		local function ej()
			cL(d7)
			eh = {}
			local ek = 0
			local function el(em, en)
				ek += 1
				eh[em] = cM(d7, en, ek, function()
					d0.Source = em ~= "*current" and em or false
					ei()
				end)
			end
			if d0.Mode == "Edit" then
				el("Keep", "Keep published settings")
			end
			el("*current", "Current settings")
			for em, en in ipairs(b0:ListConfigs()) do
				el(en, en)
			end
			ei()
		end
		local function ek(el)
			ea.Text = tostring(el)
			ea.Visible = true
		end
		function cf:OpenPublish(el)
			local em = type(el) == "table" and el.Id and ch[el.Id] or nil
			if em then
				d0.Mode, d0.Record = "Edit", em
				d0.Source = "Keep"
				d0.Tags = table.clone(em.Tags)
				d3.Text = em.Name
				d4.Text = em.Description
			elseif d0.Mode == "Edit" then
				d0.Mode, d0.Record, d0.Source, d0.Tags = "Publish", nil, false, {}
				d3.Text = ""
				d4.Text = ""
			end
			d2.Text = em and "Edit config" or "Publish a config"
			ed.Text = em and "Save changes" or "Publish"
			ea.Visible = false
			local en = cy()
			d9.Text = en and ("Your name is hidden, so you publish as " .. ce) or ("You publish as " .. __Ixa_guiPlayer.DisplayName)
			ef()
			ej()
			d1.CanvasPosition = Vector2.zero
			cW(co.Publish)
		end
		d3:GetPropertyChangedSignal("Text"):Connect(function()
			ea.Visible = false
		end)
		function cf:_submit()
			if d0.Busy then
				return
			end
			local el = bM(d3.Text)
			if el == "" then
				ek("Give your config a name")
				return
			end
			local em, en, eo = eg(el)
			if eo then
				ek(eo)
				return
			end
			if d0.Source ~= "Keep" and (en or 0) == 0 then
				ek("There are no settings to share")
				return
			end
			local ep = d0.Mode == "Edit" and d0.Record or nil
			local eq = ep and b_.OnUpdate or b_.OnPublish
			if type(eq) ~= "function" then
				ek(ep and "Editing isn't available" or "Publishing isn't available")
				return
			end
			local er = cy()
			local es = {
				Name = el,
				Description = bM(d4.Text),
				Tags = table.clone(d0.Tags),
				Code = em,
				Count = en,
				Folder = b0.ConfigFolder,
				Author = er and ce or __Ixa_guiPlayer.DisplayName,
				AuthorId = not er and __Ixa_guiPlayer.UserId or nil,
				OwnerId = __Ixa_guiPlayer.UserId,
				Streamer = er,
			}
			d0.Busy = true
			ed.Text = ep and "Saving..." or "Publishing..."
			ea.Visible = false
			task.spawn(function()
				local et, eu, ev = __Ixa_guiYieldCall(function()
					if ep then
						return eq(cF(ep), es)
					end
					return eq(es)
				end)
				d0.Busy = false
				ed.Text = ep and "Save changes" or "Publish"
				if not et or eu == false then
					if not et then
						warn("[AirFlow] cloud publish error: " .. tostring(eu))
					end
					ek(et and ev and tostring(ev) or "Something went wrong, try again")
					return
				end
				local ew = table.clone(es)
				ew.Code = em or (ep and ep.Code)
				ew.Updated = os.time()
				if type(eu) == "table" then
					for ex, ey in pairs(eu) do
						ew[ex] = ey
					end
				end
				if ep then
					ew.Id = ep.Id
					cE(ew)
					if cu[ep.Id] then
						cu[ep.Id] = cG(ep)
						cw("CloudFavorites", cu)
					end
					dH(ep)
					cx(true, "Config updated", el)
					dF(ep)
				else
					d3.Text = ""
					d4.Text = ""
					d0.Tags = {}
					d0.Source = false
					if type(eu) == "table" then
						ew.Mine = true
						local ex = cE(ew)
						if cn.Filter == "All" or cn.Filter == "Mine" then
							table.insert(cg, 1, ex)
							dK()
							dE(nil)
						end
						cx(true, "Config published", el)
						dF(ex)
					else
						cx(true, "Config published", el)
						cW(co.Browse)
						c8(false)
					end
				end
			end)
		end
		function cf:Refresh()
			c8(false)
		end
		function cf:LoadMore()
			if not cm then
				c8(true)
			end
		end
		function cf:SetConfigs(el, em)
			cl += 1
			dv(false)
			dD()
			cg = {}
			for en, eo in ipairs(type(el) == "table" and el or {}) do
				local ep = cE(eo)
				if ep then
					table.insert(cg, ep)
				end
			end
			cj = em == true
			dK()
			dz.Visible = cj
			dE(#cg == 0 and "empty" or nil, dM())
		end
		function cf:AddConfigs(el, em)
			cl += 1
			dv(false)
			dD()
			for en, eo in ipairs(type(el) == "table" and el or {}) do
				local ep = cE(eo)
				if ep and not table.find(cg, ep) then
					table.insert(cg, ep)
					dJ(ep, #cg)
				end
			end
			cj = em == true
			dz.Visible = cj
			dE(#cg == 0 and "empty" or nil, dM())
		end
		function cf:UpdateConfig(el, em)
			local en = ch[tostring(el)]
			if en and type(em) == "table" then
				local eo = table.clone(em)
				eo.Id = en.Id
				cE(eo)
				dH(en)
			end
		end
		function cf:RemoveConfig(el)
			local em = ch[tostring(el)]
			if em then
				dT(em)
				if cr == em and cp == co.Detail then
					cW(co.Browse)
				end
			end
		end
		function cf:SetLoading(el)
			cl += 1
			dv(el == true)
			dD()
			if cm then
				dC(4)
				dE(nil)
			end
		end
		function cf:SetError(el)
			cl += 1
			dv(false)
			dD()
			dE(el and "error" or nil, tostring(el or ""))
		end
		function cf:Open(el)
			local em = ch[tostring(el)]
			if em then
				b0:SelectTab(b1)
				dF(em)
			end
		end
		function cf:Back()
			cW(co.Browse)
		end
		function cf:GetQuery()
			return table.clone(cn)
		end
		function cf:GetFavorites()
			local el = {}
			for em, en in pairs(cu) do
				local eo = table.clone(en)
				eo.Id = em
				table.insert(el, eo)
			end
			return el
		end
		function cf:GetInstalled()
			local el = {}
			for em, en in pairs(cv) do
				table.insert(el, { Id = em, Name = en.Name, Updated = en.Updated, Record = en.Record })
			end
			return el
		end
		dP(true)
		cW(co.Browse)
		local el = false
		local function em()
			if not el and b1._page.Visible then
				el = true
				c8(false)
			end
		end
		b1._page:GetPropertyChangedSignal("Visible"):Connect(em)
		if type(b_.OnFetch) ~= "function" then
			el = true
			dE("empty", dM())
		else
			task.defer(em)
		end
		return cf
	end
	__Ixa_guiWindow.CreateCloudConfigs = __Ixa_guiWindow.CloudConfigs
	__Ixa_guiWindow.CloudConfig = __Ixa_guiWindow.CloudConfigs
	__Ixa_guiWindow.CreateCloudConfig = __Ixa_guiWindow.CloudConfigs
	function __Ixa_guiGroup:SetBadge() end
	function __Ixa_guiGroup:GetBadge()
		return nil
	end
	function __Ixa_guiWindow:Dialog(b_)
		b_ = __Ixa_guiOptions(b_, { Text = "Content", Message = "Content" })
		if self._dialog then
			self._dialog.Close()
		end
		local b0 = 300
		local b1 = 18
		local b2 = __Ixa_guiNew(
			"TextButton",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 40,
				Parent = self.Body,
			}
		)
		local b3 = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 10),
				Size = UDim2.fromOffset(b0, 120),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 41,
				Parent = b2,
			}
		)
		__Ixa_guiCorner(b3, UDim.new(0, 10))
		local b4 = __Ixa_guiStroke(b3, __Ixa_guiTheme.Stroke, 1)
		local b6 = __Ixa_guiNew("UIScale", { Scale = 0.94, Parent = b3 })
		local b7 = {}
		local b8 = 0
		if b_.Icon then
			local b9, ca = __Ixa_guiIcon(b3, b_.Icon, __Ixa_guiTheme.Accent, UDim2.new(0, b1, 0, b1 + 9))
			ca.ImageTransparency = 1
			b9.ZIndex = 42
			ca.ZIndex = 42
			table.insert(b7, { ca, "ImageTransparency", 0 })
			b8 = 24
		end
		local b9 = __Ixa_guiLabel({
			Position = UDim2.fromOffset(b1 + b8, b1),
			Size = UDim2.new(1, -(b1 * 2 + b8), 0, 18),
			Text = b_.Title or "Are you sure?",
			TextSize = 15,
			TextTransparency = 1,
			ZIndex = 42,
			Parent = b3,
		})
		table.insert(b7, { b9, "TextTransparency", 0 })
		local ca = 0
		if b_.Content then
			local cb = __Ixa_guiLabel({
				Position = UDim2.fromOffset(b1, b1 + 24),
				Size = UDim2.new(1, -b1 * 2, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = b_.Content,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextWrapped = true,
				TextTransparency = 1,
				TextTruncate = Enum.TextTruncate.None,
				TextYAlignment = Enum.TextYAlignment.Top,
				ZIndex = 42,
				Parent = b3,
			})
			table.insert(b7, { cb, "TextTransparency", 0 })
			ca = math.max(cb.TextBounds.Y, 16) + 6
			cb:GetPropertyChangedSignal("TextBounds"):Connect(function()
				local cc = math.max(cb.TextBounds.Y, 16) + 6
				if cc ~= ca then
					ca = cc
					b3.Size = UDim2.fromOffset(b0, b1 + 24 + ca + 12 + 34 + b1)
					local cd = b3:FindFirstChild("ButtonRow")
					if cd then
						cd.Position = UDim2.fromOffset(b1, b1 + 24 + ca + 12)
					end
				end
			end)
		end
		local cb = __Ixa_guiNew(
			"Frame",
			{
				Name = "ButtonRow",
				Position = UDim2.fromOffset(b1, b1 + 24 + ca + 12),
				Size = UDim2.new(1, -b1 * 2, 0, 34),
				BackgroundTransparency = 1,
				ZIndex = 42,
				Parent = b3,
			}
		)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8),
				Parent = cb,
			}
		)
		b3.Size = UDim2.fromOffset(b0, b1 + 24 + ca + 12 + 34 + b1)
		local cc = {}
		local cd = false
		function cc.Close()
			if cd then
				return
			end
			cd = true
			if self._dialog == cc then
				self._dialog = nil
			end
			__Ixa_guiTween(b2, { BackgroundTransparency = 1 }, 0.18)
			__Ixa_guiTween(b3, { BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 8) }, 0.18, Enum.EasingStyle.Quint)
			__Ixa_guiTween(b6, { Scale = 0.96 }, 0.18, Enum.EasingStyle.Quint)
			__Ixa_guiTween(b4, { Transparency = 1 }, 0.12)
			for ce, cf in ipairs(b7) do
				__Ixa_guiTween(cf[1], { [cf[2]] = 1 }, 0.12)
			end
			task.delay(0.2, function()
				b2:Destroy()
			end)
		end
		for ce, cf in ipairs(b_.Buttons or {}) do
			local cg = cf.Variant == "Primary"
			local ch = __Ixa_guiNew(
				"TextButton",
				{
					Size = UDim2.fromOffset(0, 34),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = cg and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Surface2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					ClipsDescendants = true,
					LayoutOrder = ce,
					ZIndex = 43,
					Parent = cb,
				}
			)
			__Ixa_guiCorner(ch, UDim.new(0, 7))
			local ci = __Ixa_guiStroke(ch, cg and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Stroke, 1)
			__Ixa_guiPadding(ch, 14, 14)
			local cj = __Ixa_guiLabel({
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = cf.Title or cf.Name or "OK",
				TextSize = 13,
				TextColor3 = cg and __Ixa_guiTheme.AccentDark or __Ixa_guiTheme.Text,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextTransparency = 1,
				ZIndex = 44,
				Parent = ch,
			})
			local ck = cg and 0.12 or 0
			local cl = cg and 0.4 or 0
			table.insert(b7, { ch, "BackgroundTransparency", ck })
			table.insert(b7, { ci, "Transparency", cl })
			table.insert(b7, { cj, "TextTransparency", 0 })
			ch.MouseEnter:Connect(function()
				if cd then
					return
				end
				if cg then
					__Ixa_guiTween(ch, { BackgroundTransparency = 0 }, 0.12)
					__Ixa_guiTween(ci, { Transparency = 0 }, 0.12)
				else
					__Ixa_guiTween(ci, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
				end
			end)
			ch.MouseLeave:Connect(function()
				if cd then
					return
				end
				if cg then
					__Ixa_guiTween(ch, { BackgroundTransparency = ck }, 0.2)
					__Ixa_guiTween(ci, { Transparency = cl }, 0.2)
				else
					__Ixa_guiTween(ci, { Color = __Ixa_guiTheme.Stroke }, 0.2)
				end
			end)
			ch.MouseButton1Click:Connect(function()
				cc.Close()
				__Ixa_guiCall(cf.Callback)
			end)
		end
		if b_.CloseOnBackdrop ~= false then
			b2.MouseButton1Click:Connect(function()
				cc.Close()
				__Ixa_guiCall(b_.OnCancel)
			end)
		end
		self._dialog = cc
		__Ixa_guiTween(b2, { BackgroundTransparency = 0.45 }, 0.25)
		__Ixa_guiTween(b3, { BackgroundTransparency = 0, Position = UDim2.fromScale(0.5, 0.5) }, 0.3, Enum.EasingStyle.Quint)
		__Ixa_guiTween(b4, { Transparency = 0 }, 0.25)
		__Ixa_guiTween(b6, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
		for ce, cf in ipairs(b7) do
			__Ixa_guiTween(cf[1], { [cf[2]] = cf[3] }, 0.25)
		end
		return cc
	end
	function __Ixa_guiWindow:Confirm(b_)
		b_ = __Ixa_guiOptions(b_, { Text = "Content", Message = "Content" })
		return self:Dialog({
			Title = b_.Title or "Are you sure?",
			Content = b_.Content,
			Icon = b_.Icon,
			OnCancel = b_.OnCancel,
			Buttons = {
				{ Title = b_.CancelText or "Cancel", Callback = b_.OnCancel },
				{ Title = b_.ConfirmText or "Confirm", Variant = "Primary", Callback = b_.Callback },
			},
		})
	end
	function __Ixa_guiWindow:_listen(b_, b0, b1)
		local b2 = self._inputListeners[b_]
		table.insert(b2, b0)
		local function b3()
			for b4, b6 in ipairs(b2) do
				if b6 == b0 then
					table.remove(b2, b4)
					break
				end
			end
		end
		if b1 then
			b1._listeners = b1._listeners or {}
			table.insert(b1._listeners, b3)
		end
		return b3
	end
	function __Ixa_guiWindow:_indicatorY(b_)
		local b0 = self._tabStack
		return (b_._button.AbsolutePosition.Y - b0.AbsolutePosition.Y) / self.Scale.Scale + b0.Position.Y.Offset
	end
	function __Ixa_guiWindow:_placeIndicator(b_)
		local b0 = self.Indicator
		local b1 = self:_indicatorY(b_)
		if not b0.Visible then
			b0.Visible = true
			b0.Position = UDim2.fromOffset(8, b1)
			b0.BackgroundTransparency = 1
			__Ixa_guiTween(b0, { BackgroundTransparency = 0.35 }, 0.3)
		end
		__Ixa_guiTween(b0, { Position = UDim2.fromOffset(8, b1) }, 0.45, Enum.EasingStyle.Quint)
	end
	function __Ixa_guiWindow:_overflowHint(b_, b0, b1, b2, b3)
		local b4 = __Ixa_guiNew(
			"Frame",
			{ AnchorPoint = b0.AnchorPoint, Position = b0.Position, Size = b0.Size, BackgroundTransparency = 1, ZIndex = 3, Parent = b_ }
		)
		local function b6()
			b4.Position = b0.Position
			b4.Size = b0.Size
			b4.Visible = b0.Visible
		end
		for b7, b8 in ipairs({ "Position", "Size", "Visible" }) do
			b0:GetPropertyChangedSignal(b8):Connect(b6)
		end
		local function b7(b8)
			return b2 and b8.Y or b8.X
		end
		local function b8()
			return self.Scale and self.Scale.Scale or 1
		end
		local function b9(ca)
			local cb = b7(b0.AbsoluteWindowSize) / b8()
			local cc = math.max(b7(b0.AbsoluteCanvasSize) / b8() - cb, 0)
			local cd = math.clamp(b7(b0.CanvasPosition) + ca * cb * 0.75, 0, cc)
			__Ixa_guiTween(b0, { CanvasPosition = b2 and Vector2.new(0, cd) or Vector2.new(cd, 0) }, 0.35, Enum.EasingStyle.Quint)
		end
		local ca = {}
		for cb, cc in ipairs({ -1, 1 }) do
			local cd = cc > 0
			local ce = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = b2 and Vector2.new(0, cd and 1 or 0) or Vector2.new(cd and 1 or 0, 0),
					Position = b2 and UDim2.fromScale(0, cd and 1 or 0) or UDim2.fromScale(cd and 1 or 0, 0),
					Size = b2 and UDim2.new(1, 0, 0, 34) or UDim2.new(0, 48, 1, 0),
					BackgroundColor3 = b3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Visible = false,
					Parent = b4,
				}
			)
			__Ixa_guiNew(
				"UIGradient",
				{
					Rotation = b2 and (cd and 270 or 90) or (cd and 180 or 0),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.4, 0.2),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Parent = ce,
				}
			)
			local cf = b2 and UDim2.new(0.5, 0, cd and 1 or 0, cd and -5 or 5)
				or UDim2.new(cd and 1 or 0, cd and -2 or 2, 0.5, 0)
			local cg = __Ixa_guiNew(
				"TextButton",
				{
					AnchorPoint = b2 and Vector2.new(0.5, cd and 1 or 0) or Vector2.new(cd and 1 or 0, 0.5),
					Position = cf,
					Size = UDim2.fromOffset(0, 20),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = __Ixa_guiTheme.Surface3,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = "",
					AutoButtonColor = false,
					Visible = false,
					ZIndex = 2,
					Parent = b4,
				}
			)
			__Ixa_guiCorner(cg, UDim.new(1, 0))
			local ch = __Ixa_guiStroke(cg, __Ixa_guiTheme.Stroke, 1)
			__Ixa_guiPadding(cg, 7, 7)
			__Ixa_guiNew(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 3),
					Parent = cg,
				}
			)
			local ci = __Ixa_guiNew(
				"ImageLabel",
				{
					Size = UDim2.fromOffset(12, 12),
					BackgroundTransparency = 1,
					ImageColor3 = __Ixa_guiTheme.Accent,
					ImageTransparency = 1,
					ScaleType = Enum.ScaleType.Fit,
					LayoutOrder = 1,
					ZIndex = 2,
					Parent = cg,
				}
			)
			__Ixa_guiApplyIcon(ci, b2 and (cd and "chevron-down" or "chevron-up") or (cd and "chevron-right" or "chevron-left"))
			local cj = "ImageTransparency"
			if ci.Image == "" then
				ci:Destroy()
				ci = __Ixa_guiLabel({
					Size = UDim2.fromOffset(10, 20),
					Text = "\u{203a}",
					TextSize = 16,
					TextColor3 = __Ixa_guiTheme.Accent,
					TextTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextTruncate = Enum.TextTruncate.None,
					Rotation = b2 and (cd and 90 or -90) or (cd and 0 or 180),
					LayoutOrder = 1,
					ZIndex = 2,
					Parent = cg,
				})
				cj = "TextTransparency"
			end
			local ck = __Ixa_guiLabel({
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = "",
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Text,
				TextTransparency = 1,
				TextTruncate = Enum.TextTruncate.None,
				Visible = false,
				LayoutOrder = 2,
				ZIndex = 2,
				Parent = cg,
			})
			cg.MouseEnter:Connect(function()
				if not __Ixa_guiIsTouch() then
					__Ixa_guiTween(ch, { Color = __Ixa_guiTheme.StrokeHover }, 0.12)
				end
			end)
			cg.MouseLeave:Connect(function()
				__Ixa_guiTween(ch, { Color = __Ixa_guiTheme.Stroke }, 0.2)
			end)
			cg.MouseButton1Click:Connect(function()
				b9(cc)
			end)
			ca[cc] = {
				Direction = cc,
				Fade = ce,
				Chip = cg,
				Stroke = ch,
				Arrow = ci,
				ArrowFade = cj,
				Count = ck,
				Home = cf,
				Shown = false,
				Generation = 0,
			}
		end
		local function cb(cc, cd)
			if cc.Shown == cd then
				return
			end
			cc.Shown = cd
			cc.Generation += 1
			local ce = cc.Home + (b2 and UDim2.fromOffset(0, cc.Direction * 6) or UDim2.fromOffset(cc.Direction * 6, 0))
			local cf = cd and 0 or 1
			if cd then
				cc.Fade.Visible = true
				cc.Chip.Visible = true
				cc.Chip.Position = ce
				__Ixa_guiTween(cc.Chip, { Position = cc.Home, BackgroundTransparency = 0.08 }, 0.3, Enum.EasingStyle.Quint)
			else
				__Ixa_guiTween(cc.Chip, { Position = ce, BackgroundTransparency = 1 }, 0.2, Enum.EasingStyle.Quint)
				local cg = cc.Generation
				task.delay(0.21, function()
					if cc.Generation == cg then
						cc.Fade.Visible = false
						cc.Chip.Visible = false
					end
				end)
			end
			__Ixa_guiTween(cc.Fade, { BackgroundTransparency = cf }, 0.2)
			__Ixa_guiTween(cc.Stroke, { Transparency = cf }, 0.2)
			__Ixa_guiTween(cc.Arrow, { [cc.ArrowFade] = cf }, 0.2)
			__Ixa_guiTween(cc.Count, { TextTransparency = cf }, 0.2)
		end
		local function cc()
			local cd = b7(b0.AbsoluteWindowSize)
			local ce = (b7(b0.AbsoluteCanvasSize) - cd) / b8()
			local cf = b7(b0.CanvasPosition)
			local cg = b7(b0.AbsolutePosition)
			local ch, ci = 0, 0
			for cj, ck in ipairs(b1:GetChildren()) do
				if ck:IsA("GuiObject") and ck.Visible and b7(ck.AbsoluteSize) > 0 then
					local cl = b7(ck.AbsolutePosition) + b7(ck.AbsoluteSize) / 2 - cg
					if cl < 0 then
						ch += 1
					elseif cl > cd then
						ci += 1
					end
				end
			end
			for cj, ck in pairs(ca) do
				local cl = cj < 0 and ch or ci
				ck.Count.Text = tostring(cl)
				ck.Count.Visible = cl > 0
				cb(ck, ce > 1 and (cj < 0 and cf > 1 or cj > 0 and cf < ce - 1))
			end
		end
		for cd, ce in ipairs({ "CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize" }) do
			b0:GetPropertyChangedSignal(ce):Connect(cc)
		end
		task.defer(cc)
	end
	function __Ixa_guiWindow:_scrollTabIntoView(b_)
		local b0 = self.TabList
		local b1 = self.Scale.Scale
		local b2 = (b_._button.AbsolutePosition.Y - b0.AbsolutePosition.Y) / b1 + b0.CanvasPosition.Y
		local b3 = b2 + b_._button.AbsoluteSize.Y / b1
		local b4 = b0.AbsoluteWindowSize.Y / b1
		local b6 = b0.CanvasPosition.Y
		if b2 - 8 < b6 then
			b6 = b2 - 8
		elseif b3 + 8 > b6 + b4 then
			b6 = b3 + 8 - b4
		else
			return
		end
		__Ixa_guiTween(b0, { CanvasPosition = Vector2.new(0, math.max(0, b6)) }, 0.35, Enum.EasingStyle.Quint)
	end
	function __Ixa_guiWindow:_closePopups()
		if self._closePopup then
			self._closePopup()
		end
	end
	function __Ixa_guiWindow:_popoutLayer()
		if self._popLayer then
			return self._popLayer
		end
		local b_ = __Ixa_guiNew(
			"Frame",
			{ Name = "PopOuts", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 20, Parent = self.Gui }
		)
		local b0 = __Ixa_guiNew("UIScale", { Parent = b_ })
		self._popLayer = b_
		self._popPanels = {}
		self:_listen("Render", function()
			local b1 = math.max(self.Scale.Scale, 0.05)
			if math.abs(b0.Scale - b1) > 1e-4 then
				b0.Scale = b1
				b_.Size = UDim2.fromScale(1 / b1, 1 / b1)
			end
			b_.Visible = self.Open == true and not self._destroyed
		end)
		return b_
	end
	function __Ixa_guiWindow:_popupHost(b_)
		local b0 = self._popLayer
		if b0 and b_ and b_:IsDescendantOf(b0) then
			return b0
		end
		return self.Body
	end
	function __Ixa_guiWindow:_overPopout(b_)
		local b0 = self._popLayer
		if not b0 or not b0.Visible then
			return false
		end
		for b1, b2 in ipairs(self._popPanels) do
			if b2.Parent and b2.Visible and __Ixa_guiContainsPoint(b_, b2) then
				return true
			end
		end
		return false
	end
	function __Ixa_guiWindow:_fade(b_, b0)
		local b1, b2 = self._fader, self.Body
		self._fadeGeneration = (self._fadeGeneration or 0) + 1
		local b3 = self._fadeGeneration
		if b2.Parent ~= b1 then
			b1.GroupTransparency = self._bodyAlpha
			b2.Parent = b1
		end
		b1.Visible = true
		self._bodyAlpha = b_
		__Ixa_guiTween(b1, { GroupTransparency = b_ }, b0)
		task.delay(b0 + 0.03, function()
			if self._fadeGeneration == b3 and b_ <= 0 and not self._destroyed then
				b2.Parent = self.Root
				b1.Visible = false
			end
		end)
	end
	function __Ixa_guiWindow:SelectTab(b_)
		if self.CurrentTab == b_ then
			return
		end
		local b0 = self.CurrentTab
		self:_resetSearch()
		self:_closePopups()
		self.CurrentTab = b_
		self:_settleTransition()
		local b1 = (self._transitionGeneration or 0) + 1
		self._transitionGeneration = b1
		if b0 then
			__Ixa_guiTween(b0._label, { TextColor3 = __Ixa_guiTheme.Muted }, 0.3)
			if b0._icon then
				__Ixa_guiTintIcon(b0._icon, __Ixa_guiTheme.Muted, false, 0.3)
			end
			local b2 = self._outLayer
			b0._page.Parent = b2
			self._outPage = b0._page
			b2.GroupTransparency = 0
			b2.Position = UDim2.fromOffset(0, 0)
			b2.Visible = true
			__Ixa_guiTween(b2, { GroupTransparency = 1, Position = UDim2.fromOffset(0, -6) }, 0.2, Enum.EasingStyle.Quint)
			task.delay(0.18, function()
				if self._transitionGeneration == b1 then
					self:_settleOut()
				end
			end)
		end
		__Ixa_guiTween(b_._button, { BackgroundTransparency = 1 }, 0.2)
		__Ixa_guiTween(b_._stroke, { Transparency = 1 }, 0.2)
		__Ixa_guiTween(b_._label, { TextColor3 = __Ixa_guiTheme.Text }, 0.3)
		if b_._icon then
			__Ixa_guiTintIcon(b_._icon, __Ixa_guiTheme.Text, true, 0.3)
		end
		self:_placeIndicator(b_)
		self:_scrollTabIntoView(b_)
		local b2 = b_._page
		b2.Position = UDim2.fromOffset(0, 0)
		b2.Visible = true
		b2.Parent = self._inLayer
		self._inPage = b2
		bz(self._inLayer)
		task.delay(0.32, function()
			if self._transitionGeneration == b1 then
				self:_settleIn()
			end
		end)
	end
	function __Ixa_guiWindow:_settleOut()
		local b_ = self._outPage
		if b_ then
			b_.Parent = self.Content
			b_.Visible = false
			self._outPage = nil
		end
		self._outLayer.Visible = false
	end
	function __Ixa_guiWindow:_settleIn()
		local b_ = self._inPage
		if b_ then
			b_.Parent = self.Content
			b_.Position = UDim2.fromOffset(0, 0)
			self._inPage = nil
		end
		self._inLayer.Visible = false
	end
	function __Ixa_guiWindow:_settleTransition()
		self:_settleOut()
		self:_settleIn()
	end
	local b_ = {
		Rain = { Image = "rbxassetid://241868005", Count = 90, Stretch = true },
		Snow = { Image = "rbxassetid://99851851", Count = 60 },
		Ember = { Image = "rbxassetid://242205518", Count = 55 },
		Sakura = { Petal = true, Count = 46, Glow = Color3.fromRGB(255, 150, 190), GlowAmount = 0.1 },
		Fireflies = { Image = __Ixa_guiAssets.Glow, Count = 34, Glow = Color3.fromRGB(70, 150, 60), GlowAmount = 0.16 },
		Matrix = {
			Text = true,
			Count = 38,
			Glow = Color3.fromRGB(30, 200, 90),
			GlowAmount = 0.07,
			Glyphs = "01234567890123456789\u{30a2}\u{30a4}\u{30a6}\u{30a8}\u{30aa}\u{30ab}\u{30ad}\u{30af}\u{30b1}\u{30b3}\u{30b5}\u{30b7}\u{30b9}\u{30bb}\u{30bd}\u{30bf}\u{30c1}\u{30c4}\u{30c6}\u{30c8}\u{30ca}\u{30cb}\u{30cc}\u{30cd}\u{30ce}\u{30cf}\u{30d2}\u{30d5}\u{30d8}\u{30db}\u{30de}\u{30df}\u{30e0}\u{30e1}\u{30e2}\u{30e4}\u{30e6}\u{30e8}\u{30e9}\u{30ea}\u{30eb}\u{30ec}\u{30ed}\u{30ef}\u{30f3}+-*=<>:",
		},
	}
	local b0 = {
		rain = "Rain",
		snow = "Snow",
		ember = "Ember",
		embers = "Ember",
		fire = "Ember",
		hellfire = "Ember",
		sakura = "Sakura",
		petals = "Sakura",
		cherryblossom = "Sakura",
		firefly = "Fireflies",
		fireflies = "Fireflies",
		matrix = "Matrix",
		matrixrain = "Matrix",
		code = "Matrix",
	}
	local b1 = Vector2.new(7 / 420, 151 / 263)
	local b2 = Random.new()
	local function b3(b4)
		if type(b4) == "string" and ({ ui = true, window = true, inside = true })[b4:lower()] then
			return "UI"
		end
		return "Screen"
	end
	local function b4(b6)
		if type(b6) ~= "string" then
			return "None"
		end
		return b0[(b6:lower():gsub("[%s_%-]", ""))] or "None"
	end
	local function b6(b7, b8)
		return b2:NextNumber(b7, b8)
	end
	local function b7(b8, b9, ca, cb, cc)
		b9.Time = b6(0, 10)
		b9.Phase = b6(0, math.pi * 2)
		if b8 == "Rain" then
			local cd = b6(2, 3.5)
			b9.Size = Vector2.new(cd, b6(26, 52))
			b9.VY = b6(950, 1400)
			b9.VX = b9.VY * 0.12
			b9.Sway, b9.Spin = 0, 0
			b9.Rotation = -math.deg(math.atan2(b9.VX, b9.VY))
			b9.Alpha = b6(0, 0.35)
			b9.X = b6(-0.15 * ca, ca)
			b9.Y = cc and b6(-40, cb) or b6(-120, -b9.Size.Y)
		elseif b8 == "Snow" then
			local cd = b6(6, 17)
			b9.Size = Vector2.new(cd, cd)
			b9.VY = b6(30, 55) * (0.6 + cd / 17)
			b9.VX = b6(-8, 14)
			b9.Sway = b6(12, 38)
			b9.Frequency = b6(0.5, 1.3)
			b9.Spin = b6(-60, 60)
			b9.Rotation = b6(0, 360)
			b9.Alpha = b6(0.05, 0.45)
			b9.X = b6(0, ca)
			b9.Y = cc and b6(-20, cb) or b6(-60, -cd)
		elseif b8 == "Sakura" then
			local cd = b6(7, 14)
			b9.Size = Vector2.new(cd, cd * b6(0.55, 0.75))
			b9.VY = b6(35, 70)
			b9.VX = b6(18, 45)
			b9.Sway = b6(14, 34)
			b9.Frequency = b6(0.6, 1.4)
			b9.Flutter = b6(1.2, 2.6)
			b9.Spin = b6(-90, 90)
			b9.Rotation = b6(0, 360)
			b9.Alpha = b6(0.05, 0.35)
			b9.Color = Color3.fromRGB(255, 205, 220):Lerp(Color3.fromRGB(255, 140, 180), b6(0, 1))
			b9.X = b6(-0.25 * ca, ca)
			b9.Y = cc and b6(-20, cb) or b6(-60, -cd)
		elseif b8 == "Fireflies" then
			local cd = b6(14, 28)
			b9.Size = Vector2.new(cd, cd)
			b9.VY = b6(-14, 8)
			b9.VX = b6(-12, 12)
			b9.Sway = b6(10, 30)
			b9.SwayY = b6(8, 22)
			b9.Frequency = b6(0.3, 0.8)
			b9.Spin, b9.Rotation = 0, 0
			b9.Alpha = b6(0, 0.25)
			b9.Life = b6(5, 11)
			b9.Age = cc and b6(0, b9.Life) or 0
			b9.Pulse = b6(1.5, 3.5)
			b9.Color = Color3.fromRGB(200, 255, 120):Lerp(Color3.fromRGB(255, 230, 120), b6(0, 1))
			b9.X = b6(0, ca)
			b9.Y = b6(cb * 0.15, cb)
		elseif b8 == "Matrix" then
			local cd = b_.Matrix
			if not cd.List then
				cd.List = {}
				for ce, cf in utf8.codes(cd.Glyphs) do
					table.insert(cd.List, utf8.char(cf))
				end
			end
			local ce = cd.List
			local cf = math.floor(b6(12, 19))
			local cg = math.floor(b6(8, 20))
			b9.TextSize = cf
			b9.Size = Vector2.new(cf + 6, cf * cg)
			b9.VY = b6(160, 360) * (cf / 15)
			b9.VX, b9.Sway, b9.Spin, b9.Rotation = 0, 0, 0, 0
			b9.Alpha = b6(0, 0.25) + (19 - cf) * 0.04
			b9.X = math.floor(b6(0, ca) / 18) * 18 + 9
			b9.Y = cc and b6(-b9.Size.Y / 2, cb) or -b9.Size.Y / 2 - b6(0, 240)
			b9.Chars = {}
			for ch = 1, cg do
				b9.Chars[ch] = ce[math.random(#ce)]
			end
			b9.Shuffle = b6(0.05, 0.2)
		else
			local cd = b6(4, 12)
			b9.Size = Vector2.new(cd, cd)
			b9.VY = -b6(60, 170)
			b9.VX = b6(-12, 12)
			b9.Sway = b6(8, 28)
			b9.Frequency = b6(1, 2.4)
			b9.Spin = b6(-140, 140)
			b9.Rotation = b6(0, 360)
			b9.Alpha = b6(0, 0.3)
			b9.Color = Color3.fromRGB(255, 70, 20):Lerp(Color3.fromRGB(255, 190, 70), b6(0, 1))
			b9.X = b6(0, ca)
			b9.Y = cc and b6(cb * 0.2, cb + 10) or cb + b6(10, 80)
		end
		local cd = b9.Label
		if b8 == "Rain" then
			cd.Size = UDim2.fromOffset(b9.Size.X / b1.X, b9.Size.Y / b1.Y)
		else
			cd.Size = UDim2.fromOffset(b9.Size.X, b9.Size.Y)
		end
		if b8 == "Matrix" then
			cd.TextSize = b9.TextSize
			cd.Text = table.concat(b9.Chars, "\n")
		elseif b8 == "Sakura" then
			cd.BackgroundColor3 = b9.Color
		else
			cd.ImageColor3 = b9.Color or (b8 == "Rain" and Color3.fromRGB(190, 210, 245) or Color3.new(1, 1, 1))
		end
	end
	function __Ixa_guiWindow:_buildBackdrop(b8)
		local b9 = __Ixa_guiNew(
			"Frame",
			{ Name = "Backdrop", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 0, Parent = self.Gui }
		)
		local ca = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 0,
				Parent = b9,
			}
		)
		__Ixa_guiNew(
			"UIGradient",
			{
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.5, 0.3),
					NumberSequenceKeypoint.new(1, 0),
				}),
				Parent = ca,
			}
		)
		local cb = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.fromScale(1, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 60, 15),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1,
				Parent = b9,
			}
		)
		__Ixa_guiNew("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = cb })
		local cc = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2, Parent = b9 }
		)
		cb.Parent = cc
		self._backdrop = b9
		self._backdropTintFrame = ca
		self._backdropHeat = cb
		self._weatherField = cc
		self._weatherParticles = {}
		self._backdropFade = 0
		self._weatherKick = 0
		self._backdropShown = false
		self._backdropEnabled = b8.Enabled ~= false
		self._backdropTint = math.clamp(tonumber(b8.Tint) or 0.45, 0, 1)
		self._backdropDim = b8.Dim ~= false
		self._dimLevel = self._backdropDim and 1 or 0
		self._weatherDensity = math.clamp(tonumber(b8.Density) or 1, 0, 3)
		self._weatherSpeed = math.clamp(tonumber(b8.Speed) or 1, 0.1, 3)
		self.Weather = b4(b8.Weather == nil and "Snow" or b8.Weather)
		self.WeatherMode = "Screen"
		self:SetWeatherMode(b8.Mode)
		self:_rebuildWeather()
		table.insert(self._frameSteps, function(cd)
			self:_stepBackdrop(cd)
		end)
	end
	function __Ixa_guiWindow:_weatherSize()
		if self.WeatherMode == "UI" then
			return Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
		end
		return self.Gui.AbsoluteSize
	end
	function __Ixa_guiWindow:_rebuildWeather()
		for b8, b9 in ipairs(self._weatherParticles) do
			b9.Label:Destroy()
		end
		self._weatherParticles = {}
		local b8 = b_[self.Weather]
		if not b8 then
			return
		end
		self._backdropHeat.BackgroundColor3 = b8.Glow or Color3.fromRGB(255, 60, 15)
		local b9 = self:_weatherSize()
		local ca = b8.Count * self._weatherDensity * (self.WeatherMode == "UI" and 0.45 or 1)
		for cb = 1, math.floor(ca + 0.5) do
			local cc, cd
			if b8.Text then
				cd = "TextTransparency"
				cc = __Ixa_guiNew(
					"TextLabel",
					{
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Text = "",
						TextColor3 = Color3.fromRGB(90, 255, 140),
						TextTransparency = 1,
						FontFace = Font.fromEnum(Enum.Font.Code),
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Top,
						LineHeight = 1,
						ZIndex = 2,
						Parent = self._weatherField,
					}
				)
				__Ixa_guiNew(
					"UIGradient",
					{
						Rotation = 90,
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(0.88, Color3.new(1, 1, 1)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 255, 240)),
						}),
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(0.6, 0.45),
							NumberSequenceKeypoint.new(1, 0),
						}),
						Parent = cc,
					}
				)
			elseif b8.Petal then
				cd = "BackgroundTransparency"
				cc = __Ixa_guiNew(
					"Frame",
					{
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 190, 210),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ZIndex = 2,
						Parent = self._weatherField,
					}
				)
				__Ixa_guiCorner(cc, UDim.new(1, 0))
				__Ixa_guiNew(
					"UIGradient",
					{ Rotation = 35, Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(235, 200, 215)), Parent = cc }
				)
			else
				cd = "ImageTransparency"
				cc = __Ixa_guiNew(
					"ImageLabel",
					{
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = b8.Image,
						ImageTransparency = 1,
						ScaleType = b8.Stretch and Enum.ScaleType.Stretch or Enum.ScaleType.Fit,
						ZIndex = 2,
						Parent = self._weatherField,
					}
				)
			end
			local ce = { Label = cc, Property = cd }
			b7(self.Weather, ce, b9.X, b9.Y, true)
			table.insert(self._weatherParticles, ce)
		end
	end
	function __Ixa_guiWindow:_stepBackdrop(b8)
		local b9 = self._backdropShown and 1 or 0
		local ca = self._backdropFade
		if ca == b9 then
			if b9 == 0 then
				return
			end
			local dimTarget = self._backdropDim and 1 or 0
			if self.Weather == "None" and self._lastBackdropWeather == self.Weather and self._dimLevel == dimTarget and self._lastBackdropTint == self._backdropTint then
				return
			end
		end
		if ca < b9 then
			ca = math.min(ca + b8 / 0.45, b9)
		elseif ca > b9 then
			ca = math.max(ca - b8 / 0.25, b9)
		end
		self._backdropFade = ca
		if ca <= 0 then
			self._backdrop.Visible = false
			self._weatherField.Visible = false
			return
		end
		local cb = 1 - (1 - ca) ^ 3
		local cc = self.Weather
		local cd = self._dimLevel
		if self._backdropDim then
			cd = math.min(cd + b8 / 0.3, 1)
		else
			cd = math.max(cd - b8 / 0.3, 0)
		end
		self._dimLevel = cd
		self._backdropTintFrame.BackgroundTransparency = 1 - self._backdropTint * cb * cd
		self._lastBackdropTint = self._backdropTint
		self._lastBackdropWeather = self.Weather
		local ce = b_[cc]
		self._backdropHeat.BackgroundTransparency = cc == "Ember" and 1 - (0.22 + math.sin(os.clock() * 2.1) * 0.05) * cb
			or ce and ce.GlowAmount and 1 - (ce.GlowAmount + math.sin(os.clock() * 0.8) * ce.GlowAmount * 0.25) * cb
			or 1
		local cf = self._weatherKick
		self._weatherKick = math.max(cf - b8 * 1.3, 0)
		local cg = self._weatherSpeed * (1 + cf * cf * 2.5)
		local ch = self:_weatherSize()
		local ci, cj = ch.X, ch.Y
		for ck, cl in ipairs(self._weatherParticles) do
			cl.Time += b8
			cl.X += cl.VX * b8 * cg
			cl.Y += cl.VY * b8 * cg
			cl.Rotation += cl.Spin * b8 * cg
			local cm = math.max(cl.Size.X, cl.Size.Y)
			if cl.Life then
				cl.Age += b8
			end
			if
				(cl.Life and cl.Age > cl.Life) or (
					not cl.Life and ((cl.VY > 0 and cl.Y > cj + cm) or (cl.VY < 0 and cl.Y < -cm))
				)
			then
				b7(cc, cl, ci, cj, false)
			elseif cl.X > ci + cm * 4 then
				cl.X -= ci + cm * 6
			elseif cl.X < -cm * 4 then
				cl.X += ci + cm * 6
			end
			local cn = cl.X
			local co = 1 - cl.Alpha
			if cl.Sway ~= 0 then
				cn += math.sin(cl.Time * cl.Frequency + cl.Phase) * cl.Sway
			end
			local cp = cl.Y
			local cq = cl.Label
			if cc == "Ember" then
				co *= math.clamp(cl.Y / (cj * 0.85), 0, 1) ^ 0.6
				co *= 0.75 + math.sin(cl.Time * 9 + cl.Phase) * 0.25
			elseif cc == "Sakura" then
				local cr = math.abs(math.cos(cl.Time * cl.Flutter + cl.Phase))
				cq.Size = UDim2.fromOffset(cl.Size.X * (0.3 + cr * 0.7), cl.Size.Y)
			elseif cc == "Fireflies" then
				cp += math.cos(cl.Time * cl.Frequency * 1.3 + cl.Phase) * cl.SwayY
				local cr, cs = cl.Age, cl.Life
				co *= math.clamp(math.min(cr / 1.2, (cs - cr) / 1.2), 0, 1)
				co *= 0.5 + math.sin(cl.Time * cl.Pulse + cl.Phase) * 0.5
			elseif cc == "Matrix" then
				cl.Shuffle -= b8 * cg
				if cl.Shuffle <= 0 then
					cl.Shuffle = b6(0.05, 0.2)
					local cr = b_.Matrix.List
					local cs = cl.Chars
					cs[math.random(#cs)] = cr[math.random(#cr)]
					cs[#cs] = cr[math.random(#cr)]
					cq.Text = table.concat(cs, "\n")
				end
			end
			cq.Position = UDim2.fromOffset(cn, cp)
			cq.Rotation = cl.Rotation
			cq[cl.Property or "ImageTransparency"] = 1 - co * cb
		end
	end
	function __Ixa_guiWindow:_refreshBackdrop(b8)
		if not self._backdrop then
			return
		end
		local b9 = self._backdropEnabled
			and self._introDone
			and self.Open
			and not self.Minimized
			and not self._destroyed
		if b9 and not self._backdropShown then
			self._backdrop.Visible = true
			self._weatherField.Visible = true
			if self._backdropFade <= 0 then
				local ca = self:_weatherSize()
				for cb, cc in ipairs(self._weatherParticles) do
					b7(self.Weather, cc, ca.X, ca.Y, true)
				end
			end
			if b8 then
				self._weatherKick = 1
			end
		end
		self._backdropShown = b9 == true
	end
	function __Ixa_guiWindow:SetBackdrop(b8)
		if not self._backdrop then
			return
		end
		self._backdropEnabled = b8 ~= false
		self:_refreshBackdrop(true)
	end
	function __Ixa_guiWindow:SetBackdropTint(b8)
		if not self._backdrop then
			return
		end
		self._backdropTint = math.clamp(tonumber(b8) or 0.45, 0, 1)
	end
	function __Ixa_guiWindow:SetDim(b8)
		if not self._backdrop then
			return
		end
		self._backdropDim = b8 ~= false
	end
	function __Ixa_guiWindow:SetWeatherMode(b8)
		if not self._backdrop then
			return
		end
		b8 = b3(b8)
		local b9 = self._weatherField
		if b8 == "UI" then
			b9.ZIndex = 0
			b9.Parent = self.Body
		else
			b9.ZIndex = 2
			b9.Parent = self._backdrop
		end
		if b8 == self.WeatherMode then
			return
		end
		self.WeatherMode = b8
		self:_rebuildWeather()
		if self._backdropShown then
			self._weatherKick = 1
		end
	end
	function __Ixa_guiWindow:SetWeather(b8)
		if not self._backdrop then
			return
		end
		local b9 = b4(b8)
		if b9 == self.Weather then
			return
		end
		self.Weather = b9
		self:_rebuildWeather()
		if self._backdropShown then
			self._weatherKick = 1
		end
	end
	function __Ixa_guiWindow:SetWeatherDensity(b8)
		if not self._backdrop then
			return
		end
		self._weatherDensity = math.clamp(tonumber(b8) or 1, 0, 3)
		self:_rebuildWeather()
	end
	function __Ixa_guiWindow:SetWeatherSpeed(b8)
		if not self._backdrop then
			return
		end
		self._weatherSpeed = math.clamp(tonumber(b8) or 1, 0.1, 3)
	end
	local b8 =
		{ Top = 8, Width = __Ixa_guiTouch and 176 or 168, Height = __Ixa_guiTouch and 36 or 32, Wide = 340, Radius = 34, Bars = 4, Pinned = 6 }
	local function b9(ca, cb, cc, cd)
		if ca._ghost then
			ca._ghost:Destroy()
		end
		local ce = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(cb.X, cb.Y),
				Size = UDim2.fromOffset(cc.X, cc.Y),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 29,
				Parent = ca.Gui,
			}
		)
		local cf = __Ixa_guiLibrary._fixedCorner(ce, UDim.new(0, cd))
		local cg = __Ixa_guiStroke(ce, __Ixa_guiTheme.Stroke, 1)
		ca._ghost = ce
		return ce, cg, cf
	end
	local function ca(cb, cc, cd, ce, cf, cg)
		__Ixa_guiTween(
			cb,
			{ Position = UDim2.fromOffset(cd.X, cd.Y), Size = UDim2.fromOffset(ce.X, ce.Y) },
			cg,
			Enum.EasingStyle.Quint
		)
		__Ixa_guiTween(cc, { CornerRadius = UDim.new(0, cf) }, cg, Enum.EasingStyle.Quint)
	end
	local function cb(cc, cd, ce, cf)
		__Ixa_guiTween(cd, { BackgroundTransparency = 1 }, cf, Enum.EasingStyle.Quad)
		__Ixa_guiTween(ce, { Transparency = 1 }, cf, Enum.EasingStyle.Quad)
		task.delay(cf + 0.02, function()
			if cc._ghost == cd then
				cc._ghost = nil
			end
			cd:Destroy()
		end)
	end
	function __Ixa_guiWindow:_buildMiniBar()
		if self.MiniBar then
			return self.MiniBar
		end
		local cc = self.Gui
		local cd = __Ixa_guiNew(
			"CanvasGroup",
			{
				Name = "Island",
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, b8.Top),
				Size = UDim2.fromOffset(b8.Width, b8.Height),
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				GroupTransparency = 1,
				Visible = false,
				ZIndex = 30,
				Parent = cc,
			}
		)
		local ce = __Ixa_guiLibrary._fixedCorner(cd, UDim.new(0, b8.Height / 2))
		local cf = __Ixa_guiNew("UIScale", { Parent = cd })
		self._miniScale = cf
		local cg = __Ixa_guiNew("NumberValue", { Value = 1 })
		local ch
		self._miniOrb = cd
		local function ci(cj)
			return __Ixa_guiNew(
				"CanvasGroup",
				{
					Name = cj,
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.new(0, b8.Wide, 0, 400),
					BackgroundTransparency = 1,
					GroupTransparency = 1,
					Parent = cd,
				}
			)
		end
		local cj = __Ixa_guiNew(
			"CanvasGroup",
			{ Name = "Compact", Size = UDim2.fromScale(1, 1), BackgroundColor3 = __Ixa_guiTheme.Surface2, BorderSizePixel = 0, Parent = cd }
		)
		__Ixa_guiNew(
			"UIGradient",
			{ Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(120, 120, 120)), Parent = cj }
		)
		local ck = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 5, 0.5, 0),
				Size = UDim2.fromOffset(b8.Height - 10, b8.Height - 10),
				BackgroundColor3 = __Ixa_guiTheme.Accent,
				BackgroundTransparency = 0.82,
				BorderSizePixel = 0,
				Parent = cj,
			}
		)
		__Ixa_guiCorner(ck, UDim.new(1, 0))
		local cl = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(16, 16),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ScaleType = Enum.ScaleType.Fit,
				Parent = ck,
			}
		)
		__Ixa_guiApplyIcon(cl, self._logoIcon == __Ixa_guiAssets.Logo and __Ixa_guiAssets.LogoSmall or self._logoIcon, true)
		local cm = __Ixa_guiLabel({
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, b8.Height + 2, 0.5, 0),
			Size = UDim2.new(1, -b8.Height - 2 - 72, 0, 18),
			Text = self.Title,
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Bold,
			TextColor3 = __Ixa_guiTheme.Text,
			Parent = cj,
		})
		local cn = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -14, 0.5, 0),
				Size = UDim2.fromOffset(0, 18),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Parent = cj,
			}
		)
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 7),
				Parent = cn,
			}
		)
		local co = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.fromOffset(b8.Bars * 3 + (b8.Bars - 1) * 2, 16),
				BackgroundTransparency = 1,
				Visible = false,
				LayoutOrder = 1,
				Parent = cn,
			}
		)
		local cp = {}
		for cq = 1, b8.Bars do
			local cr = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, (cq - 1) * 5, 0.5, 0),
					Size = UDim2.fromOffset(3, 3),
					BackgroundColor3 = __Ixa_guiTheme.Muted,
					BorderSizePixel = 0,
					Parent = co,
				}
			)
			__Ixa_guiCorner(cr, UDim.new(1, 0))
			cp[cq] = cr
		end
		local cq = __Ixa_guiLabel({
			Size = UDim2.fromOffset(0, 18),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = "",
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Bold,
			TextTruncate = Enum.TextTruncate.None,
			Visible = false,
			LayoutOrder = 2,
			Parent = cn,
		})
		local cr = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.fromOffset(6, 6), BackgroundColor3 = __Ixa_guiTheme.Accent, BorderSizePixel = 0, LayoutOrder = -1, Parent = cn }
		)
		__Ixa_guiCorner(cr, UDim.new(1, 0))
		local cs = __Ixa_guiLabel({
			Size = UDim2.fromOffset(0, 18),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = "0s",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Bold,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextTruncate = Enum.TextTruncate.None,
			LayoutOrder = 0,
			Parent = cn,
		})
		local ct = ci("Expanded")
		local cu = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(16, 14),
				Size = UDim2.new(1, -32, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = ct,
			}
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = cu })
		local cv =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, LayoutOrder = 1, Parent = cu })
		local cw = __Ixa_guiNew(
			"ImageLabel",
			{
				Size = UDim2.fromOffset(48, 48),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(__Ixa_guiPlayer.UserId) .. "&w=150&h=150",
				Parent = cv,
			}
		)
		__Ixa_guiCorner(cw, UDim.new(0, 12))
		local cx = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(20, 20),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Muted,
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Fit,
				Parent = cw,
			}
		)
		__Ixa_guiApplyIcon(cx, "user")
		self:_trackAvatar(cw, cx)
		local cy = __Ixa_guiLabel({
			Position = UDim2.fromOffset(60, 5),
			Size = UDim2.new(1, -150, 0, 20),
			TextSize = 15,
			FontFace = __Ixa_guiFonts.Bold,
			TextColor3 = __Ixa_guiTheme.Text,
			Parent = cv,
		})
		self:_trackName(cy, "Display")
		local cz = __Ixa_guiLabel({
			Position = UDim2.fromOffset(60, 26),
			Size = UDim2.new(1, -150, 0, 15),
			Text = "",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			Parent = cv,
		})
		task.spawn(function()
			cz.Text = __Ixa_guiGameName()
		end)
		local cA = __Ixa_guiLabel({
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 3),
			Size = UDim2.fromOffset(90, 24),
			Text = "0s",
			TextSize = 20,
			FontFace = __Ixa_guiFonts.Bold,
			TextColor3 = __Ixa_guiTheme.Text,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = cv,
		})
		__Ixa_guiLabel({
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 27),
			Size = UDim2.fromOffset(90, 14),
			Text = "session",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = cv,
		})
		local cB =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, LayoutOrder = 2, Parent = cu })
		local function cC(cD, cE)
			local cF = __Ixa_guiNew(
				"Frame",
				{ Position = cD, Size = UDim2.new(0.5, -10, 1, 0), BackgroundTransparency = 1, Parent = cB }
			)
			local cG = __Ixa_guiLabel({
				Size = UDim2.new(1, -70, 0, 24),
				Text = "",
				TextSize = 20,
				FontFace = __Ixa_guiFonts.Bold,
				TextColor3 = __Ixa_guiTheme.Text,
				RichText = true,
				Parent = cF,
			})
			__Ixa_guiLabel({
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 6),
				Size = UDim2.fromOffset(70, 14),
				Text = cE,
				TextSize = 12,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = cF,
			})
			local cH = __Ixa_guiNew(
				"Frame",
				{
					AnchorPoint = Vector2.new(0, 1),
					Position = UDim2.new(0, 0, 1, -4),
					Size = UDim2.new(1, 0, 0, 3),
					BackgroundColor3 = __Ixa_guiTheme.Surface3,
					BorderSizePixel = 0,
					Parent = cF,
				}
			)
			__Ixa_guiCorner(cH, UDim.new(1, 0))
			local cI = __Ixa_guiNew(
				"Frame",
				{ Size = UDim2.fromScale(0, 1), BackgroundColor3 = __Ixa_guiTheme.Success, BorderSizePixel = 0, Parent = cH }
			)
			__Ixa_guiCorner(cI, UDim.new(1, 0))
			return cI, cG
		end
		local cD, cE = cC(UDim2.fromScale(0, 0), "FRAME RATE")
		local cF, cG = cC(UDim2.new(0.5, 10, 0, 0), "PING")
		local cH =
			__Ixa_guiNew("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 3, Parent = cu })
		__Ixa_guiNew(
			"UIListLayout",
			{
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8),
				Parent = cH,
			}
		)
		local function cI(cJ, cK, cL)
			local cM = __Ixa_guiNew(
				"Frame",
				{
					Size = UDim2.fromOffset(0, 30),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = __Ixa_guiTheme.Surface2,
					BorderSizePixel = 0,
					LayoutOrder = cJ,
					Parent = cH,
				}
			)
			__Ixa_guiCorner(cM, UDim.new(1, 0))
			__Ixa_guiPadding(cM, 14, 14)
			__Ixa_guiNew(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 7),
					Parent = cM,
				}
			)
			__Ixa_guiLabel({
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = cK,
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 1,
				Parent = cM,
			})
			return __Ixa_guiLabel({
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Text = "",
				TextSize = 12,
				FontFace = __Ixa_guiFonts.Bold,
				TextColor3 = cL or __Ixa_guiTheme.Text,
				TextTruncate = Enum.TextTruncate.None,
				LayoutOrder = 2,
				Parent = cM,
			})
		end
		local cJ = cI(1, "Players")
		local cK = cI(2, "Running", __Ixa_guiTheme.Accent)
		local cL = cI(3, "Tab")
		local cM = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Visible = false, LayoutOrder = 4, Parent = cu }
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = cM })
		local cN = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 15),
			Text = "",
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			RichText = true,
			Visible = false,
			LayoutOrder = 4,
			Parent = cu,
		})
		local cO = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 14),
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			LayoutOrder = 5,
			Parent = cu,
		})
		local cP = self._sessionStart or os.clock()
		local cQ, cR, cS = 0, os.clock(), 60
		self:_listen("Render", function()
			cQ += 1
			local cT = os.clock()
			if cT - cR >= 0.5 then
				cS = math.floor(cQ / (cT - cR) + 0.5)
				cQ, cR = 0, cT
			end
		end)
		local function cT()
			cA.Text = bA(os.clock() - cP)
			cs.Text = cA.Text
			__Ixa_guiTween(cr, { BackgroundColor3 = __Ixa_guiLibrary._healthColor(cS, 50, 30) }, 0.4)
			local cU = '<font size="12" color="#8A8A93"> %s</font>'
			cE.Text = cS .. string.format(cU, "fps")
			__Ixa_guiTween(
				cD,
				{ Size = UDim2.fromScale(math.clamp(cS / 60, 0.05, 1), 1), BackgroundColor3 = __Ixa_guiLibrary._healthColor(cS, 50, 30) },
				0.4,
				Enum.EasingStyle.Quint
			)
			local cV, cW = pcall(function()
				return math.floor(__Ixa_guiPlayer:GetNetworkPing() * 1000)
			end)
			cW = cV and cW or 0
			cG.Text = cW .. string.format(cU, "ms")
			__Ixa_guiTween(
				cF,
				{
					Size = UDim2.fromScale(math.clamp(1 - (cW - 40) / 360, 0.05, 1), 1),
					BackgroundColor3 = __Ixa_guiLibrary._healthColor(cW, 90, 180, true),
				},
				0.4,
				Enum.EasingStyle.Quint
			)
			cJ.Text = #__Ixa_guiPlayers:GetPlayers() .. "/" .. __Ixa_guiPlayers.MaxPlayers
			local cX = self.CurrentTab
			cL.Text = cX and cX.Name or "-"
		end
		task.spawn(function()
			while cd.Parent do
				if cd.Visible and self.Minimized then
					cT()
				end
				task.wait(0.5)
			end
		end)
		local cU = ci("Activity")
		local cV = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(16, 13),
				Size = UDim2.new(1, -32, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = cU,
			}
		)
		local cW = __Ixa_guiNew(
			"Frame",
			{
				Size = UDim2.fromOffset(34, 34),
				BackgroundColor3 = __Ixa_guiTheme.Accent,
				BackgroundTransparency = 0.85,
				BorderSizePixel = 0,
				Parent = cV,
			}
		)
		__Ixa_guiCorner(cW, UDim.new(1, 0))
		local cX = __Ixa_guiNew(
			"ImageLabel",
			{
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(17, 17),
				BackgroundTransparency = 1,
				ImageColor3 = __Ixa_guiTheme.Accent,
				ScaleType = Enum.ScaleType.Fit,
				Parent = cW,
			}
		)
		local cY = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(46, 0),
				Size = UDim2.new(1, -46, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = cV,
			}
		)
		__Ixa_guiNew("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1), Parent = cY })
		local cZ = __Ixa_guiLabel({ Size = UDim2.new(1, 0, 0, 18), TextSize = 14, FontFace = __Ixa_guiFonts.Bold, LayoutOrder = 1, Parent = cY })
		local c_ = __Ixa_guiLabel({
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			TextSize = 12,
			FontFace = __Ixa_guiFonts.Regular,
			TextColor3 = __Ixa_guiTheme.Muted,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.None,
			TextYAlignment = Enum.TextYAlignment.Top,
			MaxVisibleGraphemes = 140,
			LayoutOrder = 2,
			Parent = cY,
		})
		local c0 = __Ixa_guiNew(
			"TextButton",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 10, Parent = cd }
		)
		local c1 = { Compact = cj, Expanded = ct, Activity = cU }
		local c2 = "Compact"
		local c3 = 0
		local c4, c5
		local c6, c7 = false, false
		local c8 = 0
		local c9, da, db, dc = nil, nil, false, false
		local dd = 0
		local de = false
		local function df(dg)
			if dg == "Expanded" then
				return Vector2.new(b8.Wide, math.floor(cu.AbsoluteSize.Y + 28 + 0.5)), b8.Radius
			elseif dg == "Activity" then
				return Vector2.new(b8.Wide, math.floor(math.max(cV.AbsoluteSize.Y, 34) + 26 + 0.5)), b8.Radius
			end
			return Vector2.new(b8.Width, b8.Height), b8.Height / 2
		end
		local dg = self:_readConfigSettings().IslandPosition
		if type(dg) == "table" and tonumber(dg.X) and tonumber(dg.Y) then
			self._islandAnchor = Vector2.new(math.clamp(tonumber(dg.X), 0, 1), math.clamp(tonumber(dg.Y), 0, 1))
		end
		local dh
		local function di()
			local dj = cc.AbsoluteSize
			local dk = self._islandAnchor
			if not dk then
				return Vector2.new(dj.X / 2, b8.Top)
			end
			return Vector2.new(dk.X * dj.X, dk.Y * dj.Y)
		end
		local function dj(dk, dl)
			local dm = cc.AbsoluteSize
			local dn = dl or di()
			local dp = 6
			local dq = math.clamp(dn.X, dk.X / 2 + dp, math.max(dm.X - dk.X / 2 - dp, dk.X / 2 + dp))
			local dr = math.clamp(dn.Y, dp, math.max(dm.Y - dk.Y - dp, dp))
			return Vector2.new(dq, dr)
		end
		local function dk(dl, dm, dn)
			local dp = dj(dl)
			if dh then
				dh:Cancel()
				dh = nil
			end
			if dm and dm > 0 then
				dh = __Ixa_guiTween(cd, { Position = UDim2.fromOffset(dp.X, dp.Y) }, dm, dn or Enum.EasingStyle.Quint)
			else
				cd.Position = UDim2.fromOffset(dp.X, dp.Y)
			end
		end
		self._islandReset = function()
			self._islandAnchor = nil
			if cd.Visible then
				dk(Vector2.new(cd.Size.X.Offset, cd.Size.Y.Offset), 0.35)
			end
		end
		local function dl(dm, dn)
			local dp, dq = df(dm)
			local dr = dm ~= c2
			c2 = dm
			c3 += 1
			local ds = c3
			local dt = Vector2.new(cd.Size.X.Offset, cd.Size.Y.Offset)
			local du = dp.X > dt.X + 1 or dp.Y > dt.Y + 1
			local dv = dn and 0 or (du and 0.5 or 0.38)
			if c4 then
				c4:Cancel()
			end
			if c5 then
				c5:Cancel()
			end
			dk(dp, dv)
			c4 = __Ixa_guiTween(
				cd,
				{ Size = UDim2.fromOffset(dp.X, dp.Y) },
				dv,
				du and Enum.EasingStyle.Back or Enum.EasingStyle.Quint
			)
			c5 = __Ixa_guiTween(ce, { CornerRadius = UDim.new(0, dq) }, dv, Enum.EasingStyle.Quint)
			if dr and not dn and not c7 and not db then
				cf.Scale = du and 0.96 or 1.03
				__Ixa_guiTween(cf, { Scale = 1 }, du and 0.55 or 0.4, Enum.EasingStyle.Back)
			end
			if dr or dn then
				if ch then
					ch:Cancel()
					ch = nil
				end
				if dn then
					cg.Value = dm == "Compact" and 1 or 0
				elseif dm == "Compact" then
					task.delay(dv * 0.55, function()
						if c3 == ds then
							ch = __Ixa_guiTween(cg, { Value = 1 }, 0.6, Enum.EasingStyle.Back)
						end
					end)
				else
					ch = __Ixa_guiTween(cg, { Value = 0 }, 0.2, Enum.EasingStyle.Quint)
				end
			end
			if not dr and not dn then
				local dw = c1[dm]
				if dw.GroupTransparency > 0 then
					__Ixa_guiTween(dw, { GroupTransparency = 0 }, 0.22, Enum.EasingStyle.Quad)
				end
				if dw ~= cj and dw.Position ~= UDim2.fromScale(0.5, 0) then
					__Ixa_guiTween(dw, { Position = UDim2.fromScale(0.5, 0) }, 0.32, Enum.EasingStyle.Quint)
				end
				return
			end
			for dw, dx in pairs(c1) do
				if dw ~= dm then
					__Ixa_guiTween(dx, { GroupTransparency = 1 }, dn and 0 or 0.14, Enum.EasingStyle.Quad)
				end
			end
			local dw = c1[dm]
			if dn then
				dw.GroupTransparency = 0
				if dw ~= cj then
					dw.Position = UDim2.fromScale(0.5, 0)
				end
			else
				if dw ~= cj then
					dw.Position = UDim2.new(0.5, 0, 0, 6)
				end
				task.delay(0.1, function()
					if c3 == ds then
						__Ixa_guiTween(dw, { GroupTransparency = 0 }, 0.22, Enum.EasingStyle.Quad)
						if dw ~= cj then
							__Ixa_guiTween(dw, { Position = UDim2.fromScale(0.5, 0) }, 0.32, Enum.EasingStyle.Quint)
						end
					end
				end)
			end
		end
		local function dm()
			if c6 and not __Ixa_guiTouch and not db then
				dl("Expanded")
			elseif de then
				dl("Activity")
			elseif self.IslandStyle == "Always Show" and not db then
				self:_refreshMini()
				cT()
				dl("Expanded")
			else
				dl("Compact")
			end
		end
		self._islandSettle = function()
			if self.Minimized and cd.Visible and not db then
				dm()
			end
		end
		function self:_miniLand()
			c6, de = false, false
			dd += 1
			cf.Scale = 1
			dl("Compact", true)
			local dn = Vector2.new(b8.Width, b8.Height)
			local dp = dj(dn)
			return Vector2.new(dp.X - dn.X / 2, dp.Y), dn
		end
		c0.MouseEnter:Connect(function()
			if __Ixa_guiIsTouch() or db then
				return
			end
			c6 = true
			c8 += 1
			local dn = c8
			if c2 == "Expanded" then
				return
			end
			if not c7 then
				__Ixa_guiTween(cf, { Scale = 1.04 }, 0.18, Enum.EasingStyle.Quint)
			end
			task.delay(0.12, function()
				if c8 == dn and c6 and self.Minimized and not db then
					self:_refreshMini()
					cT()
					dl("Expanded")
				end
			end)
		end)
		c0.MouseLeave:Connect(function()
			c6 = false
			c8 += 1
			local dn = c8
			if not c7 then
				__Ixa_guiTween(cf, { Scale = 1 }, 0.25, Enum.EasingStyle.Quint)
			end
			task.delay(c2 == "Expanded" and 0.28 or 0.1, function()
				if c8 == dn and not c6 and self.Minimized then
					dm()
				end
			end)
		end)
		c0.InputBegan:Connect(function(dn)
			if not __Ixa_guiIsPointerPress(dn) then
				return
			end
			c7 = true
			dc = false
			__Ixa_guiTween(cf, { Scale = 0.95 }, 0.12, Enum.EasingStyle.Quad)
			if not self._islandLocked then
				c9 = Vector2.new(dn.Position.X, dn.Position.Y)
				da = dj(Vector2.new(b8.Width, b8.Height))
			end
		end)
		self:_listen("Changed", function(dn)
			if not c9 or not __Ixa_guiIsPointerMove(dn) or not self.Minimized then
				return
			end
			local dp = Vector2.new(dn.Position.X, dn.Position.Y) - c9
			if not db then
				if dp.Magnitude < (__Ixa_guiTouch and 10 or 6) then
					return
				end
				db, dc = true, true
				c6 = false
				dl("Compact")
				__Ixa_guiTween(cf, { Scale = 1.06 }, 0.2, Enum.EasingStyle.Quint)
			end
			local dq = dj(Vector2.new(b8.Width, b8.Height), da + dp)
			local dr = cc.AbsoluteSize
			self._islandAnchor = Vector2.new(dq.X / math.max(dr.X, 1), dq.Y / math.max(dr.Y, 1))
			if dh then
				dh:Cancel()
				dh = nil
			end
			cd.Position = UDim2.fromOffset(dq.X, dq.Y)
		end)
		table.insert(
			self._connections,
			__Ixa_guiInputService.InputEnded:Connect(function(dn)
				if not __Ixa_guiIsPointerPress(dn) then
					return
				end
				c9 = nil
				if c7 then
					c7 = false
					__Ixa_guiTween(cf, { Scale = 1 }, 0.35, Enum.EasingStyle.Back)
				end
				if db then
					db = false
					local dp = Vector2.new(cc.AbsoluteSize.X / 2, b8.Top)
					local dq = dj(Vector2.new(b8.Width, b8.Height))
					if (dq - dp).Magnitude < 28 then
						self._islandAnchor = nil
						dk(Vector2.new(b8.Width, b8.Height), 0.35, Enum.EasingStyle.Back)
					end
					local dr = self._islandAnchor
					self:_writeConfigSettings({ IslandPosition = dr and { X = dr.X, Y = dr.Y } or false })
					c6 = not __Ixa_guiIsTouch() and __Ixa_guiContainsPoint(__Ixa_guiMousePosition(), cd)
					task.delay(0.1, function()
						if self.Minimized and not db then
							dm()
						end
					end)
				end
			end)
		)
		table.insert(
			self._connections,
			cc:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if cd.Visible and not db then
					dk(Vector2.new(cd.Size.X.Offset, cd.Size.Y.Offset), 0)
				end
			end)
		)
		c0.MouseButton1Click:Connect(function()
			if dc then
				dc = false
				return
			end
			if self.Minimized then
				self:Restore()
			end
		end)
		self._miniUnhover = function()
			c6, c7, de = false, false, false
			c9, db = nil, false
			dd += 1
			cf.Scale = 1
			task.delay(0.15, function()
				if not self.Minimized then
					dl("Compact", true)
				end
			end)
		end
		self._islandActivity = function(dn)
			if not self.Minimized or not cd.Visible then
				return
			end
			local dp = __Ixa_guiNoticeColors[dn.Type] or __Ixa_guiTheme.Accent
			cZ.Text = tostring(dn.Title or "Notification")
			cZ.TextColor3 = __Ixa_guiNoticeColors[dn.Type] or __Ixa_guiTheme.Text
			c_.Text = tostring(dn.Content or "")
			c_.Visible = c_.Text ~= ""
			local dq = dn.Icon
			if dq == nil then
				dq = ({ Success = "circle-check", Warning = "triangle-alert", Error = "circle-x" })[dn.Type] or "bell"
			end
			__Ixa_guiApplyIcon(cX, dq)
			if not cX:GetAttribute("CustomIcon") then
				cX.ImageColor3 = dp
			end
			cW.BackgroundColor3 = dp
			de = true
			dd += 1
			local dr = dd
			task.defer(function()
				if dd == dr and not c6 and not db then
					dl("Activity")
					cf.Scale = 0.96
					__Ixa_guiTween(cf, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
				end
			end)
			task.delay(math.clamp(tonumber(dn.Duration) or 3, 1.5, 5), function()
				if dd == dr then
					de = false
					if self.Minimized and not c6 then
						dm()
					end
				end
			end)
		end
		local dn = 0
		self:_listen("Render", function()
			if cd.Visible and dn > 0 and c2 == "Compact" then
				local dp = os.clock()
				for dq, dr in ipairs(cp) do
					local ds = 0.5 + 0.5 * math.sin(dp * (6 + dq * 1.4) + dq * 1.9)
					dr.Size = UDim2.fromOffset(3, math.floor(4 + ds * 11 + 0.5))
				end
			end
		end)
		local dp = __Ixa_guiLabel({
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -14, 0.5, 0),
			Size = UDim2.new(1, -52, 0, 18),
			TextSize = 13,
			FontFace = __Ixa_guiFonts.Bold,
			TextXAlignment = Enum.TextXAlignment.Right,
			RichText = true,
			TextTransparency = 1,
			Parent = cj,
		})
		local dq = __Ixa_guiNew(
			"TextButton",
			{
				Name = "IslandBubble",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(0, 0),
				BackgroundColor3 = __Ixa_guiTheme.Surface2,
				BorderSizePixel = 0,
				Text = "",
				AutoButtonColor = false,
				Visible = false,
				ZIndex = 30,
				Parent = cc,
			}
		)
		__Ixa_guiCorner(dq, UDim.new(1, 0))
		local dr = __Ixa_guiNew("NumberValue", { Value = 0 })
		local ds = false
		local dt = nil
		local function du(dv)
			if dv == ds then
				return
			end
			ds = dv
			co.Parent = dv and dq or cn
			co.AnchorPoint = dv and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
			co.Position = dv and UDim2.fromScale(0.5, 0.5) or UDim2.new()
			cn.Visible = not dv
			__Ixa_guiTween(dp, { TextTransparency = dv and 0 or 1 }, 0.2, Enum.EasingStyle.Quad)
			__Ixa_guiTween(
				dr,
				{ Value = dv and 1 or 0 },
				dv and 0.55 or 0.3,
				dv and Enum.EasingStyle.Back or Enum.EasingStyle.Quint
			)
			if dv then
				cf.Scale = 0.96
				__Ixa_guiTween(cf, { Scale = 1 }, 0.45, Enum.EasingStyle.Back)
			end
		end
		self:_listen("Render", function()
			local dv = dr.Value * cg.Value
			local dw = cd.Visible and dv > 0.02 and cd.GroupTransparency < 0.5
			dq.Visible = dw
			if not dw then
				return
			end
			local dx = cc.AbsolutePosition
			local dy, dz = cd.AbsolutePosition - dx, cd.AbsoluteSize
			local dA = math.min(dz.Y, b8.Height)
			local dB = 6
			local dC = dy.X + dz.X + dB + dA <= cc.AbsoluteSize.X
			local dD = dC and dy.X + dz.X or dy.X
			local dE = dC and 1 or -1
			local dF = dD - dE * dA * 0.6
			local dG = dD + dE * (dB + dA / 2)
			local dH = dF + (dG - dF) * dv
			local dI = math.clamp(0.35 + 0.65 * dv, 0, 1.2)
			local dJ = math.sin(math.clamp(dv, 0, 1) * math.pi)
			dq.Position = UDim2.fromOffset(dH, dy.Y + dA / 2)
			dq.Size = UDim2.fromOffset(dA * dI * (1 + 0.4 * dJ), dA * dI * (1 - 0.18 * dJ))
			dq.BackgroundTransparency = cd.GroupTransparency
		end)
		dq.MouseButton1Click:Connect(function()
			if self.Minimized then
				self:Restore()
			end
		end)
		local dv = {}
		function self:_refreshMini()
			local dw = 0
			for dx, dy in pairs(__Ixa_guiLibrary.Flags) do
				if dy._type == "Toggle" and dy.Value == true then
					dw += 1
				end
			end
			if dw ~= dn then
				local dx = dw > dn
				dn = dw
				cq.Text = tostring(dw)
				for dy, dz in ipairs(cp) do
					__Ixa_guiTween(dz, { BackgroundColor3 = dw > 0 and __Ixa_guiTheme.Accent or __Ixa_guiTheme.Muted }, 0.25)
					if dw == 0 then
						__Ixa_guiTween(dz, { Size = UDim2.fromOffset(3, 3) }, 0.25)
					end
				end
				if dx and c2 == "Compact" and cd.Visible then
					cf.Scale = 1.06
					__Ixa_guiTween(cf, { Scale = 1 }, 0.4, Enum.EasingStyle.Back)
				end
			end
			cK.Text = tostring(dw)
			local dx = {}
			for dy, dz in pairs(__Ixa_guiLibrary.Flags) do
				if dz._type == "Toggle" and dz.Value == true and dz._searchName ~= "" then
					table.insert(dx, dz._searchName)
				end
			end
			table.sort(dx)
			local dy = {}
			for dz = 1, math.min(#dx, 3) do
				dy[dz] = __Ixa_guiLibrary._rich(dx[dz])
			end
			local dz = #dx - #dy
			cN.Text = '<font color="#8A8A93">Running </font>'
				.. table.concat(dy, '<font color="#8A8A93"> \u{b7} </font>')
				.. (dz > 0 and string.format('<font color="#8A8A93">  +%d</font>', dz) or "")
			cN.Visible = #dx > 0
			dt = nil
			for dA, dB in ipairs(self._pinned) do
				if not dB._isShown or dB:_isShown() then
					dt = dB
					break
				end
			end
			if dt then
				local dA = tostring(dt:Text() or "")
				if dA:gsub("<[^>]*>", ""):match("%S") then
					dp.Text = dA
					local dB = dt._shownColor and dt._shownColor() or __Ixa_guiTheme.Text
					local dC, dD, dE = dB:ToHSV()
					dp.TextColor3 = dE < 0.35 and __Ixa_guiTheme.Text or dB
				else
					dt = nil
				end
			end
			du(dn > 0 and dt ~= nil)
			local dA = dn > 0 and not ds
			cr.Visible = not dA
			cs.Visible = not dA
			cq.Visible = dA
			co.Visible = dn > 0
			cn.Visible = not ds
			cm.Visible = not ds
			local dB = typeof(self.Keybind) == "EnumItem" and __Ixa_guiKeyName(self.Keybind)
			cO.Text = __Ixa_guiTouch and "Tap to open" or (dB and ("Click or press " .. dB .. " to open") or "Click to open")
			local dD = {}
			for dE, dF in ipairs(self._pinned) do
				if (not dF._isShown or dF:_isShown()) and #dD < b8.Pinned then
					table.insert(dD, dF)
				end
			end
			cM.Visible = false
			for dE = 1, math.max(#dD, #dv) do
				local dF = dD[dE]
				local dG = dv[dE]
				if dF then
					if not dG then
						local dH = __Ixa_guiNew(
							"Frame",
							{ Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = dE, Parent = cM }
						)
						dG = {
							Frame = dH,
							Key = __Ixa_guiLabel({
								Size = UDim2.new(0.5, -4, 1, 0),
								TextSize = 12,
								FontFace = __Ixa_guiFonts.Regular,
								TextColor3 = __Ixa_guiTheme.Muted,
								RichText = true,
								Parent = dH,
							}),
							Value = __Ixa_guiLabel({
								AnchorPoint = Vector2.new(1, 0),
								Position = UDim2.fromScale(1, 0),
								Size = UDim2.new(0.5, -4, 1, 0),
								TextSize = 12,
								TextXAlignment = Enum.TextXAlignment.Right,
								RichText = true,
								Parent = dH,
							}),
						}
						dv[dE] = dG
					end
					dG.Frame.Visible = true
					dG.Key.Text = __Ixa_guiLibrary._rich(dF.Name)
					dG.Value.Text = dF:Text()
					local dH = dF._shownColor and dF._shownColor() or __Ixa_guiTheme.Text
					if dG.Value.TextColor3 ~= dH then
						__Ixa_guiTween(dG.Value, { TextColor3 = dH }, 0.2)
					end
				elseif dG then
					dG.Frame.Visible = false
				end
			end
			if c2 == "Expanded" and (c6 or self.IslandStyle == "Always Show") then
				task.defer(function()
					if c2 == "Expanded" and (c6 or self.IslandStyle == "Always Show") and self.Minimized then
						local dE = df("Expanded")
						if math.abs(dE.Y - cd.Size.Y.Offset) > 1 then
							dl("Expanded")
						end
					end
				end)
			end
		end
		self.MiniBar = cd
		self.Island = cd
		return cd
	end
	function __Ixa_guiWindow:Minimize()
		if self.Minimized or not self._introDone or not self.Open or self._destroyed then
			return
		end
		self.Minimized = true
		self._minimizeGeneration = (self._minimizeGeneration or 0) + 1
		local cc = self._minimizeGeneration
		self:_closePopups()
		self:_refreshToggleButton()
		self:_refreshBackdrop()
		local cd = self:_buildMiniBar()
		self:_refreshMini()
		local ce = self.Gui
		local cf = self.Root.AbsolutePosition - ce.AbsolutePosition
		local cg = self.Root.AbsoluteSize
		local ch = 1
		if self._ghost then
			cf = self._ghost.AbsolutePosition - ce.AbsolutePosition
			cg = self._ghost.AbsoluteSize
			ch = self._ghost.BackgroundTransparency
		end
		local ci, cj, ck = b9(self, cf, cg, __Ixa_guiLibrary._radius(10))
		ci.BackgroundTransparency = ch
		cj.Transparency = ch
		__Ixa_guiTween(ci, { BackgroundTransparency = 0 }, 0.11, Enum.EasingStyle.Quad)
		__Ixa_guiTween(cj, { Transparency = 0 }, 0.11, Enum.EasingStyle.Quad)
		__Ixa_guiTween(self.Scale, { Scale = (self._fitScale or 1) * 0.985 }, 0.11, Enum.EasingStyle.Quad)
		__Ixa_guiTween(self.Shadow, { ImageTransparency = 1 }, 0.2)
		cd.Visible = true
		cd.GroupTransparency = 1
		task.delay(0.11, function()
			if self._minimizeGeneration ~= cc or self._destroyed then
				return
			end
			self.Root.Visible = false
			self.Scale.Scale = self._fitScale or 1
			local cl, cm = self:_miniLand(cf + cg / 2)
			ca(ci, ck, cl, cm, math.floor(cm.Y / 2), 0.36)
			task.delay(0.3, function()
				if self._minimizeGeneration ~= cc or self._destroyed then
					return
				end
				self._miniScale.Scale = 0.9
				__Ixa_guiTween(self._miniScale, { Scale = 1 }, 0.3, Enum.EasingStyle.Quint)
				__Ixa_guiTween(cd, { GroupTransparency = 0 }, 0.18, Enum.EasingStyle.Quad)
				cb(self, ci, cj, 0.2)
				if self.IslandStyle == "Always Show" then
					task.delay(0.22, function()
						if self._minimizeGeneration == cc and self._islandSettle then
							self._islandSettle()
						end
					end)
				end
			end)
		end)
		task.spawn(function()
			while self.Minimized and self._minimizeGeneration == cc and not self._destroyed do
				self:_refreshMini()
				task.wait(0.5)
			end
		end)
	end
	function __Ixa_guiWindow:Restore()
		if not self.Minimized or self._destroyed then
			return
		end
		self.Minimized = false
		self._minimizeGeneration = (self._minimizeGeneration or 0) + 1
		local cc = self._minimizeGeneration
		self:_refreshToggleButton()
		self:_refreshBackdrop(true)
		local cd = self.Gui
		local ce = self.MiniBar
		local cf = self._fitScale or 1
		local cg = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset) * cf
		local ch = self.Root.AbsolutePosition + self.Root.AbsoluteSize / 2 - cd.AbsolutePosition
		local ci = ch - cg / 2
		local cj, ck = ci, cg
		local cl = 1
		if self._ghost then
			cj = self._ghost.AbsolutePosition - cd.AbsolutePosition
			ck = self._ghost.AbsoluteSize
			cl = self._ghost.BackgroundTransparency
		elseif ce and ce.Visible then
			cj = self._miniOrb.AbsolutePosition - cd.AbsolutePosition
			ck = self._miniOrb.AbsoluteSize
		end
		if ce and ce.Visible then
			if self._miniUnhover then
				self._miniUnhover()
			end
			__Ixa_guiTween(ce, { GroupTransparency = 1 }, 0.12, Enum.EasingStyle.Quad)
			task.delay(0.12, function()
				if self._minimizeGeneration == cc then
					ce.Visible = false
				end
			end)
		end
		local cm, cn, co = b9(self, cj, ck, math.floor(math.min(ck.X, ck.Y) / 2))
		cm.BackgroundTransparency = cl
		cn.Transparency = cl
		__Ixa_guiTween(cm, { BackgroundTransparency = 0 }, 0.1, Enum.EasingStyle.Quad)
		__Ixa_guiTween(cn, { Transparency = 0 }, 0.1, Enum.EasingStyle.Quad)
		ca(cm, co, ci, cg, __Ixa_guiLibrary._radius(10), 0.4)
		__Ixa_guiTween(self.Shadow, { ImageTransparency = self._shadowRest }, 0.45)
		task.delay(0.3, function()
			if self._minimizeGeneration ~= cc or self._destroyed then
				return
			end
			self.Scale.Scale = cf
			self.BodyStroke.Transparency = 0
			self.Root.Visible = true
		end)
		task.delay(0.4, function()
			if self._ghost == cm and self._minimizeGeneration == cc then
				cb(self, cm, cn, 0.22)
			end
		end)
	end
	function __Ixa_guiWindow:SetIslandDraggable(cc)
		self._islandLocked = cc == false
	end
	function __Ixa_guiWindow:ResetIslandPosition()
		self._islandAnchor = nil
		if self._islandReset then
			self._islandReset()
		end
		self:_writeConfigSettings({ IslandPosition = false })
	end
	function __Ixa_guiWindow:SetMinimized(cc)
		if cc then
			self:Minimize()
		else
			self:Restore()
		end
	end
	function __Ixa_guiWindow:Toggle(cc)
		if not self._introDone then
			return
		end
		if self.Minimized then
			if cc ~= false then
				self:Restore()
			end
			return
		end
		if cc == nil then
			cc = not self.Open
		end
		if cc == self.Open then
			return
		end
		self.Open = cc
		self:_refreshToggleButton()
		self:_refreshBackdrop(cc)
		self._minimizeGeneration = (self._minimizeGeneration or 0) + 1
		local cd = self._minimizeGeneration
		local ce = self.Gui
		local cf = self._fitScale or 1
		local cg = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset) * cf
		local ch = self.Root.AbsolutePosition + self.Root.AbsoluteSize / 2 - ce.AbsolutePosition
		local ci = cg * 0.94
		local cj, ck, cl
		if self._ghost then
			cj = self._ghost.AbsolutePosition - ce.AbsolutePosition
			ck = self._ghost.AbsoluteSize
			cl = self._ghost.BackgroundTransparency
		end
		if cc then
			local cm, cn, co = b9(self, cj or ch - ci / 2, ck or ci, __Ixa_guiLibrary._radius(10))
			cm.BackgroundTransparency = cl or 1
			cn.Transparency = cl or 1
			__Ixa_guiTween(cm, { BackgroundTransparency = 0 }, 0.12, Enum.EasingStyle.Quad)
			__Ixa_guiTween(cn, { Transparency = 0 }, 0.12, Enum.EasingStyle.Quad)
			ca(cm, co, ch - cg / 2, cg, __Ixa_guiLibrary._radius(10), 0.3)
			__Ixa_guiTween(self.Shadow, { ImageTransparency = self._shadowRest }, 0.3)
			task.delay(0.2, function()
				if self._minimizeGeneration ~= cd or self._destroyed then
					return
				end
				self.Scale.Scale = cf
				self.BodyStroke.Transparency = 0
				self.Root.Visible = true
			end)
			task.delay(0.3, function()
				if self._ghost == cm and self._minimizeGeneration == cd then
					cb(self, cm, cn, 0.18)
				end
			end)
		else
			self:_closePopups()
			local cm = cj or self.Root.AbsolutePosition - ce.AbsolutePosition
			local cn = ck or self.Root.AbsoluteSize
			local co, cp, cq = b9(self, cm, cn, __Ixa_guiLibrary._radius(10))
			co.BackgroundTransparency = cl or 1
			cp.Transparency = cl or 1
			__Ixa_guiTween(co, { BackgroundTransparency = 0 }, 0.08, Enum.EasingStyle.Quad)
			__Ixa_guiTween(cp, { Transparency = 0 }, 0.08, Enum.EasingStyle.Quad)
			__Ixa_guiTween(self.Shadow, { ImageTransparency = 1 }, 0.16)
			task.delay(0.08, function()
				if self._minimizeGeneration ~= cd or self._destroyed then
					return
				end
				self.Root.Visible = false
				ca(co, cq, ch - ci / 2, ci, __Ixa_guiLibrary._radius(10), 0.2)
				cb(self, co, cp, 0.16)
			end)
		end
	end
	function __Ixa_guiWindow:SetKeepOnScreen(cc)
		self.KeepOnScreen = cc ~= false
		if self.KeepOnScreen then
			self:_clampToScreen()
		end
	end
	function __Ixa_guiWindow:SetKeybind(cc)
		self.Keybind = cc
		if self._keyChipLabel then
			self._keyChipLabel.Text = __Ixa_guiKeyName(cc)
		end
	end
	function __Ixa_guiWindow:Notify(cc)
		cc = __Ixa_guiOptions(cc, { Text = "Content", Message = "Content", Image = "Icon" })
		if self.Minimized and self._islandActivity then
			self._islandActivity(cc)
		end
		local cd = cc.Duration or 4
		local ce = __Ixa_guiNoticeColors[cc.Type] or __Ixa_guiTheme.Text
		self._notifyOrder = self._notifyOrder + 1
		local cf = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, LayoutOrder = self._notifyOrder, Parent = self.NotifyHolder }
		)
		local cg = __Ixa_guiNew(
			"Frame",
			{
				Position = UDim2.fromOffset(320, 0),
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Parent = cf,
			}
		)
		local ch = __Ixa_guiNew(
			"ImageLabel",
			{
				Position = UDim2.fromOffset(-20, -20),
				Size = UDim2.new(1, 40, 1, 40),
				BackgroundTransparency = 1,
				Image = __Ixa_guiAssets.Shadow,
				ImageColor3 = Color3.new(0, 0, 0),
				ImageTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(49, 49, 450, 450),
				ZIndex = 0,
				Parent = cg,
			}
		)
		local ci = __Ixa_guiNew(
			"CanvasGroup",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = __Ixa_guiTheme.Background,
				BorderSizePixel = 0,
				GroupTransparency = 1,
				Parent = cg,
			}
		)
		__Ixa_guiCorner(ci, UDim.new(0, 10))
		local cj = __Ixa_guiStroke(ci, __Ixa_guiTheme.Stroke)
		ao(ci)
		an(ci, UDim2.fromOffset(260, 120), UDim2.new(1, -10, 0, -10), 0.86, 90)
		local ck = __Ixa_guiNew(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = ci }
		)
		__Ixa_guiPadding(ck, 16, 16, 14, 24)
		local cl = 0
		if cc.Icon then
			__Ixa_guiIcon(ck, cc.Icon, ce == __Ixa_guiTheme.Text and __Ixa_guiTheme.Accent or ce, UDim2.new(0, 0, 0, 8))
			cl = 24
		end
		__Ixa_guiLabel({
			Position = UDim2.fromOffset(cl, 0),
			Size = UDim2.new(1, -28 - cl, 0, 16),
			Text = cc.Title or "Notification",
			TextSize = 14,
			TextColor3 = ce,
			Parent = ck,
		})
		local cm = __Ixa_guiNew(
			"TextButton",
			{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 6, 0, -5),
				Size = UDim2.fromOffset(24, 24),
				BackgroundTransparency = 1,
				Text = "\u{d7}",
				TextColor3 = __Ixa_guiTheme.Muted,
				TextSize = 22,
				FontFace = __Ixa_guiFonts.Bold,
				AutoButtonColor = false,
				Parent = ck,
			}
		)
		cm.MouseEnter:Connect(function()
			__Ixa_guiTween(cm, { TextColor3 = __Ixa_guiTheme.Text }, 0.15)
		end)
		cm.MouseLeave:Connect(function()
			__Ixa_guiTween(cm, { TextColor3 = __Ixa_guiTheme.Muted }, 0.2)
		end)
		if cc.Content then
			__Ixa_guiLabel({
				Position = UDim2.fromOffset(cl, 21),
				Size = UDim2.new(1, -cl, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = cc.Content,
				TextSize = 13,
				FontFace = __Ixa_guiFonts.Regular,
				TextColor3 = __Ixa_guiTheme.Muted,
				TextWrapped = true,
				TextTruncate = Enum.TextTruncate.None,
				TextYAlignment = Enum.TextYAlignment.Top,
				Parent = ck,
			})
		end
		local cn = __Ixa_guiNew(
			"Frame",
			{
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 16, 1, -8),
				Size = UDim2.new(1, -32, 0, 3),
				BackgroundColor3 = __Ixa_guiTheme.Surface3,
				BorderSizePixel = 0,
				Parent = ci,
			}
		)
		__Ixa_guiCorner(cn, UDim.new(1, 0))
		local co =
			__Ixa_guiNew("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = __Ixa_guiTheme.Accent, BorderSizePixel = 0, Parent = cn })
		__Ixa_guiCorner(co, UDim.new(1, 0))
		task.defer(function()
			if cf.Parent then
				__Ixa_guiTween(cf, { Size = UDim2.new(1, 0, 0, ci.AbsoluteSize.Y) }, 0.3, Enum.EasingStyle.Quint)
			end
		end)
		__Ixa_guiTween(cg, { Position = UDim2.fromOffset(0, 0) }, 0.5, Enum.EasingStyle.Back)
		__Ixa_guiTween(ci, { GroupTransparency = 0 }, 0.3)
		__Ixa_guiTween(ch, { ImageTransparency = 0.6 }, 0.4)
		__Ixa_guiTween(co, { Size = UDim2.fromScale(0, 1) }, cd, Enum.EasingStyle.Linear)
		local cp = false
		local function cq()
			if cp then
				return
			end
			cp = true
			for cr, cs in ipairs(self._toasts) do
				if cs == cq then
					table.remove(self._toasts, cr)
					break
				end
			end
			__Ixa_guiTween(cg, { Position = UDim2.fromOffset(320, 0) }, 0.3, Enum.EasingStyle.Quint)
			__Ixa_guiTween(ci, { GroupTransparency = 1 }, 0.2)
			__Ixa_guiTween(cj, { Transparency = 1 }, 0.15)
			__Ixa_guiTween(ch, { ImageTransparency = 1 }, 0.2)
			task.delay(0.22, function()
				cf.ClipsDescendants = true
				__Ixa_guiTween(cf, { Size = UDim2.new(1, 0, 0, -4) }, 0.22, Enum.EasingStyle.Quint)
				task.delay(0.24, function()
					cf:Destroy()
				end)
			end)
		end
		task.delay(cd, cq)
		cm.MouseButton1Click:Connect(cq)
		table.insert(self._toasts, cq)
		while #self._toasts > self.MaxNotifications do
			local cr = table.remove(self._toasts, 1)
			cr()
		end
		return { Dismiss = cq }
	end
	function __Ixa_guiWindow:Destroy()
		if self._destroyed then
			return
		end
		self._destroyed = true
		for cc, cd in ipairs(__Ixa_guiLibrary.Windows) do
			if cd == self then
				table.remove(__Ixa_guiLibrary.Windows, cc)
				break
			end
		end
		for cc, cd in ipairs(self._connections) do
			pcall(function()
				cd:Disconnect()
			end)
		end
		self._connections = {}
		self._inputListeners = { Began = {}, Changed = {}, Ended = {}, Render = {} }
		self._frameSteps = {}
		if self._pendingFlags then
			self._pendingFlags = {}
		end
		local cc = __Ixa_guiLibrary._registry()
		if cc and cc[self._registryKey] == self then
			cc[self._registryKey] = nil
		end
		local cd = self.Gui
		if not cd then
			return
		end
		local ce = false
		local function cf()
			if ce then
				return
			end
			ce = true
			if not pcall(cd.Destroy, cd) then
				pcall(function()
					cd.Enabled = false
				end)
			end
		end
		local cg, ch = pcall(function()
			if self._dialog then
				self._dialog.Close()
			end
			self:_closePopups()
			local cg = self._fitScale or 1
			__Ixa_guiTween(self.Scale, { Scale = cg * 0.92 }, 0.22, Enum.EasingStyle.Quint)
			self:_fade(1, 0.2)
			__Ixa_guiTween(self.BodyStroke, { Transparency = 1 }, 0.12)
			__Ixa_guiTween(self.Shadow, { ImageTransparency = 1 }, 0.2)
			if self.MiniBar and self.MiniBar.Visible then
				__Ixa_guiTween(self.MiniBar, { GroupTransparency = 1 }, 0.18)
			end
			if self._backdrop then
				self._weatherField.Visible = false
				__Ixa_guiTween(self._backdropTintFrame, { BackgroundTransparency = 1 }, 0.2)
				__Ixa_guiTween(self._backdropHeat, { BackgroundTransparency = 1 }, 0.2)
			end
			for ch, ci in ipairs({ self.ToggleButton, self.OpenButton }) do
				if typeof(ci) == "Instance" and ci:IsA("GuiObject") then
					__Ixa_guiTween(ci, { Size = UDim2.fromOffset(0, 0) }, 0.2, Enum.EasingStyle.Quint)
				end
			end
		end)
		if not cg then
			warn([[[AirFlow] unload animation failed, removing the window directly: ]] .. tostring(ch))
			cf()
			return
		end
		task.delay(0.24, cf)
	end
	__Ixa_guiWindow.Unload = __Ixa_guiWindow.Destroy
	function __Ixa_guiLibrary:Destroy()
		if __Ixa_guiLibrary._disposed then
			return
		end
		__Ixa_guiLibrary._disposed = true
		for cc = #__Ixa_guiLibrary.Windows, 1, -1 do
			local cd = __Ixa_guiLibrary.Windows[cc]
			if cd then
				cd:Destroy()
			end
		end
		if __Ixa_guiThemeConnection then
			__Ixa_guiThemeConnection:Disconnect()
			__Ixa_guiThemeConnection = nil
		end
		table.clear(__Ixa_guiThemeBindings)
		table.clear(__Ixa_guiThemeCallbacks)
		table.clear(__Ixa_guiLibrary._themeListeners)
		table.clear(__Ixa_guiLibrary.Flags)
	end
	__Ixa_guiLibrary.Unload = __Ixa_guiLibrary.Destroy
	return __Ixa_guiLibrary
end)()
return a
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    return
end

local Shared = nil
if type(getgenv) == "function" then
    local ok, result = pcall(getgenv)
    if ok and type(result) == "table" then
        Shared = result
    end
end
if not Shared and type(shared) == "table" then
    Shared = shared
end

if Shared and type(Shared.HallowedReactorHub) == "table" and type(Shared.HallowedReactorHub.Unload) == "function" then
    pcall(Shared.HallowedReactorHub.Unload)
end

local App = {
    alive = true,
    connections = {},
    renderName = "HallowedReactorHub_" .. tostring(LocalPlayer.UserId) .. "_" .. tostring(math.floor(os.clock() * 1000)),
    savedPosition = nil,
}
local UI = {toggleViews = {}, numberViews = {}, choiceViews = {}, colorViews = {}, open = true}
local Promo = {invite = "https://discord.gg/BpfKcTbap2", generation = 0, token = 0, feedback = 0, failures = 0, started = false, timers = {}, connections = {}}
local Guard = {groups = {}}
local Save = {path = "HALLOWED_REACTOR_Hub.json", writable = false, status = "Settings: unavailable", revision = 0}
local Motion = {character = nil, humanoid = nil, root = nil, parts = {}, characterConnections = {}}
local Combat = {tool = nil, module = nil, settings = nil, pending = false, request = 0, patches = {}, state = "Weapon: waiting"}
local Silent = {hooks = {}, records = {}, generation = 0, scanCount = 0, nextAttempt = 0, nextTargetScan = 0}
local Auto = {held = false, focused = true, shots = 0, toolFailures = 0, mouseFailures = 0, nextPress = 0, nextCheck = 0, pending = setmetatable({}, {__mode = "k"}), autoShots = 0, dryCycles = 0}
local Input = {}
local Reload = {
    nextCheck = 0,
    nextAttempt = 0,
    pauseUntil = 0,
    guiScanAt = 0,
    dryAttempts = 0,
    currentNames = {"CurrentAmmo", "currentAmmo", "AmmoInMag", "AmmoInClip", "AmmoInMagazine", "ammoInMagazine", "MagazineAmmo", "ClipAmmo", "CurrentMagazine", "CurrentMag", "currentMag", "CurrentClip", "LoadedAmmo", "AmmoLoaded", "MagAmmo"},
    reserveNames = {"ReserveAmmo", "reserveAmmo", "AmmoReserve", "AmmoInReserve", "SpareAmmo", "RemainingAmmo", "AmmoLeft", "Reserve", "ReserveCount", "AmmoStock", "TotalAmmo"},
    stateNames = {"AmmoState", "WeaponState", "State", "Stats", "Ammunition"},
    ambiguousNames = {"Ammo", "ammo", "Clip", "Magazine"},
}
local Punch = {nextCheck = 0, nextAttempt = 0}
local Visual = {characters = {}, pickups = {}, objectives = {}, accumulator = 0}
local World = {shownPrompts = {}}

local Optimizer = {
    mode = 0,
    normal = setmetatable({}, {__mode = "k"}),
    super = setmetatable({}, {__mode = "k"}),
    queue = {},
    head = 1,
    tail = 0,
    seen = setmetatable({}, {__mode = "k"}),
    connections = {},
    restoreNormal = false,
    restoreSuper = false,
    normalWatch = {},
    normalIndex = {},
    normalCursor = 1,
    superWatch = {},
    superIndex = {},
    superCursor = 1
}

function Optimizer.write(group, object, property, desired)
    local ok, current = pcall(function() return object[property] end)
    if not ok or current == nil or current == desired then return end
    local record = group[object]
    if record then
        record.original = current
    else
        record = {property = property, original = current, desired = desired}
    end
    local changed = pcall(function() object[property] = desired end)
    if changed then group[object] = record end
end

function Optimizer.track(list, index, object)
    if index[object] then return end
    local position = #list + 1
    list[position] = object
    index[object] = position
end

function Optimizer.untrack(list, index, object)
    local position = index[object]
    if not position then return end
    local lastPosition = #list
    local last = list[lastPosition]
    list[position] = last
    list[lastPosition] = nil
    index[last] = position
    index[object] = nil
end

function Optimizer.clearWatch(superOnly)
    if not superOnly then
        table.clear(Optimizer.normalWatch)
        table.clear(Optimizer.normalIndex)
        Optimizer.normalCursor = 1
    end
    table.clear(Optimizer.superWatch)
    table.clear(Optimizer.superIndex)
    Optimizer.superCursor = 1
end

function Optimizer.restoreObject(group, object)
    local record = group[object]
    if not record then return end
    group[object] = nil
    pcall(function()
        if object[record.property] == record.desired then
            object[record.property] = record.original
        end
    end)
end

function Optimizer.enqueue(object)
    if not object or Optimizer.seen[object] then return end
    Optimizer.seen[object] = true
    Optimizer.tail += 1
    Optimizer.queue[Optimizer.tail] = object
end

function Optimizer.scan()
    table.clear(Optimizer.queue)
    Optimizer.head, Optimizer.tail = 1, 0
    Optimizer.seen = setmetatable({}, {__mode = "k"})
    Optimizer.enqueue(Workspace)
    Optimizer.enqueue(Lighting)
end

function Optimizer.connected()
    if #Optimizer.connections > 0 then return end
    for _, root in ipairs({Workspace, Lighting}) do
        table.insert(Optimizer.connections, root.DescendantAdded:Connect(function(object)
            if Optimizer.mode > 0 then Optimizer.enqueue(object) end
        end))
        table.insert(Optimizer.connections, root.DescendantRemoving:Connect(function(object)
            Optimizer.seen[object] = nil
            Optimizer.untrack(Optimizer.normalWatch, Optimizer.normalIndex, object)
            Optimizer.untrack(Optimizer.superWatch, Optimizer.superIndex, object)
            Optimizer.restoreObject(Optimizer.normal, object)
            Optimizer.restoreObject(Optimizer.super, object)
        end))
    end
end

function Optimizer.disconnect()
    for _, connection in ipairs(Optimizer.connections) do
        connection:Disconnect()
    end
    table.clear(Optimizer.connections)
end

function Optimizer.setMode(mode)
    if mode == Optimizer.mode then return end
    local old = Optimizer.mode
    Optimizer.mode = mode
    if mode == 0 then
        table.clear(Optimizer.queue)
        Optimizer.head, Optimizer.tail = 1, 0
        Optimizer.seen = setmetatable({}, {__mode = "k"})
        Optimizer.restoreNormal, Optimizer.restoreSuper = true, true
        Optimizer.clearWatch(false)
        Guard.clear("fpsOptimization")
        return
    end
    Optimizer.restoreNormal = false
    Optimizer.restoreSuper = mode < 2
    if mode < 2 then Optimizer.clearWatch(true) end
    Optimizer.connected()
    Guard.set("fpsOptimization", Lighting, "GlobalShadows", false, false)
    if mode > old then
        Optimizer.scan()
    end
end

function Optimizer.apply(object)
    if Optimizer.mode <= 0 then return end
    if object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam") or object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles") or object:IsA("PostEffect") then
        Optimizer.track(Optimizer.normalWatch, Optimizer.normalIndex, object)
        Optimizer.write(Optimizer.normal, object, "Enabled", false)
    end
    if Optimizer.mode >= 2 then
        if object:IsA("Decal") or object:IsA("Texture") then
            Optimizer.track(Optimizer.superWatch, Optimizer.superIndex, object)
            Optimizer.write(Optimizer.super, object, "Transparency", 1)
        elseif object:IsA("Light") or object:IsA("Clouds") then
            Optimizer.track(Optimizer.superWatch, Optimizer.superIndex, object)
            Optimizer.write(Optimizer.super, object, "Enabled", false)
        end
    end
end

function Optimizer.maintain()
    local function refresh(list, cursorName, group, superMode)
        local count = math.min(80, #list)
        local cursor = Optimizer[cursorName]
        for _ = 1, count do
            if cursor > #list then cursor = 1 end
            local object = list[cursor]
            if not object then break end
            if superMode and (object:IsA("Decal") or object:IsA("Texture")) then
                Optimizer.write(group, object, "Transparency", 1)
            else
                Optimizer.write(group, object, "Enabled", false)
            end
            cursor += 1
        end
        Optimizer[cursorName] = cursor
    end
    if Optimizer.mode > 0 then
        refresh(Optimizer.normalWatch, "normalCursor", Optimizer.normal, false)
    end
    if Optimizer.mode >= 2 then
        refresh(Optimizer.superWatch, "superCursor", Optimizer.super, true)
    end
end

function Optimizer.restoreBatch(group, limit)
    local count = 0
    while count < limit do
        local object = next(group)
        if not object then return true end
        Optimizer.restoreObject(group, object)
        count += 1
    end
    return next(group) == nil
end

function Optimizer.step()
    if Optimizer.restoreSuper and Optimizer.restoreBatch(Optimizer.super, 160) then
        Optimizer.restoreSuper = false
    end
    if Optimizer.restoreNormal and Optimizer.restoreBatch(Optimizer.normal, 160) then
        Optimizer.restoreNormal = false
    end
    if Optimizer.mode <= 0 then
        if not Optimizer.restoreNormal and not Optimizer.restoreSuper then
            Optimizer.disconnect()
        end
        return
    end
    local processed = 0
    while processed < 200 and Optimizer.head <= Optimizer.tail do
        local object = Optimizer.queue[Optimizer.head]
        Optimizer.queue[Optimizer.head] = nil
        Optimizer.head += 1
        processed += 1
        if object and (object == Workspace or object == Lighting or object:IsDescendantOf(Workspace) or object:IsDescendantOf(Lighting)) then
            Optimizer.apply(object)
            local ok, children = pcall(function() return object:GetChildren() end)
            if ok then
                for _, child in ipairs(children) do
                    Optimizer.enqueue(child)
                end
            end
        end
    end
    if Optimizer.head > Optimizer.tail then
        table.clear(Optimizer.queue)
        Optimizer.head, Optimizer.tail = 1, 0
    end
end

function Optimizer.stop()
    Optimizer.mode = 0
    Optimizer.disconnect()
    table.clear(Optimizer.queue)
    Optimizer.head, Optimizer.tail = 1, 0
    Optimizer.restoreNormal, Optimizer.restoreSuper = false, false
    Optimizer.clearWatch(false)
    Optimizer.restoreBatch(Optimizer.super, math.huge)
    Optimizer.restoreBatch(Optimizer.normal, math.huge)
    Guard.clear("fpsOptimization")
end

function Optimizer.status()
    if Optimizer.restoreNormal or Optimizer.restoreSuper then return "FPS optimization: restoring visuals" end
    if Optimizer.mode == 0 then return "FPS optimization: off" end
    if Optimizer.head <= Optimizer.tail then return "FPS optimization: applying in batches" end
    return Optimizer.mode == 2 and "FPS optimization: super" or "FPS optimization: normal"
end

local defaults = {
    speedEnabled = false,
    speed = 28,
    stamina = false,
    antiStagger = false,
    noSlow = false,
    noclip = false,
    fpsBoost = false,
    superFpsBoost = false,
    fastReload = false,
    felsiReload = 100,
    squadReload = 200,
    noRecoil = false,
    silentAim = false,
    autoFire = false,
    autoReload = false,
    reloadKey = "R",
    autoPunch = false,
    punchRange = 8,
    punchKey = "G",
    targetPart = "Body",
    wallCheck = true,
    aimMode = "360",
    aimRadius = 200,
    showAimFov = false,
    aimColor = 0xFF9EC8,
    espPlayers = false,
    espAllies = false,
    espNPC = false,
    mobBoxes = false,
    mobSkeletons = false,
    mobColor = 0xFFAF58,
    espBoss = false,
    bossBoxes = false,
    bossSkeletons = false,
    bossColor = 0xFF6464,
    espObjectives = false,
    espPickups = false,
    eventTracker = false,
    threatTracker = false,
    threatRange = 200,
    espDistance = 800,
    fullbright = false,
    noFog = false,
    fovEnabled = false,
    fov = 80,
    crosshair = false,
    fps = false,
    instantPrompt = false,
}
local numeric = {
    speed = {12, 100},
    felsiReload = {60, 100},
    squadReload = {100, 200},
    punchRange = {2, 20},
    aimRadius = {20, 1000},
    aimColor = {0, 16777215},
    mobColor = {0, 16777215},
    bossColor = {0, 16777215},
    threatRange = {25, 1000},
    espDistance = {100, 3000},
    fov = {40, 120},
}
local choices = {
    aimMode = {"360", "Screen"},
    targetPart = {"Body", "Head", "Torso", "Root"},
    reloadKey = {"R", "F", "T", "Y", "U", "X", "Z", "C", "V"},
    punchKey = {"G", "F", "T", "Y", "U", "X", "Z", "C", "V"},
}

local settings = table.clone(defaults)
local startupManual = {}
for key, value in pairs(defaults) do
    if type(value) == "boolean" and value == false then startupManual[key] = true end
end

function App.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(App.connections, connection)
    return connection
end

function App.validValue(key, value)
    local default = defaults[key]
    if default == nil or type(value) ~= type(default) then
        return nil
    end
    if type(default) == "number" then
        if value ~= value or value == math.huge or value == -math.huge then
            return nil
        end
        local range = numeric[key]
        return math.clamp(math.floor(value + 0.5), range[1], range[2])
    elseif type(default) == "string" then
        for _, allowed in ipairs(choices[key] or {}) do
            if value == allowed then return value end
        end
        return nil
    end
    return value
end

function Save.load()
    if type(readfile) ~= "function" or type(writefile) ~= "function" then
        Save.status = "Settings: file functions unavailable"
        return
    end
    if type(isfile) ~= "function" then
        local ok, raw = pcall(readfile, Save.path)
        if ok and type(raw) == "string" then
            local parsed, data = pcall(function()
                return HttpService:JSONDecode(raw)
            end)
            if parsed and type(data) == "table" and data.version == 1 and type(data.values) == "table" then
                local valid = true
                local loaded = table.clone(defaults)
                for key, default in pairs(defaults) do
                    local value = data.values[key]
                    if key == "targetPart" and value == nil then
                        local old = data.values.silentHead
                        if type(old) ~= "boolean" then old = data.values.aimHead end
                        if type(old) == "boolean" then value = old and "Head" or "Body" end
                    end
                    if value ~= nil then
                        local clean = App.validValue(key, value)
                        if clean == nil then
                            valid = false
                            break
                        end
                        loaded[key] = clean
                    end
                end
                if valid then
                    settings = loaded
                    Save.status = "Settings loaded; saving requires isfile"
                    return
                end
            end
        end
        Save.status = "Settings not saved: isfile is unavailable"
        return
    end
    local checked, exists = pcall(isfile, Save.path)
    if not checked or type(exists) ~= "boolean" then
        Save.status = "Settings: file check failed"
        return
    end
    if not exists then
        Save.writable = true
        Save.status = "Autosave enabled"
        return
    end
    local readOk, raw = pcall(readfile, Save.path)
    if not readOk or type(raw) ~= "string" then
        Save.status = "Settings: read failed; saving disabled"
        return
    end
    local parsed, data = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not parsed or type(data) ~= "table" or data.version ~= 1 or type(data.values) ~= "table" then
        Save.status = "Settings are corrupted; saving disabled"
        return
    end
    local loaded = table.clone(defaults)
    for key, default in pairs(defaults) do
        local value = data.values[key]
        if key == "targetPart" and value == nil then
            local old = data.values.silentHead
            if type(old) ~= "boolean" then old = data.values.aimHead end
            if type(old) == "boolean" then value = old and "Head" or "Body" end
        end
        if value ~= nil then
            local clean = App.validValue(key, value)
            if clean == nil then
                Save.status = "Settings are invalid; saving disabled"
                return
            end
            loaded[key] = clean
        end
    end
    settings = loaded
    Save.writable = true
    Save.status = "Settings loaded and autosave enabled"
end

function Save.flush()
    if not Save.writable then
        return false
    end
    local encodedOk, encoded = pcall(function()
        return HttpService:JSONEncode({version = 1, values = settings})
    end)
    if not encodedOk then
        Save.writable = false
        Save.status = "Settings: encoding failed"
        return false
    end
    local written = pcall(writefile, Save.path, encoded)
    if not written then
        Save.writable = false
        Save.status = "Settings: write failed"
        return false
    end
    Save.status = "Settings saved automatically"
    return true
end

function Save.schedule()
    if not Save.writable then
        return
    end
    Save.revision += 1
    local revision = Save.revision
    task.delay(0.8, function()
        if App.alive and revision == Save.revision then
            Save.flush()
        end
    end)
end

Save.load()
for key in pairs(startupManual) do settings[key] = false end

function Guard.read(record)
    if record.attribute then
        return record.object:GetAttribute(record.key)
    end
    return record.object[record.key]
end

function Guard.write(record, value)
    if record.attribute then
        record.object:SetAttribute(record.key, value)
    else
        record.object[record.key] = value
    end
end

function Guard.set(group, object, key, desired, attribute)
    if not object then
        return false
    end
    local groupEntries = Guard.groups[group]
    if not groupEntries then
        groupEntries = {}
        Guard.groups[group] = groupEntries
    end
    local objectEntries = groupEntries[object]
    if not objectEntries then
        objectEntries = {}
        groupEntries[object] = objectEntries
    end
    local id = (attribute and "@" or ".") .. key
    local record = objectEntries[id]
    if not record then
        local enforce = group == "stamina" or group == "stagger" or group == "slow" or group == "reload"
        record = {object = object, key = key, attribute = attribute == true, desired = desired, wrote = false, enforce = enforce, group = group}
        local ok, value = pcall(Guard.read, record)
        if not ok then
            return false
        end
        record.latest = value
        objectEntries[id] = record
        local signalOk, signal = pcall(function()
            if record.attribute then
                return object:GetAttributeChangedSignal(key)
            end
            return object:GetPropertyChangedSignal(key)
        end)
        if signalOk and signal then
            record.connection = signal:Connect(function()
                local readOk, current = pcall(Guard.read, record)
                if readOk and current ~= record.desired then
                    record.latest = current
                    local humanoid = Motion.humanoid
                    if record.enforce and not record.enforcing and App.alive and record.object == LocalPlayer.Character and humanoid and humanoid.Health > 0 and (record.group ~= "stamina" or Motion.staminaAvailable()) then
                        local now = os.clock()
                        if now >= (record.nextEnforceAt or 0) then
                            record.enforcing = true
                            record.nextEnforceAt = now + 0.05
                            local wrote = pcall(Guard.write, record, record.desired)
                            record.enforcing = false
                            if wrote then
                                record.wrote = true
                            end
                        end
                    end
                end
            end)
        end
    end
    local readOk, current = pcall(Guard.read, record)
    if not readOk then
        return false
    end
    local previousDesired = record.desired
    if current ~= previousDesired then
        record.latest = current
    end
    record.desired = desired
    if current ~= desired then
        local wrote = pcall(Guard.write, record, desired)
        if wrote then
            record.wrote = true
            return true
        end
        return false
    end
    return true
end

function Guard.releaseRecord(record)
    if record.connection then
        record.connection:Disconnect()
        record.connection = nil
    end
    local ok, current = pcall(Guard.read, record)
    if ok and record.wrote and current == record.desired then
        pcall(Guard.write, record, record.latest)
    end
end

function Guard.clearObject(group, object)
    local groupEntries = Guard.groups[group]
    local objectEntries = groupEntries and groupEntries[object]
    if not objectEntries then
        return
    end
    groupEntries[object] = nil
    for _, record in pairs(objectEntries) do
        Guard.releaseRecord(record)
    end
end

function Guard.clear(group)
    local groupEntries = Guard.groups[group]
    if not groupEntries then
        return
    end
    Guard.groups[group] = nil
    for _, objectEntries in pairs(groupEntries) do
        for _, record in pairs(objectEntries) do
            Guard.releaseRecord(record)
        end
    end
end

function Guard.clearAll()
    local names = {}
    for name in pairs(Guard.groups) do
        table.insert(names, name)
    end
    for _, name in ipairs(names) do
        Guard.clear(name)
    end
end

local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 15)
if not playerGui then
    return
end

function UI.guiParents(preferred)
    local parents, seen = {}, {}
    local function add(parent)
        if typeof(parent) ~= "Instance" or seen[parent] then return end
        local ok, suitable = pcall(function()
            return (parent:IsA("BasePlayerGui") or parent:IsA("Folder"))
                and (not parent:IsA("PlayerGui") or parent.Parent == LocalPlayer)
        end)
        if ok and suitable then
            seen[parent] = true
            table.insert(parents, parent)
        end
    end
    add(preferred)
    local current = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    add(current)
    if playerGui.Parent == LocalPlayer then add(playerGui) end
    return parents
end

function UI.attach(object, preferred, protected)
    if typeof(object) ~= "Instance" then return nil end
    if not protected then
        pcall(function()
            if object:IsA("ScreenGui") and type(syn) == "table" and type(syn.protect_gui) == "function" then
                syn.protect_gui(object)
            end
        end)
    end
    local function try(parent)
        if typeof(parent) ~= "Instance" then return nil end
        local valid, suitable = pcall(function()
            return (parent:IsA("BasePlayerGui") or parent:IsA("Folder"))
                and (not parent:IsA("PlayerGui") or parent.Parent == LocalPlayer)
        end)
        if not valid or not suitable then return nil end
        local ok = pcall(function() object.Parent = parent end)
        if ok then
            local readOk, current = pcall(function() return object.Parent end)
            if readOk and current == parent then return parent end
        end
        return nil
    end
    local mounted = try(preferred)
    if mounted then return mounted end
    if type(gethui) == "function" then
        local ok, hidden = pcall(gethui)
        if ok and hidden ~= preferred then
            mounted = try(hidden)
            if mounted then return mounted end
        end
    end
    local ok, core = pcall(game.GetService, game, "CoreGui")
    if ok and core ~= preferred then
        mounted = try(core)
        if mounted then return mounted end
    end
    for _, parent in ipairs(UI.guiParents()) do
        if parent ~= preferred then
            mounted = try(parent)
            if mounted then return mounted end
        end
    end
    return nil
end

local screen = Instance.new("ScreenGui")
screen.Name = "HallowedReactorHub"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.DisplayOrder = 10000
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local guiHost = UI.attach(screen)
if not guiHost then
    pcall(function() screen:Destroy() end)
    return
end
UI.screen = screen

local visualFolder = nil
Visual.folder = nil

local palette = {
    accent = Color3.fromRGB(255, 158, 200),
    text = Color3.fromRGB(248, 232, 240),
}

function UI.label(parent, text, size, color)
    local item = Instance.new("TextLabel")
    item.BackgroundTransparency = 1
    item.Text = text
    item.TextColor3 = color or palette.text
    item.Font = Enum.Font.Gotham
    item.TextSize = size or 13
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextYAlignment = Enum.TextYAlignment.Center
    item.Parent = parent
    return item
end

local center = Instance.new("Frame")
center.Name = "Crosshair"
center.BackgroundTransparency = 1
center.AnchorPoint = Vector2.new(0.5, 0.5)
center.Position = UDim2.fromScale(0.5, 0.5)
center.Size = UDim2.fromOffset(20, 20)
center.Visible = false
center.Parent = screen
for _, geometry in ipairs({{9, 0, 2, 6}, {9, 14, 2, 6}, {0, 9, 6, 2}, {14, 9, 6, 2}}) do
    local line = Instance.new("Frame")
    line.BorderSizePixel = 0
    line.BackgroundColor3 = palette.accent
    line.Position = UDim2.fromOffset(geometry[1], geometry[2])
    line.Size = UDim2.fromOffset(geometry[3], geometry[4])
    line.Parent = center
end
UI.crosshair = center

local aimCircle = Instance.new("Frame")
aimCircle.Name = "AimFOV"
aimCircle.BackgroundTransparency = 1
aimCircle.AnchorPoint = Vector2.new(0.5, 0.5)
aimCircle.Position = UDim2.fromScale(0.5, 0.5)
aimCircle.Size = UDim2.fromOffset(settings.aimRadius * 2, settings.aimRadius * 2)
aimCircle.Visible = false
aimCircle.Parent = screen
local aimRound = Instance.new("UICorner")
aimRound.CornerRadius = UDim.new(1, 0)
aimRound.Parent = aimCircle
local aimStroke = Instance.new("UIStroke")
aimStroke.Thickness = 1.5
aimStroke.Color = UI.color and UI.color(settings.aimColor) or palette.accent
aimStroke.Parent = aimCircle
UI.aimCircle = aimCircle
UI.aimStroke = aimStroke

local fpsLabel = UI.label(screen, "FPS: --", 12, palette.accent)
fpsLabel.Name = "FPS"
fpsLabel.Position = UDim2.new(1, -90, 0, 8)
fpsLabel.Size = UDim2.fromOffset(80, 22)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
fpsLabel.Visible = false
UI.fpsLabel = fpsLabel

local trackerPanel = Instance.new("Frame")
trackerPanel.Name = "Trackers"
trackerPanel.Position = UDim2.new(0, 12, 0.66, 0)
trackerPanel.Size = UDim2.new(1, -24, 0, 50)
trackerPanel.BackgroundTransparency = 1
trackerPanel.Visible = false
trackerPanel.Parent = screen
local trackerSize = Instance.new("UISizeConstraint")
trackerSize.MaxSize = Vector2.new(320, 50)
trackerSize.Parent = trackerPanel

local function trackerLabel(name, color)
    local label = UI.label(trackerPanel, name .. ": --", 13, color)
    label.Name = name
    label.Size = UDim2.new(1, 0, 0, 22)
    label.BackgroundColor3 = Color3.fromRGB(28, 23, 32)
    label.BackgroundTransparency = 0.22
    label.BorderSizePixel = 0
    label.Font = Enum.Font.GothamMedium
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.TextStrokeTransparency = 0.5
    label.Visible = false
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = label
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 6)
    padding.Parent = label
    return label
end

UI.trackerPanel = trackerPanel
UI.eventLabel = trackerLabel("EVENT", Color3.fromRGB(255, 222, 154))
UI.threatLabel = trackerLabel("THREATS", Color3.fromRGB(255, 179, 193))

function App.notice(text)
    if UI.window and not UI.window._destroyed and type(UI.window.Notify) == "function" then
        pcall(UI.window.Notify, UI.window, {Title = "HALLOWED REACTOR", Content = tostring(text), Duration = 4})
    end
end

function UI.refreshOverlays()
    UI.crosshair.Visible = settings.crosshair and not UI.open
    UI.fpsLabel.Visible = settings.fps
    UI.trackerPanel.Visible = (settings.eventTracker or settings.threatTracker) and not UI.open
    UI.eventLabel.Visible = settings.eventTracker
    UI.threatLabel.Visible = settings.threatTracker
    UI.threatLabel.Position = UDim2.fromOffset(0, settings.eventTracker and 26 or 0)
    UI.aimCircle.Visible = settings.showAimFov and settings.aimMode == "Screen" and not UI.open
    UI.aimCircle.Size = UDim2.fromOffset(settings.aimRadius * 2, settings.aimRadius * 2)
    UI.aimStroke.Color = UI.color(settings.aimColor)
end

function UI.syncVisibility()
    local window = UI.window
    local open = window ~= nil and not window._destroyed and window.Open == true and window.Minimized ~= true
    UI.open = open
    if UI.modal then
        UI.modal.Visible = open
    end
    if not open then
        Guard.clear("cursor")
    elseif Auto.release then
        Auto.release(false)
    end
    UI.refreshOverlays()
end

function UI.setOpen(open)
    if not App.alive or not UI.window or UI.window._destroyed then
        return false
    end
    open = open == true
    local window = UI.window
    if not window._introDone then
        UI.pendingOpen = open
        return true
    end
    if open then
        if window.Minimized then
            window:Restore()
        end
        if not window.Open then
            window:Toggle(true)
        end
    elseif window.Open and not window.Minimized then
        window:Toggle(false)
    end
    UI.syncVisibility()
    return true
end

function UI.syncControl(view, value)
    if not view or type(view.Set) ~= "function" then
        return
    end
    local ok, current = false, nil
    if type(view.Get) == "function" then
        ok, current = pcall(view.Get, view)
    end
    if not ok or current ~= value then
        pcall(view.Set, view, value, true)
    end
end

function UI.refreshToggle(key)
    UI.syncControl(UI.toggleViews[key], settings[key])
end

function UI.color(value)
    return Color3.fromRGB(math.floor(value / 65536) % 256, math.floor(value / 256) % 256, value % 256)
end

function UI.packColor(color)
    if typeof(color) ~= "Color3" then return nil end
    local red = math.clamp(math.floor(color.R * 255 + 0.5), 0, 255)
    local green = math.clamp(math.floor(color.G * 255 + 0.5), 0, 255)
    local blue = math.clamp(math.floor(color.B * 255 + 0.5), 0, 255)
    return red * 65536 + green * 256 + blue
end

function UI.refreshControls()
    for key, view in pairs(UI.toggleViews) do
        UI.syncControl(view, settings[key])
    end
    for key, view in pairs(UI.numberViews) do
        UI.syncControl(view, settings[key])
    end
    for key, view in pairs(UI.choiceViews) do
        UI.syncControl(view, settings[key])
    end
    for key, view in pairs(UI.colorViews) do
        local ok, current = pcall(view.Get, view)
        if not ok or UI.packColor(current) ~= settings[key] then
            UI.syncControl(view, UI.color(settings[key]))
        end
    end
    UI.refreshOverlays()
end

function Motion.disconnectCharacter()
    for _, connection in ipairs(Motion.characterConnections) do
        connection:Disconnect()
    end
    table.clear(Motion.characterConnections)
end

function Motion.watchParts()
    local character = Motion.character
    if not character or not settings.noclip or #Motion.characterConnections > 0 then
        return
    end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            Motion.parts[descendant] = true
        end
    end
    table.insert(Motion.characterConnections, character.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            Motion.parts[descendant] = true
        end
    end))
    table.insert(Motion.characterConnections, character.DescendantRemoving:Connect(function(descendant)
        if Motion.parts[descendant] then
            Guard.clearObject("noclip", descendant)
            Motion.parts[descendant] = nil
        end
    end))
end

function Motion.bindCharacter(character)
    if Motion.character == character then
        return
    end
    Motion.disconnectCharacter()
    Guard.clear("speed")
    Guard.clear("stamina")
    Guard.clear("stagger")
    Guard.clear("slow")
    Guard.clear("reload")
    Guard.clear("noclip")
    Motion.character = character
    Motion.humanoid = nil
    Motion.root = nil
    Motion.parts = {}
    Motion.watchParts()
end

function Motion.resolve()
    local character = LocalPlayer.Character
    if character ~= Motion.character then
        Motion.bindCharacter(character)
    end
    if not character then
        return nil, nil, nil
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if root and not root:IsA("BasePart") then
        root = nil
    end
    Motion.humanoid = humanoid
    Motion.root = root
    return character, humanoid, root
end

function Motion.staminaAvailable()
    local client = ReplicatedStorage:FindFirstChild("Client")
    local config = client and client:FindFirstChild("Config")
    local flag = config and config:FindFirstChild("UseRefactoredClient")
    return not (flag and flag:IsA("BoolValue") and flag.Value == true)
end

function Motion.blocked(character)
    if not character then
        return true
    end
    if character:GetAttribute("CarryQuestMovementLocked") == true or character:GetAttribute("Executing") == true or character:FindFirstChild("Executing") then
        return true
    end
    local globalStates = character:FindFirstChild("GlobalStates")
    local executing = globalStates and globalStates:FindFirstChild("isExecuting")
    if executing and executing:IsA("BoolValue") and executing.Value == true then
        return true
    end
    local stagger = tonumber(character:GetAttribute("SINStaggerUntil")) or 0
    if stagger > 0 and ReplicatedStorage:GetAttribute("StaggerEnabled") ~= false and character:GetAttribute("StaggerImmune") ~= true and character:GetAttribute("RiotShieldEquipped") ~= true then
        local ok, now = pcall(function()
            return Workspace:GetServerTimeNow()
        end)
        if ok and stagger > now then
            return true
        end
    end
    return false
end

function Motion.updateProperties()
    local character, humanoid = Motion.resolve()
    if not character or not humanoid or humanoid.Health <= 0 then
        Guard.clear("speed")
        Guard.clear("stamina")
        Guard.clear("stagger")
        Guard.clear("slow")
        Guard.clear("reload")
        return
    end
    if settings.antiStagger then
        Guard.set("stagger", character, "StaggerImmune", true, true)
    else
        Guard.clear("stagger")
    end
    if settings.noSlow then
        Guard.set("slow", character, "FelsiMovementMult", 1, true)
        Guard.set("slow", character, "VoraxBileSlowMultiplier", 1, true)
    else
        Guard.clear("slow")
    end
    if settings.fastReload then
        Guard.set("reload", character, "SquadReloadSpeedMultiplier", settings.squadReload / 100, true)
        Guard.set("reload", character, "FelsiReloadSpeedMult", settings.felsiReload / 100, true)
        Guard.set("reload", character, "CandyCommanderReload", true, true)
    else
        Guard.clear("reload")
    end
    if settings.speedEnabled and not Motion.blocked(character) then
        Guard.set("speed", humanoid, "WalkSpeed", settings.speed, false)
    else
        Guard.clear("speed")
    end
    if settings.stamina and Motion.staminaAvailable() then
        Guard.set("stamina", character, "infiniteStamina", true, true)
    else
        Guard.clear("stamina")
    end

end

function Motion.updateNoclip()
    if not settings.noclip or not Motion.character then
        if Guard.groups.noclip then
            Guard.clear("noclip")
        end
        return
    end
    for part in pairs(Motion.parts) do
        if part.Parent and part:IsDescendantOf(Motion.character) then
            Guard.set("noclip", part, "CanCollide", false, false)
        else
            Guard.clearObject("noclip", part)
            Motion.parts[part] = nil
        end
    end
end

function Combat.ownedValue(patch, current)
    if current ~= patch.written then
        return false
    end
    if patch.zeroRange then
        return type(current) == "table" and current[1] == 0 and current[2] == 0
    end
    return true
end

function Combat.restorePatches()
    for index = #Combat.patches, 1, -1 do
        local patch = Combat.patches[index]
        local readOk, current = pcall(function()
            return patch.target[patch.key]
        end)
        if readOk and Combat.ownedValue(patch, current) then
            pcall(function()
                patch.target[patch.key] = patch.original
            end)
        end
    end
    table.clear(Combat.patches)
    Combat.fireRef = nil
    Combat.recoilRef = nil
end

function Combat.patch(target, key, value, zeroRange)
    if type(target) ~= "table" then
        return false
    end
    local readOk, original = pcall(function()
        return target[key]
    end)
    if not readOk then
        return false
    end
    local wrote, current = pcall(function()
        target[key] = value
        return target[key]
    end)
    if not wrote or current ~= value then
        return false
    end
    table.insert(Combat.patches, {target = target, key = key, original = original, written = value, zeroRange = zeroRange})
    return true
end

function Combat.needsConfig()
    return settings.noRecoil
end

function Combat.hooksWanted()
    return Combat.needsConfig() or settings.silentAim or settings.autoReload
end

function Combat.wanted()
    return Combat.hooksWanted() or settings.autoReload or settings.autoPunch
end

function Combat.applyPatches()
    Combat.restorePatches()
    local config = Combat.settings
    if type(config) ~= "table" or type(config.fire) ~= "table" then
        return
    end
    local fire = config.fire
    Combat.fireRef = fire
    Combat.recoilRef = fire.recoil
    local attempted, successful = 0, 0
    if settings.noRecoil and type(fire.recoil) == "table" then
        for _, axis in ipairs({"x", "y", "z"}) do
            local range = fire.recoil[axis]
            if type(range) == "table" and type(range[1]) == "number" and type(range[2]) == "number" then
                attempted += 1
                if Combat.patch(fire.recoil, axis, {0, 0}, true) then
                    successful += 1
                else
                    local low = Combat.patch(range, 1, 0)
                    local high = Combat.patch(range, 2, 0)
                    if low and high then
                        successful += 1
                    end
                end
            end
        end
    end
    if Combat.needsConfig() and attempted == 0 then
        Combat.state = "Weapon: no supported local fields found"
    elseif successful < attempted then
        Combat.state = "Weapon: some local fields are protected"
    elseif Combat.source == "live" then
        Combat.state = "Weapon: active client configuration linked; server limits unknown"
    else
        Combat.state = "Weapon: local configuration unverified; fire or reload to confirm"
    end
end

function Combat.patchesValid()
    local config = Combat.settings
    if type(config) ~= "table" or type(config.fire) ~= "table" or config.fire ~= Combat.fireRef then
        return false
    end
    if settings.noRecoil and config.fire.recoil ~= Combat.recoilRef then
        return false
    end
    for _, patch in ipairs(Combat.patches) do
        local ok, current = pcall(function()
            return patch.target[patch.key]
        end)
        if not ok or not Combat.ownedValue(patch, current) then
            return false
        end
    end
    return true
end

function Combat.clearWeapon()
    if Auto.reset then Auto.reset() end
    if Reload.reset then Reload.reset() end
    Combat.request += 1
    Combat.pending = false
    Combat.restorePatches()
    if Silent.resetCalibration then
        Silent.resetCalibration()
    end
    Combat.tool = nil
    Combat.module = nil
    Combat.settings = nil
    Combat.source = nil
    Combat.retryAt = nil
    Combat.state = "Weapon: waiting"
end

function Combat.moduleFor(tool)
    local module = tool and tool:FindFirstChild("")
    if module and module:IsA("ModuleScript") then
        return module
    end
    return nil
end

function Combat.findWeapon(character)
    if not character then
        return nil, nil
    end
    local current = Combat.tool
    if current and current.Parent == character and current:IsA("Tool") then
        return current, Combat.moduleFor(current)
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local module = Combat.moduleFor(child)
            if module then
                return child, module
            end
            local client = child:FindFirstChild("Client")
            local listener = child:FindFirstChild("__listener")
            if client and client:IsA("ModuleScript") or listener and listener:IsA("RemoteEvent") then
                return child, nil
            end
        end
    end
    return nil, nil
end

function Combat.observe(tool, config)
    if typeof(tool) ~= "Instance" or not tool:IsA("Tool") or tool.Parent ~= LocalPlayer.Character or type(config) ~= "table" or type(config.fire) ~= "table" then
        return false
    end
    local module = Combat.moduleFor(tool)
    if tool ~= Combat.tool or module ~= Combat.module then
        Combat.clearWeapon()
        Combat.tool, Combat.module = tool, module
    end
    if Combat.source ~= "live" or Combat.settings ~= config then
        Combat.request += 1
        Combat.pending = false
        Combat.restorePatches()
        Combat.settings = config
        Combat.source = "live"
        Combat.retryAt = nil
        Combat.applyPatches()
    elseif Combat.needsConfig() and not Combat.patchesValid() then
        Combat.applyPatches()
    end
    return true
end

function Combat.update()
    if not Combat.wanted() then
        if Combat.tool or Combat.pending or #Combat.patches > 0 then
            Combat.clearWeapon()
        end
        return
    end
    local character = LocalPlayer.Character
    local tool, module = Combat.findWeapon(character)
    if tool ~= Combat.tool or module ~= Combat.module then
        Combat.clearWeapon()
        Combat.tool = tool
        Combat.module = module
    end
    if not tool then
        Combat.state = "Weapon: equip a weapon"
        return
    end
    if Combat.hooksWanted() and Silent.tryInstall then
        Silent.tryInstall()
    end
    if not Combat.needsConfig() then
        if Combat.pending then
            Combat.request += 1
            Combat.pending = false
        end
        if Combat.settings and #Combat.patches > 0 then
            Combat.applyPatches()
        elseif not Combat.settings then
            Combat.state = "Weapon: detected"
        end
        return
    end
    if Combat.settings then
        if not Combat.patchesValid() then
            Combat.applyPatches()
        end
        return
    end
    if not module then
        Combat.state = "Weapon: waiting for the active client configuration"
        return
    end
    if not Combat.pending and (not Combat.retryAt or os.clock() >= Combat.retryAt) then
        Combat.pending = true
        Combat.request += 1
        local request = Combat.request
        Combat.state = "Weapon: loading local configuration"
        task.spawn(function()
            local ok, result = pcall(require, module)
            if not App.alive or Combat.request ~= request or Combat.tool ~= tool or Combat.module ~= module or tool.Parent ~= character then
                return
            end
            Combat.pending = false
            if ok and type(result) == "table" and type(result.fire) == "table" then
                Combat.settings = result
                Combat.source = "candidate"
                Combat.applyPatches()
            else
                Combat.state = "Weapon: local configuration unavailable; waiting for a shot"
                Combat.retryAt = os.clock() + 3
            end
        end)
    end
end

function World.position(instance)
    if not instance or typeof(instance) ~= "Instance" then
        return nil
    end
    if instance:IsA("BasePart") then
        return instance.Position
    elseif instance:IsA("Attachment") then
        return instance.WorldPosition
    elseif instance:IsA("Model") then
        local ok, pivot = pcall(function()
            return instance:GetPivot()
        end)
        return ok and pivot.Position or nil
    elseif instance:IsA("Vector3Value") then
        return instance.Value
    end
    local value = instance:GetAttribute("Position")
    return typeof(value) == "Vector3" and value or nil
end

function World.resolvePath(path)
    if type(path) ~= "string" or path == "" then
        return nil
    end
    local current = Workspace
    for segment in string.gmatch(path, "[^%.]+") do
        current = current:FindFirstChild(segment)
        if not current then
            return nil
        end
    end
    return current
end

function World.validPosition(position)
    return typeof(position) == "Vector3" and position.X == position.X and position.Y == position.Y and position.Z == position.Z and math.abs(position.X) < 10000000 and math.abs(position.Y) < 10000000 and math.abs(position.Z) < 10000000
end

function World.objectiveEntry(child)
    if not child:IsA("Folder") and not child:IsA("Vector3Value") then return nil end
    local marker = child:FindFirstChild("Marker")
    local markerTarget = marker and marker:IsA("ObjectValue") and marker.Value or nil
    local path = child:GetAttribute("LocalHighlightTargetPath")
    local position = World.position(markerTarget)
    if not World.validPosition(position) then position = child:GetAttribute("MinimapPosition") end
    if not World.validPosition(position) then position = child:GetAttribute("MarkerPosition") end
    if not World.validPosition(position) then position = World.position(child) end
    if not World.validPosition(position) and type(path) == "string" then
        position = World.position(World.resolvePath(path))
    end
    if not World.validPosition(position) then return nil end
    local name = child:GetAttribute("Text") or child:GetAttribute("ObjectiveId") or child.Name
    return {key = child, name = tostring(name or "Objective"), position = position}, path
end

function World.eventObjectives()
    local entries = {}
    local folder = ReplicatedStorage:FindFirstChild("PostGameEventMarkers")
    if folder then
        for _, child in ipairs(folder:GetChildren()) do
            local entry = World.objectiveEntry(child)
            if entry then table.insert(entries, entry) end
            if #entries >= 200 then break end
        end
    end
    return entries
end

function World.objectives()
    local entries = {}
    local paths = {}
    local function add(key, name, position)
        if key and World.validPosition(position) and #entries < 200 then
            table.insert(entries, {key = key, name = tostring(name or "Objective"), position = position})
        end
    end
    local function collectFolder(folder)
        if not folder then
            return
        end
        for _, child in ipairs(folder:GetChildren()) do
            local entry, path = World.objectiveEntry(child)
            if entry then
                if type(path) == "string" then paths[path] = true end
                add(entry.key, entry.name, entry.position)
            end
        end
    end
    local active = ReplicatedStorage:FindFirstChild("ActiveRadarObjectives")
    collectFolder(active)
    collectFolder(ReplicatedStorage:FindFirstChild("PostGameEventMarkers"))
    if active then
        local rawPaths = active:GetAttribute("LocalHighlightTargetPaths")
        if type(rawPaths) ~= "string" or rawPaths == "" then
            rawPaths = active:GetAttribute("LocalHighlightTargetPath")
        end
        if type(rawPaths) == "string" then
            for path in string.gmatch(rawPaths, "[^\n]+") do
                if not paths[path] then
                    local target = World.resolvePath(path)
                    if target then
                        paths[path] = true
                        add("path:" .. path, target.Name, World.position(target))
                    end
                end
            end
        end
    end
    local carryState = LocalPlayer:GetAttribute("CarryQuestState")
    local carryActive = carryState == "Available" or carryState == "PickingUp" or carryState == "Carrying" or carryState == "Dropping" or carryState == "Dropped" or carryState == "Delivering"
    if carryState == "Available" or carryState == "Dropped" then
        add("carry:patient", "JOSH", LocalPlayer:GetAttribute("CarryQuestPatientPosition"))
    end
    if carryActive then
        local carry = Workspace:FindFirstChild("CarryQuest")
        if carry then
            local frame = carry:GetAttribute("CarryQuestDeliveryZoneCFrame")
            local position = typeof(frame) == "CFrame" and frame.Position or nil
            if not World.validPosition(position) then
                position = World.position(carry:FindFirstChild("DeliveryZone"))
            end
            add("carry:delivery", "JOSH rescue zone", position)
        end
    end
    return entries
end

function World.pickups()
    local result = {}
    local ok, tagged = pcall(function()
        return CollectionService:GetTagged("PickupHighlight")
    end)
    if not ok or type(tagged) ~= "table" then
        return result
    end
    for _, highlight in ipairs(tagged) do
        if highlight:IsA("Highlight") then
            local target = highlight.Adornee or highlight.Parent
            if target and (target:IsA("Model") or target:IsA("BasePart")) and target:IsDescendantOf(Workspace) then
                local position = World.position(target)
                if World.validPosition(position) then
                    table.insert(result, {key = highlight, target = target, name = target.Name, position = position})
                end
            end
        end
    end
    return result
end

function World.origin()
    local _, _, root = Motion.resolve()
    if root then
        return root.Position
    end
    local camera = Workspace.CurrentCamera
    return camera and camera.CFrame.Position or nil
end

function World.closest(entries)
    local origin = World.origin()
    if not origin then
        return nil
    end
    local best, distance = nil, math.huge
    for _, entry in ipairs(entries) do
        local candidate = (entry.position - origin).Magnitude
        if candidate < distance then
            best = entry
            distance = candidate
        end
    end
    return best, distance
end

function World.teleport(position)
    local character, humanoid, root = Motion.resolve()
    if not character or not humanoid or not root or humanoid.Health <= 0 then
        App.notice("Character is not ready")
        return false
    end
    if Motion.blocked(character) then
        App.notice("Teleport is unavailable during a movement lock")
        return false
    end
    if not World.validPosition(position) then
        App.notice("Destination is unavailable")
        return false
    end
    local ok = pcall(function()
        root.CFrame = root.CFrame + (position - root.Position)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)
    if not ok then
        App.notice("Could not move the character")
        return false
    end
    return true
end

function World.teleportNearestObjective()
    local target = World.closest(World.objectives())
    if not target then
        App.notice("No active objectives found")
        return false
    end
    if World.teleport(target.position + Vector3.new(0, 3, 0)) then
        App.notice("Objective: " .. target.name .. "; the server may move you back")
        return true
    end
    return false
end

function World.teleportNearestPickup()
    local target = World.closest(World.pickups())
    if not target then
        App.notice("No PickupHighlight items found")
        return false
    end
    if World.teleport(target.position + Vector3.new(0, 3, 0)) then
        App.notice("Item: " .. target.name .. "; the server may move you back")
        return true
    end
    return false
end

function World.savePosition()
    local _, humanoid, root = Motion.resolve()
    if humanoid and root and humanoid.Health > 0 then
        App.savedPosition = root.CFrame
        App.notice("Position saved until the script is unloaded")
        return true
    end
    App.notice("Character is not ready")
    return false
end

function World.returnPosition()
    if not App.savedPosition then
        App.notice("Save a position first")
        return false
    end
    if World.teleport(App.savedPosition.Position) then
        App.notice("Returned locally")
        return true
    end
    return false
end

function Visual.makeBillboard(adornee, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HallowedHubLabel"
    billboard.Adornee = adornee
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(200, 42)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
    billboard.MaxDistance = settings.espDistance
    billboard.Parent = Visual.folder
    local label = UI.label(billboard, "", 13, color)
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextStrokeTransparency = 0.25
    label.TextWrapped = true
    return billboard, label
end

function Visual.makeHighlight(target, color)
    local highlight = Instance.new("Highlight")
    highlight.Name = "HallowedHubHighlight"
    highlight.Adornee = target
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.82
    highlight.OutlineTransparency = 0.05
    highlight.Parent = Visual.folder
    return highlight
end

function Visual.destroyEntry(entry)
    if not entry then
        return
    end
    if entry.highlight then
        entry.highlight:Destroy()
    end
    if entry.billboard then
        entry.billboard:Destroy()
    end
    if entry.anchor then
        entry.anchor:Destroy()
    end
    if entry.overlay then
        entry.overlay:Destroy()
    end
end

function Visual.clearMap(map)
    for key, entry in pairs(map) do
        Visual.destroyEntry(entry)
        map[key] = nil
    end
end

function Visual.clearAll()
    Visual.clearMap(Visual.characters)
    Visual.clearMap(Visual.pickups)
    Visual.clearMap(Visual.objectives)
end

function Visual.ensureFolder()
    local parent = visualFolder and visualFolder.Parent
    if parent and (not parent:IsA("PlayerGui") or LocalPlayer:FindFirstChildOfClass("PlayerGui") == parent) then
        return true
    end
    Visual.clearAll()
    if visualFolder then pcall(function() visualFolder:Destroy() end) end
    visualFolder = nil
    Visual.folder = nil
    local folder = Instance.new("Folder")
    folder.Name = "HallowedReactorHubVisuals"
    local preferred = UI.window and UI.window.Gui and UI.window.Gui.Parent or screen.Parent or guiHost
    if not UI.attach(folder, preferred, true) then
        pcall(function() folder:Destroy() end)
        return false
    end
    visualFolder = folder
    Visual.folder = folder
    return true
end

function World.characterPart(model)
    local head = model:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        return head
    end
    local root = model:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        return root
    end
    return model:FindFirstChildWhichIsA("BasePart", true)
end

function World.characterModels()
    local models = {}
    local seen = {}
    local folder = Workspace:FindFirstChild("Characters")
    if folder then
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("Model") and not seen[child] then
                seen[child] = true
                table.insert(models, child)
            end
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character:IsA("Model") and not seen[character] then
            seen[character] = true
            table.insert(models, character)
        end
    end
    return models
end

function World.findPlayer(model)
    local player = Players:GetPlayerFromCharacter(model)
    if player then
        return player
    end
    local named = Players:FindFirstChild(model.Name)
    if named and named:IsA("Player") then
        return named
    end
    return nil
end

function World.playerRelation(model)
    local player = World.findPlayer(model)
    if not player then
        return "npc", nil
    end
    if player == LocalPlayer then
        return "self", player
    end
    if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
        return "ally", player
    end
    return "player", player
end

function Visual.makeOverlay(entry)
    local overlay = Instance.new("Frame")
    overlay.Name = "CharacterESP"
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Parent = screen
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = overlay
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Parent = box
    entry.overlay, entry.box, entry.stroke, entry.bones = overlay, box, stroke, {}
end

function Visual.bone(entry, index)
    local line = entry.bones[index]
    if line then return line end
    line = Instance.new("Frame")
    line.Name = "Bone"
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundTransparency = 0
    line.BorderSizePixel = 0
    line.Visible = false
    line.Parent = entry.overlay
    entry.bones[index] = line
    return line
end

function Visual.updateCharacters(origin)
    local anyNPC = settings.espNPC or settings.mobBoxes or settings.mobSkeletons or settings.espBoss or settings.bossBoxes or settings.bossSkeletons
    if not (settings.espPlayers or settings.espAllies or anyNPC) or not origin then
        Visual.clearMap(Visual.characters)
        return
    end
    local candidates = {}
    for _, model in ipairs(World.characterModels()) do
        if model ~= LocalPlayer.Character then
            local relation, player = World.playerRelation(model)
            local boss = relation == "npc" and World.isBoss(model)
            local npc = relation == "npc" and World.isHostile(model, true)
            local showLabel = relation == "ally" and settings.espAllies or relation == "player" and settings.espPlayers or npc and (boss and settings.espBoss or not boss and settings.espNPC)
            local showBox = npc and (boss and settings.bossBoxes or not boss and settings.mobBoxes)
            local showSkeleton = npc and (boss and settings.bossSkeletons or not boss and settings.mobSkeletons)
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            local part = World.characterPart(model)
            if (showLabel or showBox or showSkeleton) and humanoid and humanoid.Health > 0 and part then
                local distance = (part.Position - origin).Magnitude
                if distance <= settings.espDistance then
                    table.insert(candidates, {key = model, part = part, humanoid = humanoid, player = player, relation = relation, boss = boss, distance = distance, label = showLabel, box = showBox, skeleton = showSkeleton})
                end
            end
        end
    end
    table.sort(candidates, function(a, b) return a.distance < b.distance end)
    local keep, skeletonCount = {}, 0
    for index = 1, math.min(#candidates, 64) do
        local candidate = candidates[index]
        local model = candidate.key
        keep[model] = true
        local color = candidate.relation == "ally" and Color3.fromRGB(87, 209, 170) or candidate.relation == "npc" and UI.color(candidate.boss and settings.bossColor or settings.mobColor) or Color3.fromRGB(245, 106, 106)
        local entry = Visual.characters[model]
        if not entry then
            entry = {}
            Visual.characters[model] = entry
        end
        entry.color = color
        entry.showBox = candidate.box == true
        entry.showSkeleton = candidate.skeleton == true and skeletonCount < 40
        if entry.showSkeleton then skeletonCount += 1 end
        if candidate.label then
            if not entry.billboard then
                entry.billboard, entry.label = Visual.makeBillboard(candidate.part, color)
                entry.highlight = Visual.makeHighlight(model, color)
            end
            entry.billboard.Adornee = candidate.part
            entry.billboard.MaxDistance = settings.espDistance
            entry.highlight.FillColor = color
            entry.highlight.OutlineColor = color
            entry.label.TextColor3 = color
            local name = candidate.player and candidate.player.DisplayName or model.Name
            entry.label.Text = string.format("%s  [%dm]\nHP %d", tostring(name), math.floor(candidate.distance + 0.5), math.max(0, math.floor(candidate.humanoid.Health + 0.5)))
        elseif entry.billboard then
            entry.billboard:Destroy()
            entry.highlight:Destroy()
            entry.billboard, entry.label, entry.highlight = nil, nil, nil
        end
        if entry.showBox or entry.showSkeleton then
            if not entry.overlay then Visual.makeOverlay(entry) end
            entry.stroke.Color = color
            if entry.showSkeleton then Visual.bindBones(model, entry) else entry.skeleton = nil end
        elseif entry.overlay then
            entry.overlay:Destroy()
            entry.overlay, entry.box, entry.stroke, entry.bones, entry.skeleton = nil, nil, nil, nil, nil
        end
    end
    for model, entry in pairs(Visual.characters) do
        if not keep[model] then
            Visual.destroyEntry(entry)
            Visual.characters[model] = nil
        end
    end
end

function Visual.projectBox(camera, model, entry)
    if not entry.showBox then entry.box.Visible = false return end
    local ok, frame, size = pcall(model.GetBoundingBox, model)
    if not ok or typeof(frame) ~= "CFrame" or typeof(size) ~= "Vector3" then entry.box.Visible = false return end
    local minimumX, minimumY = math.huge, math.huge
    local maximumX, maximumY = -math.huge, -math.huge
    for x = -1, 1, 2 do
        for y = -1, 1, 2 do
            for z = -1, 1, 2 do
                local point = camera:WorldToViewportPoint(frame * Vector3.new(size.X * x * 0.5, size.Y * y * 0.5, size.Z * z * 0.5))
                if point.Z <= 0 then entry.box.Visible = false return end
                minimumX, minimumY = math.min(minimumX, point.X), math.min(minimumY, point.Y)
                maximumX, maximumY = math.max(maximumX, point.X), math.max(maximumY, point.Y)
            end
        end
    end
    local viewport = camera.ViewportSize
    minimumX, maximumX = math.clamp(minimumX, 0, viewport.X), math.clamp(maximumX, 0, viewport.X)
    minimumY, maximumY = math.clamp(minimumY, 0, viewport.Y), math.clamp(maximumY, 0, viewport.Y)
    local width, height = maximumX - minimumX, maximumY - minimumY
    entry.box.Visible = width > 1 and height > 1
    if entry.box.Visible then
        entry.box.Position = UDim2.fromOffset(minimumX, minimumY)
        entry.box.Size = UDim2.fromOffset(width, height)
    end
end

function Visual.part(model, names)
    for _, name in ipairs(names) do
        local part = model:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    return nil
end

Visual.skeletonLinks = {
        {{"Head"}, {"UpperTorso", "Torso"}},
        {{"UpperTorso", "Torso"}, {"LowerTorso", "HumanoidRootPart"}},
        {{"UpperTorso", "Torso"}, {"LeftUpperArm", "Left Arm"}},
        {{"LeftUpperArm"}, {"LeftLowerArm"}},
        {{"LeftLowerArm"}, {"LeftHand"}},
        {{"UpperTorso", "Torso"}, {"RightUpperArm", "Right Arm"}},
        {{"RightUpperArm"}, {"RightLowerArm"}},
        {{"RightLowerArm"}, {"RightHand"}},
        {{"LowerTorso", "Torso", "HumanoidRootPart"}, {"LeftUpperLeg", "Left Leg"}},
        {{"LeftUpperLeg"}, {"LeftLowerLeg"}},
        {{"LeftLowerLeg"}, {"LeftFoot"}},
        {{"LowerTorso", "Torso", "HumanoidRootPart"}, {"RightUpperLeg", "Right Leg"}},
        {{"RightUpperLeg"}, {"RightLowerLeg"}},
        {{"RightLowerLeg"}, {"RightFoot"}},
}

function Visual.bindBones(model, entry)
    entry.skeleton = entry.skeleton or {}
    for index, pair in ipairs(Visual.skeletonLinks) do
        local link = entry.skeleton[index] or {}
        link[1], link[2] = Visual.part(model, pair[1]), Visual.part(model, pair[2])
        entry.skeleton[index] = link
    end
end

function Visual.projectSkeleton(camera, model, entry)
    if not entry.showSkeleton then
        for _, line in ipairs(entry.bones) do line.Visible = false end
        return
    end
    for index, pair in ipairs(entry.skeleton or {}) do
        local line = Visual.bone(entry, index)
        local a, b = pair[1], pair[2]
        local visible = false
        if a and b and a.Parent and b.Parent then
            local first, firstOn = camera:WorldToViewportPoint(a.Position)
            local second, secondOn = camera:WorldToViewportPoint(b.Position)
            if firstOn and secondOn and first.Z > 0 and second.Z > 0 then
                local dx, dy = second.X - first.X, second.Y - first.Y
                local length = math.sqrt(dx * dx + dy * dy)
                if length > 0.5 then
                    line.Position = UDim2.fromOffset((first.X + second.X) * 0.5, (first.Y + second.Y) * 0.5)
                    line.Size = UDim2.fromOffset(length, 2)
                    line.Rotation = math.deg(math.atan2(dy, dx))
                    line.BackgroundColor3 = entry.color
                    visible = true
                end
            end
        end
        line.Visible = visible
    end
end

function Visual.renderCharacters()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    for model, entry in pairs(Visual.characters) do
        if entry.overlay then
            if model.Parent then
                Visual.projectBox(camera, model, entry)
                Visual.projectSkeleton(camera, model, entry)
            else
                entry.overlay.Visible = false
            end
        end
    end
end

function Visual.updatePickups(origin)
    if not settings.espPickups or not origin then
        Visual.clearMap(Visual.pickups)
        return
    end
    local candidates = {}
    for _, item in ipairs(World.pickups()) do
        item.distance = (item.position - origin).Magnitude
        if item.distance <= settings.espDistance then
            table.insert(candidates, item)
        end
    end
    table.sort(candidates, function(a, b)
        return a.distance < b.distance
    end)
    local keep = {}
    local color = Color3.fromRGB(99, 205, 255)
    for index = 1, math.min(#candidates, 32) do
        local item = candidates[index]
        local part = item.target:IsA("BasePart") and item.target or World.characterPart(item.target)
        if part then
            keep[item.key] = true
            local entry = Visual.pickups[item.key]
            if not entry or entry.target ~= item.target then
                if entry then
                    Visual.destroyEntry(entry)
                end
                local billboard, label = Visual.makeBillboard(part, color)
                entry = {target = item.target, billboard = billboard, label = label, highlight = Visual.makeHighlight(item.target, color)}
                Visual.pickups[item.key] = entry
            end
            entry.billboard.Adornee = part
            entry.billboard.MaxDistance = settings.espDistance
            entry.label.Text = string.format("%s  [%dm]", item.name, math.floor(item.distance + 0.5))
        end
    end
    for key, entry in pairs(Visual.pickups) do
        if not keep[key] then
            Visual.destroyEntry(entry)
            Visual.pickups[key] = nil
        end
    end
end

function Visual.updateObjectives(origin)
    if not settings.espObjectives or not origin then
        Visual.clearMap(Visual.objectives)
        return
    end
    local candidates = {}
    for _, item in ipairs(World.objectives()) do
        item.distance = (item.position - origin).Magnitude
        if item.distance <= settings.espDistance then
            table.insert(candidates, item)
        end
    end
    table.sort(candidates, function(a, b)
        return a.distance < b.distance
    end)
    local keep = {}
    local color = Color3.fromRGB(255, 221, 94)
    for index = 1, math.min(#candidates, 32) do
        local item = candidates[index]
        keep[item.key] = true
        local entry = Visual.objectives[item.key]
        if not entry then
            local anchor = Instance.new("Attachment")
            anchor.Name = "HallowedHubObjective"
            anchor.Parent = Workspace.Terrain
            local billboard, label = Visual.makeBillboard(anchor, color)
            entry = {anchor = anchor, billboard = billboard, label = label}
            Visual.objectives[item.key] = entry
        end
        entry.anchor.WorldPosition = item.position
        entry.billboard.MaxDistance = settings.espDistance
        entry.label.Text = string.format("%s  [%dm]", item.name, math.floor(item.distance + 0.5))
    end
    for key, entry in pairs(Visual.objectives) do
        if not keep[key] then
            Visual.destroyEntry(entry)
            Visual.objectives[key] = nil
        end
    end
end

function Visual.update()
    if not (settings.espPlayers or settings.espAllies or settings.espNPC or settings.mobBoxes or settings.mobSkeletons or settings.espBoss or settings.bossBoxes or settings.bossSkeletons or settings.espPickups or settings.espObjectives) then
        if next(Visual.characters) or next(Visual.pickups) or next(Visual.objectives) then
            Visual.clearAll()
        end
        if visualFolder then pcall(function() visualFolder:Destroy() end) end
        visualFolder = nil
        Visual.folder = nil
        return
    end
    if not Visual.ensureFolder() then
        return
    end
    local origin = World.origin()
    Visual.updateCharacters(origin)
    Visual.updatePickups(origin)
    Visual.updateObjectives(origin)
end

function Visual.updateLighting()
    if settings.fullbright then
        Guard.set("light", Lighting, "Ambient", Color3.new(1, 1, 1), false)
        Guard.set("light", Lighting, "OutdoorAmbient", Color3.new(1, 1, 1), false)
        Guard.set("light", Lighting, "Brightness", 2, false)
        Guard.set("light", Lighting, "ExposureCompensation", 0, false)
    else
        Guard.clear("light")
    end
    if settings.noFog then
        Guard.set("fog", Lighting, "FogEnd", 1000000000, false)
        Guard.set("fog", Lighting, "FogStart", 0, false)
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("Atmosphere") then
                Guard.set("fog", child, "Density", 0, false)
                Guard.set("fog", child, "Haze", 0, false)
                Guard.set("fog", child, "Glare", 0, false)
            end
        end
    else
        Guard.clear("fog")
    end
end

function Visual.updateCamera()
    local camera = Workspace.CurrentCamera
    if Visual.fovCamera ~= camera then
        Guard.clear("fov")
        Visual.fovCamera = camera
    end
    if settings.fovEnabled and camera and camera.CameraType ~= Enum.CameraType.Scriptable then
        Guard.set("fov", camera, "FieldOfView", settings.fov, false)
    else
        Guard.clear("fov")
    end
end

function World.isHostile(model, allowInvulnerable)
    local characters = Workspace:FindFirstChild("Characters")
    local character = LocalPlayer.Character
    if not characters or model.Parent ~= characters or model == character or not model:IsA("Model") then
        return false
    end
    if model:GetAttribute("ActuallyActive") == false or model:GetAttribute("Friendly") == true or model:GetAttribute("IsFriendly") == true or model:GetAttribute("Ally") == true or model:GetAttribute("IsAlly") == true then
        return false
    end
    if not allowInvulnerable and (model:GetAttribute("AimAssistIgnore") == true or model:GetAttribute("AimAssistTargetable") == false or model:GetAttribute("Invulnerable") == true or model:GetAttribute("IsInvulnerable") == true or model:GetAttribute("Invincible") == true) then
        return false
    end
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 or not allowInvulnerable and model:FindFirstChildWhichIsA("ForceField", true) then
        return false
    end
    local player = World.findPlayer(model)
    if player then
        if player == LocalPlayer or not LocalPlayer.Team or not player.Team or LocalPlayer.Neutral == true or player.Neutral == true or LocalPlayer.Team == player.Team then
            return false
        end
    else
        local ai = model:FindFirstChild("AI")
        local aiSettings = ai and ai:FindFirstChild("settings")
        local hostile = aiSettings and aiSettings:FindFirstChild("playerHostile")
        if hostile and hostile:IsA("BoolValue") and hostile.Value == false then
            return false
        end
    end
    return true
end

function World.isBoss(model)
    if World.findPlayer(model) then return false end
    if model:GetAttribute("Boss") == true or model:GetAttribute("IsBoss") == true then return true end
    local name = string.lower(model.Name)
    for _, term in ipairs({"gilbert", "chimera", "sinitzyn", "sinitsyn", "cerberus", "d-zero", "dzero", "leaper", "mikhail", "yakov", "zhukov", "dave"}) do
        if string.find(name, term, 1, true) then return true end
    end
    return false
end

function World.isZombie(model)
    if not World.isHostile(model) or World.findPlayer(model) then return false end
    local name = string.lower(model.Name)
    if name == "rif" or string.match(name, "^rif[%s_%-]") then return false end
    if model:GetAttribute("Infected") == true or model:GetAttribute("Zombie") == true then return true end
    for _, term in ipairs({"infected", "zombie", "viral", "lurker", "mutant", "crawler", "grabby", "barnacle", "riser", "kamikaze", "slasher", "radaway", "vorax", "deceiver", "shielder", "gunner", "fury", "chimera", "cerberus", "gilbert", "d-zero", "dzero", "bomber", "leaper"}) do
        if string.find(name, term, 1, true) then return true end
    end
    return false
end

function World.threats(range)
    local origin = World.origin()
    if not World.validPosition(origin) then return nil end
    local count, nearest, nearestDistance = 0, nil, math.huge
    local maximumSquared = range * range
    for _, model in ipairs(World.characterModels()) do
        if World.isHostile(model, true) then
            local part = World.characterPart(model)
            local position = part and part.Position
            if World.validPosition(position) then
                local offset = position - origin
                local squared = offset:Dot(offset)
                if squared <= maximumSquared then
                    count += 1
                    if squared < nearestDistance then
                        nearest, nearestDistance = model, squared
                    end
                end
            end
        end
    end
    return count, nearest, nearest and math.sqrt(nearestDistance) or nil
end

function UI.updateTrackers()
    if settings.eventTracker then
        local origin = World.origin()
        local event, distance
        if World.validPosition(origin) then event, distance = World.closest(World.eventObjectives()) end
        if event and distance then
            local name = string.gsub(tostring(event.name), "%c", " ")
            UI.eventLabel.Text = string.format("EVENT: %s  [%d studs]", name, math.floor(distance + 0.5))
        elseif not World.validPosition(origin) then
            UI.eventLabel.Text = "EVENT: --"
        else
            UI.eventLabel.Text = "EVENT: no marker"
        end
    end
    if settings.threatTracker then
        local count, nearest, distance = World.threats(settings.threatRange)
        if count == nil then
            UI.threatLabel.Text = "THREATS: --"
        elseif nearest and distance then
            local name = string.gsub(tostring(nearest.Name), "%c", " ")
            UI.threatLabel.Text = string.format("THREATS: %d  |  %s [%d studs]", count, name, math.floor(distance + 0.5))
        else
            UI.threatLabel.Text = "THREATS: 0"
        end
    end
end

function World.targetPoint(model)
    local partName = settings.targetPart
    if partName == "Head" or partName == "Root" then
        local part = model:FindFirstChild(partName == "Head" and "Head" or "HumanoidRootPart")
        if part and part:IsA("BasePart") then return part.Position end
    elseif partName == "Torso" then
        for _, name in ipairs({"UpperTorso", "Torso", "LowerTorso"}) do
            local part = model:FindFirstChild(name)
            if part and part:IsA("BasePart") then return part.Position end
        end
    end
    local attachment = model:FindFirstChild("AimAssistPoint", true)
    if attachment and attachment:IsA("Attachment") then
        return attachment.WorldPosition
    end
    for _, name in ipairs({"UpperTorso", "Torso", "HumanoidRootPart"}) do
        local part = model:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part.Position
        end
    end
    return nil
end

function World.inAimFov(position)
    if settings.aimMode ~= "Screen" then return true end
    local camera = Workspace.CurrentCamera
    if not camera or not World.validPosition(position) then return false end
    local point, onScreen = camera:WorldToViewportPoint(position)
    if not onScreen or point.Z <= 0 then return false end
    local size = camera.ViewportSize
    local x, y = point.X - size.X * 0.5, point.Y - size.Y * 0.5
    return x * x + y * y <= settings.aimRadius * settings.aimRadius
end

function World.visible(origin, position, target)
    local direction = position - origin
    if direction.Magnitude < 0.01 then
        return true
    end
    local ignored = {}
    if LocalPlayer.Character then
        table.insert(ignored, LocalPlayer.Character)
    end
    local camera = Workspace.CurrentCamera
    if camera then
        table.insert(ignored, camera)
    end
    local terrainIgnore = Workspace.Terrain and Workspace.Terrain:FindFirstChild("Ignore")
    if terrainIgnore then
        table.insert(ignored, terrainIgnore)
    end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    for _ = 1, 6 do
        params.FilterDescendantsInstances = ignored
        local result = Workspace:Raycast(origin, direction, params)
        if not result then
            return true
        end
        local hit = result.Instance
        if hit == target or hit:IsDescendantOf(target) then
            return true
        end
        if not hit:IsA("BasePart") then
            return false
        end
        local ancestor = hit.Parent
        while ancestor and ancestor ~= Workspace do
            if ancestor:IsA("Model") and ancestor:FindFirstChildOfClass("Humanoid") then
                return false
            end
            ancestor = ancestor.Parent
        end
        local ignoreValue = hit:FindFirstChild("Ignore")
        local ignore = ignoreValue and ignoreValue:IsA("BoolValue") and ignoreValue.Value == true
        if hit.Transparency >= 1 or not hit.CanCollide or ignore then
            table.insert(ignored, hit)
        else
            return false
        end
    end
    return false
end

function World.selectSilentTarget(origin, maxTravel, accept, npcOnly, checkWalls)
    local characters = Workspace:FindFirstChild("Characters")
    if not characters or not World.validPosition(origin) then return nil end
    local best, bestPosition, bestSolution, bestSquared = nil, nil, nil, maxTravel * maxTravel
    for _, model in ipairs(characters:GetChildren()) do
        if World.isHostile(model) and (not npcOnly or World.isZombie(model)) then
            local position = World.targetPoint(model)
            if World.validPosition(position) and World.inAimFov(position) then
                local offset = position - origin
                local distanceSquared = offset:Dot(offset)
                if distanceSquared >= 0.0001 and distanceSquared <= bestSquared and (not checkWalls or World.visible(origin, position, model)) then
                    local solution = not accept and true or accept(model, position)
                    if solution then
                        best, bestPosition, bestSolution, bestSquared = model, position, solution, distanceSquared
                    end
                end
            end
        end
    end
    return best, bestPosition, bestSolution
end

function Silent.resetCalibration()
    local shot = Silent.shot
    if not shot or not shot.direction or shot.remaining <= 0 or os.clock() - shot.time > 0.5 then
        Silent.shot = nil
    end
    Silent.pairNetwork = nil
    Silent.pairCast = nil
    Silent.target = nil
    Silent.targetTravel = nil
    Silent.targetNpcOnly = nil
    Silent.targetWalls = nil
    Silent.speedTool = nil
    Silent.speedFire = nil
    Silent.liveSpeed = nil
    Silent.liveAcceleration = nil
    Silent.liveMaxDistance = nil
    Silent.nextTargetScan = 0
    Silent.scanCount = 0
    Silent.nextAttempt = 0
end

function Silent.recordActive(record)
    if not record or not record.live then
        return false
    end
    local ok, current = pcall(rawget, record.target, record.key)
    return ok and current == record.wrapper
end

function Silent.pairActive()
    return Silent.recordActive(Silent.pairNetwork) and Silent.recordActive(Silent.pairCast)
end

function Silent.muzzle(tool, config)
    if typeof(tool) ~= "Instance" or not tool:IsA("Tool") or tool.Parent ~= LocalPlayer.Character or type(config) ~= "table" or type(config.corePart) ~= "string" then
        return nil
    end
    local model = tool:FindFirstChild(tool.Name)
    local core = model and model:IsA("Model") and model:FindFirstChild(config.corePart)
    if not core then
        for _, child in ipairs(tool:GetChildren()) do
            if child:IsA("Model") then
                local candidate = child:FindFirstChild(config.corePart)
                if candidate and candidate:IsA("BasePart") and candidate:FindFirstChild("FirePoint") then
                    core = candidate
                    break
                end
            end
        end
    end
    if not core or not core:IsA("BasePart") then
        return nil
    end
    local point = core:FindFirstChild("FirePoint")
    if point and point:IsA("Attachment") then
        return point.WorldPosition
    end
    if point and point:IsA("BasePart") then
        return point.Position
    end
    return nil
end

function Silent.intercept(origin, position, velocity, speed, acceleration, maxTravel)
    local displacement = position - origin
    local distance = displacement.Magnitude
    if not speed or speed <= 1 or speed ~= speed or speed == math.huge then
        return nil
    end
    if typeof(acceleration) ~= "Vector3" or not World.validPosition(acceleration) then
        acceleration = Vector3.zero
    end
    if typeof(velocity) ~= "Vector3" or not World.validPosition(velocity) then
        velocity = Vector3.zero
    end
    local maxTime = math.min(10000000, math.max(3, maxTravel / speed * 2 + 1))
    local function offset(time)
        return displacement + velocity * time - acceleration * (0.5 * time * time)
    end
    local function residual(time)
        return offset(time).Magnitude - speed * time
    end
    local lower, upper = 0, math.min(maxTime, math.max(0.001, distance / speed))
    while residual(upper) > 0 and upper < maxTime do
        upper = math.min(maxTime, upper * 1.25 + 0.001)
    end
    if residual(upper) > 0 then
        return nil
    end
    for _ = 1, 26 do
        local middle = (lower + upper) * 0.5
        if residual(middle) > 0 then
            lower = middle
        else
            upper = middle
        end
    end
    local time = (lower + upper) * 0.5
    local corrected = offset(time)
    local predicted = position + velocity * time
    if not World.validPosition(corrected) or not World.validPosition(predicted) or corrected.Magnitude < 0.01 then
        return nil
    end
    return corrected.Unit, time, predicted
end

function Silent.solve(origin, config, target, position, maxTravel, checkWalls)
    local targetRoot = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
    local velocity = targetRoot and targetRoot:IsA("BasePart") and targetRoot.AssemblyLinearVelocity or Vector3.zero
    local fire = type(config.fire) == "table" and config.fire or nil
    local observed = Silent.speedTool == Combat.tool and Silent.speedFire == fire
    local speed = observed and Silent.liveSpeed or fire and tonumber(fire.fireSpeed) or nil
    local acceleration = observed and Silent.liveAcceleration or fire and fire.acceleration or Vector3.zero
    local direction, time, predicted = Silent.intercept(origin, position, velocity, speed, acceleration, maxTravel)
    if not direction then return nil end
    if predicted and ((predicted - origin).Magnitude > maxTravel or checkWalls and not World.visible(origin, predicted, target)) then return nil end
    if time and typeof(acceleration) == "Vector3" and World.validPosition(acceleration) and acceleration.Magnitude > 0.01 then
        local previous = origin
        local traveled = 0
        local sag = acceleration.Magnitude * time * time / 8
        local segments = math.clamp(math.ceil(math.sqrt(sag / 0.25)), 1, 12)
        for index = 1, segments do
            local t = time * index / segments
            local current = origin + direction * (speed * t) + acceleration * (0.5 * t * t)
            if not World.validPosition(current) or checkWalls and not World.visible(previous, current, target) then
                return nil
            end
            traveled += (current - previous).Magnitude
            if traveled > maxTravel then return nil end
            previous = current
        end
    end
    return direction
end

function Silent.choose(origin, config, npcOnly)
    if not App.alive or not settings.silentAim or UI.open or not World.validPosition(origin) then return nil end
    local camera = Workspace.CurrentCamera
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not camera or camera.CameraType == Enum.CameraType.Scriptable or not humanoid or humanoid.Health <= 0 then return nil end
    local fire = type(config.fire) == "table" and config.fire or nil
    local configuredTravel = fire and fire.maxBulletTravelDistance
    local maxTravel = (configuredTravel == nil or configuredTravel == false) and 2500 or configuredTravel
    if type(maxTravel) ~= "number" or maxTravel ~= maxTravel or maxTravel <= 0 then return nil end
    if Silent.speedTool == Combat.tool and Silent.speedFire == fire and Silent.liveMaxDistance then
        maxTravel = math.min(maxTravel, Silent.liveMaxDistance)
    end
    npcOnly = npcOnly == true
    local checkWalls = npcOnly or settings.wallCheck
    local now = os.clock()
    local target, position = Silent.target, nil
    local rescan = now >= Silent.nextTargetScan or Silent.targetTravel ~= maxTravel or Silent.targetNpcOnly ~= npcOnly or Silent.targetWalls ~= checkWalls or not target or not World.isHostile(target) or npcOnly and not World.isZombie(target)
    if not rescan then
        position = World.targetPoint(target)
        if not World.validPosition(position) or not World.inAimFov(position) then
            rescan = true
        else
            local distance = (position - origin).Magnitude
            if distance < 0.01 or distance > maxTravel or checkWalls and not World.visible(origin, position, target) then rescan = true end
        end
    end
    if not rescan then
        local direction = Silent.solve(origin, config, target, position, maxTravel, checkWalls)
        if direction then return direction, target end
    end
    local function candidate(model, point)
        return Silent.solve(origin, config, model, point, maxTravel, checkWalls)
    end
    local direction
    target, position, direction = World.selectSilentTarget(origin, maxTravel, candidate, npcOnly, checkWalls)
    Silent.target = target
    Silent.targetTravel = maxTravel
    Silent.targetNpcOnly = npcOnly
    Silent.targetWalls = checkWalls
    Silent.nextTargetScan = now + 0.1
    if direction and target then return direction, target end
    return nil
end

function Silent.wrapNetwork(record, self, name, ...)
    local original = record.original
    if not record.live or not App.alive then
        return original(self, name, ...)
    end
    if name ~= "fire" and name ~= "reload" and name ~= "magout" and name ~= "glass" then
        return original(self, name, ...)
    end
    local args = table.pack(...)
    local tool, config = args[1], args[2]
    if Combat.hooksWanted() and args.n >= 2 then
        pcall(Combat.observe, tool, config)
    end
    if name ~= "fire" then
        return original(self, name, ...)
    end
    if tool == Combat.tool and type(config) == "table" and args.n >= 3 then
        Auto.shots += 1
        Auto.lastShotAt = os.clock()
        if Auto.held and Auto.heldTool == tool then
            Auto.autoShots += 1
            Auto.dryCycles = 0
            Reload.dryAttempts = 0
        end
    end
    if not settings.silentAim then
        Silent.shot = nil
        return original(self, name, ...)
    end
    if args.n < 3 or typeof(args[3]) ~= "Vector3" or tool ~= Combat.tool or type(config) ~= "table" then
        return original(self, name, ...)
    end
    local ok, origin = pcall(Silent.muzzle, tool, config)
    if not ok or typeof(origin) ~= "Vector3" then
        return original(self, name, ...)
    end
    local fire = type(config.fire) == "table" and config.fire or nil
    local pellets = fire and tonumber(fire.bulletPerRound) or 1
    if not pellets or pellets ~= pellets or pellets < 1 or pellets > 200 then pellets = 1 end
    local shot = {network = record, tool = tool, origin = origin, originalDirection = args[3], time = os.clock(), remaining = math.floor(pellets), fire = fire, speed = fire and tonumber(fire.fireSpeed) or nil}
    Silent.shot = shot
    if Silent.pairNetwork == record and Silent.pairActive() then
        local chooseOk, direction, target = pcall(Silent.choose, origin, config, Auto.held and Auto.heldTool == tool)
        if chooseOk and typeof(direction) == "Vector3" and target then
            args[3] = direction
            shot.direction = direction
            shot.target = target
            shot.cast = Silent.pairCast
        end
    end
    return original(self, name, table.unpack(args, 1, args.n))
end

function Silent.wrapCast(record, caster, ...)
    local original = record.original
    if not record.live or not App.alive then
        return original(caster, ...)
    end
    local shot = Silent.shot
    local now = os.clock()
    if not shot or shot.remaining <= 0 or now < shot.time or now - shot.time > 0.5 then
        return original(caster, ...)
    end
    local args = table.pack(...)
    local origin, direction, velocity, behavior = args[1], args[2], args[3], args[4]
    local matched = typeof(origin) == "Vector3" and typeof(direction) == "Vector3" and type(caster) == "table"
        and caster.RayHit ~= nil and caster.LengthChanged ~= nil and type(behavior) == "table"
    local actualSpeed = type(velocity) == "number" and math.abs(velocity) or typeof(velocity) == "Vector3" and velocity.Magnitude or nil
    if matched then
        local ok, distance = pcall(function() return (origin - shot.origin).Magnitude end)
        matched = ok and distance <= 4 and actualSpeed ~= nil and actualSpeed == actualSpeed and actualSpeed > 1 and actualSpeed < math.huge
        if matched and not shot.direction and shot.speed and shot.speed == shot.speed and shot.speed > 1 and shot.speed < math.huge then
            local current = type(shot.fire) == "table" and tonumber(shot.fire.fireSpeed) or nil
            local closeOriginal = math.abs(actualSpeed - shot.speed) <= math.max(0.05, shot.speed * 0.5)
            local closeCurrent = current and current == current and current > 1 and current < math.huge
                and math.abs(actualSpeed - current) <= math.max(0.05, current * 0.5)
            matched = closeOriginal or closeCurrent == true
        end
    end
    if matched and (not shot.direction or shot.cast == record) then
        Silent.speedTool = shot.tool
        Silent.speedFire = shot.fire
        Silent.liveSpeed = actualSpeed
        local acceleration = behavior.Acceleration
        Silent.liveAcceleration = typeof(acceleration) == "Vector3" and World.validPosition(acceleration) and acceleration or nil
        local maxDistance = tonumber(behavior.MaxDistance)
        Silent.liveMaxDistance = maxDistance and maxDistance == maxDistance and maxDistance > 0 and maxDistance < math.huge and maxDistance or nil
        if shot.direction and shot.cast == record then
            args[2] = shot.direction
            if typeof(velocity) == "Vector3" then args[3] = shot.direction * actualSpeed end
            shot.remaining -= 1
        elseif not shot.direction and settings.silentAim and shot.tool == Combat.tool and Silent.recordActive(shot.network) and Silent.recordActive(record) then
            Silent.pairNetwork = shot.network
            Silent.pairCast = record
            shot.remaining -= 1
        end
    end
    return original(caster, table.unpack(args, 1, args.n))
end

function Silent.installTable(target, kind)
    if type(target) ~= "table" or Silent.hooks[target] then
        return
    end
    local key = kind == "network" and "FireServer" or "Fire"
    local ok, original = pcall(rawget, target, key)
    if not ok or type(original) ~= "function" then
        return
    end
    local record = {target = target, key = key, original = original, kind = kind, live = true}
    if kind == "network" then
        record.dispatch = Silent.wrapNetwork
        record.wrapper = function(self, name, ...)
            local dispatch = record.dispatch
            if dispatch then
                return dispatch(record, self, name, ...)
            end
            return record.original(self, name, ...)
        end
    else
        record.dispatch = Silent.wrapCast
        record.wrapper = function(caster, ...)
            local dispatch = record.dispatch
            if dispatch then
                return dispatch(record, caster, ...)
            end
            return record.original(caster, ...)
        end
    end
    local wrote = pcall(function()
        target[key] = record.wrapper
    end)
    if wrote and rawget(target, key) == record.wrapper then
        Silent.hooks[target] = record
        table.insert(Silent.records, record)
    else
        record.live = false
        record.dispatch = nil
        record.target = nil
    end
end

function Silent.classify(target)
    if type(target) ~= "table" then
        return
    end
    local ok, kind = pcall(function()
        if rawget(target, "__type") == "FastCast" and rawget(target, "__index") == target and type(rawget(target, "newBehavior")) == "function" and type(rawget(target, "Fire")) == "function" then
            return "cast"
        end
        if type(rawget(target, "FireServer")) == "function" and type(rawget(target, "InvokeServer")) == "function" and type(rawget(target, "BindEvents")) == "function" and type(rawget(target, "BindFunctions")) == "function" then
            return "network"
        end
        return nil
    end)
    if ok and kind and (kind ~= "cast" or settings.silentAim) then
        Silent.installTable(target, kind)
    end
end

function Silent.scanGC()
    if type(getgc) ~= "function" or Silent.scanPending then
        return
    end
    Silent.scanPending = true
    Silent.scanCount = math.min(Silent.scanCount + 1, 6)
    local generation = Silent.generation
    task.spawn(function()
        local ok, objects = pcall(getgc, true)
        if ok and type(objects) == "table" then
            for index, object in ipairs(objects) do
                if not App.alive or not Combat.hooksWanted() or generation ~= Silent.generation then
                    break
                end
                Silent.classify(object)
                if index % 1500 == 0 then
                    task.wait()
                end
            end
        end
        if generation == Silent.generation then
            Silent.scanPending = false
        end
    end)
end

function Silent.tryInstall()
    if not App.alive or not Combat.hooksWanted() or not Combat.tool then
        return
    end
    if settings.silentAim and Silent.pairActive() then
        return
    end
    if not settings.silentAim and Combat.source == "live" then
        for _, record in ipairs(Silent.records) do
            if record.kind == "network" and Silent.recordActive(record) then
                return
            end
        end
    end
    local now = os.clock()
    if now < Silent.nextAttempt then
        return
    end
    Silent.nextAttempt = now + math.min(20, 2 + Silent.scanCount * 3)
    Silent.scanGC()
end

function Silent.describe()
    if not settings.silentAim then
        return "Off."
    end
    if not Combat.tool then
        return "Equip a weapon."
    end
    if Silent.pairActive() then
        return "Client shot and projectile are synchronized. The server checks damage."
    end
    local network, cast = false, false
    for _, record in ipairs(Silent.records) do
        if Silent.recordActive(record) then
            if record.kind == "network" then
                network = true
            else
                cast = true
            end
        end
    end
    if network and cast then
        return "Waiting for calibration: close the menu and fire once."
    end
    if type(getgc) ~= "function" then
        return "Silent Aim unavailable: this executor does not support getgc(true)."
    end
    if Silent.scanPending then
        return "Searching for game modules."
    end
    return "Game tables were not found or are protected."
end

function Silent.requestStop()
    Silent.target = nil
    Silent.stopRequestId = (Silent.stopRequestId or 0) + 1
    local request = Silent.stopRequestId
    if Combat.hooksWanted() then
        return
    end
    local shot = Silent.shot
    if shot and shot.direction and shot.remaining > 0 and os.clock() - shot.time <= 0.5 then
        local generation = Silent.generation
        task.delay(0.55, function()
            if App.alive and not Combat.hooksWanted() and generation == Silent.generation and request == Silent.stopRequestId then
                Silent.stop()
            end
        end)
        return
    end
    Silent.stop()
end

function Silent.stop()
    Silent.generation += 1
    Silent.scanPending = false
    Silent.resetCalibration()
    Silent.shot = nil
    for index = #Silent.records, 1, -1 do
        local record = Silent.records[index]
        record.live = false
        record.dispatch = nil
        local target = record.target
        local ok, current = pcall(rawget, target, record.key)
        if ok and current == record.wrapper then
            pcall(function()
                target[record.key] = record.original
            end)
        end
        record.target = nil
        record.wrapper = nil
    end
    table.clear(Silent.records)
    table.clear(Silent.hooks)
end

function Auto.deferToolRelease(tool)
    if Auto.pending[tool] then return end
    local pending = {tool = tool}
    Auto.pending[tool] = pending
    local connections = {}
    local finished = false
    local function cleanup()
        if finished then return end
        finished = true
        for _, connection in ipairs(connections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(connections)
        if tool and Auto.pending[tool] == pending then Auto.pending[tool] = nil end
        tool = nil
    end
    local function attempt()
        if finished or not tool then return end
        local ok, ready = pcall(function()
            local character = LocalPlayer.Character
            return character ~= nil and tool.Parent == character and tool.Enabled == true
        end)
        if ok and ready then
            local equipped = tool
            pcall(function() equipped:Deactivate() end)
            cleanup()
        end
    end
    local function watch(signal, callback)
        if not signal then return end
        local ok, connection = pcall(function() return signal:Connect(callback) end)
        if ok and connection then table.insert(connections, connection) end
    end
    local ok, changed = pcall(function() return tool:GetPropertyChangedSignal("Enabled") end)
    if ok then watch(changed, attempt) end
    ok, changed = pcall(function() return tool.AncestryChanged end)
    if ok then watch(changed, attempt) end
    ok, changed = pcall(function() return tool.Destroying end)
    if ok then watch(changed, cleanup) end
    task.delay(10, cleanup)
    attempt()
end

function Auto.release(evaluate)
    if not Auto.held then return end
    local kind, tool, release, shotCount = Auto.heldKind, Auto.heldTool, Auto.releaseInput, Auto.shotsAtPress
    Auto.held = false
    Auto.heldKind = nil
    Auto.heldTool = nil
    Auto.releaseInput = nil
    if kind == "tool" and tool then
        local ok, ready = pcall(function()
            local character = LocalPlayer.Character
            return character ~= nil and tool.Parent == character and tool.Enabled == true
        end)
        if ok and ready then
            pcall(function() tool:Deactivate() end)
        else
            Auto.deferToolRelease(tool)
        end
    elseif kind == "mouse" and type(release) == "function" then
        pcall(release)
    end
    if evaluate then
        local fired = Auto.shots ~= shotCount
        if fired then
            Auto.dryCycles = 0
        elseif Auto.autoShots > 0 then
            Auto.dryCycles += 1
        end
        if kind == "tool" then
            Auto.toolFailures = fired and 0 or Auto.toolFailures + 1
        elseif kind == "mouse" then
            Auto.mouseFailures = fired and 0 or Auto.mouseFailures + 1
            if Auto.mouseFailures >= 3 then Auto.nextPress = math.max(Auto.nextPress, os.clock() + 1) end
        end
    end
end

function Auto.reset()
    Auto.release(false)
    Auto.toolFailures = 0
    Auto.mouseFailures = 0
    Auto.mouseUnavailable = false
    Auto.autoShots = 0
    Auto.dryCycles = 0
    Auto.lastShotAt = nil
    Auto.nextPress = 0
    Auto.nextCheck = 0
end

function Auto.duration(config)
    local fire = type(config) == "table" and type(config.fire) == "table" and config.fire or {}
    local function number(value)
        value = tonumber(value)
        if not value or value ~= value or value < 0 or value == math.huge then return 0 end
        return math.min(value, 4)
    end
    return math.clamp(number(fire.fireDelay) + number(fire.boltDelay) + 0.15, 0.24, 5)
end

function Auto.start(tool, config, now)
    if Auto.pending[tool] then
        Auto.nextPress = now + 0.1
        return
    end
    local useMouse = Auto.toolFailures >= 2 and not Auto.mouseUnavailable and UserInputService.MouseEnabled
        and type(mouse1press) == "function" and type(mouse1release) == "function"
    if UserInputService.MouseEnabled then
        local ok, down = pcall(UserInputService.IsMouseButtonPressed, UserInputService, Enum.UserInputType.MouseButton1)
        if ok and down then
            Auto.nextPress = now + 0.15
            return
        end
    end
    local duration = Auto.duration(config)
    Auto.held = true
    Auto.heldKind = useMouse and "mouse" or "tool"
    Auto.heldTool = tool
    Auto.releaseInput = useMouse and mouse1release or nil
    Auto.shotsAtPress = Auto.shots
    Auto.releaseAt = now + duration
    Auto.nextPress = Auto.releaseAt + 0.06
    local ok, result
    if useMouse then
        ok, result = pcall(mouse1press)
    else
        ok, result = pcall(function() tool:Activate() end)
    end
    if not ok or result == false then
        Auto.release(false)
        if useMouse then
            Auto.mouseUnavailable = true
            Auto.toolFailures = 0
        else
            Auto.toolFailures += 1
        end
        Auto.nextPress = now + 0.5
    end
end

function Auto.step()
    local tool, config = Combat.tool, Combat.settings
    local character = LocalPlayer.Character
    if not App.alive or not settings.autoFire or not settings.silentAim or UI.open or not Auto.focused
        or not character or not tool or tool.Parent ~= character or not tool:IsA("Tool")
        or type(config) ~= "table" or Combat.source ~= "live" or not Silent.pairActive()
        or UserInputService:GetFocusedTextBox() then
        Auto.release(false)
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 or Motion.blocked(character) then
        Auto.release(false)
        return
    end
    local now = os.clock()
    if Reload.isReloading(tool, character) then
        Auto.release(false)
        return
    end
    if settings.autoReload then
        local magazine, _, guiReloading = Reload.read(tool, now)
        if guiReloading or magazine == 0 or now < Reload.pauseUntil then
            Auto.release(false)
            return
        end
    end
    if Auto.held and Auto.heldTool ~= tool then Auto.reset() end
    if tool.Enabled ~= true then
        if Auto.held and now > Auto.releaseAt + math.max(0.8, Auto.duration(config)) then Auto.release(false) end
        return
    end
    if Auto.held and now >= Auto.releaseAt then
        local fire = type(config.fire) == "table" and config.fire or {}
        local gap = tonumber(fire.fireDelay) or 0
        if gap ~= gap or gap < 0 or gap == math.huge then gap = 0 end
        local recentlyFired = Auto.lastShotAt and now - Auto.lastShotAt <= math.max(0.35, math.min(gap * 2 + 0.2, 5))
        if Auto.shots - Auto.shotsAtPress >= 2 and recentlyFired then
            Auto.releaseAt = now + 0.2
            Auto.nextPress = Auto.releaseAt + 0.06
        else
            Auto.release(true)
            Auto.nextPress = math.max(Auto.nextPress, now + 0.06)
        end
    end
    if now < Auto.nextCheck then return end
    Auto.nextCheck = now + 0.08
    local origin = Silent.muzzle(tool, config)
    if not origin then
        Auto.release(false)
        Auto.nextPress = now + 0.1
        return
    end
    local direction, target = Silent.choose(origin, config, true)
    if not direction or not target then
        Auto.release(false)
        Auto.nextPress = now + 0.1
        return
    end
    if not Auto.held and now >= Auto.nextPress then Auto.start(tool, config, now) end
end

function Input.tapKey(name, action)
    local key = Enum.KeyCode[name]
    if not key then return false end
    local isDown, down = pcall(UserInputService.IsKeyDown, UserInputService, key)
    if isDown and down then return false end
    local function pressButton()
        if type(firesignal) ~= "function" then return false end
        local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not gui then return false end
        local names = action == "Reload" and {reload = true, reloadbutton = true} or {bash = true, bashbutton = true, punch = true, punchbutton = true}
        for _, candidate in ipairs(gui:GetDescendants()) do
            if candidate:IsA("GuiButton") and not candidate:IsDescendantOf(screen) and not (UI.window and UI.window.Gui and candidate:IsDescendantOf(UI.window.Gui)) then
                local normalized = string.lower(candidate.Name):gsub("[^%w]", "")
                local node, visible = candidate, true
                while node and node ~= gui do
                    if node:IsA("GuiObject") and not node.Visible or node:IsA("ScreenGui") and not node.Enabled then visible = false break end
                    node = node.Parent
                end
                if visible and node == gui and names[normalized] then
                    local signals = {candidate.Activated, candidate.MouseButton1Click}
                    if type(getconnections) == "function" then
                        for _, signal in ipairs(signals) do
                            local ok, connections = pcall(getconnections, signal)
                            if ok and type(connections) == "table" and next(connections) and pcall(firesignal, signal) then return true end
                        end
                    else
                        local sent = false
                        for _, signal in ipairs(signals) do
                            if pcall(firesignal, signal) then sent = true end
                        end
                        if sent then return true end
                    end
                end
            end
        end
        return false
    end
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and pressButton() then return true end
    if type(keypress) == "function" and type(keyrelease) == "function" and #name == 1 then
        local code = string.byte(string.upper(name))
        if code >= 65 and code <= 90 then
            local sent, result = pcall(keypress, code)
            if sent and result ~= false then
                local release = keyrelease
                task.delay(0.06, function() pcall(release, code) end)
                return true
            end
        end
    end
    local serviceOk, virtual = pcall(game.GetService, game, "VirtualInputManager")
    if serviceOk and virtual then
        local sent = pcall(function() virtual:SendKeyEvent(true, key, false, game) end)
        if sent then
            task.delay(0.06, function() pcall(function() virtual:SendKeyEvent(false, key, false, game) end) end)
            return true
        end
    end
    return pressButton()
end

function Reload.reset()
    Reload.nextCheck, Reload.nextAttempt, Reload.pauseUntil = 0, 0, 0
    Reload.guiScanAt, Reload.guiCurrent, Reload.guiReserve, Reload.guiPair = 0, nil, nil, nil
    Reload.labels = setmetatable({}, {__mode = "k"})
    Reload.sampleAt, Reload.learned, Reload.startedAt = 0, nil, nil
    Reload.sawReloading = false
    Reload.lastTool, Reload.lastReadAt, Reload.lastCurrent, Reload.lastReserve, Reload.lastReloading = nil, nil, nil, nil, nil
    Reload.dryAttempts = 0
end

function Reload.number(value)
    if type(value) == "number" and value == value and value >= 0 and value <= 1000000 and value % 1 == 0 then return value end
    if type(value) == "string" and string.match(value, "^%s*%d+%s*$") then
        local number = tonumber(value)
        if number and number <= 1000000 then return number end
    end
    return nil
end

function Reload.findNumber(root, names)
    if not root then return nil end
    for _, name in ipairs(names) do
        local ok, value = pcall(root.GetAttribute, root, name)
        local number = ok and Reload.number(value) or nil
        if number ~= nil then return number end
        local child = root:FindFirstChild(name)
        if child and (child:IsA("IntValue") or child:IsA("NumberValue")) then
            number = Reload.number(child.Value)
            if number ~= nil then return number end
        end
    end
    return nil
end

function Reload.guiVisible(label)
    if not label or not label.Parent or not label:IsA("TextLabel") then return false end
    if label:IsDescendantOf(screen) or UI.window and UI.window.Gui and label:IsDescendantOf(UI.window.Gui) then return false end
    local node = label
    while node and node ~= playerGui do
        if node:IsA("GuiObject") and not node.Visible then return false end
        if node:IsA("ScreenGui") and not node.Enabled then return false end
        node = node.Parent
    end
    return node == playerGui
end

function Reload.weaponGui(tool)
    local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not gui or not tool or tool.Parent ~= LocalPlayer.Character then return nil, nil, false, false end
    local found
    for _, candidate in ipairs(gui:GetChildren()) do
        if candidate:IsA("ScreenGui") and candidate.Name == tool.Name then
            local data = candidate:FindFirstChild("Data")
            local clip = data and data:FindFirstChild("clip")
            local ammo = data and data:FindFirstChild("ammo")
            local gunName = data and data:FindFirstChild("gunName")
            if clip and ammo and gunName and gunName:IsA("TextLabel") and gunName.Text == tool.Name
                and Reload.guiVisible(clip) and Reload.guiVisible(ammo) then
                local magazine, reserve = Reload.number(clip.Text), Reload.number(ammo.Text)
                local reloading = type(clip.Text) == "string" and string.match(clip.Text, "^%s*%-%-%s*$") ~= nil
                if reserve ~= nil and (magazine ~= nil or reloading) then
                    if found then return nil, nil, false, false end
                    found = {magazine, reserve, reloading}
                end
            end
        end
    end
    if found then return found[1], found[2], true, found[3] end
    return nil, nil, false, false
end

function Reload.screenOf(label)
    local node = label
    while node and node ~= playerGui do
        if node:IsA("ScreenGui") then return node end
        node = node.Parent
    end
    return nil
end

function Reload.guiValues(label)
    if not Reload.guiVisible(label) or type(label.Text) ~= "string" then return nil, nil end
    local text = label.Text:gsub("<.->", ""):gsub("^%s*[Aa][Mm][Mm][Oo]%s*:%s*", "")
    local magazine, reserve = string.match(text, "^%s*(%d+)%s*[/|]%s*(%d+)%s*$")
    if magazine then return Reload.number(magazine), Reload.number(reserve) end
    return Reload.number(text), nil
end

function Reload.guiPairValues(label)
    return Reload.guiValues(label)
end

function Reload.scanGui(now)
    if now < Reload.guiScanAt then return end
    Reload.guiScanAt = now + 1.5
    Reload.guiCurrent, Reload.guiReserve, Reload.guiPair = nil, nil, nil
    local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not gui then return end
    local old = Reload.labels or {}
    local labels = setmetatable({}, {__mode = "k"})
    local currents, reserves, pairsFound = {}, {}, {}
    local count = 0
    for _, item in ipairs(gui:GetDescendants()) do
        if count < 220 and item:IsA("TextLabel") and Reload.guiVisible(item) then
            local magazine, reserve = Reload.guiValues(item)
            if magazine ~= nil and magazine <= 10000 then
                count += 1
                labels[item] = old[item] or {value = magazine, serial = Auto.shots, valueAt = now, score = 0, changes = 0}
                local name = string.lower(item.Name):gsub("[^%w]", "")
                if (name == "ammoandreserve" or name == "magazinereserve" or name == "clipandreserve" or name == "ammo" or name == "ammocount" or name == "ammotext") and reserve ~= nil then
                    table.insert(pairsFound, item)
                elseif name == "currentammo" or name == "ammoinmag" or name == "clipammo" or name == "magammo" or name == "currentmag" or name == "currentclip" or name == "magazineammo" then
                    if reserve ~= nil then table.insert(pairsFound, item) else table.insert(currents, item) end
                elseif name == "reserveammo" or name == "ammoreserve" or name == "spareammo" or name == "ammoinreserve" or name == "reserve" then
                    table.insert(reserves, item)
                end
            end
        end
    end
    Reload.labels = labels
    if Reload.learned and not labels[Reload.learned] then Reload.learned = nil end
    if #pairsFound == 1 then Reload.guiPair = pairsFound[1] end
    local current, reserve, matches = nil, nil, 0
    for _, first in ipairs(currents) do
        local firstScreen = Reload.screenOf(first)
        for _, second in ipairs(reserves) do
            if firstScreen and firstScreen == Reload.screenOf(second) then
                current, reserve, matches = first, second, matches + 1
            end
        end
    end
    if matches == 1 then Reload.guiCurrent, Reload.guiReserve = current, reserve end
end

function Reload.sampleGui(now)
    if now < (Reload.sampleAt or 0) then return end
    Reload.sampleAt = now + 0.08
    local best, bestScore = nil, 1
    for label, state in pairs(Reload.labels or {}) do
        local current = Reload.guiValues(label)
        if current == nil then
            if Reload.learned == label and not Reload.guiVisible(label) then Reload.learned = nil end
        elseif current ~= state.value then
            local decrease = state.value - current
            local shots = Auto.shots - state.serial
            if decrease > 0 and shots > 0 and math.abs(decrease - shots) <= 1 and Auto.lastShotAt and now - Auto.lastShotAt <= 1.5 then
                state.score = math.min(20, state.score + math.min(decrease, 3))
                state.changes += 1
            elseif current > state.value then
                state.score = math.max(0, state.score - 1)
            else
                state.score = math.max(0, state.score - 2)
            end
            state.value, state.serial, state.valueAt = current, Auto.shots, now
        elseif now - state.valueAt > 1.5 then
            state.serial, state.valueAt = Auto.shots, now
        end
        if state.score >= 2 and state.changes >= 2 and state.score > bestScore then
            best, bestScore = label, state.score
        end
    end
    if best then Reload.learned = best end
end

function Reload.cache(tool, now, current, reserve, reloading)
    Reload.lastTool, Reload.lastReadAt = tool, now
    Reload.lastCurrent, Reload.lastReserve, Reload.lastReloading = current, reserve, reloading == true
    return current, reserve, Reload.lastReloading
end

function Reload.read(tool, now)
    if not tool or tool.Parent ~= LocalPlayer.Character then return nil, nil, false end
    if Reload.lastTool == tool and Reload.lastReadAt and now >= Reload.lastReadAt and now - Reload.lastReadAt < 0.04 then
        return Reload.lastCurrent, Reload.lastReserve, Reload.lastReloading
    end
    local magazine, spare, matched, reloading = Reload.weaponGui(tool)
    if matched then return Reload.cache(tool, now, magazine, spare, reloading) end
    local roots = {tool}
    for _, name in ipairs(Reload.stateNames) do
        local root = tool:FindFirstChild(name)
        if root then table.insert(roots, root) end
    end
    local current, reserve
    for _, root in ipairs(roots) do
        current = current ~= nil and current or Reload.findNumber(root, Reload.currentNames)
        reserve = reserve ~= nil and reserve or Reload.findNumber(root, Reload.reserveNames)
    end
    if current == nil and reserve ~= nil then
        for _, root in ipairs(roots) do
            current = Reload.findNumber(root, Reload.ambiguousNames)
            if current ~= nil then break end
        end
    end
    if current ~= nil then return Reload.cache(tool, now, current, reserve) end
    Reload.scanGui(now)
    Reload.sampleGui(now)
    if Reload.learned and Reload.guiVisible(Reload.learned) then
        local magazine, spare = Reload.guiValues(Reload.learned)
        if magazine ~= nil then return Reload.cache(tool, now, magazine, spare) end
    end
    if Reload.guiPair then
        local magazine, spare = Reload.guiPairValues(Reload.guiPair)
        if magazine ~= nil and spare ~= nil then return Reload.cache(tool, now, magazine, spare) end
    end
    if Reload.guiVisible(Reload.guiCurrent) and Reload.guiVisible(Reload.guiReserve) and Reload.screenOf(Reload.guiCurrent) == Reload.screenOf(Reload.guiReserve) then
        return Reload.cache(tool, now, Reload.number(Reload.guiCurrent.Text), Reload.number(Reload.guiReserve.Text))
    end
    return Reload.cache(tool, now, nil, nil)
end

function Reload.isReloading(tool, character)
    for _, root in ipairs({tool, character}) do
        if root then
            for _, name in ipairs({"Reloading", "IsReloading", "isReloading"}) do
                if root:GetAttribute(name) == true then return true end
                local state = root:FindFirstChild(name)
                if state and state:IsA("BoolValue") and state.Value == true then return true end
            end
        end
    end
    return false
end

function Reload.duration(config)
    if type(config) ~= "table" then return 8.5 end
    local reload = type(config.reload) == "table" and config.reload or {}
    local fire = type(config.fire) == "table" and config.fire or {}
    local value = tonumber(reload.duration or reload.reloadTime or reload.time or config.reloadTime or fire.reloadTime)
    if not value or value ~= value or value <= 0 or value == math.huge then return 8.5 end
    return math.clamp(value + 0.6, 1, 12)
end

function Reload.step()
    local now = os.clock()
    if now < Reload.nextCheck then return end
    Reload.nextCheck = now + 0.1
    if not App.alive or not settings.autoReload or UI.open or not Auto.focused or UserInputService:GetFocusedTextBox() then return end
    local tool, character = Combat.tool, LocalPlayer.Character
    local camera = Workspace.CurrentCamera
    if not character or not tool or tool.Parent ~= character or not tool:IsA("Tool") or not camera or camera.CameraType == Enum.CameraType.Scriptable then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 or Motion.blocked(character) then return end
    local magazine, reserve, guiReloading = Reload.read(tool, now)
    local reloading = guiReloading or Reload.isReloading(tool, character)
    if Reload.startedAt then
        if reloading then
            Reload.sawReloading = true
            Reload.pauseUntil = math.max(Reload.pauseUntil, now + 0.25)
        elseif Reload.sawReloading or magazine and magazine > 0 and now >= Reload.startedAt + 0.6 then
            Reload.pauseUntil, Reload.startedAt = 0, nil
            Reload.sawReloading = false
            Reload.dryAttempts = 0
            Auto.dryCycles = 0
        elseif now >= Reload.pauseUntil then
            Reload.startedAt = nil
        end
    end
    if reloading or now < Reload.pauseUntil or now < Reload.nextAttempt or tool.Enabled ~= true then return end
    local empty = magazine == 0 and (reserve == nil or reserve > 0)
    local dry = false
    if magazine ~= 0 and (reserve == nil or reserve > 0) and settings.autoFire and Auto.autoShots > 0 and Auto.dryCycles >= 3 and Auto.lastShotAt and Reload.dryAttempts < 2 then
        local waitTime = math.max(1.5, Auto.duration(Combat.settings) * 2.5)
        local mouseAvailable = UserInputService.MouseEnabled and not Auto.mouseUnavailable and type(mouse1press) == "function" and type(mouse1release) == "function"
        dry = now - Auto.lastShotAt >= waitTime and (not mouseAvailable or Auto.toolFailures < 2 or Auto.mouseFailures >= 2)
    end
    if not empty and not dry then return end
    Auto.release(false)
    if Input.tapKey(settings.reloadKey, "Reload") then
        Reload.startedAt = now
        Reload.sawReloading = false
        Reload.pauseUntil = now + Reload.duration(Combat.settings)
        Reload.nextAttempt = Reload.pauseUntil + 1
        if dry then Reload.dryAttempts += 1 end
    else
        Reload.nextAttempt = now + 2
    end
end

function Punch.immune(model)
    if model:GetAttribute("BashImmune") == true or model:GetAttribute("BashImmunity") == true then return true end
    local name = string.lower(model.Name)
    for _, term in ipairs({"chimera", "gilbert", "mikhail", "sinitzyn", "sinitsyn", "dave"}) do
        if string.find(name, term, 1, true) then return true end
    end
    return false
end

function Punch.step()
    local now = os.clock()
    if now < Punch.nextCheck then return end
    Punch.nextCheck = now + 0.05
    if not App.alive or not settings.autoPunch or UI.open or not Auto.focused or UserInputService:GetFocusedTextBox() or now < Punch.nextAttempt then return end
    local character, humanoid, root = Motion.resolve()
    local tool = Combat.tool
    local camera = Workspace.CurrentCamera
    if not character or not humanoid or humanoid.Health <= 0 or not root or Motion.blocked(character) or not tool or tool.Parent ~= character or not camera or camera.CameraType == Enum.CameraType.Scriptable then return end
    local characters = Workspace:FindFirstChild("Characters")
    if not characters then return end
    local look = camera.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    if flatLook.Magnitude < 0.05 then return end
    flatLook = flatLook.Unit
    local best, closest = nil, settings.punchRange * settings.punchRange
    for _, model in ipairs(characters:GetChildren()) do
        if World.isZombie(model) and not Punch.immune(model) then
            local part = model:FindFirstChild("HumanoidRootPart") or World.characterPart(model)
            if part and part:IsA("BasePart") then
                local offset = part.Position - root.Position
                local flat = Vector3.new(offset.X, 0, offset.Z)
                local squared = offset:Dot(offset)
                local relative = part.AssemblyLinearVelocity - root.AssemblyLinearVelocity
                if not World.validPosition(relative) then relative = Vector3.zero end
                local predicted = offset + relative * 0.12
                if squared <= closest and math.abs(offset.Y) <= 5 and flat.Magnitude > 0.01
                    and flatLook:Dot(flat.Unit) >= 0.7 and predicted.Magnitude <= settings.punchRange + 0.5
                    and World.visible(root.Position, part.Position, model) then
                    best, closest = model, squared
                end
            end
        end
    end
    if best then
        if Input.tapKey(settings.punchKey, "Punch") then
            Punch.nextAttempt = now + 5.05
        else
            Punch.nextAttempt = now + 0.5
        end
    end
end

function World.promptShown(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return
    end
    World.shownPrompts[prompt] = true
    if settings.instantPrompt then
        Guard.set("prompt", prompt, "HoldDuration", 0, false)
    end
end

function World.promptHidden(prompt)
    World.shownPrompts[prompt] = nil
    Guard.clearObject("prompt", prompt)
end

function World.updatePrompts()
    for prompt in pairs(World.shownPrompts) do
        if not prompt.Parent then
            World.shownPrompts[prompt] = nil
            Guard.clearObject("prompt", prompt)
        elseif settings.instantPrompt then
            Guard.set("prompt", prompt, "HoldDuration", 0, false)
        end
    end
    if not settings.instantPrompt then
        Guard.clear("prompt")
    end
end

function App.set(key, value)
    if not App.alive then
        return false
    end
    local cleaned = App.validValue(key, value)
    if cleaned == nil then
        return false
    end
    if settings[key] == cleaned then
        UI.refreshControls()
        return true
    end
    settings[key] = cleaned
    if key == "autoFire" and cleaned and not settings.silentAim then
        App.set("silentAim", true)
    elseif key == "silentAim" and not cleaned and settings.autoFire then
        App.set("autoFire", false)
    end
    if key == "fpsBoost" or key == "superFpsBoost" then
        local mode = settings.superFpsBoost and 2 or settings.fpsBoost and 1 or 0
        Optimizer.setMode(mode)
    end
    if key == "stamina" and cleaned and not Motion.staminaAvailable() then
        App.notice("Stamina: this client mode is not supported")
    end
    if key == "speedEnabled" and not cleaned then
        Guard.clear("speed")
    elseif key == "stamina" and not cleaned then
        Guard.clear("stamina")
    elseif key == "antiStagger" and not cleaned then
        Guard.clear("stagger")
    elseif key == "noSlow" and not cleaned then
        Guard.clear("slow")
    elseif key == "fastReload" and not cleaned then
        Guard.clear("reload")
    elseif key == "noclip" and not cleaned then
        Guard.clear("noclip")
        Motion.disconnectCharacter()
        table.clear(Motion.parts)
    elseif key == "noclip" and cleaned then
        Motion.resolve()
        Motion.watchParts()
    elseif key == "silentAim" and not cleaned then
        Auto.release(false)
        Silent.requestStop()
    elseif key == "silentAim" and cleaned then
        Silent.scanCount = 0
        Silent.nextAttempt = 0
    elseif key == "autoFire" then
        Auto.reset()
    elseif key == "autoReload" and not cleaned then
        Reload.reset()
    elseif key == "fullbright" and not cleaned then
        Guard.clear("light")
    elseif key == "noFog" and not cleaned then
        Guard.clear("fog")
    elseif key == "fovEnabled" and not cleaned then
        Guard.clear("fov")
    elseif key == "instantPrompt" then
        World.updatePrompts()
    end
    if key == "noRecoil" then
        Combat.applyPatches()
        Combat.update()
        if not Combat.hooksWanted() then Silent.requestStop() end
    elseif key == "silentAim" or key == "autoReload" or key == "autoPunch" then
        Combat.update()
        if not Combat.hooksWanted() then Silent.requestStop() end
    end
    if (key == "speedEnabled" or key == "stamina" or key == "antiStagger" or key == "noSlow" or key == "fastReload") and cleaned or key == "speed" and settings.speedEnabled or (key == "felsiReload" or key == "squadReload") and settings.fastReload then
        Motion.updateProperties()
    end
    if key == "targetPart" or key == "aimMode" or key == "aimRadius" or key == "wallCheck" then
        Silent.target = nil
        Silent.nextTargetScan = 0
    end
    if key == "espPlayers" or key == "espAllies" or key == "espNPC" or key == "espBoss" or key == "mobBoxes" or key == "mobSkeletons" or key == "bossBoxes" or key == "bossSkeletons" or key == "mobColor" or key == "bossColor" or key == "espObjectives" or key == "espPickups" then
        local ok = pcall(Visual.update)
        if not ok then
            App.notice("ESP: update failed")
        end
    end
    UI.refreshControls()
    Save.schedule()
    return true
end

function App.reset()
    for key, value in pairs(defaults) do
        App.set(key, value)
    end
    App.notice("Settings reset; features disabled")
end

function UI.addToggle(group, key, title)
    local view = group:Toggle({
        Name = title,
        Flag = "HR_" .. key,
        Default = settings[key],
        Callback = function(value)
            App.set(key, value)
        end,
    })
    UI.toggleViews[key] = view
    return view
end

function UI.addSlider(group, key, title, suffix)
    local range = numeric[key]
    local view = group:Slider({
        Name = title,
        Flag = "HR_" .. key,
        Min = range[1],
        Max = range[2],
        Increment = 1,
        Default = settings[key],
        Suffix = suffix or "",
        Callback = function(value)
            App.set(key, value)
        end,
    })
    UI.numberViews[key] = view
    return view
end

function UI.addChoice(group, key, title)
    local view = group:Dropdown({
        Name = title,
        Flag = "HR_" .. key,
        Options = choices[key],
        Default = settings[key],
        Callback = function(value) App.set(key, value) end,
    })
    UI.choiceViews[key] = view
    return view
end

function UI.addColor(group, key, title)
    local view = group:ColorPicker({
        Name = title,
        Flag = "HR_" .. key,
        Default = UI.color(settings[key]),
        Callback = function(value)
            local packed = UI.packColor(value)
            if packed then App.set(key, packed) end
        end,
    })
    UI.colorViews[key] = view
    return view
end

function UI.build()
    local library = buildIxaLibrary()
    assert(type(library) == "table" and type(library.CreateWindow) == "function", "Airflow library is unavailable")
    UI.library = library
    local sakura = library.ThemePresets and library.ThemePresets.Sakura
    if sakura then
        library.ThemeName = "Sakura"
        if type(library.SetDefaultTheme) == "function" then
            library:SetDefaultTheme(sakura)
        end
    end
    local window = library:CreateWindow({
        Name = "Ixa Hub test HALLOWED REACTOR",
        Title = "Ixa Hub test",
        LoadingSubtitle = "HALLOWED REACTOR",
        ToggleUIKeybind = "K",
        Parent = guiHost,
        AttachGui = function(gui)
            local parent = UI.attach(gui, guiHost, true)
            if not parent then return false end
            if parent ~= guiHost then
                guiHost = parent
                UI.attach(screen, guiHost, true)
            end
            return true
        end,
        OpenButton = false,
        ToggleButton = {Platform = "Both"},
        Size = UDim2.fromOffset(780, 560),
        Backdrop = {Weather = "None", Mode = "Screen", Tint = 0.35, Dim = true, Density = 0.6},
        Transparent = true,
        Background = "Lavender Pink",
        CornerRadius = 10,
        UIScale = 1,
        AdaptiveSize = false,
        Theme = sakura,
        ConfigurationSaving = {Enabled = true, FolderName = "IxaHub_HALLOWED_REACTOR"},
        Home = {
            Name = "Home",
            Title = "Ixa Hub",
            Welcome = "Welcome back,",
            Tier = "v2",
            Stats = {"Players", "Session", "FPS", "Ping", "Game", "Executor"},
        },
        Loading = false,
        UnsupportedExecutor = false,
    })
    assert(window and window.Gui and type(window.CreateTab) == "function", "Ixa window was not created")
    UI.window = window
    local applyFlags = window._applyFlags
    if type(applyFlags) == "function" then
        window._applyFlags = function(self, entries, silent)
            if type(entries) ~= "table" then
                return applyFlags(self, entries, silent)
            end
            local migrated = {}
            for flag, entry in pairs(entries) do
                if type(flag) ~= "string" or string.sub(flag, 1, 3) ~= "HR_" or library.Flags[flag] ~= nil then
                    migrated[flag] = entry
                end
            end
            if migrated.HR_targetPart == nil then
                local previous = entries.HR_silentHead or entries.HR_aimHead
                if type(previous) == "table" and type(previous.Value) == "boolean" then
                    migrated.HR_targetPart = {Type = "Dropdown", Value = previous.Value and "Head" or "Body"}
                end
            end
            local automatic = migrated.HR_autoFire
            if type(automatic) == "table" and (automatic.Type == nil or automatic.Type == "Toggle") and automatic.Value == true then
                migrated.HR_silentAim = {Type = "Toggle", Value = true}
            end
            return applyFlags(self, migrated, silent)
        end
    end
    window.Gui.DisplayOrder = 10001

    local modal = Instance.new("TextButton")
    modal.Name = "HallowedReactorMenuModal"
    modal.Text = ""
    modal.Size = UDim2.fromOffset(1, 1)
    modal.Position = UDim2.fromOffset(0, 0)
    modal.BackgroundTransparency = 1
    modal.AutoButtonColor = false
    modal.Active = false
    modal.Modal = true
    modal.Visible = true
    modal.Parent = window.Gui
    UI.modal = modal

    for _, methodName in ipairs({"Toggle", "Minimize", "Restore"}) do
        local native = window[methodName]
        if type(native) == "function" then
            window[methodName] = function(self, ...)
                local results = table.pack(native(self, ...))
                if App.alive then
                    UI.syncVisibility()
                end
                return table.unpack(results, 1, results.n)
            end
        end
    end
    local nativeDestroy = window.Destroy
    if type(nativeDestroy) == "function" then
        window.Destroy = function(self, ...)
            if App.alive and type(App.stop) == "function" then
                App.stop()
                if self._destroyed then
                    return
                end
            end
            return nativeDestroy(self, ...)
        end
        window.Unload = window.Destroy
    end

    local aimPage = window:CreateTab({Name = "Aim", Icon = "crosshair"})
    local combatPage = window:CreateTab({Name = "Combat", Icon = "swords"})
    local visualsPage = window:CreateTab({Name = "Visuals", Icon = "eye"})
    local miscPage = window:CreateTab({Name = "Misc", Icon = "settings"})
    local settingsPage = window:CreateTab({Name = "Settings", Icon = "sliders-horizontal"})

    local aim = aimPage:CreateGroupbox({Name = "Silent Aim", Side = "Left"})
    UI.addToggle(aim, "silentAim", "Silent Aim")
    UI.addToggle(aim, "autoFire", "Smart Auto Fire")
    UI.addChoice(aim, "targetPart", "Target Part")
    UI.addToggle(aim, "wallCheck", "Wall Check")
    UI.addChoice(aim, "aimMode", "FOV Mode")
    UI.addToggle(aim, "showAimFov", "Show FOV")
    UI.addSlider(aim, "aimRadius", "FOV Radius")
    UI.addColor(aim, "aimColor", "FOV Color")

    local weapons = combatPage:CreateGroupbox({Name = "Weapons", Side = "Left"})
    UI.addToggle(weapons, "noRecoil", "No Recoil")
    UI.addToggle(weapons, "autoReload", "Auto Reload")
    UI.addChoice(weapons, "reloadKey", "Reload Key")
    UI.addToggle(weapons, "fastReload", "Fast Reload")
    UI.addSlider(weapons, "felsiReload", "Felsi Reload Speed", "%")
    UI.addSlider(weapons, "squadReload", "Squad Reload Speed", "%")
    local melee = combatPage:CreateGroupbox({Name = "Melee", Side = "Right"})
    UI.addToggle(melee, "autoPunch", "Auto Punch")
    UI.addSlider(melee, "punchRange", "Auto Punch Range")
    UI.addChoice(melee, "punchKey", "Punch Key")

    local esp = visualsPage:CreateGroupbox({Name = "ESP", Side = "Left"})
    UI.addToggle(esp, "espPlayers", "Player ESP")
    UI.addToggle(esp, "espAllies", "Ally ESP")
    UI.addToggle(esp, "espNPC", "Mob ESP")
    UI.addToggle(esp, "mobBoxes", "Mob Boxes")
    UI.addToggle(esp, "mobSkeletons", "Mob Skeletons")
    UI.addColor(esp, "mobColor", "Mob Color")
    UI.addToggle(esp, "espBoss", "Boss ESP")
    UI.addToggle(esp, "bossBoxes", "Boss Boxes")
    UI.addToggle(esp, "bossSkeletons", "Boss Skeletons")
    UI.addColor(esp, "bossColor", "Boss Color")
    UI.addToggle(esp, "espObjectives", "Objective ESP")
    UI.addToggle(esp, "espPickups", "Pickup ESP")
    UI.addSlider(esp, "espDistance", "ESP Distance")
    local visual = visualsPage:CreateGroupbox({Name = "Display and Lighting", Side = "Right"})
    UI.addToggle(visual, "fullbright", "Fullbright")
    UI.addToggle(visual, "noFog", "Remove Fog")
    UI.addToggle(visual, "fovEnabled", "Change FOV")
    UI.addSlider(visual, "fov", "Field of View")
    UI.addToggle(visual, "crosshair", "Center Crosshair")
    UI.addToggle(visual, "fps", "Show FPS")
    local trackers = visualsPage:CreateGroupbox({Name = "Trackers", Side = "Right"})
    UI.addToggle(trackers, "eventTracker", "Post-Game Event Tracker")
    UI.addToggle(trackers, "threatTracker", "Nearby Threat Tracker")
    UI.addSlider(trackers, "threatRange", "Threat Range")

    local move = miscPage:CreateGroupbox({Name = "Movement", Side = "Left"})
    UI.addToggle(move, "speedEnabled", "Speed")
    UI.addSlider(move, "speed", "Walk Speed")
    UI.addToggle(move, "stamina", "Infinite Stamina")
    UI.addToggle(move, "antiStagger", "Anti Stagger")
    UI.addToggle(move, "noSlow", "No Slow")
    UI.addToggle(move, "noclip", "Noclip")
    local world = miscPage:CreateGroupbox({Name = "World and Teleports", Side = "Right"})
    UI.addToggle(world, "instantPrompt", "Instant Interactions")
    world:Button({Name = "Teleport to Nearest Objective", Callback = World.teleportNearestObjective})
    world:Button({Name = "Teleport to Nearest Pickup", Callback = World.teleportNearestPickup})
    world:Button({Name = "Save Current Position", Callback = World.savePosition})
    world:Button({Name = "Return to Saved Position", Callback = World.returnPosition})
    local performance = miscPage:CreateGroupbox({Name = "Performance", Side = "Right"})
    UI.addToggle(performance, "fpsBoost", "FPS Optimization")
    UI.addToggle(performance, "superFpsBoost", "Super FPS Optimization")

    local general = settingsPage:CreateGroupbox({Name = "Controls", Side = "Left"})
    general:Button({Name = "Reset Settings and Disable Features", Callback = App.reset})
    general:Button({Name = "Hide Menu", Callback = function() UI.setOpen(false) end})
    general:Button({Name = "Unload and Restore Changes", Style = "Danger", Callback = function() App.stop() end})
    settingsPage:CreateConfigManager({Name = "Configs", Side = "Left"})
    settingsPage:CreateThemeManager({Name = "Theme", Side = "Right"})
    UI.syncVisibility()
end

function Promo.after(seconds, callback)
    local generation = Promo.generation
    local thread
    thread = task.delay(seconds, function()
        if thread then Promo.timers[thread] = nil end
        if not App.alive or generation ~= Promo.generation then return end
        local ok, message = pcall(callback)
        if not ok then warn("[HallowedReactorHub] Discord banner: " .. tostring(message)) end
    end)
    if thread then Promo.timers[thread] = true end
    return thread
end

function Promo.disconnect()
    for _, connection in ipairs(Promo.connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(Promo.connections)
end

function Promo.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Promo.connections, connection)
end

function Promo.holder()
    if Promo.gui and Promo.gui.Parent then return Promo.gui end
    if Promo.gui then pcall(function() Promo.gui:Destroy() end) end
    Promo.gui = nil
    local preferred = UI.window and UI.window.Gui and UI.window.Gui.Parent or screen.Parent or guiHost
    for _, parent in ipairs(UI.guiParents(preferred)) do
        local ok, children = pcall(function() return parent:GetChildren() end)
        if ok and type(children) == "table" then
            for _, child in ipairs(children) do
                if child:IsA("ScreenGui") and child.Name == "HallowedReactorDiscordPromo" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    local gui = Instance.new("ScreenGui")
    gui.Name = "HallowedReactorDiscordPromo"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = (UI.window and UI.window.Gui and UI.window.Gui.DisplayOrder or 10001) + 1
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if not UI.attach(gui, preferred) then
        pcall(function() gui:Destroy() end)
        return nil
    end
    Promo.gui = gui
    return gui
end

function Promo.copy()
    local function tryCopy(fn)
        if type(fn) ~= "function" then return false end
        local ok, result = pcall(fn, Promo.invite)
        return ok and result ~= false
    end
    if tryCopy(setclipboard) then return true end
    if toclipboard ~= setclipboard and tryCopy(toclipboard) then return true end
    local synCopy = type(syn) == "table" and syn.setclipboard or nil
    if synCopy ~= setclipboard and synCopy ~= toclipboard and tryCopy(synCopy) then return true end
    return false
end

function Promo.refresh()
    local parts = Promo.parts
    if not parts or not Promo.frame or not Promo.frame.Parent then return end
    if Promo.copied then
        parts.copy.Text = "Done"
        parts.hint.Text = "Link copied: " .. Promo.invite
        parts.hint.TextColor3 = Color3.fromRGB(170, 226, 178)
    elseif Promo.copyFailed then
        parts.copy.Text = "Copy"
        parts.hint.Text = "Copy it manually: " .. Promo.invite
        parts.hint.TextColor3 = Color3.fromRGB(232, 200, 140)
    else
        parts.copy.Text = "Copy"
        parts.hint.Text = "Updates, scripts and support live there"
        parts.hint.TextColor3 = Color3.fromRGB(170, 162, 175)
    end
end

function Promo.animate(instance, duration, style, direction, properties)
    pcall(function()
        local tween = game:GetService("TweenService"):Create(instance, TweenInfo.new(duration, style, direction), properties)
        tween:Play()
    end)
end

function Promo.hide(animate, expected)
    if expected and expected ~= Promo.token then return end
    local toast, parts = Promo.frame, Promo.parts
    if not toast then return end
    Promo.token += 1
    Promo.frame, Promo.parts = nil, nil
    Promo.disconnect()
    if animate and toast.Parent then
        if parts and parts.scale then
            Promo.animate(parts.scale, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {Scale = 0.9})
        end
        Promo.animate(toast, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, -6),
        })
        Promo.after(0.24, function()
            pcall(function() if toast.Parent then toast:Destroy() end end)
        end)
    else
        pcall(function() toast:Destroy() end)
    end
end

function Promo.build(gui)
    local toast = Instance.new("Frame")
    Promo.frame = toast
    toast.Name = "DiscordPromo"
    toast.AnchorPoint = Vector2.new(0.5, 0)
    toast.Position = UDim2.new(0.5, 0, 0, 14)
    toast.Size = UDim2.new(1, -24, 0, 0)
    toast.AutomaticSize = Enum.AutomaticSize.Y
    toast.BackgroundColor3 = Color3.fromRGB(27, 21, 30)
    toast.BackgroundTransparency = 0.04
    toast.BorderSizePixel = 0
    toast.ZIndex = 100
    toast.Parent = gui
    local constraint = Instance.new("UISizeConstraint")
    constraint.MaxSize = Vector2.new(382, 1000)
    constraint.Parent = toast
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toast
    local scale = Instance.new("UIScale")
    scale.Scale = 0.95
    scale.Parent = toast
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(232, 164, 205)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = toast
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = toast
    local list = Instance.new("UIListLayout")
    list.FillDirection = Enum.FillDirection.Vertical
    list.HorizontalAlignment = Enum.HorizontalAlignment.Left
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 8)
    list.Parent = toast
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 22)
    header.LayoutOrder = 1
    header.Parent = toast
    local badge = Instance.new("TextLabel")
    badge.Name = "Badge"
    badge.AnchorPoint = Vector2.new(0, 0.5)
    badge.Position = UDim2.new(0, 0, 0.5, 0)
    badge.Size = UDim2.fromOffset(62, 18)
    badge.BackgroundColor3 = Color3.fromRGB(232, 164, 205)
    badge.BackgroundTransparency = 0.82
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 9
    badge.TextColor3 = Color3.fromRGB(246, 218, 234)
    badge.Text = "DISCORD"
    badge.Parent = header
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 5)
    badgeCorner.Parent = badge
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(72, 0)
    title.Size = UDim2.new(1, -98, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.TextColor3 = Color3.fromRGB(242, 236, 244)
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Text = "Subscribe to our Discord"
    title.Parent = header
    local close = Instance.new("TextButton")
    close.Name = "Close"
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, 0, 0.5, 0)
    close.Size = UDim2.fromOffset(20, 20)
    close.BackgroundTransparency = 1
    close.Font = Enum.Font.GothamBold
    close.TextSize = 17
    close.TextColor3 = Color3.fromRGB(150, 140, 152)
    close.Text = "\u{d7}"
    close.AutoButtonColor = false
    close.ZIndex = 101
    close.Parent = header
    local hint = Instance.new("TextLabel")
    hint.Name = "Hint"
    hint.BackgroundTransparency = 1
    hint.Size = UDim2.new(1, 0, 0, 16)
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 12
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.TextColor3 = Color3.fromRGB(170, 162, 175)
    hint.TextTruncate = Enum.TextTruncate.AtEnd
    hint.Text = "Updates, scripts and support live there"
    hint.LayoutOrder = 2
    hint.Parent = toast
    local row = Instance.new("Frame")
    row.Name = "Actions"
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 32)
    row.LayoutOrder = 3
    row.Parent = toast
    local link = Instance.new("TextButton")
    link.Name = "Invite"
    link.Size = UDim2.new(1, -88, 1, 0)
    link.BackgroundColor3 = Color3.fromRGB(43, 33, 45)
    link.BackgroundTransparency = 0.15
    link.AutoButtonColor = false
    link.Font = Enum.Font.GothamMedium
    link.TextSize = 12
    link.TextColor3 = Color3.fromRGB(232, 180, 210)
    link.TextXAlignment = Enum.TextXAlignment.Left
    link.TextYAlignment = Enum.TextYAlignment.Center
    link.TextTruncate = Enum.TextTruncate.AtEnd
    link.Text = Promo.invite
    link.ClipsDescendants = true
    link.Parent = row
    local linkPadding = Instance.new("UIPadding")
    linkPadding.PaddingLeft = UDim.new(0, 10)
    linkPadding.PaddingRight = UDim.new(0, 10)
    linkPadding.Parent = link
    local linkCorner = Instance.new("UICorner")
    linkCorner.CornerRadius = UDim.new(0, 8)
    linkCorner.Parent = link
    local copy = Instance.new("TextButton")
    copy.Name = "Copy"
    copy.AnchorPoint = Vector2.new(1, 0)
    copy.Position = UDim2.new(1, 0, 0, 0)
    copy.Size = UDim2.fromOffset(80, 32)
    copy.BackgroundColor3 = Color3.fromRGB(232, 164, 205)
    copy.AutoButtonColor = false
    copy.Font = Enum.Font.GothamBold
    copy.TextSize = 12
    copy.TextColor3 = Color3.fromRGB(32, 24, 32)
    copy.Text = "Copy"
    copy.Parent = row
    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 8)
    copyCorner.Parent = copy
    return toast, {scale = scale, title = title, hint = hint, link = link, copy = copy, close = close}
end

function Promo.show()
    if not App.alive then return false end
    local gui = Promo.holder()
    if not gui then return false end
    if Promo.frame then Promo.hide(false) end
    Promo.token += 1
    local token = Promo.token
    Promo.copied, Promo.copyFailed = false, false
    local toast, parts = Promo.build(gui)
    Promo.frame, Promo.parts = toast, parts
    local function handleCopy()
        if Promo.token ~= token or not toast.Parent then return end
        Promo.copied = Promo.copy()
        Promo.copyFailed = not Promo.copied
        Promo.feedback = Promo.feedback + 1
        local feedback = Promo.feedback
        Promo.refresh()
        Promo.after(Promo.copied and 2.5 or 3, function()
            if Promo.token ~= token or Promo.feedback ~= feedback or not toast.Parent then return end
            Promo.copied, Promo.copyFailed = false, false
            Promo.refresh()
        end)
    end
    Promo.connect(parts.copy.Activated, handleCopy)
    Promo.connect(parts.link.Activated, handleCopy)
    Promo.connect(parts.close.Activated, function() Promo.hide(true, token) end)
    Promo.connect(parts.copy.MouseEnter, function()
        parts.copy.BackgroundColor3 = Color3.fromRGB(246, 190, 222)
    end)
    Promo.connect(parts.copy.MouseLeave, function()
        parts.copy.BackgroundColor3 = Color3.fromRGB(232, 164, 205)
    end)
    Promo.connect(parts.link.MouseEnter, function()
        parts.link.BackgroundTransparency = 0.02
    end)
    Promo.connect(parts.link.MouseLeave, function()
        parts.link.BackgroundTransparency = 0.15
    end)
    Promo.animate(parts.scale, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Scale = 1})
    Promo.after(25, function() Promo.hide(true, token) end)
    return true
end

function Promo.tick()
    if not App.alive then return end
    local ok, shown = pcall(Promo.show)
    if ok and shown then
        Promo.failures, Promo.errorShown = 0, false
        Promo.after(1800, Promo.tick)
        return
    end
    if not ok then
        Promo.hide(false)
        if not Promo.errorShown then
            Promo.errorShown = true
            warn("[HallowedReactorHub] Discord banner: " .. tostring(shown))
        end
    end
    Promo.failures += 1
    Promo.after(math.min(60, 2 * 2 ^ math.min(Promo.failures - 1, 5)), Promo.tick)
end

function Promo.start()
    if not App.alive or Promo.started then return end
    Promo.started = true
    Promo.after(6, Promo.tick)
end

function Promo.stop()
    Promo.generation += 1
    Promo.token += 1
    Promo.started = false
    Promo.disconnect()
    if type(task.cancel) == "function" then
        for thread in pairs(Promo.timers) do pcall(task.cancel, thread) end
    end
    table.clear(Promo.timers)
    if Promo.gui then pcall(function() Promo.gui:Destroy() end) end
    Promo.gui, Promo.frame, Promo.parts = nil, nil, nil
end

function App.safe(name, callback, ...)
    local ok, message = pcall(callback, ...)
    if not ok then
        App.errors = App.errors or {}
        if not App.errors[name] then
            App.errors[name] = true
            warn("[HallowedReactorHub] " .. name .. ": " .. tostring(message))
            App.notice(name .. ": error, check the console")
        end
    end
    return ok
end

App.connect(UserInputService.InputBegan, function(input)
    if settings.autoPunch and not UI.open and input.KeyCode == Enum.KeyCode[settings.punchKey] then
        Punch.nextAttempt = math.max(Punch.nextAttempt, os.clock() + 5.05)
    end
    if input.KeyCode == Enum.KeyCode.RightShift and not UserInputService:GetFocusedTextBox() then
        UI.setOpen(not UI.open)
    end
end)

App.connect(UserInputService.WindowFocusReleased, function()
    Auto.focused = false
    Auto.release(false)
end)
App.connect(UserInputService.WindowFocused, function()
    Auto.focused = true
end)

App.connect(LocalPlayer.CharacterAdded, function(character)
    Motion.bindCharacter(character)
    Combat.clearWeapon()
end)
App.connect(LocalPlayer.CharacterRemoving, function(character)
    if Motion.character == character then
        Motion.bindCharacter(nil)
    end
    Combat.clearWeapon()
end)
App.connect(ProximityPromptService.PromptShown, World.promptShown)
App.connect(ProximityPromptService.PromptHidden, World.promptHidden)
App.connect(Lighting.ChildRemoved, function(child)
    if child:IsA("Atmosphere") then
        Guard.clearObject("fog", child)
    end
end)

local elapsed = {weapon = 0, esp = 0, lighting = 0, prompt = 0, fps = 0, optimization = 0, motion = 0, drawing = 0}
App.connect(RunService.Stepped, function()
    if App.alive and (settings.noclip or Guard.groups.noclip) then
        App.safe("Noclip", Motion.updateNoclip)
    end
end)
App.connect(RunService.Heartbeat, function(delta)
    if not App.alive then
        return
    end
    delta = type(delta) == "number" and math.clamp(delta, 0, 0.5) or 0.016
    if settings.autoReload then
        App.safe("Auto Reload", Reload.step)
    end
    if settings.autoPunch then
        App.safe("Auto Punch", Punch.step)
    end
    if settings.autoFire and settings.silentAim or Auto.held then
        if not App.safe("Auto Fire", Auto.step) then
            Auto.release(false)
        end
    end
    if Optimizer.head <= Optimizer.tail or Optimizer.restoreNormal or Optimizer.restoreSuper then
        App.safe("FPS optimization", Optimizer.step)
    end
    if Optimizer.mode > 0 then
        elapsed.optimization += delta
        if elapsed.optimization >= 0.1 then
            elapsed.optimization = 0
            App.safe("FPS optimization refresh", Optimizer.maintain)
        end
    end
    elapsed.motion += delta
    if elapsed.motion >= 0.25 then
        elapsed.motion = 0
        if not settings.speedEnabled and (settings.stamina or settings.antiStagger or settings.noSlow or settings.fastReload) then
            App.safe("Movement", Motion.updateProperties)
        end
    end
    elapsed.weapon += delta
    elapsed.esp += delta
    elapsed.lighting += delta
    elapsed.prompt += delta
    if elapsed.weapon >= 0.3 then
        elapsed.weapon = 0
        if Combat.wanted() or Combat.tool or Combat.pending or #Combat.patches > 0 then
            App.safe("Weapon", Combat.update)
        end
    end
    if elapsed.esp >= 0.5 then
        elapsed.esp = 0
        if settings.espPlayers or settings.espAllies or settings.espNPC or settings.mobBoxes or settings.mobSkeletons or settings.espBoss or settings.bossBoxes or settings.bossSkeletons or settings.espPickups or settings.espObjectives or next(Visual.characters) or next(Visual.pickups) or next(Visual.objectives) then
            App.safe("ESP", Visual.update)
        end
        if settings.eventTracker or settings.threatTracker then
            App.safe("Trackers", UI.updateTrackers)
        end
    end
    if elapsed.lighting >= 0.5 then
        elapsed.lighting = 0
        if Optimizer.mode > 0 then
            Guard.set("fpsOptimization", Lighting, "GlobalShadows", false, false)
        end
        if settings.fullbright or settings.noFog or Guard.groups.light or Guard.groups.fog then
            App.safe("Lighting", Visual.updateLighting)
        end
    end
    if elapsed.prompt >= 0.5 then
        elapsed.prompt = 0
        if settings.instantPrompt or Guard.groups.prompt then
            App.safe("Interactions", World.updatePrompts)
        end
    end
end)

RunService:BindToRenderStep(App.renderName, Enum.RenderPriority.Last.Value, function(delta)
    if not App.alive then
        return
    end
    if UI.open and UserInputService.MouseEnabled then
        Guard.set("cursor", UserInputService, "MouseIconEnabled", true, false)
    elseif Guard.groups.cursor then
        Guard.clear("cursor")
    end
    if settings.speedEnabled then
        App.safe("Movement", Motion.updateProperties)
    end
    if settings.fovEnabled or Guard.groups.fov then
        App.safe("FOV", Visual.updateCamera)
    end
    if settings.mobBoxes or settings.mobSkeletons or settings.bossBoxes or settings.bossSkeletons then
        elapsed.drawing += type(delta) == "number" and math.clamp(delta, 0, 0.5) or 0.016
        if elapsed.drawing >= 0.065 then
            elapsed.drawing = 0
            App.safe("ESP overlay", Visual.renderCharacters)
        end
    end
    if settings.fps and type(delta) == "number" and delta > 0 then
        local fps = math.min(999, 1 / delta)
        App.fps = App.fps and App.fps * 0.88 + fps * 0.12 or fps
        elapsed.fps += delta
        if elapsed.fps >= 0.5 then
            elapsed.fps = 0
            fpsLabel.Text = "FPS: " .. tostring(math.floor(App.fps + 0.5))
        end
    end
end)

function App.stop()
    if not App.alive then
        return
    end
    Save.revision += 1
    Save.flush()
    Auto.release(false)
    App.alive = false
    pcall(Promo.stop)
    Silent.stop()
    Optimizer.stop()
    if UI.modal then
        pcall(function() UI.modal.Visible = false end)
    end
    if UI.library and type(UI.library.Destroy) == "function" then
        pcall(UI.library.Destroy, UI.library)
    elseif UI.window and type(UI.window.Destroy) == "function" then
        pcall(UI.window.Destroy, UI.window)
    end
    UI.window = nil
    UI.library = nil
    UI.modal = nil
    table.clear(UI.toggleViews)
    table.clear(UI.numberViews)
    table.clear(UI.choiceViews)
    table.clear(UI.colorViews)
    pcall(function()
        RunService:UnbindFromRenderStep(App.renderName)
    end)
    Motion.disconnectCharacter()
    Combat.clearWeapon()
    Guard.clearAll()
    Visual.clearAll()
    for _, connection in ipairs(App.connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(App.connections)
    if visualFolder then pcall(function() visualFolder:Destroy() end) end
    visualFolder = nil
    Visual.folder = nil
    pcall(function()
        screen:Destroy()
    end)
    if Shared then
        pcall(function()
            if Shared.HallowedReactorHub == App.api then
                Shared.HallowedReactorHub = nil
            end
        end)
    end
end

App.api = {
    Set = function(key, value)
        return App.set(key, value)
    end,
    Values = function()
        return table.clone(settings)
    end,
    Status = function()
        return {silentAim = Silent.describe(), weapon = Combat.state, fpsOptimization = Optimizer.status()}
    end,
    Action = function(action)
        local actions = {
            objective = World.teleportNearestObjective,
            pickup = World.teleportNearestPickup,
            savePosition = World.savePosition,
            returnPosition = World.returnPosition,
            reset = App.reset,
        }
        local callback = actions[action]
        if callback then
            return callback()
        end
        return false
    end,
    Open = UI.setOpen,
    Unload = App.stop,
}
if Shared then
    pcall(function()
        Shared.HallowedReactorHub = App.api
    end)
end

local uiReady, uiError = pcall(UI.build)
if not uiReady then
    warn("[HallowedReactorHub] Ixa GUI: " .. tostring(uiError))
    App.stop()
    return
end

Motion.bindCharacter(LocalPlayer.Character)
if settings.speedEnabled or settings.stamina or settings.antiStagger or settings.noSlow or settings.fastReload then
    Motion.updateProperties()
end
Optimizer.setMode(settings.superFpsBoost and 2 or settings.fpsBoost and 1 or 0)
UI.setOpen(true)
UI.refreshControls()
pcall(Promo.start)
task.defer(function()
    if not App.alive or not UI.window then
        return
    end
    if UI.pendingOpen ~= nil then
        local desired = UI.pendingOpen
        UI.pendingOpen = nil
        UI.setOpen(desired)
    end
    UI.syncVisibility()
    local window = UI.window
    if window and type(window.LoadAutoload) == "function" then
        local excluded = {}
        for key in pairs(startupManual) do excluded["HR_" .. key] = true end
        window._startupExcluded = excluded
        pcall(window.LoadAutoload, window)
        window._startupExcluded = nil
    end
end)
