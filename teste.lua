-- ==========================================
-- BK CLIENT v1.4 † - ROBLOX MOBILE SCRIPT
-- ==========================================

local Players = game:Service("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:Service("RunService")
local UserInputService = game:Service("UserInputService")

-- Criando a interface principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BKClient_V14"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tentando injetar na pasta segura do CoreGui para evitar detecções
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Variaveis de Estado (Ativação das Funções)
local ESP_Active = {
    Lines = false,
    Names = false,
    Weapons = false,
    Distance = false,
    Health = false,
    Skeleton = false,
    Boxes = false
}

local Extra_Active = {
    SuperJump = false,
    SuperSpeed = false
}

local JumpPowerValue = 150
local SpeedValue = 100

-- ==========================================
-- 1. SISTEMA DA CÁPSULA FLUTUANTE (BUBBLE)
-- ==========================================

local Bubble = Instance.new("TextButton")
Bubble.Name = "BK_Bubble"
Bubble.Size = UDim2.new(0, 140, 0, 45)
Bubble.Position = UDim2.new(0.1, 0, 0.2, 0)
Bubble.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Bubble.BorderSizePixel = 0
Bubble.Text = "BK CLIENT v1.4 †"
Bubble.TextColor3 = Color3.fromRGB(255, 0, 0) -- Letras vermelhas ameaçadoras
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 13
Bubble.ClipsDescendants = true
Bubble.Parent = ScreenGui

-- Cantos arredondados na bolha
local BubbleCorner = Instance.new("UICorner")
BubbleCorner.CornerRadius = UDim.new(0, 12)
BubbleCorner.Parent = Bubble

-- Borda Vermelha Neon na Bolha
local BubbleStroke = Instance.new("UIStroke")
BubbleStroke.Color = Color3.fromRGB(200, 0, 0)
BubbleStroke.Thickness = 2
BubbleStroke.Parent = Bubble

-- Tornar a bolha arrastável em celulares
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    Bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Bubble.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Bubble.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        update(dragInput)
    end
end)

-- ==========================================
-- 2. CRIAÇÃO DO PAINEL PRINCIPAL (MENU)
-- ==========================================

local MainPanel = Instance.new("Frame")
MainPanel.Name = "BK_MainPanel"
MainPanel.Size = UDim2.new(0, 320, 0, 240)
MainPanel.Position = UDim2.new(0.5, -160, 0.5, -120)
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

-- Alternar Menu ao Clicar na Bolha
Bubble.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

-- Título do Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "BK CLIENT v1.4  [ PRIVATE ]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = MainPanel

-- Container de Abas
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainPanel

-- Páginas de Conteúdo
local PageESP = Instance.new("ScrollingFrame")
PageESP.Size = UDim2.new(1, -20, 1, -75)
PageESP.Position = UDim2.new(0, 10, 0, 65)
PageESP.BackgroundTransparency = 1
PageESP.BorderSizePixel = 0
PageESP.ScrollBarThickness = 2
PageESP.Visible = true
PageESP.Parent = MainPanel

local PageExtra = Instance.new("ScrollingFrame")
PageExtra.Size = UDim2.new(1, -20, 1, -75)
PageExtra.Position = UDim2.new(0, 10, 0, 65)
PageExtra.BackgroundTransparency = 1
PageExtra.BorderSizePixel = 0
PageExtra.ScrollBarThickness = 2
PageExtra.Visible = false
PageExtra.Parent = MainPanel

-- Layouts automáticos das listas
local espLayout = Instance.new("UIListLayout")
espLayout.Padding = UDim.new(0, 6)
espLayout.Parent = PageESP

local extraLayout = Instance.new("UIListLayout")
extraLayout.Padding = UDim.new(0, 6)
extraLayout.Parent = PageExtra

-- Botões de Alternar Abas (ESP vs EXTRA)
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
-- 3. FUNÇÃO CRIADORA DE CHECKS (BUTTONS)
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
-- 4. ADICIONANDO AS FUNÇÕES DO PAINEL
-- ==========================================

-- ABA ESP
CreateToggle(PageESP, "ESP LINE", false, function(v) ESP_Active.Lines = v end)
CreateToggle(PageESP, "ESP NOME", false, function(v) ESP_Active.Names = v end)
CreateToggle(PageESP, "ESP ARMA", false, function(v) ESP_Active.Weapons = v end)
CreateToggle(PageESP, "ESP DISTÂNCIA", false, function(v) ESP_Active.Distance = v end)
CreateToggle(PageESP, "ESP VIDA", false, function(v) ESP_Active.Health = v end)
CreateToggle(PageESP, "ESP BOX", false, function(v) ESP_Active.Boxes = v end)
CreateToggle(PageESP, "ESP ESQUELETO (R15/R20)", false, function(v) ESP_Active.Skeleton = v end)

-- ABA EXTRA
CreateToggle(PageExtra, "SUPER PULO", false, function(v) 
    Extra_Active.SuperJump = v 
end)

CreateToggle(PageExtra, "SUPER VELOCIDADE", false, function(v) 
    Extra_Active.SuperSpeed = v 
end)

-- Loop para manter Super Pulo e Super Velocidade ativos no boneco
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if Extra_Active.SuperSpeed then
            hum.WalkSpeed = SpeedValue
        else
            hum.WalkSpeed = 16 -- Velocidade original padrão
        end
        
        if Extra_Active.SuperJump then
            hum.JumpPower = JumpPowerValue
            hum.UseJumpPower = true
        else
            hum.JumpPower = 50 -- Pulo original padrão
        end
    end
end)

-- ==========================================
-- 5. ENGINE DE DESENHO DO ESP (2D DRAWING)
-- ==========================================

local function DrawESP(player)
    if player == LocalPlayer then return end

    -- Elementos do Desenho
    local Line = Drawing.new("Line")
    local Name = Drawing.new("Text")
    local Box = Drawing.new("Square")
    local SkeletonLines = {}

    local function Clear()
        Line.Visible = false
        Name.Visible = false
        Box.Visible = false
        for _, sLine in pairs(SkeletonLines) do
            sLine.Visible = false
        end
    end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not player.Parent or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            Clear()
            if not player.Parent then
                connection:Disconnect()
                Line:Remove()
                Name:Remove()
                Box:Remove()
                for _, sLine in pairs(SkeletonLines) do sLine:Remove() end
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
            -- 1. ESP LINE (Linha saindo de baixo para o inimigo)
            if ESP_Active.Lines then
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Line.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
                Line.Color = Color3.fromRGB(255, 0, 0)
                Line.Thickness = 1.2
                Line.Transparency = 1
                Line.Visible = true
            else
                Line.Visible = false
            end

            -- 2. ESP INFORMAÇÕES (Nome, Distância, Vida, Arma)
            if ESP_Active.Names or ESP_Active.Distance or ESP_Active.Health or ESP_Active.Weapons then
                local textStr = ""
                if ESP_Active.Names then textStr = textStr .. player.Name .. " " end
                if ESP_Active.Health then textStr = textStr .. "[" .. math.floor(Humanoid.Health) .. " HP] " end
                if ESP_Active.Distance then 
                    local dist = math.floor((RootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    textStr = textStr .. "(" .. dist .. "m) " 
                end
                if ESP_Active.Weapons then
                    local toolName = "Nenhum"
                    local activeTool = Char:FindFirstChildOfClass("Tool")
                    if activeTool then toolName = activeTool.Name end
                    textStr = textStr .. "{" .. toolName .. "}"
                end

                Name.Text = textStr
                Name.Position = Vector2.new(ScreenPos.X, ScreenPos.Y - 45)
                Name.Size = 13
                Name.Center = true
                Name.Outline = true
                Name.Color = Color3.fromRGB(255, 255, 255)
                Name.Visible = true
            else
                Name.Visible = false
            end

            -- 3. ESP BOX (Caixa ao redor do oponente)
            if ESP_Active.Boxes then
                local SizeX = 2000 / ScreenPos.Z
                local SizeY = 3000 / ScreenPos.Z
                Box.Size = Vector2.new(SizeX, SizeY)
                Box.Position = Vector2.new(ScreenPos.X - SizeX / 2, ScreenPos.Y - SizeY / 2)
                Box.Color = Color3.fromRGB(200, 0, 0)
                Box.Thickness = 1.5
                Box.Filled = false
                Box.Visible = true
            else
                Box.Visible = false
            end

            -- 4. ESP ESQUELETO (R15 / R20 / R6)
            if ESP_Active.Skeleton then
                local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", "RightUpperArm", "RightLowerArm", "LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
                local validParts = {}

                for _, pName in ipairs(parts) do
                    local p = Char:FindFirstChild(pName)
                    if p then validParts[pName] = p end
                end

                local function drawBone(part1, part2, index)
                    if part1 and part2 then
                        local p1, o1 = Camera:WorldToViewportPoint(part1.Position)
                        local p2, o2 = Camera:WorldToViewportPoint(part2.Position)
                        if o1 and o2 then
                            if not SkeletonLines[index] then
                                SkeletonLines[index] = Drawing.new("Line")
                            end
                            local sLine = SkeletonLines[index]
                            sLine.From = Vector2.new(p1.X, p1.Y)
                            sLine.To = Vector2.new(p2.X, p2.Y)
                            sLine.Color = Color3.fromRGB(255, 255, 255)
                            sLine.Thickness = 1
                            sLine.Visible = true
                            return
                        end
                    end
                    if SkeletonLines[index] then SkeletonLines[index].Visible = false end
                end

                -- Conexões do esqueleto
                drawBone(validParts["Head"], validParts["UpperTorso"] or validParts["Torso"], 1)
                drawBone(validParts["UpperTorso"] or validParts["Torso"], validParts["LowerTorso"] or validParts["Torso"], 2)
                -- Braço Esquerdo
                drawBone(validParts["UpperTorso"] or validParts["Torso"], validParts["LeftUpperArm"] or validParts["Left Arm"], 3)
                drawBone(validParts["LeftUpperArm"], validParts["LeftLowerArm"], 4)
                -- Braço Direito
                drawBone(validParts["UpperTorso"] or validParts["Torso"], validParts["RightUpperArm"] or validParts["Right Arm"], 5)
                drawBone(validParts["RightUpperArm"], validParts["RightLowerArm"], 6)
                -- Perna Esquerda
                drawBone(validParts["LowerTorso"] or validParts["Torso"], validParts["LeftUpperLeg"] or validParts["Left Leg"], 7)
                drawBone(validParts["LeftUpperLeg"], validParts["LeftLowerLeg"], 8)
                -- Perna Direita
                drawBone(validParts["LowerTorso"] or validParts["Torso"], validParts["RightUpperLeg"] or validParts["Right Leg"], 9)
                drawBone(validParts["RightUpperLeg"], validParts["RightLowerLeg"], 10)
            else
                for _, sLine in pairs(SkeletonLines) do
                    sLine.Visible = false
                end
            end

        else
            Clear()
        end
    end)
end

-- Rodar o ESP para todos os jogadores presentes e futuros
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function() DrawESP(player) end)
end
Players.PlayerAdded:Connect(function(player)
    task.spawn(function() DrawESP(player) end)
end)
