-- ==============================================
--     GANKUNZ HUB V2 - ANDROID VERSION
--     Fitur: Silent Aim, ESP, ToF Silent Aim, Aimlock
--     Support: Touch Screen / HP
--     Created by: GanKunZ
--     Version: 2.1
-- ==============================================

-- ==============================================
-- 1. LOAD LIBRARY
-- ==============================================

local repo = "https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- ==============================================
-- 2. SERVICES
-- ==============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==============================================
-- 3. VARIABLES
-- ==============================================

-- ESP Settings
local ESP = {
    Enabled = false,
    Survivor = false,
    Killer = false,
    Distance = 100,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = false
}

-- Silent Aim Settings
local SilentAim = {
    Enabled = false,
    FOV = 200,
    Distance = 400,
    TargetPart = "HumanoidRootPart",
    Prediction = true,
    PredictStrength = 0.15,
    BulletSpeed = 800,
    TargetMode = "Killer"
}

-- ToF Silent Aim Settings
local ToFAim = {
    Enabled = false,
    TargetMode = "Killer",
    AimPart = "HumanoidRootPart",
    Predict = true,
    BulletSpeed = 200,
    Range = 90,
    DotThreshold = 0.5
}

-- Aimlock Settings
local Aimlock = {
    Enabled = false,
    Holding = false,
    TargetMode = "Killer",
    Strength = 0.5,
    Predict = true,
    PredictStrength = 0.12,
    FOV = 250,
    AimPart = "HumanoidRootPart"
}

-- Colors
local Colors = {
    Survivor = Color3.fromRGB(0, 255, 120),
    Killer = Color3.fromRGB(255, 60, 60)
}

-- Cache
local ESPCache = {
    Objects = {},
    Status = {}
}
local silentHookActive = false
local silentOriginalCast = nil
local _tofDeferred = false
local oldNamecall = nil
local AimlockConnection = nil
local HoldingAttack = false

-- Touch Button
local TouchButton = {
    Gui = nil,
    Button = nil,
    Visible = false
}

-- ==============================================
-- 4. HELPER FUNCTIONS
-- ==============================================

local function getRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function isAlive(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health > 0
end

-- ==============================================
-- 5. ESP SYSTEM
-- ==============================================

local function removeESP(obj)
    if ESPCache.Objects[obj] then
        ESPCache.Objects[obj]:Destroy()
        ESPCache.Objects[obj] = nil
    end
end

local function createESP(obj, color)
    if not obj then return end
    if ESPCache.Objects[obj] then
        ESPCache.Objects[obj].FillColor = color
        ESPCache.Objects[obj].OutlineColor = color
        return
    end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = obj
    ESPCache.Objects[obj] = h
    obj.AncestryChanged:Connect(function(_, parent)
        if not parent then removeESP(obj) end
    end)
end

local function createStatusESP(player, char, root)
    if not ESP.Enabled then
        if ESPCache.Status[char] then
            ESPCache.Status[char]:Destroy()
            ESPCache.Status[char] = nil
        end
        return
    end
    
    local head = char:FindFirstChild("Head")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not head or not hum then return end
    if hum.Health <= 0 then
        if ESPCache.Status[char] then
            ESPCache.Status[char]:Destroy()
            ESPCache.Status[char] = nil
        end
        return
    end
    
    local dist = (head.Position - root.Position).Magnitude
    if dist > ESP.Distance then
        if ESPCache.Status[char] then
            ESPCache.Status[char]:Destroy()
            ESPCache.Status[char] = nil
        end
        return
    end
    
    local text = ""
    if ESP.ShowName then
        text = text .. player.Name
        if ESP.ShowHealth then
            text = text .. string.format(" [HP: %.0f]", hum.Health)
        end
        text = text .. "\n"
    end
    if ESP.ShowDistance then
        text = text .. string.format("Dist: %.0f", dist)
    end
    
    if text == "" then
        if ESPCache.Status[char] then
            ESPCache.Status[char]:Destroy()
            ESPCache.Status[char] = nil
        end
        return
    end
    
    local teamColor = Color3.new(1, 1, 1)
    if player.Team then
        if player.Team.Name == "Killer" then
            teamColor = Colors.Killer
        elseif player.Team.Name == "Survivors" then
            teamColor = Colors.Survivor
        end
    end
    
    local billboard = ESPCache.Status[char]
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 120, 0, 50)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Text = text
        label.Parent = billboard
        billboard.Adornee = head
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = char
        ESPCache.Status[char] = billboard
    else
        local label = billboard:FindFirstChildOfClass("TextLabel")
        if label then
            label.Text = text
            label.TextColor3 = teamColor
        end
    end
end

-- ==============================================
-- 6. SILENT AIM SYSTEM
-- ==============================================

local function getSilentTarget()
    local root = getRoot()
    if not root then return nil end
    
    local cam = Camera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local best, bestDist = nil, SilentAim.FOV
    local myPos = root.Position
    
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not p.Character then continue end
        
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        local valid = false
        if SilentAim.TargetMode == "Killer" and p.Team and p.Team.Name == "Killer" then
            valid = true
        elseif SilentAim.TargetMode == "Survivor" and p.Team and p.Team.Name == "Survivors" then
            valid = true
        end
        if not valid then continue end
        
        local part = p.Character:FindFirstChild(SilentAim.TargetPart)
        if not part then
            part = p.Character:FindFirstChild("HumanoidRootPart")
        end
        if not part then continue end
        
        local targetPos = part.Position
        
        if SilentAim.Prediction then
            local vel = part.AssemblyLinearVelocity or Vector3.new()
            local dist = (targetPos - myPos).Magnitude
            local travelTime = dist / SilentAim.BulletSpeed
            targetPos = targetPos + vel * (SilentAim.PredictStrength * travelTime * 2)
        end
        
        local screenPos, onScreen = cam:WorldToViewportPoint(targetPos)
        if onScreen then
            local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if distFromCenter < bestDist and distFromCenter <= SilentAim.FOV then
                local worldDist = (targetPos - myPos).Magnitude
                if worldDist <= SilentAim.Distance then
                    bestDist = distFromCenter
                    best = part
                end
            end
        end
    end
    
    return best
end

local function setupSilentAim()
    if silentHookActive then return end
    
    local castTable = nil
    pcall(function()
        for i, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "cast") then
                castTable = v
                break
            end
        end
    end)
    
    if castTable then
        silentOriginalCast = castTable.cast
        if silentOriginalCast then
            silentHookActive = true
            castTable.cast = function(p1, p2, p3)
                if SilentAim.Enabled then
                    local target = getSilentTarget()
                    if target then
                        return target, target.Position, Vector3.new(0,1,0), target.Material
                    end
                end
                return silentOriginalCast(p1, p2, p3)
            end
            return
        end
    end
    
    pcall(function()
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if SilentAim.Enabled and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay") then
                local target = getSilentTarget()
                if target then
                    return target, target.Position, Vector3.new(0,1,0), target.Material
                end
            end
            return oldNamecall(self, ...)
        end)
        silentHookActive = true
    end)
end

local function removeSilentAim()
    if not silentHookActive then return end
    
    local castTable = nil
    pcall(function()
        for i, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "cast") then
                castTable = v
                break
            end
        end
    end)
    
    if castTable and silentOriginalCast then
        castTable.cast = silentOriginalCast
    end
    
    if oldNamecall then
        pcall(function()
            local mt = getrawmetatable(game)
            if mt and setreadonly then
                setreadonly(mt, false)
                mt.__namecall = oldNamecall
                setreadonly(mt, true)
            end
        end)
        oldNamecall = nil
    end
    
    silentHookActive = false
    silentOriginalCast = nil
end

-- ==============================================
-- 7. TOF SILENT AIM SYSTEM
-- ==============================================

local function setupToFSilentAim()
    if oldNamecall then return end
    
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        if setreadonly then setreadonly(mt, false) end
        
        oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if not checkcaller() and method == "FireServer" and ToFAim.Enabled then
                local tofRemote = ReplicatedStorage:FindFirstChild("Remotes", true)
                    and ReplicatedStorage.Remotes:FindFirstChild("Items", true)
                    and ReplicatedStorage.Remotes.Items:FindFirstChild("Twist of Fate", true)
                    and ReplicatedStorage.Remotes.Items["Twist of Fate"]:FindFirstChild("Fire")
                
                if self == tofRemote and typeof(args[1]) == "Instance" and typeof(args[2]) == "Vector3" then
                    local root = getRoot()
                    if root then
                        local bestPart, bestDist = nil, ToFAim.Range
                        
                        for _, p in pairs(Players:GetPlayers()) do
                            if p == LocalPlayer then continue end
                            if not p.Character then continue end
                            
                            local hum = p.Character:FindFirstChildOfClass("Humanoid")
                            if not hum or hum.Health <= 0 then continue end
                            
                            local valid = false
                            if ToFAim.TargetMode == "Killer" and p.Team and p.Team.Name == "Killer" then
                                valid = true
                            elseif ToFAim.TargetMode == "Survivor" and p.Team and p.Team.Name == "Survivors" then
                                valid = true
                            end
                            if not valid then continue end
                            
                            local targetPart = p.Character:FindFirstChild(ToFAim.AimPart)
                            if not targetPart then
                                targetPart = p.Character:FindFirstChild("HumanoidRootPart")
                            end
                            if not targetPart then continue end
                            
                            local d = (targetPart.Position - root.Position).Magnitude
                            if d <= bestDist then
                                bestDist = d
                                bestPart = targetPart
                            end
                        end
                        
                        if bestPart then
                            local gunPart = args[1]
                            local gunPos = pcall(function() return gunPart.Position end) and gunPart.Position or root.Position
                            
                            local targetPos = bestPart.Position
                            if ToFAim.Predict then
                                local vel = bestPart.AssemblyLinearVelocity or Vector3.new()
                                local travelTime = bestDist / ToFAim.BulletSpeed
                                targetPos = targetPos + (vel * travelTime)
                            end
                            
                            local dir = (targetPos - gunPos).Unit
                            local camLook = Camera.CFrame.LookVector
                            
                            if camLook:Dot(dir) >= ToFAim.DotThreshold then
                                _tofDeferred = true
                                task.defer(function()
                                    pcall(function() tofRemote:FireServer(args[1], dir) end)
                                    _tofDeferred = false
                                end)
                                return
                            end
                        end
                    end
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        if setreadonly then setreadonly(mt, true) end
    end)
end

-- ==============================================
-- 8. AIMLOCK SYSTEM (TOUCH SUPPORT)
-- ==============================================

local function getAimlockTarget()
    local cam = Camera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local best, shortest = nil, Aimlock.FOV
    
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        if not p.Character then continue end
        
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        local valid = false
        if Aimlock.TargetMode == "Killer" and p.Team and p.Team.Name == "Killer" then
            valid = true
        elseif Aimlock.TargetMode == "Survivor" and p.Team and p.Team.Name == "Survivors" then
            valid = true
        end
        if not valid then continue end
        
        local part = p.Character:FindFirstChild(Aimlock.AimPart)
        if not part then
            part = p.Character:FindFirstChild("HumanoidRootPart")
        end
        if not part then continue end
        
        local pos, onScreen = cam:WorldToViewportPoint(part.Position)
        if onScreen then
            local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
            if dist < shortest then
                shortest = dist
                best = part
            end
        end
    end
    
    return best
end

local function startAimlock()
    if AimlockConnection then return end
    
    AimlockConnection = RunService.RenderStepped:Connect(function()
        if not Aimlock.Enabled then return end
        if not Aimlock.Holding then return end
        
        local target = getAimlockTarget()
        if not target then return end
        
        local pos = target.Position
        if Aimlock.Predict then
            local vel = target.AssemblyLinearVelocity or Vector3.new()
            pos = pos + vel * Aimlock.PredictStrength
        end
        
        Camera.CFrame = Camera.CFrame:Lerp(
            CFrame.new(Camera.CFrame.Position, pos),
            Aimlock.Strength
        )
    end)
end

local function stopAimlock()
    if AimlockConnection then
        AimlockConnection:Disconnect()
        AimlockConnection = nil
    end
end

-- ==============================================
-- 9. TOUCH BUTTON FOR AIMLOCK (HP/ANDROID)
-- ==============================================

local function createTouchButton()
    -- Hapus button lama
    if TouchButton.Gui then
        TouchButton.Gui:Destroy()
        TouchButton.Gui = nil
        TouchButton.Button = nil
    end
    
    -- Buat ScreenGui
    TouchButton.Gui = Instance.new("ScreenGui")
    TouchButton.Gui.Name = "AimlockTouchButton"
    TouchButton.Gui.ResetOnSpawn = false
    TouchButton.Gui.IgnoreGuiInset = true
    TouchButton.Gui.Parent = PlayerGui
    
    -- Buat tombol
    TouchButton.Button = Instance.new("ImageButton")
    TouchButton.Button.Name = "AimlockButton"
    TouchButton.Button.Size = UDim2.new(0, 70, 0, 70)
    TouchButton.Button.Position = UDim2.new(0.88, 0, 0.82, 0)
    TouchButton.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    TouchButton.Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TouchButton.Button.BackgroundTransparency = 0.2
    TouchButton.Button.Image = "rbxassetid://73705354917255"
    TouchButton.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    TouchButton.Button.ImageTransparency = 0.2
    TouchButton.Button.ZIndex = 10
    TouchButton.Button.Parent = TouchButton.Gui
    TouchButton.Button.Visible = TouchButton.Visible and Aimlock.Enabled
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = TouchButton.Button
    
    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = TouchButton.Button
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "AIM"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.ZIndex = 11
    label.Parent = TouchButton.Button
    
    -- Touch Events
    TouchButton.Button.MouseButton1Down:Connect(function()
        if Aimlock.Enabled then
            Aimlock.Holding = true
            -- Ubah warna saat ditekan
            TouchButton.Button.ImageColor3 = Color3.fromRGB(255, 200, 0)
            stroke.Color = Color3.fromRGB(255, 200, 0)
        end
    end)
    
    TouchButton.Button.MouseButton1Up:Connect(function()
        Aimlock.Holding = false
        TouchButton.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
        stroke.Color = Color3.fromRGB(255, 255, 255)
    end)
    
    TouchButton.Button.MouseLeave:Connect(function()
        Aimlock.Holding = false
        TouchButton.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
        stroke.Color = Color3.fromRGB(255, 255, 255)
    end)
end

local function updateTouchButton()
    if TouchButton.Button then
        TouchButton.Button.Visible = TouchButton.Visible and Aimlock.Enabled
    end
end

-- ==============================================
-- 10. MAIN LOOP
-- ==============================================

RunService.RenderStepped:Connect(function()
    local root = getRoot()
    if not root then return end
    
    -- ESP Update
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if ESP.Survivor and p.Team and p.Team.Name == "Survivors" then
                        createESP(char, Colors.Survivor)
                    elseif ESP.Killer and p.Team and p.Team.Name == "Killer" then
                        createESP(char, Colors.Killer)
                    else
                        removeESP(char)
                    end
                end
                createStatusESP(p, char, root)
            else
                removeESP(char)
                if ESPCache.Status[char] then
                    ESPCache.Status[char]:Destroy()
                    ESPCache.Status[char] = nil
                end
            end
        end
    end
end)

-- ==============================================
-- 11. CHARACTER EVENTS
-- ==============================================

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    Aimlock.Holding = false
    if TouchButton.Button then
        TouchButton.Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- ==============================================
-- 12. GUI CREATION
-- ==============================================

local Window = Library:CreateWindow({
    Title = "GanKunZ Hub V2",
    Footer = "By GanKunZ | Android/HP Support",
    Icon = "rbxassetid://96848424314690",
    IconSize = UDim2.fromOffset(50, 50),
    NotifySide = "Right",
    EnableSidebarResize = true,
    EnableCompacting = true,
    SidebarCompacted = true,
    Size = UDim2.fromOffset(450, 750),
    CornerRadius = 20,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "home", "Main Features"),
    ESP = Window:AddTab("ESP", "eye", "ESP Settings"),
    Settings = Window:AddTab("Settings", "settings-2", "UI Settings")
}

-- ==============================================
-- 13. MAIN TAB
-- ==============================================

local SilentBox = Tabs.Main:AddLeftGroupbox("Silent Aim", "crosshair")
local ToFBox = Tabs.Main:AddRightGroupbox("ToF Silent Aim", "target")
local AimlockBox = Tabs.Main:AddLeftGroupbox("Aimlock (Touch)", "crosshair")

-- SILENT AIM
SilentBox:AddToggle("SilentAimToggle", {
    Text = "Enable Silent Aim",
    Tooltip = "Tembak tanpa gerak kamera",
    Default = false,
    Callback = function(v)
        SilentAim.Enabled = v
        if v then
            setupSilentAim()
            Library:Notify({Title = "Silent Aim", Description = "Diaktifkan!", Time = 2})
        else
            removeSilentAim()
            Library:Notify({Title = "Silent Aim", Description = "Dinonaktifkan!", Time = 2})
        end
    end
})

SilentBox:AddDropdown("SilentTarget", {
    Values = {"Killer", "Survivor"},
    Default = 1,
    Text = "Target Mode",
    Callback = function(v)
        SilentAim.TargetMode = v
    end
})

SilentBox:AddDropdown("SilentPart", {
    Values = {"HumanoidRootPart", "Head", "Torso"},
    Default = 1,
    Text = "Aim Part",
    Callback = function(v)
        SilentAim.TargetPart = v
    end
})

SilentBox:AddSlider("SilentFOV", {
    Text = "Silent FOV",
    Default = 200,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        SilentAim.FOV = v
    end
})

SilentBox:AddSlider("SilentDistance", {
    Text = "Max Distance",
    Default = 400,
    Min = 50,
    Max = 800,
    Rounding = 0,
    Callback = function(v)
        SilentAim.Distance = v
    end
})

SilentBox:AddToggle("SilentPredict", {
    Text = "Enable Prediction",
    Default = true,
    Callback = function(v)
        SilentAim.Prediction = v
    end
})

SilentBox:AddSlider("SilentPredictStrength", {
    Text = "Prediction Strength",
    Default = 15,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Callback = function(v)
        SilentAim.PredictStrength = v / 100
    end
})

-- TOF SILENT AIM
ToFBox:AddToggle("ToFAimToggle", {
    Text = "Enable ToF Silent Aim",
    Tooltip = "Silent aim khusus Twist of Fate",
    Default = false,
    Callback = function(v)
        ToFAim.Enabled = v
        if v then
            setupToFSilentAim()
            Library:Notify({Title = "ToF Silent Aim", Description = "Diaktifkan!", Time = 2})
        else
            if oldNamecall then
                pcall(function()
                    local mt = getrawmetatable(game)
                    if mt and setreadonly then
                        setreadonly(mt, false)
                        mt.__namecall = oldNamecall
                        setreadonly(mt, true)
                    end
                end)
                oldNamecall = nil
            end
            Library:Notify({Title = "ToF Silent Aim", Description = "Dinonaktifkan!", Time = 2})
        end
    end
})

ToFBox:AddDropdown("ToFTarget", {
    Values = {"Killer", "Survivor"},
    Default = 1,
    Text = "Target Mode",
    Callback = function(v)
        ToFAim.TargetMode = v
    end
})

ToFBox:AddDropdown("ToFPart", {
    Values = {"HumanoidRootPart", "Head", "Torso"},
    Default = 1,
    Text = "Aim Part",
    Callback = function(v)
        ToFAim.AimPart = v
    end
})

ToFBox:AddToggle("ToFPredict", {
    Text = "Enable Prediction",
    Default = true,
    Callback = function(v)
        ToFAim.Predict = v
    end
})

ToFBox:AddSlider("ToFBulletSpeed", {
    Text = "Bullet Speed",
    Default = 200,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Callback = function(v)
        ToFAim.BulletSpeed = v
    end
})

ToFBox:AddSlider("ToFRange", {
    Text = "Aim Range",
    Default = 90,
    Min = 10,
    Max = 300,
    Rounding = 0,
    Callback = function(v)
        ToFAim.Range = v
    end
})

ToFBox:AddSlider("ToFDotThreshold", {
    Text = "Safe FOV (Dot Threshold)",
    Tooltip = "Semakin rendah semakin akurat, -1 = off",
    Default = 0.5,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Callback = function(v)
        ToFAim.DotThreshold = v
    end
})

-- AIMLOCK (Touch)
AimlockBox:AddToggle("AimlockToggle", {
    Text = "Enable Aimlock",
    Tooltip = "Aimlock via tombol sentuh AIM",
    Default = false,
    Callback = function(v)
        Aimlock.Enabled = v
        if v then
            startAimlock()
            createTouchButton()
            updateTouchButton()
            Library:Notify({Title = "Aimlock", Description = "Diaktifkan! (Tekan tombol AIM)", Time = 2})
        else
            stopAimlock()
            Aimlock.Holding = false
            if TouchButton.Gui then
                TouchButton.Gui:Destroy()
                TouchButton.Gui = nil
                TouchButton.Button = nil
            end
            Library:Notify({Title = "Aimlock", Description = "Dinonaktifkan!", Time = 2})
        end
    end
})

AimlockBox:AddToggle("ShowTouchButton", {
    Text = "Show AIM Button",
    Tooltip = "Tampilkan tombol sentuh AIM",
    Default = true,
    Callback = function(v)
        TouchButton.Visible = v
        updateTouchButton()
    end
})

AimlockBox:AddDropdown("AimlockTarget", {
    Values = {"Killer", "Survivor"},
    Default = 1,
    Text = "Target Mode",
    Callback = function(v)
        Aimlock.TargetMode = v
    end
})

AimlockBox:AddDropdown("AimlockPart", {
    Values = {"HumanoidRootPart", "Head", "Torso"},
    Default = 1,
    Text = "Aim Part",
    Callback = function(v)
        Aimlock.AimPart = v
    end
})

AimlockBox:AddSlider("AimlockStrength", {
    Text = "Aimlock Strength",
    Default = 50,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Callback = function(v)
        Aimlock.Strength = v / 100
    end
})

AimlockBox:AddSlider("AimlockFOV", {
    Text = "Aimlock FOV",
    Default = 250,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        Aimlock.FOV = v
    end
})

AimlockBox:AddToggle("AimlockPredict", {
    Text = "Enable Prediction",
    Default = true,
    Callback = function(v)
        Aimlock.Predict = v
    end
})

AimlockBox:AddSlider("AimlockPredictStrength", {
    Text = "Prediction Strength",
    Default = 12,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Callback = function(v)
        Aimlock.PredictStrength = v / 100
    end
})

-- ==============================================
-- 14. ESP TAB
-- ==============================================

local ESPBox = Tabs.ESP:AddLeftGroupbox("ESP Settings", "eye")
local ESPStatusBox = Tabs.ESP:AddRightGroupbox("ESP Status", "scan-eye")

ESPBox:AddToggle("EnableESP", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(v)
        ESP.Enabled = v
    end
})

ESPBox:AddToggle("SurvivorESP", {
    Text = "ESP Survivor",
    Default = false,
    Callback = function(v)
        ESP.Survivor = v
    end
})
ESPBox:AddColorPicker("SurvivorColor", {
    Default = Colors.Survivor,
    Title = "Survivor Color",
    Callback = function(c)
        Colors.Survivor = c
    end
})

ESPBox:AddToggle("KillerESP", {
    Text = "ESP Killer",
    Default = false,
    Callback = function(v)
        ESP.Killer = v
    end
})
ESPBox:AddColorPicker("KillerColor", {
    Default = Colors.Killer,
    Title = "Killer Color",
    Callback = function(c)
        Colors.Killer = c
    end
})

ESPBox:AddSlider("ESPDistance", {
    Text = "ESP Distance",
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(v)
        ESP.Distance = v
    end
})

ESPStatusBox:AddToggle("ShowName", {
    Text = "Show Name",
    Default = true,
    Callback = function(v)
        ESP.ShowName = v
    end
})

ESPStatusBox:AddToggle("ShowDistance", {
    Text = "Show Distance",
    Default = true,
    Callback = function(v)
        ESP.ShowDistance = v
    end
})

ESPStatusBox:AddToggle("ShowHealth", {
    Text = "Show Health",
    Default = false,
    Callback = function(v)
        ESP.ShowHealth = v
    end
})

-- ==============================================
-- 15. SETTINGS TAB
-- ==============================================

local SettingBox = Tabs.Settings:AddLeftGroupbox("UI Settings", "wrench")

SettingBox:AddToggle("CustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(v)
        Library.ShowCustomCursor = v
    end
})

SettingBox:AddDropdown("NotificationSide", {
    Values = {"Left", "Right"},
    Default = "Right",
    Text = "Notification Side",
    Callback = function(v)
        Library:SetNotifySide(v)
    end
})

SettingBox:AddDropdown("DPIScale", {
    Values = {"50%", "75%", "85%", "100%", "125%", "150%"},
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(v)
        v = v:gsub("%%", "")
        Library:SetDPIScale(tonumber(v))
    end
})

SettingBox:AddDivider()
SettingBox:AddLabel("Keybinds")
SettingBox:AddKeyPicker("MenuKey", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu Keybind"
})

SettingBox:AddDivider()
SettingBox:AddButton("Unload Script", function()
    -- Cleanup
    removeSilentAim()
    stopAimlock()
    Aimlock.Holding = false
    
    if TouchButton.Gui then
        TouchButton.Gui:Destroy()
        TouchButton.Gui = nil
        TouchButton.Button = nil
    end
    
    if oldNamecall then
        pcall(function()
            local mt = getrawmetatable(game)
            if mt and setreadonly then
                setreadonly(mt, false)
                mt.__namecall = oldNamecall
                setreadonly(mt, true)
            end
        end)
        oldNamecall = nil
    end
    
    Library:Unload()
end)

-- ==============================================
-- 16. THEME & SAVE
-- ==============================================

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:SetFolder("GanKunZ")
SaveManager:SetFolder("GanKunZ/configs")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

-- ==============================================
-- 17. STARTUP
-- ==============================================

-- Buat touch button default
TouchButton.Visible = true
createTouchButton()

Library:Notify({
    Title = "GanKunZ Hub V2",
    Description = "Android/HP Support! Menu Key: RightShift",
    Time = 3
})

print("✅ GanKunZ Hub V2 (Android) Loaded!")
print("📌 Fitur: Silent Aim | ToF Silent Aim | Aimlock | ESP")
print("🎯 Menu Key: RightShift")
print("👆 Tombol AIM di layar untuk aimlock (HP)")

-- ==============================================
-- END OF SCRIPT
-- ==============================================
