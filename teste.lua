-- ====================================================================
-- BK CLIENT - TITANIUM ENGINE (VERSÃO V8.3 - ANDROID & DELTA STABILITY)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- Limpeza de instâncias anteriores com tratamento de erro
pcall(function()
    if CoreGui:FindFirstChild("BK_Client_UI") then
        CoreGui:FindFirstChild("BK_Client_UI"):Destroy()
    end
end)

-- ==========================================
-- SISTEMA DE SONS SATISFATÓRIOS (COM FALLBACK)
-- ==========================================
local function playSound(soundId, volume, pitch)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. tostring(soundId)
        sound.Volume = volume or 0.4
        sound.PlaybackSpeed = pitch or 1
        sound.Parent = SoundService
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
    end)
end

local function playClick() playSound(6042053626, 0.5, 1.1) end
local function playOpen() playSound(6895079853, 0.6, 1.0) end

-- Paleta Dark Minimalista
local AccentColor = Color3.fromRGB(90, 60, 160)
local BGColor = Color3.fromRGB(15, 15, 15)
local SidebarColor = Color3.fromRGB(10, 10, 10)

-- ==========================================
-- CRIAÇÃO DA INTERFACE V8.3
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BK_Client_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    ScreenGui.Parent = CoreGui
end)

-- BOLHA FLUTUANTE V8.3 (CAPSULE)
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")

Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 55, 0, 55)
Capsule.Position = UDim2.new(0.05, 0, 0.4, 0)
Capsule.BackgroundColor3 = SidebarColor
Capsule.BackgroundTransparency = 0.1
Capsule.Active = true
Capsule.Parent = ScreenGui

CapsuleCorner.CornerRadius = UDim.new(1, 0)
CapsuleCorner.Parent = Capsule

CapsuleStroke.Color = AccentColor
CapsuleStroke.Thickness = 1.5
CapsuleStroke.Parent = Capsule

local CapsuleLogo = Instance.new("TextLabel")
CapsuleLogo.Size = UDim2.new(1, 0, 0.6, 0)
CapsuleLogo.Position = UDim2.new(0, 0, 0.1, 0)
CapsuleLogo.BackgroundTransparency = 1
CapsuleLogo.Text = "BK"
CapsuleLogo.TextColor3 = Color3.fromRGB(255, 255, 255)
CapsuleLogo.TextSize = 20
CapsuleLogo.Font = Enum.Font.GothamBold
CapsuleLogo.Parent = Capsule

local CapsuleVersion = Instance.new("TextLabel")
CapsuleVersion.Size = UDim2.new(1, 0, 0.3, 0)
CapsuleVersion.Position = UDim2.new(0, 0, 0.6, 0)
CapsuleVersion.BackgroundTransparency = 1
CapsuleVersion.Text = "V8.3"
CapsuleVersion.TextColor3 = AccentColor
CapsuleVersion.TextSize = 10
CapsuleVersion.Font = Enum.Font.GothamSemibold
CapsuleVersion.Parent = Capsule

-- PAINEL PRINCIPAL (ESTILO PC GRANDE)
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")

MainFrame.Name = "BK_MainFrame"
MainFrame.Size = UDim2.new(0, 640, 0, 380)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -190)
MainFrame.BackgroundColor3 = BGColor
MainFrame.BackgroundTransparency = 1
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Parent = ScreenGui

MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

MainStroke.Color = Color3.fromRGB(35, 35, 35)
MainStroke.Thickness = 1
MainStroke.Transparency = 1
MainStroke.Parent = MainFrame

-- BARRA LATERAL (SIDEBAR)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = SidebarColor
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local BrandLabel = Instance.new("TextLabel")
BrandLabel.Size = UDim2.new(1, 0, 0, 50)
BrandLabel.BackgroundTransparency = 1
BrandLabel.Text = "BK CLIENT"
BrandLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
BrandLabel.TextSize = 18
BrandLabel.Font = Enum.Font.GothamBold
BrandLabel.Parent = Sidebar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1, 0, 0, 15)
VersionLabel.Position = UDim2.new(0, 0, 0, 35)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "Build V8.3"
VersionLabel.TextColor3 = AccentColor
VersionLabel.TextSize = 11
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.Parent = Sidebar

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Position = UDim2.new(0, 0, 0, 65)
TabButtonsContainer.Size = UDim2.new(1, 0, 1, -130)
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Parent = Sidebar

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = TabButtonsContainer

-- PERFIL DO USUÁRIO INTEGRADO
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Position = UDim2.new(0, 0, 1, -65)
ProfileFrame.Size = UDim2.new(1, 0, 0, 65)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
ProfileFrame.BorderSizePixel = 0
ProfileFrame.Parent = Sidebar

local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, 0, 0, 1)
Separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Separator.BorderSizePixel = 0
Separator.Parent = ProfileFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 36, 0, 36)
AvatarImage.Position = UDim2.new(0, 12, 0.5, -18)
AvatarImage.BackgroundColor3 = BGColor
AvatarImage.Parent = ProfileFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

-- Carregamento seguro do Avatar para evitar travamento no Delta
task.spawn(function()
    pcall(function()
        AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    end)
end)

local PlayerName = Instance.new("TextLabel")
PlayerName.Position = UDim2.new(0, 58, 0.2, 0)
PlayerName.Size = UDim2.new(1, -68, 0, 18)
PlayerName.BackgroundTransparency = 1
PlayerName.Text = LocalPlayer.DisplayName or "Usuário"
PlayerName.TextColor3 = Color3.fromRGB(230, 230, 230)
PlayerName.TextSize = 13
PlayerName.Font = Enum.Font.GothamBold
PlayerName.TextXAlignment = Enum.TextXAlignment.Left
PlayerName.Parent = ProfileFrame

local PlayerUser = Instance.new("TextLabel")
PlayerUser.Position = UDim2.new(0, 58, 0.5, 0)
PlayerUser.Size = UDim2.new(1, -68, 0, 18)
PlayerUser.BackgroundTransparency = 1
PlayerUser.Text = "@" .. (LocalPlayer.Name or "Roblox")
PlayerUser.TextColor3 = Color3.fromRGB(120, 120, 120)
PlayerUser.TextSize = 10
PlayerUser.Font = Enum.Font.Gotham
PlayerUser.TextXAlignment = Enum.TextXAlignment.Left
PlayerUser.Parent = ProfileFrame

-- CONTAINER DE CONTEÚDO PRINCIPAL
local ContentContainer = Instance.new("Frame")
ContentContainer.Position = UDim2.new(0, 180, 0, 40)
ContentContainer.Size = UDim2.new(1, -180, 1, -40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- BARRA DE TELEMETRIA AO VIVO (DADOS REAIS PROTEGIDOS)
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, -180, 0, 40)
StatusFrame.Position = UDim2.new(0, 180, 0, 0)
StatusFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
StatusFrame.BorderSizePixel = 0
StatusFrame.Parent = MainFrame

local StatusSeparator = Instance.new("Frame")
StatusSeparator.Size = UDim2.new(1, 0, 0, 1)
StatusSeparator.Position = UDim2.new(0, 0, 1, -1)
StatusSeparator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
StatusSeparator.BorderSizePixel = 0
StatusSeparator.Parent = StatusFrame

local function createStatusLabel(posX, text, align)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.25, 0, 1, 0)
    lbl.Position = UDim2.new(posX, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextXAlignment = align
    lbl.Parent = StatusFrame
    return lbl
end

local FpsLabel = createStatusLabel(0.04, "FPS: --", Enum.TextXAlignment.Left)
local PingLabel = createStatusLabel(0.28, "PING: --ms", Enum.TextXAlignment.Left)
local UsersLabel = createStatusLabel(0.52, "JOGADORES: --", Enum.TextXAlignment.Left)
local BatteryLabel = createStatusLabel(0.72, "BAT: --%", Enum.TextXAlignment.Right)

-- ==========================================
-- ATUALIZAÇÃO DA TELEMETRIA REAL COM PROTEÇÃO
-- ==========================================
local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function(deltaTime)
    frameCount = frameCount + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        -- 1. FPS Real Otimizado
        local realFps = math.floor(frameCount / (currentTime - lastTime))
        FpsLabel.Text = "FPS: " .. tostring(realFps)
        
        -- 2. Ping Real com Fallback caso API de Stats falhe no Delta
        pcall(function()
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            PingLabel.Text = "PING: " .. tostring(ping) .. "ms"
        end)
        
        -- 3. Jogadores Seguros
        pcall(function()
            UsersLabel.Text = "JOGADORES: " .. tostring(#Players:GetPlayers())
        end)
        
        -- 4. Bateria Segura (Super Importante para Android)
        local batSuccess = pcall(function()
            local batLevel = UserInputService:GetBatteryLevel()
            if batLevel and batLevel > 0 then
                BatteryLabel.Text = "BAT: " .. tostring(math.floor(batLevel * 100)) .. "%"
            else
                BatteryLabel.Text = "BAT: 100%"
            end
        end)
        if not batSuccess then
            BatteryLabel.Text = "BAT: N/A"
        end
        
        frameCount = 0
        lastTime = currentTime
    end
end)

-- ==========================================
-- CRIADOR DE ABAS E CARDS (PROTEGIDO)
-- ==========================================
local Tabs = {}
local Pages = {}

local function newTab(name, iconId)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.85, 0, 0, 36)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = TabButtonsContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 18, 0, 18)
    Icon.Position = UDim2.new(0, 15, 0.5, -9)
    Icon.BackgroundTransparency = 1
    Icon.Image = iconId
    Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    Icon.Parent = Btn
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 40, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(150, 150, 150)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -30, 1, -20)
    Page.Position = UDim2.new(0, 15, 0, 10)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Parent = ContentContainer
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 10)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Parent = Page

    Btn.MouseButton1Click:Connect(function()
        playClick()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(Tabs) do 
            b.Btn.BackgroundTransparency = 1
            b.Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            b.Label.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        Page.Visible = true
        Btn.BackgroundTransparency = 0.8
        Btn.BackgroundColor3 = AccentColor
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    Tabs[name] = {Btn = Btn, Icon = Icon, Label = Label}
    Pages[name] = Page
    return Page
end

-- Inicializando as Abas
local MiraPage = newTab("Mira", "rbxassetid://6031225818")
local VisualPage = newTab("Visual", "rbxassetid://6031302856")
local ExtraPage = newTab("Extra", "rbxassetid://6031280882")
local GraficosPage = newTab("Gráficos", "rbxassetid://6031280036")
local JogoPage = newTab("Jogo", "rbxassetid://6031224376")
local ConfigPage = newTab("Configurações", "rbxassetid://6031075956")

local function createUnderMaintenance(page, titleText)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 160)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 0
    Frame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 35, 35)
    Stroke.Parent = Frame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0.5, -20, 0, 30)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://6031094028"
    Icon.ImageColor3 = AccentColor
    Icon.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 50)
    Label.Position = UDim2.new(0, 0, 0, 80)
    Label.BackgroundTransparency = 1
    Label.Text = titleText .. "\nFUNÇÕES EM DESENVOLVIMENTO PARA A V8.3"
    Label.TextColor3 = Color3.fromRGB(160, 160, 160)
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamSemibold
    Label.Parent = Frame
end

createUnderMaintenance(MiraPage, "SISTEMA DE MIRA")
createUnderMaintenance(VisualPage, "SISTEMA VISUAL (ESP)")
createUnderMaintenance(ExtraPage, "SISTEMA DE BYPASS E FÍSICA")
createUnderMaintenance(GraficosPage, "SISTEMA DE OTIMIZAÇÃO GRÁFICA")
createUnderMaintenance(JogoPage, "SISTEMA DE JOGO E UTILITÁRIOS")

-- ==========================================
-- ABA DE CONFIGURAÇÕES & SUPORTE
-- ==========================================
local ConfigCard = Instance.new("Frame")
ConfigCard.Size = UDim2.new(1, 0, 0, 200)
ConfigCard.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
ConfigCard.BorderSizePixel = 0
ConfigCard.Parent = ConfigPage

local CCCorner = Instance.new("UICorner")
CCCorner.CornerRadius = UDim.new(0, 6)
CCCorner.Parent = ConfigCard

local CCStroke = Instance.new("UIStroke")
CCStroke.Color = Color3.fromRGB(35, 35, 35)
CCStroke.Parent = ConfigCard

local SupportBtn = Instance.new("TextButton")
SupportBtn.Size = UDim2.new(0.9, 0, 0, 45)
SupportBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
SupportBtn.BackgroundColor3 = AccentColor
SupportBtn.Text = "FALAR COM SUPORTE (COPIAR NÚMERO)"
SupportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SupportBtn.Font = Enum.Font.GothamBold
SupportBtn.TextSize = 13
SupportBtn.Parent = ConfigCard

local SupportCorner = Instance.new("UICorner")
SupportCorner.CornerRadius = UDim.new(0, 6)
SupportCorner.Parent = SupportBtn

SupportBtn.MouseButton1Click:Connect(function()
    playClick()
    if setclipboard then
        setclipboard("49991510649")
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "BK V8.3 Suporte",
                Text = "Número copiado com sucesso: 49991510649. Cole no seu WhatsApp!",
                Duration = 5
            })
        end)
    else
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "BK V8.3",
                Text = "Erro na cópia automática. Salve o contato: 49991510649",
                Duration = 7
            })
        end)
    end
end)

local CloseAllBtn = Instance.new("TextButton")
CloseAllBtn.Size = UDim2.new(0.9, 0, 0, 45)
CloseAllBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
CloseAllBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseAllBtn.Text = "DESTRUIR PAINEL BK"
CloseAllBtn.TextColor3 = Color3.fromRGB(200, 50, 50)
CloseAllBtn.Font = Enum.Font.GothamBold
CloseAllBtn.TextSize = 13
CloseAllBtn.Parent = ConfigCard

local CACorner = Instance.new("UICorner")
CACorner.CornerRadius = UDim.new(0, 6)
CACorner.Parent = CloseAllBtn

CloseAllBtn.MouseButton1Click:Connect(function()
    playClick()
    pcall(function()
        if CoreGui:FindFirstChild("BK_Client_UI") then
            CoreGui:FindFirstChild("BK_Client_UI"):Destroy()
        end
    end)
end)

-- Definindo Aba Inicial
Tabs["Visual"].Btn.BackgroundTransparency = 0.8
Tabs["Visual"].Btn.BackgroundColor3 = AccentColor
Tabs["Visual"].Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
Tabs["Visual"].Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Pages["Visual"].Visible = true

-- ==========================================
-- SISTEMA DE ABERTURA E ARRASTE (TRANSIÇÕES)
-- ==========================================
local isMenuOpen = false

local function toggleMenu()
    isMenuOpen = not isMenuOpen
    playOpen()
    if isMenuOpen then
        Capsule.Visible = false
        MainFrame.Visible = true
        pcall(function()
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
        end)
    else
        local tween
        pcall(function()
            tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
            TweenService:Create(MainStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        end)
        if tween then
            tween:Play()
            tween.Completed:Connect(function()
                if not isMenuOpen then
                    MainFrame.Visible = false
                    Capsule.Visible = true
                end
            end)
        else
            MainFrame.Visible = false
            Capsule.Visible = true
        end
    end
end

-- Botão de Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.Font = Enum.Font.GothamSemibold
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(toggleMenu)

-- ARRASTE UNIVERSAL OTIMIZADO PARA CELULAR
local function makeDraggable(frame)
    local dragStart, startPos
    local dragging = false
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            pcall(function()
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInp
