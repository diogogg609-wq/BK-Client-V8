-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V1.1 (PASSO 1: CÁPSULA AJUSTADA & NOTIFICAÇÃO)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

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
        Icon = "rbxassetid://6031094028", -- Ícone discreto e elegante
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

-- Suporte seguro para injeção no CoreGui do Delta Android
local successParent = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not successParent then
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================
-- CÁPSULA FLUTUANTE ULTRA OTIMIZADA
-- ==========================================
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")
local Layout = Instance.new("UIListLayout")

Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 165, 0, 42) -- Ajustado levemente na largura para o novo tamanho do raio
Capsule.Position = UDim2.new(0.05, 0, 0.4, 0)
Capsule.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Capsule.BackgroundTransparency = 0.15
Capsule.Active = true
Capsule.ClipsDescendants = false
Capsule.Parent = ScreenGui

CapsuleCorner.CornerRadius = UDim.new(0, 21)
CapsuleCorner.Parent = Capsule

CapsuleStroke.Color = Color3.fromRGB(90, 60, 160) -- Roxo escuro premium (menos saturado)
CapsuleStroke.Thickness = 1.5
CapsuleStroke.Parent = Capsule

-- Layout para alinhar o texto e o raio perfeitamente lado a lado
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Capsule

-- Texto: BK CLIENT V1
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Size = UDim2.new(0, 100, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "BK CLIENT V1"
TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Parent = Capsule

-- Raio Roxo Brilhante Maior (Sem usar ID de imagem para máxima estabilidade no Delta)
local GlowRay = Instance.new("TextLabel")
GlowRay.Name = "GlowRay"
GlowRay.Size = UDim2.new(0, 22, 0, 22) -- Tamanho do frame aumentado
GlowRay.BackgroundTransparency = 1
GlowRay.Text = "⚡"
GlowRay.TextColor3 = Color3.fromRGB(130, 80, 255) -- Roxo brilhante inicial
GlowRay.TextSize = 18 -- Raio maior como você pediu!
GlowRay.Font = Enum.Font.GothamBold
GlowRay.Parent = Capsule

-- ==========================================
-- SISTEMA DE ANIMAÇÃO DO RAIO (PULSAÇÃO EM ROXO)
-- ==========================================
task.spawn(function()
    while true do
        pcall(function()
            -- Intercala o brilho e o tamanho do raio maior suavemente
            local tweenOn = TweenService:Create(GlowRay, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextColor3 = Color3.fromRGB(180, 130, 255),
                TextSize = 20 -- Pulsação máxima maior
            })
            tweenOn:Play()
            tweenOn.Completed:Wait()
            
            local tweenOff = TweenService:Create(GlowRay, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextColor3 = Color3.fromRGB(110, 50, 220),
                TextSize = 17 -- Pulsação mínima maior
            })
            tweenOff:Play()
            tweenOff.Completed:Wait()
        end)
        task.wait(0.1)
    end
end)

-- ==========================================
-- SISTEMA DE ARRASTE ULTRA FLUIDO PARA ANDROID
-- ==========================================
local dragging = false
local dragStart, startPos

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
        dragging = false
    end
end)

print("[BK CLIENT] Passo 1: Capsula V1.1 Carregada e Notificada no Android!")
