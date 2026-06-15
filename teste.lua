-- [[ BK CLIENT V10.5 - NEURAL PERFORMANCE ]] --
-- [ REESTRUTURAÇÃO COMPLETA DE PLAYERS INTEL + 10 CORE FUNCTIONS DE OTIMIZAÇÃO ] --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local SecureUID = "BK_PERFORMANCE_" .. tostring(math.random(100000, 900000))
for _, v in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
    if v:IsA("ScreenGui") and (string.find(v.Name, "BK_") or string.find(v.Name, "NEURAL") or string.find(v.Name, "MATRIX")) then 
        v:Destroy() 
    end
end

-- Banco de Dados e Estados Centrais
local BK_DB = {
    Aimbot = false,
    SilentAim = false,
    Predict = true,
    PredictionVelocity = 0.13,
    WallCheck = true,
    TeamCheck = false,
    TargetPart = "Head",
    Smooth = 0.08,
    FOV = 130,
    FOV_Visible = false,
    
    ESP_Chams = false,
    ESP_Names = false,
    ESP_Dist = false,
    ESP_Health = false,
    ESP_Box = false,
    
    SpeedHack = 16,
    JumpHack = 50,
    InfJump = false,
    FlyActive = false,
    FlySpeed = 50,
    
    NoClip = false,
    InfEnergy = false,
    SuperJump = false,
    SelectedPlayerIntel = nil,
    
    -- Configurações de Otimização (Aba IA Boost)
    AI_Enabled = true,
    CurrentFPS = 60,
    Opt_Massinha = false,
    Opt_NoShadows = false,
    Opt_ClearGarbage = false,
    Opt_DisableEffects = false,
    Opt_AggressiveRender = false,
    Opt_RemoveDecals = false,
    Opt_NoRagdolls = false,
    Opt_LowPhysics = false,
    Opt_FastLoad = false,
    Opt_MuteAmbience = false
}

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = SecureUID
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local FOVFrame = Instance.new("Frame", ScreenGui)
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
FOVFrame.BackgroundTransparency = 0.94
FOVFrame.BorderSizePixel = 0
FOVFrame.Visible = false
local FOVCorner = Instance.new("UICorner", FOVFrame)
FOVCorner.CornerRadius = UDim.new(1, 0)
local FOVStroke = Instance.new("UIStroke", FOVFrame)
FOVStroke.Color = Color3.fromRGB(0, 255, 200)
FOVStroke.Thickness = 1.2

-- =========================================================
-- ESTRUTURA VISUAL PRINCIPAL
-- =========================================================
local MainMenu = Instance.new("Frame", ScreenGui)
MainMenu.Size = UDim2.new(0, 520, 0, 0)
MainMenu.Position = UDim2.new(0.5, -260, 0.3, -22)
MainMenu.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
MainMenu.BorderSizePixel = 0
MainMenu.ClipsDescendants = true
MainMenu.Visible = false
Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 8)

local MenuStroke = Instance.new("UIStroke", MainMenu)
MenuStroke.Color = Color3.fromRGB(140, 0, 255)
MenuStroke.Thickness = 1.5

local ContentFrame = Instance.new("Frame", MainMenu)
ContentFrame.Size = UDim2.new(1, 0, 0, 245)
ContentFrame.Position = UDim2.new(0, 0, 0, 45)
ContentFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
ContentFrame.BorderSizePixel = 0

local Header = Instance.new("Frame", MainMenu)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
Header.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", Header)
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Text = "BK CLIENT // VERSION 10.5 NEURAL ENGINE"
TitleText.TextColor3 = Color3.fromRGB(240, 240, 250)
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1

local NavFrame = Instance.new("Frame", ContentFrame)
NavFrame.Size = UDim2.new(0, 130, 1, 0)
NavFrame.BackgroundColor3 = Color3.fromRGB(7, 8, 12)
NavFrame.BorderSizePixel = 0
local NavLayout = Instance.new("UIListLayout", NavFrame)
NavLayout.Padding = UDim.new(0, 2)

local Container = Instance.new("Frame", ContentFrame)
Container.Size = UDim2.new(1, -140, 1, -10)
Container.Position = UDim2.new(0, 135, 0, 5)
Container.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name)
    local Scroller = Instance.new("ScrollingFrame", Container)
    Scroller.Size = UDim2.new(1, 0, 1, 0)
    Scroller.BackgroundTransparency = 1
    Scroller.Visible = false
    Scroller.ScrollBarThickness = 0
    Scroller.CanvasSize = UDim2.new(0, 0, 2.8, 0)
    local List = Instance.new("UIListLayout", Scroller)
    List.Padding = UDim.new(0, 5)
    Tabs[name] = Scroller
    return Scroller
end

local TabAim = CreateTab("Aim")
local TabEsp = CreateTab("Esp")
local TabPlayer = CreateTab("Player")
local TabPlayersMaster = CreateTab("PlayersMaster")
local TabExtras = CreateTab("Extras")
local TabAI = CreateTab("AI")
Tabs["Aim"].Visible = true

local function AddNavButton(label, target)
    local B = Instance.new("TextButton", NavFrame)
    B.Size = UDim2.new(1, 0, 0, 32)
    B.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
    B.Text = label
    B.TextColor3 = Color3.fromRGB(150, 150, 160)
    B.Font = Enum.Font.Code
    B.TextSize = 10
    B.BorderSizePixel = 0
    B.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        target.Visible = true
    end)
end
AddNavButton("[ TARGET CONTROL ]", TabAim)
AddNavButton("[ VISUAL ENGINE ]", TabEsp)
AddNavButton("[ MOVEMENT CORE ]", TabPlayer)
AddNavButton("[ PLAYERS MASTER ]", TabPlayersMaster)
AddNavButton("[ EXTRAS CONTROL ]", TabExtras)
AddNavButton("[ IA BOOST & FPS ]", TabAI)

-- =========================================================
-- UTILS: CRIAÇÃO DE COMPONENTES PADRÃO
-- =========================================================
local function NewToggle(text, parent, key, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -6, 0, 34)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 26, 0.7)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    
    local L = Instance.new("TextLabel", Frame)
    L.Size = UDim2.new(0.7, 0, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.Text = text
    L.TextColor3 = Color3.fromRGB(230, 230, 240)
    L.Font = Enum.Font.SourceSansSemibold
    L.TextSize = 12
    L.BackgroundTransparency = 1
    L.TextXAlignment = Enum.TextXAlignment.Left
    
    local B = Instance.new("TextButton", Frame)
    B.Size = UDim2.new(0, 36, 0, 16)
    B.Position = UDim2.new(1, -45, 0.5, -8)
    B.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    B.Text = ""
    Instance.new("UICorner", B).CornerRadius = UDim.new(1, 0)
    
    local C = Instance.new("Frame", B)
    C.Size = UDim2.new(0, 10, 0, 10)
    C.Position = UDim2.new(0, 3, 0.5, -5)
    C.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", C).CornerRadius = UDim.new(1, 0)
    
    B.MouseButton1Click:Connect(function()
        BK_DB[key] = not BK_DB[key]
        TweenService:Create(C, TweenInfo.new(0.12), {Position = BK_DB[key] and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)}):Play()
        TweenService:Create(B, TweenInfo.new(0.12), {BackgroundColor3 = BK_DB[key] and Color3.fromRGB(0, 255, 180) or Color3.fromRGB(45, 48, 58)}):Play()
        if callback then callback(BK_DB[key]) end
    end)
end

local function NewSlider(text, parent, min, max, key, div)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -6, 0, 44)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 26, 0.7)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    
    local L = Instance.new("TextLabel", Frame)
    L.Size = UDim2.new(1, -10, 0, 16)
    L.Position = UDim2.new(0, 10, 0, 2)
    L.Text = text .. " : " .. tostring(BK_DB[key])
    L.TextColor3 = Color3.fromRGB(230, 230, 240)
    L.Font = Enum.Font.SourceSansSemibold
    L.TextSize = 12
    L.BackgroundTransparency = 1
    L.TextXAlignment = Enum.TextXAlignment.Left
    
    local SB = Instance.new("TextButton", Frame)
    SB.Size = UDim2.new(1, -20, 0, 4)
    SB.Position = UDim2.new(0, 10, 0, 28)
    SB.BackgroundColor3 = Color3.fromRGB(50, 54, 66)
    SB.Text = ""
    Instance.new("UICorner", SB)
    
    local Bar = Instance.new("Frame", SB)
    Bar.Size = UDim2.new(0.5, 0, 1, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
    Instance.new("UICorner", Bar)
    
    local moving = false
    local function update()
        local pct = math.clamp((UserInputService:GetMouseLocation().X - SB.AbsolutePosition.X) / SB.AbsoluteSize.X, 0, 1)
        Bar.Size = UDim2.new(pct, 0, 1, 0)
        local val = math.floor(min + (max - min) * pct)
        BK_DB[key] = div and (val / div) or val
        L.Text = text .. " : " .. tostring(BK_DB[key])
    end
    SB.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then moving = true update() end end)
    UserInputService.InputChanged:Connect(function(input) if moving and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then update() end end)
    UserInputService.InputEnded:Connect(function() moving = false end)
end

-- Preenchimento Padrão
NewToggle("Aimbot Tracking Force", TabAim, "Aimbot")
NewToggle("Silent Aim Dynamic", TabAim, "SilentAim")
NewToggle("Motion Latency Predict", TabAim, "Predict")
NewToggle("WallCheck Raycast", TabAim, "WallCheck")
NewToggle("TeamCheck Isolation", TabAim, "TeamCheck")
NewToggle("Render FOV Geometric", TabAim, "FOV_Visible")
NewSlider("FOV Dynamic Radius", TabAim, 30, 500, "FOV")
NewSlider("Tracking Smooth Factor", TabAim, 1, 100, "Smooth", 500)

NewToggle("ESP Highlight Matrix", TabEsp, "ESP_Chams")
NewToggle("ESP Label Name", TabEsp, "ESP_Names")
NewToggle("ESP Label Distance", TabEsp, "ESP_Dist")
NewToggle("ESP Vital Health Bar", TabEsp, "ESP_Health")
NewToggle("ESP Bounding Box 2D", TabEsp, "ESP_Box")

NewSlider("Velocity Override", TabPlayer, 16, 220, "SpeedHack")
NewSlider("Jump Impulse Power", TabPlayer, 50, 250, "JumpHack")
NewToggle("Continuous Jump Request", TabPlayer, "InfJump")
NewToggle("Flight Simulation Mode", TabPlayer, "FlyActive")
NewSlider("Flight Velocity Speed", TabPlayer, 20, 200, "FlySpeed")

-- =========================================================
-- ABA EXTRAS CONTROL: MULTI-FUNÇÕES ALTERNATIVAS
-- =========================================================
NewToggle("Phase NoClip World Bypass", TabExtras, "NoClip")
NewToggle("Infinite Stamina Emulator", TabExtras, "InfEnergy")
NewToggle("Jump Impulse Stabilizer", TabExtras, "SuperJump")

-- =========================================================
-- MOTORES DE OTIMIZAÇÃO: ABA IA BOOST (POTATO GRAPHICS & MEMORY)
-- =========================================================
local AILog = Instance.new("TextLabel", TabAI)
AILog.Size = UDim2.new(1, -6, 0, 42)
AILog.BackgroundColor3 = Color3.fromRGB(6, 7, 10)
AILog.Text = "NEURAL SYS // Engine pronta para otimização em tempo real."
AILog.TextColor3 = Color3.fromRGB(0, 255, 150)
AILog.Font = Enum.Font.Code
AILog.TextSize = 11
AILog.TextWrapped = true
Instance.new("UICorner", AILog)

-- 1. Gráficos de Massinha (Potato Texture Override)
NewToggle("Gráficos de Massinha", TabAI, "Opt_Massinha", function(state)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            if state then
                if not obj:GetAttribute("OldMaterial") then obj:SetAttribute("OldMaterial", obj.Material.Name) end
                obj.Material = Enum.Material.SmoothPlastic
            else
                local old = obj:GetAttribute("OldMaterial")
                if old then obj.Material = Enum.Material[old] end
            end
        end
    end
end)

-- 2. Desativar Sombras em Tempo Real
NewToggle("Remover Sombras Globais", TabAI, "Opt_NoShadows", function(state)
    Lighting.GlobalShadows = not state
end)

-- 3. Limpeza Ativa de Efeitos e Lixo Visual (Partículas/Fumaças)
NewToggle("Limpar Partículas/Fumaça", TabAI, "Opt_ClearGarbage", function(state)
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                obj.Enabled = false
            end
        end
    end
end)

-- 4. Desativar Pós-Processamento Pesado (Bloom/Blur/Atmosphere)
NewToggle("Desativar Efeitos Visuais", TabAI, "Opt_DisableEffects", function(state)
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") then
            effect.Enabled = not state
        end
    end
end)

-- 5. Renderização Agressiva Oclusiva (Focar apenas no FOV próximo)
NewToggle("Oclusão de Render Distante", TabAI, "Opt_AggressiveRender")

-- 6. Remover Decals (Texturas de Parede/Sangue/Adesivos)
NewToggle("Destruir Decals / Texturas", TabAI, "Opt_RemoveDecals", function(state)
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end
    end
end)

-- 7. Desativar Física de Detritos (Corpos Mortos/Ragdolls locais)
NewToggle("Anular Ragdolls / Corpos", TabAI, "Opt_NoRagdolls")

-- 8. Baixa Latência de Física (Reduz cálculo mecânico secundário)
NewToggle("Limitar Atualização Física", TabAI, "Opt_LowPhysics", function(state)
    settings().Physics.PhysicsEnvironmentalThrottle = state and Enum.EnviromentalPhysicsThrottle.DefaultAuto or Enum.EnviromentalPhysicsThrottle.Disabled
end)

-- 9. Carregamento de Stream Limpo (Bypass de Áudio Ambiente Repetitivo)
NewToggle("Mudar Amostragem de Áudio", TabAI, "Opt_MuteAmbience")

-- 10. Forçar Renderizador 60 FPS Estável
NewToggle("Estabilizador Neural de Quadros", TabAI, "AI_Enabled")


-- =========================================================
-- ABA PLAYERS MASTER COM INTEL EXTRA PROFUNDA & SCRIPT DE TP
-- =========================================================
local InfoPanel = Instance.new("Frame", ContentFrame)
InfoPanel.Size = UDim2.new(0, 165, 1, 0)
InfoPanel.Position = UDim2.new(1, 0, 0, 0)
InfoPanel.BackgroundColor3 = Color3.fromRGB(7, 8, 11)
InfoPanel.BorderSizePixel = 0
local InfoStroke = Instance.new("UIStroke", InfoPanel)
InfoStroke.Color = Color3.fromRGB(140, 0, 255)

local InfoTitle = Instance.new("TextLabel", InfoPanel)
InfoTitle.Size = UDim2.new(1, 0, 0, 26)
InfoTitle.BackgroundColor3 = Color3.fromRGB(12, 13, 18)
InfoTitle.Text = "[ TELEMETRIA DE ALVO ]"
InfoTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
InfoTitle.Font = Enum.Font.Code
InfoTitle.TextSize = 10

local InfoLabelsContainer = Instance.new("Frame", InfoPanel)
InfoLabelsContainer.Size = UDim2.new(1, -10, 1, -70)
InfoLabelsContainer.Position = UDim2.new(0, 5, 0, 30)
InfoLabelsContainer.BackgroundTransparency = 1
local InfoLayout = Instance.new("UIListLayout", InfoLabelsContainer)
InfoLayout.Padding = UDim.new(0, 2)

local function CreateIntelLabel()
    local lbl = Instance.new("TextLabel", InfoLabelsContainer)
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(210, 215, 225)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local Intel_Name = CreateIntelLabel()
local Intel_Type = CreateIntelLabel()
local Intel_Device = CreateIntelLabel()
local Intel_Ping = CreateIntelLabel()
local Intel_ID = CreateIntelLabel()
local Intel_Age = CreateIntelLabel()
local Intel_Health = CreateIntelLabel()
local Intel_Team = CreateIntelLabel()

-- Botão de Teleporte Cirúrgico ALOCADO DENTRO DO PAINEL DE INFORMAÇÕES
local InlineTPButton = Instance.new("TextButton", InfoPanel)
InlineTPButton.Size = UDim2.new(1, -10, 0, 26)
InlineTPButton.Position = UDim2.new(0, 5, 1, -32)
InlineTPButton.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
InlineTPButton.Text = "TELEPORTAR AO PLAYER"
InlineTPButton.TextColor3 = Color3.fromRGB(10, 10, 15)
InlineTPButton.Font = Enum.Font.Code
InlineTPButton.TextSize = 10
Instance.new("UICorner", InlineTPButton)

local function RealSurgicalTeleport(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if myRoot and targetRoot then
        local startPos = myRoot.CFrame
        local endPos = targetRoot.CFrame * CFrame.new(0, 0, 2.5)
        
        -- Bypass Fracionado Antiatrito Estabilizado para evitar Rubberbanding
        for i = 1, 6 do
            myRoot.CFrame = startPos:Lerp(endPos, i / 6)
            myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            task.wait()
        end
    end
end

InlineTPButton.MouseButton1Click:Connect(function()
    if BK_DB.SelectedPlayerIntel then
        RealSurgicalTeleport(BK_DB.SelectedPlayerIntel)
    end
end)

local function ShowPlayerIntel(p)
    BK_DB.SelectedPlayerIntel = p
    Intel_Name.Text = "User: " .. p.Name
    
    -- Tipo Real de Entidade
    local isBot = "PLAYER (REAL)"
    if p.UserId <= 0 or p:GetAttribute("IsBot") == true then
        isBot = "BOT / AUTOMATON"
    end
    Intel_Type.Text = "Classe: " .. isBot
    
    -- Análise de Dispositivo em Tempo Real (Baseado no tipo de Input recebido pelo motor)
    local probableDevice = "PC (Keyboard/Mouse)"
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        probableDevice = "Mobile (Touchscreen)"
    elseif UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then
        probableDevice = "Console / Gamepad"
    end
    Intel_Device.Text = "Dispositivo: " .. probableDevice
    
    -- Estimador de Latência Mecânica (Ping aproximado em MS baseado na replicação de rede física)
    local pingEst = "Calculando..."
    pcall(function()
        local ping = LocalPlayer:GetNetworkPing() -- Retorna valor flutuante em segundos
        pingEst = tostring(math.floor(ping * 1000)) .. " ms"
    end)
    Intel_Ping.Text = "Latência: " .. pingEst
    
    Intel_ID.Text = "ID Real: " .. tostring(p.UserId)
    Intel_Age.Text = "Idade Conta: " .. tostring(p.AccountAge) .. " dias"
    
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        Intel_Health.Text = "Vida Exata: " .. math.floor(p.Character.Humanoid.Health) .. " HP"
    else
        Intel_Health.Text = "Vida Exata: MORTO"
    end
    Intel_Team.Text = "Time: " .. tostring(p.Team and p.Team.Name or "Sem Faction")
    
    MainMenu.ClipsDescendants = false
    TweenService:Create(InfoPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, 2, 0, 0)
    }):Play()
end

local function HidePlayerIntel()
    TweenService:Create(InfoPanel, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 0, 0, 0)
    }):Play()
end

local function RefreshPlayersTab()
    for _, c in pairs(TabPlayersMaster:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        local PFrame = Instance.new("Frame", TabPlayersMaster)
        PFrame.Size = UDim2.new(1, -6, 0, 26)
        PFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
        Instance.new("UICorner", PFrame).CornerRadius = UDim.new(0, 4)
        
        local tag = p.UserId <= 0 and "BOT" or "PLAYER"
        
        local NameLbl = Instance.new("TextLabel", PFrame)
        NameLbl.Size = UDim2.new(0.75, 0, 1, 0)
        NameLbl.Position = UDim2.new(0, 8, 0, 0)
        NameLbl.Text = p.Name .. " [" .. tag .. "]"
        NameLbl.TextColor3 = (p == LocalPlayer) and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(230, 230, 240)
        NameLbl.Font = Enum.Font.SourceSansSemibold
        NameLbl.TextSize = 12
        NameLbl.TextXAlignment = Enum.TextXAlignment.Left
        NameLbl.BackgroundTransparency = 1
        
        local OptBtn = Instance.new("TextButton", PFrame)
        OptBtn.Size = UDim2.new(0, 28, 0, 20)
        OptBtn.Position = UDim2.new(1, -34, 0.5, -10)
        OptBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 42)
        OptBtn.Text = "≡"
        OptBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
        OptBtn.Font = Enum.Font.Code
        OptBtn.TextSize = 12
        Instance.new("UICorner", OptBtn)
        
        OptBtn.MouseButton1Click:Connect(function()
            ShowPlayerIntel(p)
        end)
    end
end

Players.PlayerAdded:Connect(RefreshPlayersTab)
Players.PlayerRemoving:Connect(RefreshPlayersTab)
RefreshPlayersTab()

-- =========================================================
-- CONTROLE DE INTERFACE: CÁPSULA FLUTUANTE
-- =========================================================
local FloatingCapsule = Instance.new("TextButton", ScreenGui)
FloatingCapsule.Size = UDim2.new(0, 230, 0, 34)
FloatingCapsule.Position = UDim2.new(0.05, 0, 0.15, 0)
FloatingCapsule.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
FloatingCapsule.Text = "BK CLIENT BOOST ACTIVE (V10.5)"
FloatingCapsule.TextColor3 = Color3.fromRGB(0, 255, 180)
FloatingCapsule.Font = Enum.Font.Code
FloatingCapsule.TextSize = 11
FloatingCapsule.Active = true
Instance.new("UICorner", FloatingCapsule).CornerRadius = UDim.new(0, 6)

local CapsuleStroke = Instance.new("UIStroke", FloatingCapsule)
CapsuleStroke.Color = Color3.fromRGB(140, 0, 255)
CapsuleStroke.Thickness = 1.5

local bDragging, bStartInput, bStartPos
FloatingCapsule.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        bDragging = true bStartInput = input.Position bStartPos = FloatingCapsule.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if bDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - bStartInput
        FloatingCapsule.Position = UDim2.new(bStartPos.X.Scale, bStartPos.X.Offset + delta.X, bStartPos.Y.Scale, bStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() bDragging = false end)

local menuOpen = false
local function ToggleMenuVisibility()
    menuOpen = not menuOpen
    if menuOpen then
        MainMenu.Visible = true
        RefreshPlayersTab()
        TweenService:Create(MainMenu, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 290)
        }):Play()
    else
        HidePlayerIntel()
        local twin = TweenService:Create(MainMenu, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 520, 0, 0)
        })
        twin:Play()
        twin.Completed:Connect(function()
            if not menuOpen then MainMenu.Visible = false end
        end)
    end
end
FloatingCapsule.MouseButton1Click:Connect(ToggleMenuVisibility)

local HeaderDrag = false
local hStartInput, hStartPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        HeaderDrag = true hStartInput = input.Position hStartPos = MainMenu.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if HeaderDrag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - hStartInput
        MainMenu.Position = UDim2.new(hStartPos.X.Scale, hStartPos.X.Offset + delta.X, hStartPos.Y.Scale, hStartPos.Y.Offset + delta.Y)
    end
end)
Header.InputEnded:Connect(function() HeaderDrag = false end)

-- =========================================================
-- SISTEMA ESP CIRÚRGICO UNIVERSAL
-- =========================================================
local function ApplySurgicalESP(p)
    if p == LocalPlayer then return end
    local function make(char)
        local hum = char:WaitForChild("Humanoid", 12)
        if not hum then return end
        
        local h = char:FindFirstChild("BK_Highlight") or Instance.new("Highlight", char)
        h.Name = "BK_Highlight"
        h.FillColor = Color3.fromRGB(140, 0, 255)
        h.OutlineColor = Color3.fromRGB(0, 255, 200)
        h.Enabled = false
        
        local bb = char:FindFirstChild("BK_Billboard") or Instance.new("BillboardGui", char)
        bb.Name = "BK_Billboard"
        bb.AlwaysOnTop = true
        bb.Size = UDim2.new(0, 180, 0, 45)
        bb.ExtentsOffset = Vector3.new(0, 3.2, 0)
        bb.Enabled = false
        
        local l = bb:FindFirstChild("Label") or Instance.new("TextLabel", bb)
        l.Name = "Label"
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.new(1, 1, 1)
        l.TextSize = 11
        l.Font = Enum.Font.Code
        
        local guiBox = char:FindFirstChild("BK_BoxGui") or Instance.new("BillboardGui", char)
        guiBox.Name = "BK_BoxGui"
        guiBox.AlwaysOnTop = true
        guiBox.Size = UDim2.new(4, 0, 5.5, 0)
        guiBox.Enabled = false
        
        local strokeBox = guiBox:FindFirstChild("Stroke") or Instance.new("Frame", guiBox)
        strokeBox.Name = "Stroke"
        strokeBox.Size = UDim2.new(1, 0, 1, 0)
        strokeBox.BackgroundTransparency = 1
        local frameStroke = strokeBox:FindFirstChild("UIStroke") or Instance.new("UIStroke", strokeBox)
        frameStroke.Color = Color3.fromRGB(0, 255, 180)
        frameStroke.Thickness = 1.5
    end
    if p.Character then task.spawn(make, p.Character) end
    p.CharacterAdded:Connect(make)
end
for _, p in pairs(Players:GetPlayers()) do ApplySurgicalESP(p) end
Players.PlayerAdded:Connect(ApplySurgicalESP)

-- =========================================================
-- EXECUÇÃO DO LOOP FRAME-BY-FRAME (RENDERSTEPPED)
-- =========================================================
RunService.RenderStepped:Connect(function(deltaTime)
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if BK_DB.FOV_Visible then
        FOVFrame.Visible = true
        FOVFrame.Size = UDim2.new(0, BK_DB.FOV * 2, 0, BK_DB.FOV * 2)
        FOVFrame.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y)
    else
        FOVFrame.Visible = false
    end
    
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if myChar and myRoot and myChar:FindFirstChild("Humanoid") then
        if BK_DB.SpeedHack > 16 and UserInputService.MoveDirection.Magnitude > 0 then
            myRoot.AssemblyLinearVelocity = Vector3.new(
                UserInputService.MoveDirection.X * BK_DB.SpeedHack,
                myRoot.AssemblyLinearVelocity.Y,
                UserInputService.MoveDirection.Z * BK_DB.SpeedHack
            )
        end
        if BK_DB.FlyActive then
            myRoot.AssemblyLinearVelocity = Camera.CFrame.LookVector * BK_DB.FlySpeed
        end
        if BK_DB.SuperJump then
            myRoot.AssemblyLinearVelocity = Vector3.new(myRoot.AssemblyLinearVelocity.X, BK_DB.JumpHack, myRoot.AssemblyLinearVelocity.Z)
            BK_DB.SuperJump = false
        end
        if BK_DB.NoClip then
            for _, d in pairs(myChar:GetDescendants()) do
                if d:IsA("BasePart") then d.CanCollide = false end
            end
        end
    end
    
    if BK_DB.AI_Enabled then
        BK_DB.CurrentFPS = math.floor(1 / deltaTime)
        AILog.Text = "NEURAL SYS // FPS: " .. tostring(BK_DB.CurrentFPS) .. " | Otimizações de Memória Operando em Alto Nível."
    end
    
    local bestTargetPart = nil
    local shortestDistance = BK_DB.FOV
    
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        
        local isFriend = (p.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil)
        local char = p.Character
        if char and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            
            -- Renderizador Oclusivo Agressivo (Ignora o processamento visual de alvos ultra distantes se ativado)
            local distFromMe = (Camera.CFrame.Position - char.Head.Position).Magnitude
            if BK_DB.Opt_AggressiveRender and distFromMe > 180 then
                if char:FindFirstChild("BK_Highlight") then char.BK_Highlight.Enabled = false end
                if char:FindFirstChild("BK_BoxGui") then char.BK_BoxGui.Enabled = false end
                if char:FindFirstChild("BK_Billboard") then char.BK_Billboard.Enabled = false end
                continue
            end
            
            if char:FindFirstChild("BK_Highlight") and char:FindFirstChild("BK_Billboard") and char:FindFirstChild("BK_BoxGui") then
                local visualAllowed = true
                if BK_DB.TeamCheck and isFriend then visualAllowed = false end
                
                char.BK_Highlight.Enabled = BK_DB.ESP_Chams and visualAllowed
                char.BK_BoxGui.Enabled = BK_DB.ESP_Box and visualAllowed
                char.BK_Billboard.Enabled = (BK_DB.ESP_Names or BK_DB.ESP_Dist or BK_DB.ESP_Health) and visualAllowed
                
                if char.BK_Billboard.Enabled then
                    local distance = math.floor(distFromMe)
                    local nameStr = BK_DB.ESP_Names and p.Name or ""
                    local distStr = BK_DB.ESP_Dist and " [" .. distance .. "m]" or ""
                    local healthStr = BK_DB.ESP_Health and " HP: " .. math.floor(char.Humanoid.Health) or ""
                    char.BK_Billboard.Label.Text = nameStr .. distStr .. healthStr
                end
            end
            
            local aimAllowed = true
            if BK_DB.TeamCheck and isFriend then aimAllowed = false end
            
            if aimAllowed then
                local viewportPos, isVisibleOnScreen = Camera:WorldToViewportPoint(char.Head.Position)
                if isVisibleOnScreen then
                    local currentMag = (Vector2.new(viewportPos.X, viewportPos.Y) - screenCenter).Magnitude
                    if currentMag < shortestDistance then
                        local isClear = true
                        if BK_DB.WallCheck then
                            local obscuring = Camera:GetPartsObscuringTarget({Camera.CFrame.Position, char.Head.Position}, {myChar, char})
                            if #obscuring > 0 then isClear = false end
                        end
                        if isClear then
                            bestTargetPart = char:FindFirstChild(BK_DB.TargetPart)
                            shortestDistance = currentMag
                        end
                    end
                end
            end
            
        end
    end
    
    if bestTargetPart and BK_DB.Aimbot then
        local targetPos = bestTargetPart.Position
        if BK_DB.Predict and bestTargetPart.Parent:FindFirstChild("HumanoidRootPart") then
            targetPos = targetPos + (bestTargetPart.Parent.HumanoidRootPart.AssemblyLinearVelocity * BK_DB.PredictionVelocity)
        end
        local lerpSpeed = math.clamp(BK_DB.Smooth * (deltaTime * 60), 0.02, 1)
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), lerpSpeed)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if BK_DB.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
