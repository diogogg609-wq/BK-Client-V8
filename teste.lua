-- =================================================================
-- BK CLIENT v1.5 [Beta] - PC STYLE INJECTOR LAYOUT
-- NO EFFECTS - GREY THEME - MINIMAL COLOR
-- Abas: Status, Opções, Mira, Visual, Extras, Gráficos
-- Pronto para hospedagem no GitHub / Loadstring
-- =================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local MemoryStoreService = game:GetService("MemoryStoreService")

-- Evita execução duplicada
if CoreGui:FindFirstChild("BKClient_V15") then
    CoreGui:FindFirstChild("BKClient_V15"):Destroy()
end

-- Criando a ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BKClient_V15"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- ==========================================
-- CONFIGURAÇÕES DA FUNÇÃO ESP (SALVÁVEIS)
-- ==========================================
local ESP_Config = {
    Active = false,
    Thickness = 1.5,
    Color = Color3.fromRGB(255, 0, 0),
    Origin = "Bottom" -- "Bottom" ou "Top"
}

-- ==========================================
-- 1. SISTEMA DA BOLHA FLUTUANTE (PRETA, TEXTO BRANCO, SEM EFEITOS)
-- ==========================================

local Bubble = Instance.new("TextButton")
Bubble.Name = "BKBubble_v15"
Bubble.Size = UDim2.new(0, 150, 0, 48)
Bubble.Position = UDim2.new(0.05, 0, 0.15, 0)
Bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bubble.BorderSizePixel = 0
Bubble.Text = "BK CLIENT v1.5 †"
Bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
Bubble.Font = Enum.Font.GothamBold
Bubble.TextSize = 13
Bubble.Active = true
Bubble.Draggable = true
Bubble.Parent = ScreenGui

local BubbleCorner = Instance.new("UICorner")
BubbleCorner.CornerRadius = UDim.new(0, 14)
BubbleCorner.Parent = Bubble

-- ==========================================
-- 2. PAINEL PRINCIPAL PREMIUM (CINZA, BORDAS ARREDONDADAS)
-- ==========================================

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 440, 0, 320)
MainPanel.Position = UDim2.new(0.5, -220, 0.5, -160)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainPanel.BorderSizePixel = 0
MainPanel.ClipsDescendants = true
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 16)
PanelCorner.Parent = MainPanel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = Color3.fromRGB(30, 30, 30)
PanelStroke.Thickness = 1.5
PanelStroke.Parent = MainPanel

-- Sub-Painel de Customização da LINE (Configurações extras)
local SubPanel = Instance.new("Frame")
SubPanel.Name = "SubPanel"
SubPanel.Size = UDim2.new(0, 200, 0, 220)
SubPanel.Position = UDim2.new(0.5, 230, 0.5, -110) -- Aparece elegantemente ao lado direito do menu principal
SubPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
SubPanel.BorderSizePixel = 0
SubPanel.Visible = false
SubPanel.Parent = ScreenGui

local SubCorner = Instance.new("UICorner")
SubCorner.CornerRadius = UDim.new(0, 12)
SubCorner.Parent = SubPanel

local SubStroke = Instance.new("UIStroke")
SubStroke.Color = Color3.fromRGB(40, 40, 40)
SubStroke.Thickness = 1.5
SubStroke.Parent = SubPanel

-- Lógica de abrir/fechar simplificada
local isMenuOpen = false
Bubble.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    
    if isMenuOpen then
        MainPanel.Size = UDim2.new(0, 0, 0, 0)
        MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainPanel.Visible = true
        
        local openTween = TweenService:Create(MainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 440, 0, 320),
            Position = UDim2.new(0.5, -220, 0.5, -160)
        })
        openTween:Play()
    else
        SubPanel.Visible = false
        local closeTween = TweenService:Create(MainPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not isMenuOpen then MainPanel.Visible = false end
        end)
    end
end)

-- ==========================================
-- 3. HEADER MINIMALISTA COM INDICADOR ONLINE REAL
-- ==========================================

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "BK CLIENT v1.5 [Beta]"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainPanel

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleLabel

local TitlePadding = Instance.new("UIPadding")
TitlePadding.PaddingLeft = UDim.new(0, 15)
TitlePadding.Parent = TitleLabel

local OnlineIndicator = Instance.new("Frame")
OnlineIndicator.Name = "OnlineIndicator"
OnlineIndicator.Size = UDim2.new(0, 8, 0, 8)
OnlineIndicator.Position = UDim2.new(1, -95, 0.5, -4)
OnlineIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
OnlineIndicator.BorderSizePixel = 0
OnlineIndicator.Parent = TitleLabel

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(1, 0)
IndicatorCorner.Parent = OnlineIndicator

local OnlineText = Instance.new("TextLabel")
OnlineText.Name = "OnlineText"
OnlineText.Size = UDim2.new(0, 80, 1, 0)
OnlineText.Position = UDim2.new(1, 5, 0, 0)
OnlineText.BackgroundTransparency = 1
OnlineText.Text = "1 ONLINE"
OnlineText.TextColor3 = Color3.fromRGB(150, 150, 150)
OnlineText.Font = Enum.Font.GothamBold
OnlineText.TextSize = 10
OnlineText.TextXAlignment = Enum.TextXAlignment.Left
OnlineText.Parent = OnlineIndicator

local function StartOnlineCounter()
    local success, lobbyMap = pcall(function()
        return MemoryStoreService:GetSortedMap("BKClient_ActiveUsers")
    end)
    
    if not success or not lobbyMap then 
        task.spawn(function()
            while true do
                local currentPlayers = #Players:GetPlayers()
                OnlineText.Text = tostring(currentPlayers) .. " ONLINE"
                task.wait(10)
            end
        end)
        return 
    end

    local function updatePresence()
        pcall(function()
            lobbyMap:SetAsync(LocalPlayer.Name, true, 45)
        end)
    end

    local function fetchOnlineCount()
        pcall(function()
            local count = 0
            local exclusiveLowerBound = nil
            while true do
                local items = lobbyMap:GetRangeAsync(Enum.SortDirection.Ascending, 100, exclusiveLowerBound)
                if #items == 0 then break end
                count = count + #items
                exclusiveLowerBound = items[#items].key
                if #items < 100 then break end
            end
            if count == 0 then count = 1 end
            OnlineText.Text = tostring(count) .. " ONLINE"
        end)
    end

    task.spawn(function()
        while true do
            updatePresence()
            fetchOnlineCount()
            task.wait(20)
        end
    end)
end
task.spawn(StartOnlineCounter)

-- ==========================================
-- 4. CONTAINER DE ABAS SUPERIORES (HORIZONTAL)
-- ==========================================

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 32)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainPanel

local TabLayout = Instance.new("UIGridLayout")
TabLayout.CellSize = UDim2.new(1/7, 0, 1, 0)
TabLayout.CellPadding = UDim2.new(0, 0, 0, 0)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabContainer

local TabLine = Instance.new("Frame")
TabLine.Size = UDim2.new(1, 0, 0, 1)
TabLine.Position = UDim2.new(0, 0, 1, -1)
TabLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TabLine.BorderSizePixel = 0
TabLine.Parent = TabContainer

local ContainerPages = Instance.new("Frame")
ContainerPages.Size = UDim2.new(1, -20, 1, -72)
ContainerPages.Position = UDim2.new(0, 10, 0, 72)
ContainerPages.BackgroundTransparency = 1
ContainerPages.Parent = MainPanel

local Pages = {}
local TabButtons = {}

local function CreatePage(name, isProfile, isVisual)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = "Page_" .. name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.CanvasSize = UDim2.new(0, 0, 0, 200)
    Page.Visible = false
    Page.Parent = ContainerPages
    
    if isProfile then
        local ProfileCard = Instance.new("Frame")
        ProfileCard.Size = UDim2.new(1, 0, 1, 0)
        ProfileCard.BackgroundTransparency = 1
        ProfileCard.Parent = Page

        local ProfileImg = Instance.new("ImageLabel")
        ProfileImg.Size = UDim2.new(0, 70, 0, 70)
        ProfileImg.Position = UDim2.new(0.5, -35, 0.15, 0)
        ProfileImg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ProfileImg.BorderSizePixel = 0
        ProfileImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
        ProfileImg.Parent = ProfileCard

        local ImgCorner = Instance.new("UICorner")
        ImgCorner.CornerRadius = UDim.new(0, 35)
        ImgCorner.Parent = ProfileImg

        local ImgStroke = Instance.new("UIStroke")
        ImgStroke.Color = Color3.fromRGB(60, 60, 60)
        ImgStroke.Thickness = 1.5
        ImgStroke.Parent = ProfileImg

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, 0, 0, 25)
        NameLabel.Position = UDim2.new(0, 0, 0.15, 80)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = LocalPlayer.DisplayName
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextSize = 14
        NameLabel.Parent = ProfileCard

        local CompanyLabel = Instance.new("TextLabel")
        CompanyLabel.Size = UDim2.new(1, 0, 0, 20)
        CompanyLabel.Position = UDim2.new(0, 0, 0.15, 105)
        CompanyLabel.BackgroundTransparency = 1
        CompanyLabel.Text = "BK CLIENT †"
        CompanyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        CompanyLabel.Font = Enum.Font.GothamBold
        CompanyLabel.TextSize = 11
        CompanyLabel.Parent = ProfileCard
    elseif isVisual then
        -- LIST LAYOUT PARA ADICIONAR AS FUNÇÕES VISUAIS FUTURAS
        local VisualLayout = Instance.new("UIListLayout")
        VisualLayout.Padding = UDim.new(0, 8)
        VisualLayout.Parent = Page
    else
        local SoonText = Instance.new("TextLabel")
        SoonText.Size = UDim2.new(1, 0, 1, 0)
        SoonText.BackgroundTransparency = 1
        SoonText.Text = "EM BREVE NA PRÓXIMA ATUALIZAÇÃO"
        SoonText.TextColor3 = Color3.fromRGB(100, 100, 100)
        SoonText.Font = Enum.Font.GothamMedium
        SoonText.TextSize = 13
        SoonText.Parent = Page
    end
    
    Pages[name] = Page
    return Page
end

local PageStatus = CreatePage("Status", false, false)
local PageOpcoes = CreatePage("Opcoes", false, false)
local PageMira = CreatePage("Mira", false, false)
local PageVisual = CreatePage("Visual", false, true) -- Ativado layout de lista na aba Visual
local PageExtras = CreatePage("Extras", false, false)
local PagePerfil = CreatePage("Perfil", true, false)
local PageGraficos = CreatePage("Graficos", false, false)

PageStatus.Visible = true

local function AddTabBtn(name, displayName, layoutOrder, isDefault)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundColor3 = isDefault and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(15, 15, 15)
    Btn.BorderSizePixel = 0
    Btn.Text = displayName:upper()
    Btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 9
    Btn.LayoutOrder = layoutOrder
    Btn.Parent = TabContainer

    Btn.MouseButton1Click:Connect(function()
        for tName, tBtn in pairs(TabButtons) do
            local isCurrent = (tName == name)
            tBtn.BackgroundColor3 = isCurrent and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(15, 15, 15)
            tBtn.TextColor3 = isCurrent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
            Pages[tName].Visible = isCurrent
        end
    end)
    
    TabButtons[name] = Btn
end

AddTabBtn("Status", "Status", 1, true)
AddTabBtn("Opcoes", "Opções", 2, false)
AddTabBtn("Mira", "Mira", 3, false)
AddTabBtn("Visual", "Visual", 4, false)
AddTabBtn("Extras", "Extras", 5, false)
AddTabBtn("Perfil", "Perfil", 6, false)
AddTabBtn("Graficos", "Gráficos", 7, false)

-- ==========================================
-- 5. CONSTRUÇÃO DO SUB-PAINEL DE PERSONALIZAÇÃO
-- ==========================================

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 30)
SubTitle.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
SubTitle.BorderSizePixel = 0
SubTitle.Text = "LINE CONFIGS ⚙️"
SubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 10
SubTitle.Parent = SubPanel

local SubTitleCorner = Instance.new("UICorner")
SubTitleCorner.CornerRadius = UDim.new(0, 12)
SubTitleCorner.Parent = SubTitle

-- Ajuste de Espessura (Thickness)
local ThickLabel = Instance.new("TextLabel")
ThickLabel.Size = UDim2.new(1, 0, 0, 20)
ThickLabel.Position = UDim2.new(0, 10, 0, 40)
ThickLabel.BackgroundTransparency = 1
ThickLabel.Text = "ESPESSURA: 1.5"
ThickLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ThickLabel.Font = Enum.Font.GothamBold
ThickLabel.TextSize = 9
ThickLabel.TextXAlignment = Enum.TextXAlignment.Left
ThickLabel.Parent = SubPanel

local ThickSlider = Instance.new("TextButton")
ThickSlider.Size = UDim2.new(0.9, 0, 0, 18)
ThickSlider.Position = UDim2.new(0.05, 0, 0, 60)
ThickSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ThickSlider.BorderSizePixel = 0
ThickSlider.Text = "MUDAR ESPESSURA"
ThickSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ThickSlider.Font = Enum.Font.GothamBold
ThickSlider.TextSize = 8
ThickSlider.Parent = SubPanel

local ThickCorner = Instance.new("UICorner")
ThickCorner.CornerRadius = UDim.new(0, 4)
ThickCorner.Parent = ThickSlider

-- Alterna a espessura entre 1.0, 1.5, 2.5, 4.0
ThickSlider.MouseButton1Click:Connect(function()
    if ESP_Config.Thickness == 1.5 then
        ESP_Config.Thickness = 2.5
    elseif ESP_Config.Thickness == 2.5 then
        ESP_Config.Thickness = 4.0
    elseif ESP_Config.Thickness == 4.0 then
        ESP_Config.Thickness = 1.0
    else
        ESP_Config.Thickness = 1.5
    end
    ThickLabel.Text = "ESPESSURA: " .. tostring(ESP_Config.Thickness)
end)

-- Origem da linha (Top / Bottom)
local OriginLabel = Instance.new("TextLabel")
OriginLabel.Size = UDim2.new(1, 0, 0, 20)
OriginLabel.Position = UDim2.new(0, 10, 0, 85)
OriginLabel.BackgroundTransparency = 1
OriginLabel.Text = "ORIGEM DA LINHA"
OriginLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
OriginLabel.Font = Enum.Font.GothamBold
OriginLabel.TextSize = 9
OriginLabel.TextXAlignment = Enum.TextXAlignment.Left
OriginLabel.Parent = SubPanel

local BtnTop = Instance.new("TextButton")
BtnTop.Size = UDim2.new(0.42, 0, 0, 20)
BtnTop.Position = UDim2.new(0.05, 0, 0, 105)
BtnTop.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BtnTop.BorderSizePixel = 0
BtnTop.Text = "TOPO"
BtnTop.TextColor3 = Color3.fromRGB(150, 150, 150)
BtnTop.Font = Enum.Font.GothamBold
BtnTop.TextSize = 9
BtnTop.Parent = SubPanel

local BtnTopCorner = Instance.new("UICorner")
BtnTopCorner.CornerRadius = UDim.new(0, 4)
BtnTopCorner.Parent = BtnTop

local BtnBottom = Instance.new("TextButton")
BtnBottom.Size = UDim2.new(0.42, 0, 0, 20)
BtnBottom.Position = UDim2.new(0.53, 0, 0, 105)
BtnBottom.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Ativado por padrão
BtnBottom.BorderSizePixel = 0
BtnBottom.Text = "BAIXO"
BtnBottom.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnBottom.Font = Enum.Font.GothamBold
BtnBottom.TextSize = 9
BtnBottom.Parent = SubPanel

local BtnBottomCorner = Instance.new("UICorner")
BtnBottomCorner.CornerRadius = UDim.new(0, 4)
BtnBottomCorner.Parent = BtnBottom

BtnTop.MouseButton1Click:Connect(function()
    ESP_Config.Origin = "Top"
    BtnTop.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnTop.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnBottom.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnBottom.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

BtnBottom.MouseButton1Click:Connect(function()
    ESP_Config.Origin = "Bottom"
    BtnBottom.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnBottom.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnTop.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnTop.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- Cores Rápidas
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(1, 0, 0, 20)
ColorLabel.Position = UDim2.new(0, 10, 0, 130)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "COR DA LINHA"
ColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
ColorLabel.Font = Enum.Font.GothamBold
ColorLabel.TextSize = 9
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
ColorLabel.Parent = SubPanel

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(0.9, 0, 0, 20)
ColorContainer.Position = UDim2.new(0.05, 0, 0, 150)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = SubPanel

local ColorLayout = Instance.new("UIListLayout")
ColorLayout.FillDirection = Enum.FillDirection.Horizontal
ColorLayout.Padding = UDim.new(0, 6)
ColorLayout.Parent = ColorContainer

local function CreateColorSelector(color, name)
    local colBtn = Instance.new("TextButton")
    colBtn.Size = UDim2.new(0, 20, 0, 20)
    colBtn.BackgroundColor3 = color
    colBtn.Text = ""
    colBtn.BorderSizePixel = 0
    colBtn.Parent = ColorContainer

    local colCorner = Instance.new("UICorner")
    colCorner.CornerRadius = UDim.new(1, 0)
    colCorner.Parent = colBtn

    colBtn.MouseButton1Click:Connect(function()
        ESP_Config.Color = color
    end)
end

CreateColorSelector(Color3.fromRGB(255, 0, 0))   -- Vermelho
CreateColorSelector(Color3.fromRGB(0, 255, 0))   -- Verde
CreateColorSelector(Color3.fromRGB(0, 0, 255))   -- Azul
CreateColorSelector(Color3.fromRGB(255, 255, 255)) -- Branco
CreateColorSelector(Color3.fromRGB(255, 255, 0)) -- Amare

-- Botão Salvar (Salva as configurações e fecha o painel menor)
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.9, 0, 0, 25)
SaveBtn.Position = UDim2.new(0.05, 0, 0, 185)
SaveBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SaveBtn.BorderSizePixel = 0
SaveBtn.Text = "SALVAR CONFIGURAÇÃO"
SaveBtn.TextColor3 = Color3.fromRGB(0, 255, 0) -- Verde confirmador
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 9
SaveBtn.Parent = SubPanel

local SaveCorner = Instance.new("UICorner")
SaveCorner.CornerRadius = UDim.new(0, 6)
SaveCorner.Parent = SaveBtn

SaveBtn.MouseButton1Click:Connect(function()
    SubPanel.Visible = false -- Fecha o Sub-Painel simulando salvar e carregar
end)


-- ==========================================
-- 6. INTEGRAÇÃO DO SWITCH COM SUB-PAINEL NA ABA VISUAL
-- ==========================================

local function CreateToggleWithSettings(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    -- Botão Liga/Desliga
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.2, 0, 0.7, 0)
    Button.Position = UDim2.new(0.55, -5, 0.15, 0)
    Button.BackgroundColor3 = default and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(22, 22, 22)
    Button.Text = default and "ON" or "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 9
    Button.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button

    -- Botão de Engrenagem (= ou ⚙️) para abrir sub-painel
    local SettingsBtn = Instance.new("TextButton")
    SettingsBtn.Size = UDim2.new(0.18, 0, 0.7, 0)
    SettingsBtn.Position = UDim2.new(0.78, 0, 0.15, 0)
    SettingsBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    SettingsBtn.Text = "⚙️"
    SettingsBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    SettingsBtn.Font = Enum.Font.GothamBold
    SettingsBtn.TextSize = 10
    SettingsBtn.Parent = Frame

    local SetCorner = Instance.new("UICorner")
    SetCorner.CornerRadius = UDim.new(0, 6)
    SetCorner.Parent = SettingsBtn

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        local targetColor = state and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(22, 22, 22)
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
        Button.Text = state and "ON" or "OFF"
        callback(state)
    end)

    -- Mostra o painel pequeno ao clicar na engrenagem
    SettingsBtn.MouseButton1Click:Connect(function()
        SubPanel.Visible = not SubPanel.Visible
    end)
end

-- Adiciona a função com o botão e a engrenagem dentro da aba VISUAL
CreateToggleWithSettings(PageVisual, "ESP LINE", false, function(v)
    ESP_Config.Active = v
end)

-- ==========================================
-- 7. RENDERIZADOR ESP LINE DE ALTA COMPATIBILIDADE E RESPONSIVO
-- ==========================================

local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "BK_ESP_v15"
ESPContainer.Parent = ScreenGui

local function ApplyESP(player)
    if player == LocalPlayer then return end

    local PlayerFolder = Instance.new("Folder")
    PlayerFolder.Name = "ESP_" .. player.Name
    PlayerFolder.Parent = ESPContainer

    local FrameLine = Instance.new("Frame")
    FrameLine.BorderSizePixel = 0
    FrameLine.Visible = false
    FrameLine.Parent = PlayerFolder

    local function Clear()
        FrameLine.Visible = false
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

        if OnScreen and ESP_Config.Active then
            -- Determina a origem baseado na configuração (Topo ou Baixo)
            local StartX = Camera.ViewportSize.X / 2
            local StartY = (ESP_Config.Origin == "Top") and 0 or Camera.ViewportSize.Y
            
            local TargetX = ScreenPos.X
            local TargetY = ScreenPos.Y

            local Dist = math.sqrt((TargetX - StartX)^2 + (TargetY - StartY)^2)
            local Angle = math.atan2(TargetY - StartY, TargetX - StartX)

            -- Aplica as configurações personalizadas dinâmicas (Espessura e Cor)
            FrameLine.Size = UDim2.new(0, Dist, 0, ESP_Config.Thickness)
            FrameLine.BackgroundColor3 = ESP_Config.Color
            FrameLine.Position = UDim2.new(0, (StartX + TargetX) / 2 - Dist / 2, 0, (StartY + TargetY) / 2)
            FrameLine.Rotation = math.deg(Angle)
            FrameLine.Visible = true
        else
            Clear()
        end
    end)
end

-- Rodar o ESP para o Servidor
for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(function() ApplyESP(p) end)
end
Players.PlayerAdded:Connect(function(p)
    task.spawn(function() ApplyESP(p) end)
end)
