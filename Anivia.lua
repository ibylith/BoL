local version = "2.2"
local author = "Titos"
local Qobject = nil
local Robject = nil
local Qobj = false
local Robj = false

-- Change Log --
-- 2.0 - Rewrote Script Code to be more familiar/functional.
--     - Added Ignite features.
--     - Added Jungle Clear.
--     - Added Harass.
--     - Fixed Q Cast.
--     - Changed Target Selector to Cast Priority.
--     - Fixed Ignite errors.
--     - Fixed E Cast.
--     - Added Combo customization.
--     - Fixed Qdet.
--     - Fixed Ult.

-- 2.1 - Fixed E Killsteal
--     - Added Ult Cancelling Toggle
--     - Added E and R Settings in Menu

-- 2.2 - Added Damage Calculation

-- Updates --
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/Anivia.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#00ffff\"><b>Anivia:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/Anivia.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				_AutoupdaterMsg("New version available "..ServerVersion)
				_AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () _AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				_AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		_AutoupdaterMsg("Error downloading version info")
	end
end

--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("REHGJKDHHDG") 

-- Script Begin --
if myHero.charName ~= "Anivia" then return end
require 'UPL'

-- Functions --
function OnLoad()
	print("<b><font color=\"#00FFFF\">Anivia - Eternal Winter: Loaded!</font>")
	Variables()
	Menu()
	CustomOnLoad()
	if _G.AutoCarry ~= nil then
		PrintChat("<font color=\"#DF7401\"><b>SAC: </b></font> <font color=\"#D7DF01\">Loaded</font>")
		SAC = true
		SxOrb = false
	else 	
		if not FileExist(LIB_PATH.."SxOrbWalk.lua") then
			LuaSocket = require("socket")
			ScriptSocket = LuaSocket.connect("sx-bol.eu", 80)
			ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script=raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
			ScriptReceive, ScriptStatus = ScriptSocket:receive('*a')
			ScriptRaw = string.sub(ScriptReceive, string.find(ScriptReceive, "<bols".."cript>")+11, string.find(ScriptReceive, "</bols".."cript>")-1)
			ScriptFileOpen = io.open(LIB_PATH.."SxOrbWalk.lua", "w+")
			ScriptFileOpen:write(ScriptRaw)
			ScriptFileOpen:close()
		end
	end
	require "SxOrbWalk"
	SxOrb:LoadToMenu()     
end

function OnTick()
	ComboKey = Settings.combo.comboKey
	HarassKey = Settings.harass.harassKey
	JungleKey = Settings.jungle.jungleKey
	FarmKey = Settings.farm.farmKey

	if ComboKey then
		Combo(Target)
	end
	
	if HarassKey then
		Harass(Target)
	end

	if JungleKey then
		JungleClear()
	end
	
	if Settings.ks.killSteal then
		KillSteal()
	end

	Checks()
	DetQ()
	CancelR()
end

function OnDraw()
	if not myHero.dead and not Settings.drawing.mDraw then 
		if SkillQ.ready and Settings.drawing.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillQ.range, RGB(Settings.drawing.qColor[2], Settings.drawing.qColor[3], Settings.drawing.qColor[4]))
		end
		if SkillW.ready and Settings.drawing.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillW.range, RGB(Settings.drawing.wColor[2], Settings.drawing.wColor[3], Settings.drawing.wColor[4]))
		end
		if SkillE.ready and Settings.drawing.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillE.range, RGB(Settings.drawing.eColor[2], Settings.drawing.eColor[3], Settings.drawing.eColor[4]))
		end
		if SkillR.ready and Settings.drawing.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, SkillR.range, RGB(Settings.drawing.rColor[2], Settings.drawing.rColor[3], Settings.drawing.rColor[4]))
		end
		if Settings.drawing.myHero then
			DrawCircle(myHero.x, myHero.y, myHero.z, 600, RGB(Settings.drawing.myColor[2], Settings.drawing.myColor[3], Settings.drawing.myColor[4]))
		end
	end
	if Settings.drawing.Dmg then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				local pos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
				local enemyText, color = GetDrawText(enemy)
				if enemyText ~= nil then
					DrawText(enemyText, 15, pos.x, pos.y, color)
				end
			end
		end
	end
end

function GetDrawText(unit)
	local DmgTable = { Q = getDmg("Q", enemy, myHero), E = getDmg("E", enemy, myHero), R = getDmg("R", enemy, myHero) }
	if DmgTable.Q > unit.health then
		return 'Q', ARGB(255, 0, 255, 255)
	elseif DmgTable.E > unit.health then
		return 'E', ARGB(255, 0, 255, 255)
	elseif DmgTable.Q  + (DmgTable.E * 2) > unit.health then
		return 'Q + E', ARGB(255, 0, 255, 255)
	elseif DmgTable.Q + (DmgTable.E * 2) + (DmgTable.R * 10) > unit.health then
		return 'Q + E + Ult ('.. string.format('%4.1f', (unit.health - DmgTable.Q + (DmgTable.E * 2) * (1/DmgTable.R * 10))) .. ' Secs)', ARGB(255, 0, 255, 255)
	else
		return "Can't Kill Yet", ARGB(255, 0, 255, 255)
	end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Settings.combo.useQ then
			CastQ(unit)
		end
		if Settings.combo.useE then
			CastE(unit)
		end
		if Settings.combo.useR then
			CastR(unit)
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type and not LowMana() then
		if Settings.harass.useQ then CastQ(unit) end
		if Settings.harass.useE then CastE(unit) end
	end
end

function JungleClear()
	if Settings.jungle.jungleKey then
		local JungleMob = GetJungleMob()
		
		if JungleMob ~= nil then
			if Settings.jungle.jungleQ and GetDistance(JungleMob) <= SkillQ.range and SkillQ.ready and not Qobj then
				CastSpell(_Q, JungleMob.x, JungleMob.z)
			end
			if Settings.jungle.jungleQ and GetDistance(JungleMob, Qobject) <= 200 and SkillQ.ready and Qobj then
				CastSpell(_Q)
			end
			if Settings.jungle.jungleE and GetDistance(JungleMob) <= SkillE.range and SkillE.ready then
				if TargetHaveBuff("chilled", JungleMob) then
					CastSpell(_E, JungleMob)
				end
			end
			if Settings.jungle.jungleR and GetDistance(JungleMob) <= SkillR.range and SkillR.ready and not Robj then
				CastSpell(_R, JungleMob.x, JungleMob.z)
			end
		end
	end
end

function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= SkillQ.range and SkillQ.ready and not Qobj then
		local CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, unit)
		
		if HitChance >= 2 then
			CastSpell(_Q, CastPosition.x, CastPosition.z)
		end
	end
end

function DetQ()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) and enemy.visible and Qobj and not enemy.dead then
			if GetDistance(enemy, Qobject) <= 200 then
				CastSpell(_Q)
			end
		end
	end
end

function CastE(unit)
	if GetDistance(unit) <= SkillE.range and ValidTarget(unit) then
		if SkillE.ready then
			if Settings.skill.Eskill.chilledE then
				if TargetHaveBuff("chilled", unit) then
					CastSpell(_E, unit)
				end
			else
				CastSpell(_E, unit)
			end
		end
	end
end

function CastR(unit)
	if unit ~= nil then
		if not Robj and SkillR.ready and GetDistance(unit) <= SkillR.range then
			CastSpell(_R, unit)
		end
	end
end

function CancelR()
	if not Settings.farm.farmKey then
		if not Settings.jungle.jungleKey then
			if Robj then
				local rcount = 0
				for i, enemy in ipairs(GetEnemyHeroes()) do
					if GetDistance(enemy, Robject) < SkillR.range and ValidTarget(enemy) and not enemy.dead then
						rcount = rcount + 1
					end
				end
		
				if rcount == 0 then
					CastSpell(_R) 
				end
			end
		end
	end
end

function KillSteal()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) and enemy.visible then
			local eDmg = getDmg("E", enemy, myHero)
			
			if TargetHaveBuff("chilled", champ) then
				if enemy.health <= (eDmg * 2) then
					CastE(enemy)
				end
			else
				if enemy.health <= (eDmg) then
					CastE(enemy)
				end
			end
			
			if Settings.ks.AutoIgnite then
				AutoIgnite(enemy)
			end
		end
	end
end

function AutoIgnite(unit)
	if ValidTarget(unit, Ignite.range) and unit.health <= 50 + (20 * myHero.level) then
		if Ignite.ready then
			CastSpell(Ignite.slot, unit)
		end
	end
end	

-- Checks & Menu --
function Checks()
	SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	SkillR.ready = (myHero:CanUseSpell(_R) == READY)

	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_2
	end
	
	Ignite.ready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
	

	TargetSelector:update()
	Target = GetCustomTarget()
	
	SxOrb:ForceTarget(Target)

	_G.DrawCircle = _G.oldDrawCircle
end

function LowMana()
	if myHero.mana < (myHero.maxMana * ( Settings.harass.harassMana / 100)) then
		return true
	else
		return false
	end
end

function Menu()
	Settings = scriptConfig("Anivia - Eternal Winter "..version.."", "TitosAnivia")

	Settings:addSubMenu("["..myHero.charName.."] - Combo Settings (SBTW)", "combo")
		Settings.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Settings.combo:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("useE", "Use (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:addParam("useR", "Use (R) in Combo", SCRIPT_PARAM_ONOFF, true)
		Settings.combo:permaShow("comboKey")

	Settings:addSubMenu("["..myHero.charName.."] - Harass Settings", "harass")
		Settings.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		Settings.harass:addParam("useQ", "Use "..SkillQ.name.." (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.harass:addParam("useE", "Use "..SkillE.name.." (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		Settings.harass:addParam("harassMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		Settings.harass:permaShow("harassKey")

	Settings:addSubMenu("["..myHero.charName.."] - Farm Settings", "farm")
		Settings.farm:addParam("farmKey", "Disable Automatic (R) Cancelling", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("K"))
		Settings.farm:permaShow("farmKey")

	Settings:addSubMenu("["..myHero.charName.."] - Jungle Clear Settings", "jungle")
		Settings.jungle:addParam("jungleKey", "Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
		Settings.jungle:addParam("jungleQ", "Clear with "..SkillQ.name.." (Q)", SCRIPT_PARAM_ONOFF, true)
		Settings.jungle:addParam("jungleE", "Clear with "..SkillE.name.." (E)", SCRIPT_PARAM_ONOFF, true)
		Settings.jungle:addParam("jungleR", "Clear with "..SkillR.name.." (R)", SCRIPT_PARAM_ONOFF, true)
		Settings.jungle:permaShow("jungleKey")

	Settings:addSubMenu("["..myHero.charName.."] - Skill Settings", "skill")
		Settings.skill:addSubMenu("["..SkillE.name.."] (E) Settings", "Eskill")
			Settings.skill.Eskill:addParam("chilledE", "Use (E) on Chilled Targets Only", SCRIPT_PARAM_ONOFF, true)
		Settings.skill:addSubMenu("["..SkillR.name.."] (R) Settings", "Rskill")
			Settings.skill.Rskill:addParam("autoR", "Auto (R) on Stunned (DISABLED)", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - KillSteal Settings", "ks")
		Settings.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
		Settings.ks:addParam("AutoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		Settings.ks:permaShow("killSteal")

	Settings:addSubMenu("["..myHero.charName.."] - Draw Settings", "drawing")      
		Settings.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
		Settings.drawing:addParam("myHero", "Draw My Range", SCRIPT_PARAM_ONOFF, true)
        Settings.drawing:addParam("myColor", "Draw My Range Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("qDraw", "Draw "..SkillQ.name.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("qColor", "Draw "..SkillQ.name.." (Q) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("wDraw", "Draw "..SkillW.name.." (W) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("wColor", "Draw "..SkillW.name.." (W) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("eDraw", "Draw "..SkillE.name.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("eColor", "Draw "..SkillE.name.." (E) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("rDraw", "Draw "..SkillR.name.." (R) Range", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("rColor", "Draw "..SkillR.name.." (R) Color", SCRIPT_PARAM_COLOR, {0, 100, 44, 255})
		Settings.drawing:addParam("Dmg", "Draw Damage Calculations", SCRIPT_PARAM_ONOFF, true)
		Settings.drawing:addParam("targetcircle", "Draw Circle On Target", SCRIPT_PARAM_ONOFF, true)

	Settings:addSubMenu("["..myHero.charName.."] - Prediction Settings", "Prediction")
		UPL:AddToMenu(Settings.Prediction)

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, SkillQ.range, DAMAGE_MAGIC, true)
	TargetSelector.name = "Anivia"
	Settings:addTS(TargetSelector)
end

function Variables()
	SkillQ = { name = "Flash Frost", range = 1100, delay = 0.25, speed = 850, width = 150, ready = false }
	SkillW = { name = "Crystallize", range = 1000, delay = 0.5, speed = math.huge, width = nil, ready = false }
	SkillE = { name = "Frostbite", range = 650, delay = 0.25, speed = math.huge, width = nil, ready = false }
	SkillR = { name = "Glacial Storm", range = 625, delay = 0.25, speed = math.huge, width = 210, ready = false }
	Ignite = { name = "summerdot", range = 600, slot = nil }

	UPL = UPL()
	UPL:AddSpell(_Q, { speed = SkillQ.speed, delay = SkillQ.delay, range = SkillQ.range, width = SkillQ.width, collision = false, aoe = true, type = "linear" })   

	enemyMinions = minionManager(MINION_ENEMY, SkillR.range, myHero, MINION_SORT_HEALTH_ASC)
	
	JungleMobs = {}
	JungleFocusMobs = {}

	if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true
	else
		TwistedTreeline = false
	end

	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2

	priorityTable = {
			AP = {
				"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
				"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
				"Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"
			},
			
			Support = {
				"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"
			},
			
			Tank = {
				"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
				"Warwick", "Yorick", "Zac"
			},
			
			AD_Carry = {
				"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
				"Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
			},
			
			Bruiser = {
				"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
				"Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
			}
	}
	if not TwistedTreeline then
		JungleMobNames = { 
			["SRU_MurkwolfMini2.1.3"]	= true,
			["SRU_MurkwolfMini2.1.2"]	= true,
			["SRU_MurkwolfMini8.1.3"]	= true,
			["SRU_MurkwolfMini8.1.2"]	= true,
			["SRU_BlueMini1.1.2"]		= true,
			["SRU_BlueMini7.1.2"]		= true,
			["SRU_BlueMini21.1.3"]		= true,
			["SRU_BlueMini27.1.3"]		= true,
			["SRU_RedMini10.1.2"]		= true,
			["SRU_RedMini10.1.3"]		= true,
			["SRU_RedMini4.1.2"]		= true,
			["SRU_RedMini4.1.3"]		= true,
			["SRU_KrugMini11.1.1"]		= true,
			["SRU_KrugMini5.1.1"]		= true,
			["SRU_RazorbeakMini9.1.2"]	= true,
			["SRU_RazorbeakMini9.1.3"]	= true,
			["SRU_RazorbeakMini9.1.4"]	= true,
			["SRU_RazorbeakMini3.1.2"]	= true,
			["SRU_RazorbeakMini3.1.3"]	= true,
			["SRU_RazorbeakMini3.1.4"]	= true
		}
		
		FocusJungleNames = {
			["SRU_Blue1.1.1"]			= true,
			["SRU_Blue7.1.1"]			= true,
			["SRU_Murkwolf2.1.1"]		= true,
			["SRU_Murkwolf8.1.1"]		= true,
			["SRU_Gromp13.1.1"]			= true,
			["SRU_Gromp14.1.1"]			= true,
			["Sru_Crab16.1.1"]			= true,
			["Sru_Crab15.1.1"]			= true,
			["SRU_Red10.1.1"]			= true,
			["SRU_Red4.1.1"]			= true,
			["SRU_Krug11.1.2"]			= true,
			["SRU_Krug5.1.2"]			= true,
			["SRU_Razorbeak9.1.1"]		= true,
			["SRU_Razorbeak3.1.1"]		= true,
			["SRU_Dragon6.1.1"]			= true,
			["SRU_Baron12.1.1"]			= true
		}
	else
		FocusJungleNames = {
			["TT_NWraith1.1.1"]			= true,
			["TT_NGolem2.1.1"]			= true,
			["TT_NWolf3.1.1"]			= true,
			["TT_NWraith4.1.1"]			= true,
			["TT_NGolem5.1.1"]			= true,
			["TT_NWolf6.1.1"]			= true,
			["TT_Spiderboss8.1.1"]		= true
		}		
		JungleMobNames = {
			["TT_NWraith21.1.2"]		= true,
			["TT_NWraith21.1.3"]		= true,
			["TT_NGolem22.1.2"]			= true,
			["TT_NWolf23.1.2"]			= true,
			["TT_NWolf23.1.3"]			= true,
			["TT_NWraith24.1.2"]		= true,
			["TT_NWraith24.1.3"]		= true,
			["TT_NGolem25.1.1"]			= true,
			["TT_NWolf26.1.2"]			= true,
			["TT_NWolf26.1.3"]			= true
		}
	end
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object and object.valid and not object.dead then
			if FocusJungleNames[object.name] then
				JungleFocusMobs[#JungleFocusMobs+1] = object
			elseif JungleMobNames[object.name] then
				JungleMobs[#JungleMobs+1] = object
			end
		end
	end
end

function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
 
function arrangePriorities()
		for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,	   enemy, 2)
		SetPriority(priorityTable.Support,  enemy, 3)
		SetPriority(priorityTable.Bruiser,  enemy, 4)
		SetPriority(priorityTable.Tank,	 enemy, 5)
		end
end

function arrangePrioritiesTT()
        for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,       enemy, 1)
		SetPriority(priorityTable.Support,  enemy, 2)
		SetPriority(priorityTable.Bruiser,  enemy, 2)
		SetPriority(priorityTable.Tank,     enemy, 3)
        end
end

function CustomOnLoad()
	if heroManager.iCount < 10 or (TwistedTreeline and heroManager.iCount < 6) then
		print("<b><font color=\"#00FFFF\">Anivia - Eternal Winter:</font></b> <font color=\"#FFFFFF\">Too few champions to arrange priority.</font>")
	elseif heroManager.iCount == 6 then
		arrangePrioritiesTT()
    else
		arrangePriorities()
	end
end

function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, SkillQ.range) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, SkillQ.range) then return Mob end
	end
end

function OnCreateObj(object)
	if object.name == "cryo_FlashFrost_Player_mis.troy" then
		Qobject = object
		Qobj = true
	end
	
	if object.name == "cryo_storm_green_team.troy" then
		Robject = object
		Robj = true
	end
end

function OnDeleteObj(object)
	if object.name == "cryo_FlashFrost_mis.troy" then
		Qobject = nil
		Qobj = false
	end
	
	if object.name == "cryo_storm_green_team.troy" then
		Robject = nil
		Robj = false
	end
end

function GetCustomTarget()
 	TargetSelector:update() 	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return TargetSelector.target
end

function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
end
