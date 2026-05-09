-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V2.4 (O RETORNO DOS EFEITOS ESPECIAIS)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Limpeza absoluta de versões anteriores para evitar duplicidade
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
-- INTERFACE BASE (CAMADA DE TOQUE CORRETA)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Official_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 0

-- Parent seguro na PlayerGui para garantir toques no mobile
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

local CapsuleCorner = Instance.new("UICorner")
CapsuleCorner.CornerRadius = UDim.new(0, 21)
CapsuleCorner.Parent = Capsule

local CapsuleStroke = Instance.new("UIStroke")
CapsuleStroke.Color = BorderColor
CapsuleStroke.Thickness = 1.5
CapsuleStroke.Parent = Capsule

-- ==========================================
-- [EFEITO DE VOLTA] ESTRELAS DESLIZANTES
-- ==========================================
local StarContainer = Instance.new("Frame")
StarContainer.Size = UDim2.new(1, 0, 1, 0)
StarContainer.BackgroundTransparency = 1
StarContainer.ZIndex = 1
StarContainer.Parent = Capsule

local stars = {}
for i = 1, 6 do
    local star = Instance.new("Frame")
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local size = math.random(1, 2)
    star.Size = UDim2.new(0, size, 0, size)
    star.BackgroundTransparency = math.random(3, 7) / 10
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.ZIndex = 2
    star.Parent = StarContainer
    
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = star
    
    table.insert(stars, {frame = star, speed = math.random(10, 25) / 1000})
end

-- Movimento das estrelas sem travar a UI principal
RunService.RenderStepped:Connect(function(dt)
    for _, starData in ipairs(stars) do
        local star = starData.frame
        local currentX = star.Position.X.Scale
        local newX = currentX - (starData.speed * dt * 60)
        if newX < -0.05 then 
            newX = 1.05 
            star.Position = UDim2.new(newX, 0, math.random(), 0)
        else 
            star.Position = UDim2.new(newX, 0, star.Position.Y.Scale, 0) 
        end
    end
end)

-- Nome na Bolha com o Símbolo †
local CapsuleLabel = Instance.new("TextLabel")
CapsuleLabel.Size = UDim2.new(1, 0, 1, 0)
CapsuleLabel.BackgroundTransparency = 1
CapsuleLabel.Text = "BK CLIENT V1 †"
CapsuleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
CapsuleLabel.TextSize = 13
CapsuleLabel.Font = Enum.Font.GothamBold
CapsuleLabel.ZIndex = 3
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
CentralMenu.ClipsDescendants = true
CentralMenu.ZIndex = 5
CentralMenu.Parent = ScreenGui

Instance.new("UICorner", CentralMenu).CornerRadius = UDim.new(0, 12)

local MenuStroke = Instance.new("UIStroke")
MenuStroke.Color = BorderColor
MenuStroke.Thickness = 1.5
MenuStroke.Parent = CentralMenu

-- HEADER (PERFIL DO JOGADOR)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = SidebarColor
Header.BorderSizePixel = 0
Header.ZIndex = 6
Header.Parent = CentralMenu
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
Sidebar.Parent = CentralMenu

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 7
TabContainer.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 6)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.Parent = TabContainer

local TabPad = Instance.new("UIPadding")
TabPad.PaddingTop = UDim.new(0, 10)
TabPad.Parent = TabContainer

-- CONTAINER DE CONTEÚDO (ESQUERDA)
local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 15, 0, 70)
ContentContainer.Size = UDim2.new(1, -160, 1, -85)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 6
ContentContainer.Parent = CentralMenu

-- ==========================================
-- CRIADOR DE ABAS
-- ==========================================
local Tabs = {}
local Pages = {}

local function createTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.85, 0, 0, 36)
    TabBtn.BackgroundColor3 = AccentColor
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 12
    TabBtn.ZIndex = 8
    TabBtn.Parent = TabContainer
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 5)
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = AccentColor
    BtnStroke.Thickness = 1.2
    BtnStroke.Transparency = 1
    BtnStroke.Parent = TabBtn

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ZIndex = 7
    Page.Parent = ContentContainer

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 1, 0)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "ABA [" .. string.upper(name) .. "]\n\n⚡ EM BREVE ⚡\n(INTERDITADA NESTA VERSÃO)"
    InfoLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
    InfoLabel.TextSize = 13
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.ZIndex = 8
    InfoLabel.Parent = Page

    TabBtn.MouseButton1Click:Connect(function()
        playSound("12222076", 0.3)
        for _, otherTab in pairs(Tabs) do
            TweenService:Create(otherTab.Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundTransparency = 1}):Play()
            TweenService:Create(otherTab.Stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        end
        for _, otherPage in pairs(Pages) do 
            otherPage.Visible = false 
        end

        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextColor3 = Color3.fromRGB(255, 255, 255),
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
Tabs["Visual"].Stroke.Transparency = 0.3
Pages["Visual"].Visible = true

-- ==========================================
-- SISTEMA DE ABERTURA E FECHAMENTO ANIMADO
-- ==========================================
local isMenuOpen = false
local menuTransitioning = false

local function toggleMenu()
    if menuTransitioning then return end
    menuTransitioning = true
    isMenuOpen = not isMenuOpen
    playSound("6895086153", 0.5)
    
    if isMenuOpen then
        -- Torna visível mas começa encolhido no meio
        CentralMenu.Size = UDim2.new(0, 0, 0, 0)
        CentralMenu.Visible = true
        
        -- Animação de expansão estilosa (Bounce suave)
        local openTween = TweenService:Create(CentralMenu, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 500, 0, 300)
        })
        openTween:Play()
        openTween.Completed:Connect(function()
            menuTransitioning = false
        end)
    else
        -- Animação de encolhimento antes de sumir
        local closeTween = TweenService:Create(CentralMenu, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            CentralMenu.Visible = false
            menuTransitioning = false
        end)
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

print("[BK CLIENT] Versão V2.4 com Estrelas de fundo e Pop de abertura ativo!")
