-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V2.8 (STATUS REAIS + ESP BOX PERSONALIZÁVEL)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Limpeza absoluta de versões anteriores
pcall(function()
    if CoreGui:FindFirstChild("BK_Official_UI") then
        CoreGui:FindFirstChild("BK_Official_UI"):Destroy()
    end
    if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("BK_Official_UI") then
        LocalPlayer.PlayerGui:FindFirstChild("BK_Official_UI"):Destroy()
    end
end)

-- ==========================================
-- SISTEMA DE CONFIGURAÇÕES SALVÁVEIS DO ESP
-- ==========================================
local ESP_Config = {
    Enabled = false,
    Color = Color3.fromRGB(110, 60, 220), -- Roxo Neon Padrão
    Thickness = 1.5,
    SizeMultiplier = 1.0
}

-- Armazenamento das caixas de desenho ativas
local ActiveBoxes = {}

-- ==========================================
-- SISTEMA DE SONS SATISFATÓRIOS
-- ==========================================
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

-- ==========================================
-- INTERFACE BASE
-- ==========================================
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
local AccentColor = Color3.fromRGB(110, 60, 220) -- Roxo Neon
local BorderColor = Color3.fromRGB(50, 50, 55)

-- ==========================================
-- CÁPSULA (BOLHA FLUTUANTE)
-- ==========================================
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

-- ==========================================
-- CONSTELAÇÃO NEON (BOLHAS + LINHAS SUAVES)
-- ==========================================
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

-- Nome na Bolha
local CapsuleLabel = Instance.new("TextLabel")
CapsuleLabel.Size = UDim2.new(1, 0, 1, 0)
CapsuleLabel.BackgroundTransparency = 1
CapsuleLabel.Text = "BK CLIENT V1 †"
CapsuleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
CapsuleLabel.TextSize = 13
CapsuleLabel.Font = Enum.Font.GothamBold
CapsuleLabel.ZIndex = 5
CapsuleLabel.Parent = Capsule

-- ==========================================
-- MENU CENTRAL FLUTUANTE
-- ==========================================
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

-- HEADER (PERFIL DO JOGADOR)
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
HeaderTitle.Text = LocalPlayer.DisplayName .. " | BK CLIENT V1"
HeaderTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 7
HeaderTitle.Parent = Header

-- ABAS (GAVETA DIREITA)
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

-- CONTAINER DE CONTEÚDO (ESQUERDA)
local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 15, 0, 70)
ContentContainer.Size = UDim2.new(1, -160, 1, -85)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 6
ContentContainer.Parent = CentralMenuCanvas

-- ==========================================
-- CRIADOR DE ABAS E DETECÇÃO EM TEMPO REAL
-- ==========================================
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

-- CRIAÇÃO DAS ABAS OFICIAIS
createTab("Visual")
createTab("Mira")
createTab("Status")
createTab("Configurações")

-- ==========================================
-- SEÇÃO MÓVEL DA BOX (ESTILO PC FLUTUANTE)
-- ==========================================
local CustomizerWindow = Instance.new("Frame")
CustomizerWindow.Name = "BK_BoxCustomizer"
CustomizerWindow.Size = UDim2.new(0, 220, 0, 190)
CustomizerWindow.Position = UDim2.new(0.5, -110, 0.5, -210) -- Aparece um pouco acima do menu principal
CustomizerWindow.BackgroundColor3 = MenuBGColor
CustomizerWindow.BorderSizePixel = 0
CustomizerWindow.Active = true
CustomizerWindow.Visible = false
CustomizerWindow.ZIndex = 30
CustomizerWindow.Parent = ScreenGui

Instance.new("UICorner", CustomizerWindow).CornerRadius = UDim.new(0, 8)
local CustomizerStroke = Instance.new("UIStroke", CustomizerWindow)
CustomizerStroke.Color = AccentColor
CustomizerStroke.Thickness = 1.2

-- Barra de arrasto superior da mini janela
local CustomHeader = Instance.new("Frame")
CustomHeader.Size = UDim2.new(1, 0, 0, 28)
CustomHeader.BackgroundColor3 = SidebarColor
CustomHeader.BorderSizePixel = 0
CustomHeader.ZIndex = 31
CustomHeader.Parent = CustomizerWindow
Instance.new("UICorner", CustomHeader).CornerRadius = UDim.new(0, 8)

local CustomTitle = Instance.new("TextLabel")
CustomTitle.Size = UDim2.new(1, -30, 1, 0)
CustomTitle.Position = UDim2.new(0, 10, 0, 0)
CustomTitle.BackgroundTransparency = 1
CustomTitle.Text = "Ajustes da Box"
CustomTitle.TextColor3 = Color3.fromRGB(200, 200, 205)
CustomTitle.Font = Enum.Font.GothamBold
CustomTitle.TextSize = 11
CustomTitle.TextXAlignment = Enum.TextXAlignment.Left
CustomTitle.ZIndex = 32
CustomTitle.Parent = CustomHeader

local CustomClose = Instance.new("TextButton")
CustomClose.Size = UDim2.new(0, 24, 0, 24)
CustomClose.Position = UDim2.new(1, -26, 0.5, -12)
CustomClose.BackgroundTransparency = 1
CustomClose.Text = "×"
CustomClose.TextColor3 = Color3.fromRGB(150, 150, 150)
CustomClose.Font = Enum.Font.GothamBold
CustomClose.TextSize = 18
CustomClose.ZIndex = 32
CustomClose.Parent = CustomHeader

CustomClose.MouseButton1Click:Connect(function()
    playSound("12222076", 0.3)
    CustomizerWindow.Visible = false
end)

-- Sistema de Arraste da mini janela (Touch de PC funcional no celular)
local customDragging = false
local customDragStart, customStartPos

CustomHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        customDragging = true
        customDragStart = input.Position
        customStartPos = CustomizerWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if customDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - customDragStart
        CustomizerWindow.Position = UDim2.new(
            customStartPos.X.Scale, 
            customStartPos.X.Offset + delta.X, 
            customStartPos.Y.Scale, 
            customStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        customDragging = false
    end
end)

-- CONTEÚDO DOS AJUSTES NA JANELA FLUTUANTE
local CustomBody = Instance.new("Frame")
CustomBody.Position = UDim2.new(0, 0, 0, 28)
CustomBody.Size = UDim2.new(1, 0, 1, -28)
CustomBody.BackgroundTransparency = 1
CustomBody.ZIndex = 31
CustomBody.Parent = CustomizerWindow

local BodyLayout = Instance.new("UIListLayout", CustomBody)
BodyLayout.Padding = UDim.new(0, 8)
BodyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", CustomBody).PaddingTop = UDim.new(0, 8)

-- 1. Seletor de Cores da Box
local ColorSection = Instance.new("Frame")
ColorSection.Size = UDim2.new(0.9, 0, 0, 32)
ColorSection.BackgroundTransparency = 1
ColorSection.ZIndex = 32
ColorSection.Parent = CustomBody

local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0.4, 0, 1, 0)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "Cor da Box:"
ColorLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
ColorLabel.Font = Enum.Font.GothamSemibold
ColorLabel.TextSize = 10
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.ZIndex = 33
ColorLabel.Parent = ColorSection

local ColorBtnContainer = Instance.new("Frame")
ColorBtnContainer.Size = UDim2.new(0.6, 0, 1, 0)
ColorBtnContainer.Position = UDim2.new(0.4, 0, 0, 0)
ColorBtnContainer.BackgroundTransparency = 1
ColorBtnContainer.ZIndex = 33
ColorBtnContainer.Parent = ColorSection

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
    cBtn.Parent = ColorBtnContainer
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 4)
    
    local cBtnStroke = Instance.new("UIStroke", cBtn)
    cBtnStroke.Color = Color3.fromRGB(255, 255, 255)
    cBtnStroke.Thickness = 1.2
    cBtnStroke.Transparency = (ESP_Config.Color == colorData.Color) and 0 or 1
    
    cBtn.MouseButton1Click:Connect(function()
        playSound("12222076", 0.35)
        ESP_Config.Color = colorData.Color
        -- Atualiza as bordas de seleção
        for _, child in ipairs(ColorBtnContainer:GetChildren()) do
            if child:IsA("TextButton") and child:FindFirstChildOfClass("UIStroke") then
                child:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
        cBtnStroke.Transparency = 0
    end)
end

-- 2. Ajustador de Espessura
local ThickSection = Instance.new("Frame")
ThickSection.Size = UDim2.new(0.9, 0, 0, 32)
ThickSection.BackgroundTransparency = 1
ThickSection.ZIndex = 32
ThickSection.Parent = CustomBody

local ThickLabel = Instance.new("TextLabel")
ThickLabel.Size = UDim2.new(0.4, 0, 1, 0)
ThickLabel.BackgroundTransparency = 1
ThickLabel.Text = "Espessura:"
ThickLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
ThickLabel.Font = Enum.Font.GothamSemibold
ThickLabel.TextSize = 10
ThickLabel.TextXAlignment = Enum.TextXAlignment.Left
ThickLabel.ZIndex = 33
ThickLabel.Parent = ThickSection

local ThickValLabel = Instance.new("TextLabel")
ThickValLabel.Size = UDim2.new(0.2, 0, 1, 0)
ThickValLabel.Position = UDim2.new(0.4, 0, 0, 0)
ThickValLabel.BackgroundTransparency = 1
ThickValLabel.Text = tostring(ESP_Config.Thickness)
ThickValLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
ThickValLabel.Font = Enum.Font.GothamBold
ThickValLabel.TextSize = 11
ThickValLabel.ZIndex = 33
ThickValLabel.Parent = ThickSection

local ThickLess = Instance.new("TextButton")
ThickLess.Size = UDim2.new(0, 24, 0, 24)
ThickLess.Position = UDim2.new(0.65, 0, 0.5, -12)
ThickLess.BackgroundColor3 = SidebarColor
ThickLess.Text = "-"
ThickLess.TextColor3 = Color3.fromRGB(240, 240, 240)
ThickLess.Font = Enum.Font.GothamBold
ThickLess.TextSize = 12
ThickLess.ZIndex = 34
ThickLess.Parent = ThickSection
Instance.new("UICorner", ThickLess).CornerRadius = UDim.new(0, 4)

local ThickMore = Instance.new("TextButton")
ThickMore.Size = UDim2.new(0, 24, 0, 24)
ThickMore.Position = UDim2.new(0.85, 0, 0.5, -12)
ThickMore.BackgroundColor3 = SidebarColor
ThickMore.Text = "+"
ThickMore.TextColor3 = Color3.fromRGB(240, 240, 240)
ThickMore.Font = Enum.Font.GothamBold
ThickMore.TextSize = 12
ThickMore.ZIndex = 34
ThickMo
