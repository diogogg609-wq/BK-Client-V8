-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V1.5 (PASSO 1: CÁPSULA ESTÁVEL ANDROID)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

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

-- Paleta Dark Minimalista
local BGColor = Color3.fromRGB(10, 10, 12) -- Fundo totalmente sólido e escuro
local BorderColor = Color3.fromRGB(50, 50, 50) -- Borda externa discreta

-- ==========================================
-- CÁPSULA FLUTUANTE (FUNDO SÓLIDO ESPACIAL)
-- ==========================================
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")

Capsule.Name = "BK_Capsule"
Capsule.Size = UDim2.new(0, 180, 0, 46) -- Ajustado para caber o perfil confortavelmente
Capsule.Position = UDim2.new(0.05, 0, 0.4, 0)
Capsule.BackgroundColor3 = BGColor
Capsule.BackgroundTransparency = 0 -- ZERO transparência
Capsule.Active = true
Capsule.ClipsDescendants = true -- Corta as bolhas para elas não saírem da cápsula
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
ContentFrame.ZIndex = 2 -- Garante que o conteúdo fique acima do espaço
ContentFrame.Parent = Capsule

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left -- Alinhado à esquerda
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 10)
Layout.Parent = ContentFrame

-- Margem esquerda
local PaddingL = Instance.new("UIPadding")
PaddingL.PaddingLeft = UDim.new(0, 10)
PaddingL.Parent = ContentFrame

-- IMAGEM DE PERFIL (HEADSHOT REAL) - FIXED ESTÁVEL
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(0, 32, 0, 32)
AvatarImage.BackgroundTransparency = 1
AvatarImage.BorderSizePixel = 0 -- Sem borda que buga no Delta
AvatarImage.Image = "" -- Inicialmente vazio
AvatarImage.ZIndex = 3
AvatarImage.Parent = ContentFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0) -- Perfeitamente redondo
AvatarCorner.Parent = AvatarImage

-- Carregamento seguro do Avatar Real do Jogador (Mobile Otimizado)
task.spawn(function()
    pcall(function()
        -- Puxa o headshot do Roblox em 150x150 de forma assíncrona
        local content, isLoaded = Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
        if isLoaded then
             AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
        else
             -- Fallback caso a API do Roblox demore
             AvatarImage.Image = "rbxassetid://6031094028" -- Ícone discreto
        end
    end)
end)

-- Texto: BK CLIENT V1
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Size = UDim2.new(0, 100, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "BK CLIENT V1"
TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left -- Alinhado à esquerda ao lado da foto
TextLabel.ZIndex = 3
TextLabel.Parent = ContentFrame

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

print("[BK CLIENT] Passo 1: Capsula V1.5 Estável Carregada no Android!")
