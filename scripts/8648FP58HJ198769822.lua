-- FPS Optimizer UI Script
-- Silent Hub — Dark & Grey Theme

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = (gethui and gethui()) or game:GetService("CoreGui")

-- =====================
-- STATE
-- =====================
local settings = {
    removePostEffects = true,
    disableShadows    = true,
    flatMaterials     = true,
    hideDecals        = true,
    flatTerrain       = true,
    qualityLevel      = 1,
    physicsSleep      = true,
}

local originalData = {
    effects = {},
    parts   = {},
    decals  = {},
    terrain = {},
}

-- =====================
-- FUNCTIONS
-- =====================
local function applyPostEffects(enabled)
    if enabled then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then v:Destroy() end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd        = 9e9
        Lighting.Brightness    = 2
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd        = 10000
        Lighting.Brightness    = 1
    end
end

local function applyMaterials(enabled)
    for _, instance in ipairs(workspace:GetDescendants()) do
        if instance:IsA("BasePart") then
            if player.Character and instance:IsDescendantOf(player.Character) then continue end
            if enabled then
                originalData.parts[instance] = {
                    Material    = instance.Material,
                    Reflectance = instance.Reflectance,
                }
                instance.Material    = Enum.Material.SmoothPlastic
                instance.Reflectance = 0
            else
                if originalData.parts[instance] then
                    instance.Material    = originalData.parts[instance].Material
                    instance.Reflectance = originalData.parts[instance].Reflectance
                end
            end
        end
    end
end

local function applyDecals(enabled)
    for _, instance in ipairs(workspace:GetDescendants()) do
        if instance:IsA("Texture") or instance:IsA("Decal") then
            if player.Character and instance:IsDescendantOf(player.Character) then continue end
            if enabled then
                originalData.decals[instance] = instance.Transparency
                instance.Transparency = 1
            else
                if originalData.decals[instance] then
                    instance.Transparency = originalData.decals[instance]
                end
            end
        end
    end
end

local function applyTerrain(enabled)
    local terrain = workspace:FindFirstChild("Terrain")
    if not terrain then return end
    if enabled then
        originalData.terrain = {
            WaterWaveSize      = terrain.WaterWaveSize,
            WaterWaveSpeed     = terrain.WaterWaveSpeed,
            WaterReflectance   = terrain.WaterReflectance,
            WaterTransparency  = terrain.WaterTransparency,
        }
        terrain.WaterWaveSize     = 0
        terrain.WaterWaveSpeed    = 0
        terrain.WaterReflectance  = 0
        terrain.WaterTransparency = 1
    else
        if originalData.terrain.WaterWaveSize then
            terrain.WaterWaveSize     = originalData.terrain.WaterWaveSize
            terrain.WaterWaveSpeed    = originalData.terrain.WaterWaveSpeed
            terrain.WaterReflectance  = originalData.terrain.WaterReflectance
            terrain.WaterTransparency = originalData.terrain.WaterTransparency
        end
    end
end

local function applyQuality(level)
    pcall(function()
        UserSettings().GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        settings().Rendering.QualityLevel = level
    end)
end

local function applyPhysics(enabled)
    pcall(function()
        settings().Physics.AllowSleep = enabled
    end)
end

local function applyAll()
    applyPostEffects(settings.removePostEffects)
    applyMaterials(settings.flatMaterials)
    applyDecals(settings.hideDecals)
    applyTerrain(settings.flatTerrain)
    applyQuality(settings.qualityLevel)
    applyPhysics(settings.physicsSleep)
end

local function revertAll()
    applyPostEffects(false)
    applyMaterials(false)
    applyDecals(false)
    applyTerrain(false)
    pcall(function() settings().Rendering.QualityLevel = 21 end)
    pcall(function() settings().Physics.AllowSleep = false end)
end

local masterEnabled = false

workspace.DescendantAdded:Connect(function(instance)
    if not settings.flatMaterials and not settings.hideDecals then return end
    if player.Character and instance:IsDescendantOf(player.Character) then return end
    if settings.flatMaterials and instance:IsA("BasePart") then
        instance.Material    = Enum.Material.SmoothPlastic
        instance.Reflectance = 0
    end
    if settings.hideDecals and (instance:IsA("Texture") or instance:IsA("Decal")) then
        instance.Transparency = 1
    end
end)

-- =====================
-- COLORS (Dark & Grey)
-- =====================
local C = {
    bg         = Color3.fromRGB(10, 10, 10),
    card       = Color3.fromRGB(18, 18, 18),
    titleBar   = Color3.fromRGB(22, 22, 22),
    border     = Color3.fromRGB(40, 40, 40),
    borderGlow = Color3.fromRGB(90, 90, 90),
    text       = Color3.fromRGB(200, 200, 200),
    textSub    = Color3.fromRGB(100, 100, 100),
    textMuted  = Color3.fromRGB(60, 60, 60),
    toggleOn   = Color3.fromRGB(120, 120, 120),
    toggleOff  = Color3.fromRGB(35, 35, 35),
    knob       = Color3.fromRGB(230, 230, 230),
    accent     = Color3.fromRGB(160, 160, 160),
    fillBar    = Color3.fromRGB(130, 130, 130),
    section    = Color3.fromRGB(70, 70, 70),
    btnBg      = Color3.fromRGB(30, 30, 30),
    white      = Color3.fromRGB(255, 255, 255),
}

-- =====================
-- GUI SETUP
-- =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "SilentHubFPS"
screenGui.ResetOnSpawn   = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder   = 999

local guiParented = false
if not guiParented then pcall(function() screenGui.Parent = game:GetService("CoreGui") guiParented = true end) end
if not guiParented then pcall(function() screenGui.Parent = gethui() guiParented = true end) end
if not guiParented then screenGui.Parent = player.PlayerGui end

-- =====================
-- MAIN FRAME
-- =====================
local mainFrame = Instance.new("Frame")
mainFrame.Size             = UDim2.new(0, 286, 0, 390)
mainFrame.Position         = UDim2.new(0, 16, 0.5, -195)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel  = 0
mainFrame.Active           = true
mainFrame.Draggable        = true
mainFrame.Parent           = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent       = mainFrame

-- Animated glow stroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Color     = C.border
mainStroke.Thickness = 1.5
mainStroke.Parent    = mainFrame

-- =====================
-- GLOW ANIMATION
-- =====================
local glowColors = {
    Color3.fromRGB(40,  40,  40),
    Color3.fromRGB(80,  80,  80),
    Color3.fromRGB(130, 130, 130),
    Color3.fromRGB(180, 180, 180),
    Color3.fromRGB(130, 130, 130),
    Color3.fromRGB(80,  80,  80),
    Color3.fromRGB(40,  40,  40),
}
local glowIdx = 1
local glowTimer = 0

RunService.Heartbeat:Connect(function(dt)
    glowTimer = glowTimer + dt
    if glowTimer >= 0.18 then
        glowTimer = 0
        glowIdx = (glowIdx % #glowColors) + 1
        TweenService:Create(mainStroke,
            TweenInfo.new(0.18, Enum.EasingStyle.Linear),
            {Color = glowColors[glowIdx]}
        ):Play()
    end
end)

-- =====================
-- TITLE BAR
-- =====================
local titleBar = Instance.new("Frame")
titleBar.Size             = UDim2.new(1, 0, 0, 46)
titleBar.BackgroundColor3 = C.titleBar
titleBar.BorderSizePixel  = 0
titleBar.Parent           = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent       = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size             = UDim2.new(1, 0, 0, 10)
titleFix.Position         = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = C.titleBar
titleFix.BorderSizePixel  = 0
titleFix.Parent           = titleBar

-- Title bottom border line
local titleLine = Instance.new("Frame")
titleLine.Size             = UDim2.new(1, 0, 0, 1)
titleLine.Position         = UDim2.new(0, 0, 1, -1)
titleLine.BackgroundColor3 = C.border
titleLine.BorderSizePixel  = 0
titleLine.Parent           = titleBar

-- Logo dot
local logoDot = Instance.new("Frame")
logoDot.Size             = UDim2.new(0, 7, 0, 7)
logoDot.Position         = UDim2.new(0, 12, 0.5, -3)
logoDot.BackgroundColor3 = C.accent
logoDot.BorderSizePixel  = 0
logoDot.Parent           = titleBar

local logoDotCorner = Instance.new("UICorner")
logoDotCorner.CornerRadius = UDim.new(1, 0)
logoDotCorner.Parent       = logoDot

-- Pulsing dot animation
spawn(function()
    while mainFrame.Parent do
        TweenService:Create(logoDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        }):Play()
        wait(0.7)
        TweenService:Create(logoDot, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        }):Play()
        wait(0.7)
    end
end)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size                 = UDim2.new(1, -110, 1, 0)
titleLabel.Position             = UDim2.new(0, 26, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text                 = "SILENT HUB"
titleLabel.TextColor3           = C.text
titleLabel.TextSize             = 13
titleLabel.Font                 = Enum.Font.GothamBold
titleLabel.TextXAlignment       = Enum.TextXAlignment.Left
titleLabel.Parent               = titleBar

-- Master ON/OFF
local masterBtn = Instance.new("TextButton")
masterBtn.Size             = UDim2.new(0, 38, 0, 22)
masterBtn.Position         = UDim2.new(1, -88, 0.5, -11)
masterBtn.BackgroundColor3 = C.toggleOff
masterBtn.Text             = "OFF"
masterBtn.TextColor3       = C.textSub
masterBtn.TextSize         = 10
masterBtn.Font             = Enum.Font.GothamBold
masterBtn.BorderSizePixel  = 0
masterBtn.Parent           = titleBar

local masterCorner = Instance.new("UICorner")
masterCorner.CornerRadius = UDim.new(0, 5)
masterCorner.Parent       = masterBtn

-- Minimize "S" button
local minBtn = Instance.new("TextButton")
minBtn.Size             = UDim2.new(0, 26, 0, 26)
minBtn.Position         = UDim2.new(1, -56, 0.5, -13)
minBtn.BackgroundColor3 = C.btnBg
minBtn.Text             = "S"
minBtn.TextColor3       = C.textSub
minBtn.TextSize         = 12
minBtn.Font             = Enum.Font.GothamBold
minBtn.BorderSizePixel  = 0
minBtn.Parent           = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent       = minBtn

-- Close "X" button
local closeBtn = Instance.new("TextButton")
closeBtn.Size             = UDim2.new(0, 26, 0, 26)
closeBtn.Position         = UDim2.new(1, -28, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 18, 18)
closeBtn.Text             = "X"
closeBtn.TextColor3       = Color3.fromRGB(180, 80, 80)
closeBtn.TextSize         = 11
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.BorderSizePixel  = 0
closeBtn.Parent           = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent       = closeBtn

-- =====================
-- WARNING DIALOG
-- =====================
local function showCloseWarning()
    -- Overlay
    local overlay = Instance.new("Frame")
    overlay.Size             = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel  = 0
    overlay.ZIndex           = 10
    overlay.Parent           = screenGui

    -- Dialog
    local dialog = Instance.new("Frame")
    dialog.Size             = UDim2.new(0, 250, 0, 140)
    dialog.Position         = UDim2.new(0.5, -125, 0.5, -70)
    dialog.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    dialog.BorderSizePixel  = 0
    dialog.ZIndex           = 11
    dialog.Parent           = screenGui

    local dialogCorner = Instance.new("UICorner")
    dialogCorner.CornerRadius = UDim.new(0, 10)
    dialogCorner.Parent       = dialog

    local dialogStroke = Instance.new("UIStroke")
    dialogStroke.Color     = Color3.fromRGB(70, 70, 70)
    dialogStroke.Thickness = 1
    dialogStroke.Parent    = dialog

    -- Dialog title bar
    local dTitle = Instance.new("Frame")
    dTitle.Size             = UDim2.new(1, 0, 0, 36)
    dTitle.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    dTitle.BorderSizePixel  = 0
    dTitle.ZIndex           = 11
    dTitle.Parent           = dialog

    local dTitleCorner = Instance.new("UICorner")
    dTitleCorner.CornerRadius = UDim.new(0, 10)
    dTitleCorner.Parent       = dTitle

    local dTitleFix = Instance.new("Frame")
    dTitleFix.Size             = UDim2.new(1, 0, 0, 10)
    dTitleFix.Position         = UDim2.new(0, 0, 1, -10)
    dTitleFix.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    dTitleFix.BorderSizePixel  = 0
    dTitleFix.ZIndex           = 11
    dTitleFix.Parent           = dTitle

    local dTitleLbl = Instance.new("TextLabel")
    dTitleLbl.Size                 = UDim2.new(1, 0, 1, 0)
    dTitleLbl.BackgroundTransparency = 1
    dTitleLbl.Text                 = "⚠  WARNING"
    dTitleLbl.TextColor3           = Color3.fromRGB(200, 160, 80)
    dTitleLbl.TextSize             = 12
    dTitleLbl.Font                 = Enum.Font.GothamBold
    dTitleLbl.ZIndex               = 12
    dTitleLbl.Parent               = dTitle

    local dMsg = Instance.new("TextLabel")
    dMsg.Size                 = UDim2.new(1, -24, 0, 44)
    dMsg.Position             = UDim2.new(0, 12, 0, 44)
    dMsg.BackgroundTransparency = 1
    dMsg.Text                 = "Yakin ingin menutup\nSilent Hub FPS Optimizer?"
    dMsg.TextColor3           = Color3.fromRGB(160, 160, 160)
    dMsg.TextSize             = 12
    dMsg.Font                 = Enum.Font.Gotham
    dMsg.TextWrapped          = true
    dMsg.ZIndex               = 12
    dMsg.Parent               = dialog

    -- YES button
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size             = UDim2.new(0, 100, 0, 28)
    yesBtn.Position         = UDim2.new(0, 14, 1, -40)
    yesBtn.BackgroundColor3 = Color3.fromRGB(50, 18, 18)
    yesBtn.Text             = "YA, TUTUP"
    yesBtn.TextColor3       = Color3.fromRGB(200, 80, 80)
    yesBtn.TextSize         = 11
    yesBtn.Font             = Enum.Font.GothamBold
    yesBtn.BorderSizePixel  = 0
    yesBtn.ZIndex           = 12
    yesBtn.Parent           = dialog

    local yesBtnCorner = Instance.new("UICorner")
    yesBtnCorner.CornerRadius = UDim.new(0, 6)
    yesBtnCorner.Parent       = yesBtn

    -- NO button
    local noBtn = Instance.new("TextButton")
    noBtn.Size             = UDim2.new(0, 100, 0, 28)
    noBtn.Position         = UDim2.new(1, -114, 1, -40)
    noBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    noBtn.Text             = "BATAL"
    noBtn.TextColor3       = Color3.fromRGB(140, 140, 140)
    noBtn.TextSize         = 11
    noBtn.Font             = Enum.Font.GothamBold
    noBtn.BorderSizePixel  = 0
    noBtn.ZIndex           = 12
    noBtn.Parent           = dialog

    local noBtnCorner = Instance.new("UICorner")
    noBtnCorner.CornerRadius = UDim.new(0, 6)
    noBtnCorner.Parent       = noBtn

    -- Animate in
    dialog.Position = UDim2.new(0.5, -125, 0.5, -50)
    dialog.BackgroundTransparency = 1
    TweenService:Create(dialog, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -125, 0.5, -70),
        BackgroundTransparency = 0
    }):Play()

    yesBtn.MouseButton1Click:Connect(function()
        overlay:Destroy()
        dialog:Destroy()
        if masterEnabled then revertAll() end
        screenGui:Destroy()
    end)

    noBtn.MouseButton1Click:Connect(function()
        TweenService:Create(dialog, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -125, 0.5, -50),
            BackgroundTransparency = 1
        }):Play()
        wait(0.15)
        overlay:Destroy()
        dialog:Destroy()
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    showCloseWarning()
end)

-- =====================
-- CONTENT SCROLL
-- =====================
local content = Instance.new("ScrollingFrame")
content.Size                 = UDim2.new(1, 0, 1, -46)
content.Position             = UDim2.new(0, 0, 0, 46)
content.BackgroundTransparency = 1
content.BorderSizePixel      = 0
content.ScrollBarThickness   = 3
content.ScrollBarImageColor3 = C.border
content.CanvasSize           = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize  = Enum.AutomaticSize.Y
content.Parent               = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding    = UDim.new(0, 0)
contentLayout.SortOrder  = Enum.SortOrder.LayoutOrder
contentLayout.Parent     = content

local contentPad = Instance.new("UIPadding")
contentPad.PaddingLeft   = UDim.new(0, 12)
contentPad.PaddingRight  = UDim.new(0, 12)
contentPad.PaddingTop    = UDim.new(0, 10)
contentPad.PaddingBottom = UDim.new(0, 10)
contentPad.Parent        = content

-- =====================
-- TOGGLE HELPER
-- =====================
local function makeToggle(labelText, description, defaultOn, layoutOrder, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 56)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel  = 0
    row.LayoutOrder      = layoutOrder
    row.Parent           = content

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent       = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color     = C.border
    rowStroke.Thickness = 0.8
    rowStroke.Parent    = row

    local lbl = Instance.new("TextLabel")
    lbl.Size                 = UDim2.new(1, -62, 0, 20)
    lbl.Position             = UDim2.new(0, 12, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text                 = labelText
    lbl.TextColor3           = C.text
    lbl.TextSize             = 12
    lbl.Font                 = Enum.Font.GothamBold
    lbl.TextXAlignment       = Enum.TextXAlignment.Left
    lbl.Parent               = row

    local desc = Instance.new("TextLabel")
    desc.Size                = UDim2.new(1, -62, 0, 14)
    desc.Position            = UDim2.new(0, 12, 0, 31)
    desc.BackgroundTransparency = 1
    desc.Text                = description
    desc.TextColor3          = C.textSub
    desc.TextSize            = 10
    desc.Font                = Enum.Font.Gotham
    desc.TextXAlignment      = Enum.TextXAlignment.Left
    desc.Parent              = row

    local toggleBg = Instance.new("Frame")
    toggleBg.Size            = UDim2.new(0, 38, 0, 20)
    toggleBg.Position        = UDim2.new(1, -50, 0.5, -10)
    toggleBg.BackgroundColor3 = defaultOn and C.toggleOn or C.toggleOff
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent          = row

    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent       = toggleBg

    local knob = Instance.new("Frame")
    knob.Size            = UDim2.new(0, 14, 0, 14)
    knob.Position        = defaultOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    knob.BackgroundColor3 = C.knob
    knob.BorderSizePixel = 0
    knob.Parent          = toggleBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent       = knob

    local spacer = Instance.new("Frame")
    spacer.Size             = UDim2.new(1, 0, 0, 5)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder      = layoutOrder
    spacer.Parent           = content

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.Parent               = row

    local isOn = defaultOn
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        TweenService:Create(toggleBg, ti, {BackgroundColor3 = isOn and C.toggleOn or C.toggleOff}):Play()
        TweenService:Create(knob, ti, {Position = isOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
        callback(isOn)
    end)

    return row
end

-- =====================
-- SECTION LABEL HELPER
-- =====================
local function makeSection(text, layoutOrder)
    local lbl = Instance.new("TextLabel")
    lbl.Size             = UDim2.new(1, 0, 0, 26)
    lbl.BackgroundTransparency = 1
    lbl.Text             = "// " .. text
    lbl.TextColor3       = C.section
    lbl.TextSize         = 10
    lbl.Font             = Enum.Font.GothamBold
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    lbl.LayoutOrder      = layoutOrder
    lbl.Parent           = content
end

-- =====================
-- SLIDER HELPER
-- =====================
local function makeSlider(labelText, min, max, default, layoutOrder, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 64)
    row.BackgroundColor3 = C.card
    row.BorderSizePixel  = 0
    row.LayoutOrder      = layoutOrder
    row.Parent           = content

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent       = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color     = C.border
    rowStroke.Thickness = 0.8
    rowStroke.Parent    = row

    local lbl = Instance.new("TextLabel")
    lbl.Size             = UDim2.new(1, -50, 0, 18)
    lbl.Position         = UDim2.new(0, 12, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text             = labelText
    lbl.TextColor3       = C.text
    lbl.TextSize         = 12
    lbl.Font             = Enum.Font.GothamBold
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    lbl.Parent           = row

    local valLabel = Instance.new("TextLabel")
    valLabel.Size        = UDim2.new(0, 38, 0, 18)
    valLabel.Position    = UDim2.new(1, -50, 0, 10)
    valLabel.BackgroundTransparency = 1
    valLabel.Text        = tostring(default)
    valLabel.TextColor3  = C.accent
    valLabel.TextSize    = 12
    valLabel.Font        = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent      = row

    local track = Instance.new("Frame")
    track.Size           = UDim2.new(1, -24, 0, 3)
    track.Position       = UDim2.new(0, 12, 0, 42)
    track.BackgroundColor3 = C.toggleOff
    track.BorderSizePixel = 0
    track.Parent         = row

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent       = track

    local fill = Instance.new("Frame")
    local pct = (default - min) / (max - min)
    fill.Size            = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = C.fillBar
    fill.BorderSizePixel = 0
    fill.Parent          = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent       = fill

    local thumb = Instance.new("Frame")
    thumb.Size           = UDim2.new(0, 12, 0, 12)
    thumb.Position       = UDim2.new(pct, -6, 0.5, -6)
    thumb.BackgroundColor3 = C.knob
    thumb.BorderSizePixel = 0
    thumb.ZIndex         = 2
    thumb.Parent         = track

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent       = thumb

    local spacer = Instance.new("Frame")
    spacer.Size             = UDim2.new(1, 0, 0, 5)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder      = layoutOrder
    spacer.Parent           = content

    local dragging = false
    local trackBtn = Instance.new("TextButton")
    trackBtn.Size            = UDim2.new(1, 0, 0, 24)
    trackBtn.Position        = UDim2.new(0, 0, 0, 32)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text            = ""
    trackBtn.ZIndex          = 3
    trackBtn.Parent          = row

    local function updateSlider(input)
        local trackAbs  = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        local relX      = math.clamp((input.Position.X - trackAbs.X) / trackSize.X, 0, 1)
        local value     = math.round(min + relX * (max - min))
        valLabel.Text   = tostring(value)
        fill.Size       = UDim2.new(relX, 0, 1, 0)
        thumb.Position  = UDim2.new(relX, -6, 0.5, -6)
        callback(value)
    end

    trackBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    trackBtn.MouseButton1Up:Connect(function(x, y)
        updateSlider({Position = Vector3.new(x, y, 0)})
    end)
end

-- =====================
-- BUILD UI
-- =====================
makeSection("LIGHTING", 0)
makeToggle("Remove Post Effects", "Bloom, blur, color correction", settings.removePostEffects, 1, function(v)
    settings.removePostEffects = v
    if masterEnabled then applyPostEffects(v) end
end)
makeToggle("Disable Shadows", "Global shadow rendering", settings.disableShadows, 2, function(v)
    settings.disableShadows = v
    if masterEnabled then Lighting.GlobalShadows = not v end
end)

makeSection("WORLD", 10)
makeToggle("Flat Materials", "SmoothPlastic on all parts", settings.flatMaterials, 11, function(v)
    settings.flatMaterials = v
    if masterEnabled then applyMaterials(v) end
end)
makeToggle("Hide Decals & Textures", "Makes all textures invisible", settings.hideDecals, 12, function(v)
    settings.hideDecals = v
    if masterEnabled then applyDecals(v) end
end)
makeToggle("Flat Terrain Water", "Remove water waves & reflections", settings.flatTerrain, 13, function(v)
    settings.flatTerrain = v
    if masterEnabled then applyTerrain(v) end
end)

makeSection("PERFORMANCE", 20)
makeSlider("Render Quality", 1, 21, settings.qualityLevel, 21, function(v)
    settings.qualityLevel = v
    if masterEnabled then pcall(function() settings().Rendering.QualityLevel = v end) end
end)
makeToggle("Physics Sleep", "Idle parts skip physics calc", settings.physicsSleep, 22, function(v)
    settings.physicsSleep = v
    if masterEnabled then pcall(function() settings().Physics.AllowSleep = v end) end
end)

-- =====================
-- MINIMIZE LOGIC (S button)
-- =====================
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    if minimized then
        TweenService:Create(mainFrame, ti, {Size = UDim2.new(0, 286, 0, 46)}):Play()
        minBtn.Text = "S"
        minBtn.TextColor3 = C.accent
    else
        TweenService:Create(mainFrame, ti, {Size = UDim2.new(0, 286, 0, 390)}):Play()
        minBtn.Text = "S"
        minBtn.TextColor3 = C.textSub
    end
end)

-- =====================
-- MASTER ON/OFF
-- =====================
masterBtn.MouseButton1Click:Connect(function()
    masterEnabled = not masterEnabled
    local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
    if masterEnabled then
        masterBtn.Text = "ON"
        TweenService:Create(masterBtn, ti, {
            BackgroundColor3 = C.toggleOn,
            TextColor3       = C.text,
        }):Play()
        applyAll()
    else
        masterBtn.Text = "OFF"
        TweenService:Create(masterBtn, ti, {
            BackgroundColor3 = C.toggleOff,
            TextColor3       = C.textSub,
        }):Play()
        revertAll()
    end
end)
