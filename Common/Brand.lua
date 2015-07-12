if myHero.charName ~= "Brand"  or not VIP_USER then return end
local version = 0.1
local AUTOUPDATE = true
local SCRIPT_NAME = "SXBrand"
require 'VPrediction'
require "SxOrbwalk"
--require 'Prodiction' 
require 'Collision'
require 'DivinePred'
require 'HPrediction'


-- Constants --
local ignite, igniteReady = nil, nil
local ts = nil
local VP = nil
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {2,1,3,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3}
local Ranges = { AA = 550 }
local skills = {
	SkillQ = { ready = true, name = " Sear", range = 1050, delay = 0.5, speed = 1200, width = 80.0 },
	SkillW = { ready = true, name = "Pillar of Flame", range = 900, delay = 0.5, speed = math.huge, width = 240.0 },
	SkillE = { ready = true, name = " Conflagration", range = 625, delay = 0, speed = 1800, width = 0.0 },
	SkillR = { ready = true, name = "Pyroclasm", range = 750, delay = 0.5, speed = math.huge, width = 0.0 },
}
--[[ Slots Itens ]]--
local tiamatSlot, hydraSlot, youmuuSlot, bilgeSlot, bladeSlot, dfgSlot, divineSlot = nil, nil, nil, nil, nil, nil, nil
local tiamatReady, hydraReady, youmuuReady, bilgeReady, bladeReady, dfgReady, divineReady = nil, nil, nil, nil, nil, nil, nil

--[[Auto Attacks]]--
local lastBasicAttack = 0
local swingDelay = 0.25
local swing = false

--[[Misc]]--
local lastSkin = 0
local isSAC = false
local isMMA = false
local target = nil

function CheckUpdate()
        local scriptName = "SXBrand"
        local version = 1.0
        local ToUpdate = {}
        ToUpdate.Version = version
        ToUpdate.Host = "raw.githubusercontent.com"
        ToUpdate.VersionPath = "/syraxtepper/bolscripts/master/SXBrand"..scriptName..".version"
        ToUpdate.ScriptPath = "/syraxtepper/bolscripts/master/SXBrand"..scriptName..".lua"
        ScriptUpdate(ToUpdate.Version, ToUpdate.Host, ToUpdate.VersionPath, ToUpdate.ScriptPath)
end
class "ScriptUpdate"
function ScriptUpdate:__init(LocalVersion, Host, VersionPath, ScriptPath)
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..VersionPath)..'&rand='..math.random(99999999)
    self.ScriptPath = '/BoL/TCPUpdater/GetScript2.php?script='..self:Base64Encode(self.Host..ScriptPath)..'&rand='..math.random(99999999)
    self.SavePath = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
    self.CallbackUpdate = function(NewVersion, OldVersion) print("Updated to "..NewVersion..". Please Reload with 2x F9.") end
    self.CallbackNoUpdate = function(OldVersion) print("No Updates Found") end
    self.CallbackNewVersion = function(NewVersion) print("New Version found ("..NewVersion.."). Please wait..") end
    self.LuaSocket = require("socket")
    self.Socket = self.LuaSocket.connect('sx-bol.eu', 80)
    self.Socket:send("GET "..self.VersionPath.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.LastPrint = ""
    self.File = ""
    AddTickCallback(function() self:GetOnlineVersion() end)
end

function ScriptUpdate:Base64Encode(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function ScriptUpdate:GetOnlineVersion()
    if self.Status == 'closed' then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)

    if self.Receive then
        if self.LastPrint ~= self.Receive then
            self.LastPrint = self.Receive
            self.File = self.File .. self.Receive
        end
    end

    if self.Snipped ~= "" and self.Snipped then
        self.File = self.File .. self.Snipped
    end
    if self.Status == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            self.OnlineVersion = tonumber(self.File:sub(ContentStart + 1))
            if self.OnlineVersion > self.LocalVersion then
                if self.CallbackNewVersion and type(self.CallbackNewVersion) == 'function' then
                    self.CallbackNewVersion(self.OnlineVersion,self.LocalVersion)
                end
                self.DownloadSocket = self.LuaSocket.connect('sx-bol.eu', 80)
                self.DownloadSocket:send("GET "..self.ScriptPath.." HTTP/1.0\r\nHost: sx-bol.eu\r\n\r\n")
                self.DownloadSocket:settimeout(0, 'b')
                self.DownloadSocket:settimeout(99999999, 't')
                self.LastPrint = ""
                self.File = ""
                AddTickCallback(function() self:DownloadUpdate() end)
            else
                if self.CallbackNoUpdate and type(self.CallbackNoUpdate) == 'function' then
                    self.CallbackNoUpdate(self.LocalVersion)
                end
            end
        else
            print('Error: Could not get end of Header')
        end
    end
end

function ScriptUpdate:DownloadUpdate()
    if self.DownloadStatus == 'closed' then return end
    self.DownloadReceive, self.DownloadStatus, self.DownloadSnipped = self.DownloadSocket:receive(1024)

    if self.DownloadReceive then
        if self.LastPrint ~= self.DownloadReceive then
            self.LastPrint = self.DownloadReceive
            self.File = self.File .. self.DownloadReceive
        end
    end

    if self.DownloadSnipped ~= "" and self.DownloadSnipped then
        self.File = self.File .. self.DownloadSnipped
    end

    if self.DownloadStatus == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            local ScriptFileOpen = io.open(self.SavePath, "w+")
            ScriptFileOpen:write(self.File:sub(ContentStart + 1))
            ScriptFileOpen:close()
            if self.CallbackUpdate and type(self.CallbackUpdate) == 'function' then
                self.CallbackUpdate(self.OnlineVersion,self.LocalVersion)
            end
        end
    end
end
--Credit Trees

function GetCustomTarget()
	ts:update()
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
  if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	return ts.target
end

function OnLoad()
	if _G.ScriptLoaded then	return end
	_G.ScriptLoaded = true
	initComponents()
   HookPackets()
   
   Spell_Q.collisionM['Brand'] = true
  Spell_Q.collisionH['Brand'] = true -- or false (sometimes, it's better to not consider it)
  Spell_Q.delay['Brand'] = .25
  Spell_Q.range['Brand'] = 1050
  Spell_Q.speed['Brand'] = 1200
  Spell_Q.type['Brand'] = "DelayLine" -- (it has tail like comet)
  Spell_Q.width['Brand'] = 80
  
  
   Spell_W.collisionM['Brand'] = false
  Spell_W.collisionH['Brand'] = false -- or false (sometimes, it's better to not consider it)
  Spell_W.delay['Brand'] = .25
  Spell_W.range['Brand'] = 900
  Spell_W.speed['Brand'] = math.huge
  Spell_W.type['Brand'] = "DelayLine" -- (it has tail like comet)
  Spell_W.width['Brand'] = 240
end
function initComponents()
 -- Prod = ProdictManager.GetInstance()
 -- ProdQ = Prod:AddProdictionObject(_Q, 900, math.huge, 0.5, 110)  
 --qPos = nil
    -- VPrediction Start
    
    --[[Spell_Q.collisionM['Brand'] = true
  Spell_Q.collisionH['Brand'] = true -- or false (sometimes, it's better to not consider it)
  Spell_Q.delay['Brand'] = .25
  Spell_Q.range['Brand'] = 1050
  Spell_Q.speed['Brand'] = 1200
  Spell_Q.type['Brand'] = "DelayLine" -- (it has tail like comet)
  Spell_Q.width['Brand'] = 80
  
  
   Spell_W.collisionM['Brand'] = false
  Spell_W.collisionH['Brand'] = false -- or false (sometimes, it's better to not consider it)
  Spell_W.delay['Brand'] = .25
  Spell_W.range['Brand'] = 900
  Spell_W.speed['Brand'] = math.huge
  Spell_W.type['Brand'] = "DelayLine" -- (it has tail like comet)
  Spell_W.width['Brand'] = 240--]]
 VP = VPrediction()
  DP = DivinePred()
    HPred = HPrediction()
   -- SOW Declare
  -- Orbwalker = SOW(VP)
  -- Target Selector
   ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900)
  
 Menu = scriptConfig("SXBrand by SyraX", "BrandMA")

   if _G.MMA_Loaded ~= nil then
     PrintChat("<font color = \"#33CCCC\">MMA Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isMMA = true
 elseif _G.AutoCarry ~= nil then
      PrintChat("<font color = \"#33CCCC\">SAC Status:</font> <font color = \"#fff8e7\"> Loaded</font>")
     isSAC = true
 else
     PrintChat("<font color = \"#33CCCC\">OrbWalker not found:</font> <font color = \"#fff8e7\"> Loading SX</font>")
    Menu:addSubMenu("["..myHero.charName.."] - Orbwalking Settings", "Orbwalking")
		SxOrb:LoadToMenu(Menu.Orbwalking)

   -- Menu:addTS(ts)
    end
    
 Menu:addSubMenu("["..myHero.charName.." - Combo]", "BrandCombo")
    Menu.BrandCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Menu.BrandCombo:addSubMenu("Q Settings", "qSet")
  Menu.BrandCombo.qSet:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.BrandCombo:addSubMenu("W Settings", "wSet")
  Menu.BrandCombo.wSet:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, false)
 Menu.BrandCombo:addSubMenu("E Settings", "eSet")
  Menu.BrandCombo.eSet:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
 Menu.BrandCombo:addSubMenu("R Settings", "rSet")
  Menu.BrandCombo.rSet:addParam("useR", "Use Smart Ultimate", SCRIPT_PARAM_ONOFF, true)
  --Menu.BrandCombo.rSet:addParam("SelectR", "How you wanna cast R?", SCRIPT_PARAM_LIST, 1, {"Manual", "Let Script do it on count", "Spacebar + Leftclick"})
  Menu.BrandCombo.rSet:addParam("RMode", "Use Ultimate enemy count:", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)

 Menu:addSubMenu("["..myHero.charName.." - Harass]", "Harass")
  Menu.Harass:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
  Menu.Harass:addParam("useQ", "Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
    Menu.Harass:addParam("useW", "Use W in Harass", SCRIPT_PARAM_ONOFF, false)
   Menu.Harass:addParam("useE", "Use E in Harass", SCRIPT_PARAM_ONOFF, true)
    
 Menu:addSubMenu("["..myHero.charName.." - Laneclear]", "Laneclear")
    Menu.Laneclear:addParam("lclr", "Laneclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  Menu.Laneclear:addParam("useClearQ", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
 Menu.Laneclear:addParam("useClearW", "Use W in Laneclear", SCRIPT_PARAM_ONOFF, false)
    Menu.Laneclear:addParam("useClearE", "Use E in Laneclear", SCRIPT_PARAM_ONOFF, true)
 
 Menu:addSubMenu("["..myHero.charName.." - Jungleclear]", "Jungleclear")
    Menu.Jungleclear:addParam("jclr", "Jungleclear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  Menu.Jungleclear:addParam("useClearQ", "Use Q in Jungleclear", SCRIPT_PARAM_ONOFF, true)
 Menu.Jungleclear:addParam("useClearW", "Use W in Jungleclear", SCRIPT_PARAM_ONOFF, false)
    Menu.Jungleclear:addParam("useClearE", "Use E in Jungleclear", SCRIPT_PARAM_ONOFF, true)
 
 Menu:addSubMenu("["..myHero.charName.." - Prodiction Settings]", "ProdSettings") -- Menu.ProdSettings.SelectProdiction
 -- Menu.selectProdSettings == 1 or 2
	Menu.ProdSettings:addParam("SelectProdiction", "Select Prodiction", SCRIPT_PARAM_LIST, 1, {"Devine", "VPrediction", "HPrediction"})

 
 Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
    Menu.Ads:addParam("autoLevel", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
   Menu.Ads:addSubMenu("Killsteal", "KS")
   Menu.Ads:addParam("Tower", "Target under your tower use stun", SCRIPT_PARAM_ONOFF, false)
   
   Menu.Ads.KS:addParam("ignite", "Use Ignite", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.KS:addParam("igniteRange", "Minimum range to cast Ignite", SCRIPT_PARAM_SLICE, 470, 0, 600, 0)
    Menu.Ads.KS:addParam("KS", "KillSteal", SCRIPT_PARAM_ONOFF, false)

  
 
  Menu.Ads:addSubMenu("VIP", "VIP")
    Menu.Ads.VIP:addParam("skin", "Use custom skin", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads.VIP:addParam("skin1", "Skin changer", SCRIPT_PARAM_SLICE, 1, 1, 5)

  
 Menu:addSubMenu("["..myHero.charName.." - Drawings]", "drawings")
  Menu.drawings:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
  Menu.drawings:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    Menu.drawings:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
    
 targetMinions = minionManager(MINION_ENEMY, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
  allyMinions = minionManager(MINION_ALLY, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
 jungleMinions = minionManager(MINION_JUNGLE, 360, myHero, MINION_SORT_MAXHEALTH_DEC)
 
 if Menu.Ads.VIP.skin and VIP_USER then
       GenModelPacket("Brand", Menu.Ads.VIP.skin1)
     lastSkin = Menu.Ads.VIP.skin1
    end
  
  PrintChat("<font color = \"#FFA319\">SX</font><font color = \"#52524F\">Brand/font> <font color = \"#FFFFFF\">by</font><font color = \"#FF0066\"> SyraX</font><font color = \"#00FF00\"> V"..version.."</font>")
end

 pis = false
 kut = math.huge
function OnTick()
	target = GetCustomTarget()
	targetMinions:update()
	allyMinions:update()
	jungleMinions:update()
	CDHandler()
	KillSteal()
  --print(pis)
  
  --print(Passive)
  if Menu.Ads.Tower then
   TurretStun()
  end
  if pis then
    if kut + 4 <= GetGameTimer() then
      pis = false
      kut = math.huge
    end
  end
  
 -- print(ulti)

   


 

	if Menu.Ads.VIP.skin and VIP_USER and skinChanged() then
		GenModelPacket("Brand", Menu.Ads.VIP.skin1)
		lastSkin = Menu.Ads.VIP.skin1
	end 
  --[[for i = 1, heroManager.iCount do
    local hero = heroManager:GetHero(i)
      if hero.team ~= myHero.team then
        
        ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
        ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
        ProdQ:GetPredictionOnDash(hero, OnDashfunc)
        
        
      end
    end--]]

--[[for i = 1, heroManager.iCount do
       local hero = heroManager:GetHero(i)
       if hero.team ~= myHero.team then
         
          
            if Menu.ProdSettings.AD then
                ProdQ:GetPredictionAfterDash(hero, AfterDashFunc)
            
            else
                ProdQ:GetPredictionAfterDash(hero, AfterDashFunc, false)
               
            end
            
            if Menu.ProdSettings.AI then
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc)
               
            else
                
                ProdQ:GetPredictionAfterImmobile(hero, AfterImmobileFunc, false)
            end
                  

        end
    end
    OnDashPos = nil
    AfterDashPos = nil
    AfterImmobilePos = nil
    OnImmobilePos = nil--]]

if click == 2 then
       DoubleClick()
       if click == 2 then
         click = 0
        end
   end
   if click >= 3 then
   click = 0
   end
   if click == 1 then
      if time + 0.4 <= GetGameTimer() then
         click = 0
         time  = math.huge
      end
    end 
  
   
    
     --[[ sec
      if klik == 2 then
       DoubleClick2()
       if klik == 2 then
         klik = 0
        end
   end
   if klik >= 3 then
   klik = 0
   end
   if klik == 1 then
      if tijd + 0.4 <= GetGameTimer() then
         klik = 0
         tijd  = math.huge
      end
    end 
--]]
	if Menu.Ads.autoLevel then
		AutoLevel()
	end
	
	if Menu.BrandCombo.combo then
		Combo()
	end
	
	if Menu.Harass.harass then
		Harass()
	end
	
	if Menu.Laneclear.lclr then
		LaneClear()
	end
	
	if Menu.Jungleclear.jclr then
		JungleClear()
	end

end

function CDHandler()
	-- Spells
	skills.SkillQ.ready = (myHero:CanUseSpell(_Q) == READY)
	skills.SkillW.ready = (myHero:CanUseSpell(_W) == READY)
	skills.SkillE.ready = (myHero:CanUseSpell(_E) == READY)
	skills.SkillR.ready = (myHero:CanUseSpell(_R) == READY)

	-- Items
	tiamatSlot = GetInventorySlotItem(3077)
	hydraSlot = GetInventorySlotItem(3074)
	youmuuSlot = GetInventorySlotItem(3142) 
	bilgeSlot = GetInventorySlotItem(3144)
	bladeSlot = GetInventorySlotItem(3153)
	dfgSlot = GetInventorySlotItem(3128)
	divineSlot = GetInventorySlotItem(3131)
	
	tiamatReady = (tiamatSlot ~= nil and myHero:CanUseSpell(tiamatSlot) == READY)
	hydraReady = (hydraSlot ~= nil and myHero:CanUseSpell(hydraSlot) == READY)
	youmuuReady = (youmuuSlot ~= nil and myHero:CanUseSpell(youmuuSlot) == READY)
	bilgeReady = (bilgeSlot ~= nil and myHero:CanUseSpell(bilgeSlot) == READY)
	bladeReady = (bladeSlot ~= nil and myHero:CanUseSpell(bladeSlot) == READY)
	dfgReady = (dfgSlot ~= nil and myHero:CanUseSpell(dfgSlot) == READY)
	divineReady = (divineSlot ~= nil and myHero:CanUseSpell(divineSlot) == READY)

	-- Summoners
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		ignite = SUMMONER_2
	end
	igniteReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
DamageCalculation()
end-- Harass --

function Harass()	
	if target ~= nil and ValidTarget(target) then
    if  Menu.ProdSettings.SelectProdiction == 2 then
      if Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
           if HitChance >= 2 and GetDistance(CastPosition) < 900 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
       -- print("301")
            end
    elseif Menu.Harass.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.ready then
          DevineQ()
        end
    end
       if target ~= nil and target ~= nil and skills.SkillW.ready then
  if Menu.Harass.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready and not target.dead then
  if Menu.ProdSettings.SelectProdiction == 2 then
   
  AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, skills.SkillW.delay, skills.SkillW.width, skills.SkillW.range, skills.SkillW.speed, myHero)
      if GetDistance(AOECastPosition) <= skills.SkillW.range and MainTargetHitChance >= 2 then
          Packet("S_CAST", {spellId = _W, fromX = AOECastPosition.x, fromY = AOECastPosition.z, toX = AOECastPosition.x, toY = AOECastPosition.z}):send()
      end
    elseif Menu.ProdSettings.SelectProdiction == 1 then
      DevineW()
    --  print("wajoo")
    end
	end
end
		if Menu.Harass.useE and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
			CastSpell(_E, target)
		end
	end
	
end

-- End Harass --

function DevineW()
  if target ~= nil and target.type == myHero.type and skills.SkillE.ready and ValidTarget(target, skills.SkillE.range) then
  if Menu.ProdSettings.SelectProdiction == 2 then
			local target = DPTarget(target)
			local MaokaiW = LineSS(skills.SkillW.speed, skills.SkillW.range, skills.SkillW.width, skills.SkillW.delay, 0)
			local State, Position, perc = DP:predict(target, MaokaiW)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
        print("goed zo")
				
      Packet("S_CAST", {spellId = _W, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()


				end
			end
end
end
  

function DevineQ()
 -- print("johhny")
  if target ~= nil and target.type == myHero.type then
  if Menu.ProdSettings.SelectProdiction == 1 then
			local target = DPTarget(target)
			local BrandQ = LineSS(skills.SkillQ.speed, skills.SkillQ.range, skills.SkillQ.width, skills.SkillQ.delay, 0)
			local State, Position, perc = DP:predict(target, BrandQ)
			if State == SkillShot.STATUS.SUCCESS_HIT then 
				
      Packet("S_CAST", {spellId = _Q, fromX = Position.x, fromY = Position.z, toX = Position.x, toY = Position.z}):send()


				end
			end
end
end

function OnTowerFocus(tower, unit)
  unit = GetTarget()
  if unit ~= nil then
       if tower.team == myHero.team then
         if unit.team ~= myHero.team then
          return true
       end
     end
  end
 

end

function AreaEnemyCount()
	local count = 0
		for _, enemy in pairs(GetEnemyHeroes()) do
			if enemy and not enemy.dead and enemy.visible and GetDistance(myHero, enemy) < skills.SkillE.range then
				count = count + 1
			end
		end              
	return count
end

-- Combo Selector --

function Combo()
	local typeCombo = 0
	if target ~= nil then
		AllInCombo(target, 0)
	end
	
end

-- Combo Selector --

-- All In Combo -- 

function AllInCombo(target, typeCombo)
	if target ~= nil and typeCombo == 0 and target.type == myHero.type and target.team ~= myHero.team then
		ItemUsage(target)
    if ValidTarget(target, skills.SkillR.range) and AreaEnemyCount() >= Menu.BrandCombo.rSet.RMode and target.health <= rDmg  then
       if Menu.BrandCombo.rSet.useR  then 
        CastSpell(_R, target)
       end
    end
    if Menu.BrandCombo.eSet.useE  and ValidTarget(target, skills.SkillE.range) and skills.SkillE.ready then
      CastSpell(_E, target)
    end
  --  print("check2")
    if  Menu.ProdSettings.SelectProdiction == 2 then
    --  print("check3")
      if Menu.BrandCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.range and Passive then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
      --print("check 2")
            if HitChance >= 2 and GetDistance(CastPosition) < 1050 then
             -- print("check1")
				CastSpell(_Q, CastPosition.x, CastPosition.z)
       -- print("301")
            end
    end
  elseif Menu.ProdSettings.SelectProdiction == 1 then
    if Menu.BrandCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.range and Passive then
      DevineQ()
    end
  elseif Menu.ProdSettings.SelectProdiction == 3 then
    if Menu.BrandCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.range and Passive then 
      CastQ()
    end
  end
  
    

 if target ~= nil and target ~= nil and skills.SkillW.ready then
  if Menu.BrandCombo.wSet.useW and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready and not target.dead then
  if Menu.ProdSettings.SelectProdiction == 2 then
   
  AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, skills.SkillW.delay, skills.SkillW.width, skills.SkillW.range, skills.SkillW.speed, myHero)
      if GetDistance(AOECastPosition) <= skills.SkillW.range and MainTargetHitChance >= 2 then
          Packet("S_CAST", {spellId = _W, fromX = AOECastPosition.x, fromY = AOECastPosition.z, toX = AOECastPosition.x, toY = AOECastPosition.z}):send()
      end
    elseif Menu.ProdSettings.SelectProdiction == 1 then
      DevineW()
    --  print("wajoo")
  elseif Menu.ProdSettings.SelectProdiction == 3 then
    CastW()
	end
end

	
	end
end
end
-- All In Combo --


function LaneClear()
	for i, targetMinion in pairs(targetMinions.objects) do
		if targetMinion ~= nil then
			if Menu.Laneclear.useClearQ and skills.SkillQ.ready and ValidTarget(targetMinion, skills.SkillQ.range) then
				CastSpell(_Q, targetMinion.x, targetMinion.z)
			end
			if Menu.Laneclear.useClearW and skills.SkillW.ready and ValidTarget(targetMinion, skills.SkillW.range) then
				CastSpell(_W, targetMinion.x, targetMinion.z)
			end
			if Menu.Laneclear.useClearE and skills.SkillE.ready and ValidTarget(targetMinion, skills.SkillE.range) then
				CastSpell(_E, targetMinion)
			end
		end
		
	end
end

function JungleClear()
	for i, jungleMinion in pairs(jungleMinions.objects) do
		if jungleMinion ~= nil then
			if Menu.Jungleclear.useClearQ and skills.SkillQ.ready and ValidTarget(jungleMinion, skills.SkillQ.range) then
				CastSpell(_Q, jungleMinion.x, jungleMinion.z)
			end
			if Menu.Jungleclear.useClearW and skills.SkillW.ready and ValidTarget(jungleMinion, skills.SkillW.range) then
				CastSpell(_W, jungleMinion)
			end
			if Menu.Jungleclear.useClearE and skills.SkillE.ready and ValidTarget(jungleMinion, skills.SkillE.range) then
				CastSpell(_W, jungleMinion)
			end
		end
	end
end

function AutoLevel()
	local qL, wL, eL, rL = player:GetSpellData(_Q).level + qOff, player:GetSpellData(_W).level + wOff, player:GetSpellData(_E).level + eOff, player:GetSpellData(_R).level + rOff
	if qL + wL + eL + rL < player.level then
		local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4, }
		local level = { 0, 0, 0, 0 }
		for i = 1, player.level, 1 do
			level[abilitySequence[i]] = level[abilitySequence[i]] + 1
		end
		for i, v in ipairs({ qL, wL, eL, rL }) do
			if v < level[i] then LevelSpell(spellSlot[i]) end
		end
	end
end

function KillSteal()
	if Menu.Ads.KS.ignite then
		IgniteKS()
	end
  if  Menu.Ads.KS.KS  then
    KS2()
  end
   
  
  if Menu.Ads.Tower then
   --  OnTowerFocus()
  end
end

-- Auto Ignite get the maximum range to avoid over kill --

function IgniteKS()
	if igniteReady then
		local Enemies = GetEnemyHeroes()
		for i, val in ipairs(Enemies) do
			if ValidTarget(val, 600) then
				if getDmg("IGNITE", val, myHero) > val.health and GetDistance(val) >= Menu.Ads.KS.igniteRange then
					CastSpell(ignite, val)
				end
			end
		end
	end
end

-- Auto Ignite --

function HealthCheck(unit, HealthValue)
	if unit.health > (unit.maxHealth * (HealthValue/100)) then 
		return true
	else
		return false
	end
end

function ItemUsage(target)

	if dfgReady then CastSpell(dfgSlot, target) end
	if youmuuReady then CastSpell(youmuuSlot, target) end
	if bilgeReady then CastSpell(bilgeSlot, target) end
	if bladeReady then CastSpell(bladeSlot, target) end
	if divineReady then CastSpell(divineSlot, target) end

end

-- Change skin function, made by Shalzuth
function GenModelPacket(champ, skinId)
	p = CLoLPacket(0x97)
	p:EncodeF(myHero.networkID)
	p.pos = 1
	t1 = p:Decode1()
	t2 = p:Decode1()
	t3 = p:Decode1()
	t4 = p:Decode1()
	p:Encode1(t1)
	p:Encode1(t2)
	p:Encode1(t3)
	p:Encode1(bit32.band(t4,0xB))
	p:Encode1(1)--hardcode 1 bitfield
	p:Encode4(skinId)
	for i = 1, #champ do
		p:Encode1(string.byte(champ:sub(i,i)))
	end
	for i = #champ + 1, 64 do
		p:Encode1(0)
	end
	p:Hide()
	RecvPacket(p)
end



    
function skinChanged()
	return Menu.Ads.VIP.skin1 ~= lastSkin
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
 radius = radius or 300
 quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
 quality = 2 * math.pi / quality
 radius = radius*.92
 local points = {}
 for theta = 0, 2 * math.pi + quality, quality do
  local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
  points[#points + 1] = D3DXVECTOR2(c.x, c.y)
 end
 DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
 local vPos1 = Vector(x, y, z)
 local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
 local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
 local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
 if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
  self:DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
 end
end

function CircleDraw(x,y,z,radius, color)
	self:DrawCircle2(x, y, z, radius, color)
end--[[ Kill Text ]]--
TextList = {"Harass him", "Q", "W", "E", "ULT HIM !", "Items", "All In", "Skills Not Ready"}
KillText = {}
colorText = ARGB(229,229,229,0)
_G.ShowTextDraw = true

-- Damage Calculation Thanks Skeem for the base --

function DamageCalculation()
  for i=1, heroManager.iCount do
    local enemy = heroManager:GetHero(i)
    if ValidTarget(enemy) and enemy ~= nil then
      qDmg = getDmg("Q", enemy,myHero)
      wDmg = getDmg("W", enemy,myHero)
      eDmg = getDmg("E", enemy,myHero)
      rDmg = getDmg("R", enemy,myHero)
      dfgDmg = getDmg("DFG", enemy, myHero)

      if not skills.SkillQ.ready and not skills.SkillW.ready and not skills.SkillE.ready and not skills.SkillR.ready then
        KillText[i] = TextList[8]
        return
      end

      if enemy.health <= qDmg then
        KillText[i] = TextList[2]
      elseif enemy.health <= wDmg then
        KillText[i] = TextList[3]
      elseif enemy.health <= eDmg then
        KillText[i] = TextList[4]
      elseif enemy.health <= rDmg then
        KillText[i] = TextList[5]
      elseif enemy.health <= qDmg + wDmg then
        KillText[i] = TextList[2] .."+".. TextList[3]
      elseif enemy.health <= qDmg + eDmg then
        KillText[i] = TextList[2] .."+".. TextList[4]
      elseif enemy.health <= qDmg + rDmg then
        KillText[i] = TextList[2] .."+".. TextList[5]
      elseif enemy.health <= wDmg + eDmg then
        KillText[i] = TextList[3] .."+".. TextList[4]
      elseif enemy.health <= wDmg + rDmg then
        KillText[i] = TextList[3] .."+".. TextList[5]
      elseif enemy.health <= eDmg + rDmg then
        KillText[i] = TextList[4] .."+".. TextList[5]
      elseif enemy.health <= qDmg + wDmg + eDmg then
        KillText[i] = TextList[2] .."+".. TextList[3] .."+".. TextList[4]
      elseif enemy.health <= qDmg + wDmg + eDmg + rDmg then
        KillText[i] = TextList[2] .."+".. TextList[3] .."+".. TextList[4] .."+".. TextList[5]
      elseif enemy.health <= dfgDmg + ((qDmg + wDmg + eDmg + rDmg) + (0.2 * (qDmg + wDmg + eDmg + rDmg))) then
        KillText[i] = TextList[7]
      else
        KillText[i] = TextList[1]
      end
    end
  end
end

function OnDraw()    if not myHero.dead then
        if Menu.drawings.drawAA then DrawCircle(myHero.x, myHero.y, myHero.z, Ranges.AA, ARGB(25 , 9, 12, 102)) end
        if Menu.drawings.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillQ.range, ARGB(25 , 255, 0, 0)) end
        if Menu.drawings.drawW then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillW.range, ARGB(25 , 255, 128, 0)) end
        if Menu.drawings.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillE.range, ARGB(25 , 145, 0, 161)) end
        if Menu.drawings.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, skills.SkillR.range, ARGB(25 , 255, 255, 0)) end
    end
if _G.ShowTextDraw then
    for i = 1, heroManager.iCount do
	    local enemy = heroManager:GetHero(i)
	    if ValidTarget(enemy) and enemy ~= nil then
	      local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z)) --(Credit to Zikkah)
	      local PosX = barPos.x - 35
	      local PosY = barPos.y - 10
	      if KillText[i] ~= 10 then
	        DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
	      else
	        DrawText(TextList[KillText[i]] .. string.format("%4.1f", ((enemy.health - (qDmg + pDmg + eDmg + itemsDmg)) * (1/rDmg)) * 2.5) .. "s = Kill", 16, PosX, PosY, colorText)
	      end
	    end
	end
end
if not myHero.dead and target ~= nil and	target.team ~= myHero.team and target.type ~= myHero.type then 
		--	if Settings.drawing.text then 
				DrawText3D("Focus This Bitch!",target.x-100, target.y-50, target.z, 20, 0xFFFF9900) --0xFF9900
			end
end

ulti = false
ultitime = math.huge
function OnProcessSpell(unit, spell)

end



  
 --[[ if p.header == 0x00B5 then p:Block() end
end

function OnSendPacket(p)
  print(string.format('%02X', p.header))
end--]]
--[[function OnSendPacket(p)
  print(string.format('%02X', p.header))
  if p.header == 0x00D1 then 
    p:Block()
    end
end
--]]


function OnSendPacket(packet)


end
--[[
function CastQ(unit,pos)
    if target ~= nil and not ult then 
      if GetDistance(pos) < skills.SkillQ.range and skills.SkillQ.ready then

   
                CastSpell(_Q, pos.x, pos.z)
              --  print("774")
            end
    end
  end
  
function GetQPos(unit, pos)
        qPos = pos
end--]]


 function DoubleClick()
 
 end
 
 function DoubleClick2()
 
  end


  Kip = false
  --[[
function OnTowerFocus(tower, unit)
  unit = GetTarget()
  if unit ~= nil then
       if tower.team == myHero.team then
         if unit.team ~= myHero.team then
             if target ~= nil and ValidTarget(target, skills.SkillR.range) and skills.SkillR.ready and target.type == myHero.type and target.team ~= myHero.team then
      CastSpell(_R, target)
    end
       end
     end
  end
  end--]]
  --[[
  function UnitAtTower(unit,offset)
  for i, turret in pairs(GetTurrets()) do
    if turret ~= nil then
      if turret.team == myHero.team then
        if GetDistance(unit, turret) <= turret.range+offset then
          return true
        end
      end
    end
  end
  return false
end

function TurretStun()
  for _, enemy in ipairs(GetEnemyHeroes()) do
    if UnitAtTower(enemy, 0) and GetDistanceSqr(enemy) <= skills.SkillR.range^2 then
      CastSpell(_R, enemy)
    end
  end
end
--]]

lastLeftClick = 0 
--- thxx too klokje!
kijk = 0
tijd = math.huge
click = 0
time = math.huge
function OnWndMsg(Msg, Key)
	
	
	if Msg == WM_LBUTTONUP then
        
      
		local minD = 0
		local target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) and unit.type == myHero.type then
				if GetDistance(unit, mousePos) <= minD or target == nil then
					minD = GetDistance(unit, mousePos)
					target = unit
         
    
    
    if target and minD < 115 then
        click = click + 1
        time = GetGameTimer()
			if SelectedTarget and target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = target
        pis = true
        kut = GetGameTimer()
   
             
          end
			end
		end
  end
  end
      
      end
        
	end

function KS2()
    if target ~= nil and target.type == myHero.type and target.team ~= myHero.team  then
      for i=1, heroManager.iCount do
      local enemy = heroManager:GetHero(i)
        if ValidTarget(enemy) and enemy ~= nil then
        qDmg = getDmg("Q", enemy,myHero)
        eDmg = getDmg("E", enemy,myHero)
        rDmg = getDmg("R", enemy,myHero)
        wDmg = getDmg("W", enemy,myHero)
      
          if target ~= nil and skills.SkillQ.ready and ValidTarget(target, skills.SkillQ.range) and target.health < qDmg then
            if Menu.BrandCombo.qSet.useQ and Menu.ProdSettings.SelectProdiction == 1 then
          --ProdQ:GetPredictionCallBack(target, CastQ)
            DevineQ()
            elseif Menu.ProdSettings.SelectProdiction == 2 then
              if Menu.BrandCombo.qSet.useQ and ValidTarget(target, skills.SkillQ.range) and skills.SkillQ.range then
                local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, skills.SkillQ.delay, skills.SkillQ.width, skills.SkillQ.range, skills.SkillQ.speed, myHero, true)
                if HitChance >= 2 and GetDistance(CastPosition) < 1050 then
                  CastSpell(_Q, CastPosition.x, CastPosition.z)
                end
              end
            end
          end

          if skills.SkillE.ready and ValidTarget(target, skills.SkillE.range) and target.health < eDmg then
            CastSpell(_E, target)
          end
          if target ~= nil and ValidTarget(target, skills.SkillW.range) and skills.SkillW.ready and target.health <= wDmg then
            if Menu.ProdSettings.SelectProdiction == 2 then
   
        AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, skills.SkillW.delay, skills.SkillW.width, skills.SkillW.range, skills.SkillW.speed, myHero)
              if GetDistance(AOECastPosition) <= skills.SkillW.range and MainTargetHitChance >= 2 then
              Packet("S_CAST", {spellId = _W, fromX = AOECastPosition.x, fromY = AOECastPosition.z, toX = AOECastPosition.x, toY = AOECastPosition.z}):send()
              end
            elseif Menu.ProdSettings.SelectProdiction == 1 then
            DevineW()
   
            end
          end 



             end
            end
          end
        end
  
Passive = false
function OnApplyBuff(source, unit, buff)
  if buff and unit.type == myHero.type and unit.team ~= myHero.team then 
    if buff.name:find("brandablaze") then
      Passive = true
      naam = unit.charName
  end
end
end
function OnRemoveBuff(unit, buff)
  if buff and unit.type == myHero.type and unit.team ~= myHero.team then
    if buff.name:find("brandablaze") then
      Passive = false
      naam = nil
  end
  end
end

function CastQ()
  if target ~= nil then
  QPos, QHitChance = HPred:GetPredict("Q", target, myHero)
  
  if QHitChance >= 2 then
  
    if VIP_USER then
      Packet("S_CAST", {spellId = _Q, toX = QPos.x, toY = QPos.z, fromX = QPos.x, fromY = QPos.z}):send()
    else
      CastSpell(_Q, QPos.x, QPos.z)
    end
    
  end
  
end
end

function CastW()
  if target ~= nil then
  WPos, WHitChance = HPred:GetPredict("W", target, myHero)
  
  if WHitChance >= 2 then
  
    if VIP_USER then
      Packet("S_CAST", {spellId = _W, toX = WPos.x, toY = WPos.z, fromX = WPos.x, fromY = WPos.z}):send()
    else
      CastSpell(_W, WPos.x, WPos.z)
    end
    
  end
  
end
end
