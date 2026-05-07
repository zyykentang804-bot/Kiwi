-- ============================================================
-- SILENT HUB v1.2 (Kiwisense UI Edition)
-- Fitur: Walk Speed (max 23), Infinite Stamina, Noclip, Change Name, Change Username
-- ============================================================

-- Load Kiwisense Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/Kiwisense/Library.lua"))()

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Tunggu karakter
repeat task.wait() until player.Character
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

-- ========== GLOBAL VARIABLES ==========
local walkSpeedValue = 16
local infiniteStaminaEnabled = false
local noclipEnabled = false
local staminaReq = nil
local staminaConn = nil
local noclipConn = nil
local noclipParts = {}  -- untuk menyimpan properti asli part

-- ========== FUNGSI UTILITY ==========
local function notify(msg, isErr)
    Library:Notification({
        Name = isErr and "Error" or "Silent Hub",
        Description = msg,
        Duration = 3,
        Icon = isErr and "97118059177470" or "116339777575852",
        IconColor = isErr and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(52, 255, 164)
    })
end

-- ========== WALK SPEED ==========
local function setWalkSpeed(v)
    walkSpeedValue = v
    if humanoid then
        humanoid.WalkSpeed = v
        notify("Walk Speed: " .. v)
    end
end

-- ========== INFINITE STAMINA ==========
pcall(function() staminaReq = require(player.PlayerScripts:WaitForChild("Main", 5)) end)

local function setInfiniteStamina(enabled)
    infiniteStaminaEnabled = enabled
    if enabled then
        if staminaReq then staminaReq.Stamina = 100 end
        if staminaConn then staminaConn:Disconnect() end
        staminaConn = RunService.Heartbeat:Connect(function()
            if infiniteStaminaEnabled and staminaReq then staminaReq.Stamina = 100 end
        end)
        player:SetAttribute("StaminaConsumeMultiplier", 0)
        player:GetAttributeChangedSignal("StaminaConsumeMultiplier"):Connect(function()
            player:SetAttribute("StaminaConsumeMultiplier", 0)
        end)
        -- Sembunyikan stamina bar
        local mainGui = player.PlayerGui:FindFirstChild("Main")
        if mainGui and mainGui:FindFirstChild("Bars") then
            local bar = mainGui.Bars:FindFirstChild("StaminaBar")
            if bar then bar.Visible = false end
        end
        notify("Infinite Stamina ON")
    else
        if staminaConn then staminaConn:Disconnect(); staminaConn = nil end
        local mainGui = player.PlayerGui:FindFirstChild("Main")
        if mainGui and mainGui:FindFirstChild("Bars") then
            local bar = mainGui.Bars:FindFirstChild("StaminaBar")
            if bar then bar.Visible = true end
        end
        notify("Infinite Stamina OFF")
    end
end

-- ========== NOCLIP (sethiddenproperty) ==========
local function setHiddenProperty(instance, property, value)
    pcall(function()
        if sethiddenproperty then sethiddenproperty(instance, property, value)
        elseif set_hidden_property then set_hidden_property(instance, property, value)
        else
            instance[property] = value
        end
    end)
end

local function exclusions(part)
    local roads = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Roads/Sidewalks")
    return (roads and part:IsDescendantOf(roads)) or
           part.Name == "default" or part.Name == "Sidewalk" or part.Name == "Floor" or
           part.Name == "Collision" or part.Name == "QuaterCylinder" or
           (player.Character and part:IsDescendantOf(player.Character)) or
           (part.Parent and part.Parent:IsA("Model") and Players:GetPlayerFromCharacter(part.Parent) ~= nil) or
           part:IsA("VehicleSeat") or part:IsA("Vehicle")
end

local function updateNoclip()
    local camera = workspace.CurrentCamera
    local pos = camera.CFrame.Position
    local radius = 15
    local region = Region3.new(pos - Vector3.new(radius, radius, radius), pos + Vector3.new(radius, radius, radius))
    local parts = workspace:FindPartsInRegion3(region, nil, math.huge)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and not exclusions(part) then
            if not noclipParts[part] then
                noclipParts[part] = { CanCollide = part.CanCollide }
                setHiddenProperty(part, "CanCollide", false)
            end
        end
    end
end

local function resetNoclip()
    for part, props in pairs(noclipParts) do
        if part:IsA("BasePart") then
            setHiddenProperty(part, "CanCollide", props.CanCollide)
        end
    end
    noclipParts = {}
end

local function setNoclip(enabled)
    noclipEnabled = enabled
    if enabled then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            if noclipEnabled then updateNoclip() end
        end)
        notify("Noclip ON")
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        resetNoclip()
        notify("Noclip OFF")
    end
end

-- Reset saat character respawn
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    humanoid = newChar:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = walkSpeedValue
    end
    if noclipEnabled then
        setNoclip(false)
        task.wait(0.2)
        setNoclip(true)
    end
    if infiniteStaminaEnabled then
        -- re-apply infinite stamina
        setInfiniteStamina(true)
    end
end)

-- ========== CHANGE NAME & USERNAME ==========
local function changeName(newName)
    pcall(function()
        local nameTag = workspace.Characters:FindFirstChild(player.Name):FindFirstChild("Head"):FindFirstChild("NameTag"):FindFirstChild("MainFrame"):FindFirstChild("NameLabel")
        if nameTag then
            nameTag.Text = newName
            notify("Name changed to: " .. newName)
        else
            notify("Name tag not found", true)
        end
    end)
end

local function changeUsername(newUsn)
    pcall(function()
        local rankTag = workspace.Characters:FindFirstChild(player.Name):FindFirstChild("Head"):FindFirstChild("RankTag"):FindFirstChild("MainFrame"):FindFirstChild("NameLabel")
        if rankTag then
            rankTag.Text = newUsn
            notify("Username changed to: " .. newUsn)
        else
            notify("Username tag not found", true)
        end
    end)
end

-- ========== UI SETUP MENGGUNAKAN KIWISENSE ==========
-- Buat Window utama
local Window = Library:Window({
    Name = "Silent Hub",
    Version = "v1.2",
    Logo = "135215559087473",  -- icon Silent Hub (optional)
    FadeSpeed = 0.25,
})

-- Buat Page "Movement"
local MovementPage = Window:Page({
    Name = "Movement",
    Icon = "109463522861706",
    Columns = 1  -- biar rapi
})

-- Buat Section "Settings"
local GeneralSection = MovementPage:Section({
    Name = "General",
    Side = 1,
    Icon = "103174889897193"
})

-- Slider Walk Speed (max 23)
GeneralSection:Slider({
    Name = "Walk Speed",
    Flag = "WalkSpeed",
    Min = 16,
    Default = 16,
    Max = 23,
    Suffix = " speed",
    Decimals = 0,
    Callback = function(Value)
        setWalkSpeed(Value)
    end
})

-- Toggle Infinite Stamina
GeneralSection:Toggle({
    Name = "Infinite Stamina",
    Flag = "InfiniteStamina",
    Default = false,
    Callback = function(Value)
        setInfiniteStamina(Value)
    end
})

-- Toggle Noclip
GeneralSection:Toggle({
    Name = "Noclip (Tembus Dinding)",
    Flag = "Noclip",
    Default = false,
    Callback = function(Value)
        setNoclip(Value)
    end
})

-- ========== Page "Character" untuk change name/username ==========
local CharacterPage = Window:Page({
    Name = "Character",
    Icon = "135799335731002",
    Columns = 1
})

local CharacterSection = CharacterPage:Section({
    Name = "Identity",
    Side = 1,
    Icon = "103174889897193"
})

-- Textbox Change Name
CharacterSection:Textbox({
    Name = "Change Name",
    Flag = "ChangeName",
    Placeholder = "Nama baru...",
    Default = "",
    Callback = function(Value)
        if Value ~= "" then
            changeName(Value)
        end
    end
})

-- Textbox Change Username
CharacterSection:Textbox({
    Name = "Change Username",
    Flag = "ChangeUsername",
    Placeholder = "Username baru...",
    Default = "",
    Callback = function(Value)
        if Value ~= "" then
            changeUsername(Value)
        end
    end
})

-- Optional: Page "Info" untuk credit
local InfoPage = Window:Page({
    Name = "Info",
    Icon = "137300573942266",
    Columns = 1
})

local InfoSection = InfoPage:Section({
    Name = "About",
    Side = 1,
    Icon = "103863157706913"
})

InfoSection:Label("Silent Hub v1.2 - Dark & Grey Edition", "Left")
InfoSection:Label("Developer: Silent Team", "Left")
InfoSection:Label("Prioritaskan member, jika ada masalah langsung ditangani.", "Left")
InfoSection:Label("Support developer kecil, jangan pernah menjatuhkan sesama developer.", "Left")

-- ========== ANTIDOTE (Anti-AFK) ==========
player.Idled:Connect(function()
    pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
end)

-- ========== INISIALISASI ==========
Library:Notification({
    Name = "Silent Hub",
    Description = "Loaded successfully! v1.2",
    Duration = 4,
    Icon = "116339777575852",
    IconColor = Color3.fromRGB(52, 255, 164)
})

Library:Init()  -- Wajib untuk autoload config/theme

print("Silent Hub v1.2 (Kiwisense) loaded")
