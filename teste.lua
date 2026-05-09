-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V1.3 (PASSO 1: CÁPSULA ESPACIAL & NINJA ROXO)
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
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================
-- CÁPSULA FLUTUANTE (FUNDO SÓLIDO ESPACIAL)
-- ==========================================
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")

Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 165, 0, 42)
Capsule.Position = UDim2.new(0.05, 0, 0.4, 0)
Capsule.BackgroundColor3 = Color3.fromRGB(10, 10, 12) -- Fundo totalmente sólido
Capsule.BackgroundTransparency = 0
Capsule.Active = true
Capsule.ClipsDescendants = true -- Corta as bolhas para elas não saírem da cápsula
Capsule.Parent = ScreenGui

CapsuleCorner.CornerRadius = UDim.new(0, 21)
CapsuleCorner.Parent = Capsule

CapsuleStroke.Color = Color3.fromRGB(90, 60, 160) -- Roxo escuro premium
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

-- Criar 8 pequenas bolinhas/estrelas flutuantes
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

-- Animação infinita das bolinhas
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
-- CONTEÚDO DA CÁPSULA (SOBRE AS PARTÍCULAS)
-- ==========================================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2
ContentFrame.Parent = Capsule

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 8) -- Ajustado espaçamento
Layout.Parent = ContentFrame

-- Texto: BK CLIENT V1
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Size = UDim2.new(0, 100, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "BK CLIENT V1"
TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamBold
TextLabel.ZIndex = 3
TextLabel.Parent = ContentFrame

-- ÍCONE DE MÁSCARA NINJA (ESTILIZADO EM ROXO NEON)
local NinjaIcon = Instance.new("TextLabel")
NinjaIcon.Name = "NinjaIcon"
NinjaIcon.Size = UDim2.new(0, 24, 0, 24)
NinjaIcon.BackgroundTransparency = 1
NinjaIcon.Text = "🥷" -- Usando o caractere de ninja base com modificação de cor via código para dar contraste
NinjaIcon.TextSize = 20
NinjaIcon.Font = Enum.Font.GothamBold
NinjaIcon.ZIndex = 3
NinjaIcon.Parent = ContentFrame

-- Sobreposição de Cor Roxo Neon no Ninja (Efeito Silhouette profissional)
local GlowLabel = Instance.new("TextLabel")
GlowLabel.Size = UDim2.new(1, 0, 1, 0)
GlowLabel.BackgroundTransparency = 1
GlowLabel.Text = "🥷"
GlowLabel.TextSize = 20
GlowLabel.Font = Enum.Font.GothamBold
GlowLabel.TextColor3 = Color3.fromRGB(140, 80, 255) -- Tom Roxo Puro Neon
GlowLabel.TextTransparency = 0.45 -- Sobreposição sutil que puxa os detalhes do Ninja para o roxo
GlowLabel.ZIndex = 4
GlowLabel.Parent = NinjaIcon

-- ==========================================
-- SISTEMA DE ANIMAÇÃO DO NINJA (PULSAÇÃO SUAVE)
-- ==========================================
task.spawn(function()
    while true do
        pcall(function()
            -- Pulsação suave do tamanho e do brilho roxo
            local tweenOn = TweenService:Create(GlowLabel, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextColor3 = Color3.fromRGB(190, 130, 255),
                TextSize = 22
            })
            local tweenOnBase = TweenService:Create(NinjaIcon, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextSize = 22
            })
            
            tweenOn:Play()
            tweenOnBase:Play()
            tweenOn.Completed:Wait()
            
            local tweenOff = TweenService:Create(GlowLabel, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextColor3 = Color3.fromRGB(110, 40, 200),
                TextSize = 18
            })
            local tweenOffBase = TweenService:Create(NinjaIcon, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                TextSize = 18
            })
            
            tweenOff:Play()
            tweenOffBase:Play()
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

print("[BK CLIENT] Passo 1: Capsula Espacial V1.3 (Ninja) Carregada!")
