-- ====================================================================
-- BK CLIENT - VERSÃO OFICIAL V1.6 (PASSO 2: CONTROLE DE MENU PELA CÁPSULA)
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

-- Configurações de tamanho da Cápsula
local CAPSULE_NORMAL_SIZE = UDim2.new(0, 180, 0, 46)
local CAPSULE_MINI_SIZE = UDim2.new(0, 46, 0, 46)

local BGColor = Color3.fromRGB(10, 10, 12)
local BorderColor = Color3.fromRGB(50, 50, 50)

-- ==========================================
-- CÁPSULA FLUTUANTE (CONTROLE DO MENU)
-- ==========================================
local Capsule = Instance.new("Frame")
local CapsuleCorner = Instance.new("UICorner")
local CapsuleStroke = Instance.new("UIStroke")

Capsule.Name = "BK_Capsule"
Capsule.Size = CAPSULE_NORMAL_SIZE
Capsule.Position = UDim2.new(0.05, 0, 0.3, 0) -- Posição inicial
Capsule.BackgroundColor3 = BGColor
Capsule.BackgroundTransparency = 0
Capsule.Active = true
Capsule.ClipsDescendants = true
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
-- CONTEÚDO DA CÁPSULA (AVATAR E TEXTO)
-- ==========================================
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2
ContentFrame.Parent = Capsule

local Layout = Instance.new("UIListLayout")
Layout.FillDirection = Enum.FillDirection.Horizontal
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 10)
Layout.Parent = ContentFrame

local PaddingL = Instance.new("UIPadding")
PaddingL.PaddingLeft = UDim.new(0, 7) -- Ajustado para centralizar bem quando mini
PaddingL.Parent = ContentFrame

-- IMAGEM DE PERFIL
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(0, 32, 0, 32)
AvatarImage.BackgroundTransparency = 1
AvatarImage.BorderSizePixel = 0
AvatarImage.ZIndex = 3
AvatarImage.Parent = ContentFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

task.spawn(function()
    pcall(function()
        AvatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png"
    end)
end)

-- TEXTO BK CLIENT V1
local TextLabel = Instance.new("TextLabel")
TextLabel.Name = "TextLabel"
TextLabel.Size = UDim2.new(0, 110, 0, 20)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "BK CLIENT V1"
TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 3
TextLabel.Parent = ContentFrame


-- ==========================================
-- PAINEL PRINCIPAL DE TESTES (SÓ O QUADRADO)
-- ==========================================
local MainMenu = Instance.new("Frame")
local MenuCorner = Instance.new("UICorner")
local MenuStroke = Instance.new("UIStroke")

MainMenu.Name = "BK_MainMenu"
-- Quadrado de testes perfeito e otimizado
MainMenu.Size = UDim2.new(0, 300, 0, 300) 
-- Posição do menu diretamente acoplada logo abaixo da cápsula (dinâmico)
MainMenu.Position = UDim2.new(0, 0, 1, 10) 
MainMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainMenu.BackgroundTransparency = 1 -- Invisível ao iniciar
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Parent = Capsule -- Menu vira "filho" da cápsula para mover junto de forma automática!

MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MainMenu

MenuStroke.Color = Color3.fromRGB(45, 45, 50)
MenuStroke.Thickness = 1.5
MenuStroke.Transparency = 1
MenuStroke.Parent = MainMenu


-- ==========================================
-- LÓGICA DE ABRIR E FECHAR O MENU (TWEEN)
-- ==========================================
local isMenuOpen = false

local function toggleMenu()
    isMenuOpen = not isMenuOpen
    
    if isMenuOpen then
        -- 1. Animação de Encolher a Cápsula para o formato mini (apenas a carinha do jogador)
        TweenService:Create(Capsule, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = CAPSULE_MINI_SIZE
        }):Play()
        
        -- Sumir com o texto do BK CLIENT V1 suavemente
        TweenService:Create(TextLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 1
        }):Play()
        
        -- 2. Mostrar o Menu de Testes
        MainMenu.Visible = true
        TweenService:Create(MainMenu, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(MenuStroke, TweenInfo.new(0.3), {
            Transparency = 0
        }):Play()
        
    else
        -- 1. Esconder o Menu de Testes suavemente
        local menuTween = TweenService:Create(MainMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        TweenService:Create(MenuStroke, TweenInfo.new(0.2), {
            Transparency = 1
        }):Play()
        
        menuTween:Play()
        menuTween.Completed:Connect(function()
            if not isMenuOpen then
                MainMenu.Visible = false
            end
        end)
        
        -- 2. Voltar a Cápsula para o tamanho normal de perfil
        TweenService:Create(Capsule, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = CAPSULE_NORMAL_SIZE
        }):Play()
        
        -- Reaparecer o texto
        TweenService:Create(TextLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
    end
end


-- ==========================================
-- SISTEMA DE ARRASTE INTEGRADO (CÁPSULA + MENU)
-- ==========================================
local dragging = false
local dragStart, startPos

Capsule.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Capsule.Position
        
        -- Captura o clique rápido para abrir/fechar o menu sem bugar o arraste
        local inputEndedConnection
        inputEndedConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                inputEndedConnection:Disconnect()
                
                -- Se o movimento foi mínimo, considera um clique
                if (input.Position - dragStart).Magnitude < 8 then
                    toggleMenu()
                end
            end
        end)
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

print("[BK CLIENT] Passo 2: Estrutura do Menu e Controle da Cápsula Ativados!")
