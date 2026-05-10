-- =================================================================
-- BK CLIENT v1.4 † - ROBLOX MOBILE PRIVATE SCRIPT
-- Desenvolvido para máxima compatibilidade com Delta Executor (Mobile)
-- Pronto para hospedagem no GitHub / Loadstring
-- =================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Evita executar o script mais de uma vez ao mesmo tempo
if CoreGui:FindFirstChild("BKClient_V14") then
    CoreGui:FindFirstChild("BKClient_V14"):Destroy()
end

-- Criando a ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BKClient_V14"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Estados de ativação das funções
local ESP_Settings = {
    Lines = false,
    Names = false,
    Weapons = false,
    Distance = false,
    Health = false,
    Boxes = false,
    Skeleton = false
}

local Extra_Settings = {
    SuperSpeed = false,
    SuperJump = false
}

local SpeedValue = 80
local JumpValue = 120

-- Container para desenhos do ESP (Fica por trás do menu)
local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "BK_ESP_Container"
ESPContainer.Parent = ScreenGui

-- ==========================================
-- 1. SISTEMA DA CÁPSULA FLUTUANTE (BUBBLE)
-- ==========================================

local Bubble = Instance.new("TextButton")
Bubble.Name = "BKBubble"
Bubble.Size = UDim2.new(0, 140, 0, 45)
Bubble.Position = UDim2.new(0.1, 0, 0.2, 0)
Bubble.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Bubble.BorderSizePixel = 0
Bubble.Text = "BK CLIENT v1.4 †"
Bubble.TextColor3 = Color3.fromRGB(255, 0, 0)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 13
Bubble.Active = true
Bubble.Draggable = true -- Nativo para mobile arrastar sem bugs
Bubble.Parent = ScreenGui

local BubbleCorner = Instance.new("UICorner")
BubbleCorner.CornerRadius = UDim.new(0, 12)
BubbleCorner.Parent = Bubble

local BubbleStroke = Instance.new("UIStroke")
BubbleStroke.Color = Color3.fromRGB(200, 0, 0)
BubbleStroke.Thickness = 2
BubbleStroke.Parent = Bubble

-- ==========================================
-- 2. PAINEL PRINCIPAL (MENU)
-- ==========================================

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 300, 0, 240)
MainPanel.Position = UDim2.new(0.5, -150, 0.5, -120)
MainPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 10)
PanelCorner.Parent = MainPanel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Color3.fromRGB(200, 0, 0)
PanelStroke.Thickness = 1.5
PanelStroke.Parent = MainPanel

-- Abre/Fecha sem precisar recriar nada ao tocar na bolha
Bubble.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

-- Título do Painel
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "BK CLIENT v1.4  [ PRIVATE ]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainPanel

-- Abas do Painel
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainPanel

local TabESPBtn = Instance.new("TextButton")
TabESPBtn.Size = UDim2.new(0.5, 0, 1, 0)
TabESPBtn.BackgroundTransparency = 1
TabESPBtn.Text = "ESP"
TabESPBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
TabESPBtn.Font = Enum.Font.GothamBold
TabESPBtn.TextSize = 12
TabESPBtn.Parent = TabContainer

local TabExtraBtn = Instance.new("TextButton")
TabExtraBtn.Size = UDim2.new(0.5, 0, 1, 0)
TabExtraBtn.Position = UDim2.new(0.5, 0, 0, 0)
TabExtraBtn.BackgroundTransparency = 1
TabExtraBtn.Text = "EXTRA"
TabExtraBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
TabExtraBtn.Font = Enum.Font.GothamBold
TabExtraBtn.TextSize = 12
TabExtraBtn.Parent = TabContainer

-- Páginas de Conteúdo (Usando ScrollingFrames limpos)
local PageESP = Instance.new("ScrollingFrame")
PageESP.Size = UDim2.new(1, -20, 1, -85)
PageESP.Position = UDim2.new(0, 10, 0, 75)
PageESP.BackgroundTransparency = 1
PageESP.BorderSizePixel = 0
PageESP.CanvasSize = UDim2.new(0, 0, 0, 300)
PageESP.ScrollBarThickness = 3
PageESP.Visible = true
PageESP.Parent = MainPanel

local PageExtra = Instance.new("ScrollingFrame")
PageExtra.Size = UDim2.new(1, -20, 1, -85)
PageExtra.Position = UDim2.new(0, 10, 0, 75)
PageExtra.BackgroundTransparency = 1
PageExtra.BorderSizePixel = 0
PageExtra.CanvasSize = UDim2.new(0, 0, 0, 200)
PageExtra.ScrollBarThickness = 3
PageExtra.Visible = false
PageExtra.Parent = MainPanel

local espLayout = Instance.new("UIListLayout")
espLayout.Padding = UDim.new(0, 5)
espLayout.Parent = PageESP

local extraLayout = Instance.new("UIListLayout")
extraLayout.Padding = UDim.new(0, 5)
extraLayout.Parent = PageExtra

-- Lógica de troca de abas
TabESPBtn.MouseButton1Click:Connect(function()
    PageESP.Visible = true
    PageExtra.Visible = false
    TabESPBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    TabExtraBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

TabExtraBtn.MouseButton1Click:Connect(function()
    PageESP.Visible = false
    PageExtra.Visible = true
    TabESPBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabExtraBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
end)

-- ==========================================
-- 3. CRIADOR DE SWITCH/BOTÃO DE FUNÇÃO
-- ==========================================

local function CreateToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(230, 230, 230)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.25, 0, 0.8, 0)
    Button.Position = UDim2.new(0.75, -5, 0.1, 0)
    Button.BackgroundColor3 = default and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
    Button.Text = default and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 10
    Button.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
        Button.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

-- ==========================================
-- 4. MAPEANDO AS CONFIGURAÇÕES NO MENU
-- ==========================================

CreateToggle(PageESP, "ESP LINE", false, function(v) ESP_Settings.Lines = v end)
CreateToggle(PageESP, "ESP NOME", false, function(v) ESP_Settings.Names = v end)
CreateToggle(PageESP, "ESP ARMA", false, function(v) ESP_Settings.Weapons = v end)
CreateToggle(PageESP, "ESP DISTÂNCIA", false, function(v) ESP_Settings.Distance = v end)
CreateToggle(PageESP, "ESP VIDA", false, function(v) ESP_Settings.Health = v end)
CreateToggle(PageESP, "ESP BOX", false, function(v) ESP_Settings.Boxes = v end)
CreateToggle(PageESP, "ESP ESQUELETO (R15/R20)", false, function(v) ESP_Settings.Skeleton = v end)

CreateToggle(PageExtra, "SUPER PULO", false, function(v) Extra_Settings.SuperJump = v end)
CreateToggle(PageExtra, "SUPER VELOCIDADE", false, function(v) Extra_Settings.SuperSpeed = v end)

-- Loop de Física das Funções Extras (Super Speed / Super Jump)
RunService.Heartbeat:Connect(function()
    local Char = LocalPlayer.Character
    if Char and Char:FindFirstChildOfClass("Humanoid") then
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        
        if Extra_Settings.SuperSpeed then
            Hum.WalkSpeed = SpeedValue
        else
            Hum.WalkSpeed = 16
        end

        if Extra_Settings.SuperJump then
            Hum.JumpPower = JumpValue
            Hum.UseJumpPower = true
        else
            Hum.JumpPower = 50
        end
    end
end)

-- ==========================================
-- 5. RENDERIZADOR DE ESP NATIVO (STABLE)
-- ==========================================

local function ApplyESP(player)
    if player == LocalPlayer then return end

    -- Pasta individual de elementos na tela para o jogador correspondente
    local PlayerFolder = Instance.new("Folder")
    PlayerFolder.Name = "ESP_" .. player.Name
    PlayerFolder.Parent = ESPContainer

    -- Linha de ESP
    local FrameLine = Instance.new("Frame")
    FrameLine.BorderSizePixel = 0
    FrameLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    FrameLine.Visible = false
    FrameLine.Parent = PlayerFolder

    -- Textos (Nome, Distância, Vida, Arma)
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.Font = Enum.Font.GothamBold
    InfoLabel.TextSize = 11
    InfoLabel.TextStrokeTransparency = 0.2
    InfoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    InfoLabel.Visible = false
    InfoLabel.Parent = PlayerFolder

    -- Box de ESP (Bordas usando frames)
    local BoxFrame = Instance.new("Frame")
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Visible = false
    BoxFrame.Parent = PlayerFolder

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(255, 0, 0)
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = BoxFrame

    -- Estrutura para desenho do Esqueleto
    local Bones = {}
    for i = 1, 10 do
        local boneLine = Instance.new("Frame")
        boneLine.BorderSizePixel = 0
        boneLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        boneLine.Visible = false
        boneLine.Parent = PlayerFolder
        Bones[i] = boneLine
    end

    local function Clear()
        FrameLine.Visible = false
        InfoLabel.Visible = false
        BoxFrame.Visible = false
        for _, b in ipairs(Bones) do b.Visible = false end
    end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            Clear()
            if not player.Parent then
                connection:Disconnect()
                PlayerFolder:Destroy()
            end
            return
        end

        local Char = player.Character
        local RootPart = Char.HumanoidRootPart
        local Humanoid = Char:FindFirstChildOfClass("Humanoid")

        if not Humanoid or Humanoid.Health <= 0 then
            Clear()
            return
        end

        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

        if OnScreen then
            -- 1. DESENHO DA ESP LINE
            if ESP_Settings.Lines then
                local StartX = Camera.ViewportSize.X / 2
                local StartY = Camera.ViewportSize.Y
                local TargetX = ScreenPos.X
                local TargetY = ScreenPos.Y

                local Dist = math.sqrt((TargetX - StartX)^2 + (TargetY - StartY)^2)
                local Angle = math.atan2(TargetY - StartY, TargetX - StartX)

                FrameLine.Size = UDim2.new(0, Dist, 0, 1.5)
                FrameLine.Position = UDim2.new(0, (StartX + TargetX) / 2 - Dist / 2, 0, (StartY + TargetY) / 2)
                FrameLine.Rotation = math.deg(Angle)
                FrameLine.Visible = true
            else
                FrameLine.Visible = false
            end

            -- 2. DESENHO DAS INFORMAÇÕES (NOME, DISTÂNCIA, ETC.)
            if ESP_Settings.Names or ESP_Settings.Distance or ESP_Settings.Health or ESP_Settings.Weapons then
                local textStr = ""
                if ESP_Settings.Names then textStr = textStr .. player.Name .. " " end
                if ESP_Settings.Health then textStr = textStr .. "[" .. math.floor(Humanoid.Health) .. " HP] " end
                
                local myChar = LocalPlayer.Character
                if ESP_Settings.Distance and myChar and myChar:FindFirstChild("HumanoidRootPart") then 
                    local dist = math.floor((RootPart.Position - myChar.HumanoidRootPart.Position).Magnitude)
                    textStr = textStr .. "(" .. dist .. "m) " 
                end

                if ESP_Settings.Weapons then
                    local toolName = "Nenhum"
                    local activeTool = Char:FindFirstChildOfClass("Tool")
                    if activeTool then toolName = activeTool.Name end
                    textStr = textStr .. "{" .. toolName .. "}"
                end

                InfoLabel.Text = textStr
                InfoLabel.Position = UDim2.new(0, ScreenPos.X - 100, 0, ScreenPos.Y - 55)
                InfoLabel.Size = UDim2.new(0, 200, 0, 20)
                InfoLabel.Visible = true
            else
                InfoLabel.Visible = false
            end

            -- 3. DESENHO DO ESP BOX
            if ESP_Settings.Boxes then
                local SizeX = 2000 / ScreenPos.Z
                local SizeY = 3000 / ScreenPos.Z

                BoxFrame.Size = UDim2.new(0, SizeX, 0, SizeY)
                BoxFrame.Position = UDim2.new(0, ScreenPos.X - SizeX / 2, 0, ScreenPos.Y - SizeY / 2)
                BoxFrame.Visible = true
            else
                BoxFrame.Visible = false
            end

            -- 4. DESENHO DO ESQUELETO (COMPATÍVEL COM R15 E R6)
            if ESP_Settings.Skeleton then
                local function connectParts(partA, partB, boneIndex)
                    if Char:FindFirstChild(partA) and Char:FindFirstChild(partB) then
                        local posA, onScreenA = Camera:WorldToViewportPoint(Char[partA].Position)
                        local posB, onScreenB = Camera:WorldToViewportPoint(Char[partB].Position)

                        if onScreenA and onScreenB then
                            local Dist = math.sqrt((posB.X - posA.X)^2 + (posB.Y - posA.Y)^2)
                            local Angle = math.atan2(posB.Y - posA.Y, posB.X - posA.X)

                            local bone = Bones[boneIndex]
                            bone.Size = UDim2.new(0, Dist, 0, 1.2)
                            bone.Position = UDim2.new(0, (posA.X + posB.X) / 2 - Dist / 2, 0, (posA.Y + posB.Y) / 2)
                            bone.Rotation = math.deg(Angle)
                            bone.Visible = true
                            return
                        end
                    end
                    Bones[boneIndex].Visible = false
                end

                -- Conectando esqueleto dinamicamente (Funciona em R15 e R6)
                if Humanoid.RigType == Enum.HumanoidRigType.R15 then
                    connectParts("Head", "UpperTorso", 1)
                    connectParts("UpperTorso", "LowerTorso", 2)
                    connectParts("UpperTorso", "LeftUpperArm", 3)
                    connectParts("LeftUpperArm", "LeftLowerArm", 4)
                    connectParts("UpperTorso", "RightUpperArm", 5)
                    connectParts("RightUpperArm", "RightLowerArm", 6)
                    connectParts("LowerTorso", "LeftUpperLeg", 7)
                    connectParts("LeftUpperLeg", "LeftLowerLeg", 8)
                    connectParts("LowerTorso", "RightUpperLeg", 9)
                    connectParts("RightUpperLeg", "RightLowerLeg", 10)
                else -- R6
                    connectParts("Head", "Torso", 1)
                    connectParts("Torso", "Left Arm", 3)
                    connectParts("Torso", "Right Arm", 5)
                    connectParts("Torso", "Left Leg", 7)
                    connectParts("Torso", "Right Leg", 9)
                    -- Esconde linhas desnecessárias do R15 no modo R6
                    Bones[2].Visible = false
                    Bones[4].Visible = false
                    Bones[6].Visible = false
                    Bones[8].Visible = false
                    Bones[10].Visible = false
                end
            else
                for _, b in ipairs(Bones) do b.Visible = false end
            end

        else
            Clear()
        end
    end)
end

-- Roda o ESP para quem já está no servidor
for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(function() ApplyESP(p) end)
end

-- Registra novos jogadores que entrarem na partida
Players.PlayerAdded:Connect(function(p)
    task.spawn(function() ApplyESP(p) end)
end)
