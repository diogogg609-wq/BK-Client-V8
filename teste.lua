-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V2.9.1 (CORREÇÃO DE BUG DE INICIALIZAÇÃO)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

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
-- DESIGN DA ABA [STATUS] - ATIVA E REAL
-- ==========================================
local StatusPage = Pages["Status"]

local StatusLayout = Instance.new("UIListLayout", StatusPage)
StatusLayout.Padding = UDim.new(0, 12)
StatusLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- 1. CARD JOGADORES ATIVOS
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

-- 2. CARD FPS
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

-- ==========================================
-- DESIGN DA ABA [CONFIGURAÇÕES] - ATIVA COM SUPORTE
-- ==========================================
local ConfigPage = Pages["Configurações"]

local ConfigLayout = Instance.new("UIListLayout", ConfigPage)
ConfigLayout.Padding = UDim.new(0, 12)
ConfigLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- BOTÃO FALAR COM O SUPORTE
local SupportBtn = Instance.new("TextButton")
SupportBtn.Size = UDim2.new(1, -10, 0, 50)
SupportBtn.BackgroundColor3 = SidebarColor
SupportBtn.Text = ""
SupportBtn.AutoButtonColor = false
SupportBtn.ZIndex = 8
SupportBtn.Parent = ConfigPage

Instance.new("UICorner", SupportBtn).CornerRadius = UDim.new(0, 8)
local SupportStroke = Instance.new("UIStroke", SupportBtn)
SupportStroke.Color = Color3.fromRGB(35, 35, 40)
SupportStroke.Thickness = 1.2

local SupportIcon = Instance.new("TextLabel")
SupportIcon.Size = UDim2.new(0, 45, 1, 0)
SupportIcon.BackgroundTransparency = 1
SupportIcon.Text = "💬"
SupportIcon.TextSize = 18
SupportIcon.ZIndex = 9
SupportIcon.Parent = SupportBtn

local SupportText = Instance.new("TextLabel")
SupportText.Position = UDim2.new(0, 45, 0, 0)
SupportText.Size = UDim2.new(1, -55, 1, 0)
SupportText.BackgroundTransparency = 1
SupportText.Text = "Falar com o Suporte (Copiar Número)"
SupportText.TextColor3 = Color3.fromRGB(230, 230, 235)
SupportText.Font = Enum.Font.GothamBold
SupportText.TextSize = 12
SupportText.TextXAlignment = Enum.TextXAlignment.Left
SupportText.ZIndex = 9
SupportText.Parent = SupportBtn

-- Sistema de Clique para Copiar Número com Notificação Visual
local copied = false
SupportBtn.MouseButton1Click:Connect(function()
    if copied then return end
    copied = true
    
    -- Copia o número para o clipboard do celular usando API nativa
    pcall(function()
        setclipboard("49991510649")
    end)
    
    playSound("12222076", 0.4) -- Bipe sonoro satisfatório
    
    -- Transição visual de sucesso
    TweenService:Create(SupportStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 220, 110)}):Play()
    SupportText.Text = "Número Copiado! ✅"
    SupportText.TextColor3 = Color3.fromRGB(50, 220, 110)
    
    task.wait(2)
    
    -- Retorna ao visual padrão original
    TweenService:Create(SupportStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 40)}):Play()
    SupportText.Text = "Falar com o Suporte (Copiar Número)"
    SupportText.TextColor3 = Color3.fromRGB(230, 230, 235)
    copied = false
end)

-- ==========================================
-- SCRIPT DE CÁLCULO DE FPS & PLAYERS REAL (SUAVE)
-- ==========================================
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

-- INTERDITANDO AS OUTRAS ABAS
local function setInterdicted(page, name)
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 1, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "ABA [" .. string.upper(name) .. "]\n\n⚡ EM BREVE ⚡\n(INTERDITADA V2.9.1)"
    InfoLabel.TextColor3 = Color3.fromRGB(100, 100, 110)
    InfoLabel.TextSize = 13
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.ZIndex = 8
    InfoLabel.Parent = page
end

setInterdicted(Pages["Visual"], "Visual")
setInterdicted(Pages["Mira"], "Mira")

-- Seleciona a aba Status por padrão
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
            GroupTransparency =
