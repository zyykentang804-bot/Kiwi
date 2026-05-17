-- ============================================================================
-- SILENT HUB v1 - FULL ULTIMATE EDITION (Final Fix)
-- ============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local HttpService = game:GetService("HttpService")

-- ==================== CEK KETERSEDIAAN FUNGSI ====================
local hasFilterGC = type(filtergc) == "function"
local hasGetGC = type(getgc) == "function"
local hasHookFunction = type(hookfunction) == "function"
local hasDrawing = type(Drawing) == "table"

if not hasDrawing then
    warn("[Silent Hub] Drawing tidak support. ESP dan FOV Circle tidak akan muncul.")
end

-- ==================== FULL BYPASS EMULATOR (Hyphon) ====================
local bypassActive = false
if hasFilterGC and hasGetGC and hasHookFunction then
    pcall(function()
        local OWpCsbCTXfeDG = filtergc('function', {IgnoreExecutor = true, Name = "OWpCsbCTXfeDG"}, true)
        if not OWpCsbCTXfeDG then return end
        
        local source = debug.info(OWpCsbCTXfeDG, "s")
        local function getUpval(func, idx)
            local ok, v = pcall(debug.getupvalue, func, idx)
            return ok and v or nil
        end
        local function safeGetUpvalues(func)
            local ok, result = pcall(debug.getupvalues, func)
            return ok and result or {}
        end
        
        local Function_2247 = nil
        local idx_Remote = nil
        for _, Value in filtergc("function", {Source = source, IgnoreExecutor = true}) do
            if not iscclosure(Value) then
                local upvals = safeGetUpvalues(Value)
                for i, v in upvals do
                    local ok, isInst = pcall(function() return typeof(v) == "Instance" and v:IsA("RemoteFunction") end)
                    if ok and isInst then
                        Function_2247 = Value
                        idx_Remote = i
                        break
                    end
                end
            end
            if Function_2247 then break end
            task.wait()
        end
        if not Function_2247 then return end
        
        local V5_Function = nil
        local idx_V5Handshake = nil
        for _, Value in filtergc("function", {Source = source, IgnoreExecutor = true}) do
            if not iscclosure(Value) and Value ~= Function_2247 then
                local upvals = safeGetUpvalues(Value)
                for i, v in upvals do
                    local ok, isShortStr = pcall(function() return typeof(v) == "string" and #v <= 4 and #v >= 1 end)
                    if ok and isShortStr then
                        V5_Function = Value
                        idx_V5Handshake = i
                        break
                    end
                end
            end
            if V5_Function then break end
            task.wait()
        end
        
        local SecondArgument_Token = nil
        local Last_RemoteFunction_Call = nil
        local Last_Hyphon_Check = nil
        
        _InvokeServer = nil
        _InvokeServer = hookfunction(Instance.new("RemoteFunction", nil).InvokeServer, newcclosure(function(Self, ...)
            if Self.Name:len() == 3 then
                Last_RemoteFunction_Call = tick()
                SecondArgument_Token = select(1, ...)[2]
            end
            return _InvokeServer(Self, ...)
        end))
        
        _FireServer = nil
        _FireServer = hookfunction(Instance.new("RemoteEvent", nil).FireServer, newcclosure(function(Self, ...)
            if Self and Self.Name == "Hyphon_Check" then
                Last_Hyphon_Check = tick()
            end
            return _FireServer(Self, ...)
        end))
        
        repeat task.wait() until Last_RemoteFunction_Call ~= nil and Last_Hyphon_Check ~= nil
        
        local idx_FirstToken, idx_SecondToken, idx_SixthKey = nil, nil, nil
        local idx_EleventhToken, idx_CurrentNumber = nil, nil
        local TenthArgument_Table = nil
        local stringCount = 0
        
        local upvals2247 = safeGetUpvalues(Function_2247)
        for i, v in upvals2247 do
            local t = typeof(v)
            if t == "string" then
                stringCount = stringCount + 1
                if stringCount == 1 then idx_FirstToken = i
                elseif stringCount == 2 then idx_SecondToken = i
                elseif stringCount == 6 then idx_SixthKey = i
                elseif stringCount == 11 then idx_EleventhToken = i
                end
            elseif t == "number" and not idx_CurrentNumber then
                idx_CurrentNumber = i
            elseif t == "userdata" and not TenthArgument_Table then
                local nextVal = getUpval(Function_2247, i + 1)
                if nextVal then
                    local ok, tbl = pcall(function() return v[nextVal] end)
                    if ok and typeof(tbl) == "table" then TenthArgument_Table = tbl end
                end
            end
        end
        if not TenthArgument_Table then
            for i, v in upvals2247 do
                if typeof(v) == "table" then TenthArgument_Table = v; break end
            end
        end
        
        local Emulator = setmetatable({
            Encode = function(s) return s end,
            Decode = function(s) return s end,
            fake_dec = getfenv(OWpCsbCTXfeDG).fake_dec,
            Tablets = {[1]=nil,[2]=nil,[3]=nil,[4]=nil,[5]=nil,[6]=nil},
            SSL = 192429429429 - game.PlaceVersion / LocalPlayer.UserId + game.PlaceVersion,
            Handshake_V5 = V5_Function and tostring(getUpval(V5_Function, idx_V5Handshake)) or "V5",
            Remote = getUpval(Function_2247, idx_Remote),
            FirstArgument_Token = getUpval(Function_2247, idx_FirstToken),
            SecondArgument_Token = getUpval(Function_2247, idx_SecondToken),
            SixthArgument_Key = getUpval(Function_2247, idx_SixthKey),
            TenthArgument_Table = TenthArgument_Table,
            Eleventh_Token = getUpval(Function_2247, idx_EleventhToken),
            Current_Number = getUpval(Function_2247, idx_CurrentNumber),
            Hyphon_Script = (function() for _, v in pairs(getnilinstances()) do if v:IsA("Script") and v.Name:len()==32 then return v end end end)(),
            Hyphon_Check = (function() return cloneref(game:GetService("MemoryStoreService")):FindFirstChild("Hyphon_Check") end)(),
            Last_RemoteFunction_Call = Last_RemoteFunction_Call,
            Last_Hyphon_Check = Last_Hyphon_Check,
            Logs = { Enabled = true, Method = "Print" },
        }, {})
        
        local _Script_ = nil
        for _, v in pairs(getnilinstances()) do if v:IsA("Script") and v.Name:len()==32 then _Script_ = v end end
        if _Script_ then
            local Bit_32; Bit_32 = hookfunction(bit32.bxor, function(a,b,c,d,e)
                if not checkcaller() and getcallingscript() == _Script_ then return task.wait(9e9) end
                return Bit_32(a,b,c,d,e)
            end)
        end
        
        local function Get_Tablets()
            local Cache = {}
            for _, v in Emulator.Tablets do table.insert(Cache, v) end
            return Cache
        end
        
        for i, v in upvals2247 do
            if i == 24 then Emulator.Tablets[1]=v
            elseif i==25 then Emulator.Tablets[2]=v
            elseif i==26 then Emulator.Tablets[3]=v
            elseif i==27 then Emulator.Tablets[4]=v
            elseif i==28 then Emulator.Tablets[5]=v
            elseif i==29 then Emulator.Tablets[6]=v
            end
        end
        
        task.spawn(function() while true do Emulator.Tablets[1]=tick(); task.wait(9) end end)
        task.spawn(function() while true do Emulator.Tablets[2]=tick(); task.wait(9) end end)
        task.spawn(function() while true do Emulator.Tablets[3]=tick(); task.wait(10) end end)
        task.spawn(function() while true do Emulator.Tablets[4]=tick(); task.wait(4) end end)
        
        local v3020 = nil
        for _, v in filtergc("function", {Upvalues={LocalPlayer}, Source=source, IgnoreExecutor=true}) do
            if not iscclosure(v) then
                local ok1, t1 = pcall(debug.getupvalue, v, 1)
                local ok3, t3 = pcall(debug.getupvalue, v, 3)
                if ok1 and type(t1)=='function' and ok3 and type(t3)=='table' then v3020=v; break end
            end
            task.wait()
        end
        local _2102 = filtergc("function", {StartLine=2102, IgnoreExecutor=true}, true)
        if v3020 and _2102 and typeof(Emulator.Remote) == "Instance" then
            Emulator.Remote.OnClientInvoke = function(a1,a2,a3,a4,a5,a6)
                Emulator.SecondArgument_Token = a1
                local v297 = math.floor(workspace:GetServerTimeNow()/8)%87/78
                local v298 = math.floor(math.noise(Emulator.SSL+v297, LocalPlayer.UserId,0)*628)
                local fake_dec_result = ""
                pcall(function() fake_dec_result = Emulator.fake_dec(a3, tostring(LocalPlayer.UserId)) end)
                return unpack({
                    debug.getupvalue(_2102,26),
                    tostring(math.random(242,789)),
                    fake_dec_result,
                    v3020(v298),
                    tostring(workspace:GetServerTimeNow()),
                    { CI=tostring(tick()), TL=Get_Tablets(), GL=nil, LS=3+game.PlaceVersion }
                })
            end
            task.spawn(function()
                task.wait(tick()-Emulator.Last_Hyphon_Check)
                while true do
                    Emulator.Hyphon_Check:FireServer(tick(), Emulator.Handshake_V5.."Handshake_V5")
                    task.wait(0.1)
                    Emulator.Hyphon_Check:FireServer()
                    task.wait(9)
                end
            end)
            task.spawn(function()
                while task.wait(35) do
                    Emulator.Tablets[5]=tick()-0.5
                    Emulator.Tablets[6]=tick()
                    if tostring(Emulator.Current_Number)=="0" then Emulator.Current_Number="1"
                    elseif tostring(Emulator.Current_Number)=="1" then Emulator.Current_Number="2"
                    else Emulator.Current_Number="0" end
                    if not Emulator.SecondArgument_Token or typeof(Emulator.SecondArgument_Token)~="string" then
                        Emulator.SecondArgument_Token = getUpval(Function_2247, idx_SecondToken)
                    end
                    Emulator.Remote:InvokeServer({
                        Emulator.FirstArgument_Token,
                        Emulator.SecondArgument_Token,
                        nil,
                        tostring(Emulator.Current_Number),
                        "Hooks detected: _1__index",
                        Emulator.SixthArgument_Key,
                        "Hooked",
                        tostring(os.time()),
                        tick(),
                        Emulator.TenthArgument_Table,
                        Emulator.Eleventh_Token,
                        { CurrentTick=tostring(tick()), Tablets=Get_Tablets() },
                        { LuaFunction={true, function() end, string.format("Players.%s.PlayerGui.%s", LocalPlayer.Name, Emulator.Hyphon_Script.Name), 2266, "", 0, true}, SSL=Emulator.SSL, ["Metatable code"]="nil" }
                    })
                    if Emulator.Logs.Enabled then
                        print(string.format("[HYPHON EMULATOR] SENT DATA [%s %s] AT %s", Emulator.Remote.Name, Emulator.SecondArgument_Token, os.date("%X")))
                    end
                end
            end)
        end
        
        getgenv().Hyphon_Emulator = Emulator
        bypassActive = true
        print("✅ Full Bypass Emulator aktif")
    end)
else
    print("⚠️ Bypass emulator tidak aktif (executor tidak support fungsi yang diperlukan)")
end

-- ==================== LOAD LIBRARY UI ====================
local Library = nil
pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sametexe001/sametlibs/refs/heads/main/idkThisOne/Library.lua"))()
end)

if not Library then
    -- Fallback GUI
    local sg = Instance.new("ScreenGui")
    sg.Name = "SilentHub_Fallback"
    sg.Parent = game:GetService("CoreGui")
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 360, 0, 260)
    f.Position = UDim2.new(0.5, -180, 0.5, -130)
    f.BackgroundColor3 = Color3.fromRGB(15,15,22)
    f.Parent = sg
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,14)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,0,45)
    t.Position = UDim2.new(0,0,0,10)
    t.BackgroundTransparency = 1
    t.Text = "SILENT HUB v1"
    t.TextColor3 = Color3.fromRGB(255,100,100)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 22
    t.Parent = f
    local st = Instance.new("TextLabel")
    st.Size = UDim2.new(1,-20,0,50)
    st.Position = UDim2.new(0,10,0,70)
    st.BackgroundTransparency = 1
    st.Text = bypassActive and "✅ Bypass Emulator: AKTIF" or "⚠️ Bypass Emulator: TIDAK AKTIF\n(Executor tidak support)"
    st.TextWrapped = true
    st.Parent = f
    local c = Instance.new("TextButton")
    c.Size = UDim2.new(0,100,0,35)
    c.Position = UDim2.new(0.5,-50,1,-50)
    c.Text = "Tutup"
    c.BackgroundColor3 = Color3.fromRGB(80,80,100)
    c.Parent = f
    Instance.new("UICorner", c).CornerRadius = UDim.new(0,8)
    c.MouseButton1Click:Connect(function() sg:Destroy() end)
    return
end

-- ==================== MAIN GUI ====================
local Window = Library:Window({
    Logo = "123748867365417",
    FadeSpeed = 0.15,
    PagePadding = 19,
})

-- Tema abu-abu
Library.ChangeTheme("Accent", Color3.fromRGB(160, 160, 160))
Library.ChangeTheme("Light Accent", Color3.fromRGB(200, 200, 200))

local Tab1 = Window:Page({Icon = "109391165290124", Search = true})
local Tab2 = Window:Page({Icon = "72974659157165", Search = false})
local Tab3 = Window:Page({Icon = "109391165290124", Search = true})
local Tab4 = Window:Page({Icon = "129960652808688", Search = true})

-- ==================== TAB 1 : AIMBOT & SILENT AIM ====================
do
    local AimbotSub = Tab1:SubPage({Name = "Aimbot"})
    local SilentSub = Tab1:SubPage({Name = "Silent Aim"})
    
    -- Aimbot (magnet)
    do
        local AimSection = AimbotSub:Section({Name = "Aimbot (Magnet)", Side = "Left"})
        local aimEnabled = false
        local aimFov = 200
        local aimPart = "Head"
        local aimConnection = nil
        
        local function findAimbotTarget()
            if not LocalPlayer.Character then return nil end
            local mousePos = UserInputService:GetMouseLocation()
            local closest, closestDist = nil, aimFov + 1
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local char = plr.Character
                    if char then
                        local part = char:FindFirstChild(aimPart)
                        local hum = char:FindFirstChild("Humanoid")
                        if part and hum and hum.Health > 0 then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closest = plr
                                end
                            end
                        end
                    end
                end
            end
            return closest
        end
        
        local function startAimbot()
            if aimConnection then aimConnection:Disconnect() end
            aimConnection = RunService.RenderStepped:Connect(function()
                if not aimEnabled then return end
                local target = findAimbotTarget()
                if target and target.Character then
                    local head = target.Character:FindFirstChild("Head")
                    if head then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            pcall(function()
                                UserInputService:SetMousePosition(screenPos.X, screenPos.Y)
                            end)
                        end
                    end
                end
            end)
        end
        
        local aimToggle = AimSection:Toggle({
            Name = "Enable Aimbot",
            Flag = "Aimbot_Enable",
            Default = false,
            Callback = function(v) aimEnabled = v; if v then startAimbot() elseif aimConnection then aimConnection:Disconnect(); aimConnection = nil end end
        })
        aimToggle:Keybind({ Name = "Keybind", Flag = "Aimbot_Key", Default = Enum.KeyCode.X, Mode = "Toggle" })
        AimSection:Slider({ Name = "FOV", Flag = "Aimbot_FOV", Min = 50, Max = 500, Default = 200, Suffix = "px", Callback = function(v) aimFov = v end })
        AimSection:Dropdown({ Name = "Target Part", Flag = "Aimbot_Part", Items = {"Head","HumanoidRootPart","UpperTorso","LowerTorso"}, Default = "Head", Callback = function(v) aimPart = v end })
    end
    
    -- Silent Aim (lengkap dengan FOV circle, wallbang, excluded, snapline)
    do
        local SilentSection = SilentSub:Section({Name = "Silent Aim", Side = "Left"})
        local SilentAimEnabled = false
        local SilentAimPart = "HumanoidRootPart"
        local SilentWallbang = true
        local FovRadius = 250
        local FovMode = "PC"
        local FovColor = Color3.fromRGB(255,0,0)
        local FovTrans = 0.5
        local ShowFov = true
        local snaplineEnabled = false
        local snaplineColor = Color3.fromRGB(255,255,255)
        local snaplineMaxDist = 300
        local FovCircle, snaplineLine = nil, nil
        
        if hasDrawing then
            FovCircle = Drawing.new("Circle")
            FovCircle.Radius = FovRadius
            FovCircle.Thickness = 2
            FovCircle.Visible = ShowFov
            FovCircle.Color = FovColor
            FovCircle.Transparency = FovTrans
            FovCircle.NumSides = 64
            snaplineLine = Drawing.new("Line")
            snaplineLine.Thickness = 1.5
            snaplineLine.Visible = false
            snaplineLine.Color = snaplineColor
        end
        
        RunService.RenderStepped:Connect(function()
            if FovCircle then
                if not ShowFov then FovCircle.Visible = false; return end
                FovCircle.Visible = true
                FovCircle.Position = (FovMode == "PC") and UserInputService:GetMouseLocation() or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            end
            if snaplineEnabled and snaplineLine and LocalPlayer.Character and SilentAimEnabled then
                local target, targetPart = GetTarget()
                if target and targetPart then
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local dist3D = (targetPart.Position - root.Position).Magnitude
                        if dist3D <= snaplineMaxDist then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                snaplineLine.From = Vector2.new(screenPos.X, screenPos.Y)
                                snaplineLine.To = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                                snaplineLine.Visible = true
                                snaplineLine.Color = snaplineColor
                            else snaplineLine.Visible = false end
                        else snaplineLine.Visible = false end
                    else snaplineLine.Visible = false end
                else snaplineLine.Visible = false end
            elseif snaplineLine then snaplineLine.Visible = false end
        end)
        
        local function GetTarget()
            if not LocalPlayer.Character then return nil, nil end
            local fovCenter = (FovMode == "PC") and UserInputService:GetMouseLocation() or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local closestPart, closestTarget, closestDist = nil, nil, FovRadius + 1
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local excluded = false
                    if _G.ExcludedPlayers and type(_G.ExcludedPlayers)=="table" then
                        for _, n in pairs(_G.ExcludedPlayers) do if n == plr.Name then excluded=true break end end
                    end
                    if not excluded then
                        local char = plr.Character
                        if char then
                            local part = char:FindFirstChild(SilentAimPart)
                            local hum = char:FindFirstChild("Humanoid")
                            if part and hum and hum.Health > 0 then
                                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                                if onScreen then
                                    local dist = (fovCenter - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestPart = part
                                        closestTarget = plr
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return closestTarget, closestPart
        end
        
        if hasHookFunction and hasGetGC then
            task.spawn(function()
                while true do
                    pcall(function()
                        local CastBL = nil
                        for _, v in pairs(getgc(true)) do
                            if type(v)=="function" then
                                local info = debug.getinfo(v)
                                if info and info.name == "CastBlacklist" then
                                    CastBL = v
                                    break
                                end
                            end
                        end
                        if CastBL then
                            hookfunction(CastBL, function(origin, direction, blacklist)
                                if not SilentAimEnabled then
                                    local params = RaycastParams.new()
                                    params.FilterType = Enum.RaycastFilterType.Blacklist
                                    params.FilterDescendantsInstances = blacklist or {}
                                    return workspace:Raycast(origin, direction, params)
                                end
                                local target, targetPart = GetTarget()
                                if target and targetPart then
                                    local newDir = (targetPart.Position - origin).Unit * (direction.Magnitude or 500)
                                    local params = RaycastParams.new()
                                    params.FilterType = Enum.RaycastFilterType.Blacklist
                                    params.FilterDescendantsInstances = blacklist or {}
                                    local hit = workspace:Raycast(origin, newDir, params)
                                    if hit and hit.Instance and hit.Instance:IsDescendantOf(target.Character) then return hit end
                                end
                                local params = RaycastParams.new()
                                params.FilterType = Enum.RaycastFilterType.Blacklist
                                params.FilterDescendantsInstances = blacklist or {}
                                return workspace:Raycast(origin, direction, params)
                            end)
                            break
                        end
                    end)
                    task.wait(2)
                end
            end)
        end
        
        local saToggle = SilentSection:Toggle({ Name = "Enable Silent Aim", Flag = "Silent_Enable", Default = false, Callback = function(v) SilentAimEnabled = v end })
        saToggle:Keybind({ Name = "Keybind", Flag = "Silent_Key", Default = Enum.KeyCode.Q, Mode = "Toggle" })
        SilentSection:Slider({ Name = "FOV Radius", Flag = "Silent_FOV", Min = 50, Max = 500, Default = 250, Callback = function(v) FovRadius = v; if FovCircle then FovCircle.Radius = v end end })
        SilentSection:Dropdown({ Name = "Target Part", Flag = "Silent_Part", Items = {"Head","HumanoidRootPart","UpperTorso","LowerTorso"}, Default = "HumanoidRootPart", Callback = function(v) SilentAimPart = v end })
        SilentSection:Dropdown({ Name = "FOV Mode", Flag = "Silent_FOVMode", Items = {"PC (Mouse)","Mobile (Center)"}, Default = "PC (Mouse)", Callback = function(v) FovMode = (v == "PC (Mouse)") and "PC" or "Mobile" end })
        SilentSection:Toggle({ Name = "Wallbang", Flag = "Silent_Wallbang", Default = true, Callback = function(v) SilentWallbang = v end })
        SilentSection:Colorpicker({ Name = "FOV Color", Flag = "Silent_FOVColor", Default = Color3.fromRGB(255,0,0), Callback = function(col) FovColor = col; if FovCircle then FovCircle.Color = col end end })
        SilentSection:Slider({ Name = "FOV Transparency", Flag = "Silent_FOVTrans", Min = 0, Max = 1, Default = 0.5, Decimals = 2, Callback = function(v) FovTrans = v; if FovCircle then FovCircle.Transparency = v end end })
        SilentSection:Toggle({ Name = "Show FOV Circle", Flag = "Silent_ShowFOV", Default = true, Callback = function(v) ShowFov = v; if FovCircle then FovCircle.Visible = v end end })
        SilentSection:Toggle({ Name = "Snapline", Flag = "Silent_Snapline", Default = false, Callback = function(v) snaplineEnabled = v; if not v and snaplineLine then snaplineLine.Visible = false end end })
        SilentSection:Slider({ Name = "Snapline Max Distance", Flag = "Silent_SnaplineDist", Min = 1, Max = 700, Default = 300, Suffix = " studs", Callback = function(v) snaplineMaxDist = v end })
        SilentSection:Colorpicker({ Name = "Snapline Color", Flag = "Silent_SnaplineColor", Default = Color3.fromRGB(255,255,255), Callback = function(col) snaplineColor = col; if snaplineLine then snaplineLine.Color = col end end })
        
        SilentSection:Label("Excluded Players", "Left")
        local function getPlayerList()
            local list = {}
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list, p.Name) end end
            return list
        end
        local excludeDropdown = SilentSection:Dropdown({ Name = "Select Player", Flag = "ExcludeSelect", Items = getPlayerList(), Multi = false })
        SilentSection:Button({ Name = "Exclude Selected", Callback = function()
            local selected = excludeDropdown.Value
            if selected then
                if not _G.ExcludedPlayers then _G.ExcludedPlayers = {} end
                local found = false
                for _, n in pairs(_G.ExcludedPlayers) do if n == selected then found=true break end end
                if not found then table.insert(_G.ExcludedPlayers, selected) end
            end
        end }):SubButton({ Name = "Unexclude Selected", Callback = function()
            local selected = excludeDropdown.Value
            if selected and _G.ExcludedPlayers then
                for i,n in pairs(_G.ExcludedPlayers) do if n == selected then table.remove(_G.ExcludedPlayers,i) break end end
            end
        end })
        SilentSection:Button({ Name = "Clear All Excluded", Callback = function() _G.ExcludedPlayers = {} end })
        Players.PlayerAdded:Connect(function() excludeDropdown:Refresh(getPlayerList()) end)
        Players.PlayerRemoving:Connect(function() excludeDropdown:Refresh(getPlayerList()) end)
    end
end

-- ==================== TAB 2: TELEPORT ====================
do
    local VehicleSub = Tab2:SubPage({Name = "Vehicle Teleport"})
    local InstantSub = Tab2:SubPage({Name = "Instant Teleport"})
    
    do
        local vehSection = VehicleSub:Section({Name = "Vehicle Teleport", Side = "Left"})
        local cachedSeat = nil
        local function updateSeatCache()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            cachedSeat = hum and hum.SeatPart or nil
        end
        LocalPlayer.CharacterAdded:Connect(function(char)
            local hum = char:WaitForChild("Humanoid",10)
            if hum then hum:GetPropertyChangedSignal("SeatPart"):Connect(updateSeatCache) end
            updateSeatCache()
        end)
        updateSeatCache()
        local function teleportTo(pos)
            if not cachedSeat then Library:Notification("Error","Not in vehicle!",2) return end
            local vm = cachedSeat:FindFirstAncestorWhichIsA("Model")
            if vm and vm.PrimaryPart then vm:SetPrimaryPartCFrame(CFrame.new(pos.X,pos.Y+2,pos.Z))
            elseif cachedSeat then cachedSeat.CFrame = CFrame.new(pos.X,pos.Y+2,pos.Z) end
        end
        local LOCATIONS = {
            {"Dealer NPC", Vector3.new(770.992,3.71,433.75)},
            {"NPC Marshmallow", Vector3.new(510.061,4.476,600.548)},
            {"Apart 1", Vector3.new(1137.992,9.932,449.753)},
            {"Apart 2", Vector3.new(1139.174,9.932,420.556)},
            {"Apart 3", Vector3.new(984.856,9.932,247.280)},
            {"Apart 4", Vector3.new(988.311,9.932,221.664)},
            {"Apart 5", Vector3.new(923.954,9.932,42.202)},
            {"Apart 6", Vector3.new(895.721,9.932,41.928)},
            {"Casino", Vector3.new(1166.33,3.36,-29.77)},
            {"GS UJUNG", Vector3.new(-466.525,3.862,357.661)},
            {"GS BINARY", Vector3.new(-280.351,3.742,248.872)},
            {"GS MID", Vector3.new(218.427,3.737,-176.975)},
        }
        for _,loc in ipairs(LOCATIONS) do vehSection:Button({ Name = loc[1], Callback = function() teleportTo(loc[2]) end }) end
        local statusLabel = vehSection:Label("Status: Not in vehicle", "Left")
        RunService.Heartbeat:Connect(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local seat = hum and hum.SeatPart
            statusLabel.Instance.Text = "Status: " .. (seat and "In vehicle" or "Not in vehicle")
        end)
    end
    
    do
        local instSection = InstantSub:Section({Name = "Instant Teleport (Void)", Side = "Left"})
        local isTeleporting = false; local pendingDest = nil
        local function teleportToVoid(dest)
            if isTeleporting then return end
            local char = LocalPlayer.Character; if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            isTeleporting = true; pendingDest = dest
            hrp.CFrame = CFrame.new(999999,999999,999999)
            local conn; conn = LocalPlayer.CharacterAdded:Connect(function(newChar)
                conn:Disconnect()
                task.wait(0.2)
                local newHrp = newChar:FindFirstChild("HumanoidRootPart")
                if newHrp and pendingDest then newHrp.CFrame = CFrame.new(pendingDest.X, pendingDest.Y+3, pendingDest.Z) end
                pendingDest = nil; isTeleporting = false
            end)
            task.delay(3, function() if pendingDest then conn:Disconnect(); pendingDest=nil; isTeleporting=false; Library:Notification("Error","Teleport timeout",3) end end)
        end
        local LOCATIONS_INSTANT = {
            {"Dealer NPC", Vector3.new(770.992,3.71,433.75)},
            {"NPC Marshmallow", Vector3.new(510.061,4.476,600.548)},
            {"Apart 1", Vector3.new(1137.992,9.932,449.753)},
            {"Apart 2", Vector3.new(1139.174,9.932,420.556)},
            {"Apart 3", Vector3.new(984.856,9.932,247.280)},
            {"Apart 4", Vector3.new(988.311,9.932,221.664)},
            {"Apart 5", Vector3.new(923.954,9.932,42.202)},
            {"Apart 6", Vector3.new(895.721,9.932,41.928)},
            {"Casino", Vector3.new(1166.33,3.36,-29.77)},
            {"GS UJUNG", Vector3.new(-466.525,3.862,357.661)},
            {"GS BINARY", Vector3.new(-280.351,3.742,248.872)},
            {"GS MID", Vector3.new(218.427,3.737,-176.975)},
        }
        for _,loc in ipairs(LOCATIONS_INSTANT) do instSection:Button({ Name = loc[1], Callback = function() teleportToVoid(loc[2]) end }) end
    end
end

-- ==================== TAB 3: MAIN FEATURES ====================
do
    local MainSection = Tab3:Section({Name = "Main Features", Side = "Left"})
    local wsEnabled = false; local wsValue = 16
    local flashEnabled = false; local flashHooked = false
    local noclipEnabled = false; local noclipParts = {}; local noclipConnection = nil
    local deleteMode = false; local highlightColor = Color3.fromRGB(255,0,0); local currentHighlight = nil; local deletedHistory = {}
    local flyEnabled = false; local flySpeed = 50; local flyConnection = nil; local activeKeys = {W=false,A=false,S=false,D=false,Space=false}
    local lp = LocalPlayer; local mouse = lp:GetMouse()
    
    MainSection:Slider({ Name = "Walk Speed", Flag = "WalkSpeed", Min = 16, Max = 23, Default = 16, Callback = function(v) wsValue = v; if wsEnabled then local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = v end end end })
    local wsToggle = MainSection:Toggle({ Name = "Enable Walk Speed", Flag = "WalkSpeedEnable", Default = false, Callback = function(v) wsEnabled = v; if v then if flashEnabled then flashToggle:Set(false) end; local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = wsValue end else local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 16 end end end })
    local flashToggle = MainSection:Toggle({ Name = "Walk Flash (Anti-Detect)", Flag = "WalkFlash", Default = false, Callback = function(v)
        flashEnabled = v
        if v then
            if wsEnabled then wsToggle:Set(false) end
            if not flashHooked and getrawmetatable then
                local mt = getrawmetatable(game)
                if mt then
                    setreadonly(mt, false)
                    local oldIndex = mt.__index
                    mt.__index = newcclosure(function(self,key) if self==game and key=="WalkSpeed" then return 16 end return oldIndex(self,key) end)
                    setreadonly(mt, true)
                    flashHooked = true; _G.FlashOldIndex = oldIndex
                end
            end
            local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = 40 end
        else
            if flashHooked and getrawmetatable then
                local mt = getrawmetatable(game)
                if mt and _G.FlashOldIndex then
                    setreadonly(mt, false); mt.__index = _G.FlashOldIndex; setreadonly(mt, true); flashHooked = false; _G.FlashOldIndex = nil
                end
            end
            local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = wsEnabled and wsValue or 16 end
        end
    end })
    
    -- Noclip
    local function updateNoclip()
        if not noclipEnabled then return end
        local char = lp.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local region = Region3.new(hrp.Position - Vector3.new(10,10,10), hrp.Position + Vector3.new(10,10,10))
        local parts = workspace:FindPartsInRegion3(region, char, math.huge)
        for _,part in pairs(parts) do
            if part:IsA("BasePart") and not noclipParts[part] and part.CanCollide and not part:IsDescendantOf(char) then
                noclipParts[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    end
    local function resetNoclip() for part,val in pairs(noclipParts) do if part:IsA("BasePart") then part.CanCollide = val end end; noclipParts = {} end
    MainSection:Toggle({ Name = "Noclip", Flag = "Noclip", Default = false, Callback = function(v)
        noclipEnabled = v
        if v then if noclipConnection then noclipConnection:Disconnect() end; noclipConnection = RunService.Heartbeat:Connect(updateNoclip)
        else if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end; resetNoclip() end
    end })
    
    -- Delete Mode
    local function createHighlight(part)
        if currentHighlight then currentHighlight:Destroy() end
        local hl = Instance.new("BoxHandleAdornment"); hl.Adornee = part; hl.Size = part.Size; hl.Color3 = highlightColor; hl.Transparency = 0.5; hl.ZIndex = 10; hl.Parent = part
        currentHighlight = hl
    end
    local function removeHighlight() if currentHighlight then currentHighlight:Destroy(); currentHighlight = nil end end
    local function savePart(part)
        table.insert(deletedHistory, { name=part.Name, parent=part.Parent, cframe=part.CFrame, size=part.Size, transparency=part.Transparency, color=part.Color, material=part.Material, canCollide=part.CanCollide, anchored=part.Anchored })
        if #deletedHistory > 20 then table.remove(deletedHistory,1) end
    end
    local function undoDelete()
        if #deletedHistory==0 then return end
        local d = deletedHistory[#deletedHistory]; table.remove(deletedHistory)
        local p = Instance.new("Part"); p.Name=d.name; p.Size=d.size; p.CFrame=d.cframe; p.Transparency=d.transparency; p.Color=d.color; p.Material=d.material; p.CanCollide=d.canCollide; p.Anchored=d.anchored; p.Parent=d.parent
    end
    MainSection:Toggle({ Name = "Delete Mode (1-click)", Flag = "DeleteMode", Default = false, Callback = function(v) deleteMode=v; if not v then removeHighlight() end end })
    MainSection:Colorpicker({ Name = "Highlight Color", Flag = "HighlightColor", Default = Color3.fromRGB(255,0,0), Callback = function(col) highlightColor=col; if currentHighlight then currentHighlight.Color3=col end end })
    MainSection:Button({ Name = "Undo Last Delete", Callback = undoDelete })
    RunService.RenderStepped:Connect(function()
        if deleteMode then
            local tgt = mouse.Target
            if tgt and tgt:IsA("BasePart") and not tgt:IsDescendantOf(lp.Character) then createHighlight(tgt) else removeHighlight() end
        end
    end)
    UserInputService.InputBegan:Connect(function(input,gpe)
        if gpe or not deleteMode or input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
        local tgt = mouse.Target
        if tgt and tgt:IsA("BasePart") and not tgt:IsDescendantOf(lp.Character) then savePart(tgt); tgt:Destroy(); removeHighlight() end
    end)
    
    -- Fly
    local function updateFly(dt)
        if not flyEnabled then return end
        local char = lp.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = true
            pcall(function()
                for _,state in pairs({Enum.HumanoidStateType.Jumping, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Running, Enum.HumanoidStateType.StrafingNoPhysics, Enum.HumanoidStateType.Seated}) do hum:SetStateEnabled(state, false) end
            end)
        end
        local cam = Camera
        local move = Vector3.new(0,0,0)
        if activeKeys.W then move = move + cam.CFrame.LookVector end
        if activeKeys.S then move = move - cam.CFrame.LookVector end
        if activeKeys.D then move = move + cam.CFrame.RightVector end
        if activeKeys.A then move = move - cam.CFrame.RightVector end
        if activeKeys.Space then move = move + cam.CFrame.UpVector end
        if move.Magnitude > 0 then
            move = move.Unit * flySpeed * dt
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.CFrame = hrp.CFrame + move
        end
    end
    local function startFly() if flyConnection then flyConnection:Disconnect() end; flyConnection = RunService.RenderStepped:Connect(updateFly) end
    local function stopFly() if flyConnection then flyConnection:Disconnect(); flyConnection = nil end; local char=lp.Character; if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.PlatformStand=false; pcall(function() for _,state in pairs({Enum.HumanoidStateType.Jumping, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Running, Enum.HumanoidStateType.StrafingNoPhysics, Enum.HumanoidStateType.Seated}) do hum:SetStateEnabled(state, true) end end) end end end
    MainSection:Toggle({ Name = "Fly (Bypass Anti-Kick)", Flag = "FlyMode", Default = false, Callback = function(v) flyEnabled = v; if v then startFly() else stopFly() end end })
    MainSection:Slider({ Name = "Fly Speed", Flag = "FlySpeed", Min = 20, Max = 200, Default = 50, Callback = function(v) flySpeed = v end })
    UserInputService.InputBegan:Connect(function(input,gpe)
        if gpe or not flyEnabled then return end
        local k = input.KeyCode
        if k==Enum.KeyCode.W then activeKeys.W=true elseif k==Enum.KeyCode.A then activeKeys.A=true elseif k==Enum.KeyCode.S then activeKeys.S=true elseif k==Enum.KeyCode.D then activeKeys.D=true elseif k==Enum.KeyCode.Space then activeKeys.Space=true end
    end)
    UserInputService.InputEnded:Connect(function(input,gpe)
        if gpe or not flyEnabled then return end
        local k = input.KeyCode
        if k==Enum.KeyCode.W then activeKeys.W=false elseif k==Enum.KeyCode.A then activeKeys.A=false elseif k==Enum.KeyCode.S then activeKeys.S=false elseif k==Enum.KeyCode.D then activeKeys.D=false elseif k==Enum.KeyCode.Space then activeKeys.Space=false end
    end)
end

-- ==================== TAB 4: ESP + CUSTOM NAME ====================
do
    local EspSub = Tab4:SubPage({Name = "ESP"})
    local CustomSub = Tab4:SubPage({Name = "Custom Name"})
    
    -- ESP (lengkap dengan drawing, box, name, health, distance, skeleton, fill, color picker)
    if not hasDrawing then
        EspSub:Section({Name = "ESP", Side = "Left"}):Label("ESP tidak didukung oleh executor ini (Drawing tidak tersedia)", "Left")
    else
        local espSection = EspSub:Section({Name = "ESP Settings", Side = "Left"})
        local espEnabled = false
        local espMaxDist = 600
        local espColor = Color3.fromRGB(0,255,0)
        local fillBox = false
        local showSkeleton = false
        local showInventory = false
        local espCache = {}
        
        local function createESP(player)
            if espCache[player] then for _,o in pairs(espCache[player]) do o:Remove() end end
            local box = Drawing.new("Square"); box.Thickness=1; box.Color=espColor; box.Filled=fillBox
            local nameL = Drawing.new("Text"); nameL.Text=player.Name; nameL.Size=9; nameL.Font=1; nameL.Color=Color3.fromRGB(255,255,255); nameL.Outline=true; nameL.Center=true
            local hpBg = Drawing.new("Square"); hpBg.Thickness=1; hpBg.Color=Color3.fromRGB(30,30,30); hpBg.Filled=true
            local hpFl = Drawing.new("Square"); hpFl.Thickness=1; hpFl.Color=Color3.fromRGB(72,215,115); hpFl.Filled=true
            local dL = Drawing.new("Text"); dL.Size=9; dL.Font=1; dL.Color=Color3.fromRGB(160,160,175); dL.Outline=true; dL.Center=true
            local invL = Drawing.new("Text"); invL.Size=9; invL.Font=1; invL.Color=Color3.fromRGB(255,255,0); invL.Outline=true; invL.Center=true
            local skeletonLines = {}; for i=1,15 do skeletonLines[i]=Drawing.new("Line") end
            espCache[player] = {box,nameL,hpBg,hpFl,dL,invL,skeletonLines}
        end
        local function removeESP(p) if espCache[p] then for _,o in pairs(espCache[p]) do o:Remove() end; espCache[p]=nil end end
        for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then createESP(p) end end
        Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then createESP(p) end end)
        Players.PlayerRemoving:Connect(removeESP)
        
        local function getInventoryItem(plr)
            local char = plr.Character; if char then local tool = char:FindFirstChildWhichIsA("Tool"); if tool then return tool.Name end end
            local bp = plr.Backpack; if bp then local tool = bp:FindFirstChildWhichIsA("Tool"); if tool then return tool.Name end end
            return nil
        end
        local function getSkeletonPoints(char)
            local partNames = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}
            local fallback = {LeftUpperArm="Left Arm",LeftLowerArm="Left Arm",LeftHand="LeftHand",RightUpperArm="Right Arm",RightLowerArm="Right Arm",RightHand="RightHand",LeftUpperLeg="Left Leg",LeftLowerLeg="Left Leg",LeftFoot="LeftFoot",RightUpperLeg="Right Leg",RightLowerLeg="Right Leg",RightFoot="RightFoot"}
            local points = {}
            for _,name in ipairs(partNames) do
                local part = char:FindFirstChild(name)
                if not part and fallback[name] then part = char:FindFirstChild(fallback[name]) end
                table.insert(points, part and part.Position or nil)
            end
            return points
        end
        
        RunService.RenderStepped:Connect(function()
            if not espEnabled then for _,drs in pairs(espCache) do for _,o in pairs(drs) do o.Visible=false end end return end
            local myChar = LocalPlayer.Character; local myPos = myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar.HumanoidRootPart.Position
            local vX,vY = Camera.ViewportSize.X, Camera.ViewportSize.Y
            for player,drawings in pairs(espCache) do
                local box,nameL,hpBg,hpFl,dL,invL,skeletonLines = unpack(drawings)
                local char = player.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart"); local head = char and char:FindFirstChild("Head")
                if not (char and hum and root and head and hum.Health>0) then for _,o in pairs(drawings) do o.Visible=false end
                else
                    local d3 = myPos and (root.Position - myPos).Magnitude or 0
                    if d3>espMaxDist then for _,o in pairs(drawings) do o.Visible=false end
                    else
                        local rp,rOn = Camera:WorldToViewportPoint(root.Position)
                        local hp,hOn = Camera:WorldToViewportPoint(head.Position)
                        if rOn and hOn then
                            local height = math.abs(hp.Y - rp.Y)*1.5+8; local width = height*0.5
                            local bX = rp.X - width/2; local bY = hp.Y - 4
                            if bX+width>0 and bX<vX and bY+height>0 and bY<vY then
                                box.Color=espColor; box.Size=Vector2.new(width,height); box.Position=Vector2.new(bX,bY); box.Filled=fillBox; box.Visible=true
                                nameL.Text=player.Name; nameL.Position=Vector2.new(rp.X,bY-12); nameL.Visible=true
                                local hpPct = math.clamp(hum.Health/hum.MaxHealth,0,1)
                                hpBg.Size=Vector2.new(3,height-4); hpBg.Position=Vector2.new(bX-7,bY+2); hpBg.Visible=true
                                hpFl.Color=Color3.fromRGB(255*(1-hpPct),255*hpPct,80); hpFl.Size=Vector2.new(2,(height-6)*hpPct); hpFl.Position=Vector2.new(bX-6,bY+3+(height-6)*(1-hpPct)); hpFl.Visible=true
                                dL.Text=math.floor(d3).."m"; dL.Position=Vector2.new(rp.X,bY+height+2); dL.Visible=true
                                if showInventory then local item=getInventoryItem(player); if item then invL.Text=item; invL.Position=Vector2.new(rp.X,bY+height+14); invL.Visible=true else invL.Visible=false end else invL.Visible=false end
                                if showSkeleton then
                                    local points = getSkeletonPoints(char)
                                    local screenPoints = {}
                                    for i,pos in pairs(points) do if pos then local vec,on = Camera:WorldToViewportPoint(pos); if on then screenPoints[i]=Vector2.new(vec.X,vec.Y) else screenPoints[i]=nil end else screenPoints[i]=nil end end
                                    local connections = {{1,2},{2,3},{2,4},{4,5},{5,6},{2,7},{7,8},{8,9},{3,10},{10,11},{11,12},{3,13},{13,14},{14,15}}
                                    for idx,conn in pairs(connections) do local a=screenPoints[conn[1]]; local b=screenPoints[conn[2]]; if a and b then skeletonLines[idx].From=a; skeletonLines[idx].To=b; skeletonLines[idx].Color=espColor; skeletonLines[idx].Thickness=1; skeletonLines[idx].Visible=true else skeletonLines[idx].Visible=false end end
                                    for i=#connections+1,15 do skeletonLines[i].Visible=false end
                                else for i=1,15 do skeletonLines[i].Visible=false end end
                            else for _,o in pairs(drawings) do o.Visible=false end end
                        else for _,o in pairs(drawings) do o.Visible=false end end
                    end
                end
            end
        end)
        
        espSection:Toggle({ Name="Enable ESP", Flag="ESP_Enable", Default=false, Callback=function(v) espEnabled=v end })
        espSection:Slider({ Name="Max Distance", Flag="ESP_Distance", Min=10, Max=1000, Default=600, Callback=function(v) espMaxDist=v end })
        espSection:Colorpicker({ Name="ESP Color", Flag="ESP_Color", Default=Color3.fromRGB(0,255,0), Callback=function(col) espColor=col end })
        espSection:Toggle({ Name="Fill Box", Flag="ESP_FillBox", Default=false, Callback=function(v) fillBox=v end })
        espSection:Toggle({ Name="Show Skeleton", Flag="ESP_Skeleton", Default=false, Callback=function(v) showSkeleton=v end })
        espSection:Toggle({ Name="Show Inventory Item", Flag="ESP_Inventory", Default=false, Callback=function(v) showInventory=v end })
    end
    
    -- Custom Name
    do
        local customSection = CustomSub:Section({Name = "Custom Name & Tier", Side = "Left"})
        customSection:Textbox({ Name="Change Display Name", Flag="CustomName", Placeholder="New name...", Default="", Callback=function(text) if text~="" then pcall(function() local char=workspace.Characters:FindFirstChild(LocalPlayer.Name); if char and char.Head and char.Head.NameTag then char.Head.NameTag.MainFrame.NameLabel.Text=text end end) end end })
        customSection:Textbox({ Name="Change Username (RankTag)", Flag="CustomUsername", Placeholder="New username...", Default="", Callback=function(text) if text~="" then pcall(function() local char=workspace.Characters:FindFirstChild(LocalPlayer.Name); if char and char.Head and char.Head.RankTag then char.Head.RankTag.MainFrame.NameLabel.Text=text end end) end end })
        customSection:Dropdown({ Name="Username Tier Color", Flag="TierColor", Items={"Default","Tier 1 (Green)","Tier 2 (Peach)","Tier 3 (Blue)"}, Default="Default", Callback=function(sel) local colors={Default=Color3.new(1,1,1),["Tier 1 (Green)"]=Color3.fromRGB(130,220,130),["Tier 2 (Peach)"]=Color3.fromRGB(255,213,170),["Tier 3 (Blue)"]=Color3.fromRGB(100,149,237)}; pcall(function() local char=workspace.Characters:FindFirstChild(LocalPlayer.Name); if char and char.Head and char.Head.RankTag then char.Head.RankTag.MainFrame.NameLabel.TextColor3=colors[sel] end end) end })
    end
end

Library:Notification("Silent Hub v1 Loaded", "Bypass Emulator: " .. (bypassActive and "AKTIF ✅" or "TIDAK AKTIF ⚠️"), 5)
print("Silent Hub: All features loaded. Press Z to open menu.")
