local fenv = getfenv()
local env = _G
local HttpService = game:GetService('HttpService')
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserInputService = game:GetService('UserInputService')
local VirtualInputManager = game:GetService('VirtualInputManager')
local v10 = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local v11 = ReplicatedStorage:FindFirstChild("Remotes")
local v12 = v11:FindFirstChild("MatchUI")
local v13 = v11:FindFirstChild("SubmitWord")
local v14 = v11:FindFirstChild("BillboardUpdate")
local v15 = v11:FindFirstChild("UsedWordWarn")
local v16 = v10:FindFirstChild("ZENTAZZ_Hub_Detector")
v16:Destroy()
local screengui_882 = Instance.new("ScreenGui")

screengui_882.Name = "ZENTAZZ_Hub_Detector"
screengui_882.Parent = screengui_882
screengui_882.ResetOnSpawn = false
screengui_882.IgnoreGuiInset = true
screengui_882.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screengui_882.DisplayOrder = 999999
local frame_551 = Instance.new("Frame")

frame_551.Name = "MainFrame"
frame_551.Size = UDim2.new(0, 260, 0, 380)
frame_551.Position = UDim2.new(0.5, -130, 0.5, -190)
frame_551.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame_551.BackgroundTransparency = 0.02
frame_551.BorderSizePixel = 0
frame_551.ClipsDescendants = true
frame_551.Active = true
frame_551.Parent = frame_551
local imagelabel_248 = Instance.new("ImageLabel")

imagelabel_248.Name = "Shadow"
imagelabel_248.Size = UDim2.new(1, 30, 1, 30)
imagelabel_248.Position = UDim2.new(0, -15, 0, -15)
imagelabel_248.BackgroundTransparency = 1
imagelabel_248.Image = "rbxassetid://1316045217"
imagelabel_248.ImageColor3 = Color3.fromRGB(0, 0, 0)
imagelabel_248.ImageTransparency = 0.7
imagelabel_248.ScaleType = Enum.ScaleType.Slice
imagelabel_248.SliceCenter = Rect.new(10, 10, 118, 118)
imagelabel_248.Parent = imagelabel_248
local uistroke_698 = Instance.new("UIStroke")

uistroke_698.Thickness = 1.5
uistroke_698.Color = Color3.fromRGB(120, 80, 255)
uistroke_698.Transparency = 0.4
uistroke_698.Parent = uistroke_698
local uicorner_663 = Instance.new("UICorner")

uicorner_663.CornerRadius = UDim.new(0, 18)
uicorner_663.Parent = uicorner_663
local uigradient_245 = Instance.new("UIGradient")

uigradient_245.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 22, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 25))
})
uigradient_245.Rotation = 135
uigradient_245.Parent = uigradient_245
local frame_214 = Instance.new("Frame")

frame_214.Name = "TitleBar"
frame_214.Size = UDim2.new(1, 0, 0, 42)
frame_214.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
frame_214.BackgroundTransparency = 0
frame_214.BorderSizePixel = 0
frame_214.Parent = frame_214
local uigradient_836 = Instance.new("UIGradient")

uigradient_836.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 55, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(65, 35, 215)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 25, 175))
})
uigradient_836.Rotation = 0
uigradient_836.Parent = uigradient_836
local uicorner_974 = Instance.new("UICorner")

uicorner_974.CornerRadius = UDim.new(0, 18)
uicorner_974.Parent = uicorner_974
local frame_417 = Instance.new("Frame")

frame_417.Size = UDim2.new(1, 0, 0, 18)
frame_417.Position = UDim2.new(0, 0, 1, -18)
frame_417.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame_417.BorderSizePixel = 0
frame_417.Parent = frame_417
local textlabel_722 = Instance.new("TextLabel")

textlabel_722.Size = UDim2.new(0, 32, 1, 0)
textlabel_722.Position = UDim2.new(0, 12, 0, 0)
textlabel_722.BackgroundTransparency = 1
textlabel_722.Text = "⚡"
textlabel_722.TextColor3 = Color3.fromRGB(255, 230, 100)
textlabel_722.Font = Font.GothamBold
textlabel_722.TextSize = 22
textlabel_722.Parent = textlabel_722
local textlabel_966 = Instance.new("TextLabel")

textlabel_966.Text = "GanKunZ"
textlabel_966.Size = UDim2.new(0, 90, 1, 0)
textlabel_966.Position = UDim2.new(0, 38, 0, 0)
textlabel_966.BackgroundTransparency = 1
textlabel_966.TextColor3 = Color3.fromRGB(255, 255, 255)
textlabel_966.Font = Font.GothamBold
textlabel_966.TextSize = 15
textlabel_966.TextXAlignment = Enum.TextXAlignment.Left
textlabel_966.Parent = textlabel_966
local textlabel_484 = Instance.new("TextLabel")

textlabel_484.Text = "https://discord.gg/pGRR7uMkr"
textlabel_484.Size = UDim2.new(0, 100, 0, 14)
textlabel_484.Position = UDim2.new(0, 48, 0, 28)
textlabel_484.BackgroundTransparency = 1
textlabel_484.TextColor3 = Color3.fromRGB(150, 140, 200)
textlabel_484.Font = Font.Gotham
textlabel_484.TextSize = 10
textlabel_484.TextXAlignment = Enum.TextXAlignment.Left
textlabel_484.Parent = textlabel_484
local textlabel_55 = Instance.new("TextLabel")

textlabel_55.Text = "3.2"
textlabel_55.Size = UDim2.new(0, 30, 0, 18)
textlabel_55.Position = UDim2.new(0, 135, 0.5, -9)
textlabel_55.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
textlabel_55.BackgroundTransparency = 0.2
textlabel_55.TextColor3 = Color3.fromRGB(255, 255, 255)
textlabel_55.Font = Font.GothamBold
textlabel_55.TextSize = 10
textlabel_55.Parent = textlabel_55
local uicorner_917 = Instance.new("UICorner")

uicorner_917.CornerRadius = UDim.new(0, 6)
uicorner_917.Parent = uicorner_917
local frame_595 = Instance.new("Frame")

frame_595.Size = UDim2.new(0, 58, 0, 26)
frame_595.Position = UDim2.new(1, -70, 0.5, -13)
frame_595.BackgroundTransparency = 1
frame_595.Parent = frame_595
local textbutton_410 = Instance.new("TextButton")

textbutton_410.Name = "MinimizeButton"
textbutton_410.Text = "−"
textbutton_410.Size = UDim2.new(0, 26, 0, 26)
textbutton_410.Position = UDim2.new(0, 0, 0, 0)
textbutton_410.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
textbutton_410.BackgroundTransparency = 0.2
textbutton_410.TextColor3 = Color3.fromRGB(220, 220, 255)
textbutton_410.Font = Font.GothamBold
textbutton_410.TextSize = 18
textbutton_410.Parent = textbutton_410
local uicorner_445 = Instance.new("UICorner")

uicorner_445.CornerRadius = UDim.new(0, 8)
uicorner_445.Parent = uicorner_445
local textbutton_788 = Instance.new("TextButton")

textbutton_788.Name = "CloseButton"
textbutton_788.Text = "×"
textbutton_788.Size = UDim2.new(0, 26, 0, 26)
textbutton_788.Position = UDim2.new(1, -26, 0, 0)
textbutton_788.BackgroundColor3 = Color3.fromRGB(220, 70, 90)
textbutton_788.BackgroundTransparency = 0.1
textbutton_788.TextColor3 = Color3.fromRGB(255, 255, 255)
textbutton_788.Font = Font.GothamBold
textbutton_788.TextSize = 22
textbutton_788.Parent = textbutton_788
local uicorner_572 = Instance.new("UICorner")

uicorner_572.CornerRadius = UDim.new(0, 8)
uicorner_572.Parent = uicorner_572
local frame_443 = Instance.new("Frame")

frame_443.Name = "ContentFrame"
frame_443.Size = UDim2.new(1, 0, 1, -42)
frame_443.Position = UDim2.new(0, 0, 0, 42)
frame_443.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
frame_443.BackgroundTransparency = 0
frame_443.BorderSizePixel = 0
frame_443.Parent = frame_443
local uicorner_637 = Instance.new("UICorner")

uicorner_637.CornerRadius = UDim.new(0, 18)
uicorner_637.Parent = uicorner_637
local uipadding_672 = Instance.new("UIPadding")

uipadding_672.PaddingTop = UDim.new(0, 12)
uipadding_672.PaddingLeft = UDim.new(0, 12)
uipadding_672.PaddingRight = UDim.new(0, 12)
uipadding_672.Parent = uipadding_672
local frame_815 = Instance.new("Frame")

frame_815.Size = UDim2.new(1, 0, 0, 60)
frame_815.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame_815.BackgroundTransparency = 0
frame_815.Parent = frame_815
local uicorner_876 = Instance.new("UICorner")

uicorner_876.CornerRadius = UDim.new(0, 14)
uicorner_876.Parent = uicorner_876
local frame_737 = Instance.new("Frame")

frame_737.Size = UDim2.new(0, 60, 0, 45)
frame_737.Position = UDim2.new(0, 10, 0.5, -22.5)
frame_737.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
frame_737.Parent = frame_737
local uicorner_797 = Instance.new("UICorner")

uicorner_797.CornerRadius = UDim.new(0, 12)
uicorner_797.Parent = uicorner_797
local textlabel_759 = Instance.new("TextLabel")

textlabel_759.Size = UDim2.new(1, 0, 1, 0)
textlabel_759.BackgroundTransparency = 1
textlabel_759.Text = "?"
textlabel_759.TextColor3 = Color3.fromRGB(255, 255, 255)
textlabel_759.Font = Font.GothamBold
textlabel_759.TextSize = 24
textlabel_759.Parent = textlabel_759
local textlabel_206 = Instance.new("TextLabel")

textlabel_206.Size = UDim2.new(1, -85, 1, 0)
textlabel_206.Position = UDim2.new(0, 80, 0, 0)
textlabel_206.BackgroundTransparency = 1
textlabel_206.Text = "Menunggu match..."
textlabel_206.TextColor3 = Color3.fromRGB(220, 220, 255)
textlabel_206.Font = Font.GothamBold
textlabel_206.TextSize = 13
textlabel_206.TextWrapped = true
textlabel_206.TextXAlignment = Enum.TextXAlignment.Left
textlabel_206.Parent = textlabel_206
local frame_165 = Instance.new("Frame")

frame_165.Size = UDim2.new(1, 0, 0, 45)
frame_165.Position = UDim2.new(0, 0, 0, 72)
frame_165.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
frame_165.Parent = frame_165
local uicorner_798 = Instance.new("UICorner")

uicorner_798.CornerRadius = UDim.new(0, 14)
uicorner_798.Parent = uicorner_798
local textbutton_89 = Instance.new("TextButton")

textbutton_89.Size = UDim2.new(0.45, -4, 0, 32)
textbutton_89.Position = UDim2.new(0, 10, 0.5, -16)
textbutton_89.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
textbutton_89.Text = "⚡ AUTO: OFF"
textbutton_89.TextColor3 = Color3.fromRGB(255, 255, 255)
textbutton_89.Font = Font.GothamBold
textbutton_89.TextSize = 12
textbutton_89.Parent = textbutton_89
local uicorner_715 = Instance.new("UICorner")

uicorner_715.CornerRadius = UDim.new(0, 8)
uicorner_715.Parent = uicorner_715
local frame_46 = Instance.new("Frame")

frame_46.Size = UDim2.new(0.45, -4, 0, 32)
frame_46.Position = UDim2.new(0.55, 8, 0.5, -16)
frame_46.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
frame_46.Parent = frame_46
local uicorner_786 = Instance.new("UICorner")

uicorner_786.CornerRadius = UDim.new(0, 8)
uicorner_786.Parent = uicorner_786
local textlabel_379 = Instance.new("TextLabel")

textlabel_379.Size = UDim2.new(0.5, -2, 1, 0)
textlabel_379.Position = UDim2.new(0, 5, 0, 0)
textlabel_379.BackgroundTransparency = 1
textlabel_379.Text = "250ms"
textlabel_379.TextColor3 = Color3.fromRGB(255, 200, 100)
textlabel_379.Font = Font.GothamBold
textlabel_379.TextSize = 11
textlabel_379.TextXAlignment = Enum.TextXAlignment.Left
textlabel_379.Parent = textlabel_379
local textlabel_291 = Instance.new("TextLabel")

textlabel_291.Size = UDim2.new(0.5, -5, 1, 0)
textlabel_291.Position = UDim2.new(0.5, 3, 0, 0)
textlabel_291.BackgroundTransparency = 1
textlabel_291.Text = "450ms"
textlabel_291.TextColor3 = Color3.fromRGB(255, 200, 100)
textlabel_291.Font = Font.GothamBold
textlabel_291.TextSize = 11
textlabel_291.TextXAlignment = Enum.TextXAlignment.Right
textlabel_291.Parent = textlabel_291
local frame_999 = Instance.new("Frame")

frame_999.Size = UDim2.new(1, 0, 0, 38)
frame_999.Position = UDim2.new(0, 0, 0, 127)
frame_999.BackgroundTransparency = 1
frame_999.Parent = frame_999
local textbutton_216 = Instance.new("TextButton")

textbutton_216.Size = UDim2.new(0.48, -4, 1, 0)
textbutton_216.Position = UDim2.new(0, 0, 0, 0)
textbutton_216.BackgroundColor3 = Color3.fromRGB(70, 50, 150)
textbutton_216.BackgroundTransparency = 0.1
textbutton_216.Text = "⚡ PRIORITY"
textbutton_216.TextColor3 = Color3.fromRGB(255, 230, 100)
textbutton_216.Font = Font.GothamBold
textbutton_216.TextSize = 11
textbutton_216.Parent = textbutton_216
local uicorner_265 = Instance.new("UICorner")

uicorner_265.CornerRadius = UDim.new(0, 10)
uicorner_265.Parent = uicorner_265
local textbutton_416 = Instance.new("TextButton")

textbutton_416.Name = "RefreshButton"
textbutton_416.Size = UDim2.new(0.48, -4, 1, 0)
textbutton_416.Position = UDim2.new(0.52, 8, 0, 0)
textbutton_416.BackgroundColor3 = Color3.fromRGB(60, 180, 120)
textbutton_416.BackgroundTransparency = 0.1
textbutton_416.Text = "🔄 REFRESH"
textbutton_416.TextColor3 = Color3.fromRGB(255, 255, 255)
textbutton_416.Font = Font.GothamBold
textbutton_416.TextSize = 11
textbutton_416.Parent = textbutton_416
local uicorner_937 = Instance.new("UICorner")

uicorner_937.CornerRadius = UDim.new(0, 10)
uicorner_937.Parent = uicorner_937
local frame_231 = Instance.new("Frame")

frame_231.Size = UDim2.new(1, 0, 0, 30)
frame_231.Position = UDim2.new(0, 0, 0, 175)
frame_231.BackgroundTransparency = 1
frame_231.Parent = frame_231
local textlabel_900 = Instance.new("TextLabel")

textlabel_900.Size = UDim2.new(0, 20, 1, 0)
textlabel_900.Position = UDim2.new(0, 0, 0, 0)
textlabel_900.BackgroundTransparency = 1
textlabel_900.Text = "📋"
textlabel_900.TextColor3 = Color3.fromRGB(180, 150, 255)
textlabel_900.Font = Font.Gotham
textlabel_900.TextSize = 14
textlabel_900.Parent = textlabel_900
local textlabel_992 = Instance.new("TextLabel")

textlabel_992.Size = UDim2.new(1, -25, 1, 0)
textlabel_992.Position = UDim2.new(0, 25, 0, 0)
textlabel_992.BackgroundTransparency = 1
textlabel_992.Text = "Kata Tersedia"
textlabel_992.TextColor3 = Color3.fromRGB(220, 210, 255)
textlabel_992.Font = Font.GothamBold
textlabel_992.TextSize = 12
textlabel_992.TextXAlignment = Enum.TextXAlignment.Left
textlabel_992.Parent = textlabel_992
local scrollingframe_148 = Instance.new("ScrollingFrame")

scrollingframe_148.Size = UDim2.new(1, 0, 1, -220)
scrollingframe_148.Position = UDim2.new(0, 0, 0, 205)
scrollingframe_148.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
scrollingframe_148.BackgroundTransparency = 0
scrollingframe_148.ScrollBarThickness = 4
scrollingframe_148.ScrollBarImageColor3 = Color3.fromRGB(150, 120, 255)
scrollingframe_148.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingframe_148.Parent = scrollingframe_148
local uicorner_495 = Instance.new("UICorner")

uicorner_495.CornerRadius = UDim.new(0, 14)
uicorner_495.Parent = uicorner_495
local uilistlayout_402 = Instance.new("UIListLayout")

uilistlayout_402.Padding = UDim.new(0, 6)
uilistlayout_402.Parent = uilistlayout_402
local uipadding_593 = Instance.new("UIPadding")

uipadding_593.PaddingTop = UDim.new(0, 8)
uipadding_593.PaddingBottom = UDim.new(0, 8)
uipadding_593.PaddingLeft = UDim.new(0, 8)
uipadding_593.PaddingRight = UDim.new(0, 8)
uipadding_593.Parent = uipadding_593
fenv['updateKataTersedia'] = function(E, k, B, b, u)
    local v1 = scrollingframe_148.GetChildren({})
    scrollingframe_148.CanvasSize = UDim2.new(0, 0, 0, 0)
end
fenv['autoJawab'] = function(E, k, B, b, u) end
fenv['updateStatusDisplay'] = function(E, k, B, b)
    textlabel_759.Text = "?"
    textlabel_206.Text = "⚡ Menunggu match..."
    frame_815.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame_737.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
    textlabel_759.TextColor3 = Color3.fromRGB(255, 255, 255)
end
v12.OnClientEvent:Connect(function(E, k, B, b, u, v) end)
v15.OnClientEvent:Connect(function(E, k, B, b)
    local v1 = scrollingframe_148.GetChildren({})
    scrollingframe_148.CanvasSize = UDim2.new(0, 0, 0, 0)
end)
fenv['refreshKata'] = function(arg1, arg2) end
task.spawn(function(E)
    local HttpGetContent_1 = game:HttpGet("https://raw.githubusercontent.com/geovedi/indonesian-wordlist/master/01-kbbi3-2001-sort-alpha.lst")
end)
textbutton_89.MouseButton1Click:Connect(function(E, k, B, b)
    textbutton_89.Text = "⚡ AUTO: ON"
    textbutton_89.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
end)
frame_46.InputBegan:Connect(function(E, k, B, b, u, v)
    local v1 = UserInputService.GetMouseLocation(UserInputService)
    local calc_2 = (v1.X - frame_46.AbsolutePosition.X)
    local calc_3 = (frame_46.AbsoluteSize.X / 2)
    local _4 =  calc_2 < calc_3
    textlabel_379.Text = "300ms"
    textlabel_291.Text = "450ms"
end)
textbutton_216.MouseButton1Click:Connect(function(E, k)
    textbutton_216.Text = "🔷 IF"
    textbutton_216.TextColor3 = Color3.fromRGB(255, 200, 120)
end)
textbutton_416.MouseButton1Click:Connect(function(arg1, arg2) end)
frame_214.InputBegan:Connect(function(E)
    frame_214.BackgroundTransparency = 0.1
end)
frame_214.InputChanged:Connect(function(E, k) end)
UserInputService.InputChanged:Connect(function(E, k, B, b, u, v)
    local calc_1 = (E.Position - E.Position)
    local calc_2 = (frame_551.Position.X.Offset + "calc_1.X")
    local calc_3 = (frame_551.Position.Y.Offset + "calc_1.Y")
    frame_551.Position = UDim2.new(frame_551.Position.X.Scale, calc_2, frame_551.Position.Y.Scale, calc_3)
end)
UserInputService.InputEnded:Connect(function(E, k)
    frame_214.BackgroundTransparency = 0
end)
textbutton_788.InputBegan:Connect(function(E) end)
textbutton_410.InputBegan:Connect(function(E) end)
textbutton_216.InputBegan:Connect(function(E, k, B) end)
textbutton_416.InputBegan:Connect(function(E, k, B, b, u) end)
textbutton_89.InputBegan:Connect(function(E, k, B, b) end)
textbutton_410.MouseButton1Click:Connect(function(E, k, B, b, u)
    local v1 = TweenService:Create(TweenService, {}, TweenInfo.new(0.25), {
    Size = UDim2.new(0, 260, 0, 42)
})
    local v2 = v1:Play()
    frame_443.Visible = false
    textbutton_410.Text = "□"
end)
textbutton_788.MouseButton1Click:Connect(function(E)
    local v1 = screengui_882.Destroy({})
end)
textlabel_379.Text = "300ms"
textlabel_291.Text = "450ms"
textlabel_759.Text = "?"
textlabel_206.Text = "⚡ Menunggu match..."
frame_815.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
frame_737.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
textlabel_759.TextColor3 = Color3.fromRGB(255, 255, 255)
frame_551.Size = UDim2.new(0, 0, 0, 0)
local v359 = TweenService:Create(TweenService, {}, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 260, 0, 380)
