-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V1.8 (CORREÇÃO DE ARRASTE E TOQUE NO ANDROID)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- Limpeza absoluta de qualquer versão anterior para evitar conflitos
pcall(function()
    if CoreGui:FindFirstChild("BK_Official_UI") then
        CoreGui:FindFirstChild("BK_Official_UI"):Destroy()
    end
end)

-- ==========================================
-- SISTEMA DE NOTIFICAÇÃO DE INICIALIZAÇÃO
-- ==========================================
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "BK CLIENT V1",
        Text = "SCRIPT BK CLIENT V1 ATIVO",
        Icon = "rbxassetid://6031094028",
        Duration = 5
    })
end)

-- ==========================================
-- CRIAÇÃO DA INTERFACE BASE (V1)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Official_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local successParent = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not successParent then
    pcall(function()
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end

-- Variáveis de Tamanho e Cores
local CAPSULE_NORMAL_SIZE = UDim2.new(0, 180, 0, 46)
local CAPSULE_MINI_SIZE = UDim2.new(0, 46, 0, 46)

local BGColor = Color3.fromRGB(10, 10, 12)
local MenuBGColor = Color3.fromRGB(14, 14, 16)
local SidebarColor = Color3.fromRGB(8, 8, 10)
local AccentColor = Color3.fromRGB(110, 60, 220) -- Roxo Principal
local BorderColor = Color3.fromRGB(50, 50, 55)

-- ==========================================
-- CÁPSULA FLUTUANTE (FUNDO SÓLIDO ESPACIAL)
-- ==========================================
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")

Capsule.Name = "BK_Capsule"
Capsule.Size = CAPSULE_NORMAL_SIZE
Capsule.Position = UDim2.new(0.05, 0, 0.3, 0)
Capsule.BackgroundColor3 = BGColor
Capsule.BackgroundTransparency = 0
Capsule.Active = true
Capsule.ClipsDescendants = true
Capsule.Parent = ScreenGui

CapsuleCorner.CornerRadius = UDim.new(0, 23)
CapsuleCorner.Parent = Capsule

CapsuleStroke.Color = BorderColor
CapsuleStroke.Thickness = 1.5
CapsuleStroke.Parent = Capsule

-- ==========================================
-- SISTEMA DE PARTÍCULAS ESPACIAIS (STARFIELD)
-- ==========================================
local StarContainer = Instance.new("Frame")
StarContainer.Name = "StarContainer"
StarContainer.Size = UDim2.new(1, 0, 1, 0)
StarContainer.BackgroundTransparency = 1
StarContainer.ZIndex = 1
StarContainer.Parent = Capsule

local stars = {}
for i = 1, 8 do
    local star = Instance.new("Frame")
    star.Name = "Star" .. i
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local size = math.random(1, 3)
    star.Size = UDim2.new(0, size, 0, size)
    star.BackgroundTransparency = math.random(2, 6) / 10
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.ZIndex = 1
    star.Parent = StarContainer
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = star
    local speed = math.random(10, 30) / 1000
    table.insert(stars, {frame = star, speed = speed})
end

RunService.RenderStepped:Connect(function(dt)
    for _, starData in ipairs(stars) do
        local star = starData.frame
        local speed = starData.speed
        local currentX = star.Position.X.Scale
        local newX = currentX - (speed * dt * 60)
        if newX < -0.05 then
            newX = 1.05
            star.Position = UDim2.new(newX, 0, math.random(), 0)
        else
            star.Position = UDim2.new(newX, 0, star.Position.Y.Scale, 0)
        end
    end
end)

-- ==========================================
-- CONTEÚDO DA CÁPSULA (AVATAR E TEXTO)
-- ==========================================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2
ContentFrame.Parent = Capsule

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 10)
Layout.Parent = ContentFrame

local PaddingL = Instance.new("UIPadding")
PaddingL.PaddingLeft = UDim.new(0, 7)
PaddingL.Parent = ContentFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(0, 32, 0, 32)
AvatarImage.BackgroundTransparency = 1
AvatarImage.BorderSizePixel = 0
AvatarImage.ZIndex = 3
AvatarImage.Parent = ContentFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

task.spawn(function()
    pcall(function()
        AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    end)
end)

local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
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
-- PAINEL PRINCIPAL INDEPENDENTE (PASSO 3)
-- ==========================================
local MainMenu = Instance.new("Frame")
local MenuCorner = Instance.new("UICorner")
local MenuStroke = Instance.new("UIStroke")

MainMenu.Name = "BK_MainMenu"
MainMenu.Size = UDim2.new(0, 480, 0, 280)
MainMenu.Position = UDim2.new(0, 0, 0, 60) -- Alinhado abaixo da cápsula
MainMenu.BackgroundColor3 = MenuBGColor
MainMenu.BackgroundTransparency = 1
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Parent = Capsule -- Segue a cápsula automaticamente no arraste

MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = MainMenu

MenuStroke.Color = BorderColor
MenuStroke.Thickness = 1.2
MenuStroke.Transparency = 1
MenuStroke.Parent = MainMenu

-- GAVETA / SIDEBAR ESQUERDA (BOTÕES DE ABAS)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -30)
Sidebar.BackgroundColor3 = SidebarColor
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainMenu

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.VerticalAlignment = Enum.VerticalAlignment.Center
SidebarList.Parent = TabButtonsContainer

-- CONTAINER DE CONTEÚDO (DIREITA)
local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 150, 0, 10)
ContentContainer.Size = UDim2.new(1, -160, 1, -50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainMenu

-- ==========================================
-- BARRA DE TELEMETRIA (DADOS REAIS)
-- ==========================================
local TelemetryFrame = Instance.new("Frame")
TelemetryFrame.Size = UDim2.new(1, 0, 0, 30)
TelemetryFrame.Position = UDim2.new(0, 0, 1, -30)
TelemetryFrame.BackgroundColor3 = SidebarColor
TelemetryFrame.BorderSizePixel = 0
TelemetryFrame.Parent = MainMenu

local TelemetryCorner = Instance.new("UICorner")
TelemetryCorner.CornerRadius = UDim.new(0, 10)
TelemetryCorner.Parent = TelemetryFrame

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
    lbl.TextSize = 10
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
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            PingLabel.Text = "PING: " .. tostring(ping) .. "ms"
        end)
        pcall(function()
            PlayersLabel.Text = "PLAYERS: " .. tostring(#Players:GetPlayers())
        end)
        local batSuccess = pcall(function()
            local level = UserInputService:GetBatteryLevel()
            if level and level > 0 then
                BatteryLabel.Text = "BAT: " .. tostring(math.floor(level * 100)) .. "%"
            else
                BatteryLabel.Text = "BAT: 100%"
            end
        end)
        if not batSuccess then BatteryLabel.Text = "BAT: N/A" end
        frameCount = 0
        lastTime = curTime
    end
end)

-- ==========================================
-- CRIADOR DE ABAS
-- ==========================================
local Tabs = {}
local Pages = {}

local function createTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 36)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 12
    TabBtn.Parent = TabButtonsContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabBtn
    
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
    InfoLabel.TextSize = 12
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.Parent = Page

    TabBtn.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(Tabs) do
            TweenService:Create(otherTab.Btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(160, 160, 165),
                BackgroundColor3 = Color3.fromRGB(20, 20, 25),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(otherTab.Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
        end
        for _, otherPage in pairs(Pages) do
            otherPage.Visible = false
        end

        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = AccentColor,
            BackgroundTransparency = 0.8
        }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.25), {Transparency = 0.3}):Play()
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
Tabs["Visual"].Stroke.Transparency = 0.3
Pages["Visual"].Visible = true

-- ==========================================
-- LÓGICA DE INTERRUPTOR DO MENU (TWEEN)
-- ==========================================
local isMenuOpen = false

local function toggleMenu()
    isMenuOpen = not isMenuOpen
    
    if isMenuOpen then
        TweenService:Create(Capsule, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = CAPSULE_MINI_SIZE
        }):Play()
        
        TweenService:Create(TextLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 1
        }):Play()
        
        MainMenu.Visible = true
        TweenService:Create(MainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(MenuStroke, TweenInfo.new(0.3), {
            Transparency = 0
        }):Play()
    else
        local menuTween = TweenService:Create(MainMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        TweenService:Create(MenuStroke, TweenInfo.new(0.2), {
            Transparency = 1
        }):Play()
        
        menuTween:Play()
        menuTween.Completed:Connect(function()
            if not isMenuOpen then
                MainMenu.Visible = false
            end
        end)
        
        TweenService:Create(Capsule, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = CAPSULE_NORMAL_SIZE
        }):Play()
        
        TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
    end
end

-- ==========================================
-- NOVO SISTEMA DE ARRASTE + CLIQUE SEPARADO (BLINDADO)
-- ==========================================
local dragging = false
local dragStart, startPos
local dragLimit = 6 -- Tolerância de movimento (pixels) para diferenciar arraste de clique

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
            Capsule.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            dragging = false
            local dragDistance = (input.Position - dragStart).Magnitude
            -- Se mover menos do que o limite de pixels, detecta como um CLIQUE real!
            if dragDistance < dragLimit then
                toggleMenu()
            end
        end
    end
end)

print("[BK CLIENT] Passo 3 Corrigido: Arraste e cliques 100% calibrados!")
