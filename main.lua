-- [[ CONFIGURAÇÕES DO SCRIPT ]]
_G.AutoFishing = false
_G.MasteryFarm = false
local tempoReinicio = 2
local player = game.Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")
local camera = game.Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- [[ INTERFACE ESTILO AZTUP HUB ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Frame Principal (Design Escuro)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
TitleText.Text = "Order Hub | v3.52.6"
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
FishBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
FishBtn.TextSize = 14
FishBtn.Font = Enum.Font.Code
FishBtn.TextXAlignment = Enum.TextXAlignment.Left

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
TPBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
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
MasteryBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
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
ZoneFrame.BorderColor3 = Color3.fromRGB(0, 255, 127)
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
ListFrame.ClipsDescendants = false
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
        for _, pasta in ipairs(collectables:GetChildren()) do
            if pasta:IsA("Folder") or pasta:IsA("Model") then
                for _, item in ipairs(pasta:GetChildren()) do
                    if item.Name == itemSelecionado then
                        criarHighlight(item)
                    end
                end
            end
        end
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

local function atualizarListaItens()
    for _, child in ipairs(ListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    itensDisponiveis = buscarItensDropaveis()
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

DropdownMain.MouseButton1Click:Connect(function()
    ListFrame.Visible = not ListFrame.Visible
    if ListFrame.Visible then
        atualizarListaItens()
        ListFrame.Position = UDim2.new(
            DropdownMain.Position.X.Scale,
            DropdownMain.Position.X.Offset,
            DropdownMain.Position.Y.Scale,
            DropdownMain.Position.Y.Offset + DropdownMain.Size.Y.Offset
        )
    end
end)

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

-- ✅ FUNÇÃO CORRIGIDA - TELEPORTE PARA METEORO (NOME CORRETO)
local function teleportarParaMeteoro()
    print("\n[METEOR TP] ========== INICIANDO TELEPORTE ==========")
    
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    print("[METEOR TP] HRP encontrada:", hrp ~= nil)
    if hrp then
        print("[METEOR TP] Posição do player:", tostring(hrp.Position))
    end
    
    if not hrp then
        DebugLabel.Text = "> Status: Player not ready"
        print("[METEOR TP] ❌ HumanoidRootPart não encontrado")
        print("[METEOR TP] ==========================================\n")
        return
    end
    
    DebugLabel.Text = "> Status: Searching for meteor..."
    print("[METEOR TP] Procurando meteoro...")
    
    local meteor = nil
    
    print("[METEOR TP] [ETAPA 1] Procurando MeteoriteFragmentModel...")
    meteor = game.Workspace:FindFirstChild("MeteoriteFragmentModel")
    print("[METEOR TP] MeteoriteFragmentModel encontrada:", meteor ~= nil)
    
    if meteor then
        print("[METEOR TP] ✅ METEOR ENCONTRADO!")
        print("[METEOR TP] Nome:", meteor.Name)
        print("[METEOR TP] Tipo:", meteor.ClassName)
        print("[METEOR TP] Tem PrimaryPart:", meteor.PrimaryPart ~= nil)
        
        local meteorPos = nil
        
        if meteor.PrimaryPart then
            meteorPos = meteor.PrimaryPart.Position
            print("[METEOR TP] Usando PrimaryPart para posição")
        else
            for _, obj in ipairs(meteor:GetDescendants()) do
                if obj:IsA("BasePart") then
                    meteorPos = obj.Position
                    print("[METEOR TP] Usando BasePart para posição:", obj.Name)
                    break
                end
            end
        end
        
        if meteorPos then
            print("[METEOR TP] Posição do meteoro:", tostring(meteorPos))
            
            local destinoFinal = meteorPos + Vector3.new(15, 10, 15)
            print("[METEOR TP] Posição final (com offset):", tostring(destinoFinal))
            
            print("[METEOR TP] Teleportando...")
            hrp.CFrame = CFrame.new(destinoFinal)
            
            task.wait(0.5)
            
            print("[METEOR TP] Nova posição do player:", tostring(hrp.Position))
            print("[METEOR TP] ✅ TELEPORTE CONCLUÍDO!")
            DebugLabel.Text = "> Status: Reached Meteor ✅"
        else
            print("[METEOR TP] ❌ Não conseguiu encontrar posição do meteoro")
            DebugLabel.Text = "> Status: Meteor position error!"
        end
    else
        print("[METEOR TP] ❌ METEOR NÃO ENCONTRADO!")
        DebugLabel.Text = "> Status: Meteor NOT found! ❌"
    end
    
    print("[METEOR TP] ========== FIM DO TELEPORTE ==========\n")
end

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
    teleportarParaMeteoro()
end)

local function clicarNaZona()
    local centroX = ZoneFrame.AbsolutePosition.X + (ZoneFrame.AbsoluteSize.X / 2)
    local centroY = ZoneFrame.AbsolutePosition.Y + (ZoneFrame.AbsoluteSize.Y / 2)
    vim:SendMouseButtonEvent(centroX, centroY, 0, true, game, 0)
    task.wait(0.1)
    vim:SendMouseButtonEvent(centroX, centroY, 0, false, game, 0)
end

-- ✅ LOOP AUTO FISHING
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

-- ✅ LOOP MASTERY FARM
task.spawn(function()
    local teclasSequencia = {"B", "V", "C", "G", "F", "T"}
    local indiceAtual = 1
    local tempoEntreCliques = 0.5
    
    while true do
        task.wait(0.1)
        if _G.MasteryFarm then
            KeyNotificationGui.Enabled = true
            KeyNotifFrame.Visible = true
            
            local teclaAtual = teclasSequencia[indiceAtual]
            
            KeyNotifDisplay.Text = "[ " .. teclaAtual .. " ]"
            
            vim:SendKeyEvent(true, Enum.KeyCode[teclaAtual], false, game)
            task.wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode[teclaAtual], false, game)
            
            print("[MASTERY FARM] Apertou: " .. teclaAtual)
            
            indiceAtual = indiceAtual + 1
            if indiceAtual > #teclasSequencia then
                indiceAtual = 1
            end
            
            task.wait(tempoEntreCliques)
        else
            KeyNotifFrame.Visible = false
        end
    end
end)

-- ✅ ANTI-AFK NATIVO
task.spawn(function()
    print("[ANTI-AFK] Sistema iniciado!")
    local ultimaAtividadeDoPlayer = tick()
    
    while true do
        task.wait(1)
        
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.MoveVector ~= Vector3.new(0, 0, 0) then
                ultimaAtividadeDoPlayer = tick()
            end
            
            if tick() - ultimaAtividadeDoPlayer > 300 then
                print("[ANTI-AFK] ⚠️ Detectado AFK! Movendo player...")
                
                vim:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.5)
                vim:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                task.wait(0.3)
                
                vim:SendKeyEvent(true, Enum.KeyCode.S, false, game)
                task.wait(0.5)
                vim:SendKeyEvent(false, Enum.KeyCode.S, false, game)
                
                ultimaAtividadeDoPlayer = tick()
                print("[ANTI-AFK] ✅ Movimento executado!")
            end
        end
    end
end)

print("[AUTO FISHING] Script carregado com sucesso!")
print("[ANTI-AFK] ✅ Sistema Anti-AFK ativado automaticamente!")
