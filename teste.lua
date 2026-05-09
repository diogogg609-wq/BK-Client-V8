-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V2.1 (FIX: BOLHA LEVE & INPUT PRIORITÁRIO)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- Limpeza absoluta
pcall(function()
    if CoreGui:FindFirstChild("BK_Official_UI") then
        CoreGui:FindFirstChild("BK_Official_UI"):Destroy()
    end
end)

-- ==========================================
-- SISTEMA DE SONS
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
ScreenGui.DisplayOrder = 99999 -- Garante que fique por cima de tudo

local successParent = pcall(function() ScreenGui.Parent = CoreGui end)
if not successParent then pcall(function() ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end

local BGColor = Color3.fromRGB(10, 10, 12)
local MenuBGColor = Color3.fromRGB(14, 14, 16)
local SidebarColor = Color3.fromRGB(8, 8, 10)
local AccentColor = Color3.fromRGB(110, 60, 220)
local BorderColor = Color3.fromRGB(50, 50, 55)

-- ==========================================
-- CÁPSULA (BOLHA) - AGORA SEM PERFIL PARA NÃO TRAVAR
-- ==========================================
local Capsule = Instance.new("TextButton") -- Usando TextButton para melhor resposta ao toque
Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 160, 0, 42)
Capsule.Position = UDim2.new(0.05, 0, 0.3, 0)
Capsule.BackgroundColor3 = BGColor
Capsule.BorderSizePixel = 0
Capsule.AutoButtonColor = false
Capsule.Text = ""
Capsule.ClipsDescendants = true
Capsule.Parent = ScreenGui

local CapsuleCorner = Instance.new("UICorner")
CapsuleCorner.CornerRadius = UDim.new(0, 21)
CapsuleCorner.Parent = Capsule

local CapsuleStroke = Instance.new("UIStroke")
CapsuleStroke.Color = BorderColor
CapsuleStroke.Thickness = 1.5
CapsuleStroke.Parent = Capsule

-- Efeito de Estrelas na Bolha (Animação de fundo)
local StarContainer = Instance.new("Frame")
StarContainer.Size = UDim2.new(1, 0, 1, 0)
StarContainer.BackgroundTransparency = 1
StarContainer.Parent = Capsule

for i = 1, 6 do
    local star = Instance.new("Frame")
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.Size = UDim2.new(0, 2, 0, 2)
    star.BackgroundTransparency = 0.5
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.Parent = StarContainer
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        while task.wait(math.random(2, 5)) do
            if not Capsule then break end
            TweenService:Create(star, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
            task.wait(1)
            star.Position = UDim2.new(math.random(), 0, math.random(), 0)
            TweenService:Create(star, TweenInfo.new(1), {BackgroundTransparency = 0.5}):Play()
        end
    end)
end

-- Nome na Bolha com o Símbolo †
local CapsuleLabel = Instance.new("TextLabel")
CapsuleLabel.Size = UDim2.new(1, 0, 1, 0)
CapsuleLabel.BackgroundTransparency = 1
CapsuleLabel.Text = "BK CLIENT V1 †"
CapsuleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
CapsuleLabel.TextSize = 13
CapsuleLabel.Font = Enum.Font.GothamBold
CapsuleLabel.Parent = Capsule

-- ==========================================
-- MENU CENTRAL FLUTUANTE
-- ==========================================
local CentralMenu = Instance.new("Frame")
CentralMenu.Name = "BK_CentralMenu"
CentralMenu.Size = UDim2.new(0, 500, 0, 300)
CentralMenu.AnchorPoint = Vector2.new(0.5, 0.5)
CentralMenu.Position = UDim2.new(0.5, 0, 0.5, 0)
CentralMenu.BackgroundColor3 = MenuBGColor
CentralMenu.Visible = false
CentralMenu.Active = true
CentralMenu.Parent = ScreenGui

Instance.new("UICorner", CentralMenu).CornerRadius = UDim.new(0, 12)
local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = BorderColor
MenuStroke.Thickness = 1.5
MenuStroke.Parent = CentralMenu

-- HEADER (ONDE O PERFIL FICA AGORA)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = SidebarColor
Header.BorderSizePixel = 0
Header.Parent = CentralMenu
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderAvatar = Instance.new("ImageLabel")
HeaderAvatar.Size = UDim2.new(0, 38, 0, 38)
HeaderAvatar.Position = UDim2.new(0, 15, 0.5, -19)
HeaderAvatar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
HeaderAvatar.BorderSizePixel = 0
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
HeaderTitle.Parent = Header

-- ABAS (GAVETA DIREITA)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -85)
Sidebar.Position = UDim2.new(1, -130, 0, 55)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = CentralMenu

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 5)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 10, 0, 65)
ContentContainer.Size = UDim2.new(1, -150, 1, -105)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = CentralMenu

-- TELEMETRIA (DADOS REAIS)
local Telemetry = Instance.new("Frame")
Telemetry.Size = UDim2.new(1, 0, 0, 30)
Telemetry.Position = UDim2.new(0, 0, 1, -30)
Telemetry.BackgroundColor3 = SidebarColor
Telemetry.BorderSizePixel = 0
Telemetry.Parent = CentralMenu

local TelLayout = Instance.new("UIListLayout")
TelLayout.FillDirection = Enum.FillDirection.Horizontal
TelLayout.HorizontalAlignment = Enum.HorizontalAlignment.SpaceAround
TelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TelLayout.Parent = Telemetry

local function createStat(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 80, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(150, 150, 150)
    l.TextSize = 10
    l.Font = Enum.Font.GothamSemibold
    l.Parent = Telemetry
    return l
end

local FpsL = createStat("FPS: --")
local PingL = createStat("PING: --")
local PlayerL = createStat("ONLINE: --")

task.spawn(function()
    while task.wait(1) do
        if not CentralMenu then break end
        FpsL.Text = "FPS: " .. math.floor(1/RunService.RenderStepped:Wait())
        PingL.Text = "PING: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms"
        PlayerL.Text = "ONLINE: " .. #Players:GetPlayers()
    end
end)

-- ==========================================
-- CRIADOR DE ABAS
-- ==========================================
local function createTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.BackgroundColor3 = AccentColor
    b.BackgroundTransparency = 1
    b.Text = name
    b.TextColor3 = Color3.fromRGB(150, 150, 150)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 12
    b.Parent = TabContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    
    local page = Instance.new("TextLabel")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Text = "[" .. name .. "] EM BREVE..."
    page.TextColor3 = Color3.fromRGB(80, 80, 85)
    page.Font = Enum.Font.GothamBold
    page.Visible = false
    page.Parent = ContentContainer

    b.MouseButton1Click:Connect(function()
        playSound("12222076", 0.3)
        for _, v in pairs(TabContainer:GetChildren()) do
            if v:IsA("TextButton") then 
                TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end
        end
        for _, v in pairs(ContentContainer:GetChildren()) do v.Visible = false end
        page.Visible = true
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
end

createTab("Visual")
createTab("Mira")
createTab("Configurações")

-- ==========================================
-- SISTEMA DE ARRASTE E CLIQUE (RECONSTRUÍDO)
-- ==========================================
local isMenuOpen = false
local dragStart, startPos
local dragging = false

Capsule.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Capsule.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Capsule.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Clique para abrir/fechar (Separado do arraste para não travar)
Capsule.MouseButton1Click:Connect(function()
    if dragging then return end -- Se estiver arrastando, não clica
    isMenuOpen = not isMenuOpen
    playSound("6895086153", 0.5)
    
    if isMenuOpen then
        CentralMenu.Visible = true
        CentralMenu.Size = UDim2.new(0, 450, 0, 250)
        TweenService:Create(CentralMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 500, 0, 300)}):Play()
    else
        CentralMenu.Visible = false
    end
end)

-- Regra Número 1: Executado com sucesso.
print("[BK CLIENT] Sistema V2.1 Ativo e Calibrado.")
