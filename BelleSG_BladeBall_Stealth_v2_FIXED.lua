-- Belle.sg | Blade Ball - Obsidian UI [STEALTH MODE v2]
-- by ruey
-- [MODIFIED] Manual spam block + randomizer + stealth parry + hybrid mode

repeat task.wait() until game:IsLoaded()

-- ================================================
-- STEALTH WRAPPER & ANTI-DETECTION
-- ================================================
local function stealthWait(ms)
    local s = tick()
    while tick()-s < (ms/1000) do task.wait() end
end

pcall(function()
    if game:GetService("RunService"):IsStudio() then return end
    stealthWait(math.random(300, 800)) -- Random initial delay
end)

-- Cleanup old GUIs
local function cleanup()
    local names = {"WindUI","SsinHubGui","SpamCenter","BelleSgBladeBall","ObsidianUI"}
    for _,name in pairs(names) do
        local old = game.CoreGui:FindFirstChild(name)
        if old then old:Destroy() end
    end
end
cleanup()

-- Services
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local StatsService     = game:GetService("Stats")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local VIM              = game:GetService("VirtualInputManager")

-- State
local remote           = nil
local f_raw            = nil
local c                = {nil,nil,nil,nil,nil,nil,nil}
local AutoParry        = false
local AnimFix          = false
local ShowPeak         = false
local ManualSpamEnabled= false
local TriggerBot       = false
local AutoSpam         = false
local CooldownProtect  = false
local Headless         = false
local spamActive       = false
local triggerSpamActive= false
local peakVel          = 0
getgenv().AbilityESP   = false
getgenv().AvatarInput  = ""

-- STEALTH MODE VARS
local stealthMode      = true  -- Enable stealth by default
local randomMissRate   = 0.35  -- 35% intentional miss rate (looks human)
local baseSpamInterval = 1/875
local delayVariation   = {50, 200}  -- ms delay randomization
local lastSpamTime     = 0
local lastTrigSpamTime = 0
local lastClashSpamTime= 0
local lastAbilityTime  = 0
local abilityCooldown  = 0.8
local ClashRange       = 14
local spamInterval     = baseSpamInterval
local remoteHooked     = false
local parried_balls    = {}
local billboardLabels  = {}
local abilityActive    = false

local SwordAPI      = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SwordAPI")
local lastplayedd   = 0
local bypasscd      = false
local AnimationDelay= 1
local AnimationCache= {}
local Grab_Parry    = nil

-- Helper functions
local function GetCharacter() return LocalPlayer.Character end
local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end
local function StopAnimation(track)
    track:Stop(track:GetAttribute("StopFadeTime") or 0.1)
end
local function PlayGrabAnimation(track)
    track:Play(track:GetAttribute("PlayFadeTime") or 0, track:GetAttribute("PlayWeight") or 1, track:GetAttribute("PlaySpeed") or 1)
end
local function GetParryAnimation()
    local char = GetCharacter()
    if not char then return nil end
    local currentSword = char:GetAttribute("CurrentlyEquippedSword")
    if not currentSword then return SwordAPI.Collection.Default:FindFirstChild("GrabParry") end
    if AnimationCache[currentSword] then return AnimationCache[currentSword] end
    local ok, swordData = pcall(function()
        return ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(currentSword)
    end)
    if not ok or type(swordData) ~= "table" then
        AnimationCache[currentSword] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        return AnimationCache[currentSword]
    end
    for _, obj in pairs(SwordAPI.Collection:GetChildren()) do
        if obj.Name == swordData.AnimationType then
            local anim = obj:FindFirstChild("GrabParry") or obj:FindFirstChild("Grab")
            if anim then AnimationCache[currentSword] = anim; return anim end
        end
    end
    AnimationCache[currentSword] = SwordAPI.Collection.Default:FindFirstChild("GrabParry")
    return AnimationCache[currentSword]
end
local function PlayParry_Animation()
    local humanoid = GetHumanoid()
    if not humanoid then return end
    local animation = GetParryAnimation()
    if not animation then return end
    for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        if track.Name == "GrabParry" or track.Name == "Grab" then
            track.TimePosition = 0; StopAnimation(track)
        elseif track.Name == "SuccessParry" or track.Name == "Success" then
            StopAnimation(track)
        end
    end
    Grab_Parry = humanoid.Animator:LoadAnimation(animation)
    PlayGrabAnimation(Grab_Parry)
end
local function SpamParry_Animation()
    if (os.clock() - lastplayedd) >= (AnimationDelay - 0.8) or bypasscd then
        lastplayedd = os.clock()
        bypasscd = false
        PlayParry_Animation()
    end
end

pcall(function()
    ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
        bypasscd = true
        local humanoid = GetHumanoid()
        if humanoid then
            for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
                if track.Name == "GrabParry" or track.Name == "Grab" then StopAnimation(track) end
            end
        end
    end)
end)

local function applyHeadless(char, enabled)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = enabled and 1 or 0
        for _, v in pairs(head:GetChildren()) do
            if v:IsA("Decal") or v:IsA("SpecialMesh") then
                v.Transparency = enabled and 1 or 0
            end
        end
    end
    for _, acc in pairs(char:GetChildren()) do
        if acc:IsA("Accessory") then
            local handle = acc:FindFirstChild("Handle")
            if handle then
                local isHead = handle:FindFirstChild("HatAttachment")
                    or handle:FindFirstChild("HairAttachment")
                    or handle:FindFirstChild("FaceFrontAttachment")
                    or handle:FindFirstChild("FaceBackAttachment")
                    or handle:FindFirstChild("NeckAttachment")
                if isHead then
                    handle.Transparency = enabled and 1 or 0
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if Headless then applyHeadless(char, true) end
end)

-- Remote hook with stealth
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
    if key == "FireServer" or key == "InvokeServer" then
        return function(instance, ...)
            local args = {...}
            if #args >= 4 then
                remoteHooked = true
                remote = instance
                f_raw = old(instance, "FireServer")
                for i = 1, 7 do c[i] = args[i] end
            end
            return old(self, key)(instance, ...)
        end
    end
    return old(self, key)
end)
setreadonly(mt, true)

local function findBall()
    local bc = workspace:FindFirstChild("Balls")
    if bc then
        local b = bc:GetChildren()[1]
        if b and b:IsA("BasePart") then return b end
    end
    for _,v in ipairs(workspace:GetChildren()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            if n:find("ball") then return v end
        end
    end
    local folders = {"Lobby","Training","Practice","Map","Game"}
    for _,fname in ipairs(folders) do
        local folder = workspace:FindFirstChild(fname)
        if folder then
            for _,v in ipairs(folder:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("ball") then return v end
            end
        end
    end
    return nil
end

-- STEALTH PARRY FUNCTION (with randomizer)
local function fireParryWithStealth()
    if not stealthMode then
        -- Normal mode - fire immediately
        if remote and f_raw then
            task.spawn(function()
                pcall(function() f_raw(remote, c[1], c[2], c[3], c[4]) end)
            end)
        end
        return
    end
    
    -- Stealth mode: add random delay + intentional misses
    local shouldMiss = math.random() < randomMissRate
    if shouldMiss then
        return  -- Don't fire, intentional miss (looks human)
    end
    
    -- Add random delay (50-200ms)
    local randomDelay = (math.random(delayVariation[1], delayVariation[2]) / 1000)
    task.delay(randomDelay, function()
        if remote and f_raw then
            task.spawn(function()
                pcall(function() f_raw(remote, c[1], c[2], c[3], c[4]) end)
            end)
        end
    end)
end

local function fireAbility()
    if not abilityActive and remote and f_raw and c[5] then
        abilityActive = true
        task.spawn(function()
            pcall(function() f_raw(remote, c[1], c[2], c[3], c[5]) end)
        end)
        task.wait(0.5)
        abilityActive = false
    end
end

-- ================================================
-- RAYFIELD UI LIBRARY
-- ================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Belle.sg | Blade Ball",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by ruey",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Belle.sg",
        FileName = "BladeballConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local function N(title, text)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = 4,
        Image = 4483345998
    })
end

-- ── COMBAT TAB ─────────────────────────────────────
local CombatTab = Window:CreateTab("Combat", 4483345998)
local CombatSection = CombatTab:CreateSection("Parry Settings")

CombatSection:CreateToggle({
    Name = "Auto Parry",
    CurrentValue = false,
    Flag = "AutoParryToggle",
    Callback = function(Value)
        AutoParry = Value
        N("Combat", AutoParry and "Auto Parry ON" or "Auto Parry OFF")
    end
})

CombatSection:CreateToggle({
    Name = "Manual Spam Block [E Key]",
    CurrentValue = false,
    Flag = "ManualSpamToggle",
    Callback = function(Value)
        ManualSpamEnabled = Value
        N("Combat", ManualSpamEnabled and "Manual Spam ON (Press E)" or "Manual Spam OFF")
    end
})

CombatSection:CreateToggle({
    Name = "Trigger Bot",
    CurrentValue = false,
    Flag = "TriggerBotToggle",
    Callback = function(Value)
        TriggerBot = Value
        N("Combat", TriggerBot and "Trigger Bot ON" or "Trigger Bot OFF")
    end
})

CombatSection:CreateToggle({
    Name = "Auto Clash Spam",
    CurrentValue = false,
    Flag = "AutoSpamToggle",
    Callback = function(Value)
        AutoSpam = Value
        N("Combat", AutoSpam and "Auto Clash ON" or "Auto Clash OFF")
    end
})

CombatSection:CreateToggle({
    Name = "Ability Cooldown Protect",
    CurrentValue = false,
    Flag = "CooldownProtectToggle",
    Callback = function(Value)
        CooldownProtect = Value
        N("Combat", CooldownProtect and "Cooldown Protect ON" or "Cooldown Protect OFF")
    end
})

CombatSection:CreateSlider({
    Name = "Spam Speed",
    Min = 400,
    Max = 1500,
    Default = 875,
    Color = Color3.fromRGB(255, 85, 127),
    Increment = 1,
    Suffix = "Hz",
    Callback = function(Value)
        spamInterval = 1 / Value
    end
})

-- ── UTILITY TAB ────────────────────────────────────
local UtilityTab = Window:CreateTab("Utility", 4483345998)
local UtilitySection = UtilityTab:CreateSection("Features")

UtilitySection:CreateToggle({
    Name = "Show Peak Velocity",
    CurrentValue = false,
    Flag = "ShowPeakToggle",
    Callback = function(Value)
        ShowPeak = Value
    end
})

UtilitySection:CreateToggle({
    Name = "Animation Fix",
    CurrentValue = false,
    Flag = "AnimFixToggle",
    Callback = function(Value)
        AnimFix = Value
    end
})

UtilitySection:CreateToggle({
    Name = "Headless Mode",
    CurrentValue = false,
    Flag = "HeadlessToggle",
    Callback = function(Value)
        Headless = Value
        if Headless then
            local char = LocalPlayer.Character
            if char then applyHeadless(char, true) end
        else
            local char = LocalPlayer.Character
            if char then applyHeadless(char, false) end
        end
        N("Utility", Headless and "Headless ON" or "Headless OFF")
    end
})

UtilitySection:CreateToggle({
    Name = "Stealth Mode [RECOMMENDED]",
    CurrentValue = true,
    Flag = "StealthModeToggle",
    Callback = function(Value)
        stealthMode = Value
        N("Utility", stealthMode and "Stealth Mode ON (Safer)" or "Stealth Mode OFF")
    end
})

UtilitySection:CreateSlider({
    Name = "Miss Rate % (Stealth)",
    Min = 10,
    Max = 60,
    Default = 35,
    Color = Color3.fromRGB(255, 85, 127),
    Increment = 1,
    Suffix = "%",
    Callback = function(Value)
        randomMissRate = Value / 100
        N("Utility", "Miss Rate: " .. Value .. "%")
    end
})

-- ── AVATAR TAB ─────────────────────────────────────
local AvatarTab = Window:CreateTab("Avatar", 4483345998)
local AvatarSection = AvatarTab:CreateSection("Cosmetics")

AvatarSection:CreateInput({
    Name = "Shirt ID",
    CurrentValue = "",
    PlaceHolder = "Enter shirt ID",
    RemoveTextAfterFocusLost = false,
    Flag = "ShirtIdInput",
    Callback = function(Text)
        getgenv().AvatarInput = Text
    end
})

AvatarSection:CreateButton({
    Name = "Apply Shirt",
    Callback = function()
        task.spawn(function()
            local id = getgenv().AvatarInput
            if id == "" then N("Avatar","Invalid ID!") return end
            local char = LocalPlayer.Character; if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                N("Avatar","Shirt applied: "..id)
            end
        end)
    end
})

AvatarSection:CreateButton({
    Name = "Reset Avatar",
    Callback = function()
        task.spawn(function()
            local char = LocalPlayer.Character; if not char then return end
            local ok,desc = pcall(function()
                return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
            end)
            if ok and desc then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function() hum:ApplyDescription(desc) end)
                    N("Avatar","Reset!")
                    if Headless then task.wait(0.3); applyHeadless(char, true) end
                end
            else N("Avatar","Reset failed!") end
        end)
    end
})

-- ── SETTINGS TAB ───────────────────────────────────
local SettingsTab = Window:CreateTab("Settings", 4483345998)
local SettingsSection = SettingsTab:CreateSection("Information")

SettingsSection:CreateLabel("Belle.sg | Blade Ball")
SettingsSection:CreateLabel("Stealth Edition v2")
SettingsSection:CreateLabel("by ruey")
SettingsSection:CreateLabel("")
SettingsSection:CreateLabel("RightCtrl — toggle UI")
SettingsSection:CreateLabel("E key — Manual Spam")
SettingsSection:CreateLabel("")
SettingsSection:CreateLabel("⚠️ Stealth Mode: ~1-2 weeks")
SettingsSection:CreateLabel("⚠️ Use at own risk")
SettingsSection:CreateLabel("⚠️ Check Discord for updates")

-- ── INPUT HANDLING ──────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        Window:Toggle()
    end
    
    if input.KeyCode == Enum.KeyCode.E then
        if ManualSpamEnabled then
            spamActive = true
            SpamStatus:Set("FIRING")
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.E then
        spamActive = false
        SpamStatus:Set("READY")
    end
end)

-- ── HEARTBEAT LOOP ──────────────────────────────────
local lastBallCheck  = 0
local cachedBall     = nil
local lastHrpCache   = 0
local cachedHrp      = nil
local lastAliveCache = 0
local cachedAlive    = nil
local frameCount     = 0

RunService.Heartbeat:Connect(function()
    local now = tick()
    frameCount = frameCount + 1

    if now - lastHrpCache > 0.15 then
        local ch = LocalPlayer.Character
        cachedHrp = ch and ch:FindFirstChild("HumanoidRootPart")
        lastHrpCache = now
    end
    local hrp = cachedHrp
    if not hrp then return end

    if now - lastBallCheck > 0.08 then
        cachedBall = findBall()
        lastBallCheck = now
    end

    if now - lastAliveCache > 0.3 then
        cachedAlive = workspace:FindFirstChild("Alive")
        lastAliveCache = now
    end

    local ball = cachedBall
    local char = LocalPlayer.Character

    if ball and ball:IsA("BasePart") then
        if ShowPeak and frameCount % 3 == 0 then
            local vel = ball.Velocity.Magnitude
            peakVel = math.max(peakVel, vel)
        end

        if AutoParry and remote and f_raw then
            local bID = ball:GetDebugId()
            if not parried_balls[bID] then
                local target = ball:GetAttribute("target")
                    or ball:GetAttribute("Target")
                    or ball:GetAttribute("targetPlayer")
                    or ball:GetAttribute("TargetPlayer")

                local isMyBall = false
                if target then
                    isMyBall = (target == LocalPlayer.Name)
                        or (target == LocalPlayer.UserId)
                        or (target == tostring(LocalPlayer.UserId))
                else
                    local dist = (hrp.Position - ball.Position).Magnitude
                    if dist <= 30 then
                        local vel = ball.Velocity
                        if vel.Magnitude > 1 then
                            local dir = (hrp.Position - ball.Position).Unit
                            local dot = dir:Dot(vel.Unit)
                            isMyBall = (dot > 0.4)
                        end
                    end
                end

                if isMyBall then
                    local Zoomies = ball:FindFirstChild("zoomies")
                    local shouldParry = false
                    if Zoomies then
                        local Vel = Zoomies.VectorVelocity
                        local Dir = (hrp.Position - ball.Position).Unit
                        local Dot = Dir:Dot(Vel.Unit)
                        local pingOk,pingVal = pcall(function()
                            return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                        end)
                        local Ping = (pingOk and pingVal or 80)/1000
                        if Dot >= (0.3 - Ping*0.5) then
                            local dist = (hrp.Position-ball.Position).Magnitude
                            local threshold = Vel.Magnitude*(Ping+0.016)*8*0.43
                            if dist <= threshold or dist <= 9 then
                                shouldParry = true
                            end
                        end
                    else
                        local dist = (hrp.Position-ball.Position).Magnitude
                        local vel = ball.Velocity.Magnitude
                        if dist <= 12 and vel > 1 then
                            shouldParry = true
                        end
                    end

                    if shouldParry then
                        fireParryWithStealth()
                        parried_balls[bID] = true
                        task.spawn(function()
                            if target then
                                ball:GetAttributeChangedSignal("target"):Wait()
                            else
                                task.wait(1.5)
                            end
                            parried_balls[bID] = nil
                        end)
                    end
                end
            end
        end

        if CooldownProtect then
            local target = ball:GetAttribute("target") or ball:GetAttribute("Target")
                or ball:GetAttribute("targetPlayer") or ball:GetAttribute("TargetPlayer")
            local isMyBall = target and ((target==LocalPlayer.Name)
                or (target==LocalPlayer.UserId)
                or (target==tostring(LocalPlayer.UserId)))
            if isMyBall then
                if (hrp.Position-ball.Position).Magnitude<=25
                and now-lastAbilityTime>=abilityCooldown then
                    lastAbilityTime=now; task.spawn(fireAbility)
                end
            end
        end

        if TriggerBot then
            local dist = (hrp.Position-ball.Position).Magnitude
            local v2 = ball.Velocity.Magnitude
            local coming = v2>1 and ball.Velocity.Unit:Dot((hrp.Position-ball.Position).Unit)>0.3
            if coming and dist<=35 then
                if not triggerSpamActive then
                    triggerSpamActive=true
                    TrigStatus:Set("FIRING")
                end
            elseif triggerSpamActive then
                triggerSpamActive=false
                TrigStatus:Set("ON")
            end
        end
    else
        if ShowPeak and frameCount%3==0 then end
        if triggerSpamActive then
            triggerSpamActive=false
            TrigStatus:Set("ON")
        end
    end

    if TriggerBot and triggerSpamActive and remote and f_raw then
        if now-lastTrigSpamTime>=spamInterval then
            lastTrigSpamTime=now; fireParryWithStealth()
        end
    end

    if ManualSpamEnabled and spamActive and remote and f_raw then
        if now-lastSpamTime>=spamInterval then
            lastSpamTime=now; fireParryWithStealth()
        end
    end

    if AutoSpam and remote and f_raw and cachedAlive and frameCount%3==0 then
        local nearEnemy=false
        for _,v in ipairs(cachedAlive:GetChildren()) do
            if v~=char and v.PrimaryPart then
                if (hrp.Position-v.PrimaryPart.Position).Magnitude<=ClashRange then
                    nearEnemy=true; break
                end
            end
        end
        if nearEnemy and now-lastClashSpamTime>=spamInterval then
            lastClashSpamTime=now; fireParryWithStealth()
        end
    end
end)

-- Remote hook notification (stealthed)
task.spawn(function()
    while not remoteHooked do task.wait(0.5) end
    pcall(function()
        N("Belle.sg","Remote hooked — Stealth ready!")
    end)
end)

task.wait(1)
Rayfield:Notify({
    Title = "Belle.sg Blade Ball [STEALTH v2]",
    Content = "Loaded! RightCtrl = toggle | Miss Rate ~35% | Delay 50-200ms",
    Duration = 5,
    Image = 4483345998
})
