-- ====================================================================
-- BK CLIENT - VERSÃO COMPLETA E ESTABILIZADA V2.9.2
-- ====================================================================

-- Garantia de carregamento inicial (Impede o script de sumir/dar crash no mobile)
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5) 

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then LocalPlayer = Players.PlayerAdded:Wait() end

-- Limpeza absoluta de versões anteriores para evitar sobreposição
pcall(function()
    for _, child in pairs(CoreGui:GetChildren()) do
        if child.Name == "BK_Official_UI" then child:Destroy() end
    end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, child in pairs(pg:GetChildren()) do
            if child.Name == "BK_Official_UI" then child:Destroy() end
        end
    end
end)

-- ==========================================
-- INTERFACE BASE (CRIAÇÃO SEGURA)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Official_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999 -- Prioridade máxima para desenhar por cima de tudo
ScreenGui.Enabled = true

-- Tenta inserir no CoreGui (padrão injector), se falhar usa PlayerGui de forma segura
local parentSuccess = pcall(function() ScreenGui.Parent = CoreGui end)
if not parentSuccess then
    local pGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if pGui then ScreenGui.Parent = pGui end
end

-- Definição da Paleta de Cores (Dark & Purple Neon)
local BGColor = Color3.fromRGB(10, 10, 12)
local MenuBGColor = Color3.fromRGB(14, 14, 16)
local SidebarColor = Color3.fromRGB(8, 8, 10)
local AccentColor = Color3.fromRGB(110, 60, 220) -- Roxo Neon Principal
local BorderColor = Color3.fromRGB(50, 50, 55)

-- ==========================================
-- SISTEMA DE SONS SATISFATÓRIOS
-- ==========================================
local function playSound(id, volume)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = volume or 0.5
        sound.Parent = ScreenGui -- Garante que o som execute tocando dentro da GUI
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

-- ==========================================
-- CÁPSULA (BOLHA FLUTUANTE)
-- ==========================================
local Capsule = Instance.new("TextButton")
Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 160, 0, 42)
Capsule.Position = UDim2.new(0.1, 0, 0.4, 0) -- Posição inicial segura na tela
Capsule.BackgroundColor3 = BGColor
Capsule.BorderSizePixel = 0
Capsule.AutoButtonColor = false
Capsule.Text = ""
Capsule.Active = true
Capsule.Visible = true
Capsule.ClipsDescendants = true 
Capsule.ZIndex = 100
Capsule.Parent = ScreenGui

Instance.new("UICorner", Capsule).CornerRadius = UDim.new(0, 21)
local CapsuleStroke = Instance.new("UIStroke", Capsule)
CapsuleStroke.Color = BorderColor
CapsuleStroke.Thickness = 1.5

-- [CONSTELAÇÃO NEON INTERATIVA NA BOLHA]
local StarContainer = Instance.new("Frame")
StarContainer.Size = UDim2.new(1, 0, 1, 0)
StarContainer.BackgroundTransparency = 1
StarContainer.ZIndex = 101
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
    nodeFrame.ZIndex = 103
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
    line.ZIndex = 102
    
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

-- Nome Oficial da Bolha
local CapsuleLabel = Instance.new("TextLabel")
CapsuleLabel.Size = UDim2.new(1, 0, 1, 0)
CapsuleLabel.BackgroundTransparency = 1
CapsuleLabel.Text = "BK CLIENT V1 †"
CapsuleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
CapsuleLabel.TextSize = 13
CapsuleLabel.Font = Enum.Font.GothamBold
CapsuleLabel.ZIndex = 105
CapsuleLabel.Parent = Capsule

-- ==========================================
-- MENU CENTRAL (PAINEL GERAL)
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
CentralMenuCanvas.ZIndex = 200
CentralMenuCanvas.Parent = ScreenGui

Instance.new("UICorner", CentralMenuCanvas).CornerRadius = UDim.new(0, 12)
local MenuStroke = Instance.new("UIStroke", CentralMenuCanvas)
MenuStroke.Color = BorderColor
MenuStroke.Thickness = 1.5

-- HEADER (BARRA SUPERIOR COM FOTO DE PERFIL)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = SidebarColor
Header.BorderSizePixel = 0
Header.ZIndex = 201
Header.Parent = CentralMenuCanvas
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderAvatar = Instance.new("ImageLabel")
HeaderAvatar.Size = UDim2.new(0, 38, 0, 38)
HeaderAvatar.Position = UDim2.new(0, 15, 0.5, -19)
HeaderAvatar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
HeaderAvatar.BorderSizePixel = 0
HeaderAvatar.ZIndex = 202
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
HeaderTitle.Text = LocalPlayer.DisplayName .. " | BK CLIENT"
HeaderTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextSize = 14
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 202
HeaderTitle.Parent = Header

-- SIDEBAR (BARRA LATERAL DE SELEÇÃO DE ABAS)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -55)
Sidebar.Position = UDim2.new(1, -130, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 201
Sidebar.Parent = CentralMenuCanvas

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 202
TabContainer.Parent = Sidebar

Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 6)
TabContainer.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", TabContainer).PaddingTop = UDim.new(0, 10)

-- CONTAINER DE CONTEÚDO DAS PÁGINAS
local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 15, 0, 70)
ContentContainer.Size = UDim2.new(1, -160, 1, -85)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 201
ContentContainer.Parent = CentralMenuCanvas

-- ==========================================
-- CRIADOR DE ABAS SISTÊMICO
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
    TabBtn.ZIndex = 203
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
    Page.ZIndex = 202
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

-- CRIAÇÃO DAS QUATRO ABAS OFICIAIS
createTab("Visual")
createTab("Mira")
createTab("Status")
createTab("Configurações")

-- ==========================================
-- CONTEÚDO DA ABA [STATUS] (ATIVA)
-- ==========================================
local StatusPage = Pages["Status"]
local ValCP = Instance.new("TextLabel")
local ValCF = Instance.new("TextLabel")

local function setupStatusPage()
    local StatusLayout = Instance.new("UIListLayout", StatusPage)
    StatusLayout.Padding = UDim.new(0, 12)
    StatusLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function createCard(title, icon, parent)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -10, 0, 60)
        card.BackgroundColor3 = SidebarColor
        card.ZIndex = 203
        card.Parent = parent
        
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        local cardStroke = Instance.new("UIStroke", card)
        cardStroke.Color = Color3.fromRGB(35, 35, 40)
        cardStroke.Thickness = 1.2
        
        local textTitle = Instance.new("TextLabel")
        textTitle.Position = UDim2.new(0, 50, 0, 10)
        textTitle.Size = UDim2.new(1, -60, 0, 20)
        textTitle.Text = title
        textTitle.TextColor3 = Color3.fromRGB(170, 170, 180)
        textTitle.TextSize = 12
        textTitle.BackgroundTransparency = 1
        textTitle.TextXAlignment = Enum.TextXAlignment.Left
        textTitle.Font = Enum.Font.GothamSemibold
        textTitle.ZIndex = 204
        textTitle.Parent = card
        
        local textVal = Instance.new("TextLabel")
        textVal.Position = UDim2.new(0, 50, 0, 30)
        textVal.Size = UDim2.new(1, -60, 0, 20)
        textVal.Text = "Calculando..."
        textVal.TextColor3 = AccentColor
        textVal.TextSize = 14
        textVal.BackgroundTransparency = 1
        textVal.TextXAlignment = Enum.TextXAlignment.Left
        textVal.Font = Enum.Font.GothamBold
        textVal.ZIndex = 204
        textVal.Parent = card
        
        local emoji = Instance.new("TextLabel")
        emoji.Size = UDim2.new(0, 50, 1, 0)
        emoji.Text = icon
        emoji.TextSize = 20
        emoji.BackgroundTransparency = 1
        emoji.ZIndex = 204
        emoji.Parent = card
        
        return textVal
    end
    
    ValCP = createCard("Jogadores usando o BK", "👤", StatusPage)
    ValCF = createCard("Taxa de Quadros (FPS)", "⚡", StatusPage)
    ValCF.TextColor3 = Color3.fromRGB(50, 220, 110) -- Cor Verde Sucesso para FPS
end
setupStatusPage()

-- ==========================================
-- CONTEÚDO DA ABA [CONFIGURAÇÕES] (ATIVA)
-- ==========================================
local function setupConfigPage()
    local ConfigPage = Pages["Configurações"]
    local ConfigLayout = Instance.new("UIListLayout", ConfigPage)
    ConfigLayout.Padding = UDim.new(0, 12)
    ConfigLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local SupportBtn = Instance.new("TextButton")
    SupportBtn.Size = UDim2.new(1, -10, 0, 50)
    SupportBtn.BackgroundColor3 = SidebarColor
    SupportBtn.Text = "💬  Falar com o Suporte (Copiar Número)"
    SupportBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
    SupportBtn.Font = Enum.Font.GothamBold
    SupportBtn.TextSize = 12
    SupportBtn.ZIndex = 203
    SupportBtn.Parent = ConfigPage
    
    Instance.new("UICorner", SupportBtn).CornerRadius = UDim.new(0, 8)
    local SupportStroke = Instance.new("UIStroke", SupportBtn)
    SupportStroke.Color = Color3.fromRGB(40, 40, 45)
    SupportStroke.Thickness = 1.2
    
    -- Mecânica de clique que copia o número de telefone
    local copied = false
    SupportBtn.MouseButton1Click:Connect(function()
        if copied then return end
        copied = true
        
        pcall(function() setclipboard("49991510649") end)
        playSound("12222076", 0.4)
        
        SupportBtn.Text = "Número Copiado! ✅"
        SupportBtn.TextColor3 = Color3.fromRGB(50, 220, 110)
        SupportStroke.Color = Color3.fromRGB(50, 220, 110)
        
        task.wait(2)
        
        SupportBtn.Text = "💬  Falar com o Suporte (Copiar Número)"
        SupportBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
        SupportStroke.Color = Color3.fromRGB(40, 40, 45)
        copied = false
    end)
end
setupConfigPage()

-- ==========================================
-- SCRIPT DE INTERDIÇÃO (VISUAL & MIRA)
-- ==========================================
local function setInterdicted(page, name)
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 1, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "ABA [" .. string.upper(name) .. "]\n\n⚡ EM BREVE ⚡\n(INTERDITADA V2.9.2)"
    InfoLabel.TextColor3 = Color3.fromRGB(80, 80, 90)
    InfoLabel.TextSize = 13
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.ZIndex = 203
    InfoLabel.Parent = page
end
setInterdicted(Pages["Visual"], "Visual")
setInterdicted(Pages["Mira"], "Mira")

-- ==========================================
-- LOGICAS EM SEGUNDO PLANO (FPS & JOGADORES)
-- ==========================================
task.spawn(function()
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
    
    while task.wait(4) do
        if not ScreenGui.Parent then break end
        local activeBKCount = 0
        pcall(function()
            for _, p in pairs(Players:GetPlayers()) do
                local pg = p:FindFirstChild("PlayerGui")
                local cg = p:FindFirstChild("CoreGui")
                if (pg and pg:FindFirstChild("BK_Official_UI")) or (cg and cg:FindFirstChild("BK_Official_UI")) then
                    activeBKCount = activeBKCount + 1
                end
            end
        end)
        if activeBKCount == 0 then activeBKCount = 1 end
        ValCP.Text = tostring(activeBKCount) .. " Ativo(s) no Servidor"
    end
end)

-- ==========================================
-- SISTEMA DE EXPANSÃO (ABRE/FECHA)
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
        menuTransitioning = false
    end
end

-- ==========================================
-- SISTEMA DE ARRASTE ULTRA ESTÁVEL (TOUCH)
-- ==========================================
local dragging = false
local dragStart, startPos
local dragLimit = 8

Capsule.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType
