-- [[ CONFIGURAÇÕES DO SCRIPT ]]
_G.AutoFishing = false
_G.MasteryFarm = false
local tempoReinicio = 2
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local camera = game.Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- [[ INTERFACE ESTILO AZTUP HUB ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Frame Principal (Design Escuro)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
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

-- [[ COMPONENTES: BOTÕES ESTILO HUB ]]

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

-- Toggle Auto Fishing
FishBtn.MouseButton1Click:Connect(function()
    _G.AutoFishing = not _G.AutoFishing
    if _G.AutoFishing then
        FishBtn.Text = "  ■ Auto Fishing (ON)"
        FishBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        DebugLabel.Text = "> Auto Fishing: ATIVO"
        ZoneFrame.Visible = true
    else
        FishBtn.Text = "  ■ Auto Fishing"
        FishBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        DebugLabel.Text = "> Auto Fishing: DESATIVADO"
    end
end)

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

-- Botão Mastery Farm
local MasteryBtn = Instance.new("TextButton", Container)
MasteryBtn.Size = UDim2.new(1, 0, 0, 30)
MasteryBtn.Position = UDim2.new(0, 0, 0, 160)
MasteryBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MasteryBtn.BorderSizePixel = 1
MasteryBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
MasteryBtn.Text = "  ■ Mastery Farm"
MasteryBtn.TextColor3 = Color3.fromRGB(255, 50, 50) -- Começa Vermelho
MasteryBtn.TextSize = 14
MasteryBtn.Font = Enum.Font.Code
MasteryBtn.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Mastery Farm
MasteryBtn.MouseButton1Click:Connect(function()
    _G.MasteryFarm = not _G.MasteryFarm
    if _G.MasteryFarm then
        MasteryBtn.Text = "  ■ Mastery Farm (ON)"
        MasteryBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        DebugLabel.Text = "> Mastery Farm: ATIVO"
    else
        MasteryBtn.Text = "  ■ Mastery Farm"
        MasteryBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        DebugLabel.Text = "> Mastery Farm: DESATIVADO"
    end
end)

-- Debug Label (Status)
local DebugLabel = Instance.new("TextLabel", Container)
DebugLabel.Size = UDim2.new(1, 0, 0, 20)
DebugLabel.Position = UDim2.new(0, 0, 1, -20)
DebugLabel.BackgroundTransparency = 1
DebugLabel.Text = "> Status: Idle"
DebugLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
DebugLabel.TextSize = 12
DebugLabel.TextXAlignment = Enum.TextXAlignment.Left
DebugLabel.Font = Enum.Font.Code

-- [[ NOTIFICAÇÃO FLUTUANTE DE TECLAS (MASTERY FARM) ]]
local KeyNotificationGui = Instance.new("ScreenGui", game.CoreGui)
KeyNotificationGui.Name = "MasteryKeyNotif"
KeyNotificationGui.ResetOnSpawn = false

local KeyNotifFrame = Instance.new("Frame", KeyNotificationGui)
KeyNotifFrame.Size = UDim2.new(0, 280, 0, 80)
KeyNotifFrame.Position = UDim2.new(1, -300, 0, 20)
KeyNotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyNotifFrame.BorderSizePixel = 2
KeyNotifFrame.BorderColor3 = Color3.fromRGB(0, 255, 127)
KeyNotifFrame.Visible = false

local KeyNotifCorner = Instance.new("UICorner", KeyNotifFrame)
KeyNotifCorner.CornerRadius = UDim.new(0, 8)

local KeyNotifTitle = Instance.new("TextLabel", KeyNotifFrame)
KeyNotifTitle.Size = UDim2.new(1, -10, 0, 25)
KeyNotifTitle.Position = UDim2.new(0, 5, 0, 5)
KeyNotifTitle.BackgroundTransparency = 1
KeyNotifTitle.Text = "⚡ Apertando Tecla"
KeyNotifTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
KeyNotifTitle.TextSize = 13
KeyNotifTitle.Font = Enum.Font.Code
KeyNotifTitle.TextXAlignment = Enum.TextXAlignment.Left

local KeyNotifDisplay = Instance.new("TextLabel", KeyNotifFrame)
KeyNotifDisplay.Size = UDim2.new(1, -10, 0, 35)
KeyNotifDisplay.Position = UDim2.new(0, 5, 0, 30)
KeyNotifDisplay.BackgroundTransparency = 1
KeyNotifDisplay.Text = "[ B ]"
KeyNotifDisplay.TextColor3 = Color3.fromRGB(255, 100, 100)
KeyNotifDisplay.TextSize = 28
KeyNotifDisplay.Font = Enum.Font.GothamBold
KeyNotifDisplay.TextXAlignment = Enum.TextXAlignment.Center

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
DropdownMain.Text = "  ▼ SELECIONAR ITEM ESP"
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

-- ✅ FUNÇÃO CORRIGIDA - TELEPORTE DIRETO PARA O METEORO
local function teleportarParaMeteor()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local meteor = game.Workspace:FindFirstChild("MeteoriteFragmentModel")

    if hrp and meteor then
        DebugLabel.Text = "> Status: Teleporting to Meteor..."
        
        -- ✅ ENCONTRA A POSIÇÃO DO METEORO CORRETAMENTE
        local meteorPos = (meteor:FindFirstChild("PrimaryPart") or meteor:FindFirstChildWhichIsA("BasePart") or meteor).Position
        
        -- ✅ ADICIONA OFFSET PARA NÃO FICAR DENTRO DO METEORO
        local destinoFinal = meteorPos + Vector3.new(10, 5, 10)
        
        -- ✅ TELEPORTE DIRETO E INSTANTÂNEO (MAIS CONFIÁVEL)
        hrp.CFrame = CFrame.new(destinoFinal)
        
        task.wait(0.5)
        DebugLabel.Text = "> Status: Reached Meteor"
        print("[DEBUG] Teleportado para o meteoro em: " .. tostring(destinoFinal))
    else
        DebugLabel.Text = "> Status: Meteor not found or player not ready"
        print("[DEBUG] HRP encontrada:", hrp ~= nil)
        print("[DEBUG] Meteoro encontrado:", meteor ~= nil)
        if meteor then
            print("[DEBUG] Nome do meteoro:", meteor.Name)
            print("[DEBUG] Posição do meteoro:", meteor.Position)
        end
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

-- ✅ FUNÇÃO CORRIGIDA DE CLIQUE (PARÂMETROS CORRETOS)
local function clicarNaZona()
    local centroX = ZoneFrame.AbsolutePosition.X + (ZoneFrame.AbsoluteSize.X / 2)
    local centroY = ZoneFrame.AbsolutePosition.Y + (ZoneFrame.AbsoluteSize.Y / 2)
    vim:SendMouseButtonEvent(centroX, centroY, 0, true, game, 0)
    task.wait(0.1)
    vim:SendMouseButtonEvent(centroX, centroY, 0, false, game, 0)
end

-- ✅ LOOP DE PESCA (CORRIGIDO - COMO A VERSÃO QUE FUNCIONAVA)
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
                    -- ✅ PROCURA EM TODOS OS FILHOS DO WORKSPACE
                    for _, obj in ipairs(game.Workspace:GetChildren()) do
                        if obj:IsA("BasePart") or obj:FindFirstChildOfClass("ParticleEmitter") then
                            local screenPos, onScreen = camera:WorldToScreenPoint(obj.Position)
                            if onScreen then
                                local relX = screenPos.X - ZoneFrame.AbsolutePosition.X
                                local relY = screenPos.Y - ZoneFrame.AbsolutePosition.Y
                                if relX > 0 and relX < ZoneFrame.AbsoluteSize.X and relY > 0 and relY < ZoneFrame.AbsoluteSize.Y then
                                    -- ✅ DETECÇÃO DE EFEITOS DE MORDIDA
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

-- ✅ LOOP MASTERY FARM (APERTA B, V, C, G, F, T EM ORDEM)
task.spawn(function()
    local teclasSequencia = {"B", "V", "C", "G", "F", "T"}
    local indiceAtual = 1
    local tempoEntreCliques = 0.5 -- Tempo entre apertos (em segundos)
    
    while true do
        task.wait(0.1)
        if _G.MasteryFarm then
            KeyNotificationGui.Enabled = true
            KeyNotifFrame.Visible = true
            
            local teclaAtual = teclasSequencia[indiceAtual]
            
            -- ✅ ATUALIZA A NOTIFICAÇÃO COM A TECLA ATUAL
            KeyNotifDisplay.Text = "[ " .. teclaAtual .. " ]"
            
            -- ✅ SIMULA O APERTO DA TECLA
            vim:SendKeyEvent(true, Enum.KeyCode[teclaAtual], false, game)
            task.wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode[teclaAtual], false, game)
            
            print("[MASTERY FARM] Apertou: " .. teclaAtual)
            
            -- ✅ PASSA PARA A PRÓXIMA TECLA
            indiceAtual = indiceAtual + 1
            if indiceAtual > #teclasSequencia then
                indiceAtual = 1 -- Volta ao começo
            end
            
            task.wait(tempoEntreCliques)
        else
            KeyNotifFrame.Visible = false
        end
    end
end)

print("[AUTO FISHING] Script carregado com sucesso!")
