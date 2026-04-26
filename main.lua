-- [[ CONFIGURAÇÕES DO SCRIPT ]]
_G.AutoFishing = false
local tempoReinicio = 2
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local camera = game.Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")


local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Frame Principal (Design Escuro)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Fundo Aztup
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.Active = true
MainFrame.Draggable = true

-- Barra de Título
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -10, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.Text = "Order Hub | v1.0"
TitleText.TextColor3 = Color3.fromRGB(180, 180, 180)
TitleText.TextSize = 13
TitleText.Font = Enum.Font.Code
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.BackgroundTransparency = 1

-- Container de Conteúdo
local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 35)
Container.BackgroundTransparency = 1



-- Botão Auto Fishing
local FishBtn = Instance.new("TextButton", Container)
FishBtn.Size = UDim2.new(1, 0, 0, 30)
FishBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FishBtn.BorderSizePixel = 1
FishBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
FishBtn.Text = "  ■ Auto Fishing"
FishBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Começa Vermelho (desativado)
FishBtn.TextSize = 14
FishBtn.Font = Enum.Font.Code
FishBtn.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Teleport (Coordenadas da imagem)
local TPBtn = Instance.new("TextButton", Container)
TPBtn.Size = UDim2.new(1, 0, 0, 30)
TPBtn.Position = UDim2.new(0, 0, 0, 40)
TPBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TPBtn.BorderSizePixel = 1
TPBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
TPBtn.Text = "  ■ TP to Water Position"
TPBtn.TextColor3 = Color3.fromRGB(0, 255, 127) -- Verde Aztup
TPBtn.TextSize = 14
TPBtn.Font = Enum.Font.Code
TPBtn.TextXAlignment = Enum.TextXAlignment.Left

-- Debug Label (Status)
local DebugLabel = Instance.new("TextLabel", Container)
DebugLabel.Size = UDim2.new(1, 0, 0, 20)
DebugLabel.Position = UDim2.new(0, 0, 1, -20)
DebugLabel.BackgroundTransparency = 1
DebugLabel.Text = "> Status: Idle"
DebugLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
DebugLabel.TextSize = 12
DebugTextXAlignment = Enum.TextXAlignment.Left
DebugLabel.Font = Enum.Font.Code

-- [[ QUADRADO DE PESCA (ZONA) ]]
local ZoneFrame = Instance.new("Frame", ScreenGui)
ZoneFrame.Size = UDim2.new(0, 250, 0, 180)
ZoneFrame.Position = UDim2.new(0.5, -125, 0.4, -90)
ZoneFrame.BackgroundTransparency = 1 
ZoneFrame.BorderSizePixel = 2
ZoneFrame.BorderColor3 = Color3.fromRGB(0, 255, 127) -- Verde no quadrado também
ZoneFrame.Visible = false

local DragHandle = Instance.new("TextButton", ZoneFrame)
DragHandle.Size = UDim2.new(1, 0, 0, 20)
DragHandle.Position = UDim2.new(0, 0, -0.12, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
DragHandle.Text = "DRAG TO WATER"
DragHandle.TextColor3 = Color3.new(0, 0, 0)
DragHandle.TextSize = 10
DragHandle.Font = Enum.Font.Code
DragHandle.Draggable = true

-- [[ CONFIGURAÇÃO DO DROPDOWN ESP ]]

-- Função para buscar itens disponíveis dinamicamente
local function buscarItensDropaveis()
    local nomesUnicos = {}
    local jaAdicionados = {}
    local collectables = game.Workspace:FindFirstChild("Collectables")
    if collectables then
        for _, pasta in ipairs(collectables:GetChildren()) do
            if pasta:IsA("Folder") or pasta:IsA("Model") then
                for _, obj in ipairs(pasta:GetChildren()) do
                    if obj.Name and not jaAdicionados[obj.Name] then
                        table.insert(nomesUnicos, obj.Name)
                        jaAdicionados[obj.Name] = true
                    end
                end
            end
        end
    end
    return nomesUnicos
end

local itensDisponiveis = buscarItensDropaveis()

local itemSelecionado = ""
local ESP_Ativo = false
local ESP_Connections = {}

-- 1. BOTÃO PRINCIPAL
local DropdownMain = Instance.new("TextButton", Container)
DropdownMain.Size = UDim2.new(1, 0, 0, 30)
DropdownMain.Position = UDim2.new(0, 0, 0, 80)
DropdownMain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DropdownMain.BorderSizePixel = 1
DropdownMain.BorderColor3 = Color3.fromRGB(40, 40, 40)
DropdownMain.Text = "  ▼ SELECT ITEM(CLICK TWICE TO TOGGLE OFF)"
DropdownMain.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownMain.TextSize = 14
DropdownMain.Font = Enum.Font.Code
DropdownMain.TextXAlignment = Enum.TextXAlignment.Left

-- 2. LISTA (ScrollingFrame)
local ListFrame = Instance.new("ScrollingFrame", MainFrame)
ListFrame.Size = UDim2.new(0, 200, 0, 150)
ListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ListFrame.BorderSizePixel = 1
ListFrame.BorderColor3 = Color3.fromRGB(45, 45, 45)
ListFrame.Visible = false
ListFrame.ZIndex = 100
ListFrame.ScrollBarThickness = 5
ListFrame.ClipsDescendants = false -- Para debug visual
ListFrame.CanvasSize = UDim2.new(0, 0, 0, #itensDisponiveis * 30 + 10)

local UIList = Instance.new("UIListLayout")
UIList.Parent = ListFrame
UIList.Padding = UDim.new(0, 2)

-- 3. FUNÇÃO DE ATUALIZAR ESP
local function criarHighlight(item)
    local h = item:FindFirstChild("ESPHighlight")
    if not h then
        h = Instance.new("Highlight")
        h.Name = "ESPHighlight"
        h.Parent = item
    end
    h.FillColor = Color3.fromRGB(0, 255, 127)
    h.FillTransparency = 0.5
    h.OutlineColor = Color3.new(1, 1, 1)
    h.OutlineTransparency = 0
    h.Adornee = item
    h.Enabled = true
end

local function limparESP()
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:FindFirstChild("ESPHighlight") then
            obj.ESPHighlight:Destroy()
        end
    end
end

local function ativarESP()
    limparESP()
    ESP_Ativo = true
    local collectables = game.Workspace:FindFirstChild("Collectables")
    if collectables then
        -- Destaca todos os objetos com o nome selecionado em todas as pastas
        for _, pasta in ipairs(collectables:GetChildren()) do
            if pasta:IsA("Folder") or pasta:IsA("Model") then
                for _, item in ipairs(pasta:GetChildren()) do
                    if item.Name == itemSelecionado then
                        criarHighlight(item)
                    end
                end
            end
        end
        -- Destaca novos drops com o nome selecionado
        table.insert(ESP_Connections, collectables.DescendantAdded:Connect(function(desc)
            task.wait(0.1)
            if desc.Name == itemSelecionado then
                criarHighlight(desc)
            end
        end))
    end
    DropdownMain.TextColor3 = Color3.fromRGB(0, 255, 127)
    DropdownMain.Text = "  ■ ESP ATIVO: " .. itemSelecionado
    DebugLabel.Text = "> ESP: " .. itemSelecionado .. " ATIVO"
end

local function desativarESP()
    ESP_Ativo = false
    for _, conn in ipairs(ESP_Connections) do pcall(function() conn:Disconnect() end) end
    table.clear(ESP_Connections)
    limparESP()
    DropdownMain.TextColor3 = Color3.fromRGB(200, 200, 200)
    DropdownMain.Text = "  ▼ SELECIONAR ITEM ESP"
    DebugLabel.Text = "> ESP Desativado"
end

-- 4. CRIAR ITENS DA LISTA

-- Função para popular a lista dinamicamente
local function atualizarListaItens()
    -- Limpa itens antigos
    for _, child in ipairs(ListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    itensDisponiveis = buscarItensDropaveis()
    print("[DEBUG] Itens encontrados na busca:")
    for _, nome in ipairs(itensDisponiveis) do
        print("  - " .. nome)
    end
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, #itensDisponiveis * 30 + 10)
    for _, nome in ipairs(itensDisponiveis) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Parent = ListFrame
        ItemBtn.Size = UDim2.new(1, 0, 0, 28)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ItemBtn.BorderSizePixel = 0
        ItemBtn.Text = "  " .. nome
        ItemBtn.TextColor3 = Color3.new(1, 1, 1)
        ItemBtn.TextSize = 12
        ItemBtn.Font = Enum.Font.Code
        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
        ItemBtn.ZIndex = 101

        ItemBtn.MouseButton1Click:Connect(function()
            if ESP_Ativo and itemSelecionado == nome then
                desativarESP()
            else
                itemSelecionado = nome
                ativarESP()
            end
            ListFrame.Visible = false
        end)
        ItemBtn.MouseEnter:Connect(function()
            ItemBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        ItemBtn.MouseLeave:Connect(function()
            ItemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end)
    end
end

-- 5. LÓGICA DE ABRIR/FECHAR
DropdownMain.MouseButton1Click:Connect(function()
    ListFrame.Visible = not ListFrame.Visible
    if ListFrame.Visible then
        atualizarListaItens()
        -- Posição relativa ao MainFrame: logo abaixo do DropdownMain
        ListFrame.Position = UDim2.new(
            DropdownMain.Position.X.Scale,
            DropdownMain.Position.X.Offset,
            DropdownMain.Position.Y.Scale,
            DropdownMain.Position.Y.Offset + DropdownMain.Size.Y.Offset
        )
    end
end)

-- Opcional: Ativar ESP automaticamente ao iniciar


-- Lógica Teleporte (Tween atravessa paredes)
TPBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        DebugLabel.Text = "> Status: Traveling..."
        local destino = CFrame.new(-3122.65, 149.17, -1405.69)
        local tempo = (hrp.Position - destino.Position).Magnitude / 60
        local tween = TweenService:Create(hrp, TweenInfo.new(tempo, Enum.EasingStyle.Linear), {CFrame = destino})
        
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        tween:Play()
        tween.Completed:Connect(function() 
            bv:Destroy() 
            DebugLabel.Text = "> Status: Destination Reached"
        end)
    end
end)

-- Função para teleportar o jogador até o meteoro
local function teleportarParaMeteor()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local meteor = game:GetService("Workspace"):FindFirstChild("MeteoriteFragmentModel")

    if hrp and meteor then
        DebugLabel.Text = "> Status: Teleporting to Meteor..."
        local destino = meteor.PrimaryPart and meteor.PrimaryPart.CFrame or meteor.CFrame
        local tempo = (hrp.Position - destino.Position).Magnitude / 60
        local tween = TweenService:Create(hrp, TweenInfo.new(tempo, Enum.EasingStyle.Linear), {CFrame = destino})

        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        tween:Play()
        tween.Completed:Connect(function()
            bv:Destroy()
            DebugLabel.Text = "> Status: Reached Meteor"
        end)
    else
        DebugLabel.Text = "> Status: Meteor not found or player not ready"
    end
end

-- Botão para teleportar para o meteoro
local MeteorTPBtn = Instance.new("TextButton", Container)
MeteorTPBtn.Size = UDim2.new(1, 0, 0, 30)
MeteorTPBtn.Position = UDim2.new(0, 0, 0, 120)
MeteorTPBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MeteorTPBtn.BorderSizePixel = 1
MeteorTPBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
MeteorTPBtn.Text = "  ■ TP to Meteor"
MeteorTPBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
MeteorTPBtn.TextSize = 14
MeteorTPBtn.Font = Enum.Font.Code
MeteorTPBtn.TextXAlignment = Enum.TextXAlignment.Left

MeteorTPBtn.MouseButton1Click:Connect(function()
    teleportarParaMeteor()
end)

-- Loop de Pesca (Seu sistema original corrigido)
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoFishing then
            local char = player.Character
            if char and char:FindFirstChildOfClass("Tool") then
                clicarNaZona()
                task.wait(3.5)
                local mordeu = false
                while _G.AutoFishing and not mordeu do
                    for _, obj in ipairs(game.Workspace:GetChildren()) do
                        if obj:IsA("BasePart") or obj:FindFirstChildOfClass("ParticleEmitter") then
                            local screenPos, onScreen = camera:WorldToScreenPoint(obj.Position)
                            if onScreen then
                                local relX = screenPos.X - ZoneFrame.AbsolutePosition.X
                                local relY = screenPos.Y - ZoneFrame.AbsolutePosition.Y
                                if relX > 0 and relX < ZoneFrame.AbsoluteSize.X and relY > 0 and relY < ZoneFrame.AbsoluteSize.Y then
                                    if obj.Name:lower():find("effect") or obj.Name:lower():find("splash") or obj.Name:lower():find("ring") then
                                        mordeu = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
                if mordeu and _G.AutoFishing then
                    clicarNaZona()
                    task.wait(tempoReinicio)
                end
            end
        end
    end
end)
