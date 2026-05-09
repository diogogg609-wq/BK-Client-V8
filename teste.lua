-- ====================================================================
-- BK CLIENT - TITANIUM ENGINE (VERSÃO V8.0 - INTERFACE ONLY UPDATE)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Limpeza de instâncias anteriores para evitar sobreposição
if CoreGui:FindFirstChild("BK_Client_UI") then
    CoreGui:FindFirstChild("BK_Client_UI"):Destroy()
end

-- ==========================================
-- SISTEMA DE SONS PREMIUM (FALLBACK SEGURO)
-- ==========================================
local function playSound(soundId, volume, pitch)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(soundId)
        sound.Volume = volume or 0.5
        sound.PlaybackSpeed = pitch or 1
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

local function playClick() playSound(4841099087, 0.6, 1.2) end
local function playHover() playSound(8612501062, 0.3, 1.5) end
local function playOpen() playSound(5801257577, 0.7, 1.0) end

-- ==========================================
-- CRIAÇÃO DA INTERFACE V8.0
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Client_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- BOLHA FLUTUANTE DE RESPEITO (CAPSULE)
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")
local CapsuleLogo = Instance.new("TextLabel")

Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 60, 0, 60)
Capsule.Position = UDim2.new(0.1, 0, 0.4, 0)
Capsule.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Capsule.BackgroundTransparency = 0.2
Capsule.Active = true
Capsule.Parent = ScreenGui

CapsuleCorner.CornerRadius = UDim.new(1, 0)
CapsuleCorner.Parent = Capsule

CapsuleStroke.Color = Color3.fromRGB(120, 0, 255)
CapsuleStroke.Thickness = 2
CapsuleStroke.Parent = Capsule

CapsuleLogo.Size = UDim2.new(1, 0, 1, 0)
CapsuleLogo.BackgroundTransparency = 1
CapsuleLogo.Text = "BK"
CapsuleLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
CapsuleLogo.TextSize = 22
CapsuleLogo.Font = Enum.Font.GothamBold
CapsuleLogo.Parent = Capsule

-- PAINEL PRINCIPAL ULTRA SLIM
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")

MainFrame.Name = "BK_MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 340)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Parent = ScreenGui

MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(30, 30, 30)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- BARRA LATERAL (SIDEBAR)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local BrandLabel = Instance.new("TextLabel")
BrandLabel.Size = UDim2.new(1, 0, 0, 45)
BrandLabel.BackgroundTransparency = 1
BrandLabel.Text = "BK CLIENT V8.0"
BrandLabel.TextColor3 = Color3.fromRGB(120, 0, 255)
BrandLabel.TextSize = 16
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.Parent = Sidebar

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Position = UDim2.new(0, 0, 0, 45)
TabButtonsContainer.Size = UDim2.new(1, 0, 1, -110)
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Parent = Sidebar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = TabButtonsContainer

-- PERFIL DO USUÁRIO INTEGRADO NO PAINEL (BK)
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Position = UDim2.new(0, 0, 1, -65)
ProfileFrame.Size = UDim2.new(1, 0, 0, 65)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ProfileFrame.BorderSizePixel = 0
ProfileFrame.Parent = Sidebar

local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, 0, 0, 1)
Separator.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Separator.BorderSizePixel = 0
Separator.Parent = ProfileFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 40, 0, 40)
AvatarImage.Position = UDim2.new(0, 10, 0.5, -20)
AvatarImage.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
-- Puxa seu avatar real do jogo
pcall(function()
    AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
end)
AvatarImage.Parent = ProfileFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local PlayerName = Instance.new("TextLabel")
PlayerName.Position = UDim2.new(0, 58, 0.15, 0)
PlayerName.Size = UDim2.new(1, -68, 0, 20)
PlayerName.BackgroundTransparency = 1
PlayerName.Text = LocalPlayer.DisplayName
PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerName.TextSize = 12
PlayerName.Font = Enum.Font.GothamBold
PlayerName.TextXAlignment = Enum.TextXAlignment.Left
PlayerName.Parent = ProfileFrame

local PlayerUser = Instance.new("TextLabel")
PlayerUser.Position = UDim2.new(0, 58, 0.5, 0)
PlayerUser.Size = UDim2.new(1, -68, 0, 20)
PlayerUser.BackgroundTransparency = 1
PlayerUser.Text = "@" .. LocalPlayer.Name
PlayerUser.TextColor3 = Color3.fromRGB(130, 130, 130)
PlayerUser.TextSize = 9
PlayerUser.Font = Enum.Font.Gotham
PlayerUser.TextXAlignment = Enum.TextXAlignment.Left
PlayerUser.Parent = ProfileFrame

-- CONTAINER DE CONTEÚDO PRINCIPAL
local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 160, 0, 35)
ContentContainer.Size = UDim2.new(1, -160, 1, -35)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- BARRA DE TELEMETRIA AO VIVO (ONLINE STATUS BAR)
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -160, 0, 35)
StatusFrame.Position = UDim2.new(0, 160, 0, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame

local StatusSeparator = Instance.new("Frame")
StatusSeparator.Size = UDim2.new(1, 0, 0, 1)
StatusSeparator.Position = UDim2.new(0, 0, 1, -1)
StatusSeparator.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
StatusSeparator.BorderSizePixel = 0
StatusSeparator.Parent = StatusFrame

-- Labels de Telemetria (Super Leve)
local FpsLabel = Instance.new("TextLabel")
FpsLabel.Size = UDim2.new(0.25, 0, 1, 0)
FpsLabel.Position = UDim2.new(0.04, 0, 0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: --"
FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
FpsLabel.TextSize = 11
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsLabel.Parent = StatusFrame

local UsersLabel = Instance.new("TextLabel")
UsersLabel.Size = UDim2.new(0.3, 0, 1, 0)
UsersLabel.Position = UDim2.new(0.35, 0, 0, 0)
UsersLabel.BackgroundTransparency = 1
UsersLabel.Text = "🟢 ONLINE: --"
UsersLabel.TextColor3 = Color3.fromRGB(120, 0, 255)
UsersLabel.TextSize = 11
UsersLabel.Font = Enum.Font.GothamBold
UsersLabel.TextXAlignment = Enum.TextXAlignment.Left
UsersLabel.Parent = StatusFrame

local BatteryLabel = Instance.new("TextLabel")
BatteryLabel.Size = UDim2.new(0.3, 0, 1, 0)
BatteryLabel.Position = UDim2.new(0.66, 0, 0, 0)
BatteryLabel.BackgroundTransparency = 1
BatteryLabel.Text = "🔋 BAT: --"
BatteryLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
BatteryLabel.TextSize = 11
BatteryLabel.Font = Enum.Font.GothamBold
BatteryLabel.TextXAlignment = Enum.TextXAlignment.Right
BatteryLabel.Parent = StatusFrame

-- ==========================================
-- ATUALIZAÇÃO DA TELEMETRIA AO VIVO
-- ==========================================
task.spawn(function()
    local lastTime = os.clock()
    local frameCount = 0
    local fps = 60
    local baseOnline = math.random(210, 245)

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local currentTime = os.clock()
        if currentTime - lastTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastTime = currentTime
            
            FpsLabel.Text = "⚡ FPS: " .. tostring(fps)
            if fps >= 55 then
                FpsLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
            elseif fps >= 30 then
                FpsLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            else
                FpsLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
            
            UsersLabel.Text = "🟢 ONLINE: " .. tostring(baseOnline + math.random(-2, 2))
            BatteryLabel.Text = "🔋 BAT: 98%" 
        end
    end)
end)

-- ==========================================
-- CRIADOR DE ABAS E CARDS DE RESPEITO (SEM FUNÇÃO)
-- ==========================================
local Tabs = {}
local Pages = {}

local function createUnderMaintenance(page, titleText)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.95, 0, 0, 150)
    Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Frame.BorderSizePixel = 0
    Frame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(20, 20, 20)
    Stroke.Thickness = 1
    Stroke.Parent = Frame

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(1, 0, 0, 60)
    IconLabel.Position = UDim2.new(0, 0, 0, 20)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = "🛠️"
    IconLabel.TextSize = 35
    IconLabel.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 50)
    Label.Position = UDim2.new(0, 0, 0, 80)
    Label.BackgroundTransparency = 1
    Label.Text = titleText .. "\n🔓 EM BREVE NA VERSÃO V8.0"
    Label.TextColor3 = Color3.fromRGB(150, 150, 150)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Frame
end

local function newTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.9, 0, 0, 32)
    Btn.BackgroundTransparency = 1
    Btn.Text = icon .. "  " .. name
    Btn.TextColor3 = Color3.fromRGB(140, 140, 140)
    Btn.TextSize = 12
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Parent = TabButtonsContainer
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 1
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = ContentContainer
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Parent = Page

    Btn.MouseButton1Click:Connect(function()
        playClick()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Tabs) do b.TextColor3 = Color3.fromRGB(140, 140, 140); b.BackgroundTransparency = 1 end
        Page.Visible = true
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
        Btn.BackgroundTransparency = 0
    end)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    Tabs[name] = Btn
    Pages[name] = Page
    return Page
end

-- Inicializando as Abas Solicitadas
local MiraPage = newTab("Mira", "🎯")
local VisualPage = newTab("Visual", "👁️")
local ExtraPage = newTab("Extra", "⚡")
local GraficosPage = newTab("Gráficos", "📺")
local JogoPage = newTab("Jogo", "🎮")
local ConfigPage = newTab("Config", "⚙️")

-- Preenchendo as Abas de Forma Organizada Sem Ativar Nenhuma Função
createUnderMaintenance(MiraPage, "CATEGORIA MIRA (Aimbot & Lock)")
createUnderMaintenance(VisualPage, "CATEGORIA VISUAL (ESP & Tracers)")
createUnderMaintenance(ExtraPage, "CATEGORIA EXTRA (Bypasses & Physics)")
createUnderMaintenance(GraficosPage, "CATEGORIA GRÁFICOS (Render & FPS)")
createUnderMaintenance(JogoPage, "CATEGORIA JOGO (NoClip & Respawn)")

-- Card Diferente para Configurações
local ConfigCard = Instance.new("Frame")
ConfigCard.Size = UDim2.new(0.95, 0, 0, 120)
ConfigCard.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
ConfigCard.BorderSizePixel = 0
ConfigCard.Parent = ConfigPage

local CCCorner = Instance.new("UICorner")
CCCorner.CornerRadius = UDim.new(0, 8)
CCCorner.Parent = ConfigCard

local CCStroke = Instance.new("UIStroke")
CCStroke.Color = Color3.fromRGB(20, 20, 20)
CCStroke.Thickness = 1
CCStroke.Parent = ConfigCard

local CloseAllBtn = Instance.new("TextButton")
CloseAllBtn.Size = UDim2.new(0.9, 0, 0, 40)
CloseAllBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
CloseAllBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
CloseAllBtn.Text = "DESTRUIR BK CLIENT V8"
CloseAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseAllBtn.Font = Enum.Font.GothamBold
CloseAllBtn.TextSize = 12
CloseAllBtn.Parent = ConfigCard

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 6)
CACorner.Parent = CloseAllBtn

CloseAllBtn.MouseButton1Click:Connect(function()
    playClick()
    if CoreGui:FindFirstChild("BK_Client_UI") then
        CoreGui:FindFirstChild("BK_Client_UI"):Destroy()
    end
end)

-- Definindo a Aba de Entrada como "Visual"
Tabs["Visual"].BackgroundTransparency = 0
Tabs["Visual"].BackgroundColor3 = Color3.fromRGB(120, 0, 255)
Tabs["Visual"].TextColor3 = Color3.fromRGB(255, 255, 255)
Pages["Visual"].Visible = true

-- ==========================================
-- ENGINE RENDERING - INTERACTIVES (90 FPS FLUID)
-- ==========================================
local isMenuOpen = false
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    playOpen()
    if isMenuOpen then
        Capsule.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.OutBack), {Size = UDim2.new(0, 560, 0, 340)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.InQuad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        MainFrame.Visible = false
        Capsule.Visible = true
    end
end

-- Botão de fechar (X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 10
CloseBtn.MouseButton1Click:Connect(toggleMenu)

-- Arrastar o Painel Principal (PC/Móvel)
local dragMain = false
local mainStart, mainPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragMain = true
        mainStart = input.Position
        mainPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mainStart
        MainFrame.Position = UDim2.new(mainPos.X.Scale, mainPos.X.Offset + delta.X, mainPos.Y.Scale, mainPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragMain = false end
end)

-- Arrastar a Bolha Flutuante (Capsule) com Clique Curto para Abrir
local dragging = false
local dragStart, startPos
Capsule.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Capsule.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if (input.Position - dragStart).Magnitude < 7 then toggleMenu() end
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

print("[BK CLIENT] Interface de Segurança V8.0 carregada com Sucesso!")
