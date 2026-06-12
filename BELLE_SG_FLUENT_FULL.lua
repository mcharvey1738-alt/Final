-- ============================================================
-- BELLE.SG | FLUENT UI MODDED FULL CONVERSION
-- Diesel n' Steel | by Ruey
-- ============================================================

-- DUPLICATE RUN GUARD
do
    if not getgenv().__BELLE_SG_LIVE then
        getgenv().__BELLE_SG_LIVE = true
    else
        error("", 0)
    end
end

-- ============================================================
-- SERVICES
-- ============================================================
local TweenService      = game:GetService("TweenService")
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local CoreGui           = game:GetService("CoreGui")
local RunService        = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local LOGO_ASSET  = "rbxassetid://74730846535909"

-- ============================================================
-- FLUENT UI MODDED LOAD & SETUP
-- ============================================================
local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentPro"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ============================================================
-- XENON GRADIENT BACKGROUND
-- ============================================================
task.spawn(function()
    local bg = Instance.new("ScreenGui")
    bg.Name = "BelleSgXenonBG"
    bg.ResetOnSpawn = false
    bg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", bg)
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundColor3 = Color3.fromRGB(5, 2, 14)
    frame.BackgroundTransparency = 0
    frame.ZIndex = -5

    -- Xenon gradient overlay
    local grad = Instance.new("UIGradient", frame)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(139, 92, 246)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 5, 25)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(20, 10, 50)),
    })
    grad.Rotation = 135

    -- Floating animated particles
    for i = 1, 20 do
        local particle = Instance.new("Frame", frame)
        local sz = math.random(2, 6)
        particle.Size = UDim2.fromOffset(sz, sz)
        particle.Position = UDim2.fromScale(math.random(0, 100)/100, math.random(0, 100)/100)
        particle.BackgroundColor3 = Color3.fromRGB(math.random(100, 180), math.random(50, 100), math.random(200, 255))
        particle.BackgroundTransparency = math.random(30, 70) / 100
        particle.ZIndex = -4
        Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            while true do
                local endPos = UDim2.fromScale(math.random(0, 100)/100, math.random(0, 100)/100)
                local duration = math.random(8, 16)
                local t = TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position=endPos, BackgroundTransparency=math.random(50, 90)/100})
                t:Play()
                t.Completed:Wait()
            end
        end)
    end

    local watermark = Instance.new("TextLabel", frame)
    watermark.Size = UDim2.fromOffset(220, 30)
    watermark.Position = UDim2.new(1, -228, 1, -36)
    watermark.BackgroundTransparency = 1
    watermark.Text = "BELLE.SG  •  DIESEL n' STEEL"
    watermark.TextColor3 = Color3.fromRGB(139, 92, 246)
    watermark.TextTransparency = 0.4
    watermark.Font = Enum.Font.GothamBold
    watermark.TextSize = 12
    watermark.TextXAlignment = Enum.TextXAlignment.Right
    watermark.ZIndex = -3
end)

-- ============================================================
-- SHARED REMOTES & DATA
-- ============================================================
local _CatNet  = ReplicatedStorage:WaitForChild("CatNet"):WaitForChild("Cat")
local _Remotes = ReplicatedStorage:WaitForChild("Remotes")

local _PARTS = {
    ["BA - 05"]=100,["BA - 01"]=99.93858333333276,["BA - 03"]=100,
    ["T - 02 (R)"]=100,["6-Speed Manual"]=100,["5-Speed Manual"]=100,
    ["CL - 02"]=100,["TO - 01"]=99.77641870652995,["4HK1 Twin Turbo"]=99.96873025011094,
    ["4JJ1"]=100,["4HK1 Single Turbo"]=100,["4BC2"]=100,
    ["4HE1 Single Turbo"]=100,["4-Speed Manual (High Ratio)"]=97.15449046231382,
    ["T - 01 (F)"]=99.89398593012503,["EO - 01"]=99.77641870652995,
    ["T - 05 (R)"]=100,["T - 03 (R)"]=100,["TO - 03"]=100,
    ["EO - 03"]=100,["TO - 05"]=100,["EO - 05"]=100,
    ["4HF1 Twin Turbo"]=100,["TO - 02"]=100,["C - 04"]=100,
    ["BA - 02"]=100,["EO - 04"]=100,["T - 04 (R)"]=100,
    ["C - 02"]=100,["BA - 04"]=100,["T - 02 (F)"]=100,
    ["EO - 02"]=100,["B - 05"]=100,["R - 01"]=99.99369258557067,
    ["BF - 02"]=100,["C - 03"]=100,["B - 03"]=100,
    ["BF - 01"]=99.90000000000009,["T - 05 (F)"]=100,["4-Speed Manual"]=100,
    ["B - 04"]=100,["TO - 04"]=100,["4JK1"]=100,
    ["CL - 01"]=99.99299999999997,["T - 01 (R)"]=99.89398593012503,
    ["R - 02"]=100,["B - 02"]=100,["4BE1"]=100,["T - 04 (F)"]=100,
    ["B - 01"]=99.8333333333332,["T - 03 (F)"]=100,["D - 01"]=99.97349648253126,
    ["C - 01"]=99.89799999999951,
}
local _STATUS = {
    ["FrontTiresHealth"]=99.89398593012503,["DifferentialHealth"]=99.97349648253126,
    ["ClutchHealth"]=99.99299999999997,["TransmissionHealth"]=97.15449046231382,
    ["TransmissionOil"]=99.77641870652995,["CoolantLevel"]=99.89799999999951,
    ["BrakeHealth"]=99.8333333333332,["BrakeFluid"]=99.90000000000009,
    ["RearTiresHealth"]=99.89398593012503,["BatteryHealth"]=99.93858333333276,
    ["RadiatorHealth"]=99.99369258557067,["EngineOil"]=99.77641870652995,
    ["EngineHealth"]=99.96873025011094,
}
local _EQUIPPED = {
    ["Clutch"]="CL - 01",["Brake"]="B - 01",["Differential"]="D - 01",
    ["Battery"]="BA - 01",["Transmission"]="4-Speed Manual (High Ratio)",
    ["Coolant"]="C - 01",["TransmissionOil"]="TO - 01",["RearTires"]="T - 01 (R)",
    ["Radiator"]="R - 01",["BrakeFluid"]="BF - 01",["FrontTires"]="T - 01 (F)",
    ["EngineOil"]="EO - 01",["Engine"]="4HK1 Twin Turbo",
}

-- ============================================================
-- NEON PURPLE THEME
-- ============================================================
Fluent:RegisterCustomTheme("NeonPurple", {
    Accent              = Color3.fromRGB(139, 92, 246),
    AcrylicMain         = Color3.fromRGB(10, 6, 20),
    AcrylicBorder       = Color3.fromRGB(90, 40, 160),
    AcrylicGradient     = ColorSequence.new(Color3.fromRGB(12,7,24), Color3.fromRGB(6,3,14)),
    AcrylicNoise        = 0.75,
    TitleBarLine        = Color3.fromRGB(100, 50, 180),
    Tab                 = Color3.fromRGB(20, 12, 40),
    Element             = Color3.fromRGB(18, 10, 36),
    ElementBorder       = Color3.fromRGB(80, 40, 140),
    InElementBorder     = Color3.fromRGB(130, 70, 210),
    ElementTransparency = 0.82,
    ToggleSlider        = Color3.fromRGB(35, 18, 65),
    ToggleToggled       = Color3.fromRGB(139, 92, 246),
    SliderRail          = Color3.fromRGB(35, 18, 65),
    DropdownFrame       = Color3.fromRGB(16, 9, 32),
    DropdownHolder      = Color3.fromRGB(10, 5, 20),
    DropdownBorder      = Color3.fromRGB(80, 40, 140),
    DropdownOption      = Color3.fromRGB(24, 13, 46),
    Keybind             = Color3.fromRGB(24, 13, 46),
    Input               = Color3.fromRGB(12, 7, 28),
    InputFocused        = Color3.fromRGB(8, 4, 18),
    InputIndicator      = Color3.fromRGB(130, 70, 210),
    Dialog              = Color3.fromRGB(8, 5, 20),
    DialogHolder        = Color3.fromRGB(6, 3, 16),
    DialogHolderLine    = Color3.fromRGB(70, 35, 130),
    DialogButton        = Color3.fromRGB(16, 9, 34),
    DialogButtonBorder  = Color3.fromRGB(80, 40, 140),
    DialogBorder        = Color3.fromRGB(80, 40, 140),
    DialogInput         = Color3.fromRGB(12, 7, 28),
    DialogInputLine     = Color3.fromRGB(130, 70, 210),
    Text                = Color3.fromRGB(245, 230, 255),
    SubText             = Color3.fromRGB(175, 115, 215),
    Hover               = Color3.fromRGB(45, 18, 75),
    HoverChange         = 0.05,
    ShineEnabled        = true,
    StrokeShine         = true,
    StrokeDark          = Color3.fromRGB(60, 30, 120),
    Shine = {
        Speed = 0.5, RotationSpeed = 18,
        ColorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(80,  40, 150)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(139, 92, 246)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(80,  40, 150)),
        }),
    },
    ButtonGradient = {
        Background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 18, 75)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18,  7, 35)),
        }),
        Stroke = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(110, 55, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(139, 92, 246)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(110, 55, 200)),
        }),
    },
})

-- ============================================================
-- FLUENT WINDOW 400x310
-- ============================================================
local Window = Fluent:CreateWindow({
    Title            = "BELLE.SG",
    SubTitle         = "Diesel n' Steel  •  by Ruey",
    TabWidth         = 100,
    Size             = UDim2.fromOffset(400, 310),
    Acrylic          = true,
    Theme            = "NeonPurple",
    MinimizeKey      = Enum.KeyCode.RightControl,
    Search           = false,
    TabLogo          = LOGO_ASSET,
})

-- ============================================================
-- AUTO SUKLI FUNCTION
-- ============================================================
local function startAutoSukli()
    task.spawn(function()
        local RegularFare  = 13
        local DiscountFare = 11
        local numberMap = {
            ["isa"]=1,["dalawa"]=2,["tatlo"]=3,["apat"]=4,["lima"]=5,
            ["anim"]=6,["pito"]=7,["walo"]=8,["siyam"]=9,["sampu"]=10
        }
        local function clickButton(btn)
            if btn and btn.Visible then
                pcall(function()
                    for _, c in pairs(getconnections(btn.MouseButton1Click)) do c:Fire() end
                    for _, c in pairs(getconnections(btn.MouseButton1Down))  do c:Fire() end
                    for _, c in pairs(getconnections(btn.Activated))         do c:Fire() end
                end)
            end
        end
        local playerGui = LocalPlayer.PlayerGui
        while getgenv().AutoSukli do
            task.wait(0.3)
            local activeFrame, paymentFound, isDiscounted, passengerCount = nil, 0, false, 1
            for _, btn in pairs(playerGui:GetDescendants()) do
                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                    local tName = string.lower(btn.Name)
                    local tText = btn:IsA("TextButton") and string.lower(btn.Text) or ""
                    if tName=="take" or tName=="claim" or tText=="take" or tText=="claim" or tText=="kuhanin" then
                        clickButton(btn); task.wait(0.5)
                    end
                end
            end
            for _, gui in pairs(playerGui:GetDescendants()) do
                if gui:IsA("TextLabel") and gui.Visible then
                    local txt = string.lower(gui.Text)
                    if txt:find("payment") or txt:find("bayad") or (tonumber(txt) and tonumber(txt) >= 20) then
                        local parent = gui.Parent
                        if parent and (parent:FindFirstChild("1") or parent:FindFirstChild("5") or parent:FindFirstChild("Give")) then
                            activeFrame = parent
                            local nums = string.match(txt, "%d+")
                            if nums then paymentFound = tonumber(nums) end
                        end
                    end
                end
            end
            if activeFrame and paymentFound > 0 then
                for _, label in pairs(activeFrame:GetDescendants()) do
                    if label:IsA("TextLabel") and label.Visible then
                        local info = string.lower(label.Text)
                        if info:find("senior") or info:find("estudyante") or info:find("student") or info:find("pwd") then isDiscounted = true end
                        for word, count in pairs(numberMap) do if info:find(word) then passengerCount = count end end
                    end
                end
                local farePrice   = isDiscounted and DiscountFare or RegularFare
                local totalCost   = farePrice * passengerCount
                local targetSukli = paymentFound - totalCost
                local currentSukli = targetSukli
                if targetSukli >= 0 then
                    for _, coinValue in ipairs({50,20,10,5,1}) do
                        while currentSukli >= coinValue do
                            local coinBtn = nil
                            for _, btn in pairs(activeFrame:GetDescendants()) do
                                if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and btn.Visible then
                                    if btn.Name==tostring(coinValue) or btn.Text==tostring(coinValue) then coinBtn=btn; break end
                                end
                            end
                            if coinBtn then clickButton(coinBtn); currentSukli=currentSukli-coinValue; task.wait(0.4)
                            else break end
                        end
                    end
                    if currentSukli == 0 then
                        task.wait(0.5)
                        for _, btn in pairs(activeFrame:GetDescendants()) do
                            if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and btn.Visible then
                                local bName = string.lower(btn.Name)
                                if bName=="give" or bName=="check" or bName=="enter" or bName=="confirm" then clickButton(btn); task.wait(1.5); break end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- TELEPORT FUNCTION
-- ============================================================
local function tpJeepOrPlayer(target)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not target then return end
    local targetPos = (target:IsA("BasePart") and target.Position) or target.Position
    local newPos = targetPos + Vector3.new(0, 5, 0)
    if hum and hum.Sit and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
        local jeep = hum.SeatPart:FindFirstAncestorOfClass("Model")
        if jeep and jeep.PrimaryPart then
            for _, v in ipairs(jeep:GetDescendants()) do if v:IsA("BasePart") then v.Anchored=true end end
            jeep:SetPrimaryPartCFrame(CFrame.new(newPos))
            task.wait(0.15)
            for _, v in ipairs(jeep:GetDescendants()) do if v:IsA("BasePart") then v.Anchored=false end end
            return
        end
    end
    hrp.CFrame = CFrame.new(newPos)
end

-- ============================================================
-- TAB 1: MAIN
-- ============================================================
local tabMain = Window:AddTab({ Title = "Main", Icon = "solar/star-bold" })

getgenv().Autocash  = false
getgenv().AutoSukli = false
getgenv().AutoCoins = false

tabMain:AddSection("Auto Sukli & Cash")

tabMain:AddToggle("t_autocash", {
    Title = "Auto Cash",
    Default = false,
    Callback = function(v)
        getgenv().Autocash = v
        if v then
            task.spawn(function()
                while getgenv().Autocash do
                    pcall(function() _CatNet:FireServer({[1]={[1]="3",[2]="BuyJeepney",[3]={["Password"]=774827611,["JeepneyName"]="Sarao Custombuilt Model 2"}}}) end)
                    task.wait(0.1)
                    pcall(function() _Remotes.GetDataStore:InvokeServer() end)
                    task.wait(0.1)
                    pcall(function() _Remotes.CloseCustomize:FireServer({["Password"]=774827611,["NewOwnedParts"]=_PARTS,["NewPartsStatus"]=_STATUS,["JeepneyName"]="Sarao Custombuilt Model 2_#1",["NewEquippedParts"]=_EQUIPPED}) end)
                    task.wait(0.1)
                    pcall(function() _CatNet:FireServer({[1]={[1]="3",[2]="SpawnJeepney",[3]={["Password"]=774827611,["Garage"]=workspace.Map.Misc.Garages["700 Matungao st., Matungao, Bulakan, Bulacan"],["Route"]="Balagtas - Bulakan",["JeepneyName"]="Sarao Custombuilt Model 2_#1"}}}) end)
                    task.wait(0.1)
                    pcall(function() _CatNet:FireServer({[1]={[1]="3",[2]="SellJeepney",[3]={["Index"]="Sarao Custombuilt Model 2_#1"}}}) end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

tabMain:AddToggle("t_autocoins", {
    Title = "Auto Coins",
    Default = false,
    Callback = function(v)
        getgenv().AutoCoins = v
        if v then
            task.spawn(function()
                local _catNet = ReplicatedStorage:WaitForChild("CatNet",9e9):WaitForChild("Cat",9e9)
                local _text   = "Manong sobra ho sukli."
                local function _getPass()
                    local inside = {}
                    local ok, Jeep = pcall(function() return workspace:WaitForChild("Jeepnies",5):WaitForChild(LocalPlayer.Name,5) end)
                    if not ok or not Jeep then return inside end
                    local root = Jeep.PrimaryPart or Jeep:FindFirstChildWhichIsA("BasePart")
                    if not root then return inside end
                    local Passengers = workspace:FindFirstChild("Passengers")
                    if not Passengers then return inside end
                    for _, p in pairs(Passengers:GetChildren()) do
                        local pr = p:FindFirstChild("HumanoidRootPart") or p:FindFirstChild("Head")
                        if pr and (pr.Position - root.Position).Magnitude < 20 then table.insert(inside, p) end
                    end
                    return inside
                end
                task.spawn(function()
                    while getgenv().AutoCoins do
                        local ps = _getPass()
                        if #ps > 0 then
                            local p = ps[math.random(1,#ps)]
                            pcall(function() _catNet:FireServer({[1]={[1]="3",[2]="PassengerChatted",[3]={["Password"]=410501933,["Character"]=p,["Text"]=_text}}}) end)
                        end
                        task.wait(0.5)
                    end
                end)
                while getgenv().AutoCoins do
                    local ps = _getPass()
                    if #ps > 0 then
                        local ok2, J2 = pcall(function() return workspace:WaitForChild("Jeepnies",5):WaitForChild(LocalPlayer.Name,5) end)
                        if ok2 and J2 then
                            local pv = J2:FindFirstChild("PassengerValues")
                            if pv then
                                pcall(function() _catNet:FireServer({[1]={[1]="3",[2]="RecieveCoin",[3]={["Value"]=300,["PassengerValues"]=pv,["Password"]=410501933}}}) end)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

tabMain:AddToggle("t_autosukli", {
    Title = "Auto Sukli",
    Default = false,
    Callback = function(v)
        getgenv().AutoSukli = v
        if v then startAutoSukli() end
    end
})

tabMain:AddDivider()
tabMain:AddSection("Duplicate Coin")

local coinActive = false
tabMain:AddToggle("t_dupecoin", {
    Title = "Duplicate Coin",
    Default = false,
    Callback = function(v) coinActive = v end
})
task.spawn(function()
    while true do
        if coinActive then
            repeat
                if not coinActive then break end
                pcall(function()
                    ReplicatedStorage:WaitForChild("CatNet",9e9):WaitForChild("Cat",9e9):FireServer(unpack({[1]={{[1]="3",[2]="RecieveCoin",[3]={["PassengerValues"]=workspace:WaitForChild("Jeepnies",9e9):WaitForChild(LocalPlayer.Name,9e9):WaitForChild("PassengerValues",9e9),["Password"]=379561105,["Main"]=true,["Value"]=50}}}}))
                end)
                task.wait(0.001)
            until not coinActive
        end
        task.wait(0.001)
    end
end)

tabMain:AddDivider()
tabMain:AddSection("Duplicate Cash")

local dupeSpeed = 2000
tabMain:AddDropdown("dd_dupeamt", {
    Title   = "Duplicate Amount",
    Values  = {"200k","300k","400k","500k"},
    Default = "200k",
    Callback = function(v)
        if v=="200k" then dupeSpeed=2000
        elseif v=="300k" then dupeSpeed=3000
        elseif v=="400k" then dupeSpeed=4000
        elseif v=="500k" then dupeSpeed=5000 end
    end
})

tabMain:AddToggle("t_dupecashgui", {
    Title = "Duplicate Cash GUI",
    Default = false,
    Callback = function(state)
        if not state then
            local ex = CoreGui:FindFirstChild("BELLE_DupeGUI")
            if ex then ex:Destroy() end; return
        end
        local ex = CoreGui:FindFirstChild("BELLE_DupeGUI")
        if ex then ex:Destroy() end
        local SG = Instance.new("ScreenGui"); SG.Name="BELLE_DupeGUI"; SG.Parent=CoreGui; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        local MF = Instance.new("Frame",SG)
        MF.BackgroundTransparency=0.15; MF.BackgroundColor3=Color3.fromRGB(0,0,0)
        MF.Position=UDim2.new(0.5,-120,0.5,-65); MF.Size=UDim2.new(0,240,0,130); MF.BorderSizePixel=0
        Instance.new("UICorner",MF).CornerRadius=UDim.new(0,15)
        local us=Instance.new("UIStroke",MF); us.Thickness=1.5; us.Color=Color3.fromRGB(139,92,246)
        local Tit=Instance.new("TextLabel",MF); Tit.BackgroundTransparency=1
        Tit.Position=UDim2.new(0,0,0.05,0); Tit.Size=UDim2.new(1,0,0.25,0)
        Tit.Font=Enum.Font.FredokaOne; Tit.Text="BELLE.SG Dupe Cash"
        Tit.TextColor3=Color3.fromRGB(255,255,255); Tit.TextSize=20; Tit.ZIndex=2
        local TB=Instance.new("TextButton",MF); TB.BackgroundColor3=Color3.fromRGB(30,30,30)
        TB.Position=UDim2.new(0.075,0,0.45,0); TB.Size=UDim2.new(0.85,0,0.45,0); TB.AutoButtonColor=false; TB.Text=""
        Instance.new("UICorner",TB).CornerRadius=UDim.new(0,12)
        local BL=Instance.new("TextLabel",TB); BL.BackgroundTransparency=1; BL.Size=UDim2.new(1,0,1,0)
        BL.Font=Enum.Font.FredokaOne; BL.Text="OFF"; BL.TextColor3=Color3.fromRGB(255,255,255); BL.TextSize=24; BL.ZIndex=2
        local tog=false; local db=false
        TB.MouseButton1Click:Connect(function()
            if db then return end; db=true; tog=not tog
            if tog then
                BL.Text="ON"; BL.TextColor3=Color3.fromRGB(0,255,0)
                task.spawn(function()
                    while tog and SG and SG.Parent do
                        for i=1,dupeSpeed do
                            if not tog or not SG.Parent then break end
                            pcall(function() ReplicatedStorage:WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack({[1]={{[1]="3",[2]="RecieveCash",[3]={["Value"]=100,["Main"]=true,["Password"]=368557533}}}})) end)
                        end
                        task.wait(0.1)
                    end
                end)
            else BL.Text="OFF"; BL.TextColor3=Color3.fromRGB(255,255,255) end
            task.wait(0.2); db=false
        end)
    end
})

-- ============================================================
-- TAB 2: EXP & REPUTATION
-- ============================================================
local tabExp = Window:AddTab({ Title = "EXP & REP", Icon = "solar/chart-bold" })

local _ExpRemote = ReplicatedStorage:WaitForChild("CatNet"):WaitForChild("Cat")
local _ExpPassengers = workspace:WaitForChild("Passengers", 10)
local _ExpDest = workspace.Map.Misc.PassengerSpawnPoints["Malolos - Bulakan"].BulakanTerminalDropPoint

local function getExpJeep()
    local f = workspace:FindFirstChild("Jeepnies")
    return f and f:FindFirstChild(LocalPlayer.Name)
end
local function getExpSeat(jeep)
    if jeep and jeep:FindFirstChild("Body") then
        local fs = jeep.Body:FindFirstChild("FunctionalStuff")
        if fs and fs:FindFirstChild("Seats") then return fs.Seats:GetChildren()[14] end
    end
end
local function getExpPassenger()
    if not _ExpPassengers then return nil end
    local list = _ExpPassengers:GetChildren()
    if #list > 0 then return list[math.random(1,#list)] end
end

getgenv().AutoExpRep = false
getgenv().DNS_AutoExpMassive = false

tabExp:AddSection("EXP & Reputation Farm")

tabExp:AddToggle("t_exprep", {
    Title = "EXP & Reputation Manual Gain",
    Default = false,
    Callback = function(state)
        getgenv().AutoExpRep = state
        if state then
            task.spawn(function()
                while getgenv().AutoExpRep do
                    pcall(function()
                        local jeep = getExpJeep()
                        local seat = getExpSeat(jeep)
                        if jeep and seat then
                            local payload = {}
                            for i = 1, 100 do
                                local p = getExpPassenger()
                                if p then
                                    table.insert(payload, {[1]="3",[2]="UnloadPassenger",[3]={["Seat"]=seat,["Passenger"]=p,["Password"]=349161876,["Jeepney"]=jeep,["Destination"]=_ExpDest}})
                                end
                            end
                            if #payload > 0 then _ExpRemote:FireServer(payload) end
                        end
                    end)
                    task.wait()
                end
            end)
        end
    end
})

tabExp:AddToggle("t_massiveexp", {
    Title = "Auto EXP & Massive Passenger",
    Default = false,
    Callback = function(state)
        getgenv().DNS_AutoExpMassive = state
        if state then
            task.spawn(function()
                local _net = ReplicatedStorage:WaitForChild("CatNet",9e9):WaitForChild("Cat",9e9)
                while getgenv().DNS_AutoExpMassive do
                    pcall(function()
                        _net:FireServer(unpack({[1]={{[1]="3",[2]="Bark",[3]={["Password"]=622233069,["Route"]="Balagtas - Bulakan",["VoiceOver"]="BALAGTAS",["GiveExp"]=true,["MunicipalityOrCity"]="ToBalagtasTerminalLoadPoint"}}}}))
                    end)
                    task.wait()
                end
            end)
        end
    end
})

tabExp:AddDivider()
tabExp:AddSection("Terminals & Drops")

local teleportPoints = {
    ["Malolos Load"]   = {"Map","Misc","TerminalParts","Malolos - Bulakan","ToMalolosTerminalLoadPoint"},
    ["Bulakan Load"]   = {"Map","Misc","TerminalParts","Malolos - Bulakan","ToBulakanTerminalLoadPoint"},
    ["Guiguinto Load"] = {"Map","Misc","TerminalParts","Guiguinto - Bulakan","ToGuiguintoTerminalLoadPoint"},
    ["Balagtas Load"]  = {"Map","Misc","TerminalParts","Balagtas - Bulakan","ToBalagtasTerminalLoadPoint"},
    ["Malolos Drop"]   = {"Map","Misc","PassengerSpawnPoints","Malolos - Bulakan","MalolosTerminalDropPoint"},
    ["Bulakan Drop"]   = {"Map","Misc","PassengerSpawnPoints","Malolos - Bulakan","BulakanTerminalDropPoint"},
    ["Guiguinto Drop"] = {"Map","Misc","PassengerSpawnPoints","Guiguinto - Bulakan","GuiguintoTerminalDropPoint"},
    ["Balagtas Drop"]  = {"Map","Misc","PassengerSpawnPoints","Balagtas - Bulakan","BalagtasTerminalDropPoint"},
}
for name, path in pairs(teleportPoints) do
    tabExp:AddButton({
        Title = name,
        Callback = function()
            local cur = workspace
            for _, p in ipairs(path) do cur = cur:FindFirstChild(p); if not cur then return end end
            tpJeepOrPlayer(cur)
        end
    })
end

tabExp:AddDivider()
tabExp:AddSection("Deduct Management")

getgenv().AutoDeductCash = false
getgenv().AutoDeductExp  = false
getgenv().AutoDeductCoin = false

tabExp:AddToggle("t_deductcash", {
    Title = "Auto Deduct Cash",
    Default = false,
    Callback = function(state)
        getgenv().AutoDeductCash = state
        if state then
            task.spawn(function()
                while getgenv().AutoDeductCash do
                    pcall(function() _CatNet:FireServer(unpack({{{"3","DeductCash",{Value=1000,Password=649686508}}}})) end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

tabExp:AddToggle("t_deductexp", {
    Title = "Auto Deduct EXP",
    Default = false,
    Callback = function(state)
        getgenv().AutoDeductExp = state
        if state then
            task.spawn(function()
                while getgenv().AutoDeductExp do
                    pcall(function() _CatNet:FireServer(unpack({{{"3","DeductExp",{Value=1000,Password=62199980}}}})) end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

tabExp:AddToggle("t_deductcoin", {
    Title = "Auto Deduct Coin",
    Default = false,
    Callback = function(state)
        getgenv().AutoDeductCoin = state
        if state then
            task.spawn(function()
                while getgenv().AutoDeductCoin do
                    pcall(function()
                        local jeepnies = workspace:FindFirstChild("Jeepnies"); if not jeepnies then return end
                        local myJeep   = jeepnies:FindFirstChild(LocalPlayer.Name); if not myJeep then return end
                        local pv       = myJeep:FindFirstChild("PassengerValues"); if not pv then return end
                        _CatNet:FireServer(unpack({[1]={{[1]="3",[2]="DeductCoin",[3]={["PassengerValues"]=pv,["Password"]=212417354,["Value"]=1000}}}}))
                    end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

-- ============================================================
-- TAB 3: TELEPORT
-- ============================================================
local tabTp = Window:AddTab({ Title = "TELEPORT", Icon = "solar/planet-bold" })

tabTp:AddSection("Malolos - Bulakan")
tabTp:AddButton({ Title="To Malolos Terminal", Callback=function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Malolos - Bulakan"].ToMalolosTerminalLoadPoint) end })
tabTp:AddButton({ Title="To Bulakan Terminal", Callback=function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Malolos - Bulakan"].ToBulakanTerminalLoadPoint) end })
tabTp:AddButton({ Title="Malolos Drop Point",  Callback=function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Malolos - Bulakan"].MalolosTerminalDropPoint) end })
tabTp:AddButton({ Title="Bulakan Drop Point",  Callback=function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Malolos - Bulakan"].BulakanTerminalDropPoint) end })
tabTp:AddDivider()
tabTp:AddSection("Guiguinto - Bulakan")
tabTp:AddButton({ Title="To Guiguinto Terminal", Callback=function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Guiguinto - Bulakan"].ToGuiguintoTerminalLoadPoint) end })
tabTp:AddButton({ Title="To Bulakan Terminal",   Callback=function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Guiguinto - Bulakan"].ToBulakanTerminalLoadPoint) end })
tabTp:AddButton({ Title="Guiguinto Drop Point",  Callback=function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Guiguinto - Bulakan"].GuiguintoTerminalDropPoint) end })
tabTp:AddButton({ Title="Bulakan Drop Point",    Callback=function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Guiguinto - Bulakan"].BulakanTerminalDropPoint) end })
tabTp:AddDivider()
tabTp:AddSection("Balagtas - Bulakan")
tabTp:AddButton({ Title="To Balagtas Terminal", Callback=function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Balagtas - Bulakan"].ToBalagtasTerminalLoadPoint) end })
tabTp:AddButton({ Title="To Bulakan Terminal",  Callback=function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Balagtas - Bulakan"].ToBulakanTerminalLoadPoint) end })
tabTp:AddButton({ Title="Balagtas Drop Point",  Callback=function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Balagtas - Bulakan"].BalagtasTerminalDropPoint) end })
tabTp:AddButton({ Title="Bulakan Drop Point",   Callback=function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Balagtas - Bulakan"].BulakanTerminalDropPoint) end })

-- ============================================================
-- TAB 4: TROLL
-- ============================================================
local tabTroll = Window:AddTab({ Title = "TROLL", Icon = "solar/danger-triangle-bold" })

local flingEnabled = false
local flingAll     = false
local flingTarget  = ""
local flingOrigPos = nil
local bV, bAV

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    if #names == 0 then names = {"No Players"} end
    return names
end
local function GetFlingTarget()
    if flingAll then
        local plys = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(plys, p) end
        end
        if #plys > 0 then return plys[math.random(1,#plys)] end
    else
        for _, p in ipairs(Players:GetPlayers()) do if p.Name==flingTarget then return p end end
    end
end
task.spawn(function()
    while true do
        if flingEnabled or flingAll then
            local target = GetFlingTarget()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
                if not bV or not bV.Parent then
                    bV = Instance.new("BodyVelocity",hrp); bV.MaxForce=Vector3.new(math.huge,math.huge,math.huge); bV.Velocity=Vector3.new(900000,900000,900000)
                end
                if not bAV or not bAV.Parent then
                    bAV = Instance.new("BodyAngularVelocity",hrp); bAV.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); bAV.AngularVelocity=Vector3.new(0,999999,0)
                end
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame
            else
                if not flingAll then if bV then bV:Destroy(); bV=nil end; if bAV then bAV:Destroy(); bAV=nil end end
            end
        else
            if bV then bV:Destroy(); bV=nil end
            if bAV then bAV:Destroy(); bAV=nil end
        end
        task.wait()
    end
end)

tabTroll:AddSection("Fling Controls")
tabTroll:AddDropdown("dd_flingtarget", {
    Title   = "Select Target",
    Values  = getPlayerNames(),
    Default = getPlayerNames()[1],
    Callback = function(v) flingTarget = v end
})
tabTroll:AddButton({
    Title = "Refresh Players",
    Callback = function()
        Fluent:Notify({ Title="Troll", Content="Re-open dropdown for updated players.", Type="Info", Duration=3 })
    end
})
tabTroll:AddToggle("t_flinger", {
    Title = "Enable Flinger",
    Default = false,
    Callback = function(v)
        flingEnabled = v
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if v then if hrp then flingOrigPos=hrp.CFrame end
        else if hrp then hrp.RotVelocity=Vector3.new(0,0,0); hrp.Velocity=Vector3.new(0,0,0); if flingOrigPos then hrp.CFrame=flingOrigPos; flingOrigPos=nil end end end
    end
})
tabTroll:AddToggle("t_flingall", {
    Title = "Fling All",
    Default = false,
    Callback = function(v)
        flingAll = v
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if v then if hrp then flingOrigPos=hrp.CFrame end
        else if hrp then hrp.RotVelocity=Vector3.new(0,0,0); hrp.Velocity=Vector3.new(0,0,0); if flingOrigPos then hrp.CFrame=flingOrigPos; flingOrigPos=nil end end end
    end
})
tabTroll:AddDivider()
tabTroll:AddSection("Audio Troll")
local LoudEngineEnabled = false
tabTroll:AddToggle("t_enginetroll", {
    Title = "Engine Troll",
    Default = false,
    Callback = function(state)
        LoudEngineEnabled = state
        if state then
            task.spawn(function()
                while LoudEngineEnabled do
                    local jeepFolder = workspace:FindFirstChild("Jeepnies")
                    if jeepFolder then
                        for _, jeep in ipairs(jeepFolder:GetChildren()) do
                            local soundRE = jeep:FindFirstChild("SoundRE")
                            if soundRE then
                                for _, sName in ipairs({"EngineRev","EngineIdle"}) do
                                    pcall(function() soundRE:FireServer(unpack({[1]="UpdateSound",[2]={["Pitch"]=2,["SoundName"]=sName,["Volume"]=8888888888}})) end)
                                end
                            end
                        end
                    end
                    task.wait(0.001)
                end
            end)
        end
    end
})

-- ============================================================
-- TAB 5: SHOP
-- ============================================================
local tabShop = Window:AddTab({ Title = "SHOP", Icon = "solar/tag-bold" })

local selectedJeepForParts = "Milwaukee Motor Sport 11 Seater_#1"

tabShop:AddSection("Unlock Parts")
tabShop:AddButton({
    Title = "Unlock All Parts (100%)",
    Callback = function()
        local args = {[1]={[1]={[1]="3",[2]="CloseCustomize",[3]={["Password"]=341958586,["NewOwnedParts"]={
            ["BA - 05"]=100,["BA - 01"]=100,["BA - 03"]=100,["T - 02 (R)"]=100,
            ["6-Speed Manual"]=100,["5-Speed Manual"]=100,["C - 04"]=100,["TO - 01"]=100,
            ["4HK1 Twin Turbo"]=100,["4JJ1"]=100,["BF - 02"]=100,["4BC2"]=100,
            ["4HE1 Single Turbo"]=100,["4-Speed Manual (High Ratio)"]=100,["R - 02"]=100,["EO - 01"]=100,
            ["T - 05 (R)"]=100,["T - 03 (R)"]=100,["TO - 02"]=100,["T - 04 (F)"]=100,
            ["EO - 03"]=100,["B - 04"]=100,["T - 05 (F)"]=100,["CL - 02"]=100,
            ["4JK1"]=100,["BA - 02"]=100,["EO - 04"]=100,["T - 04 (R)"]=100,
            ["C - 02"]=100,["BA - 04"]=100,["T - 02 (F)"]=100,["EO - 02"]=100,
            ["B - 05"]=100,["TO - 05"]=100,["CL - 01"]=100,["C - 03"]=100,
            ["B - 03"]=100,["BF - 01"]=100,["4HF1 Twin Turbo"]=100,["T - 01 (F)"]=100,
            ["TO - 03"]=100,["TO - 04"]=100,["B - 02"]=100,["R - 01"]=100,
            ["T - 01 (R)"]=100,["4-Speed Manual"]=100,["EO - 05"]=100,["4BE1"]=100,
            ["T - 03 (F)"]=100,["B - 01"]=100,["4HK1 Single Turbo"]=100,["D - 01"]=100,["C - 01"]=100,
        },["JeepneyName"]=selectedJeepForParts}}}}
        ReplicatedStorage:WaitForChild("CatNet"):FireServer(unpack(args))
        Fluent:Notify({ Title="Shop", Content="All parts unlocked!", Type="Success", Duration=3 })
    end
})
tabShop:AddDivider()
tabShop:AddSection("Buy Jeepneys")
local jeepNames = {"Milwaukee Motor Sport 11 Seater","Morales 10 Seater","DF Devera Long Model","Sarao Custombuilt Model 2","Xlt Auv 12 Seater"}
local selectedJeep = jeepNames[1]
tabShop:AddDropdown("dd_buyjeep", {
    Title   = "Select Jeepney",
    Values  = jeepNames,
    Default = jeepNames[1],
    Callback = function(v) selectedJeep = v end
})
tabShop:AddButton({
    Title = "Buy Jeepney",
    Callback = function()
        pcall(function() ReplicatedStorage:WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack({{{"3","BuyJeepney",{JeepneyName=selectedJeep,Password=774827611}}}})) end)
        Fluent:Notify({ Title="Shop", Content="Buying "..selectedJeep, Type="Success", Duration=3 })
    end
})
tabShop:AddDivider()
tabShop:AddSection("Food & Items")
local shopItems = {
    {Name="Bloxy Cola",Password=312590325},{Name="Hotdog",Password=312590325},
    {Name="Burger",Password=312590325},{Name="Betamax",Password=699268542},
    {Name="Calamares",Password=699268542},{Name="Isaw",Password=699268542},
    {Name="Water",Password=699268542},{Name="Quek Quek",Password=699268542},
}
for _, item in pairs(shopItems) do
    tabShop:AddButton({
        Title = item.Name,
        Callback = function()
            pcall(function() ReplicatedStorage:WaitForChild("Remotes",9e9):WaitForChild("BuyFood",9e9):InvokeServer(unpack({[1]={["Password"]=item.Password,["FoodName"]=item.Name}})) end)
        end
    })
end
tabShop:AddDivider()
tabShop:AddSection("Tools")
local toolItems = {
    {Name="Rope",Password=626326648},{Name="Wrench",Password=626326648},
    {Name="Baseball bat",Password=626326648},{Name="Metal pipe",Password=626326648},
    {Name="Hammer",Password=626326648},{Name="Diesel can",Password=626326648},
}
for _, tool in pairs(toolItems) do
    tabShop:AddButton({
        Title = tool.Name,
        Callback = function()
            pcall(function() ReplicatedStorage:WaitForChild("Remotes",9e9):WaitForChild("BuyTool",9e9):InvokeServer(unpack({[1]={["Password"]=tool.Password,["ToolName"]=tool.Name}})) end)
        end
    })
end

-- ============================================================
-- TAB 6: OTHER
-- ============================================================
local tabOther = Window:AddTab({ Title = "OTHER", Icon = "solar/settings-bold" })

tabOther:AddSection("Jeep Controls")
tabOther:AddButton({
    Title = "Register Jeepney",
    Callback = function()
        pcall(function() ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RegisterJeepney"):FireServer() end)
        Fluent:Notify({ Title="Other", Content="Jeepney registered!", Type="Success", Duration=3 })
    end
})
tabOther:AddDivider()
tabOther:AddSection("Misc Features")
tabOther:AddButton({
    Title = "Driver License",
    Callback = function()
        pcall(function() ReplicatedStorage:WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack({{{"3","PassedTheExam",{Password=318862364}}}})) end)
        Fluent:Notify({ Title="Other", Content="License obtained!", Type="Success", Duration=3 })
    end
})
tabOther:AddButton({
    Title = "Auto Complete Tutorial",
    Callback = function()
        pcall(function() ReplicatedStorage:WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack({{{"3","CompletedTutorial",{Password=176096284}}}})) end)
        Fluent:Notify({ Title="Other", Content="Tutorial completed!", Type="Success", Duration=3 })
    end
})
tabOther:AddButton({
    Title = "Free Cam",
    Callback = function() loadstring(game:HttpGet("https://pastefy.app/xfVluu2u/raw"))() end
})
tabOther:AddButton({
    Title = "ESP Jeep",
    Callback = function()
        local function createESP(car)
            if car:FindFirstChild("JeepESP") then return end
            local hl = Instance.new("Highlight"); hl.Name="JeepESP"; hl.Adornee=car
            hl.FillColor=Color3.fromRGB(139,92,246); hl.FillTransparency=0.5
            hl.OutlineColor=Color3.fromRGB(255,255,255); hl.OutlineTransparency=0.2; hl.Parent=car
            local bb = Instance.new("BillboardGui")
            bb.Adornee=car.PrimaryPart or car:FindFirstChildOfClass("BasePart")
            bb.Size=UDim2.new(0,200,0,50); bb.StudsOffset=Vector3.new(0,4,0); bb.AlwaysOnTop=true
            local lbl=Instance.new("TextLabel",bb); lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,0,1,0)
            lbl.TextColor3=Color3.fromRGB(196,181,253); lbl.TextStrokeTransparency=0; lbl.TextScaled=true; lbl.Font=Enum.Font.SourceSansBold
            bb.Parent=car
            task.spawn(function()
                while car and car.Parent do
                    local driver="No Driver"
                    local ds=car:FindFirstChildOfClass("VehicleSeat") or car:FindFirstChild("DriveSeat")
                    if ds and ds.Occupant then driver=ds.Occupant.Parent.Name end
                    local dist=0
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        dist=math.floor((LocalPlayer.Character.HumanoidRootPart.Position-bb.Adornee.Position).Magnitude)
                    end
                    lbl.Text=string.format("Jeep | %s | %d studs",driver,dist)
                    task.wait(0.5)
                end
            end)
        end
        local j=workspace:FindFirstChild("Jeepnies")
        if j then for _,v in pairs(j:GetChildren()) do createESP(v) end end
        Fluent:Notify({ Title="Other", Content="ESP enabled!", Type="Success", Duration=3 })
    end
})
tabOther:AddButton({
    Title = "Delete NPC Cars",
    Callback = function()
        pcall(function()
            local f=workspace:FindFirstChild("AiVehicles")
            if f then f:ClearAllChildren()
            else for _,v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and (v.Name:find("NPC") or v.Name:find("AI")) then
                    local seat=v:FindFirstChildOfClass("VehicleSeat") or v:FindFirstChild("DriveSeat")
                    if seat and not seat.Occupant then v:Destroy() end
                end
            end end
        end)
        Fluent:Notify({ Title="Other", Content="NPC cars deleted!", Type="Success", Duration=3 })
    end
})
tabOther:AddButton({
    Title = "Infinite Yield",
    Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end
})
tabOther:AddDivider()
tabOther:AddSection("Auto Farm")
local isKmActive = false
tabOther:AddToggle("t_autokm", {
    Title = "Enable Auto KM",
    Default = false,
    Callback = function(v)
        isKmActive = v
        if v then
            task.spawn(function()
                local flightHeight=500; local speed=550
                while isKmActive do
                    local char=LocalPlayer.Character
                    local hum=char and char:FindFirstChild("Humanoid")
                    if hum and hum.SeatPart then
                        local car=hum.SeatPart.Parent
                        if car:FindFirstChild("Body") and car.Body:FindFirstChild("#Weight") then car.PrimaryPart=car.Body["#Weight"] end
                        local cpp=car.PrimaryPart or (car:FindFirstChild("Body") and car.Body:FindFirstChild("#Weight"))
                        if cpp then
                            local loc1=Vector3.new(-6205.2983,flightHeight,8219.8535)
                            local loc2=Vector3.new(-7594.5410,flightHeight,5130.9526)
                            repeat task.wait(); if not hum.SeatPart or not isKmActive then break end
                                cpp.AssemblyLinearVelocity=(loc1-cpp.Position).Unit*speed; car:PivotTo(CFrame.lookAt(cpp.Position,loc1))
                            until (cpp.Position-loc1).Magnitude<50
                            cpp.AssemblyLinearVelocity=Vector3.zero
                            repeat task.wait(); if not hum.SeatPart or not isKmActive then break end
                                cpp.AssemblyLinearVelocity=(loc2-cpp.Position).Unit*speed; car:PivotTo(CFrame.lookAt(cpp.Position,loc2))
                            until (cpp.Position-loc2).Magnitude<50
                            cpp.AssemblyLinearVelocity=Vector3.zero
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})
tabOther:AddDivider()
tabOther:AddSection("Game Settings")
tabOther:AddToggle("t_fpsboost", {
    Title = "FPS Boost",
    Default = false,
    Callback = function(v)
        if v then
            for _,obj in pairs(game:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then obj.Material=Enum.Material.SmoothPlastic; obj.Reflectance=0
                elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then obj.Enabled=false end
            end
            settings().Rendering.QualityLevel=1; game.Lighting.GlobalShadows=false
        end
    end
})

-- ============================================================
-- TAB 7: MUSIC
-- ============================================================
local tabMusic = Window:AddTab({ Title = "MUSIC", Icon = "solar/music-note-bold" })

local musicSound = Instance.new("Sound")
musicSound.Parent = workspace.CurrentCamera
musicSound.Volume = 1
musicSound.Looped = false

local songs = {
    {Id=102530888109784,Name="No Limit Ice Ice"},{Id=86793099693274,Name="PUFF ME UP SUPAFLY"},
    {Id=104642889770966,Name="Thug Love"},{Id=123193066922226,Name="MYDAY HELLMERRY"},
    {Id=96349817794138,Name="XXXX"},{Id=105433463687285,Name="Alam Mo Ba Girl"},
    {Id=78338689906576,Name="Marikit Sa Dilim"},{Id=80186643942739,Name="Kung Ako Sayo"},
    {Id=116809617492226,Name="6lock"},{Id=105849669299967,Name="Walang Pag-Ibig"},
    {Id=72274745745781,Name="Pagsamo"},{Id=82410487906541,Name="Bakit Nga Ba Mahal Kita"},
    {Id=1188403994693034,Name="Masaya Ka Sa Iba"},{Id=79311041168107,Name="Oksihina"},
    {Id=118668717534464,Name="Multo"},{Id=119536408246566,Name="Eroplanong Papel"},
    {Id=104973165878865,Name="Bulong"},{Id=104293367124017,Name="Kundiman"},
    {Id=81413378667534,Name="Kung Wala Ka"},{Id=116237878392921,Name="Bumalik Kana Sakin"},
    {Id=99019663546064,Name="Rebound"},{Id=120403965756395,Name="Nasa Puso Ka Parin"},
    {Id=86777554622462,Name="Magkaiba"},{Id=106174792478284,Name="Love Attack"},
    {Id=75822084529419,Name="Alipin"},{Id=129046939580756,Name="Woman Who Cant Be Moved"},
    {Id=100747716273742,Name="Mahika"},{Id=124820719478947,Name="Tingin"},
    {Id=90591472148973,Name="Heaven Knows Rock"},{Id=113762943787847,Name="Hey Crush"},
    {Id=94475074502605,Name="Alam Mo Ba Girl 2"},{Id=78426236518475,Name="Para Sa Streets"},
    {Id=86700413156316,Name="Randomantic"},{Id=108873659010908,Name="Babaero"},
    {Id=139463481930838,Name="Papap Dol Budots"},{Id=88690983161170,Name="Baduy Vvink"},
    {Id=71879611226471,Name="Hanggang Sa Huli"},{Id=109046857444579,Name="Urong Sulong"},
    {Id=96259697252611,Name="Byahe"},{Id=88881552063453,Name="Arizona B Budots"},
    {Id=93542593797773,Name="Co-Pilot"},{Id=78487275982635,Name="Salamin Salamin"},
    {Id=115816944184683,Name="Malay Ko"},{Id=139751146414163,Name="Buhay ng Gangsta"},
    {Id=111330689779749,Name="Rock That Body"},{Id=116909196354204,Name="Opalite x Golden"},
    {Id=112590536755182,Name="Sabi Ko Na Barbie"},{Id=86273886532794,Name="Iris Goo Goo"},
    {Id=105897803731104,Name="Wala Na Pag Ibig 2"},{Id=108769896869101,Name="INTROHAN NATIN"},
    {Id=131178324358019,Name="Alam Ko Na"},{Id=114182593972695,Name="Kabute"},
    {Id=93272267476694,Name="Baliw"},{Id=91241303056228,Name="Namumula"},
    {Id=116695707585893,Name="Kailan"},{Id=80660014894209,Name="All Or Nothing"},
    {Id=113463168801116,Name="Kung Sakali"},{Id=104348021759246,Name="Two Times Budots"},
    {Id=71275570481350,Name="Migrain"},{Id=78446156193949,Name="Fixing Broken Heart"},
    {Id=126606110469298,Name="Officially Missing You"},{Id=133257180884988,Name="Torete"},
    {Id=92211397826543,Name="Panis Ka Boy Remix"},{Id=79902104729560,Name="Maligayang Pasko"},
    {Id=83553933296460,Name="Magkakasama Pasko"},{Id=120200330391730,Name="Thank You For Love"},
    {Id=122893796050555,Name="Ngayong Pasko"},
}
tabMusic:AddSection("Controls")
tabMusic:AddButton({
    Title = "Stop Music",
    Callback = function()
        if musicSound.IsPlaying then musicSound:Stop() end
        Fluent:Notify({ Title="Music", Content="Stopped.", Type="Info", Duration=2 })
    end
})
tabMusic:AddDivider()
tabMusic:AddSection("Playlist")
for _, s in ipairs(songs) do
    tabMusic:AddButton({
        Title = s.Name,
        Callback = function()
            if musicSound.IsPlaying then musicSound:Stop() end
            musicSound.SoundId = "rbxassetid://"..tostring(s.Id)
            musicSound:Play()
            Fluent:Notify({ Title="Now Playing", Content=s.Name, Type="Success", Duration=3 })
        end
    })
end

-- ============================================================
-- TAB 8: SERVER
-- ============================================================
local tabServer = Window:AddTab({ Title = "SERVER", Icon = "solar/layers-bold" })

tabServer:AddSection("Management")
tabServer:AddButton({
    Title = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end
})
tabServer:AddButton({
    Title = "Swap Server (Hop)",
    Callback = function()
        local Http=HttpService; local TPS=game:GetService("TeleportService")
        local Api="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
        local Next
        repeat
            local ok,Servers=pcall(function() return Http:JSONDecode(game:HttpGet(Api..((Next and "&cursor="..Next) or ""))) end)
            if not ok then break end
            for _,v in next,Servers.data do if v.playing<v.maxPlayers and v.id~=game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId,v.id); return end end
            Next=Servers.nextPageCursor
        until not Next
    end
})
tabServer:AddButton({
    Title = "Small Server",
    Callback = function()
        local Http=HttpService; local TPS=game:GetService("TeleportService")
        local Api="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local Next
        repeat
            local ok,Servers=pcall(function() return Http:JSONDecode(game:HttpGet(Api..((Next and "&cursor="..Next) or ""))) end)
            if not ok then break end
            for _,v in next,Servers.data do if v.playing<v.maxPlayers and v.id~=game.JobId then TPS:TeleportToPlaceInstance(game.PlaceId,v.id); return end end
            Next=Servers.nextPageCursor
        until not Next
    end
})

-- ============================================================
-- TAB 9: STICKERS
-- ============================================================
local tabSticker = Window:AddTab({ Title = "STICKERS", Icon = "solar/gallery-bold" })

local _BotAPI        = "https://sticker-production-da81.up.railway.app"
local _APIKey        = "Tg4lVox0ZKXjpooMdWSroQmTHtT8M4Co"
local _GalleryDomain = "https://sticker-webhook.netlify.app/"
local _stickerPlayers = Players
local _stickerLocal   = LocalPlayer
local _stickerTarget  = ""

local _stickerPlayerNames = {}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then table.insert(_stickerPlayerNames, plr.Name) end
end
if #_stickerPlayerNames == 0 then _stickerPlayerNames = {"No Players"} end

local function _GetVehicleDecals(ws)
    local found = {}
    local function recurse(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("Model") and (child:FindFirstChild("DriveSeat") or child:FindFirstChild("VehicleSeat") or child.Name:lower():find("jeep")) then
                local ov = child:FindFirstChild("Owner") or child:FindFirstChild("PlayerName")
                table.insert(found, {Model=child, Owner=ov and tostring(ov.Value) or ""})
            end
            recurse(child)
        end
    end
    recurse(ws)
    local results = {}
    for _, data in ipairs(found) do
        local decals, cache = {}, {}
        for _, desc in ipairs(data.Model:GetDescendants()) do
            if desc:IsA("Decal") and desc.Texture~="" then
                local id = tostring(desc.Texture:match("%d+"))
                if id and not cache[id] then table.insert(decals,id); cache[id]=true end
            end
        end
        if #decals>0 then table.insert(results,{Vehicle=data.Model,Owner=data.Owner,Decals=decals}) end
    end
    return results
end
local function _FindTargetVehicle(target, ws)
    local data = _GetVehicleDecals(ws)
    for _,v in ipairs(data) do if v.Owner==target then return v end end
    for _,v in ipairs(data) do if v.Vehicle.Name:lower():find(target:lower()) then return v end end
end

tabSticker:AddSection("Sticker Viewer")
tabSticker:AddDropdown("dd_stickertarget", {
    Title   = "Target Player",
    Values  = _stickerPlayerNames,
    Default = _stickerPlayerNames[1],
    Callback = function(v) _stickerTarget = v end
})
tabSticker:AddButton({
    Title = "Review Stickers",
    Callback = function()
        if _stickerTarget=="" or _stickerTarget=="No Players" then
            Fluent:Notify({ Title="Stickers", Content="Select a target player first!", Type="Warning", Duration=3 }); return
        end
        local targetData = _FindTargetVehicle(_stickerTarget, workspace)
        if not targetData or not targetData.Decals or #targetData.Decals==0 then
            Fluent:Notify({ Title="Stickers", Content="No jeep or stickers found!", Type="Error", Duration=3 }); return
        end
        local decals = targetData.Decals
        local t=os.date("*t"); local months={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
        local dh=t.hour%12; if dh==0 then dh=12 end
        local dateStr=string.format("%s %d, %d %d:%02d %s",months[t.month],t.day,t.year,dh,t.min,t.hour>=12 and "PM" or "AM")
        pcall(function()
            local Http=request or (syn and syn.request) or http_request; if not Http then return end
            Http({Url=_BotAPI.."/steal",Method="POST",Headers={["Content-Type"]="application/json",["x-api-key"]=_APIKey},
                Body=HttpService:JSONEncode({target=_stickerTarget,stickerName=_stickerTarget.."'s Stickers",decals=decals,date=dateStr})})
        end)
        Fluent:Notify({ Title="Stickers", Content="Found "..(#decals).." sticker(s)!", Type="Success", Duration=4 })
    end
})

-- ============================================================
-- TAB 10: TUNE
-- ============================================================
local tabTune = Window:AddTab({ Title = "TUNE", Icon = "solar/tuning-bold" })

local _BotAPI_Tune = "https://sticker-production-da81.up.railway.app"
local _APIKey_Tune = "Tg4lVox0ZKXjpooMdWSroQmTHtT8M4Co"
local _tuneTarget  = ""

local _tunePlayerNames = {}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then table.insert(_tunePlayerNames, plr.Name) end
end
if #_tunePlayerNames==0 then _tunePlayerNames={"No Players"} end

local function _FindJeep(targetName)
    local jeepnies=workspace:FindFirstChild("Jeepnies")
    if jeepnies then
        local d=jeepnies:FindFirstChild(targetName); if d then return d end
        for _,v in ipairs(jeepnies:GetChildren()) do if v.Name:lower():find(targetName:lower()) then return v end end
    end
    local function recurse(parent,depth)
        if depth>5 then return nil end
        for _,child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") then
                local ov=child:FindFirstChild("Owner") or child:FindFirstChild("PlayerName")
                if ov and tostring(ov.Value)==targetName then return child end
            end
            local f=recurse(child,depth+1); if f then return f end
        end
    end
    return recurse(workspace,0)
end
local function _ReadTune(jeep)
    local jeepIndex=jeep:GetAttribute("Index") or jeep.Name
    local fh,rh,fs,fd,rs,rd=0,0,0,0,0,0
    local tv=jeep:FindFirstChild("TuneValues",true)
    if tv then fh=tv:GetAttribute("FrontHeight") or 0; rh=tv:GetAttribute("RearHeight") or 0 end
    local wheels=jeep:FindFirstChild("Wheels")
    if wheels then
        for _,wn in ipairs({"FR","FL"}) do local w=wheels:FindFirstChild(wn); if w then for _,d in ipairs(w:GetDescendants()) do if d:IsA("SpringConstraint") then fs=d.Stiffness; fd=d.Damping; break end end; if fs~=0 then break end end end
        for _,wn in ipairs({"RR","RL"}) do local w=wheels:FindFirstChild(wn); if w then for _,d in ipairs(w:GetDescendants()) do if d:IsA("SpringConstraint") then rs=d.Stiffness; rd=d.Damping; break end end; if rs~=0 then break end end end
    end
    return {jeepIndex=jeepIndex,fh=fh,rh=rh,fs=fs,fd=fd,rs=rs,rd=rd,
        tuneCode=string.format("fh;%.4f;rh;%.4f;fs;%.4f;rs;%.4f;fd;%.4f;rd;%.4f",fh,rh,fs,rs,fd,rd)}
end

tabTune:AddSection("Tune Viewer")
tabTune:AddDropdown("dd_tunetarget", {
    Title   = "Target Player",
    Values  = _tunePlayerNames,
    Default = _tunePlayerNames[1],
    Callback = function(v) _tuneTarget=v end
})
tabTune:AddButton({
    Title = "Read Tune",
    Callback = function()
        if _tuneTarget=="" or _tuneTarget=="No Players" then
            Fluent:Notify({ Title="Tune", Content="Select a target player first!", Type="Warning", Duration=3 }); return
        end
        Fluent:Notify({ Title="Tune", Content="Finding jeep...", Type="Info", Duration=2 })
        task.spawn(function()
            local jeep=_FindJeep(_tuneTarget)
            if not jeep then Fluent:Notify({ Title="Tune", Content="No jeep found!", Type="Error", Duration=3 }); return end
            local td=_ReadTune(jeep)
            print("=== BELLE.SG TUNE VIEWER ===")
            print("Player : ".._tuneTarget); print("Jeep   : "..td.jeepIndex)
            print("FH:"..td.fh," FS:"..td.fs," FD:"..td.fd)
            print("RH:"..td.rh," RS:"..td.rs," RD:"..td.rd)
            print("Code   : "..td.tuneCode); print("============================")
            local t=os.date("*t"); local months={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
            local dh=t.hour%12; if dh==0 then dh=12 end
            local dateStr=string.format("%s %d, %d %d:%02d %s",months[t.month],t.day,t.year,dh,t.min,t.hour>=12 and "PM" or "AM")
            local success=false
            pcall(function()
                local Http=request or (syn and syn.request) or http_request; if not Http then return end
                local res=Http({Url=_BotAPI_Tune.."/tune",Method="POST",Headers={["Content-Type"]="application/json",["x-api-key"]=_APIKey_Tune},
                    Body=HttpService:JSONEncode({target=_tuneTarget,jeepName=td.jeepIndex,frontHeight=td.fh,frontStiffness=td.fs,frontDampening=td.fd,rearHeight=td.rh,rearStiffness=td.rs,rearDampening=td.rd,tuneCode=td.tuneCode,date=dateStr})})
                success=res and (res.StatusCode==200 or res.StatusCode==204)
            end)
            if success then Fluent:Notify({ Title="Tune", Content="Tune read and sent!", Type="Success", Duration=4 })
            else Fluent:Notify({ Title="Tune", Content="Tune read. Check console.", Type="Warning", Duration=4 }) end
        end)
    end
})

-- ============================================================
-- FLOATING BUTTON (SOUND + PURPLE)
-- ============================================================
local floatingGui = Instance.new("ScreenGui")
floatingGui.Name = "BelleSgFloating"
floatingGui.ResetOnSpawn = false
floatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
floatingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainBtn = Instance.new("TextButton")
mainBtn.Name = "FloatingButton"
mainBtn.Parent = floatingGui
mainBtn.BackgroundColor3 = Color3.fromRGB(20, 14, 40)
mainBtn.BackgroundTransparency = 0.15
mainBtn.Position = UDim2.new(0.04, 0, 0.08, 0)
mainBtn.Size = UDim2.new(0, 56, 0, 56)
mainBtn.Text = ""
mainBtn.ZIndex = 10
Instance.new("UICorner", mainBtn).CornerRadius = UDim.new(1, 0)
local btnStroke = Instance.new("UIStroke", mainBtn)
btnStroke.Color = Color3.fromRGB(139, 92, 246)
btnStroke.Thickness = 2

local bgImg = Instance.new("ImageLabel", mainBtn)
bgImg.Size = UDim2.new(1.6, 0, 1.6, 0)
bgImg.Position = UDim2.new(0.5, 0, 0.5, 0)
bgImg.AnchorPoint = Vector2.new(0.5, 0.5)
bgImg.BackgroundTransparency = 1
bgImg.Image = "rbxassetid://92062295706713"
bgImg.SizeConstraint = Enum.SizeConstraint.RelativeXX
bgImg.ZIndex = 9

local iconImg = Instance.new("ImageLabel", mainBtn)
iconImg.Size = UDim2.fromOffset(44, 44)
iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
iconImg.BackgroundTransparency = 1
iconImg.Image = LOGO_ASSET
iconImg.ZIndex = 11
Instance.new("UICorner", iconImg).CornerRadius = UDim.new(0.2, 0)

local soundBtn = Instance.new("TextButton", mainBtn)
soundBtn.Name = "SoundButton"
soundBtn.Size = UDim2.fromOffset(20, 20)
soundBtn.Position = UDim2.new(1, -24, 0, 2)
soundBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
soundBtn.Text = "🔊"
soundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
soundBtn.Font = Enum.Font.GothamBold
soundBtn.TextSize = 11
soundBtn.ZIndex = 12
Instance.new("UICorner", soundBtn).CornerRadius = UDim.new(0.3, 0)

local soundEnabled = true
soundBtn.MouseButton1Click:Connect(function()
    soundEnabled = not soundEnabled
    if soundEnabled then
        soundBtn.Text = "🔊"
        soundBtn.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
    else
        soundBtn.Text = "🔇"
        soundBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

local rot, spd, lt = 0, 90, tick()
task.spawn(function()
    while true do
        local now = tick()
        rot = (rot + spd * (now - lt)) % 360
        lt = now
        bgImg.Rotation = rot
        task.wait()
    end
end)

local drag, ds, sp = false, nil, nil
mainBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = true
        ds = i.Position
        sp = mainBtn.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then drag = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - ds
        mainBtn.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end
end)

local uiOpen = true
mainBtn.MouseButton1Click:Connect(function()
    uiOpen = not uiOpen
    if uiOpen then Window:Show() else Window:Hide() end
    if soundEnabled then
        local sound = Instance.new("Sound")
        sound.Parent = workspace.CurrentCamera
        sound.SoundId = "rbxassetid://876939830"
        sound.Volume = 0.3
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end
end)

-- ============================================================
-- STARTUP
-- ============================================================
Window:SelectTab(1)
Fluent:Notify({
    Title = "BELLE.SG",
    Content = "Diesel n' Steel loaded! RightCtrl to toggle.",
    Type = "Success",
    Duration = 4
})
