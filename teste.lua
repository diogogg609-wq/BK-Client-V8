local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("BK_Official_UI") then
        CoreGui:FindFirstChild("BK_Official_UI"):Destroy()
    end
    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("BK_Official_UI") then
        LocalPlayer.PlayerGui:FindFirstChild("BK_Official_UI"):Destroy()
    end
end)

local ESP_Config = {
    BoxEnabled = false,
    BoxColor = Color3.fromRGB(110, 60, 220),
    BoxThickness = 1.5,
    BoxSizeMultiplier = 1.0,
    
    LineEnabled = false,
    LineColor = Color3.fromRGB(255, 50, 50),
    LineThickness = 1.5,
    LineOrigin = "Baixo",

    NameEnabled = false,
    NameSize = 12,
    NameColor = Color3.fromRGB(255, 255, 255),
    NameRainbow = false,

    DistEnabled = false,
    DistColor = Color3.fromRGB(200, 200, 200),
    MaxDistance = 350
}

local ActiveBoxes = {}
local ActiveLines = {}
local ActiveNames = {}
local ActiveDists = {}

local function playSound(id, volume)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = volume or 0.5
        sound.Parent = CoreGui
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Official_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 10

local successParent = pcall(function() 
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
end)
if not successParent then
    pcall(function() ScreenGui.Parent = CoreGui end)
end

local BGColor = Color3.fromRGB(10, 10, 12)
local MenuBGColor = Color3.fromRGB(14, 14, 16)
local SidebarColor = Color3.fromRGB(8, 8, 10)
local AccentColor = Color3.fromRGB(110, 60, 220)
local BorderColor = Color3.fromRGB(50, 50, 55)

local Capsule = Instance.new("TextButton")
Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 160, 0, 42)
Capsule.Position = UDim2.new(0.15, 0, 0.15, 0)
Capsule.BackgroundColor3 = BGColor
Capsule.BorderSizePixel = 0
Capsule.AutoButtonColor = false
Capsule.Text = ""
Capsule.Active = true
Capsule.ClipsDescendants = true 
Capsule.ZIndex = 10
Capsule.Parent = ScreenGui

Instance.new("UICorner", Capsule).CornerRadius = UDim.new(0, 21)
local CapsuleStroke = Instance.new("UIStroke", Capsule)
CapsuleStroke.Color = BorderColor
CapsuleStroke.Thickness = 1.5

local StarContainer = Instance.new("Frame")
StarContainer.Size = UDim2.new(1, 0, 1, 0)
StarContainer.BackgroundTransparency = 1
StarContainer.ZIndex = 1
StarContainer.Parent = Capsule

local numNodes = 6
local nodes = {}
local connectionLines = {}
local MAX_CONNECT_DIST = 50

for i = 1, numNodes do
    local nodeFrame = Instance.new("Frame")
    nodeFrame.BackgroundColor3 = Color3.fromRGB(230, 200, 255)
    nodeFrame.BorderSizePixel = 0
    local size = math.random(3, 5)
    nodeFrame.Size = UDim2.new(0, size, 0, size)
    nodeFrame.BackgroundTransparency = math.random(2, 5) / 10
    nodeFrame.Position = UDim2.new(math.random(), 0, math.random(), 0)
    nodeFrame.ZIndex = 3
    nodeFrame.Parent = StarContainer
    
    Instance.new("UICorner", nodeFrame).CornerRadius = UDim.new(1, 0)
    
    local nodeGlow = Instance.new("UIStroke", nodeFrame)
    nodeGlow.Color = AccentColor
    nodeGlow.Thickness = 1.2
    nodeGlow.Transparency = 0.3
    
    local angle = math.random() * math.pi * 2
    local speed = math.random(3, 8) / 100
    local vx = math.cos(angle) * speed
    local vy = math.sin(angle) * speed
    
    table.insert(nodes, {frame = nodeFrame, vx = vx, vy = vy, baseTransparency = nodeFrame.BackgroundTransparency})
end

local function drawLine(posA, posB, distance)
    local line = Instance.new("Frame")
    line.BorderSizePixel = 0
    line.ZIndex = 2
    
    local rawTransparency = (distance / MAX_CONNECT_DIST)
    local trans = 0.3 + (rawTransparency * 0.7)
    local thickness = 1.2 - (rawTransparency * 0.4)
    
    line.BackgroundTransparency = math.clamp(trans, 0.3, 1)
    line.BackgroundColor3 = AccentColor
    
    local startPos = Vector2.new(posA.X, posA.Y)
    local endPos = Vector2.new(posB.X, posB.Y)
    local diff = endPos - startPos
    local angle = math.atan2(diff.Y, diff.X)
    
    line.Size = UDim2.new(0, diff.Magnitude, 0, thickness)
    line.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
    line.Rotation = math.deg(angle)
    line.AnchorPoint = Vector2.new(0, 0.5)
    line.Parent = StarContainer
    
    table.insert(connectionLines, line)
end

RunService.RenderStepped:Connect(function(dt)
    if not Capsule.Parent then return end
    for _, line in ipairs(connectionLines) do line:Destroy() end
    table.clear(connectionLines)
    
    local time = os.clock()
    for _, data in ipairs(nodes) do
        local node = data.frame
        local newX = node.Position.X.Scale + (data.vx * dt)
        local newY = node.Position.Y.Scale + (data.vy * dt)
        
        if newX < 0.05 or newX > 0.95 then data.vx = -data.vx newX = math.clamp(newX, 0.05, 0.95) end
        if newY < 0.05 or newY > 0.95 then data.vy = -data.vy newY = math.clamp(newY, 0.05, 0.95) end
        
        node.Position = UDim2.new(newX, 0, newY, 0)
        local glowTrans = data.baseTransparency + math.sin(time * 3 + node.AbsolutePosition.X * 0.1) * 0.15
        node.BackgroundTransparency = math.clamp(glowTrans, 0.2, 0.6)
    end
    
    for i = 1, #nodes do
        local nodeA = nodes[i].frame
        local posA = nodeA.AbsolutePosition - Capsule.AbsolutePosition + (nodeA.AbsoluteSize/2)
        for j = i + 1, #nodes do
            local nodeB = nodes[j].frame
            local posB = nodeB.AbsolutePosition - Capsule.AbsolutePosition + (nodeB.AbsoluteSize/2)
            local distance = (posA - posB).Magnitude
            if distance < MAX_CONNECT_DIST then
                drawLine(posA, posB, distance)
            end
        end
    end
end)

local CapsuleLabel = Instance.new("TextLabel")
CapsuleLabel.Size = UDim2.new(1, 0, 1, 0)
CapsuleLabel.BackgroundTransparency = 1
CapsuleLabel.Text = "BK CLIENT V1.2 †"
CapsuleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
CapsuleLabel.TextSize = 13
CapsuleLabel.Font = Enum.Font.GothamBold
CapsuleLabel.ZIndex = 5
CapsuleLabel.Parent = Capsule

local CentralMenuCanvas = Instance.new("CanvasGroup")
CentralMenuCanvas.Name = "BK_CentralMenu"
CentralMenuCanvas.Size = UDim2.new(0, 500, 0, 320)
CentralMenuCanvas.AnchorPoint = Vector2.new(0.5, 0.5)
CentralMenuCanvas.Position = UDim2.new(0.5, 0, 0.5, 0)
CentralMenuCanvas.BackgroundColor3 = MenuBGColor
CentralMenuCanvas.Visible = false
CentralMenuCanvas.Active = true
CentralMenuCanvas.GroupTransparency = 1
CentralMenuCanvas.ZIndex = 5
CentralMenuCanvas.Parent = ScreenGui

Instance.new("UICorner", CentralMenuCanvas).CornerRadius = UDim.new(0, 12)
local MenuStroke = Instance.new("UIStroke", CentralMenuCanvas)
MenuStroke.Color = BorderColor
MenuStroke.Thickness = 1.5

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = SidebarColor
Header.BorderSizePixel = 0
Header.ZIndex = 6
Header.Parent = CentralMenuCanvas
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderAvatar = Instance.new("ImageLabel")
HeaderAvatar.Size = UDim2.new(0, 38, 0, 38)
HeaderAvatar.Position = UDim2.new(0, 15, 0.5, -19)
HeaderAvatar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
HeaderAvatar.BorderSizePixel = 0
HeaderAvatar.ZIndex = 7
HeaderAvatar.Parent = Header
Instance.new("UICorner", HeaderAvatar).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    pcall(function()
        HeaderAvatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    end)
end)

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Position = UDim2.new(0, 65, 0, 0)
HeaderTitle.Size = UDim2.new(0, 300, 1, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = LocalPlayer.DisplayName .. " | BK CLIENT V1.2"
HeaderTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 7
HeaderTitle.Parent = Header

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.Position = UDim2.new(1, -130, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 6
Sidebar.Parent = CentralMenuCanvas

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 7
TabContainer.Parent = Sidebar

Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)
TabContainer.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", TabContainer).PaddingTop = UDim.new(0, 10)

local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 15, 0, 70)
ContentContainer.Size = UDim2.new(1, -160, 1, -85)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 6
ContentContainer.Parent = CentralMenuCanvas

local Tabs = {}
local Pages = {}

local function createTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 36)
    TabBtn.BackgroundColor3 = AccentColor
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 12
    TabBtn.ZIndex = 8
    TabBtn.Parent = TabContainer
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)
    
    local BtnStroke = Instance.new("UIStroke", TabBtn)
    BtnStroke.Color = AccentColor
    BtnStroke.Thickness = 1.2
    BtnStroke.Transparency = 1

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ZIndex = 7
    Page.Parent = ContentContainer

    TabBtn.MouseButton1Click:Connect(function()
        playSound("12222076", 0.3)
        for _, otherTab in pairs(Tabs) do
            TweenService:Create(otherTab.Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 165), BackgroundTransparency = 1}):Play()
            TweenService:Create(otherTab.Stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        end
        for _, otherPage in pairs(Pages) do 
            otherPage.Visible = false 
        end

        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            BackgroundColor3 = AccentColor
        }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Transparency = 0.3}):Play()
    end)

    Tabs[name] = {Btn = TabBtn, Stroke = BtnStroke}
    Pages[name] = Page
end

createTab("Visual")
createTab("Mira")
createTab("Status")
createTab("Configurações")

-- ==========================================
-- SEÇÃO MÓVEL DA BOX
-- ==========================================
local BoxCustomizerWindow = Instance.new("Frame")
BoxCustomizerWindow.Name = "BK_BoxCustomizer"
BoxCustomizerWindow.Size = UDim2.new(0, 220, 0, 190)
BoxCustomizerWindow.Position = UDim2.new(0.5, -230, 0.5, -210)
BoxCustomizerWindow.BackgroundColor3 = MenuBGColor
BoxCustomizerWindow.BorderSizePixel = 0
BoxCustomizerWindow.Active = true
BoxCustomizerWindow.Visible = false
BoxCustomizerWindow.ZIndex = 30
BoxCustomizerWindow.Parent = ScreenGui

Instance.new("UICorner", BoxCustomizerWindow).CornerRadius = UDim.new(0, 8)
local BoxCustomizerStroke = Instance.new("UIStroke", BoxCustomizerWindow)
BoxCustomizerStroke.Color = AccentColor
BoxCustomizerStroke.Thickness = 1.2

local BoxCustomHeader = Instance.new("Frame")
BoxCustomHeader.Size = UDim2.new(1, 0, 0, 28)
BoxCustomHeader.BackgroundColor3 = SidebarColor
BoxCustomHeader.BorderSizePixel = 0
BoxCustomHeader.ZIndex = 31
BoxCustomHeader.Parent = BoxCustomizerWindow
Instance.new("UICorner", BoxCustomHeader).CornerRadius = UDim.new(0, 8)

local BoxCustomTitle = Instance.new("TextLabel")
BoxCustomTitle.Size = UDim2.new(1, -30, 1, 0)
BoxCustomTitle.Position = UDim2.new(0, 10, 0, 0)
BoxCustomTitle.BackgroundTransparency = 1
BoxCustomTitle.Text = "Ajustes da Box"
BoxCustomTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
BoxCustomTitle.Font = Enum.Font.GothamBold
BoxCustomTitle.TextSize = 11
BoxCustomTitle.TextXAlignment = Enum.TextXAlignment.Left
BoxCustomTitle.ZIndex = 32
BoxCustomTitle.Parent = BoxCustomHeader

local BoxCustomClose = Instance.new("TextButton")
BoxCustomClose.Size = UDim2.new(0, 24, 0, 24)
BoxCustomClose.Position = UDim2.new(1, -26, 0.5, -12)
BoxCustomClose.BackgroundTransparency = 1
BoxCustomClose.Text = "×"
BoxCustomClose.TextColor3 = Color3.fromRGB(150, 150, 150)
BoxCustomClose.Font = Enum.Font.GothamBold
BoxCustomClose.TextSize = 18
BoxCustomClose.ZIndex = 32
BoxCustomClose.Parent = BoxCustomHeader

BoxCustomClose.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    BoxCustomizerWindow.Visible = false
end)

local boxDragging = false
local boxDragStart, boxStartPos

BoxCustomHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        boxDragging = true
        boxDragStart = input.Position
        boxStartPos = BoxCustomizerWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if boxDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - boxDragStart
        BoxCustomizerWindow.Position = UDim2.new(
            boxStartPos.X.Scale, 
            boxStartPos.X.Offset + delta.X, 
            boxStartPos.Y.Scale, 
            boxStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        boxDragging = false
    end
end)

local BoxCustomBody = Instance.new("Frame")
BoxCustomBody.Position = UDim2.new(0, 0, 0, 28)
BoxCustomBody.Size = UDim2.new(1, 0, 1, -28)
BoxCustomBody.BackgroundTransparency = 1
BoxCustomBody.ZIndex = 31
BoxCustomBody.Parent = BoxCustomizerWindow

local BoxBodyLayout = Instance.new("UIListLayout", BoxCustomBody)
BoxBodyLayout.Padding = UDim.new(0, 8)
BoxBodyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", BoxCustomBody).PaddingTop = UDim.new(0, 8)

local BoxColorSection = Instance.new("Frame")
BoxColorSection.Size = UDim2.new(0.9, 0, 0, 32)
BoxColorSection.BackgroundTransparency = 1
BoxColorSection.ZIndex = 32
BoxColorSection.Parent = BoxCustomBody

local BoxColorLabel = Instance.new("TextLabel")
BoxColorLabel.Size = UDim2.new(0.4, 0, 1, 0)
BoxColorLabel.BackgroundTransparency = 1
BoxColorLabel.Text = "Cor da Box:"
BoxColorLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
BoxColorLabel.Font = Enum.Font.GothamSemibold
BoxColorLabel.TextSize = 10
BoxColorLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxColorLabel.ZIndex = 33
BoxColorLabel.Parent = BoxColorSection

local BoxColorBtnContainer = Instance.new("Frame")
BoxColorBtnContainer.Size = UDim2.new(0.6, 0, 1, 0)
BoxColorBtnContainer.Position = UDim2.new(0.4, 0, 0, 0)
BoxColorBtnContainer.BackgroundTransparency = 1
BoxColorBtnContainer.ZIndex = 33
BoxColorBtnContainer.Parent = BoxColorSection

local ColorsList = {
    {Color = Color3.fromRGB(0, 255, 120), Text = "Verde"},
    {Color = Color3.fromRGB(110, 60, 220), Text = "Roxo"},
    {Color = Color3.fromRGB(255, 50, 50), Text = "Verm."}
}

for idx, colorData in ipairs(ColorsList) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 35, 0, 22)
    cBtn.Position = UDim2.new(0, (idx - 1) * 40, 0.5, -11)
    cBtn.BackgroundColor3 = colorData.Color
    cBtn.BorderSizePixel = 0
    cBtn.Text = ""
    cBtn.ZIndex = 34
    cBtn.Parent = BoxColorBtnContainer
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    
    local cBtnStroke = Instance.new("UIStroke", cBtn)
    cBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    cBtnStroke.Thickness = 1.2
    cBtnStroke.Transparency = (ESP_Config.BoxColor == colorData.Color) and 0 or 1
    
    cBtn.MouseButton1Click:Connect(function()
        playSound("12222076", 0.35)
        ESP_Config.BoxColor = colorData.Color
        for _, child in ipairs(BoxColorBtnContainer:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChildOfClass("UIStroke") then
                child:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
        cBtnStroke.Transparency = 0
    end)
end

local BoxThickSection = Instance.new("Frame")
BoxThickSection.Size = UDim2.new(0.9, 0, 0, 32)
BoxThickSection.BackgroundTransparency = 1
BoxThickSection.ZIndex = 32
BoxThickSection.Parent = BoxCustomBody

local BoxThickLabel = Instance.new("TextLabel")
BoxThickLabel.Size = UDim2.new(0.4, 0, 1, 0)
BoxThickLabel.BackgroundTransparency = 1
BoxThickLabel.Text = "Espessura:"
BoxThickLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
BoxThickLabel.Font = Enum.Font.GothamSemibold
BoxThickLabel.TextSize = 10
BoxThickLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxThickLabel.ZIndex = 33
BoxThickLabel.Parent = BoxThickSection

local BoxThickValLabel = Instance.new("TextLabel")
BoxThickValLabel.Size = UDim2.new(0.2, 0, 1, 0)
BoxThickValLabel.Position = UDim2.new(0.4, 0, 0, 0)
BoxThickValLabel.BackgroundTransparency = 1
BoxThickValLabel.Text = tostring(ESP_Config.BoxThickness)
BoxThickValLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
BoxThickValLabel.Font = Enum.Font.GothamBold
BoxThickValLabel.TextSize = 11
BoxThickValLabel.ZIndex = 33
BoxThickValLabel.Parent = BoxThickSection

local BoxThickLess = Instance.new("TextButton")
BoxThickLess.Size = UDim2.new(0, 24, 0, 24)
BoxThickLess.Position = UDim2.new(0.65, 0, 0.5, -12)
BoxThickLess.BackgroundColor3 = SidebarColor
BoxThickLess.Text = "-"
BoxThickLess.TextColor3 = Color3.fromRGB(240, 240, 240)
BoxThickLess.Font = Enum.Font.GothamBold
BoxThickLess.TextSize = 12
BoxThickLess.ZIndex = 34
BoxThickLess.Parent = BoxThickSection
Instance.new("UICorner", BoxThickLess).CornerRadius = UDim.new(0, 4)

local BoxThickMore = Instance.new("TextButton")
BoxThickMore.Size = UDim2.new(0, 24, 0, 24)
BoxThickMore.Position = UDim2.new(0.85, 0, 0.5, -12)
BoxThickMore.BackgroundColor3 = SidebarColor
BoxThickMore.Text = "+"
BoxThickMore.TextColor3 = Color3.fromRGB(240, 240, 240)
BoxThickMore.Font = Enum.Font.GothamBold
BoxThickMore.TextSize = 12
BoxThickMore.ZIndex = 34
BoxThickMore.Parent = BoxThickSection
Instance.new("UICorner", BoxThickMore).CornerRadius = UDim.new(0, 4)

BoxThickLess.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    ESP_Config.BoxThickness = math.clamp(ESP_Config.BoxThickness - 0.5, 1, 5)
    BoxThickValLabel.Text = tostring(ESP_Config.BoxThickness)
end)

BoxThickMore.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    ESP_Config.BoxThickness = math.clamp(ESP_Config.BoxThickness + 0.5, 1, 5)
    BoxThickValLabel.Text = tostring(ESP_Config.BoxThickness)
end)

local BoxSizeSection = Instance.new("Frame")
BoxSizeSection.Size = UDim2.new(0.9, 0, 0, 32)
BoxSizeSection.BackgroundTransparency = 1
BoxSizeSection.ZIndex = 32
BoxSizeSection.Parent = BoxCustomBody

local BoxSizeLabel = Instance.new("TextLabel")
BoxSizeLabel.Size = UDim2.new(0.4, 0, 1, 0)
BoxSizeLabel.BackgroundTransparency = 1
BoxSizeLabel.Text = "Tamanho:"
BoxSizeLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
BoxSizeLabel.Font = Enum.Font.GothamSemibold
BoxSizeLabel.TextSize = 10
BoxSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxSizeLabel.ZIndex = 33
BoxSizeLabel.Parent = BoxSizeSection

local BoxSizeValLabel = Instance.new("TextLabel")
BoxSizeValLabel.Size = UDim2.new(0.2, 0, 1, 0)
BoxSizeValLabel.Position = UDim2.new(0.4, 0, 0, 0)
BoxSizeValLabel.BackgroundTransparency = 1
BoxSizeValLabel.Text = string.format("%.1fx", ESP_Config.BoxSizeMultiplier)
BoxSizeValLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
BoxSizeValLabel.Font = Enum.Font.GothamBold
BoxSizeValLabel.TextSize = 11
BoxSizeValLabel.ZIndex = 33
BoxSizeValLabel.Parent = BoxSizeSection

local BoxSizeLess = Instance.new("TextButton")
BoxSizeLess.Size = UDim2.new(0, 24, 0, 24)
BoxSizeLess.Position = UDim2.new(0.65, 0, 0.5, -12)
BoxSizeLess.BackgroundColor3 = SidebarColor
BoxSizeLess.Text = "-"
BoxSizeLess.TextColor3 = Color3.fromRGB(240, 240, 240)
BoxSizeLess.Font = Enum.Font.GothamBold
BoxSizeLess.TextSize = 12
BoxSizeLess.ZIndex = 34
BoxSizeLess.Parent = BoxSizeSection
Instance.new("UICorner", BoxSizeLess).CornerRadius = UDim.new(0, 4)

local BoxSizeMore = Instance.new("TextButton")
BoxSizeMore.Size = UDim2.new(0, 24, 0, 24)
BoxSizeMore.Position = UDim2.new(0.85, 0, 0.5, -12)
BoxSizeMore.BackgroundColor3 = SidebarColor
BoxSizeMore.Text = "+"
BoxSizeMore.TextColor3 = Color3.fromRGB(240, 240, 240)
BoxSizeMore.Font = Enum.Font.GothamBold
BoxSizeMore.TextSize = 12
BoxSizeMore.ZIndex = 34
BoxSizeMore.Parent = BoxSizeSection
Instance.new("UICorner", BoxSizeMore).CornerRadius = UDim.new(0, 4)

BoxSizeLess.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    ESP_Config.BoxSizeMultiplier = math.clamp(ESP_Config.BoxSizeMultiplier - 0.1, 0.5, 2.0)
    BoxSizeValLabel.Text = string.format("%.1fx", ESP_Config.BoxSizeMultiplier)
end)

BoxSizeMore.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    ESP_Config.BoxSizeMultiplier = math.clamp(ESP_Config.BoxSizeMultiplier + 0.1, 0.5, 2.0)
    BoxSizeValLabel.Text = string.format("%.1fx", ESP_Config.BoxSizeMultiplier)
end)

local BoxSaveBtn = Instance.new("TextButton")
BoxSaveBtn.Size = UDim2.new(0.9, 0, 0, 32)
BoxSaveBtn.BackgroundColor3 = AccentColor
BoxSaveBtn.Text = "Salvar Configurações"
BoxSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BoxSaveBtn.Font = Enum.Font.GothamBold
BoxSaveBtn.TextSize = 11
BoxSaveBtn.ZIndex = 33
BoxSaveBtn.Parent = BoxCustomBody
Instance.new("UICorner", BoxSaveBtn).CornerRadius = UDim.new(0, 6)

BoxSaveBtn.MouseButton1Click:Connect(function()
    playSound("12222076", 0.5)
    BoxSaveBtn.Text = "Configurações Salvas! ✔"
    BoxSaveBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 110)
    task.wait(1.5)
    BoxSaveBtn.Text = "Salvar Configurações"
    BoxSaveBtn.BackgroundColor3 = AccentColor
end)

-- ==========================================
-- SEÇÃO MÓVEL DA LINE
-- ==========================================
local LineCustomizerWindow = Instance.new("Frame")
LineCustomizerWindow.Name = "BK_LineCustomizer"
LineCustomizerWindow.Size = UDim2.new(0, 220, 0, 190)
LineCustomizerWindow.Position = UDim2.new(0.5, 10, 0.5, -210)
LineCustomizerWindow.BackgroundColor3 = MenuBGColor
LineCustomizerWindow.BorderSizePixel = 0
LineCustomizerWindow.Active = true
LineCustomizerWindow.Visible = false
LineCustomizerWindow.ZIndex = 30
LineCustomizerWindow.Parent = ScreenGui

Instance.new("UICorner", LineCustomizerWindow).CornerRadius = UDim.new(0, 8)
local LineCustomizerStroke = Instance.new("UIStroke", LineCustomizerWindow)
LineCustomizerStroke.Color = AccentColor
LineCustomizerStroke.Thickness = 1.2

local LineCustomHeader = Instance.new("Frame")
LineCustomHeader.Size = UDim2.new(1, 0, 0, 28)
LineCustomHeader.BackgroundColor3 = SidebarColor
LineCustomHeader.BorderSizePixel = 0
LineCustomHeader.ZIndex = 31
LineCustomHeader.Parent = LineCustomizerWindow
Instance.new("UICorner", LineCustomHeader).CornerRadius = UDim.new(0, 8)

local LineCustomTitle = Instance.new("TextLabel")
LineCustomTitle.Size = UDim2.new(1, -30, 1, 0)
LineCustomTitle.Position = UDim2.new(0, 10, 0, 0)
LineCustomTitle.BackgroundTransparency = 1
LineCustomTitle.Text = "Ajustes da Line"
LineCustomTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
LineCustomTitle.Font = Enum.Font.GothamBold
LineCustomTitle.TextSize = 11
LineCustomTitle.TextXAlignment = Enum.TextXAlignment.Left
LineCustomTitle.ZIndex = 32
LineCustomTitle.Parent = LineCustomHeader

local LineCustomClose = Instance.new("TextButton")
LineCustomClose.Size = UDim2.new(0, 24, 0, 24)
LineCustomClose.Position = UDim2.new(1, -26, 0.5, -12)
LineCustomClose.BackgroundTransparency = 1
LineCustomClose.Text = "×"
LineCustomClose.TextColor3 = Color3.fromRGB(150, 150, 155)
LineCustomClose.Font = Enum.Font.GothamBold
LineCustomClose.TextSize = 18
LineCustomClose.ZIndex = 32
LineCustomClose.Parent = LineCustomHeader

LineCustomClose.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    LineCustomizerWindow.Visible = false
end)

local lineDragging = false
local lineDragStart, lineStartPos

LineCustomHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lineDragging = true
        lineDragStart = input.Position
        lineStartPos = LineCustomizerWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if lineDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - lineDragStart
        LineCustomizerWindow.Position = UDim2.new(
            lineStartPos.X.Scale, 
            lineStartPos.X.Offset + delta.X, 
            lineStartPos.Y.Scale, 
            lineStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        lineDragging = false
    end
end)

local LineCustomBody = Instance.new("Frame")
LineCustomBody.Position = UDim2.new(0, 0, 0, 28)
LineCustomBody.Size = UDim2.new(1, 0, 1, -28)
LineCustomBody.BackgroundTransparency = 1
LineCustomBody.ZIndex = 31
LineCustomBody.Parent = LineCustomizerWindow

local LineBodyLayout = Instance.new("UIListLayout", LineCustomBody)
LineBodyLayout.Padding = UDim.new(0, 8)
LineBodyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", LineCustomBody).PaddingTop = UDim.new(0, 8)

local LineColorSection = Instance.new("Frame")
LineColorSection.Size = UDim2.new(0.9, 0, 0, 32)
LineColorSection.BackgroundTransparency = 1
LineColorSection.ZIndex = 32
LineColorSection.Parent = LineCustomBody

local LineColorLabel = Instance.new("TextLabel")
LineColorLabel.Size = UDim2.new(0.4, 0, 1, 0)
LineColorLabel.BackgroundTransparency = 1
LineColorLabel.Text = "Cor da Line:"
LineColorLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
LineColorLabel.Font = Enum.Font.GothamSemibold
LineColorLabel.TextSize = 10
LineColorLabel.TextXAlignment = Enum.TextXAlignment.Left
LineColorLabel.ZIndex = 33
LineColorLabel.Parent = LineColorSection

local LineColorBtnContainer = Instance.new("Frame")
LineColorBtnContainer.Size = UDim2.new(0.6, 0, 1, 0)
LineColorBtnContainer.Position = UDim2.new(0.4, 0, 0, 0)
LineColorBtnContainer.BackgroundTransparency = 1
LineColorBtnContainer.ZIndex = 33
LineColorBtnContainer.Parent = LineColorSection

local LineColorsList = {
    {Color = Color3.fromRGB(0, 255, 120), Text = "Verde"},
    {Color = Color3.fromRGB(110, 60, 220), Text = "Roxo"},
    {Color = Color3.fromRGB(255, 50, 50), Text = "Verm."}
}

for idx, colorData in ipairs(LineColorsList) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 35, 0, 22)
    cBtn.Position = UDim2.new(0, (idx - 1) * 40, 0.5, -11)
    cBtn.BackgroundColor3 = colorData.Color
    cBtn.BorderSizePixel = 0
    cBtn.Text = ""
    cBtn.ZIndex = 34
    cBtn.Parent = LineColorBtnContainer
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    
    local cBtnStroke = Instance.new("UIStroke", cBtn)
    cBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    cBtnStroke.Thickness = 1.2
    cBtnStroke.Transparency = (ESP_Config.LineColor == colorData.Color) and 0 or 1
    
    cBtn.MouseButton1Click:Connect(function()
        playSound("12222076", 0.35)
        ESP_Config.LineColor = colorData.Color
        for _, child in ipairs(LineColorBtnContainer:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChildOfClass("UIStroke") then
                child:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
        cBtnStroke.Transparency = 0
    end)
end

local LineThickSection = Instance.new("Frame")
LineThickSection.Size = UDim2.new(0.9, 0, 0, 32)
LineThickSection.BackgroundTransparency = 1
LineThickSection.ZIndex = 32
LineThickSection.Parent = LineCustomBody

local LineThickLabel = Instance.new("TextLabel")
LineThickLabel.Size = UDim2.new(0.4, 0, 1, 0)
LineThickLabel.BackgroundTransparency = 1
LineThickLabel.Text = "Espessura:"
LineThickLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
LineThickLabel.Font = Enum.Font.GothamSemibold
LineThickLabel.TextSize = 10
LineThickLabel.TextXAlignment = Enum.TextXAlignment.Left
LineThickLabel.ZIndex = 33
LineThickLabel.Parent = LineThickSection

local LineThickValLabel = Instance.new("TextLabel")
LineThickValLabel.Size = UDim2.new(0.2, 0, 1, 0)
LineThickValLabel.Position = UDim2.new(0.4, 0, 0, 0)
LineThickValLabel.BackgroundTransparency = 1
LineThickValLabel.Text = tostring(ESP_Config.LineThickness)
LineThickValLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
LineThickValLabel.Font = Enum.Font.GothamBold
LineThickValLabel.TextSize = 11
LineThickValLabel.ZIndex = 33
LineThickValLabel.Parent = LineThickSection

local LineThickLess = Instance.new("TextButton")
LineThickLess.Size = UDim2.new(0, 24, 0, 24)
LineThickLess.Position = UDim2.new(0.65, 0, 0.5, -12)
LineThickLess.BackgroundColor3 = SidebarColor
LineThickLess.Text = "-"
LineThickLess.TextColor3 = Color3.fromRGB(240, 240, 240)
LineThickLess.Font = Enum.Font.GothamBold
LineThickLess.TextSize = 12
LineThickLess.ZIndex = 34
LineThickLess.Parent = LineThickSection
Instance.new("UICorner", LineThickLess).CornerRadius = UDim.new(0, 4)

local LineThickMore = Instance.new("TextButton")
LineThickMore.Size = UDim2.new(0, 24, 0, 24)
LineThickMore.Position = UDim2.new(0.85, 0, 0.5, -12)
LineThickMore.BackgroundColor3 = SidebarColor
LineThickMore.Text = "+"
LineThickMore.TextColor3 = Color3.fromRGB(240, 240, 240)
LineThickMore.Font = Enum.Font.GothamBold
LineThickMore.TextSize = 12
LineThickMore.ZIndex = 34
LineThickMore.Parent = LineThickSection
Instance.new("UICorner", LineThickMore).CornerRadius = UDim.new(0, 4)

LineThickLess.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    ESP_Config.LineThickness = math.clamp(ESP_Config.LineThickness - 0.5, 1, 5)
    LineThickValLabel.Text = tostring(ESP_Config.LineThickness)
end)

LineThickMore.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    ESP_Config.LineThickness = math.clamp(ESP_Config.LineThickness + 0.5, 1, 5)
    LineThickValLabel.Text = tostring(ESP_Config.LineThickness)
end)

local OriginSection = Instance.new("Frame")
OriginSection.Size = UDim2.new(0.9, 0, 0, 32)
OriginSection.BackgroundTransparency = 1
OriginSection.ZIndex = 32
OriginSection.Parent = LineCustomBody

local OriginLabel = Instance.new("TextLabel")
OriginLabel.Size = UDim2.new(0.4, 0, 1, 0)
OriginLabel.BackgroundTransparency = 1
OriginLabel.Text = "Origem:"
OriginLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
OriginLabel.Font = Enum.Font.GothamSemibold
OriginLabel.TextSize = 10
OriginLabel.TextXAlignment = Enum.TextXAlignment.Left
OriginLabel.ZIndex = 33
OriginLabel.Parent = OriginSection

local OriginBtn = Instance.new("TextButton")
OriginBtn.Size = UDim2.new(0.5, 0, 0, 24)
OriginBtn.Position = UDim2.new(0.45, 0, 0.5, -12)
OriginBtn.BackgroundColor3 = SidebarColor
OriginBtn.Text = "De: " .. ESP_Config.LineOrigin
OriginBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
OriginBtn.Font = Enum.Font.GothamBold
OriginBtn.TextSize = 10
OriginBtn.ZIndex = 34
OriginBtn.Parent = OriginSection
Instance.new("UICorner", OriginBtn).CornerRadius = UDim.new(0, 4)

OriginBtn.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    if ESP_Config.LineOrigin == "Baixo" then
        ESP_Config.LineOrigin = "Cima"
    else
        ESP_Config.LineOrigin = "Baixo"
    end
    OriginBtn.Text = "De: " .. ESP_Config.LineOrigin
end)

local LineSaveBtn = Instance.new("TextButton")
LineSaveBtn.Size = UDim2.new(0.9, 0, 0, 32)
LineSaveBtn.BackgroundColor3 = AccentColor
LineSaveBtn.Text = "Salvar Configurações"
LineSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LineSaveBtn.Font = Enum.Font.GothamBold
LineSaveBtn.TextSize = 11
LineSaveBtn.ZIndex = 33
LineSaveBtn.Parent = LineCustomBody
Instance.new("UICorner", LineSaveBtn).CornerRadius = UDim.new(0, 6)

LineSaveBtn.MouseButton1Click:Connect(function()
    playSound("12222076", 0.5)
    LineSaveBtn.Text = "Configurações Salvas! ✔"
    LineSaveBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 110)
    task.wait(1.5)
    LineSaveBtn.Text = "Salvar Configurações"
    LineSaveBtn.BackgroundColor3 = AccentColor
end)

-- ==========================================
-- SEÇÃO MÓVEL DO NAME (ESTILO PC FLUTUANTE)
-- ==========================================
local NameCustomizerWindow = Instance.new("Frame")
NameCustomizerWindow.Name = "BK_NameCustomizer"
NameCustomizerWindow.Size = UDim2.new(0, 220, 0, 190)
NameCustomizerWindow.Position = UDim2.new(0.5, -230, 0.5, 10)
NameCustomizerWindow.BackgroundColor3 = MenuBGColor
NameCustomizerWindow.BorderSizePixel = 0
NameCustomizerWindow.Active = true
NameCustomizerWindow.Visible = false
NameCustomizerWindow.ZIndex = 30
NameCustomizerWindow.Parent = ScreenGui

Instance.new("UICorner", NameCustomizerWindow).CornerRadius = UDim.new(0, 8)
local NameCustomizerStroke = Instance.new("UIStroke", NameCustomizerWindow)
NameCustomizerStroke.Color = AccentColor
NameCustomizerStroke.Thickness = 1.2

local NameCustomHeader = Instance.new("Frame")
NameCustomHeader.Size = UDim2.new(1, 0, 0, 28)
NameCustomHeader.BackgroundColor3 = SidebarColor
NameCustomHeader.BorderSizePixel = 0
NameCustomHeader.ZIndex = 31
NameCustomHeader.Parent = NameCustomizerWindow
Instance.new("UICorner", NameCustomHeader).CornerRadius = UDim.new(0, 8)

local NameCustomTitle = Instance.new("TextLabel")
NameCustomTitle.Size = UDim2.new(1, -30, 1, 0)
NameCustomTitle.Position = UDim2.new(0, 10, 0, 0)
NameCustomTitle.BackgroundTransparency = 1
NameCustomTitle.Text = "Ajustes do Name"
NameCustomTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
NameCustomTitle.Font = Enum.Font.GothamBold
NameCustomTitle.TextSize = 11
NameCustomTitle.TextXAlignment = Enum.TextXAlignment.Left
NameCustomTitle.ZIndex = 32
NameCustomTitle.Parent = NameCustomHeader

local NameCustomClose = Instance.new("TextButton")
NameCustomClose.Size = UDim2.new(0, 24, 0, 24)
NameCustomClose.Position = UDim2.new(1, -26, 0.5, -12)
NameCustomClose.BackgroundTransparency = 1
NameCustomClose.Text = "×"
NameCustomClose.TextColor3 = Color3.fromRGB(150, 150, 155)
NameCustomClose.Font = Enum.Font.GothamBold
NameCustomClose.TextSize = 18
NameCustomClose.ZIndex = 32
NameCustomClose.Parent = NameCustomHeader

NameCustomClose.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    NameCustomizerWindow.Visible = false
end)

local nameDragging = false
local nameDragStart, nameStartPos

NameCustomHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        nameDragging = true
        nameDragStart = input.Position
        nameStartPos = NameCustomizerWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if nameDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - nameDragStart
        NameCustomizerWindow.Position = UDim2.new(
            nameStartPos.X.Scale, 
            nameStartPos.X.Offset + delta.X, 
            nameStartPos.Y.Scale, 
            nameStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        nameDragging = false
    end
end)

local NameCustomBody = Instance.new("Frame")
NameCustomBody.Position = UDim2.new(0, 0, 0, 28)
NameCustomBody.Size = UDim2.new(1, 0, 1, -28)
NameCustomBody.BackgroundTransparency = 1
NameCustomBody.ZIndex = 31
NameCustomBody.Parent = NameCustomizerWindow

local NameBodyLayout = Instance.new("UIListLayout", NameCustomBody)
NameBodyLayout.Padding = UDim.new(0, 8)
NameBodyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", NameCustomBody).PaddingTop = UDim.new(0, 8)

local NameColorSection = Instance.new("Frame")
NameColorSection.Size = UDim2.new(0.9, 0, 0, 32)
NameColorSection.BackgroundTransparency = 1
NameColorSection.ZIndex = 32
NameColorSection.Parent = NameCustomBody

local NameColorLabel = Instance.new("TextLabel")
NameColorLabel.Size = UDim2.new(0.4, 0, 1, 0)
NameColorLabel.BackgroundTransparency = 1
NameColorLabel.Text = "Cor do Name:"
NameColorLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
NameColorLabel.Font = Enum.Font.GothamSemibold
NameColorLabel.TextSize = 10
NameColorLabel.TextXAlignment = Enum.TextXAlignment.Left
NameColorLabel.ZIndex = 33
NameColorLabel.Parent = NameColorSection

local NameColorBtnContainer = Instance.new("Frame")
NameColorBtnContainer.Size = UDim2.new(0.6, 0, 1, 0)
NameColorBtnContainer.Position = UDim2.new(0.4, 0, 0, 0)
NameColorBtnContainer.BackgroundTransparency = 1
NameColorBtnContainer.ZIndex = 33
NameColorBtnContainer.Parent = NameColorSection

local NameColorsList = {
    {Color = Color3.fromRGB(255, 255, 255), Text = "Branco"},
    {Color = Color3.fromRGB(110, 60, 220), Text = "Roxo"},
    {Color = Color3.fromRGB(0, 255, 120), Text = "Verde"}
}

for idx, colorData in ipairs(NameColorsList) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 35, 0, 22)
    cBtn.Position = UDim2.new(0, (idx - 1) * 40, 0.5, -11)
    cBtn.BackgroundColor3 = colorData.Color
    cBtn.BorderSizePixel = 0
    cBtn.Text = ""
    cBtn.ZIndex = 34
    cBtn.Parent = NameColorBtnContainer
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    
    local cBtnStroke = Instance.new("UIStroke", cBtn)
    cBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    cBtnStroke.Thickness = 1.2
    cBtnStroke.Transparency = (ESP_Config.NameColor == colorData.Color and not ESP_Config.NameRainbow) and 0 or 1
    
    cBtn.MouseButton1Click:Connect(function()
        playSound("12222076", 0.35)
        ESP_Config.NameColor = colorData.Color
        ESP_Config.NameRainbow = false
        for _, child in ipairs(NameColorBtnContainer:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChildOfClass("UIStroke") then
                child:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
        cBtnStroke.Transparency = 0
    end)
end

local SizeSliderSection = Instance.new("Frame")
SizeSliderSection.Size = UDim2.new(0.9, 0, 0, 32)
SizeSliderSection.BackgroundTransparency = 1
SizeSliderSection.ZIndex = 32
SizeSliderSection.Parent = NameCustomBody

local SizeLabel = Instance.new("TextLabel")
SizeLabel.Size = UDim2.new(0.35, 0, 1, 0)
SizeLabel.BackgroundTransparency = 1
SizeLabel.Text = "Tamanho:"
SizeLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
SizeLabel.Font = Enum.Font.GothamSemibold
SizeLabel.TextSize = 10
SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SizeLabel.ZIndex = 33
SizeLabel.Parent = SizeSliderSection

local SizeValLabel = Instance.new("TextLabel")
SizeValLabel.Size = UDim2.new(0.15, 0, 1, 0)
SizeValLabel.Position = UDim2.new(0.35, 0, 0, 0)
SizeValLabel.BackgroundTransparency = 1
SizeValLabel.Text = tostring(ESP_Config.NameSize)
SizeValLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
SizeValLabel.Font = Enum.Font.GothamBold
SizeValLabel.TextSize = 11
SizeValLabel.ZIndex = 33
SizeValLabel.Parent = SizeSliderSection

local SizeSliderBG = Instance.new("TextButton")
SizeSliderBG.Size = UDim2.new(0.45, 0, 0, 6)
SizeSliderBG.Position = UDim2.new(0.52, 0, 0.5, -3)
SizeSliderBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SizeSliderBG.Text = ""
SizeSliderBG.BorderSizePixel = 0
SizeSliderBG.ZIndex = 33
SizeSliderBG.Parent = SizeSliderSection
Instance.new("UICorner", SizeSliderBG).CornerRadius = UDim.new(1, 0)

local SizeSliderFill = Instance.new("Frame")
SizeSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SizeSliderFill.BackgroundColor3 = AccentColor
SizeSliderFill.BorderSizePixel = 0
SizeSliderFill.ZIndex = 34
SizeSliderFill.Parent = SizeSliderBG
Instance.new("UICorner", SizeSliderFill).CornerRadius = UDim.new(1, 0)

local SizeSliderPin = Instance.new("Frame")
SizeSliderPin.Size = UDim2.new(0, 12, 0, 12)
SizeSliderPin.Position = UDim2.new(0.5, -6, 0.5, -6)
SizeSliderPin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SizeSliderPin.BorderSizePixel = 0
SizeSliderPin.ZIndex = 35
SizeSliderPin.Parent = SizeSliderBG
Instance.new("UICorner", SizeSliderPin).CornerRadius = UDim.new(1, 0)

local function updateSizeSlider(input)
    local percentage = math.clamp((input.Position.X - SizeSliderBG.AbsolutePosition.X) / SizeSliderBG.AbsoluteSize.X, 0, 1)
    SizeSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    SizeSliderPin.Position = UDim2.new(percentage, -6, 0.5, -6)
    
    local calculated = math.floor(8 + (percentage * 10)) -- 8 a 18
    ESP_Config.NameSize = calculated
    SizeValLabel.Text = tostring(calculated)
end

local sizeSliding = false
SizeSliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sizeSliding = true
        updateSizeSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sizeSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSizeSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sizeSliding = false
    end
end)

local RainbowSection = Instance.new("Frame")
RainbowSection.Size = UDim2.new(0.9, 0, 0, 32)
RainbowSection.BackgroundTransparency = 1
RainbowSection.ZIndex = 32
RainbowSection.Parent = NameCustomBody

local RainbowLabel = Instance.new("TextLabel")
RainbowLabel.Size = UDim2.new(0.5, 0, 1, 0)
RainbowLabel.BackgroundTransparency = 1
RainbowLabel.Text = "Efeito RGB:"
RainbowLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
RainbowLabel.Font = Enum.Font.GothamSemibold
RainbowLabel.TextSize = 10
RainbowLabel.TextXAlignment = Enum.TextXAlignment.Left
RainbowLabel.ZIndex = 33
RainbowLabel.Parent = RainbowSection

local RainbowToggleBG = Instance.new("TextButton")
RainbowToggleBG.Size = UDim2.new(0, 36, 0, 18)
RainbowToggleBG.Position = UDim2.new(1, -40, 0.5, -9)
RainbowToggleBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
RainbowToggleBG.Text = ""
RainbowToggleBG.ZIndex = 33
RainbowToggleBG.Parent = RainbowSection
Instance.new("UICorner", RainbowToggleBG).CornerRadius = UDim.new(1, 0)

local RainbowToggleIndicator = Instance.new("Frame")
RainbowToggleIndicator.Size = UDim2.new(0, 12, 0, 12)
RainbowToggleIndicator.Position = UDim2.new(0, 3, 0.5, -6)
RainbowToggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
RainbowToggleIndicator.BorderSizePixel = 0
RainbowToggleIndicator.ZIndex = 34
RainbowToggleIndicator.Parent = RainbowToggleBG
Instance.new("UICorner", RainbowToggleIndicator).CornerRadius = UDim.new(1, 0)

RainbowToggleBG.MouseButton1Click:Connect(function()
    ESP_Config.NameRainbow = not ESP_Config.NameRainbow
    playSound("12222076", 0.3)
    if ESP_Config.NameRainbow then
        TweenService:Create(RainbowToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
        TweenService:Create(RainbowToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -15, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        for _, child in ipairs(NameColorBtnContainer:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChildOfClass("UIStroke") then
                child:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
    else
        TweenService:Create(RainbowToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
        TweenService:Create(RainbowToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = Color3.fromRGB(150, 150, 155)}):Play()
    end
end)

local NameSaveBtn = Instance.new("TextButton")
NameSaveBtn.Size = UDim2.new(0.9, 0, 0, 32)
NameSaveBtn.BackgroundColor3 = AccentColor
NameSaveBtn.Text = "Salvar Configurações"
NameSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NameSaveBtn.Font = Enum.Font.GothamBold
NameSaveBtn.TextSize = 11
NameSaveBtn.ZIndex = 33
NameSaveBtn.Parent = NameCustomBody
Instance.new("UICorner", NameSaveBtn).CornerRadius = UDim.new(0, 6)

NameSaveBtn.MouseButton1Click:Connect(function()
    playSound("12222076", 0.5)
    NameSaveBtn.Text = "Configurações Salvas! ✔"
    NameSaveBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 110)
    task.wait(1.5)
    NameSaveBtn.Text = "Salvar Configurações"
    NameSaveBtn.BackgroundColor3 = AccentColor
end)

-- ==========================================
-- SEÇÃO MÓVEL DA DISTÂNCIA (ESTILO PC FLUTUANTE)
-- ==========================================
local DistCustomizerWindow = Instance.new("Frame")
DistCustomizerWindow.Name = "BK_DistCustomizer"
DistCustomizerWindow.Size = UDim2.new(0, 220, 0, 190)
DistCustomizerWindow.Position = UDim2.new(0.5, 10, 0.5, 10)
DistCustomizerWindow.BackgroundColor3 = MenuBGColor
DistCustomizerWindow.BorderSizePixel = 0
DistCustomizerWindow.Active = true
DistCustomizerWindow.Visible = false
DistCustomizerWindow.ZIndex = 30
DistCustomizerWindow.Parent = ScreenGui

Instance.new("UICorner", DistCustomizerWindow).CornerRadius = UDim.new(0, 8)
local DistCustomizerStroke = Instance.new("UIStroke", DistCustomizerWindow)
DistCustomizerStroke.Color = AccentColor
DistCustomizerStroke.Thickness = 1.2

local DistCustomHeader = Instance.new("Frame")
DistCustomHeader.Size = UDim2.new(1, 0, 0, 28)
DistCustomHeader.BackgroundColor3 = SidebarColor
DistCustomHeader.BorderSizePixel = 0
DistCustomHeader.ZIndex = 31
DistCustomHeader.Parent = DistCustomizerWindow
Instance.new("UICorner", DistCustomHeader).CornerRadius = UDim.new(0, 8)

local DistCustomTitle = Instance.new("TextLabel")
DistCustomTitle.Size = UDim2.new(1, -30, 1, 0)
DistCustomTitle.Position = UDim2.new(0, 10, 0, 0)
DistCustomTitle.BackgroundTransparency = 1
DistCustomTitle.Text = "Ajustes de Distância"
DistCustomTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
DistCustomTitle.Font = Enum.Font.GothamBold
DistCustomTitle.TextSize = 11
DistCustomTitle.TextXAlignment = Enum.TextXAlignment.Left
DistCustomTitle.ZIndex = 32
DistCustomTitle.Parent = DistCustomHeader

local DistCustomClose = Instance.new("TextButton")
DistCustomClose.Size = UDim2.new(0, 24, 0, 24)
DistCustomClose.Position = UDim2.new(1, -26, 0.5, -12)
DistCustomClose.BackgroundTransparency = 1
DistCustomClose.Text = "×"
DistCustomClose.TextColor3 = Color3.fromRGB(150, 150, 155)
DistCustomClose.Font = Enum.Font.GothamBold
DistCustomClose.TextSize = 18
DistCustomClose.ZIndex = 32
DistCustomClose.Parent = DistCustomHeader

DistCustomClose.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    DistCustomizerWindow.Visible = false
end)

local distDragging = false
local distDragStart, distStartPos

DistCustomHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        distDragging = true
        distDragStart = input.Position
        distStartPos = DistCustomizerWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if distDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - distDragStart
        DistCustomizerWindow.Position = UDim2.new(
            distStartPos.X.Scale, 
            distStartPos.X.Offset + delta.X, 
            distStartPos.Y.Scale, 
            distStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        distDragging = false
    end
end)

local DistCustomBody = Instance.new("Frame")
DistCustomBody.Position = UDim2.new(0, 0, 0, 28)
DistCustomBody.Size = UDim2.new(1, 0, 1, -28)
DistCustomBody.BackgroundTransparency = 1
DistCustomBody.ZIndex = 31
DistCustomBody.Parent = DistCustomizerWindow

local DistBodyLayout = Instance.new("UIListLayout", DistCustomBody)
DistBodyLayout.Padding = UDim.new(0, 8)
DistBodyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", DistCustomBody).PaddingTop = UDim.new(0, 8)

local DistColorSection = Instance.new("Frame")
DistColorSection.Size = UDim2.new(0.9, 0, 0, 32)
DistColorSection.BackgroundTransparency = 1
DistColorSection.ZIndex = 32
DistColorSection.Parent = DistCustomBody

local DistColorLabel = Instance.new("TextLabel")
DistColorLabel.Size = UDim2.new(0.4, 0, 1, 0)
DistColorLabel.BackgroundTransparency = 1
DistColorLabel.Text = "Cor do ESP:"
DistColorLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
DistColorLabel.Font = Enum.Font.GothamSemibold
DistColorLabel.TextSize = 10
DistColorLabel.TextXAlignment = Enum.TextXAlignment.Left
DistColorLabel.ZIndex = 33
DistColorLabel.Parent = DistColorSection

local DistColorBtnContainer = Instance.new("Frame")
DistColorBtnContainer.Size = UDim2.new(0.6, 0, 1, 0)
DistColorBtnContainer.Position = UDim2.new(0.4, 0, 0, 0)
DistColorBtnContainer.BackgroundTransparency = 1
DistColorBtnContainer.ZIndex = 33
DistColorBtnContainer.Parent = DistColorSection

local DistColorsList = {
    {Color = Color3.fromRGB(200, 200, 200), Text = "Cinza"},
    {Color = Color3.fromRGB(255, 230, 0), Text = "Amarelo"},
    {Color = Color3.fromRGB(0, 200, 255), Text = "Azul"}
}

for idx, colorData in ipairs(DistColorsList) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 35, 0, 22)
    cBtn.Position = UDim2.new(0, (idx - 1) * 40, 0.5, -11)
    cBtn.BackgroundColor3 = colorData.Color
    cBtn.BorderSizePixel = 0
    cBtn.Text = ""
    cBtn.ZIndex = 34
    cBtn.Parent = DistColorBtnContainer
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    
    local cBtnStroke = Instance.new("UIStroke", cBtn)
    cBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    cBtnStroke.Thickness = 1.2
    cBtnStroke.Transparency = (ESP_Config.DistColor == colorData.Color) and 0 or 1
    
    cBtn.MouseButton1Click:Connect(function()
        playSound("12222076", 0.35)
        ESP_Config.DistColor = colorData.Color
        for _, child in ipairs(DistColorBtnContainer:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChildOfClass("UIStroke") then
                child:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
        cBtnStroke.Transparency = 0
    end)
end

local MaxDistSection = Instance.new("Frame")
MaxDistSection.Size = UDim2.new(0.9, 0, 0, 32)
MaxDistSection.BackgroundTransparency = 1
MaxDistSection.ZIndex = 32
MaxDistSection.Parent = DistCustomBody

local MaxDistLabel = Instance.new("TextLabel")
MaxDistLabel.Size = UDim2.new(0.35, 0, 1, 0)
MaxDistLabel.BackgroundTransparency = 1
MaxDistLabel.Text = "Dist. Máx:"
MaxDistLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
MaxDistLabel.Font = Enum.Font.GothamSemibold
MaxDistLabel.TextSize = 10
MaxDistLabel.TextXAlignment = Enum.TextXAlignment.Left
MaxDistLabel.ZIndex = 33
MaxDistLabel.Parent = MaxDistSection

local MaxDistValLabel = Instance.new("TextLabel")
MaxDistValLabel.Size = UDim2.new(0.2, 0, 1, 0)
MaxDistValLabel.Position = UDim2.new(0.35, 0, 0, 0)
MaxDistValLabel.BackgroundTransparency = 1
MaxDistValLabel.Text = tostring(ESP_Config.MaxDistance) .. "m"
MaxDistValLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
MaxDistValLabel.Font = Enum.Font.GothamBold
MaxDistValLabel.TextSize = 11
MaxDistValLabel.ZIndex = 33
MaxDistValLabel.Parent = MaxDistSection

local MaxDistSliderBG = Instance.new("TextButton")
MaxDistSliderBG.Size = UDim2.new(0.4, 0, 0, 6)
MaxDistSliderBG.Position = UDim2.new(0.55, 0, 0.5, -3)
MaxDistSliderBG.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MaxDistSliderBG.Text = ""
MaxDistSliderBG.BorderSizePixel = 0
MaxDistSliderBG.ZIndex = 33
MaxDistSliderBG.Parent = MaxDistSection
Instance.new("UICorner", MaxDistSliderBG).CornerRadius = UDim.new(1, 0)

local MaxDistSliderFill = Instance.new("Frame")
MaxDistSliderFill.Size = UDim2.new(1.0, 0, 1, 0) -- Padrão 350m (Maximo)
MaxDistSliderFill.BackgroundColor3 = AccentColor
MaxDistSliderFill.BorderSizePixel = 0
MaxDistSliderFill.ZIndex = 34
MaxDistSliderFill.Parent = MaxDistSliderBG
Instance.new("UICorner", MaxDistSliderFill).CornerRadius = UDim.new(1, 0)

local MaxDistSliderPin = Instance.new("Frame")
MaxDistSliderPin.Size = UDim2.new(0, 12, 0, 12)
MaxDistSliderPin.Position = UDim2.new(1.0, -6, 0.5, -6)
MaxDistSliderPin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MaxDistSliderPin.BorderSizePixel = 0
MaxDistSliderPin.ZIndex = 35
MaxDistSliderPin.Parent = MaxDistSliderBG
Instance.new("UICorner", MaxDistSliderPin).CornerRadius = UDim.new(1, 0)

local function updateMaxDistSlider(input)
    local percentage = math.clamp((input.Position.X - MaxDistSliderBG.AbsolutePosition.X) / MaxDistSliderBG.AbsoluteSize.X, 0, 1)
    MaxDistSliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    MaxDistSliderPin.Position = UDim2.new(percentage, -6, 0.5, -6)
    
    local calculated = math.floor(50 + (percentage * 300)) -- 50m a 350m
    ESP_Config.MaxDistance = calculated
    MaxDistValLabel.Text = tostring(calculated) .. "m"
end

local distSliding = false
MaxDistSliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        distSliding = true
        updateMaxDistSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if distSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateMaxDistSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        distSliding = false
    end
end)

local DistSaveBtn = Instance.new("TextButton")
DistSaveBtn.Size = UDim2.new(0.9, 0, 0, 32)
DistSaveBtn.BackgroundColor3 = AccentColor
DistSaveBtn.Text = "Salvar Configurações"
DistSaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DistSaveBtn.Font = Enum.Font.GothamBold
DistSaveBtn.TextSize = 11
DistSaveBtn.ZIndex = 33
DistSaveBtn.Parent = DistCustomBody
Instance.new("UICorner", DistSaveBtn).CornerRadius = UDim.new(0, 6)

DistSaveBtn.MouseButton1Click:Connect(function()
    playSound("12222076", 0.5)
    DistSaveBtn.Text = "Configurações Salvas! ✔"
    DistSaveBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 110)
    task.wait(1.5)
    DistSaveBtn.Text = "Salvar Configurações"
    DistSaveBtn.BackgroundColor3 = AccentColor
end)

-- ==========================================
-- CONTEÚDO DA ABA [VISUAL] - ESP CONTROL
-- ==========================================
local VisualPage = Pages["Visual"]

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, 0, 1, 0)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.BorderSizePixel = 0
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 270)
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.ScrollBarImageColor3 = AccentColor
ScrollContainer.ZIndex = 8
ScrollContainer.Parent = VisualPage

local VisualLayout = Instance.new("UIListLayout", ScrollContainer)
VisualLayout.Padding = UDim.new(0, 10)
VisualLayout.SortOrder = Enum.SortOrder.LayoutOrder
Instance.new("UIPadding", ScrollContainer).PaddingRight = UDim.new(0, 10)

-- CONTAINER BOX
local BoxFrame = Instance.new("Frame")
BoxFrame.Size = UDim2.new(1, 0, 0, 52)
BoxFrame.BackgroundColor3 = SidebarColor
BoxFrame.ZIndex = 8
BoxFrame.Parent = ScrollContainer
Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 8)
local BoxFrameStroke = Instance.new("UIStroke", BoxFrame)
BoxFrameStroke.Color = Color3.fromRGB(35, 35, 40)
BoxFrameStroke.Thickness = 1.2

local BoxTitle = Instance.new("TextLabel")
BoxTitle.Position = UDim2.new(0, 15, 0, 8)
BoxTitle.Size = UDim2.new(0, 150, 0, 20)
BoxTitle.BackgroundTransparency = 1
BoxTitle.Text = "ESP Box"
BoxTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
BoxTitle.Font = Enum.Font.GothamBold
BoxTitle.TextSize = 12
BoxTitle.TextXAlignment = Enum.TextXAlignment.Left
BoxTitle.ZIndex = 9
BoxTitle.Parent = BoxFrame

local BoxDesc = Instance.new("TextLabel")
BoxDesc.Position = UDim2.new(0, 15, 0, 26)
BoxDesc.Size = UDim2.new(0, 180, 0, 20)
BoxDesc.BackgroundTransparency = 1
BoxDesc.Text = "Desenha bordas ao redor do inimigo"
BoxDesc.TextColor3 = Color3.fromRGB(130, 130, 135)
BoxDesc.Font = Enum.Font.GothamSemibold
BoxDesc.TextSize = 9
BoxDesc.TextXAlignment = Enum.TextXAlignment.Left
BoxDesc.ZIndex = 9
BoxDesc.Parent = BoxFrame

local BoxToggleBG = Instance.new("TextButton")
BoxToggleBG.Size = UDim2.new(0, 44, 0, 22)
BoxToggleBG.Position = UDim2.new(1, -115, 0.5, -11)
BoxToggleBG.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
BoxToggleBG.Text = ""
BoxToggleBG.ZIndex = 9
BoxToggleBG.Parent = BoxFrame
Instance.new("UICorner", BoxToggleBG).CornerRadius = UDim.new(1, 0)

local BoxToggleIndicator = Instance.new("Frame")
BoxToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
BoxToggleIndicator.Position = UDim2.new(0, 3, 0.5, -8)
BoxToggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
BoxToggleIndicator.BorderSizePixel = 0
BoxToggleIndicator.ZIndex = 10
BoxToggleIndicator.Parent = BoxToggleBG
Instance.new("UICorner", BoxToggleIndicator).CornerRadius = UDim.new(1, 0)

local BoxConfigTrigger = Instance.new("TextButton")
BoxConfigTrigger.Size = UDim2.new(0, 30, 0, 30)
BoxConfigTrigger.Position = UDim2.new(1, -50, 0.5, -15)
BoxConfigTrigger.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
BoxConfigTrigger.Text = "|||"
BoxConfigTrigger.Rotation = 90
BoxConfigTrigger.TextColor3 = Color3.fromRGB(200, 200, 205)
BoxConfigTrigger.Font = Enum.Font.GothamBold
BoxConfigTrigger.TextSize = 10
BoxConfigTrigger.ZIndex = 9
BoxConfigTrigger.Parent = BoxFrame
Instance.new("UICorner", BoxConfigTrigger).CornerRadius = UDim.new(0, 6)

local BoxConfigTriggerStroke = Instance.new("UIStroke", BoxConfigTrigger)
BoxConfigTriggerStroke.Color = Color3.fromRGB(50, 50, 55)
BoxConfigTriggerStroke.Thickness = 1

BoxConfigTrigger.MouseButton1Click:Connect(function()
    playSound("12222076", 0.4)
    BoxCustomizerWindow.Visible = not BoxCustomizerWindow.Visible
end)

BoxToggleBG.MouseButton1Click:Connect(function()
    ESP_Config.BoxEnabled = not ESP_Config.BoxEnabled
    playSound("12222076", 0.4)
    
    if ESP_Config.BoxEnabled then
        TweenService:Create(BoxToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
        TweenService:Create(BoxToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(BoxToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(BoxToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 155)}):Play()
        for player, drawObj in pairs(ActiveBoxes) do
            if drawObj.Box then drawObj.Box:Remove() end
            ActiveBoxes[player] = nil
        end
    end
end)

-- CONTAINER LINE
local LineFrame = Instance.new("Frame")
LineFrame.Size = UDim2.new(1, 0, 0, 52)
LineFrame.BackgroundColor3 = SidebarColor
LineFrame.ZIndex = 8
LineFrame.Parent = ScrollContainer
Instance.new("UICorner", LineFrame).CornerRadius = UDim.new(0, 8)
local LineFrameStroke = Instance.new("UIStroke", LineFrame)
LineFrameStroke.Color = Color3.fromRGB(35, 35, 40)
LineFrameStroke.Thickness = 1.2

local LineTitle = Instance.new("TextLabel")
LineTitle.Position = UDim2.new(0, 15, 0, 8)
LineTitle.Size = UDim2.new(0, 150, 0, 20)
LineTitle.BackgroundTransparency = 1
LineTitle.Text = "ESP Line"
LineTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
LineTitle.Font = Enum.Font.GothamBold
LineTitle.TextSize = 12
LineTitle.TextXAlignment = Enum.TextXAlignment.Left
LineTitle.ZIndex = 9
LineTitle.Parent = LineFrame

local LineDesc = Instance.new("TextLabel")
LineDesc.Position = UDim2.new(0, 15, 0, 26)
LineDesc.Size = UDim2.new(0, 180, 0, 20)
LineDesc.BackgroundTransparency = 1
LineDesc.Text = "Liga uma linha guia até o inimigo"
LineDesc.TextColor3 = Color3.fromRGB(130, 130, 135)
LineDesc.Font = Enum.Font.GothamSemibold
LineDesc.TextSize = 9
LineDesc.TextXAlignment = Enum.TextXAlignment.Left
LineDesc.ZIndex = 9
LineDesc.Parent = LineFrame

local LineToggleBG = Instance.new("TextButton")
LineToggleBG.Size = UDim2.new(0, 44, 0, 22)
LineToggleBG.Position = UDim2.new(1, -115, 0.5, -11)
LineToggleBG.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
LineToggleBG.Text = ""
LineToggleBG.ZIndex = 9
LineToggleBG.Parent = LineFrame
Instance.new("UICorner", LineToggleBG).CornerRadius = UDim.new(1, 0)

local LineToggleIndicator = Instance.new("Frame")
LineToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
LineToggleIndicator.Position = UDim2.new(0, 3, 0.5, -8)
LineToggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
LineToggleIndicator.BorderSizePixel = 0
LineToggleIndicator.ZIndex = 10
LineToggleIndicator.Parent = LineToggleBG
Instance.new("UICorner", LineToggleIndicator).CornerRadius = UDim.new(1, 0)

local LineConfigTrigger = Instance.new("TextButton")
LineConfigTrigger.Size = UDim2.new(0, 30, 0, 30)
LineConfigTrigger.Position = UDim2.new(1, -50, 0.5, -15)
LineConfigTrigger.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LineConfigTrigger.Text = "|||"
LineConfigTrigger.Rotation = 90
LineConfigTrigger.TextColor3 = Color3.fromRGB(200, 200, 205)
LineConfigTrigger.Font = Enum.Font.GothamBold
LineConfigTrigger.TextSize = 10
LineConfigTrigger.ZIndex = 9
LineConfigTrigger.Parent = LineFrame
Instance.new("UICorner", LineConfigTrigger).CornerRadius = UDim.new(0, 6)

local LineConfigTriggerStroke = Instance.new("UIStroke", LineConfigTrigger)
LineConfigTriggerStroke.Color = Color3.fromRGB(50, 50, 55)
LineConfigTriggerStroke.Thickness = 1

LineConfigTrigger.MouseButton1Click:Connect(function()
    playSound("12222076", 0.4)
    LineCustomizerWindow.Visible = not LineCustomizerWindow.Visible
end)

LineToggleBG.MouseButton1Click:Connect(function()
    ESP_Config.LineEnabled = not ESP_Config.LineEnabled
    playSound("12222076", 0.4)
    
    if ESP_Config.LineEnabled then
        TweenService:Create(LineToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
        TweenService:Create(LineToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(LineToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(LineToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 155)}):Play()
        for player, drawObj in pairs(ActiveLines) do
            if drawObj.Line then drawObj.Line:Remove() end
            ActiveLines[player] = nil
        end
    end
end)

-- CONTAINER ESP NAME
local NameFrame = Instance.new("Frame")
NameFrame.Size = UDim2.new(1, 0, 0, 52)
NameFrame.BackgroundColor3 = SidebarColor
NameFrame.ZIndex = 8
NameFrame.Parent = ScrollContainer
Instance.new("UICorner", NameFrame).CornerRadius = UDim.new(0, 8)
local NameFrameStroke = Instance.new("UIStroke", NameFrame)
NameFrameStroke.Color = Color3.fromRGB(35, 35, 40)
NameFrameStroke.Thickness = 1.2

local NameTitle = Instance.new("TextLabel")
NameTitle.Position = UDim2.new(0, 15, 0, 8)
NameTitle.Size = UDim2.new(0, 150, 0, 20)
NameTitle.BackgroundTransparency = 1
NameTitle.Text = "ESP Name"
NameTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
NameTitle.Font = Enum.Font.GothamBold
NameTitle.TextSize = 12
NameTitle.TextXAlignment = Enum.TextXAlignment.Left
NameTitle.ZIndex = 9
NameTitle.Parent = NameFrame

local NameDesc = Instance.new("TextLabel")
NameDesc.Position = UDim2.new(0, 15, 0, 26)
NameDesc.Size = UDim2.new(0, 180, 0, 20)
NameDesc.BackgroundTransparency = 1
NameDesc.Text = "Mostra o nome limpo do alvo"
NameDesc.TextColor3 = Color3.fromRGB(130, 130, 135)
NameDesc.Font = Enum.Font.GothamSemibold
NameDesc.TextSize = 9
NameDesc.TextXAlignment = Enum.TextXAlignment.Left
NameDesc.ZIndex = 9
NameDesc.Parent = NameFrame

local NameToggleBG = Instance.new("TextButton")
NameToggleBG.Size = UDim2.new(0, 44, 0, 22)
NameToggleBG.Position = UDim2.new(1, -115, 0.5, -11)
NameToggleBG.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
NameToggleBG.Text = ""
NameToggleBG.ZIndex = 9
NameToggleBG.Parent = NameFrame
Instance.new("UICorner", NameToggleBG).CornerRadius = UDim.new(1, 0)

local NameToggleIndicator = Instance.new("Frame")
NameToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
NameToggleIndicator.Position = UDim2.new(0, 3, 0.5, -8)
NameToggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
NameToggleIndicator.BorderSizePixel = 0
NameToggleIndicator.ZIndex = 10
NameToggleIndicator.Parent = NameToggleBG
Instance.new("UICorner", NameToggleIndicator).CornerRadius = UDim.new(1, 0)

local NameConfigTrigger = Instance.new("TextButton")
NameConfigTrigger.Size = UDim2.new(0, 30, 0, 30)
NameConfigTrigger.Position = UDim2.new(1, -50, 0.5, -15)
NameConfigTrigger.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
NameConfigTrigger.Text = "|||"
NameConfigTrigger.Rotation = 90
NameConfigTrigger.TextColor3 = Color3.fromRGB(200, 200, 205)
NameConfigTrigger.Font = Enum.Font.GothamBold
NameConfigTrigger.TextSize = 10
NameConfigTrigger.ZIndex = 9
NameConfigTrigger.Parent = NameFrame
Instance.new("UICorner", NameConfigTrigger).CornerRadius = UDim.new(0, 6)

local NameConfigTriggerStroke = Instance.new("UIStroke", NameConfigTrigger)
NameConfigTriggerStroke.Color = Color3.fromRGB(50, 50, 55)
NameConfigTriggerStroke.Thickness = 1

NameConfigTrigger.MouseButton1Click:Connect(function()
    playSound("12222076", 0.4)
    NameCustomizerWindow.Visible = not NameCustomizerWindow.Visible
end)

NameToggleBG.MouseButton1Click:Connect(function()
    ESP_Config.NameEnabled = not ESP_Config.NameEnabled
    playSound("12222076", 0.4)
    
    if ESP_Config.NameEnabled then
        TweenService:Create(NameToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
        TweenService:Create(NameToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(NameToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(NameToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 155)}):Play()
        for player, drawObj in pairs(ActiveNames) do
            if drawObj.Text then drawObj.Text:Remove() end
            ActiveNames[player] = nil
        end
    end
end)

-- CONTAINER ESP DISTANCE
local DistFrame = Instance.new("Frame")
DistFrame.Size = UDim2.new(1, 0, 0, 52)
DistFrame.BackgroundColor3 = SidebarColor
DistFrame.ZIndex = 8
DistFrame.Parent = ScrollContainer
Instance.new("UICorner", DistFrame).CornerRadius = UDim.new(0, 8)
local DistFrameStroke = Instance.new("UIStroke", DistFrame)
DistFrameStroke.Color = Color3.fromRGB(35, 35, 40)
DistFrameStroke.Thickness = 1.2

local DistTitle = Instance.new("TextLabel")
DistTitle.Position = UDim2.new(0, 15, 0, 8)
DistTitle.Size = UDim2.new(0, 150, 0, 20)
DistTitle.BackgroundTransparency = 1
DistTitle.Text = "ESP Distância"
DistTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
DistTitle.Font = Enum.Font.GothamBold
DistTitle.TextSize = 12
DistTitle.TextXAlignment = Enum.TextXAlignment.Left
DistTitle.ZIndex = 9
DistTitle.Parent = DistFrame

local DistDesc = Instance.new("TextLabel")
DistDesc.Position = UDim2.new(0, 15, 0, 26)
DistDesc.Size = UDim2.new(0, 180, 0, 20)
DistDesc.BackgroundTransparency = 1
DistDesc.Text = "Mostra distância com limite ajustável"
DistDesc.TextColor3 = Color3.fromRGB(130, 130, 135)
DistDesc.Font = Enum.Font.GothamSemibold
DistDesc.TextSize = 9
DistDesc.TextXAlignment = Enum.TextXAlignment.Left
DistDesc.ZIndex = 9
DistDesc.Parent = DistFrame

local DistToggleBG = Instance.new("TextButton")
DistToggleBG.Size = UDim2.new(0, 44, 0, 22)
DistToggleBG.Position = UDim2.new(1, -115, 0.5, -11)
DistToggleBG.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
DistToggleBG.Text = ""
DistToggleBG.ZIndex = 9
DistToggleBG.Parent = DistFrame
Instance.new("UICorner", DistToggleBG).CornerRadius = UDim.new(1, 0)

local DistToggleIndicator = Instance.new("Frame")
DistToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
DistToggleIndicator.Position = UDim2.new(0, 3, 0.5, -8)
DistToggleIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
DistToggleIndicator.BorderSizePixel = 0
DistToggleIndicator.ZIndex = 10
DistToggleIndicator.Parent = DistToggleBG
Instance.new("UICorner", DistToggleIndicator).CornerRadius = UDim.new(1, 0)

local DistConfigTrigger = Instance.new("TextButton")
DistConfigTrigger.Size = UDim2.new(0, 30, 0, 30)
DistConfigTrigger.Position = UDim2.new(1, -50, 0.5, -15)
DistConfigTrigger.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
DistConfigTrigger.Text = "|||"
DistConfigTrigger.Rotation = 90
DistConfigTrigger.TextColor3 = Color3.fromRGB(200, 200, 205)
DistConfigTrigger.Font = Enum.Font.GothamBold
DistConfigTrigger.TextSize = 10
DistConfigTrigger.ZIndex = 9
DistConfigTrigger.Parent = DistFrame
Instance.new("UICorner", DistConfigTrigger).CornerRadius = UDim.new(0, 6)

local DistConfigTriggerStroke = Instance.new("UIStroke", DistConfigTrigger)
DistConfigTriggerStroke.Color = Color3.fromRGB(50, 50, 55)
DistConfigTriggerStroke.Thickness = 1

DistConfigTrigger.MouseButton1Click:Connect(function()
    playSound("12222076", 0.4)
    DistCustomizerWindow.Visible = not DistCustomizerWindow.Visible
end)

DistToggleBG.MouseButton1Click:Connect(function()
    ESP_Config.DistEnabled = not ESP_Config.DistEnabled
    playSound("12222076", 0.4)
    
    if ESP_Config.DistEnabled then
        TweenService:Create(DistToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor}):Play()
        TweenService:Create(DistToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        TweenService:Create(DistToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
        TweenService:Create(DistToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 155)}):Play()
        for player, drawObj in pairs(ActiveDists) do
            if drawObj.Text then drawObj.Text:Remove() end
            ActiveDists[player] = nil
        end
    end
end)

-- ==========================================
-- DESIGN DA ABA [STATUS] - STATUS REAIS
-- ==========================================
local StatusPage = Pages["Status"]

local StatusLayout = Instance.new("UIListLayout", StatusPage)
StatusLayout.Padding = UDim.new(0, 12)
StatusLayout.SortOrder = Enum.SortOrder.LayoutOrder

local CardPlayers = Instance.new("Frame")
CardPlayers.Size = UDim2.new(1, -10, 0, 65)
CardPlayers.BackgroundColor3 = SidebarColor
CardPlayers.ZIndex = 8
CardPlayers.Parent = StatusPage
Instance.new("UICorner", CardPlayers).CornerRadius = UDim.new(0, 8)
local StrokeCP = Instance.new("UIStroke", CardPlayers)
StrokeCP.Color = Color3.fromRGB(35, 35, 40)
StrokeCP.Thickness = 1.2

local IconCP = Instance.new("TextLabel")
IconCP.Size = UDim2.new(0, 50, 1, 0)
IconCP.BackgroundTransparency = 1
IconCP.Text = "👤"
IconCP.TextSize = 22
IconCP.ZIndex = 9
IconCP.Parent = CardPlayers

local LabelCP = Instance.new("TextLabel")
LabelCP.Position = UDim2.new(0, 55, 0, 12)
LabelCP.Size = UDim2.new(1, -65, 0, 20)
LabelCP.BackgroundTransparency = 1
LabelCP.Text = "Jogadores usando o BK"
LabelCP.TextColor3 = Color3.fromRGB(170, 170, 180)
LabelCP.Font = Enum.Font.GothamSemibold
LabelCP.TextSize = 12
LabelCP.TextXAlignment = Enum.TextXAlignment.Left
LabelCP.ZIndex = 9
LabelCP.Parent = CardPlayers

local ValCP = Instance.new("TextLabel")
ValCP.Position = UDim2.new(0, 55, 0, 32)
ValCP.Size = UDim2.new(1, -65, 0, 20)
ValCP.BackgroundTransparency = 1
ValCP.Text = "Calculando..."
ValCP.TextColor3 = AccentColor
ValCP.Font = Enum.Font.GothamBold
ValCP.TextSize = 14
ValCP.TextXAlignment = Enum.TextXAlignment.Left
ValCP.ZIndex = 9
ValCP.Parent = CardPlayers

local CardFPS = Instance.new("Frame")
CardFPS.Size = UDim2.new(1, -10, 0, 65)
CardFPS.BackgroundColor3 = SidebarColor
CardFPS.ZIndex = 8
CardFPS.Parent = StatusPage
Instance.new("UICorner", CardFPS).CornerRadius = UDim.new(0, 8)
local StrokeCF = Instance.new("UIStroke", CardFPS)
StrokeCF.Color = Color3.fromRGB(35, 35, 40)
StrokeCF.Thickness = 1.2

local IconCF = Instance.new("TextLabel")
IconCF.Size = UDim2.new(0, 50, 1, 0)
IconCF.BackgroundTransparency = 1
IconCF.Text = "⚡"
IconCF.TextSize = 22
IconCF.ZIndex = 9
IconCF.Parent = CardFPS

local LabelCF = Instance.new("TextLabel")
LabelCF.Position = UDim2.new(0, 55, 0, 12)
LabelCF.Size = UDim2.new(1, -65, 0, 20)
LabelCF.BackgroundTransparency = 1
LabelCF.Text = "Taxa de Quadros (FPS)"
LabelCF.TextColor3 = Color3.fromRGB(170, 170, 180)
LabelCF.Font = Enum.Font.GothamSemibold
LabelCF.TextSize = 12
LabelCF.TextXAlignment = Enum.TextXAlignment.Left
LabelCF.ZIndex = 9
LabelCF.Parent = CardFPS

local ValCF = Instance.new("TextLabel")
ValCF.Position = UDim2.new(0, 55, 0, 32)
ValCF.Size = UDim2.new(1, -65, 0, 20)
ValCF.BackgroundTransparency = 1
ValCF.Text = "Calculando..."
ValCF.TextColor3 = Color3.fromRGB(50, 220, 110)
ValCF.Font = Enum.Font.GothamBold
ValCF.TextSize = 14
ValCF.TextXAlignment = Enum.TextXAlignment.Left
ValCF.ZIndex = 9
ValCF.Parent = CardFPS

local fpsTimer = 0
local frameCount = 0

RunService.Heartbeat:Connect(function(dt)
    frameCount = frameCount + 1
    fpsTimer = fpsTimer + dt
    if fpsTimer >= 1 then
        ValCF.Text = tostring(frameCount) .. " FPS"
        frameCount = 0
        fpsTimer = 0
    end
end)

task.spawn(function()
    while task.wait(3) do
        if not ScreenGui.Parent then break end
        local usingBKCount = 0
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                local pg = p:FindFirstChild("PlayerGui")
                if pg and (pg:FindFirstChild("BK_Official_UI") or pg:FindFirstChild("BK_Capsule")) then
                    usingBKCount = usingBKCount + 1
                end
            end
        end)
        if usingBKCount == 0 then usingBKCount = 1 end
        ValCP.Text = tostring(usingBKCount) .. " Ativo(s) no Servidor"
    end
end)

-- ==========================================
-- ENGINE DOS ESPs (BOX, LINE, NAME, DIST)
-- ==========================================
local function createEspElements(player)
    if not ActiveBoxes[player] then
        local box = Drawing.new("Square")
        box.Visible = false
        box.Filled = false
        ActiveBoxes[player] = {Box = box}
    end
    if not ActiveLines[player] then
        local line = Drawing.new("Line")
        line.Visible = false
        ActiveLines[player] = {Line = line}
    end
    if not ActiveNames[player] then
        local text = Drawing.new("Text")
        text.Visible = false
        text.Center = true
        text.Outline = true
        text.OutlineColor = Color3.fromRGB(0, 0, 0)
        ActiveNames[player] = {Text = text}
    end
    if not ActiveDists[player] then
        local text = Drawing.new("Text")
        text.Visible = false
        text.Center = true
        text.Outline = true
        text.OutlineColor = Color3.fromRGB(0, 0, 0)
        ActiveDists[player] = {Text = text}
    end
end

RunService.RenderStepped:Connect(function()
    local rainbowColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createEspElements(player)
            
            local boxContainer = ActiveBoxes[player]
            local lineContainer = ActiveLines[player]
            local nameContainer = ActiveNames[player]
            local distContainer = ActiveDists[player]
            
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local rootPart = char.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                local distance = (Camera.CoordinateFrame.p - rootPart.Position).Magnitude
                
                if onScreen and distance <= ESP_Config.MaxDistance then
                    local scaleFactor = 1 / (screenPos.Z * math.tan(math.rad(Camera.FieldOfView / 2))) * 1000
                    local width = (scaleFactor * 1.5) * ESP_Config.BoxSizeMultiplier
                    local height = (scaleFactor * 2.1) * ESP_Config.BoxSizeMultiplier
                    
                    if ESP_Config.BoxEnabled then
                        boxContainer.Box.Size = Vector2.new(width, height)
                        boxContainer.Box.Position = Vector2.new(screenPos.X - (width / 2), screenPos.Y - (height / 2))
                        boxContainer.Box.Color = ESP_Config.BoxColor
                        boxContainer.Box.Thickness = ESP_Config.BoxThickness
                        boxContainer.Box.Visible = true
                    else
                        boxContainer.Box.Visible = false
                    end
                    
                    if ESP_Config.LineEnabled then
                        local startPoint
                        if ESP_Config.LineOrigin == "Baixo" then
                            startPoint = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        else
                            startPoint = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        end
                        lineContainer.Line.From = startPoint
                        lineContainer.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                        lineContainer.Line.Color = ESP_Config.LineColor
                        lineContainer.Line.Thickness = ESP_Config.LineThickness
                        lineContainer.Line.Visible = true
                    else
                        lineContainer.Line.Visible = false
                    end
                    
                    if ESP_Config.NameEnabled then
                        nameContainer.Text.Text = player.DisplayName
                        nameContainer.Text.Size = ESP_Config.NameSize
                        nameContainer.Text.Color = ESP_Config.NameRainbow and rainbowColor or ESP_Config.NameColor
                        
                        local topOffset = height / 2 + 15
                        nameContainer.Text.Position = Vector2.new(screenPos.X, screenPos.Y - topOffset)
                        nameContainer.Text.Visible = true
                    else
                        nameContainer.Text.Visible = false
                    end
                    
                    if ESP_Config.DistEnabled then
                        distContainer.Text.Text = string.format("[ %dM ]", math.floor(distance))
                        distContainer.Text.Size = ESP_Config.NameSize - 1
                        distContainer.Text.Color = ESP_Config.DistColor
                        
                        local bottomOffset = height / 2 + 2
                        distContainer.Text.Position = Vector2.new(screenPos.X, screenPos.Y + bottomOffset)
                        distContainer.Text.Visible = true
                    else
                        distContainer.Text.Visible = false
                    end
                else
                    boxContainer.Box.Visible = false
                    lineContainer.Line.Visible = false
                    nameContainer.Text.Visible = false
                    distContainer.Text.Visible = false
                end
            else
                boxContainer.Box.Visible = false
                lineContainer.Line.Visible = false
                nameContainer.Text.Visible = false
                distContainer.Text.Visible = false
            end
        end
    end
    
    for player, drawObj in pairs(ActiveBoxes) do
        if not player.Parent then
            if drawObj.Box then drawObj.Box:Remove() end
            ActiveBoxes[player] = nil
        end
    end
    for player, drawObj in pairs(ActiveLines) do
        if not player.Parent then
            if drawObj.Line then drawObj.Line:Remove() end
            ActiveLines[player] = nil
        end
    end
    for player, drawObj in pairs(ActiveNames) do
        if not player.Parent then
            if drawObj.Text then drawObj.Text:Remove() end
            ActiveNames[player] = nil
        end
    end
    for player, drawObj in pairs(ActiveDists) do
        if not player.Parent then
            if drawObj.Text then drawObj.Text:Remove() end
            ActiveDists[player] = nil
        end
    end
end)

-- ==========================================
-- INTERDITANDO AS OUTRAS ABAS
-- ==========================================
local function setInterdicted(page, name)
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 1, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "ABA [" .. string.upper(name) .. "]\n\n⚡ EM BREVE ⚡\n(INTERDITADA V2.8)"
    InfoLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
    InfoLabel.TextSize = 13
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.ZIndex = 8
    InfoLabel.Parent = page
end

setInterdicted(Pages["Mira"], "Mira")
setInterdicted(Pages["Configurações"], "Configurações")

Tabs["Status"].Btn.BackgroundTransparency = 0.8
Tabs["Status"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs["Status"].Btn.BackgroundColor3 = AccentColor
Tabs["Status"].Stroke.Transparency = 0.3
Pages["Status"].Visible = true

-- ==========================================
-- SISTEMA DE ABERTURA PREMIUM (FADE & SCALE)
-- ==========================================
local isMenuOpen = false
local menuTransitioning = false

local function toggleMenu()
    if menuTransitioning then return end
    menuTransitioning = true
    isMenuOpen = not isMenuOpen
    playSound("6895086153", 0.5)
    
    if isMenuOpen then
        CentralMenuCanvas.Size = UDim2.new(0, 470, 0, 290)
        CentralMenuCanvas.GroupTransparency = 1
        CentralMenuCanvas.Visible = true
        
        TweenService:Create(CentralMenuCanvas, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 320),
            GroupTransparency = 0
        }):Play()
        
        task.wait(0.4)
        menuTransitioning = false
    else
        TweenService:Create(CentralMenuCanvas, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 470, 0, 290),
            GroupTransparency = 1
        }):Play()
        
        task.wait(0.3)
        if not isMenuOpen then
            CentralMenuCanvas.Visible = false
        end
        BoxCustomizerWindow.Visible = false
        LineCustomizerWindow.Visible = false
        NameCustomizerWindow.Visible = false
        DistCustomizerWindow.Visible = false
        menuTransitioning = false
    end
end

-- ==========================================
-- SISTEMA DE ARRASTE ULTRA ESTÁVEL (DIRETO)
-- ==========================================
local dragging = false
local dragStart, startPos
local dragLimit = 8

Capsule.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Capsule.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Capsule.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            dragging = false
            local moveDistance = (input.Position - dragStart).Magnitude
            if moveDistance < dragLimit then
                toggleMenu()
            end
        end
    end
end)

print("[BK CLIENT] Versão V1.2 Ativa. ESP Name e ESP Distância configurados perfeitamente!")
