-- =================================================================
-- BK CLIENT v1.8 [Beta] - PC STYLE INJECTOR LAYOUT (SIDEBAR LEFT)
-- NO EFFECTS - GREY THEME - MINIMAL COLOR
-- Abas: Perfil (Inicial), Status, Opções, Mira, Visual, Extras, Gráficos
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
local GuiService = game:GetService("GuiService")

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
-- CONFIGURAÇÕES SALVÁVEIS DAS FUNÇÕES VISUAIS
-- ==========================================
local ESP_Config = {
    -- ESP LINE
    Active = false,
    Thickness = 1.5,
    Color = Color3.fromRGB(255, 0, 0),
    Origin = "Bottom",
    
    -- ESP BOX
    BoxActive = false,
    BoxSize = 1.0, -- Multiplicador (0.7 = P, 1.0 = M, 1.4 = G)
    BoxThickness = 1.5,
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxRound = false,
    
    -- ESP NOME
    NameActive = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    NameRGB = false,
    NameSize = 11,

    -- ESP DISTÂNCIA
    DistActive = false,
    DistColor = Color3.fromRGB(0, 255, 255),
    DistRGB = false,
    DistSize = 10,

    -- ESP ESQUELETO
    SkelActive = false,
    SkelColor = Color3.fromRGB(255, 0, 255),
    SkelThickness = 1.5
}

-- Variável auxiliar para efeito RGB global
local GlobalRGB = Color3.fromRGB(255, 0, 0)
task.spawn(function()
    while task.wait() do
        for i = 0, 1, 0.01 do
            GlobalRGB = Color3.fromHSV(i, 1, 1)
            task.wait(0.03)
        end
    end
end)

-- ==========================================
-- 1. SISTEMA DA BOLHA FLUTUANTE (PRETA, TEXTO BRANCO)
-- ==========================================

local Bubble = Instance.new("TextButton")
Bubble.Name = "BKBubble_v15"
Bubble.Size = UDim2.new(0, 150, 0, 48)
Bubble.Position = UDim2.new(0.05, 0, 0.15, 0)
Bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Bubble.BorderSizePixel = 0
Bubble.Text = "BK CLIENT v1.8 †"
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
-- 2. PAINEL PRINCIPAL PREMIUM (CINZA COM SIDEBAR ESQUERDA)
-- ==========================================

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 520, 0, 320)
MainPanel.Position = UDim2.new(0.5, -260, 0.5, -160)
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

-- ==========================================
-- SUB-PAINEIS DE CONFIGURAÇÃO DAS FUNÇÕES
-- ==========================================

local function CreateSubPanel(name)
    local SP = Instance.new("Frame")
    SP.Name = name
    SP.Size = UDim2.new(0, 200, 0, 220)
    SP.Position = UDim2.new(0.5, 270, 0.5, -110)
    SP.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    SP.BorderSizePixel = 0
    SP.Visible = false
    SP.Parent = ScreenGui

    local SC = Instance.new("UICorner")
    SC.CornerRadius = UDim.new(0, 12)
    SC.Parent = SP

    local SS = Instance.new("UIStroke")
    SS.Color = Color3.fromRGB(40, 40, 40)
    SS.Thickness = 1.5
    SS.Parent = SP

    return SP
end

local SubPanel = CreateSubPanel("SubPanel")
local SubPanelBox = CreateSubPanel("SubPanelBox")
local SubPanelName = CreateSubPanel("SubPanelName")
local SubPanelDist = CreateSubPanel("SubPanelDist")
local SubPanelSkel = CreateSubPanel("SubPanelSkel")

local function CloseAllSubPanels()
    SubPanel.Visible = false
    SubPanelBox.Visible = false
    SubPanelName.Visible = false
    SubPanelDist.Visible = false
    SubPanelSkel.Visible = false
end

local isMenuOpen = false
Bubble.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    
    if isMenuOpen then
        MainPanel.Size = UDim2.new(0, 0, 0, 0)
        MainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainPanel.Visible = true
        
        local openTween = TweenService:Create(MainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 320),
            Position = UDim2.new(0.5, -260, 0.5, -160)
        })
        openTween:Play()
    else
        CloseAllSubPanels()
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
-- 3. HEADER SUPERIOR
-- ==========================================

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "BK CLIENT v1.8 [Beta]"
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
-- 4. CONTAINER DE ABAS (SIDEBAR ESQUERDA)
-- ==========================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 110, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainPanel

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SidebarLine.BorderSizePixel = 0
SidebarLine.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.FillDirection = Enum.FillDirection.Vertical
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 0)
SidebarLayout.Parent = Sidebar

local ContainerPages = Instance.new("Frame")
ContainerPages.Size = UDim2.new(1, -130, 1, -50)
ContainerPages.Position = UDim2.new(0, 120, 0, 40)
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
    Page.CanvasSize = UDim2.new(0, 0, 0, 320)
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
        local VisualLayout = Instance.new("UIListLayout")
        VisualLayout.Padding = UDim.new(0, 6)
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

-- Criando as abas
local PagePerfil = CreatePage("Perfil", true, false)
local PageStatus = CreatePage("Status", false, false)
local PageOpcoes = CreatePage("Opcoes", false, false)
local PageMira = CreatePage("Mira", false, false)
local PageVisual = CreatePage("Visual", false, true)
local PageExtras = CreatePage("Extras", false, false)
local PageGraficos = CreatePage("Graficos", false, false)

-- Perfil inicial ativo
PagePerfil.Visible = true

local function AddTabBtn(name, displayName, layoutOrder, isDefault)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 41)
    Btn.BackgroundColor3 = isDefault and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(15, 15, 15)
    Btn.BorderSizePixel = 0
    Btn.Text = displayName:upper()
    Btn.TextColor3 = isDefault and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 9
    Btn.LayoutOrder = layoutOrder
    Btn.Parent = Sidebar

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

-- Botões alinhados na esquerda (Perfil inicial)
AddTabBtn("Perfil", "Perfil", 1, true)
AddTabBtn("Status", "Status", 2, false)
AddTabBtn("Opcoes", "Opções", 3, false)
AddTabBtn("Mira", "Mira", 4, false)
AddTabBtn("Visual", "Visual", 5, false)
AddTabBtn("Extras", "Extras", 6, false)
AddTabBtn("Graficos", "Gráficos", 7, false)

-- ==========================================
-- 5. CONSTRUÇÃO DO SUB-PAINEL (ESP LINE)
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
BtnBottom.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

local function CreateColorSelector(color, parent)
    local colBtn = Instance.new("TextButton")
    colBtn.Size = UDim2.new(0, 20, 0, 20)
    colBtn.BackgroundColor3 = color
    colBtn.Text = ""
    colBtn.BorderSizePixel = 0
    colBtn.Parent = parent

    local colCorner = Instance.new("UICorner")
    colCorner.CornerRadius = UDim.new(1, 0)
    colCorner.Parent = colBtn
    return colBtn
end

local c1 = CreateColorSelector(Color3.fromRGB(255, 0, 0), ColorContainer)
c1.MouseButton1Click:Connect(function() ESP_Config.Color = Color3.fromRGB(255, 0, 0) end)
local c2 = CreateColorSelector(Color3.fromRGB(0, 255, 0), ColorContainer)
c2.MouseButton1Click:Connect(function() ESP_Config.Color = Color3.fromRGB(0, 255, 0) end)
local c3 = CreateColorSelector(Color3.fromRGB(0, 0, 255), ColorContainer)
c3.MouseButton1Click:Connect(function() ESP_Config.Color = Color3.fromRGB(0, 0, 255) end)
local c4 = CreateColorSelector(Color3.fromRGB(255, 255, 255), ColorContainer)
c4.MouseButton1Click:Connect(function() ESP_Config.Color = Color3.fromRGB(255, 255, 255) end)
local c5 = CreateColorSelector(Color3.fromRGB(255, 255, 0), ColorContainer)
c5.MouseButton1Click:Connect(function() ESP_Config.Color = Color3.fromRGB(255, 255, 0) end)

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.9, 0, 0, 25)
SaveBtn.Position = UDim2.new(0.05, 0, 0, 185)
SaveBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SaveBtn.BorderSizePixel = 0
SaveBtn.Text = "SALVAR CONFIGURAÇÃO"
SaveBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 9
SaveBtn.Parent = SubPanel

SaveBtn.MouseButton1Click:Connect(function() SubPanel.Visible = false end)

-- ==========================================
-- 6. CONSTRUÇÃO DO SUB-PAINEL (ESP BOX)
-- ==========================================

local SubTitleBox = Instance.new("TextLabel")
SubTitleBox.Size = UDim2.new(1, 0, 0, 30)
SubTitleBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
SubTitleBox.BorderSizePixel = 0
SubTitleBox.Text = "BOX CONFIGS ⚙️"
SubTitleBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTitleBox.Font = Enum.Font.GothamBold
SubTitleBox.TextSize = 10
SubTitleBox.Parent = SubPanelBox

local SubTitleBoxCorner = Instance.new("UICorner")
SubTitleBoxCorner.CornerRadius = UDim.new(0, 12)
SubTitleBoxCorner.Parent = SubTitleBox

local BoxSizeLabel = Instance.new("TextLabel")
BoxSizeLabel.Size = UDim2.new(1, 0, 0, 20)
BoxSizeLabel.Position = UDim2.new(0, 10, 0, 40)
BoxSizeLabel.BackgroundTransparency = 1
BoxSizeLabel.Text = "TAMANHO: MÉDIO"
BoxSizeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BoxSizeLabel.Font = Enum.Font.GothamBold
BoxSizeLabel.TextSize = 9
BoxSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxSizeLabel.Parent = SubPanelBox

local BoxSizeSlider = Instance.new("TextButton")
BoxSizeSlider.Size = UDim2.new(0.9, 0, 0, 18)
BoxSizeSlider.Position = UDim2.new(0.05, 0, 0, 60)
BoxSizeSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BoxSizeSlider.BorderSizePixel = 0
BoxSizeSlider.Text = "MUDAR TAMANHO"
BoxSizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
BoxSizeSlider.Font = Enum.Font.GothamBold
BoxSizeSlider.TextSize = 8
BoxSizeSlider.Parent = SubPanelBox

local BoxSizeCorner = Instance.new("UICorner")
BoxSizeCorner.CornerRadius = UDim.new(0, 4)
BoxSizeCorner.Parent = BoxSizeSlider

BoxSizeSlider.MouseButton1Click:Connect(function()
    if ESP_Config.BoxSize == 1.0 then
        ESP_Config.BoxSize = 1.4
        BoxSizeLabel.Text = "TAMANHO: GRANDE"
    elseif ESP_Config.BoxSize == 1.4 then
        ESP_Config.BoxSize = 0.7
        BoxSizeLabel.Text = "TAMANHO: PEQUENO"
    else
        ESP_Config.BoxSize = 1.0
        BoxSizeLabel.Text = "TAMANHO: MÉDIO"
    end
end)

local BoxStyleLabel = Instance.new("TextLabel")
BoxStyleLabel.Size = UDim2.new(1, 0, 0, 20)
BoxStyleLabel.Position = UDim2.new(0, 10, 0, 85)
BoxStyleLabel.BackgroundTransparency = 1
BoxStyleLabel.Text = "ESTILO DA BOX"
BoxStyleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BoxStyleLabel.Font = Enum.Font.GothamBold
BoxStyleLabel.TextSize = 9
BoxStyleLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxStyleLabel.Parent = SubPanelBox

local BtnSquare = Instance.new("TextButton")
BtnSquare.Size = UDim2.new(0.42, 0, 0, 20)
BtnSquare.Position = UDim2.new(0.05, 0, 0, 105)
BtnSquare.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnSquare.BorderSizePixel = 0
BtnSquare.Text = "QUADRADA"
BtnSquare.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnSquare.Font = Enum.Font.GothamBold
BtnSquare.TextSize = 8
BtnSquare.Parent = SubPanelBox

local BtnSquareCorner = Instance.new("UICorner")
BtnSquareCorner.CornerRadius = UDim.new(0, 4)
BtnSquareCorner.Parent = BtnSquare

local BtnRound = Instance.new("TextButton")
BtnRound.Size = UDim2.new(0.42, 0, 0, 20)
BtnRound.Position = UDim2.new(0.53, 0, 0, 105)
BtnRound.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BtnRound.BorderSizePixel = 0
BtnRound.Text = "REDONDA"
BtnRound.TextColor3 = Color3.fromRGB(150, 150, 150)
BtnRound.Font = Enum.Font.GothamBold
BtnRound.TextSize = 8
BtnRound.Parent = SubPanelBox

local BtnRoundCorner = Instance.new("UICorner")
BtnRoundCorner.CornerRadius = UDim.new(0, 4)
BtnRoundCorner.Parent = BtnRound

BtnSquare.MouseButton1Click:Connect(function()
    ESP_Config.BoxRound = false
    BtnSquare.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnSquare.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnRound.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnRound.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

BtnRound.MouseButton1Click:Connect(function()
    ESP_Config.BoxRound = true
    BtnRound.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnRound.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnSquare.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnSquare.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

local BoxColorLabel = Instance.new("TextLabel")
BoxColorLabel.Size = UDim2.new(1, 0, 0, 20)
BoxColorLabel.Position = UDim2.new(0, 10, 0, 130)
BoxColorLabel.BackgroundTransparency = 1
BoxColorLabel.Text = "COR DA BOX"
BoxColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
BoxColorLabel.Font = Enum.Font.GothamBold
BoxColorLabel.TextSize = 9
BoxColorLabel.TextXAlignment = Enum.TextXAlignment.Left
BoxColorLabel.Parent = SubPanelBox

local BoxColorContainer = Instance.new("Frame")
BoxColorContainer.Size = UDim2.new(0.9, 0, 0, 20)
BoxColorContainer.Position = UDim2.new(0.05, 0, 0, 150)
BoxColorContainer.BackgroundTransparency = 1
BoxColorContainer.Parent = SubPanelBox

local BoxColorLayout = Instance.new("UIListLayout")
BoxColorLayout.FillDirection = Enum.FillDirection.Horizontal
BoxColorLayout.Padding = UDim.new(0, 6)
BoxColorLayout.Parent = BoxColorContainer

local bc1 = CreateColorSelector(Color3.fromRGB(255, 0, 0), BoxColorContainer)
bc1.MouseButton1Click:Connect(function() ESP_Config.BoxColor = Color3.fromRGB(255, 0, 0) end)
local bc2 = CreateColorSelector(Color3.fromRGB(0, 255, 0), BoxColorContainer)
bc2.MouseButton1Click:Connect(function() ESP_Config.BoxColor = Color3.fromRGB(0, 255, 0) end)
local bc3 = CreateColorSelector(Color3.fromRGB(0, 0, 255), BoxColorContainer)
bc3.MouseButton1Click:Connect(function() ESP_Config.BoxColor = Color3.fromRGB(0, 0, 255) end)
local bc4 = CreateColorSelector(Color3.fromRGB(255, 255, 255), BoxColorContainer)
bc4.MouseButton1Click:Connect(function() ESP_Config.BoxColor = Color3.fromRGB(255, 255, 255) end)
local bc5 = CreateColorSelector(Color3.fromRGB(255, 255, 0), BoxColorContainer)
bc5.MouseButton1Click:Connect(function() ESP_Config.BoxColor = Color3.fromRGB(255, 255, 0) end)

local SaveBtnBox = Instance.new("TextButton")
SaveBtnBox.Size = UDim2.new(0.9, 0, 0, 25)
SaveBtnBox.Position = UDim2.new(0.05, 0, 0, 185)
SaveBtnBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SaveBtnBox.BorderSizePixel = 0
SaveBtnBox.Text = "SALVAR CONFIGURAÇÃO"
SaveBtnBox.TextColor3 = Color3.fromRGB(0, 255, 0)
SaveBtnBox.Font = Enum.Font.GothamBold
SaveBtnBox.TextSize = 9
SaveBtnBox.Parent = SubPanelBox

SaveBtnBox.MouseButton1Click:Connect(function() SubPanelBox.Visible = false end)

-- ==========================================
-- 7. CONSTRUÇÃO DO SUB-PAINEL (ESP NOME)
-- ==========================================

local SubTitleName = Instance.new("TextLabel")
SubTitleName.Size = UDim2.new(1, 0, 0, 30)
SubTitleName.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
SubTitleName.BorderSizePixel = 0
SubTitleName.Text = "NAME CONFIGS ⚙️"
SubTitleName.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTitleName.Font = Enum.Font.GothamBold
SubTitleName.TextSize = 10
SubTitleName.Parent = SubPanelName

local SubTitleNameCorner = Instance.new("UICorner")
SubTitleNameCorner.CornerRadius = UDim.new(0, 12)
SubTitleNameCorner.Parent = SubTitleName

local RGBLabel = Instance.new("TextLabel")
RGBLabel.Size = UDim2.new(1, 0, 0, 20)
RGBLabel.Position = UDim2.new(0, 10, 0, 40)
RGBLabel.BackgroundTransparency = 1
RGBLabel.Text = "EFEITO COLORIDO RGB"
RGBLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
RGBLabel.Font = Enum.Font.GothamBold
RGBLabel.TextSize = 9
RGBLabel.TextXAlignment = Enum.TextXAlignment.Left
RGBLabel.Parent = SubPanelName

local BtnRGBOn = Instance.new("TextButton")
BtnRGBOn.Size = UDim2.new(0.42, 0, 0, 20)
BtnRGBOn.Position = UDim2.new(0.05, 0, 0, 60)
BtnRGBOn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BtnRGBOn.BorderSizePixel = 0
BtnRGBOn.Text = "ATIVAR RGB"
BtnRGBOn.TextColor3 = Color3.fromRGB(150, 150, 150)
BtnRGBOn.Font = Enum.Font.GothamBold
BtnRGBOn.TextSize = 8
BtnRGBOn.Parent = SubPanelName

local BtnRGBOnCorner = Instance.new("UICorner")
BtnRGBOnCorner.CornerRadius = UDim.new(0, 4)
BtnRGBOnCorner.Parent = BtnRGBOn

local BtnRGBOff = Instance.new("TextButton")
BtnRGBOff.Size = UDim2.new(0.42, 0, 0, 20)
BtnRGBOff.Position = UDim2.new(0.53, 0, 0, 60)
BtnRGBOff.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnRGBOff.BorderSizePixel = 0
BtnRGBOff.Text = "ESTÁTICO"
BtnRGBOff.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnRGBOff.Font = Enum.Font.GothamBold
BtnRGBOff.TextSize = 8
BtnRGBOff.Parent = SubPanelName

local BtnRGBOffCorner = Instance.new("UICorner")
BtnRGBOffCorner.CornerRadius = UDim.new(0, 4)
BtnRGBOffCorner.Parent = BtnRGBOff

BtnRGBOn.MouseButton1Click:Connect(function()
    ESP_Config.NameRGB = true
    BtnRGBOn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnRGBOn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnRGBOff.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnRGBOff.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

BtnRGBOff.MouseButton1Click:Connect(function()
    ESP_Config.NameRGB = false
    BtnRGBOff.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnRGBOff.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnRGBOn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnRGBOn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

local NameSizeLabel = Instance.new("TextLabel")
NameSizeLabel.Size = UDim2.new(1, 0, 0, 20)
NameSizeLabel.Position = UDim2.new(0, 10, 0, 85)
NameSizeLabel.BackgroundTransparency = 1
NameSizeLabel.Text = "TAMANHO DO TEXTO: 11"
NameSizeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
NameSizeLabel.Font = Enum.Font.GothamBold
NameSizeLabel.TextSize = 9
NameSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
NameSizeLabel.Parent = SubPanelName

local NameSizeSlider = Instance.new("TextButton")
NameSizeSlider.Size = UDim2.new(0.9, 0, 0, 18)
NameSizeSlider.Position = UDim2.new(0.05, 0, 0, 105)
NameSizeSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NameSizeSlider.BorderSizePixel = 0
NameSizeSlider.Text = "MUDAR TAMANHO"
NameSizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
NameSizeSlider.Font = Enum.Font.GothamBold
NameSizeSlider.TextSize = 8
NameSizeSlider.Parent = SubPanelName

local NameSizeCorner = Instance.new("UICorner")
NameSizeCorner.CornerRadius = UDim.new(0, 4)
NameSizeCorner.Parent = NameSizeSlider

NameSizeSlider.MouseButton1Click:Connect(function()
    if ESP_Config.NameSize == 11 then
        ESP_Config.NameSize = 14
    elseif ESP_Config.NameSize == 14 then
        ESP_Config.NameSize = 8
    else
        ESP_Config.NameSize = 11
    end
    NameSizeLabel.Text = "TAMANHO DO TEXTO: " .. tostring(ESP_Config.NameSize)
end)

local NameColorLabel = Instance.new("TextLabel")
NameColorLabel.Size = UDim2.new(1, 0, 0, 20)
NameColorLabel.Position = UDim2.new(0, 10, 0, 130)
NameColorLabel.BackgroundTransparency = 1
NameColorLabel.Text = "COR DO NOME"
NameColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
NameColorLabel.Font = Enum.Font.GothamBold
NameColorLabel.TextSize = 9
NameColorLabel.TextXAlignment = Enum.TextXAlignment.Left
NameColorLabel.Parent = SubPanelName

local NameColorContainer = Instance.new("Frame")
NameColorContainer.Size = UDim2.new(0.9, 0, 0, 20)
NameColorContainer.Position = UDim2.new(0.05, 0, 0, 150)
NameColorContainer.BackgroundTransparency = 1
NameColorContainer.Parent = SubPanelName

local NameColorLayout = Instance.new("UIListLayout")
NameColorLayout.FillDirection = Enum.FillDirection.Horizontal
NameColorLayout.Padding = UDim.new(0, 6)
NameColorLayout.Parent = NameColorContainer

local nc1 = CreateColorSelector(Color3.fromRGB(255, 0, 0), NameColorContainer)
nc1.MouseButton1Click:Connect(function() ESP_Config.NameColor = Color3.fromRGB(255, 0, 0) end)
local nc2 = CreateColorSelector(Color3.fromRGB(0, 255, 0), NameColorContainer)
nc2.MouseButton1Click:Connect(function() ESP_Config.NameColor = Color3.fromRGB(0, 255, 0) end)
local nc3 = CreateColorSelector(Color3.fromRGB(0, 0, 255), NameColorContainer)
nc3.MouseButton1Click:Connect(function() ESP_Config.NameColor = Color3.fromRGB(0, 0, 255) end)
local nc4 = CreateColorSelector(Color3.fromRGB(255, 255, 255), NameColorContainer)
nc4.MouseButton1Click:Connect(function() ESP_Config.NameColor = Color3.fromRGB(255, 255, 255) end)
local nc5 = CreateColorSelector(Color3.fromRGB(255, 255, 0), NameColorContainer)
nc5.MouseButton1Click:Connect(function() ESP_Config.NameColor = Color3.fromRGB(255, 255, 0) end)

local SaveBtnName = Instance.new("TextButton")
SaveBtnName.Size = UDim2.new(0.9, 0, 0, 25)
SaveBtnName.Position = UDim2.new(0.05, 0, 0, 185)
SaveBtnName.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SaveBtnName.BorderSizePixel = 0
SaveBtnName.Text = "SALVAR CONFIGURAÇÃO"
SaveBtnName.TextColor3 = Color3.fromRGB(0, 255, 0)
SaveBtnName.Font = Enum.Font.GothamBold
SaveBtnName.TextSize = 9
SaveBtnName.Parent = SubPanelName

SaveBtnName.MouseButton1Click:Connect(function() SubPanelName.Visible = false end)

-- ==========================================
-- 8. CONSTRUÇÃO DO SUB-PAINEL (ESP DISTÂNCIA)
-- ==========================================

local SubTitleDist = Instance.new("TextLabel")
SubTitleDist.Size = UDim2.new(1, 0, 0, 30)
SubTitleDist.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
SubTitleDist.BorderSizePixel = 0
SubTitleDist.Text = "DISTANCE CONFIGS ⚙️"
SubTitleDist.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTitleDist.Font = Enum.Font.GothamBold
SubTitleDist.TextSize = 10
SubTitleDist.Parent = SubPanelDist

local SubTitleDistCorner = Instance.new("UICorner")
SubTitleDistCorner.CornerRadius = UDim.new(0, 12)
SubTitleDistCorner.Parent = SubTitleDist

local DistRGBLabel = Instance.new("TextLabel")
DistRGBLabel.Size = UDim2.new(1, 0, 0, 20)
DistRGBLabel.Position = UDim2.new(0, 10, 0, 40)
DistRGBLabel.BackgroundTransparency = 1
DistRGBLabel.Text = "RGB NA DISTÂNCIA"
DistRGBLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
DistRGBLabel.Font = Enum.Font.GothamBold
DistRGBLabel.TextSize = 9
DistRGBLabel.TextXAlignment = Enum.TextXAlignment.Left
DistRGBLabel.Parent = SubPanelDist

local BtnDistRGBOn = Instance.new("TextButton")
BtnDistRGBOn.Size = UDim2.new(0.42, 0, 0, 20)
BtnDistRGBOn.Position = UDim2.new(0.05, 0, 0, 60)
BtnDistRGBOn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BtnDistRGBOn.BorderSizePixel = 0
BtnDistRGBOn.Text = "ATIVAR"
BtnDistRGBOn.TextColor3 = Color3.fromRGB(150, 150, 150)
BtnDistRGBOn.Font = Enum.Font.GothamBold
BtnDistRGBOn.TextSize = 8
BtnDistRGBOn.Parent = SubPanelDist

local BtnDistRGBOnCorner = Instance.new("UICorner")
BtnDistRGBOnCorner.CornerRadius = UDim.new(0, 4)
BtnDistRGBOnCorner.Parent = BtnDistRGBOn

local BtnDistRGBOff = Instance.new("TextButton")
BtnDistRGBOff.Size = UDim2.new(0.42, 0, 0, 20)
BtnDistRGBOff.Position = UDim2.new(0.53, 0, 0, 60)
BtnDistRGBOff.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnDistRGBOff.BorderSizePixel = 0
BtnDistRGBOff.Text = "ESTÁTICO"
BtnDistRGBOff.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnDistRGBOff.Font = Enum.Font.GothamBold
BtnDistRGBOff.TextSize = 8
BtnDistRGBOff.Parent = SubPanelDist

local BtnDistRGBOffCorner = Instance.new("UICorner")
BtnDistRGBOffCorner.CornerRadius = UDim.new(0, 4)
BtnDistRGBOffCorner.Parent = BtnDistRGBOff

BtnDistRGBOn.MouseButton1Click:Connect(function()
    ESP_Config.DistRGB = true
    BtnDistRGBOn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnDistRGBOn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnDistRGBOff.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnDistRGBOff.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

BtnDistRGBOff.MouseButton1Click:Connect(function()
    ESP_Config.DistRGB = false
    BtnDistRGBOff.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BtnDistRGBOff.TextColor3 = Color3.fromRGB(255, 255, 255)
    BtnDistRGBOn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BtnDistRGBOn.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

local DistSizeLabel = Instance.new("TextLabel")
DistSizeLabel.Size = UDim2.new(1, 0, 0, 20)
DistSizeLabel.Position = UDim2.new(0, 10, 0, 85)
DistSizeLabel.BackgroundTransparency = 1
DistSizeLabel.Text = "TAMANHO DO TEXTO: 10"
DistSizeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
DistSizeLabel.Font = Enum.Font.GothamBold
DistSizeLabel.TextSize = 9
DistSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
DistSizeLabel.Parent = SubPanelDist

local DistSizeSlider = Instance.new("TextButton")
DistSizeSlider.Size = UDim2.new(0.9, 0, 0, 18)
DistSizeSlider.Position = UDim2.new(0.05, 0, 0, 105)
DistSizeSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DistSizeSlider.BorderSizePixel = 0
DistSizeSlider.Text = "MUDAR TAMANHO"
DistSizeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
DistSizeSlider.Font = Enum.Font.GothamBold
DistSizeSlider.TextSize = 8
DistSizeSlider.Parent = SubPanelDist

local DistSizeCorner = Instance.new("UICorner")
DistSizeCorner.CornerRadius = UDim.new(0, 4)
DistSizeCorner.Parent = DistSizeSlider

DistSizeSlider.MouseButton1Click:Connect(function()
    if ESP_Config.DistSize == 10 then
        ESP_Config.DistSize = 13
    elseif ESP_Config.DistSize == 13 then
        ESP_Config.DistSize = 8
    else
        ESP_Config.DistSize = 10
    end
    DistSizeLabel.Text = "TAMANHO DO TEXTO: " .. tostring(ESP_Config.DistSize)
end)

local DistColorLabel = Instance.new("TextLabel")
DistColorLabel.Size = UDim2.new(1, 0, 0, 20)
DistColorLabel.Position = UDim2.new(0, 10, 0, 130)
DistColorLabel.BackgroundTransparency = 1
DistColorLabel.Text = "COR DA DISTÂNCIA"
DistColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
DistColorLabel.Font = Enum.Font.GothamBold
DistColorLabel.TextSize = 9
DistColorLabel.TextXAlignment = Enum.TextXAlignment.Left
DistColorLabel.Parent = SubPanelDist

local DistColorContainer = Instance.new("Frame")
DistColorContainer.Size = UDim2.new(0.9, 0, 0, 20)
DistColorContainer.Position = UDim2.new(0.05, 0, 0, 150)
DistColorContainer.BackgroundTransparency = 1
DistColorContainer.Parent = SubPanelDist

local DistColorLayout = Instance.new("UIListLayout")
DistColorLayout.FillDirection = Enum.FillDirection.Horizontal
DistColorLayout.Padding = UDim.new(0, 6)
DistColorLayout.Parent = DistColorContainer

local dc1 = CreateColorSelector(Color3.fromRGB(255, 0, 0), DistColorContainer)
dc1.MouseButton1Click:Connect(function() ESP_Config.DistColor = Color3.fromRGB(255, 0, 0) end)
local dc2 = CreateColorSelector(Color3.fromRGB(0, 255, 0), DistColorContainer)
dc2.MouseButton1Click:Connect(function() ESP_Config.DistColor = Color3.fromRGB(0, 255, 0) end)
local dc3 = CreateColorSelector(Color3.fromRGB(0, 255, 255), DistColorContainer)
dc3.MouseButton1Click:Connect(function() ESP_Config.DistColor = Color3.fromRGB(0, 255, 255) end)
local dc4 = CreateColorSelector(Color3.fromRGB(255, 255, 255), DistColorContainer)
dc4.MouseButton1Click:Connect(function() ESP_Config.DistColor = Color3.fromRGB(255, 255, 255) end)
local dc5 = CreateColorSelector(Color3.fromRGB(255, 255, 0), DistColorContainer)
dc5.MouseButton1Click:Connect(function() ESP_Config.DistColor = Color3.fromRGB(255, 255, 0) end)

local SaveBtnDist = Instance.new("TextButton")
SaveBtnDist.Size = UDim2.new(0.9, 0, 0, 25)
SaveBtnDist.Position = UDim2.new(0.05, 0, 0, 185)
SaveBtnDist.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SaveBtnDist.BorderSizePixel = 0
SaveBtnDist.Text = "SALVAR CONFIGURAÇÃO"
SaveBtnDist.TextColor3 = Color3.fromRGB(0, 255, 0)
SaveBtnDist.Font = Enum.Font.GothamBold
SaveBtnDist.TextSize = 9
SaveBtnDist.Parent = SubPanelDist

SaveBtnDist.MouseButton1Click:Connect(function() SubPanelDist.Visible = false end)


-- ==========================================
-- 9. CONSTRUÇÃO DO SUB-PAINEL (ESP ESQUELETO)
-- ==========================================

local SubTitleSkel = Instance.new("TextLabel")
SubTitleSkel.Size = UDim2.new(1, 0, 0, 30)
SubTitleSkel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
SubTitleSkel.BorderSizePixel = 0
SubTitleSkel.Text = "SKELETON CONFIGS ⚙️"
SubTitleSkel.TextColor3 = Color3.fromRGB(255, 255, 255)
SubTitleSkel.Font = Enum.Font.GothamBold
SubTitleSkel.TextSize = 10
SubTitleSkel.Parent = SubPanelSkel

local SubTitleSkelCorner = Instance.new("UICorner")
SubTitleSkelCorner.CornerRadius = UDim.new(0, 12)
SubTitleSkelCorner.Parent = SubTitleSkel

local SkelThickLabel = Instance.new("TextLabel")
SkelThickLabel.Size = UDim2.new(1, 0, 0, 20)
SkelThickLabel.Position = UDim2.new(0, 10, 0, 40)
SkelThickLabel.BackgroundTransparency = 1
SkelThickLabel.Text = "ESPESSURA LINHAS: 1.5"
SkelThickLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SkelThickLabel.Font = Enum.Font.GothamBold
SkelThickLabel.TextSize = 9
SkelThickLabel.TextXAlignment = Enum.TextXAlignment.Left
SkelThickLabel.Parent = SubPanelSkel

local SkelThickSlider = Instance.new("TextButton")
SkelThickSlider.Size = UDim2.new(0.9, 0, 0, 18)
SkelThickSlider.Position = UDim2.new(0.05, 0, 0, 60)
SkelThickSlider.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SkelThickSlider.BorderSizePixel = 0
SkelThickSlider.Text = "MUDAR ESPESSURA"
SkelThickSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SkelThickSlider.Font = Enum.Font.GothamBold
SkelThickSlider.TextSize = 8
SkelThickSlider.Parent = SubPanelSkel

local SkelThickCorner = Instance.new("UICorner")
SkelThickCorner.CornerRadius = UDim.new(0, 4)
SkelThickCorner.Parent = SkelThickSlider

SkelThickSlider.MouseButton1Click:Connect(function()
    if ESP_Config.SkelThickness == 1.5 then
        ESP_Config.SkelThickness = 2.5
    elseif ESP_Config.SkelThickness == 2.5 then
        ESP_Config.SkelThickness = 4.0
    elseif ESP_Config.SkelThickness == 4.0 then
        ESP_Config.SkelThickness = 1.0
    else
        ESP_Config.SkelThickness = 1.5
    end
    SkelThickLabel.Text = "ESPESSURA LINHAS: " .. tostring(ESP_Config.SkelThickness)
end)

local SkelColorLabel = Instance.new("TextLabel")
SkelColorLabel.Size = UDim2.new(1, 0, 0, 20)
SkelColorLabel.Position = UDim2.new(0, 10, 0, 100)
SkelColorLabel.BackgroundTransparency = 1
SkelColorLabel.Text = "COR DO ESQUELETO"
SkelColorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SkelColorLabel.Font = Enum.Font.GothamBold
SkelColorLabel.TextSize = 9
SkelColorLabel.TextXAlignment = Enum.TextXAlignment.Left
SkelColorLabel.Parent = SubPanelSkel

local SkelColorContainer = Instance.new("Frame")
SkelColorContainer.Size = UDim2.new(0.9, 0, 0, 20)
SkelColorContainer.Position = UDim2.new(0.05, 0, 0, 120)
SkelColorContainer.BackgroundTransparency = 1
SkelColorContainer.Parent = SubPanelSkel

local SkelColorLayout = Instance.new("UIListLayout")
SkelColorLayout.FillDirection = Enum.FillDirection.Horizontal
SkelColorLayout.Padding = UDim.new(0, 6)
SkelColorLayout.Parent = SkelColorContainer

local sc1 = CreateColorSelector(Color3.fromRGB(255, 0, 0), SkelColorContainer)
sc1.MouseButton1Click:Connect(function() ESP_Config.SkelColor = Color3.fromRGB(255, 0, 0) end)
local sc2 = CreateColorSelector(Color3.fromRGB(0, 255, 0), SkelColorContainer)
sc2.MouseButton1Click:Connect(function() ESP_Config.SkelColor = Color3.fromRGB(0, 255, 0) end)
local sc3 = CreateColorSelector(Color3.fromRGB(255, 0, 255), SkelColorContainer)
sc3.MouseButton1Click:Connect(function() ESP_Config.SkelColor = Color3.fromRGB(255, 0, 255) end)
local sc4 = CreateColorSelector(Color3.fromRGB(255, 255, 255), SkelColorContainer)
sc4.MouseButton1Click:Connect(function() ESP_Config.SkelColor = Color3.fromRGB(255, 255, 255) end)
local sc5 = CreateColorSelector(Color3.fromRGB(255, 255, 0), SkelColorContainer)
sc5.MouseButton1Click:Connect(function() ESP_Config.SkelColor = Color3.fromRGB(255, 255, 0) end)

local SaveBtnSkel = Instance.new("TextButton")
SaveBtnSkel.Size = UDim2.new(0.9, 0, 0, 25)
SaveBtnSkel.Position = UDim2.new(0.05, 0, 0, 175)
SaveBtnSkel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SaveBtnSkel.BorderSizePixel = 0
SaveBtnSkel.Text = "SALVAR CONFIGURAÇÃO"
SaveBtnSkel.TextColor3 = Color3.fromRGB(0, 255, 0)
SaveBtnSkel.Font = Enum.Font.GothamBold
SaveBtnSkel.TextSize = 9
SaveBtnSkel.Parent = SubPanelSkel

SaveBtnSkel.MouseButton1Click:Connect(function() SubPanelSkel.Visible = false end)


-- ==========================================
-- 10. CRIANDO OS INTERRUPTORES NA ABA VISUAL
-- ==========================================

local function CreateToggleWithSettings(parent, text, default, subPanelToOpen, callback)
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

    SettingsBtn.MouseButton1Click:Connect(function()
        local lastState = subPanelToOpen.Visible
        CloseAllSubPanels()
        subPanelToOpen.Visible = not lastState
    end)
end

-- Criando os toggles com as sub-configurações correspondentes
CreateToggleWithSettings(PageVisual, "ESP LINE", false, SubPanel, function(v)
    ESP_Config.Active = v
end)

CreateToggleWithSettings(PageVisual, "ESP BOX", false, SubPanelBox, function(v)
    ESP_Config.BoxActive = v
end)

CreateToggleWithSettings(PageVisual, "ESP NOME", false, SubPanelName, function(v)
    ESP_Config.NameActive = v
end)

CreateToggleWithSettings(PageVisual, "ESP DISTÂNCIA", false, SubPanelDist, function(v)
    ESP_Config.DistActive = v
end)

CreateToggleWithSettings(PageVisual, "ESP ESQUELETO", false, SubPanelSkel, function(v)
    ESP_Config.SkelActive = v
end)


-- ==========================================
-- 11. RENDERIZADOR SUPREMO DE ESP CORRIGIDO (v1.8)
-- ==========================================

local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "BK_ESP_v15"
ESPContainer.Parent = ScreenGui

-- Cria conexões de linha de esqueleto 2D
local function DrawLine(parent, thickness)
    local l = Instance.new("Frame")
    l.BorderSizePixel = 0
    l.AnchorPoint = Vector2.new(0.5, 0.5)
    l.Visible = false
    l.Parent = parent
    return l
end

local function ApplyESP(player)
    if player == LocalPlayer then return end

    local PlayerFolder = Instance.new("Folder")
    PlayerFolder.Name = "ESP_" .. player.Name
    PlayerFolder.Parent = ESPContainer

    -- Estrutura ESP LINE
    local FrameLine = Instance.new("Frame")
    FrameLine.BorderSizePixel = 0
    FrameLine.Visible = false
    FrameLine.Parent = PlayerFolder

    -- Estrutura ESP BOX
    local FrameBox = Instance.new("Frame")
    FrameBox.BackgroundTransparency = 1
    FrameBox.Visible = false
    FrameBox.Parent = PlayerFolder

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = FrameBox

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 0)
    BoxCorner.Parent = FrameBox

    -- Estrutura ESP NOME
    local NameTag = Instance.new("TextLabel")
    NameTag.BackgroundTransparency = 1
    NameTag.Font = Enum.Font.GothamBold
    NameTag.Text = player.DisplayName
    NameTag.Visible = false
    NameTag.Parent = PlayerFolder

    -- Estrutura ESP DISTÂNCIA
    local DistTag = Instance.new("TextLabel")
    DistTag.BackgroundTransparency = 1
    DistTag.Font = Enum.Font.GothamBold
    DistTag.Visible = false
    DistTag.Parent = PlayerFolder

    -- Estrutura ESP ESQUELETO (Articulações R6/R15)
    local SkeletonFolder = Instance.new("Folder")
    SkeletonFolder.Name = "Skeleton"
    SkeletonFolder.Parent = PlayerFolder

    -- Pool de 16 linhas para cobrir perfeitamente o esqueleto R15
    local lines = {}
    for i = 1, 16 do
        lines[i] = DrawLine(SkeletonFolder, 1.5)
    end

    local function Clear()
        FrameLine.Visible = false
        FrameBox.Visible = false
        NameTag.Visible = false
        DistTag.Visible = false
        for _, line in ipairs(lines) do
            line.Visible = false
        end
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

        -- =================================================================
        -- CORREÇÃO DO INSET DA TELA (MOBILE TOOLBAR / TOPBAR SHIFT FIX)
        -- =================================================================
        local inset = GuiService:GetGuiInset()

        local RawScreenPos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
        -- Aplica a correção de escala e offset de viewport mobile
        local ScreenPos = Vector2.new(RawScreenPos.X, RawScreenPos.Y - inset.Y)

        if OnScreen then
            -- RENDERIZAR ESP LINE
            if ESP_Config.Active then
                local StartX = Camera.ViewportSize.X / 2
                local StartY = (ESP_Config.Origin == "Top") and 0 or Camera.ViewportSize.Y
                local TargetX = ScreenPos.X
                local TargetY = ScreenPos.Y

                local Dist = math.sqrt((TargetX - StartX)^2 + (TargetY - StartY)^2)
                local Angle = math.atan2(TargetY - StartY, TargetX - StartX)

                FrameLine.Size = UDim2.new(0, Dist, 0, ESP_Config.Thickness)
                FrameLine.BackgroundColor3 = ESP_Config.Color
                FrameLine.Position = UDim2.new(0, (StartX + TargetX) / 2 - Dist / 2, 0, (StartY + TargetY) / 2 - (ESP_Config.Origin == "Bottom" and inset.Y or 0))
                FrameLine.Rotation = math.deg(Angle)
                FrameLine.Visible = true
            else
                FrameLine.Visible = false
            end

            -- RENDERIZAR ESP BOX (CENTRALIZADO COM OFFSET CORRIGIDO)
            if ESP_Config.BoxActive then
                local RawTopPos, OnScreenTop = Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 3, 0))
                local RawBottomPos, OnScreenBottom = Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3.5, 0))

                if OnScreenTop and OnScreenBottom then
                    -- Ajusta as posições com base no Inset Mobile
                    local TopPos = Vector2.new(RawTopPos.X, RawTopPos.Y - inset.Y)
                    local BottomPos = Vector2.new(RawBottomPos.X, RawBottomPos.Y - inset.Y)

                    local BoxHeight = math.abs(TopPos.Y - BottomPos.Y) * ESP_Config.BoxSize
                    local BoxWidth = (BoxHeight * 0.65)

                    FrameBox.Size = UDim2.new(0, BoxWidth, 0, BoxHeight)
                    -- Perfeitamente centralizado no personagem compensando o inset
                    FrameBox.Position = UDim2.new(0, ScreenPos.X - (BoxWidth / 2), 0, ScreenPos.Y - (BoxHeight / 2))
                    
                    BoxStroke.Color = ESP_Config.BoxColor
                    BoxStroke.Thickness = ESP_Config.BoxThickness
                    BoxCorner.CornerRadius = ESP_Config.BoxRound and UDim.new(1, 0) or UDim.new(0, 0)
                    
                    FrameBox.Visible = true
                else
                    FrameBox.Visible = false
                end
            else
                FrameBox.Visible = false
            end

            -- RENDERIZAR ESP NOME
            if ESP_Config.NameActive then
                local DistFromCamera = (Camera.CoordinateFrame.p - RootPart.Position).Magnitude
                local OffsetY = (800 / DistFromCamera)

                NameTag.Size = UDim2.new(0, 150, 0, 20)
                NameTag.Position = UDim2.new(0, ScreenPos.X - 75, 0, ScreenPos.Y - OffsetY - 18)
                NameTag.TextSize = ESP_Config.NameSize
                NameTag.TextColor3 = ESP_Config.NameRGB and GlobalRGB or ESP_Config.NameColor
                NameTag.Visible = true
            else
                NameTag.Visible = false
            end

            -- RENDERIZAR ESP DISTÂNCIA
            if ESP_Config.DistActive then
                local DistFromCamera = math.floor((Camera.CoordinateFrame.p - RootPart.Position).Magnitude)
                local OffsetY = (800 / DistFromCamera)

                DistTag.Size = UDim2.new(0, 100, 0, 15)
                DistTag.Position = UDim2.new(0, ScreenPos.X - 50, 0, ScreenPos.Y + OffsetY + 5)
                DistTag.Text = "[" .. tostring(DistFromCamera) .. "m]"
                DistTag.TextSize = ESP_Config.DistSize
                DistTag.TextColor3 = ESP_Config.DistRGB and GlobalRGB or ESP_Config.DistColor
                DistTag.Visible = true
            else
                DistTag.Visible = false
            end

            -- RENDERIZAR ESP ESQUELETO (R6 / R15 DINÂMICO CENTRALIZADO COM INSET FIXED)
            if ESP_Config.SkelActive then
                local lineIndex = 1
                local rigType = Humanoid.RigType

                local function ConnectJoints(p1Name, p2Name)
                    local part1 = Char:FindFirstChild(p1Name)
                    local part2 = Char:FindFirstChild(p2Name)

                    if part1 and part2 and lines[lineIndex] then
                        local rawScreen1, on1 = Camera:WorldToViewportPoint(part1.Position)
                        local rawScreen2, on2 = Camera:WorldToViewportPoint(part2.Position)

                        if on1 and on2 then
                            -- Compensação de inset nas articulações
                            local screen1 = Vector2.new(rawScreen1.X, rawScreen1.Y - inset.Y)
                            local screen2 = Vector2.new(rawScreen2.X, rawScreen2.Y - inset.Y)

                            local line = lines[lineIndex]
                            local dx = screen2.X - screen1.X
                            local dy = screen2.Y - screen1.Y
                            local dist = math.sqrt(dx^2 + dy^2)
                            local angle = math.atan2(dy, dx)

                            line.Size = UDim2.new(0, dist, 0, ESP_Config.SkelThickness)
                            line.BackgroundColor3 = ESP_Config.SkelColor
                            line.Position = UDim2.new(0, (screen1.X + screen2.X) / 2, 0, (screen1.Y + screen2.Y) / 2)
                            line.Rotation = math.deg(angle)
                            line.Visible = true
                            
                            lineIndex = lineIndex + 1
                        end
                    end
                end

                -- Mapeamento das conexões de articulação
                if rigType == Enum.HumanoidRigType.R15 then
                    -- Tronco e Cabeça
                    ConnectJoints("Head", "UpperTorso")
                    ConnectJoints("UpperTorso", "LowerTorso")
                    
                    -- Braço Esquerdo
                    ConnectJoints("UpperTorso", "LeftUpperArm")
                    ConnectJoints("LeftUpperArm", "LeftLowerArm")
                    ConnectJoints("LeftLowerArm", "LeftHand")

                    -- Braço Direito
                    ConnectJoints("UpperTorso", "RightUpperArm")
                    ConnectJoints("RightUpperArm", "RightLowerArm")
                    ConnectJoints("RightLowerArm", "RightHand")

                    -- Perna Esquerda
                    ConnectJoints("LowerTorso", "LeftUpperLeg")
                    ConnectJoints("LeftUpperLeg", "LeftLowerLeg")
                    ConnectJoints("LeftLowerLeg", "LeftFoot")

                    -- Perna Direita
                    ConnectJoints("LowerTorso", "RightUpperLeg")
                    ConnectJoints("RightUpperLeg", "RightLowerLeg")
                    ConnectJoints("RightLowerLeg", "RightFoot")
                else
                    -- R6 Clássico estruturado com correção de Inset
                    ConnectJoints("Head", "Torso")
                    ConnectJoints("Torso", "Left Arm")
                    ConnectJoints("Torso", "Right Arm")
                    ConnectJoints("Torso", "Left Leg")
                    ConnectJoints("Torso", "Right Leg")
                end

                -- Esconde as linhas que sobraram
                for i = lineIndex, #lines do
                    lines[i].Visible = false
                end
            else
                for _, line in ipairs(lines) do
                    line.Visible = false
                end
            end
        else
            Clear()
        end
    end)
end

-- Monitorar jogadores do servidor
for _, p in ipairs(Players:GetPlayers()) do
    task.spawn(function() ApplyESP(p) end)
end
Players.PlayerAdded:Connect(function(p)
    task.spawn(function() ApplyESP(p) end)
end)
