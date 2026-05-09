-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V2.0 (VERSÃO ULTRA ESTÁVEL ANDROID)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- Limpeza absoluta de qualquer versão anterior
pcall(function()
    if CoreGui:FindFirstChild("BK_Official_UI") then
        CoreGui:FindFirstChild("BK_Official_UI"):Destroy()
    end
end)

-- ==========================================
-- SISTEMA DE SONS SATISFATÓRIOS
-- ==========================================
local function playSound(id, volume, pitch)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Volume = volume or 0.5
        sound.PlaybackSpeed = pitch or 1
        sound.Parent = CoreGui
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

local SOUND_CLICK = "6895086153" -- Pop macio
local SOUND_TAB = "12222076" -- Clique digital

-- Notificação de inicialização
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "BK CLIENT V2",
        Text = "MENU CARREGADO COM SUCESSO",
        Icon = "rbxassetid://6031094028",
        Duration = 5
    })
end)

-- ==========================================
-- CRIAÇÃO DA INTERFACE BASE
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Official_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local successParent = pcall(function() ScreenGui.Parent = CoreGui end)
if not successParent then pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end

local BGColor = Color3.fromRGB(10, 10, 12)
local MenuBGColor = Color3.fromRGB(14, 14, 16)
local SidebarColor = Color3.fromRGB(8, 8, 10)
local AccentColor = Color3.fromRGB(110, 60, 220)
local BorderColor = Color3.fromRGB(50, 50, 55)

-- ==========================================
-- CÁPSULA FLUTUANTE (BOLHA)
-- ==========================================
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")

Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 180, 0, 46)
Capsule.Position = UDim2.new(0.05, 0, 0.3, 0)
Capsule.BackgroundColor3 = BGColor
Capsule.Active = true
Capsule.ClipsDescendants = true
Capsule.Parent = ScreenGui

CapsuleCorner.CornerRadius = UDim.new(0, 23)
CapsuleCorner.Parent = Capsule

CapsuleStroke.Color = BorderColor
CapsuleStroke.Thickness = 1.5
CapsuleStroke.Parent = Capsule

-- Starfield (Fundo Espacial da Bolha)
local StarContainer = Instance.new("Frame")
StarContainer.Size = UDim2.new(1, 0, 1, 0)
StarContainer.BackgroundTransparency = 1
StarContainer.ZIndex = 1
StarContainer.Parent = Capsule

local stars = {}
for i = 1, 8 do
    local star = Instance.new("Frame")
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local size = math.random(1, 3)
    star.Size = UDim2.new(0, size, 0, size)
    star.BackgroundTransparency = math.random(2, 6) / 10
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.Parent = StarContainer
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = star
    table.insert(stars, {frame = star, speed = math.random(10, 30) / 1000})
end

RunService.RenderStepped:Connect(function(dt)
    for _, starData in ipairs(stars) do
        local star = starData.frame
        local currentX = star.Position.X.Scale
        local newX = currentX - (starData.speed * dt * 60)
        if newX < -0.05 then newX = 1.05 star.Position = UDim2.new(newX, 0, math.random(), 0)
        else star.Position = UDim2.new(newX, 0, star.Position.Y.Scale, 0) end
    end
end)

-- Conteúdo interno da Bolha
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2
ContentFrame.Parent = Capsule

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 10)
Layout.Parent = ContentFrame

local PaddingL = Instance.new("UIPadding")
PaddingL.PaddingLeft = UDim.new(0, 7)
PaddingL.Parent = ContentFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 32, 0, 32)
AvatarImage.BackgroundTransparency = 1
AvatarImage.ZIndex = 3
AvatarImage.Parent = ContentFrame
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

task.spawn(function() pcall(function() AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png" end) end)

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 110, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "BK CLIENT V1"
TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 3
TextLabel.Parent = ContentFrame


-- ==========================================
-- MENU CENTRAL FLUTUANTE ULTRA SIMPLIFICADO
-- ==========================================
local CentralMenu = Instance.new("Frame")
CentralMenu.Name = "BK_CentralMenu"
CentralMenu.Size = UDim2.new(0, 520, 0, 320)
CentralMenu.AnchorPoint = Vector2.new(0.5, 0.5)
CentralMenu.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centralizado na Tela
CentralMenu.BackgroundColor3 = MenuBGColor
CentralMenu.BackgroundTransparency = 0 -- Sólido direto para evitar falhas de renderização
CentralMenu.Visible = false -- Controlado apenas pela visibilidade direta
CentralMenu.Active = true
CentralMenu.ClipsDescendants = true
CentralMenu.Parent = ScreenGui

local CentralCorner = Instance.new("UICorner")
CentralCorner.CornerRadius = UDim.new(0, 12)
CentralCorner.Parent = CentralMenu

local CentralStroke = Instance.new("UIStroke")
CentralStroke.Color = BorderColor
CentralStroke.Thickness = 1.5
CentralStroke.Parent = CentralMenu

-- ==========================================
-- HEADER DO MENU (PERFIL + NOME + BK CLIENT)
-- ==========================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = SidebarColor
Header.BorderSizePixel = 0
Header.Parent = CentralMenu

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = SidebarColor
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local HeaderAvatar = AvatarImage:Clone()
HeaderAvatar.Position = UDim2.new(0, 15, 0.5, -16)
HeaderAvatar.Parent = Header

local HeaderName = Instance.new("TextLabel")
HeaderName.Size = UDim2.new(0, 250, 1, 0)
HeaderName.Position = UDim2.new(0, 55, 0, 0)
HeaderName.BackgroundTransparency = 1
HeaderName.Text = LocalPlayer.DisplayName .. " | BK CLIENT V1"
HeaderName.TextColor3 = Color3.fromRGB(240, 240, 240)
HeaderName.TextSize = 14
HeaderName.Font = Enum.Font.GothamBold
HeaderName.TextXAlignment = Enum.TextXAlignment.Left
HeaderName.Parent = Header

-- ==========================================
-- ABAS (GAVETA DO LADO DIREITO) E CONTEÚDO
-- ==========================================
local SidebarRight = Instance.new("Frame")
SidebarRight.Size = UDim2.new(0, 140, 1, -80)
SidebarRight.Position = UDim2.new(1, -140, 0, 50)
SidebarRight.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
SidebarRight.BorderSizePixel = 0
SidebarRight.Parent = CentralMenu

local SidebarBorder = Instance.new("Frame")
SidebarBorder.Size = UDim2.new(0, 1, 1, 0)
SidebarBorder.BackgroundColor3 = BorderColor
SidebarBorder.BorderSizePixel = 0
SidebarBorder.Parent = SidebarRight

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Parent = SidebarRight

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 8)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.VerticalAlignment = Enum.VerticalAlignment.Top
SidebarList.Parent = TabButtonsContainer

local TabPad = Instance.new("UIPadding")
TabPad.PaddingTop = UDim.new(0, 10)
TabPad.Parent = TabButtonsContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 0, 0, 50)
ContentContainer.Size = UDim2.new(1, -140, 1, -80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = CentralMenu

-- ==========================================
-- BARRA DE TELEMETRIA
-- ==========================================
local TelemetryFrame = Instance.new("Frame")
TelemetryFrame.Size = UDim2.new(1, 0, 0, 30)
TelemetryFrame.Position = UDim2.new(0, 0, 1, -30)
TelemetryFrame.BackgroundColor3 = SidebarColor
TelemetryFrame.BorderSizePixel = 0
TelemetryFrame.Parent = CentralMenu

local TelLayout = Instance.new("UIListLayout")
TelLayout.FillDirection = Enum.FillDirection.Horizontal
TelLayout.HorizontalAlignment = Enum.HorizontalAlignment.SpaceAround
TelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TelLayout.Parent = TelemetryFrame

local function createStatLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = TelemetryFrame
    return lbl
end

local FpsLabel = createStatLabel("FPS: --")
local PingLabel = createStatLabel("PING: --ms")
local PlayersLabel = createStatLabel("PLAYERS: --")
local BatteryLabel = createStatLabel("BAT: --%")

local lastTime = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    local curTime = tick()
    if curTime - lastTime >= 1 then
        FpsLabel.Text = "FPS: " .. tostring(math.floor(frameCount / (curTime - lastTime)))
        pcall(function() PingLabel.Text = "PING: " .. tostring(math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())) .. "ms" end)
        pcall(function() PlayersLabel.Text = "PLAYERS: " .. tostring(#Players:GetPlayers()) end)
        pcall(function() 
            local level = UserInputService:GetBatteryLevel()
            BatteryLabel.Text = (level and level > 0) and ("BAT: " .. tostring(math.floor(level * 100)) .. "%") or "BAT: 100%"
        end)
        frameCount = 0
        lastTime = curTime
    end
end)

-- ==========================================
-- CRIADOR DE ABAS (ANIMAÇÕES E SONS)
-- ==========================================
local Tabs = {}
local Pages = {}

local function createTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.85, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 13
    TabBtn.Parent = TabButtonsContainer
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = AccentColor
    BtnStroke.Thickness = 1.2
    BtnStroke.Transparency = 1
    BtnStroke.Parent = TabBtn

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentContainer

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 1, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "ABA [" .. string.upper(name) .. "]\n\n⚡ EM BREVE ⚡\n(INTERDITADA NESTA VERSÃO)"
    InfoLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
    InfoLabel.TextSize = 14
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.Parent = Page

    TabBtn.MouseButton1Click:Connect(function()
        playSound(SOUND_TAB, 0.4, 1.2)
        for _, otherTab in pairs(Tabs) do
            TweenService:Create(otherTab.Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 165), BackgroundTransparency = 1}):Play()
            TweenService:Create(otherTab.Stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        end
        for _, otherPage in pairs(Pages) do otherPage.Visible = false end

        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            BackgroundColor3 = AccentColor
        }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
    end)

    Tabs[name] = {Btn = TabBtn, Stroke = BtnStroke}
    Pages[name] = Page
end

createTab("Visual")
createTab("Mira")
createTab("Configurações")

Tabs["Visual"].Btn.BackgroundTransparency = 0.8
Tabs["Visual"].Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs["Visual"].Btn.BackgroundColor3 = AccentColor
Tabs["Visual"].Stroke.Transparency = 0
Pages["Visual"].Visible = true

-- ==========================================
-- LÓGICA DE INTERRUPTOR DO MENU (DIRETO E SEGURO)
-- ==========================================
local isMenuOpen = false

local function toggleMenu()
    isMenuOpen = not isMenuOpen
    playSound(SOUND_CLICK, 0.6)
    
    if isMenuOpen then
        -- Abre o menu de forma direta e sem frescuras que causam bugs no Delta
        CentralMenu.Visible = true
    else
        -- Fecha o menu instantaneamente
        CentralMenu.Visible = false
    end
end

-- ==========================================
-- CONTROLE DE ARRASTE E TOQUE NA BOLHA
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
        pcall(function()
            Capsule.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            dragging = false
            -- Calcula se foi apenas um clique rápido sem arrastar o dedo
            if (input.Position - dragStart).Magnitude < dragLimit then
                toggleMenu()
            end
        end
    end
end)

print("[BK CLIENT] Versão V2.0 Estável Carregada sem CanvasGroup e pronta para Android!")
