-- ==============================================
--     GANKUNZ HUB - LITE VERSION
--     Created by: GanKunZ
--     Version: 4.0 Lite
--     No Key Required - Free to Use
--     WhatsApp: https://whatsapp.com/channel/0029Vb8MsxY7T8bUAjemYH2j
-- ==============================================

-- ==============================================
-- 1. SERVICES
-- ==============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- ==============================================
-- 2. VARIABLES
-- ==============================================

local Settings = {
    -- ESP
    ESP_Survivor = false,
    ESP_Killer = false,
    ESP_Generator = false,
    ESP_Pallet = false,
    ESP_Window = false,
    ESP_SCP = false,
    ESP_Distance = 100,
    ESP_Status = false,
    ESP_ShowName = true,
    ESP_ShowDistance = true,
    ESP_ShowHealth = false,
    
    -- Auto
    Auto_SkillCheck = false,
    Auto_SkillCheckMode = "Legit",
    Auto_Parry = false,
    Auto_ParryRadius = 15,
    Auto_ParryAggressive = false,
    Auto_PalletDrop = false,
    Auto_PalletDist = 6,
    Auto_Flee = false,
    Auto_FleeDist = 50,
    Auto_Stalk = false,
    
    -- Movement
    WalkSpeed = false,
    WalkSpeedValue = 17.6,
    JumpPower = false,
    JumpPowerValue = 50,
    NoClip = false,
    FastVault = false,
    FastVaultSpeed = 1.2,
    
    -- Killer
    KillAll = false,
    BypassCooldown = false,
    BypassLeap = false,
    BlockVaults = false,
    AntiBlind = false,
    AttackAim = false,
    ThirdPerson = false,
    
    -- Visual
    Fullbright = false,
    NoShadow = false,
    LowGraphics = false,
    NoScreenEffects = false,
    CleanSky = false,
    ClockTime = 14,
    
    -- Aim
    GunAim = false,
    SilentAim = false,
    ToFAim = false,
    
    -- Emote
    Emote = "Mannrobics",
    
    -- Chat
    FakeTag = false,
    FakeTagText = "[GANKUNZ]",
}

local ESPCache = {
    Objects = {},
    Status = {},
    Generators = {},
    Windows = {},
    Pallets = {},
    SCP = {}
}

local Connections = {}
local State = {
    ParryCooldown = false,
    Busy = false,
    GunHolding = false,
    AttackHolding = false,
    LastFlee = 0,
    LastPalletDrop = 0
}

local TeamColors = {
    Killer = Color3.fromRGB(255, 60, 60),
    Survivor = Color3.fromRGB(60, 255, 120)
}

local EmoteList = {
    "Mannrobics", "Arm Swing", "Schadenfreude", "Kyoufuu",
    "Backflip", "Griddy", "Friday Night", "Floating Rest",
    "OnePlays", "Quick Combo", "WarCry", "Wave"
}

local GenColor = Color3.fromRGB(255, 170, 0)
local PalletColor = Color3.fromRGB(74, 255, 181)
local WindowColor = Color3.fromRGB(74, 255, 181)
local SCPColor = Color3.fromRGB(255, 0, 0)

-- ==============================================
-- 3. GUI SYSTEM (SIMPLE & MOBILE FRIENDLY)
-- ==============================================

local GUI = {
    Main = nil,
    Logo = nil,
    Menu = nil,
    Dragging = false,
    DragStart = nil,
    StartPos = nil,
    CurrentTab = nil,
    Visible = false
}

local function CreateLogo()
    -- Hapus logo lama
    local oldLogo = PlayerGui:FindFirstChild("GanKunZLogo")
    if oldLogo then oldLogo:Destroy() end
    
    -- Buat ScreenGui untuk logo
    local logoGui = Instance.new("ScreenGui")
    logoGui.Name = "GanKunZLogo"
    logoGui.ResetOnSpawn = false
    logoGui.IgnoreGuiInset = true
    logoGui.Parent = PlayerGui
    GUI.Logo = logoGui
    
    -- Tombol Logo
    local logoBtn = Instance.new("ImageButton")
    logoBtn.Name = "LogoButton"
    logoBtn.Size = UDim2.new(0, 60, 0, 60)
    logoBtn.Position = UDim2.new(0.03, 0, 0.85, 0)
    logoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    logoBtn.BackgroundTransparency = 0.1
    logoBtn.Image = "rbxassetid://96848424314690"
    logoBtn.ImageColor3 = Color3.fromRGB(255, 200, 50)
    logoBtn.Parent = logoGui
    
    -- Border glow
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 200, 50)
    stroke.Thickness = 2
    stroke.Transparency = 0.4
    stroke.Parent = logoBtn
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = logoBtn
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1.1, 0, 1.1, 0)
    shadow.Position = UDim2.new(-0.05, 0, -0.05, 0)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://13158042418"
    shadow.ImageColor3 = Color3.fromRGB(255, 200, 50)
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = -1
    shadow.Parent = logoBtn
    
    -- Tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(0, 100, 0, 25)
    tooltip.Position = UDim2.new(0, 65, 0, 18)
    tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tooltip.BackgroundTransparency = 0.7
    tooltip.Text = "GanKunZ Hub"
    tooltip.TextColor3 = Color3.fromRGB(255, 200, 50)
    tooltip.TextScaled = true
    tooltip.Font = Enum.Font.GothamBold
    tooltip.Visible = false
    tooltip.Parent = logoBtn
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 5)
    corner2.Parent = tooltip
    
    -- Animasi pulse
    local pulse = TweenService:Create(stroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = 0.1
    })
    pulse:Play()
    
    -- Hover
    logoBtn.MouseEnter:Connect(function()
        tooltip.Visible = true
        pulse:Cancel()
        stroke.Transparency = 0
    end)
    
    logoBtn.MouseLeave:Connect(function()
        tooltip.Visible = false
        stroke.Transparency = 0.4
        pulse:Play()
    end)
    
    -- Click - Toggle Menu
    logoBtn.MouseButton1Click:Connect(function()
        ToggleMenu()
    end)
    
    -- Mobile Touch
    logoBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            task.wait(0.1)
            ToggleMenu()
        end
    end)
end

local function CreateMenu()
    -- Hapus menu lama
    local oldMenu = PlayerGui:FindFirstChild("GanKunZMenu")
    if oldMenu then oldMenu:Destroy() end
    
    local menuGui = Instance.new("ScreenGui")
    menuGui.Name = "GanKunZMenu"
    menuGui.ResetOnSpawn = false
    menuGui.IgnoreGuiInset = true
    menuGui.Parent = PlayerGui
    menuGui.Enabled = false
    GUI.Menu = menuGui
    
    -- Main Frame (draggable)
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 380, 0, 520)
    main.Position = UDim2.new(0.5, -190, 0.5, -260)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    main.BackgroundTransparency = 0.05
    main.ClipsDescendants = true
    main.Parent = menuGui
    GUI.Main = main
    
    -- Background blur
    local blur = Instance.new("ImageLabel")
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundTransparency = 1
    blur.Image = "rbxassetid://13158042418"
    blur.ImageColor3 = Color3.fromRGB(255, 200, 50)
    blur.ImageTransparency = 0.85
    blur.Parent = main
    
    -- Border
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(255, 200, 50)
    border.Thickness = 2
    border.Transparency = 0.3
    border.Parent = main
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = main
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    header.BackgroundTransparency = 0.15
    header.Parent = main
    
    -- Header Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0.05, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ GanKunZ Hub"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Close Button
    local close = Instance.new("ImageButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(0.93, 0, 0.2, 0)
    close.BackgroundTransparency = 1
    close.Image = "rbxassetid://8845650431"
    close.ImageColor3 = Color3.fromRGB(255, 100, 100)
    close.Parent = header
    
    close.MouseButton1Click:Connect(function()
        ToggleMenu()
    end)
    
    -- Tab Buttons
    local tabs = {"Player", "ESP", "Movement", "Visual", "Server"}
    local tabNames = {"🎯", "👁", "🏃", "✨", "🌐"}
    local tabButtons = {}
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0, 0, 0, 50)
    tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabFrame.BackgroundTransparency = 0.95
    tabFrame.Parent = main
    
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = tab
        btn.Size = UDim2.new(0.2, 0, 1, 0)
        btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = tabNames[i] or tab
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.Parent = tabFrame
        tabButtons[tab] = btn
        
        btn.MouseButton1Click:Connect(function()
            SwitchTab(tab)
        end)
    end
    
    -- Content Frame
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -90)
    content.Position = UDim2.new(0, 0, 0, 90)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 50)
    content.Parent = main
    
    -- Content Layout
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    -- Store content reference
    GUI.Content = content
    GUI.Layout = layout
    GUI.TabButtons = tabButtons
    
    -- Buat konten tab
    CreatePlayerTab()
    CreateESPTab()
    CreateMovementTab()
    CreateVisualTab()
    CreateServerTab()
    
    -- Default tab
    SwitchTab("Player")
    
    -- Make draggable
    local dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            GUI.Dragging = true
            GUI.DragStart = input.Position
            GUI.StartPos = main.Position
        end
    end)
    
    header.InputChanged:Connect(function(input)
        if GUI.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - GUI.DragStart
            local newPos = UDim2.new(GUI.StartPos.X.Scale, GUI.StartPos.X.Offset + delta.X, GUI.StartPos.Y.Scale, GUI.StartPos.Y.Offset + delta.Y)
            main.Position = newPos
        end
    end)
    
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            GUI.Dragging = false
        end
    end)
end

function ToggleMenu()
    GUI.Visible = not GUI.Visible
    if GUI.Menu then
        GUI.Menu.Enabled = GUI.Visible
        if GUI.Visible then
            UpdateContentSize()
        end
    end
end

function SwitchTab(tab)
    GUI.CurrentTab = tab
    
    -- Update tab buttons
    for name, btn in pairs(GUI.TabButtons or {}) do
        if name == tab then
            btn.TextColor3 = Color3.fromRGB(255, 200, 50)
        else
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    -- Show/hide tab content
    for _, child in pairs(GUI.Content:GetChildren()) do
        if child:IsA("Frame") and child.Name == tab then
            child.Visible = true
        elseif child:IsA("Frame") then
            child.Visible = false
        end
    end
    
    UpdateContentSize()
end

function UpdateContentSize()
    task.wait(0.05)
    local totalHeight = 0
    for _, child in pairs(GUI.Content:GetChildren()) do
        if child:IsA("Frame") and child.Visible then
            totalHeight = totalHeight + child.Size.Y.Offset + 5
        end
    end
    GUI.Content.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, 400))
end

-- ==============================================
-- 4. GUI - CREATE TABS
-- ==============================================

function CreatePlayerTab()
    local frame = Instance.new("Frame")
    frame.Name = "Player"
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = GUI.Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    -- Section: Auto
    AddSection(frame, "⚡ Auto Features")
    AddCheckbox(frame, "Auto Skill Check", "Auto_SkillCheck", "Otomatis skill check")
    AddDropdown(frame, "Skill Check Mode", {"Legit", "Instant"}, "Auto_SkillCheckMode")
    AddCheckbox(frame, "Auto Parry", "Auto_Parry", "Otomatis parry")
    AddSlider(frame, "Parry Radius", 5, 25, 15, "Auto_ParryRadius")
    AddCheckbox(frame, "Parry Aggressive", "Auto_ParryAggressive", "Parry tanpa melihat arah")
    AddCheckbox(frame, "Auto Pallet Drop", "Auto_PalletDrop", "Otomatis drop pallet")
    AddSlider(frame, "Pallet Distance", 5, 20, 6, "Auto_PalletDist")
    AddCheckbox(frame, "Auto Flee Killer", "Auto_Flee", "Teleport menjauh dari killer")
    AddSlider(frame, "Flee Distance", 30, 100, 50, "Auto_FleeDist")
    
    -- Section: Killer
    AddSection(frame, "🔪 Killer Features")
    AddCheckbox(frame, "Auto Stalk (Myers)", "Auto_Stalk", "Auto stalk survivor")
    AddCheckbox(frame, "Auto Kill All", "KillAll", "Auto attack semua survivor")
    AddCheckbox(frame, "Bypass Cooldown (Abyss)", "BypassCooldown", "Bypass cooldown Abyss")
    AddCheckbox(frame, "Bypass Leap (Hidden)", "BypassLeap", "Bypass cooldown Hidden")
    AddCheckbox(frame, "Block All Vaults", "BlockVaults", "Blokir vault survivor")
    AddCheckbox(frame, "Anti Blind", "AntiBlind", "Anti kena flash")
    AddCheckbox(frame, "Attack Aimlock", "AttackAim", "Aimlock saat attack")
    AddCheckbox(frame, "Third Person", "ThirdPerson", "Third person view")
    
    -- Section: Emote
    AddSection(frame, "💃 Emote")
    AddDropdown(frame, "Select Emote", EmoteList, "Emote")
    AddButton(frame, "Play Emote", function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("EmoteHandler")
        if remote then remote:FireServer(Settings.Emote) end
    end)
    
    UpdateFrameSize(frame)
end

function CreateESPTab()
    local frame = Instance.new("Frame")
    frame.Name = "ESP"
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = GUI.Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    AddSection(frame, "👁 ESP Settings")
    AddCheckbox(frame, "ESP Survivor", "ESP_Survivor")
    AddCheckbox(frame, "ESP Killer", "ESP_Killer")
    AddCheckbox(frame, "ESP Generator", "ESP_Generator")
    AddCheckbox(frame, "ESP Pallet", "ESP_Pallet")
    AddCheckbox(frame, "ESP Window", "ESP_Window")
    AddCheckbox(frame, "ESP SCP", "ESP_SCP")
    AddSlider(frame, "ESP Distance", 50, 500, 100, "ESP_Distance")
    
    AddSection(frame, "📊 Status ESP")
    AddCheckbox(frame, "Enable Status ESP", "ESP_Status")
    AddCheckbox(frame, "Show Name", "ESP_ShowName")
    AddCheckbox(frame, "Show Distance", "ESP_ShowDistance")
    AddCheckbox(frame, "Show Health", "ESP_ShowHealth")
    
    UpdateFrameSize(frame)
end

function CreateMovementTab()
    local frame = Instance.new("Frame")
    frame.Name = "Movement"
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = GUI.Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    AddSection(frame, "🏃 Movement")
    AddCheckbox(frame, "Walk Speed", "WalkSpeed")
    AddSlider(frame, "Walk Speed Value", 16, 32, 17.6, "WalkSpeedValue")
    AddCheckbox(frame, "Jump Power", "JumpPower")
    AddSlider(frame, "Jump Power Value", 0, 300, 50, "JumpPowerValue")
    AddCheckbox(frame, "No Clip", "NoClip")
    AddCheckbox(frame, "Fast Vault", "FastVault")
    AddSlider(frame, "Vault Speed", 1, 5, 1.2, "FastVaultSpeed")
    
    AddSection(frame, "🎯 Aim")
    AddCheckbox(frame, "Gun Aimlock", "GunAim")
    AddCheckbox(frame, "Silent Aim", "SilentAim")
    AddCheckbox(frame, "ToF Silent Aim", "ToFAim")
    
    UpdateFrameSize(frame)
end

function CreateVisualTab()
    local frame = Instance.new("Frame")
    frame.Name = "Visual"
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = GUI.Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    AddSection(frame, "✨ Visual")
    AddCheckbox(frame, "Fullbright", "Fullbright")
    AddCheckbox(frame, "No Shadow", "NoShadow")
    AddCheckbox(frame, "Low Graphics", "LowGraphics")
    AddCheckbox(frame, "No Screen Effects", "NoScreenEffects")
    AddCheckbox(frame, "Clean Sky", "CleanSky")
    AddSlider(frame, "Clock Time", 0, 24, 14, "ClockTime")
    
    AddSection(frame, "💬 Chat")
    AddCheckbox(frame, "Fake Chat Tag", "FakeTag")
    AddInput(frame, "Tag Text", "FakeTagText", "[GANKUNZ]")
    
    AddSection(frame, "🔄 Utility")
    AddButton(frame, "Apply Korless Morph", function()
        ApplyKorless()
    end)
    AddButton(frame, "Teleport to Finish", function()
        TeleportToFinish()
    end)
    
    UpdateFrameSize(frame)
end

function CreateServerTab()
    local frame = Instance.new("Frame")
    frame.Name = "Server"
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = GUI.Content
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame
    
    AddSection(frame, "🌐 Server")
    AddButton(frame, "Find Best Server", function()
        FindBestServer()
    end)
    AddButton(frame, "Join Best Server", function()
        JoinBestServer()
    end)
    AddButton(frame, "Rejoin Server", function()
        RejoinServer()
    end)
    
    AddSection(frame, "📱 WhatsApp")
    AddButton(frame, "Open WhatsApp Channel", function()
        OpenWhatsApp()
    end)
    AddButton(frame, "Copy Channel Link", function()
        setclipboard("https://whatsapp.com/channel/0029Vb8MsxY7T8bUAjemYH2j")
        Notify("Copied!", "Link WhatsApp disalin!")
    end)
    
    AddSection(frame, "ℹ️ Info")
    AddLabel(frame, "Version: 4.0 Lite")
    AddLabel(frame, "Creator: GanKunZ")
    AddButton(frame, "Check Updates", function()
        CheckUpdates()
    end)
    
    UpdateFrameSize(frame)
end

-- ==============================================
-- 5. GUI HELPERS
-- ==============================================

function AddSection(parent, title)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, 0, 0, 25)
    section.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    section.BackgroundTransparency = 0.2
    section.Text = " " .. title
    section.TextColor3 = Color3.fromRGB(255, 200, 50)
    section.TextScaled = true
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = section
end

function AddLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = parent
end

function AddCheckbox(parent, text, setting, tooltip)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 25, 0, 25)
    btn.Position = UDim2.new(0.9, 0, 0.08, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.BackgroundTransparency = 0.3
    btn.Image = "rbxassetid://8845650431"
    btn.ImageColor3 = Color3.fromRGB(100, 100, 100)
    btn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    
    if tooltip then
        local tip = Instance.new("TextLabel")
        tip.Size = UDim2.new(0, 150, 0, 20)
        tip.Position = UDim2.new(0, 0, 0, -20)
        tip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tip.BackgroundTransparency = 0.7
        tip.Text = tooltip
        tip.TextColor3 = Color3.fromRGB(255, 255, 255)
        tip.TextScaled = true
        tip.Font = Enum.Font.Gotham
        tip.Visible = false
        tip.Parent = frame
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(0, 5)
        corner2.Parent = tip
        
        btn.MouseEnter:Connect(function() tip.Visible = true end)
        btn.MouseLeave:Connect(function() tip.Visible = false end)
    end
    
    -- Set initial state
    local state = Settings[setting]
    if state then
        btn.ImageColor3 = Color3.fromRGB(255, 200, 50)
    end
    
    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        if Settings[setting] then
            btn.ImageColor3 = Color3.fromRGB(255, 200, 50)
        else
            btn.ImageColor3 = Color3.fromRGB(100, 100, 100)
        end
        -- Trigger callback jika ada
        if setting == "Auto_SkillCheck" then
            if Settings.Auto_SkillCheck then StartSkillCheck() else StopSkillCheck() end
        elseif setting == "Auto_Stalk" then
            if Settings.Auto_Stalk then StartStalk() else StopStalk() end
        elseif setting == "BypassCooldown" then
            if Settings.BypassCooldown then StartBypassCooldown() end
        elseif setting == "BypassLeap" then
            if Settings.BypassLeap then StartLeapBypass() end
        elseif setting == "NoClip" then
            ToggleNoClip(Settings.NoClip)
        elseif setting == "WalkSpeed" then
            ApplyWalkSpeed()
        elseif setting == "JumpPower" then
            ApplyJumpPower()
        elseif setting == "AttackAim" then
            if Settings.AttackAim then StartAttackAim() end
        elseif setting == "GunAim" then
            if Settings.GunAim then StartGunAim() end
        elseif setting == "Fullbright" or setting == "NoShadow" or setting == "CleanSky" or setting == "ClockTime" then
            ApplyVisual()
        end
    end)
    
    return frame
end

function AddSlider(parent, text, min, max, default, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0.5, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0.3, 0)
    slider.Position = UDim2.new(0, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    slider.BackgroundTransparency = 0.5
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    fill.BackgroundTransparency = 0.3
    fill.Parent = slider
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = slider
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 5)
    corner2.Parent = fill
    
    local dragging = false
    
    local function UpdateSlider(mousePos)
        local pos = mousePos.X / slider.AbsoluteSize.X
        pos = math.clamp(pos, 0, 1)
        local value = min + (max - min) * pos
        value = math.round(value)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value)
        Settings[setting] = value
        
        if setting == "WalkSpeedValue" then ApplyWalkSpeed()
        elseif setting == "JumpPowerValue" then ApplyJumpPower()
        elseif setting == "FastVaultSpeed" then ApplyFastVault()
        elseif setting == "ClockTime" then ApplyVisual()
        end
    end
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input.Position)
        end
    end)
    
    slider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input.Position)
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function AddDropdown(parent, text, values, setting)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.45, 0, 1, 0)
    btn.Position = UDim2.new(0.55, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.BackgroundTransparency = 0.3
    btn.Text = values[1]
    btn.TextColor3 = Color3.fromRGB(255, 200, 50)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    local currentIndex = 1
    btn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #values + 1
        btn.Text = values[currentIndex]
        Settings[setting] = values[currentIndex]
    end)
end

function AddInput(parent, text, setting, placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.55, 0, 1, 0)
    input.Position = UDim2.new(0.45, 0, 0, 0)
    input.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    input.BackgroundTransparency = 0.3
    input.Text = placeholder or ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextScaled = true
    input.Font = Enum.Font.Gotham
    input.PlaceholderText = placeholder or ""
    input.ClearTextOnFocus = false
    input.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = input
    
    input.FocusLost:Connect(function()
        if input.Text ~= "" then
            Settings[setting] = input.Text
        end
    end)
end

function AddButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    btn.BackgroundTransparency = 0.15
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 200, 50)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

function UpdateFrameSize(frame)
    task.wait(0.05)
    local height = 0
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            height = height + child.Size.Y.Offset + 4
        end
    end
    frame.Size = UDim2.new(1, -10, 0, height)
end

function Notify(title, desc)
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "Notify"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 60)
        frame.Position = UDim2.new(0.5, -150, 0.2, 0)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        frame.BackgroundTransparency = 0.05
        frame.Parent = gui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = frame
        
        local border = Instance.new("UIStroke")
        border.Color = Color3.fromRGB(255, 200, 50)
        border.Thickness = 1
        border.Transparency = 0.5
        border.Parent = frame
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, 0, 0.4, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = Color3.fromRGB(255, 200, 50)
        titleLbl.TextScaled = true
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.Parent = frame
        
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, 0, 0.5, 0)
        descLbl.Position = UDim2.new(0, 0, 0.45, 0)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = desc or ""
        descLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        descLbl.TextScaled = true
        descLbl.Font = Enum.Font.Gotham
        descLbl.Parent = frame
        
        task.delay(2, function()
            gui:Destroy()
        end)
    end)
end

-- ==============================================
-- 6. CORE FUNCTIONS
-- ==============================================

-- Get Root
local function getRoot()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

-- Get Humanoid
local function getHumanoid()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- Is Killer
local function isKiller() 
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Killer" 
end

-- Is Survivor
local function isSurvivor() 
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Survivors" 
end

-- ==============================================
-- 7. AUTO SKILL CHECK
-- ==============================================

local skillCheckConn = nil

function StartSkillCheck()
    if skillCheckConn then return end
    skillCheckConn = RunService.RenderStepped:Connect(function()
        if not Settings.Auto_SkillCheck or State.Busy then return end
        
        local prompt = PlayerGui:FindFirstChild("SkillCheckPromptGui")
        if not prompt then return end
        
        local check = prompt:FindFirstChild("Check")
        if not check or not check.Visible then return end
        
        local line = check:FindFirstChild("Line")
        local goal = check:FindFirstChild("Goal")
        if not line or not goal then return end
        
        if Settings.Auto_SkillCheckMode == "Instant" then
            line.Rotation = goal.Rotation + 109
            State.Busy = true
            task.spawn(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait()
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.2)
                State.Busy = false
            end)
        else
            local lr = line.Rotation % 360
            local gr = goal.Rotation % 360
            local startRange = (gr + 102) % 360
            local endRange = (gr + 116) % 360
            local success = (startRange > endRange and (lr >= startRange or lr <= endRange))
                         or (lr >= startRange and lr <= endRange)
            if success then
                State.Busy = true
                task.spawn(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait()
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.05)
                    State.Busy = false
                end)
            end
        end
    end)
end

function StopSkillCheck()
    if skillCheckConn then
        skillCheckConn:Disconnect()
        skillCheckConn = nil
    end
end

-- ==============================================
-- 8. AUTO PARRY
-- ==============================================

local parryConn = nil
local lastParry = 0

function StartParry()
    if parryConn then return end
    parryConn = RunService.Heartbeat:Connect(function()
        if not Settings.Auto_Parry or State.ParryCooldown then return end
        
        local root = getRoot()
        if not root then return end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                local kRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if kRoot then
                    local dist = (kRoot.Position - root.Position).Magnitude
                    if dist <= Settings.Auto_ParryRadius then
                        local now = tick()
                        if now - lastParry > 0.2 then
                            lastParry = now
                            ExecuteParry()
                        end
                    end
                end
            end
        end
    end)
end

function ExecuteParry()
    pcall(function()
        local parryRemote = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Items"):FindFirstChild("Parrying Dagger"):FindFirstChild("parry")
        if parryRemote then
            parryRemote:FireServer()
        end
        VirtualInputManager:SendMouseButtonEvent(0, 0, 2, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 2, false, game, 0)
        State.ParryCooldown = true
        task.delay(1, function() State.ParryCooldown = false end)
    end)
end

-- ==============================================
-- 9. AUTO FLEE
-- ==============================================

task.spawn(function()
    while task.wait(0.3) do
        if not Settings.Auto_Flee then continue end
        local root = getRoot()
        if not root then continue end
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                local kRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if kRoot then
                    local dist = (kRoot.Position - root.Position).Magnitude
                    if dist <= Settings.Auto_FleeDist and tick() - State.LastFlee > 2 then
                        -- Cari generator terdekat
                        local bestPoint, bestDist = nil, math.huge
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and string.match(obj.Name, "^GeneratorPoint%d+$") then
                                local d = (obj.Position - root.Position).Magnitude
                                if d < bestDist then
                                    bestDist = d
                                    bestPoint = obj
                                end
                            end
                        end
                        if bestPoint then
                            root.CFrame = bestPoint.CFrame + Vector3.new(0, 5, 0)
                            State.LastFlee = tick()
                        end
                    end
                end
            end
        end
    end
end)

-- ==============================================
-- 10. AUTO PALLET DROP
-- ==============================================

task.spawn(function()
    while task.wait(0.2) do
        if not Settings.Auto_PalletDrop or not isSurvivor() then continue end
        if tick() - State.LastPalletDrop < 2.5 then continue end
        
        local root = getRoot()
        if not root then continue end
        
        -- Cari killer terdekat
        local nearestKiller, killDist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Killer" then
                local kRoot = p.Character:FindFirstChild("HumanoidRootPart")
                if kRoot then
                    local d = (kRoot.Position - root.Position).Magnitude
                    if d < killDist then
                        killDist = d
                        nearestKiller = kRoot
                    end
                end
            end
        end
        
        if nearestKiller and killDist <= Settings.Auto_PalletDist then
            -- Cari pallet terdekat
            local bestPallet, bestDist = nil, 8
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Pallet" or obj.Name == "Palletwrong" then
                    local point = obj:FindFirstChild("PalletPoint") or obj:FindFirstChild("PalletPointSlide")
                    if point then
                        local d = (point.Position - root.Position).Magnitude
                        if d < bestDist then
                            bestDist = d
                            bestPallet = point
                        end
                    end
                end
            end
            
            if bestPallet then
                local dropEvent = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Pallet"):FindFirstChild("PalletDropEvent")
                if dropEvent then
                    dropEvent:FireServer(bestPallet)
                    State.LastPalletDrop = tick()
                end
            end
        end
    end
end)

-- ==============================================
-- 11. AUTO STALK
-- ==============================================

local stalkConn = nil

function StartStalk()
    if stalkConn then return end
    stalkConn = RunService.Heartbeat:Connect(function()
        if not Settings.Auto_Stalk then return end
        local root = getRoot()
        if not root then return end
        
        local closest, shortest = nil, 150
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < shortest then
                        shortest = d
                        closest = p
                    end
                end
            end
        end
        
        if closest then
            local stalkEvent = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Killers"):FindFirstChild("Stalker"):FindFirstChild("StartStalking")
            if stalkEvent then stalkEvent:FireServer(closest) end
        end
    end)
end

function StopStalk()
    if stalkConn then
        stalkConn:Disconnect()
        stalkConn = nil
    end
end

-- ==============================================
-- 12. BYPASS COOLDOWN
-- ==============================================

local bypassConn = nil

function StartBypassCooldown()
    if bypassConn then return end
    bypassConn = RunService.Heartbeat:Connect(function()
        if not Settings.BypassCooldown then return end
        -- Cari function corrupt di memory
        pcall(function()
            for _, v in pairs(getgc(true)) do
                if type(v) == "function" and islclosure(v) then
                    local constants = debug.getconstants(v)
                    if table.find(constants, "corrupt") then
                        local upvalues = debug.getupvalues(v)
                        for idx, val in pairs(upvalues) do
                            if type(val) == "boolean" and val == false then
                                debug.setupvalue(v, idx, true)
                            end
                        end
                    end
                end
            end
        end)
    end)
end

-- ==============================================
-- 13. LEAP BYPASS
-- ==============================================

function StartLeapBypass()
    task.spawn(function()
        while task.wait(0.1) do
            if not Settings.BypassLeap then break end
            pcall(function()
                for _, v in pairs(getgc(true)) do
                    if type(v) == "function" and islclosure(v) then
                        local info = debug.getinfo(v)
                        if info.name == "tryActivate" or info.name == "playM2Animation" then
                            for i, val in pairs(debug.getupvalues(v)) do
                                if type(val) == "boolean" and val == true then
                                    debug.setupvalue(v, i, false)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- ==============================================
-- 14. ATTACK AIM
-- ==============================================

local attackAimConn = nil

function StartAttackAim()
    if attackAimConn then return end
    attackAimConn = RunService.RenderStepped:Connect(function()
        if not Settings.AttackAim or not State.AttackHolding then return end
        local cam = Camera
        if not cam then return end
        
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local closest, shortest = nil, 250
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Team and p.Team.Name == "Survivors" then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                    if visible then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = hrp
                        end
                    end
                end
            end
        end
        
        if closest then
            cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position)
        end
    end)
end

-- ==============================================
-- 15. GUN AIM
-- ==============================================

local gunAimConn = nil

function StartGunAim()
    if gunAimConn then return end
    gunAimConn = RunService.RenderStepped:Connect(function()
        if not Settings.GunAim or not State.GunHolding then return end
        local cam = Camera
        if not cam then return end
        
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        local closest, shortest = nil, 250
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Team then
                local valid = false
                if isKiller() and p.Team.Name == "Survivors" then valid = true
                elseif isSurvivor() and p.Team.Name == "Killer" then valid = true
                end
                if valid then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos, visible = cam:WorldToViewportPoint(hrp.Position)
                        if visible then
                            local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if dist < shortest then
                                shortest = dist
                                closest = hrp
                            end
                        end
                    end
                end
            end
        end
        
        if closest then
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, closest.Position), 0.8)
        end
    end)
end

-- ==============================================
-- 16. MOVEMENT
-- ==============================================

function ApplyWalkSpeed()
    local hum = getHumanoid()
    if hum then
        if Settings.WalkSpeed then
            hum.WalkSpeed = Settings.WalkSpeedValue
        else
            hum.WalkSpeed = 16
        end
    end
end

function ApplyJumpPower()
    local hum = getHumanoid()
    if hum then
        if Settings.JumpPower then
            hum.JumpPower = Settings.JumpPowerValue
        else
            hum.JumpPower = 50
        end
    end
end

function ToggleNoClip(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

function ApplyFastVault()
    -- Fast vault di-handle oleh hook
end

-- Hook Fast Vault
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            animator.AnimationPlayed:Connect(function(track)
                if not Settings.FastVault then return end
                local anim = track.Animation
                if anim and anim.AnimationId then
                    local id = anim.AnimationId:match("%d+")
                    if id and (id == "83873880822918" or id == "136962284480779") then
                        track:AdjustSpeed(Settings.FastVaultSpeed)
                    end
                end
            end)
        end
    end
end)

-- ==============================================
-- 17. VISUAL
-- ==============================================

function ApplyVisual()
    if Settings.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = Settings.ClockTime
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    end
    
    Lighting.GlobalShadows = not Settings.NoShadow
    
    if Settings.LowGraphics then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    else
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end)
    end
    
    if Settings.CleanSky then
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
    end
    
    if Settings.NoScreenEffects then
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("BloomEffect") then
                v.Enabled = false
            end
        end
    end
end

-- ==============================================
-- 18. KORLESS MORPH
-- ==============================================

local korlessConn = nil

function ApplyKorless()
    local char = LocalPlayer.Character
    if not char then return end
    
    pcall(function()
        char.Head.Transparency = 1
        local face = char.Head:FindFirstChild("face")
        if face then face:Destroy() end
        
        char["Right Leg"].Transparency = 1
        
        local mesh = Instance.new("MeshPart")
        mesh.Name = "KorlessHead"
        mesh.Size = Vector3.new(1.5, 1.5, 1.5)
        mesh.CanCollide = false
        mesh.MeshId = "rbxassetid://902942096"
        mesh.TextureID = "rbxassetid://902843398"
        mesh.CFrame = char["Right Leg"].CFrame * CFrame.new(0, 0.5, 0)
        mesh.Parent = char
        
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = char["Right Leg"]
        weld.Part1 = mesh
        weld.Parent = mesh
    end)
    
    Notify("Morph", "Korless Morph Applied!")
end

-- ==============================================
-- 19. TELEPORT TO FINISH
-- ==============================================

function TeleportToFinish()
    local root = getRoot()
    if not root then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if string.lower(obj.Name) == "fininshline" and obj:IsA("BasePart") then
            root.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
            Notify("Teleport", "Teleport to finish!")
            return
        end
    end
end

-- ==============================================
-- 20. SERVER FUNCTIONS
-- ==============================================

function FindBestServer()
    pcall(function()
        local servers = TeleportService:GetServerListAsync()
        local best = nil
        local minPlayers = math.huge
        for _, server in pairs(servers) do
            if server.PlayerCount < minPlayers then
                minPlayers = server.PlayerCount
                best = server
            end
        end
        if best then
            Notify("Server Found", "Players: " .. best.PlayerCount .. " | Region: " .. (best.Region or "Unknown"))
        end
    end)
end

function JoinBestServer()
    pcall(function()
        local servers = TeleportService:GetServerListAsync()
        local best = nil
        local minPlayers = math.huge
        for _, server in pairs(servers) do
            if server.PlayerCount < minPlayers then
                minPlayers = server.PlayerCount
                best = server
            end
        end
        if best then
            TeleportService:TeleportToServerInstance(game.PlaceId, best.Id)
        end
    end)
end

function RejoinServer()
    pcall(function()
        TeleportService:Teleport(game.PlaceId)
    end)
end

function OpenWhatsApp()
    setclipboard("https://whatsapp.com/channel/0029Vb8MsxY7T8bUAjemYH2j")
    Notify("WhatsApp", "Link disalin ke clipboard!")
end

function CheckUpdates()
    Notify("Update Check", "Checking for updates...")
    pcall(function()
        local response = HttpService:GetAsync("https://raw.githubusercontent.com/kezodxyz/KezodX/refs/heads/main/version.json")
        local data = HttpService:JSONDecode(response)
        if data and data.version then
            Notify("Version", "Current: 4.0 | Latest: " .. data.version)
        end
    end)
end

-- ==============================================
-- 21. FAKE CHAT TAG
-- ==============================================

TextChatService.OnIncomingMessage = function(message)
    local props = Instance.new("TextChatMessageProperties")
    if Settings.FakeTag and message.TextSource then
        if message.TextSource.UserId == LocalPlayer.UserId then
            props.PrefixText = string.format("<font color=\"#00FFFF\"><b>%s</b></font> %s", 
                Settings.FakeTagText, message.PrefixText)
        end
    end
    return props
end

-- ==============================================
-- 22. ESP SYSTEM (SIMPLE)
-- ==============================================

function UpdateESP()
    local root = getRoot()
    if not root then return end
    
    -- Clear old ESP
    for obj, h in pairs(ESPCache.Objects) do
        if h and h.Parent then
            h:Destroy()
        end
        ESPCache.Objects[obj] = nil
    end
    
    -- Player ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= Settings.ESP_Distance then
                        local color
                        if Settings.ESP_Survivor and p.Team and p.Team.Name == "Survivors" then
                            color = TeamColors.Survivor
                        elseif Settings.ESP_Killer and p.Team and p.Team.Name == "Killer" then
                            color = TeamColors.Killer
                        end
                        if color then
                            local h = Instance.new("Highlight")
                            h.FillColor = color
                            h.OutlineColor = color
                            h.FillTransparency = 0.8
                            h.OutlineTransparency = 0.3
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Parent = char
                            ESPCache.Objects[char] = h
                        end
                    end
                end
            end
        end
    end
    
    -- Generator ESP
    if Settings.ESP_Generator then
        for _, gen in pairs(workspace:GetDescendants()) do
            if gen.Name == "Generator" and gen:IsA("Model") then
                local hrp = gen:FindFirstChild("HumanoidRootPart") or gen:FindFirstChildWhichIsA("BasePart")
                if hrp then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= Settings.ESP_Distance then
                        local h = gen:FindFirstChild("GenHighlight") or Instance.new("Highlight")
                        h.Name = "GenHighlight"
                        h.FillColor = GenColor
                        h.OutlineColor = GenColor
                        h.FillTransparency = 0.8
                        h.OutlineTransparency = 0.3
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = gen
                    end
                end
            end
        end
    end
    
    -- Pallet ESP
    if Settings.ESP_Pallet then
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj.Name == "Pallet" or obj.Name == "Palletwrong") and obj:IsA("Model") then
                local part = obj:FindFirstChild("PalletPoint") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (part.Position - root.Position).Magnitude
                    if dist <= Settings.ESP_Distance then
                        local h = obj:FindFirstChild("PalletHighlight") or Instance.new("Highlight")
                        h.Name = "PalletHighlight"
                        h.FillColor = PalletColor
                        h.OutlineColor = PalletColor
                        h.FillTransparency = 0.8
                        h.OutlineTransparency = 0.3
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = obj
                    end
                end
            end
        end
    end
    
    -- Window ESP
    if Settings.ESP_Window then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Window" and obj:IsA("Model") then
                local part = obj:FindFirstChild("Bottom") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (part.Position - root.Position).Magnitude
                    if dist <= Settings.ESP_Distance then
                        local h = obj:FindFirstChild("WindowHighlight") or Instance.new("Highlight")
                        h.Name = "WindowHighlight"
                        h.FillColor = WindowColor
                        h.OutlineColor = WindowColor
                        h.FillTransparency = 0.8
                        h.OutlineTransparency = 0.3
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = obj
                    end
                end
            end
        end
    end
end

-- ==============================================
-- 23. STATUS ESP
-- ==============================================

function UpdateStatusESP()
    if not Settings.ESP_Status then
        for char, b in pairs(ESPCache.Status) do
            if b then b:Destroy() end
            ESPCache.Status[char] = nil
        end
        return
    end
    
    local root = getRoot()
    if not root then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local char = p.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            if hum and head and hum.Health > 0 then
                local dist = (head.Position - root.Position).Magnitude
                if dist <= 100 then
                    local text = ""
                    if Settings.ESP_ShowName then
                        text = text .. p.Name .. "\n"
                    end
                    if Settings.ESP_ShowDistance then
                        text = text .. string.format("Dist: %.0f\n", dist)
                    end
                    if Settings.ESP_ShowHealth then
                        text = text .. string.format("HP: %.0f", hum.Health)
                    end
                    
                    if text ~= "" then
                        local b = ESPCache.Status[char]
                        if not b then
                            b = Instance.new("BillboardGui")
                            b.Size = UDim2.new(0, 120, 0, 40)
                            b.AlwaysOnTop = true
                            b.Adornee = head
                            b.StudsOffset = Vector3.new(0, 2.5, 0)
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.fromRGB(255, 255, 255)
                            label.TextStrokeTransparency = 0
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 12
                            label.Text = text
                            label.Parent = b
                            
                            b.Parent = char
                            ESPCache.Status[char] = b
                        else
                            local label = b:FindFirstChildOfClass("TextLabel")
                            if label then label.Text = text end
                        end
                    end
                end
            end
        end
    end
end

-- ==============================================
-- 24. ESP LOOP
-- ==============================================

task.spawn(function()
    while task.wait(0.15) do
        UpdateESP()
        UpdateStatusESP()
    end
end)

-- ==============================================
-- 25. MOBILE SUPPORT
-- ==============================================

-- Touch untuk attack aim
local function SetupMobileAttack()
    local attackBtn = PlayerGui:FindFirstChild("Slasher-mob")
    if attackBtn then
        attackBtn = attackBtn:FindFirstChild("Controls")
        if attackBtn then
            attackBtn = attackBtn:FindFirstChild("attack")
            if attackBtn then
                attackBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        State.AttackHolding = true
                    end
                end)
                attackBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        State.AttackHolding = false
                    end
                end)
            end
        end
    end
end

-- Touch untuk gun aim
local function SetupMobileGun()
    local gunBtn = PlayerGui:FindFirstChild("Survivor-mob")
    if gunBtn then
        gunBtn = gunBtn:FindFirstChild("Controls")
        if gunBtn then
            gunBtn = gunBtn:FindFirstChild("Gui-mob")
            if gunBtn then
                gunBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        State.GunHolding = true
                    end
                end)
                gunBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        State.GunHolding = false
                    end
                end)
            end
        end
    end
end

-- Mouse untuk attack aim
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        State.AttackHolding = true
        State.GunHolding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        State.AttackHolding = false
        State.GunHolding = false
    end
end)

-- Retry setup setiap beberapa detik
task.spawn(function()
    while true do
        task.wait(2)
        SetupMobileAttack()
        SetupMobileGun()
    end
end)

-- ==============================================
-- 26. CHARACTER ADDED
-- ==============================================

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    ApplyWalkSpeed()
    ApplyJumpPower()
    if Settings.NoClip then ToggleNoClip(true) end
    SetupMobileAttack()
    SetupMobileGun()
end)

-- ==============================================
-- 27. INIT
-- ==============================================

-- Create GUI
CreateLogo()
CreateMenu()

-- Start functions
StartSkillCheck()
StartParry()
StartAttackAim()
StartGunAim()
ApplyVisual()

-- Notify loaded
Notify("GanKunZ Hub", "Loaded! Tap logo to open menu")

print("✅ GanKunZ Hub Lite Loaded!")
print("📱 Tap logo to open menu")
print("📱 WhatsApp: https://whatsapp.com/channel/0029Vb8MsxY7T8bUAjemYH2j")

-- ==============================================
-- END OF SCRIPT
-- ==============================================