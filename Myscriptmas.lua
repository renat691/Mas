-- ============================================
-- ⚖ WEIGHT CONTROL v205 — ULTIMATE + LANG
-- RU/EN, без полёта, исправлен лунный прыжок
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ================== НАСТРОЙКИ ==================
local CONFIG = { DEFAULT_WEIGHT = 100, ANIM_SPEED = 0.25 }

local state = {
    weight = CONFIG.DEFAULT_WEIGHT,
    menuOpen = false,
    dragging = false,
    topBarVisible = true,
    forceSpeed = true,
    speedValue = 16,
    accent = Color3.fromRGB(120, 160, 255),
    accent2 = Color3.fromRGB(200, 100, 255),
    bg = Color3.fromRGB(18, 18, 26),
    bg2 = Color3.fromRGB(28, 28, 40),
    text = Color3.fromRGB(240, 240, 255),
    subtext = Color3.fromRGB(160, 160, 200),
    danger = Color3.fromRGB(255, 80, 80),
    success = Color3.fromRGB(80, 220, 130),
    menuTransparency = 0.1,
    activeTab = "main",
}

-- ================== ЛОКАЛИЗАЦИЯ ==================
local LOCALES = {
    ru = {
        header="⚖ WEIGHT ULTIMATE", tab_weight="ВЕС", tab_speed="СКОРОСТЬ",
        tab_player="ИГРОК", tab_extra="ФИШКИ", tab_style="СТИЛЬ",
        current_weight="ТЕКУЩИЙ ВЕС", top_weight="⚖ ВЕС: ",
        speed_title="🏃 СКОРОСТЬ БЕГА", player_title="👤 УПРАВЛЕНИЕ ПЕРСОНАЖЕМ",
        extra_title="✨ ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ", style_title="🎨 ЦВЕТА МЕНЮ",
        lang_title="🌍 ЯЗЫК / LANGUAGE",
        hide_top="Скрыть верх", show_top="Показать верх", reset="Сброс",
        force_on="Принудительная скорость: ВКЛ", force_off="Принудительная скорость: ВЫКЛ",
        on=": ВКЛ", off=": ВЫКЛ",
        noclip="👻 Noclip", no_gravity="🌌 Нулевая гравитация", hover="🛸 Hover",
        inf_jump="🦅 Бесконечный прыжок", auto_jump="🦘 Автопрыжок",
        high_jump="🚀 Высокий прыжок", moon_jump="🌙 Лунный прыжок",
        water_walk="🌊 Ходьба по воде", ghost="👤 Полупрозрачность",
        spin="🌀 Вращение", tiny="🐜 Маленький персонаж",
        rainbow="🌈 Радужный персонаж", auto_heal="❤ Авто-хил",
        stamina="⚡ Бесконечная стамина", anti_afk="🛡 Anti-AFK",
        fullbright="💡 Fullbright", fast_fall="⬇ Быстрое падение",
        zoom="🔍 Максимальный зум", fire="🔥 Огненная аура",
        sparkles="✨ Искры аура", tp_up="⬆ Телепорт вверх (+50)",
        tp_down="⬇ Телепорт вниз (-50)", tp_spawn="🏠 Телепорт на спавн",
        respawn="💀 Респавн (убить себя)", disable_all="🛑 Выключить ВСЕ функции",
        esp="👁 ESP игроков", follow="👀 Следить за игроком",
        tp_player="📍 Телепорт к игроку...", tp_title="📍 ТЕЛЕПОРТ К ИГРОКУ",
        search="🔍 Поиск по нику...",
    },
    en = {
        header="⚖ WEIGHT ULTIMATE", tab_weight="WEIGHT", tab_speed="SPEED",
        tab_player="PLAYER", tab_extra="FEATURES", tab_style="STYLE",
        current_weight="CURRENT WEIGHT", top_weight="⚖ WEIGHT: ",
        speed_title="🏃 WALK SPEED", player_title="👤 CHARACTER CONTROL",
        extra_title="✨ EXTRA FEATURES", style_title="🎨 MENU COLORS",
        lang_title="🌍 LANGUAGE",
        hide_top="Hide top", show_top="Show top", reset="Reset",
        force_on="Force Speed: ON", force_off="Force Speed: OFF",
        on=": ON", off=": OFF",
        noclip="👻 Noclip", no_gravity="🌌 Zero Gravity", hover="🛸 Hover",
        inf_jump="🦅 Infinite Jump", auto_jump="🦘 Auto Jump",
        high_jump="🚀 High Jump", moon_jump="🌙 Moon Jump",
        water_walk="🌊 Walk on Water", ghost="👤 Transparency",
        spin="🌀 Spin", tiny="🐜 Tiny Character",
        rainbow="🌈 Rainbow Character", auto_heal="❤ Auto Heal",
        stamina="⚡ Infinite Stamina", anti_afk="🛡 Anti-AFK",
        fullbright="💡 Fullbright", fast_fall="⬇ Fast Fall",
        zoom="🔍 Max Zoom", fire="🔥 Fire Aura",
        sparkles="✨ Sparkles Aura", tp_up="⬆ Teleport Up (+50)",
        tp_down="⬇ Teleport Down (-50)", tp_spawn="🏠 Teleport to Spawn",
        respawn="💀 Respawn (kill self)", disable_all="🛑 Disable ALL",
        esp="👁 Player ESP", follow="👀 Follow Player",
        tp_player="📍 Teleport to Player...", tp_title="📍 TELEPORT TO PLAYER",
        search="🔍 Search by name...",
    }
}
local currentLang = "ru"
local function L(key)
    local loc = LOCALES[currentLang] or LOCALES.ru
    return loc[key] or key
end

-- ================== ФЛАГИ ==================
local flags = {
    autoJump=false, infJump=false, autoReset=false, speedBoost=false,
    noclip=false, antiAFK=false, walkOnWater=false, noGravity=false,
    fullBright=false, spin=false, tinyChar=false, rainbowChar=false,
    highJump=false, esp=false, autoHeal=false, infStamina=false,
    hover=false, moonJump=false, fastFall=false, cameraZoom=false,
    fireAura=false, sparklesAura=false, lookAtPlayer=false, ghostMode=false,
}

-- ================== ФУНКЦИИ ==================
local function formatWeight(n)
    if n == math.huge then return "∞" end
    if n >= 1e12 then return string.format("%.2fT", n / 1e12) end
    if n >= 1e9 then return string.format("%.2fB", n / 1e9) end
    if n >= 1e6 then return string.format("%.2fM", n / 1e6) end
    if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
    return tostring(math.floor(n))
end

local function applyWeight(value)
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function()
                part.CustomPhysicalProperties = PhysicalProperties.new(math.min(value,100),0.3,0.5)
            end)
        end
    end
    state.weight = value
end

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local myChar = player.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myHrp and targetHrp then
        myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
    end
end

-- ================== СКОРОСТЬ ==================
task.spawn(function()
    while true do
        if state.forceSpeed then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.WalkSpeed = state.speedValue end) end
            end
        end
        task.wait(0.1)
    end
end)

-- ================== UI ROOT ==================
local sg = Instance.new("ScreenGui")
sg.Name = "WeightUlt_" .. math.random(1,99999)
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = game:GetService("CoreGui")

-- Верхний индикатор
local topBar = Instance.new("Frame", sg)
topBar.Size = UDim2.new(0, 340, 0, 46)
topBar.Position = UDim2.new(0.5, -170, 0, 12)
topBar.BackgroundColor3 = state.bg
topBar.BackgroundTransparency = 0.1
topBar.BorderSizePixel = 0
topBar.ZIndex = 50
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)
local topStroke = Instance.new("UIStroke", topBar)
topStroke.Color = state.accent
topStroke.Thickness = 1.5
topStroke.Transparency = 0.3

local topText = Instance.new("TextLabel", topBar)
topText.Size = UDim2.new(1, -20, 1, 0)
topText.Position = UDim2.new(0, 15, 0, 0)
topText.BackgroundTransparency = 1
topText.Text = L("top_weight") .. formatWeight(state.weight)
topText.TextColor3 = state.text
topText.Font = Enum.Font.GothamBold
topText.TextScaled = true
topText.TextXAlignment = Enum.TextXAlignment.Left
topText.ZIndex = 51

-- FAB
local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 20, 0, 100)
openBtn.BackgroundColor3 = state.accent
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextScaled = true
openBtn.Text = "⚖"
openBtn.ZIndex = 10
openBtn.AutoButtonColor = false
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)
local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = state.accent2
openStroke.Thickness = 2
openStroke.Transparency = 0.4

-- Панель
local panel = Instance.new("Frame", sg)
panel.Size = UDim2.new(0, 400, 0, 540)
panel.Position = UDim2.new(0.5, -200, 0.5, -270)
panel.BackgroundColor3 = state.bg
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 20
panel.ClipsDescendants = true
panel.Active = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = state.accent
panelStroke.Thickness = 1.5
panelStroke.Transparency = 0.3

-- Заголовок
local header = Instance.new("Frame", panel)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundTransparency = 1
header.ZIndex = 21

local headerTitle = Instance.new("TextLabel", header)
headerTitle.Size = UDim2.new(1, -100, 1, 0)
headerTitle.Position = UDim2.new(0, 20, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = L("header")
headerTitle.TextColor3 = state.text
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextScaled = true
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.ZIndex = 22

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
closeBtn.BackgroundColor3 = state.danger
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.Text = "✕"
closeBtn.ZIndex = 22
closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Вкладки
local tabsFrame = Instance.new("Frame", panel)
tabsFrame.Size = UDim2.new(1, -20, 0, 34)
tabsFrame.Position = UDim2.new(0, 10, 0, 48)
tabsFrame.BackgroundColor3 = state.bg2
tabsFrame.BorderSizePixel = 0
tabsFrame.ZIndex = 21
Instance.new("UICorner", tabsFrame).CornerRadius = UDim.new(0, 8)

local tabsLayout = Instance.new("UIListLayout", tabsFrame)
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabsLayout.Padding = UDim.new(0, 3)

local tabButtons = {}
local contentFrames = {}
local tabKeys = {}

local function createTab(name, key, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 70, 0, 26)
    b.BackgroundColor3 = state.bg2
    b.TextColor3 = state.subtext
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = L(key)
    b.ZIndex = 22
    b.AutoButtonColor = false
    b.LayoutOrder = order
    b.Parent = tabsFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        state.activeTab = name
        for n, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = (n==name) and state.accent or state.bg2
            btn.TextColor3 = (n==name) and Color3.new(1,1,1) or state.subtext
        end
        for n, f in pairs(contentFrames) do f.Visible = (n==name) end
    end)
    tabButtons[name] = b
    tabKeys[name] = key
    return b
end

local function createContent(name)
    local f = Instance.new("Frame", panel)
    f.Size = UDim2.new(1, -20, 1, -150)
    f.Position = UDim2.new(0, 10, 0, 88)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.ZIndex = 21
    f.Active = false
    contentFrames[name] = f
    return f
end

createTab("main","tab_weight",1)
createTab("speed","tab_speed",2)
createTab("player","tab_player",3)
createTab("extra","tab_extra",4)
createTab("style","tab_style",5)

local mainContent = createContent("main")
local speedContent = createContent("speed")
local playerContent = createContent("player")
local extraContent = createContent("extra")
local styleContent = createContent("style")

tabButtons["main"].BackgroundColor3 = state.accent
tabButtons["main"].TextColor3 = Color3.new(1,1,1)
mainContent.Visible = true

-- ================== ВКЛАДКА "ВЕС" ==================
local card = Instance.new("Frame", mainContent)
card.Size = UDim2.new(1, 0, 0, 80)
card.Position = UDim2.new(0, 0, 0, 5)
card.BackgroundColor3 = state.bg2
card.BorderSizePixel = 0
card.ZIndex = 22
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

local bigValue = Instance.new("TextLabel", card)
bigValue.Size = UDim2.new(1, -20, 0, 50)
bigValue.Position = UDim2.new(0, 10, 0, 5)
bigValue.BackgroundTransparency = 1
bigValue.Text = formatWeight(state.weight)
bigValue.TextColor3 = state.accent
bigValue.Font = Enum.Font.GothamBold
bigValue.TextScaled = true
bigValue.ZIndex = 23

local bigSub = Instance.new("TextLabel", card)
bigSub.Size = UDim2.new(1, -20, 0, 20)
bigSub.Position = UDim2.new(0, 10, 0, 55)
bigSub.BackgroundTransparency = 1
bigSub.Text = L("current_weight")
bigSub.TextColor3 = state.subtext
bigSub.Font = Enum.Font.Gotham
bigSub.TextScaled = true
bigSub.ZIndex = 23

local sliderBg = Instance.new("Frame", mainContent)
sliderBg.Size = UDim2.new(1, 0, 0, 14)
sliderBg.Position = UDim2.new(0, 0, 0, 100)
sliderBg.BackgroundColor3 = Color3.fromRGB(45,45,60)
sliderBg.BorderSizePixel = 0
sliderBg.ZIndex = 22
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = state.accent
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 23
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

local knob = Instance.new("Frame", sliderBg)
knob.Size = UDim2.new(0, 26, 0, 26)
knob.Position = UDim2.new(0, -13, 0.5, -13)
knob.BackgroundColor3 = Color3.new(1,1,1)
knob.BorderSizePixel = 0
knob.ZIndex = 24
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
local knobStroke = Instance.new("UIStroke", knob)
knobStroke.Color = state.accent
knobStroke.Thickness = 3

local quickFrame = Instance.new("Frame", mainContent)
quickFrame.Size = UDim2.new(1, 0, 0, 100)
quickFrame.Position = UDim2.new(0, 0, 0, 130)
quickFrame.BackgroundTransparency = 1
quickFrame.ZIndex = 25

local setSliderFromWeight
local BTN_W, BTN_H, GAP_X, GAP_Y = 78, 42, 8, 10

local function makeQuickBtn(text, weight, col, row)
    local b = Instance.new("TextButton", quickFrame)
    b.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    b.Position = UDim2.new(0, col*(BTN_W+GAP_X), 0, row*(BTN_H+GAP_Y))
    b.BackgroundColor3 = state.bg2
    b.TextColor3 = state.text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = text
    b.ZIndex = 30
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() if setSliderFromWeight then setSliderFromWeight(weight) end end)
end

makeQuickBtn("1",1,0,0) makeQuickBtn("10",10,1,0) makeQuickBtn("100",100,2,0) makeQuickBtn("1K",1000,3,0)
makeQuickBtn("10K",1e4,0,1) makeQuickBtn("100K",1e5,1,1) makeQuickBtn("1M",1e6,2,1) makeQuickBtn("∞",math.huge,3,1)

-- ================== ВКЛАДКА "СКОРОСТЬ" ==================
local speedTitle = Instance.new("TextLabel", speedContent)
speedTitle.Size = UDim2.new(1, 0, 0, 26)
speedTitle.Position = UDim2.new(0, 0, 0, 10)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = L("speed_title")
speedTitle.TextColor3 = state.subtext
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextScaled = true
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 22

local speedValueLabel = Instance.new("TextLabel", speedContent)
speedValueLabel.Size = UDim2.new(1, 0, 0, 40)
speedValueLabel.Position = UDim2.new(0, 0, 0, 40)
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Text = tostring(state.speedValue)
speedValueLabel.TextColor3 = state.success
speedValueLabel.Font = Enum.Font.GothamBold
speedValueLabel.TextScaled = true
speedValueLabel.ZIndex = 22

local speedSliderBg = Instance.new("Frame", speedContent)
speedSliderBg.Size = UDim2.new(1, 0, 0, 14)
speedSliderBg.Position = UDim2.new(0, 0, 0, 90)
speedSliderBg.BackgroundColor3 = Color3.fromRGB(45,45,60)
speedSliderBg.BorderSizePixel = 0
speedSliderBg.ZIndex = 22
Instance.new("UICorner", speedSliderBg).CornerRadius = UDim.new(1, 0)

local speedFill = Instance.new("Frame", speedSliderBg)
speedFill.Size = UDim2.new(0.03, 0, 1, 0)
speedFill.BackgroundColor3 = state.success
speedFill.BorderSizePixel = 0
speedFill.ZIndex = 23
Instance.new("UICorner", speedFill).CornerRadius = UDim.new(1, 0)

local speedKnob = Instance.new("Frame", speedSliderBg)
speedKnob.Size = UDim2.new(0, 26, 0, 26)
speedKnob.Position = UDim2.new(0.03, -13, 0.5, -13)
speedKnob.BackgroundColor3 = Color3.new(1,1,1)
speedKnob.BorderSizePixel = 0
speedKnob.ZIndex = 24
Instance.new("UICorner", speedKnob).CornerRadius = UDim.new(1, 0)
local speedKnobStroke = Instance.new("UIStroke", speedKnob)
speedKnobStroke.Color = state.success
speedKnobStroke.Thickness = 3

local updateSpeedValue
local speedQuick = Instance.new("Frame", speedContent)
speedQuick.Size = UDim2.new(1, 0, 0, 90)
speedQuick.Position = UDim2.new(0, 0, 0, 130)
speedQuick.BackgroundTransparency = 1
speedQuick.ZIndex = 25

for i,v in ipairs({16,50,100,200}) do
    local b = Instance.new("TextButton", speedQuick)
    b.Size = UDim2.new(0, 78, 0, 40)
    b.Position = UDim2.new(0, (i-1)*86, 0, 0)
    b.BackgroundColor3 = state.bg2
    b.TextColor3 = state.text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = tostring(v)
    b.ZIndex = 30
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() updateSpeedValue(v) end)
end

updateSpeedValue = function(v)
    state.speedValue = v
    speedValueLabel.Text = tostring(v)
    local p = math.clamp((v-10)/190, 0, 1)
    speedFill.Size = UDim2.new(p, 0, 1, 0)
    speedKnob.Position = UDim2.new(p, -13, 0.5, -13)
end

local forceBtn = Instance.new("TextButton", speedContent)
forceBtn.Size = UDim2.new(1, 0, 0, 40)
forceBtn.Position = UDim2.new(0, 0, 0, 180)
forceBtn.BackgroundColor3 = state.success
forceBtn.TextColor3 = Color3.new(1,1,1)
forceBtn.Font = Enum.Font.GothamBold
forceBtn.TextScaled = true
forceBtn.Text = L("force_on")
forceBtn.ZIndex = 25
forceBtn.AutoButtonColor = false
Instance.new("UICorner", forceBtn).CornerRadius = UDim.new(0, 8)

-- ================== ВКЛАДКА "ИГРОК" ==================
local playerTitle = Instance.new("TextLabel", playerContent)
playerTitle.Size = UDim2.new(1, 0, 0, 24)
playerTitle.Position = UDim2.new(0, 0, 0, 5)
playerTitle.BackgroundTransparency = 1
playerTitle.Text = L("player_title")
playerTitle.TextColor3 = state.subtext
playerTitle.Font = Enum.Font.GothamBold
playerTitle.TextScaled = true
playerTitle.TextXAlignment = Enum.TextXAlignment.Left
playerTitle.ZIndex = 22

local playerScroll = Instance.new("ScrollingFrame", playerContent)
playerScroll.Size = UDim2.new(1, 0, 1, -35)
playerScroll.Position = UDim2.new(0, 0, 0, 35)
playerScroll.BackgroundTransparency = 1
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 4
playerScroll.ScrollBarImageColor3 = state.accent
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 1200)
playerScroll.ZIndex = 25

local playerLayout = Instance.new("UIListLayout", playerScroll)
playerLayout.Padding = UDim.new(0, 8)
playerLayout.SortOrder = Enum.SortOrder.LayoutOrder

local playerBtnKeys = {}

local function makePlayerBtn(key, onClick)
    local b = Instance.new("TextButton", playerScroll)
    b.Size = UDim2.new(1, -8, 0, 42)
    b.BackgroundColor3 = state.bg2
    b.TextColor3 = state.text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = L(key) .. L("off")
    b.ZIndex = 30
    b.AutoButtonColor = false
    b.Active = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() onClick(b) end)
    table.insert(playerBtnKeys, {btn = b, key = key, flag = nil})
    return b
end

-- Утилита для регистрации флага
local function regFlag(btn, key, flagName)
    for _, e in ipairs(playerBtnKeys) do
        if e.btn == btn then e.flag = flagName e.key = key break end
    end
end

local b1 = makePlayerBtn("noclip", function(btn)
    flags.noclip = not flags.noclip
    btn.Text = L("noclip") .. (flags.noclip and L("on") or L("off"))
    btn.BackgroundColor3 = flags.noclip and state.success or state.bg2
end) regFlag(b1, "noclip", "noclip")

local b2 = makePlayerBtn("no_gravity", function(btn)
    flags.noGravity = not flags.noGravity
    btn.Text = L("no_gravity") .. (flags.noGravity and L("on") or L("off"))
    btn.BackgroundColor3 = flags.noGravity and state.success or state.bg2
end) regFlag(b2, "no_gravity", "noGravity")

local b3 = makePlayerBtn("hover", function(btn)
    flags.hover = not flags.hover
    btn.Text = L("hover") .. (flags.hover and L("on") or L("off"))
    btn.BackgroundColor3 = flags.hover and state.success or state.bg2
end) regFlag(b3, "hover", "hover")

local b4 = makePlayerBtn("inf_jump", function(btn)
    flags.infJump = not flags.infJump
    btn.Text = L("inf_jump") .. (flags.infJump and L("on") or L("off"))
    btn.BackgroundColor3 = flags.infJump and state.success or state.bg2
end) regFlag(b4, "inf_jump", "infJump")

local b5 = makePlayerBtn("auto_jump", function(btn)
    flags.autoJump = not flags.autoJump
    btn.Text = L("auto_jump") .. (flags.autoJump and L("on") or L("off"))
    btn.BackgroundColor3 = flags.autoJump and state.success or state.bg2
end) regFlag(b5, "auto_jump", "autoJump")

local b6 = makePlayerBtn("high_jump", function(btn)
    flags.highJump = not flags.highJump
    btn.Text = L("high_jump") .. (flags.highJump and L("on") or L("off"))
    btn.BackgroundColor3 = flags.highJump and state.success or state.bg2
end) regFlag(b6, "high_jump", "highJump")

local b7 = makePlayerBtn("moon_jump", function(btn)
    flags.moonJump = not flags.moonJump
    btn.Text = L("moon_jump") .. (flags.moonJump and L("on") or L("off"))
    btn.BackgroundColor3 = flags.moonJump and state.success or state.bg2
end) regFlag(b7, "moon_jump", "moonJump")

local b8 = makePlayerBtn("water_walk", function(btn)
    flags.walkOnWater = not flags.walkOnWater
    btn.Text = L("water_walk") .. (flags.walkOnWater and L("on") or L("off"))
    btn.BackgroundColor3 = flags.walkOnWater and state.success or state.bg2
end) regFlag(b8, "water_walk", "walkOnWater")

local b9 = makePlayerBtn("ghost", function(btn)
    flags.ghostMode = not flags.ghostMode
    btn.Text = L("ghost") .. (flags.ghostMode and L("on") or L("off"))
    btn.BackgroundColor3 = flags.ghostMode and state.success or state.bg2
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.Transparency = flags.ghostMode and 0.5 or 0 end)
            end
        end
    end
end) regFlag(b9, "ghost", "ghostMode")

local b10 = makePlayerBtn("spin", function(btn)
    flags.spin = not flags.spin
    btn.Text = L("spin") .. (flags.spin and L("on") or L("off"))
    btn.BackgroundColor3 = flags.spin and state.success or state.bg2
end) regFlag(b10, "spin", "spin")

local b11 = makePlayerBtn("tiny", function(btn)
    flags.tinyChar = not flags.tinyChar
    btn.Text = L("tiny") .. (flags.tinyChar and L("on") or L("off"))
    btn.BackgroundColor3 = flags.tinyChar and state.success or state.bg2
    local char = player.Character
    if char then
        local sc = flags.tinyChar and 0.5 or 1
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                pcall(function()
                    if not part:GetAttribute("origSize") then
                        part:SetAttribute("origSize", part.Size)
                    end
                    part.Size = part:GetAttribute("origSize") * sc
                end)
            end
        end
    end
end) regFlag(b11, "tiny", "tinyChar")

local b12 = makePlayerBtn("rainbow", function(btn)
    flags.rainbowChar = not flags.rainbowChar
    btn.Text = L("rainbow") .. (flags.rainbowChar and L("on") or L("off"))
    btn.BackgroundColor3 = flags.rainbowChar and state.success or state.bg2
end) regFlag(b12, "rainbow", "rainbowChar")

local b13 = makePlayerBtn("auto_heal", function(btn)
    flags.autoHeal = not flags.autoHeal
    btn.Text = L("auto_heal") .. (flags.autoHeal and L("on") or L("off"))
    btn.BackgroundColor3 = flags.autoHeal and state.success or state.bg2
end) regFlag(b13, "auto_heal", "autoHeal")

local b14 = makePlayerBtn("stamina", function(btn)
    flags.infStamina = not flags.infStamina
    btn.Text = L("stamina") .. (flags.infStamina and L("on") or L("off"))
    btn.BackgroundColor3 = flags.infStamina and state.success or state.bg2
end) regFlag(b14, "stamina", "infStamina")

local b15 = makePlayerBtn("anti_afk", function(btn)
    flags.antiAFK = not flags.antiAFK
    btn.Text = L("anti_afk") .. (flags.antiAFK and L("on") or L("off"))
    btn.BackgroundColor3 = flags.antiAFK and state.success or state.bg2
end) regFlag(b15, "anti_afk", "antiAFK")

local b16 = makePlayerBtn("fullbright", function(btn)
    flags.fullBright = not flags.fullBright
    btn.Text = L("fullbright") .. (flags.fullBright and L("on") or L("off"))
    btn.BackgroundColor3 = flags.fullBright and state.success or state.bg2
    local lighting = game:GetService("Lighting")
    if flags.fullBright then
        lighting.Ambient = Color3.fromRGB(255,255,255)
        lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        lighting.Brightness = 2
    else
        lighting.Ambient = Color3.fromRGB(70,70,70)
        lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        lighting.Brightness = 1
    end
end) regFlag(b16, "fullbright", "fullBright")

local b17 = makePlayerBtn("fast_fall", function(btn)
    flags.fastFall = not flags.fastFall
    btn.Text = L("fast_fall") .. (flags.fastFall and L("on") or L("off"))
    btn.BackgroundColor3 = flags.fastFall and state.success or state.bg2
end) regFlag(b17, "fast_fall", "fastFall")

local b18 = makePlayerBtn("zoom", function(btn)
    flags.cameraZoom = not flags.cameraZoom
    btn.Text = L("zoom") .. (flags.cameraZoom and L("on") or L("off"))
    btn.BackgroundColor3 = flags.cameraZoom and state.success or state.bg2
    workspace.CurrentCamera.FieldOfView = flags.cameraZoom and 120 or 70
end) regFlag(b18, "zoom", "cameraZoom")

local b19 = makePlayerBtn("fire", function(btn)
    flags.fireAura = not flags.fireAura
    btn.Text = L("fire") .. (flags.fireAura and L("on") or L("off"))
    btn.BackgroundColor3 = flags.fireAura and state.success or state.bg2
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local fire = hrp:FindFirstChild("AuraFire")
            if flags.fireAura and not fire then
                fire = Instance.new("Fire", hrp)
                fire.Name = "AuraFire"
                fire.Size = 5
            elseif not flags.fireAura and fire then
                fire:Destroy()
            end
        end
    end
end) regFlag(b19, "fire", "fireAura")

local b20 = makePlayerBtn("sparkles", function(btn)
    flags.sparklesAura = not flags.sparklesAura
    btn.Text = L("sparkles") .. (flags.sparklesAura and L("on") or L("off"))
    btn.BackgroundColor3 = flags.sparklesAura and state.success or state.bg2
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local sp = hrp:FindFirstChild("AuraSparkles")
            if flags.sparklesAura and not sp then
                sp = Instance.new("Sparkles", hrp)
                sp.Name = "AuraSparkles"
            elseif not flags.sparklesAura and sp then
                sp:Destroy()
            end
        end
    end
end) regFlag(b20, "sparkles", "sparklesAura")

-- Телепорты (без флага)
makePlayerBtn("tp_up", function() 
    local c = player.Character
    if c then
        local h = c:FindFirstChild("HumanoidRootPart")
        if h then h.CFrame = h.CFrame + Vector3.new(0,50,0) end
    end
end)

makePlayerBtn("tp_down", function()
    local c = player.Character
    if c then
        local h = c:FindFirstChild("HumanoidRootPart")
        if h then h.CFrame = h.CFrame - Vector3.new(0,50,0) end
    end
end)

makePlayerBtn("tp_spawn", function()
    local c = player.Character
    if c then
        local h = c:FindFirstChild("HumanoidRootPart")
        local sp = workspace:FindFirstChildOfClass("SpawnLocation")
        if h and sp then h.CFrame = sp.CFrame + Vector3.new(0,5,0) end
    end
end)

makePlayerBtn("respawn", function()
    local c = player.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)

makePlayerBtn("disable_all", function()
    for k in pairs(flags) do flags[k] = false end
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            hum.Gravity = 196.2
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CanCollide = true
                    part.Transparency = 0
                    if part:GetAttribute("origSize") then
                        part.Size = part:GetAttribute("origSize")
                    end
                end)
                for _, child in ipairs(part:GetChildren()) do
                    if child.Name == "AuraFire" or child.Name == "AuraSparkles" then
                        child:Destroy()
                    end
                end
            end
        end
    end
    workspace.CurrentCamera.FieldOfView = 70
    for _, btn in ipairs(playerScroll:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.BackgroundColor3 = state.bg2
            for _, e in ipairs(playerBtnKeys) do
                if e.btn == btn then
                    btn.Text = L(e.key) .. L("off")
                end
            end
        end
    end
end)

playerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerLayout.AbsoluteContentSize.Y + 10)
end)

-- ================== ВКЛАДКА "ФИШКИ" ==================
local extraTitle = Instance.new("TextLabel", extraContent)
extraTitle.Size = UDim2.new(1, 0, 0, 24)
extraTitle.Position = UDim2.new(0, 0, 0, 5)
extraTitle.BackgroundTransparency = 1
extraTitle.Text = L("extra_title")
extraTitle.TextColor3 = state.subtext
extraTitle.Font = Enum.Font.GothamBold
extraTitle.TextScaled = true
extraTitle.TextXAlignment = Enum.TextXAlignment.Left
extraTitle.ZIndex = 22

local extraScroll = Instance.new("ScrollingFrame", extraContent)
extraScroll.Size = UDim2.new(1, 0, 1, -35)
extraScroll.Position = UDim2.new(0, 0, 0, 35)
extraScroll.BackgroundTransparency = 1
extraScroll.BorderSizePixel = 0
extraScroll.ScrollBarThickness = 4
extraScroll.ScrollBarImageColor3 = state.accent
extraScroll.CanvasSize = UDim2.new(0, 0, 0, 400)
extraScroll.ZIndex = 25

local extraLayout = Instance.new("UIListLayout", extraScroll)
extraLayout.Padding = UDim.new(0, 8)
extraLayout.SortOrder = Enum.SortOrder.LayoutOrder

local extraBtnKeys = {}

local function makeExtraBtn(key, onClick)
    local b = Instance.new("TextButton", extraScroll)
    b.Size = UDim2.new(1, -8, 0, 42)
    b.BackgroundColor3 = state.bg2
    b.TextColor3 = state.text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = L(key) .. L("off")
    b.ZIndex = 30
    b.AutoButtonColor = false
    b.Active = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() onClick(b) end)
    table.insert(extraBtnKeys, {btn = b, key = key})
    return b
end

makeExtraBtn("esp", function(btn)
    flags.esp = not flags.esp
    btn.Text = L("esp") .. (flags.esp and L("on") or L("off"))
    btn.BackgroundColor3 = flags.esp and state.success or state.bg2
end)

makeExtraBtn("follow", function(btn)
    flags.lookAtPlayer = not flags.lookAtPlayer
    btn.Text = L("follow") .. (flags.lookAtPlayer and L("on") or L("off"))
    btn.BackgroundColor3 = flags.lookAtPlayer and state.success or state.bg2
    if flags.lookAtPlayer then
        local targets = {}
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= player and p.Character then table.insert(targets, p) end
        end
        if #targets > 0 then _G.__camTarget = targets[math.random(1,#targets)] end
    else
        _G.__camTarget = nil
    end
end)

makeExtraBtn("tp_player", function()
    refreshPlayerList("")
    searchBox.Text = ""
    tpPanel.Visible = true
end)

extraLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    extraScroll.CanvasSize = UDim2.new(0, 0, 0, extraLayout.AbsoluteContentSize.Y + 10)
end)

-- ================== МЕНЮ ТЕЛЕПОРТА ==================
local tpPanel = Instance.new("Frame", sg)
tpPanel.Size = UDim2.new(0, 320, 0, 420)
tpPanel.Position = UDim2.new(0.5, -160, 0.5, -210)
tpPanel.BackgroundColor3 = state.bg
tpPanel.BorderSizePixel = 0
tpPanel.Visible = false
tpPanel.ZIndex = 100
tpPanel.Active = true
Instance.new("UICorner", tpPanel).CornerRadius = UDim.new(0, 16)
local tpStroke = Instance.new("UIStroke", tpPanel)
tpStroke.Color = state.accent
tpStroke.Thickness = 1.5
tpStroke.Transparency = 0.3

local tpHeader = Instance.new("Frame", tpPanel)
tpHeader.Size = UDim2.new(1, 0, 0, 45)
tpHeader.BackgroundTransparency = 1
tpHeader.ZIndex = 101

local tpTitle = Instance.new("TextLabel", tpHeader)
tpTitle.Size = UDim2.new(1, -60, 1, 0)
tpTitle.Position = UDim2.new(0, 15, 0, 0)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = L("tp_title")
tpTitle.TextColor3 = state.text
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextScaled = true
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.ZIndex = 102

local tpClose = Instance.new("TextButton", tpHeader)
tpClose.Size = UDim2.new(0, 30, 0, 30)
tpClose.Position = UDim2.new(1, -40, 0.5, -15)
tpClose.BackgroundColor3 = state.danger
tpClose.TextColor3 = Color3.new(1,1,1)
tpClose.Font = Enum.Font.GothamBold
tpClose.TextScaled = true
tpClose.Text = "✕"
tpClose.ZIndex = 102
tpClose.AutoButtonColor = false
Instance.new("UICorner", tpClose).CornerRadius = UDim.new(1, 0)

local searchBox = Instance.new("TextBox", tpPanel)
searchBox.Size = UDim2.new(1, -30, 0, 36)
searchBox.Position = UDim2.new(0, 15, 0, 55)
searchBox.BackgroundColor3 = state.bg2
searchBox.TextColor3 = state.text
searchBox.PlaceholderText = L("search")
searchBox.PlaceholderColor3 = state.subtext
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 16
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 102
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

local playerList = Instance.new("ScrollingFrame", tpPanel)
playerList.Size = UDim2.new(1, -30, 1, -150)
playerList.Position = UDim2.new(0, 15, 0, 100)
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.ScrollBarImageColor3 = state.accent
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ZIndex = 101

local listLayout = Instance.new("UIListLayout", playerList)
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

function refreshPlayerList(filter)
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    filter = string.lower(filter or "")
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player then
            if filter == "" or string.find(string.lower(p.Name), filter, 1, true) then
                local btn = Instance.new("TextButton", playerList)
                btn.Size = UDim2.new(1, -8, 0, 38)
                btn.BackgroundColor3 = state.bg2
                btn.TextColor3 = state.text
                btn.Font = Enum.Font.GothamBold
                btn.TextScaled = true
                btn.Text = "👤 " .. p.Name
                btn.ZIndex = 102
                btn.AutoButtonColor = false
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
                btn.MouseButton1Click:Connect(function()
                    teleportToPlayer(p)
                    tpPanel.Visible = false
                end)
            end
        end
    end
    task.wait(0.05)
    playerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    refreshPlayerList(searchBox.Text)
end)

tpClose.MouseButton1Click:Connect(function() tpPanel.Visible = false end)

-- ================== ВКЛАДКА "СТИЛЬ" ==================
local styleTitle = Instance.new("TextLabel", styleContent)
styleTitle.Size = UDim2.new(1, 0, 0, 24)
styleTitle.Position = UDim2.new(0, 0, 0, 5)
styleTitle.BackgroundTransparency = 1
styleTitle.Text = L("style_title")
styleTitle.TextColor3 = state.subtext
styleTitle.Font = Enum.Font.GothamBold
styleTitle.TextScaled = true
styleTitle.TextXAlignment = Enum.TextXAlignment.Left
styleTitle.ZIndex = 22

local colorPresets = {
    {name="Синий / Blue", a=Color3.fromRGB(120,160,255), b=Color3.fromRGB(200,100,255)},
    {name="Красный / Red", a=Color3.fromRGB(255,80,80), b=Color3.fromRGB(255,150,50)},
    {name="Зелёный / Green", a=Color3.fromRGB(80,220,130), b=Color3.fromRGB(50,200,180)},
    {name="Розовый / Pink", a=Color3.fromRGB(255,100,200), b=Color3.fromRGB(255,150,180)},
    {name="Золотой / Gold", a=Color3.fromRGB(255,200,50), b=Color3.fromRGB(255,150,20)},
    {name="Белый / White", a=Color3.fromRGB(230,230,240), b=Color3.fromRGB(180,180,200)},
}

local colorFrame = Instance.new("Frame", styleContent)
colorFrame.Size = UDim2.new(1, 0, 0, 100)
colorFrame.Position = UDim2.new(0, 0, 0, 35)
colorFrame.BackgroundTransparency = 1
colorFrame.ZIndex = 25

local langButtons = {}

local function applyColors(a, b)
    state.accent = a
    state.accent2 = b
    openBtn.BackgroundColor3 = a
    openStroke.Color = b
    panelStroke.Color = a
    topStroke.Color = a
    sliderFill.BackgroundColor3 = a
    knobStroke.Color = a
    bigValue.TextColor3 = a
    for _, tab in pairs(tabButtons) do
        if tab.BackgroundColor3 ~= state.bg2 then tab.BackgroundColor3 = a end
    end
    for k, lb in pairs(langButtons) do
        if k == currentLang then lb.BackgroundColor3 = a end
    end
end

for i, preset in ipairs(colorPresets) do
    local col = (i-1) % 3
    local row = math.floor((i-1) / 3)
    local b = Instance.new("TextButton", colorFrame)
    b.Size = UDim2.new(0, 118, 0, 42)
    b.Position = UDim2.new(0, col*125, 0, row*50)
    b.BackgroundColor3 = preset.a
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = preset.name
    b.ZIndex = 30
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local g = Instance.new("UIGradient", b)
    g.Color = ColorSequence.new(preset.a, preset.b)
    g.Rotation = 45
    b.MouseButton1Click:Connect(function() applyColors(preset.a, preset.b) end)
end

-- Язык
local langTitle = Instance.new("TextLabel", styleContent)
langTitle.Size = UDim2.new(1, 0, 0, 24)
langTitle.Position = UDim2.new(0, 0, 0, 145)
langTitle.BackgroundTransparency = 1
langTitle.Text = L("lang_title")
langTitle.TextColor3 = state.subtext
langTitle.Font = Enum.Font.GothamBold
langTitle.TextScaled = true
langTitle.TextXAlignment = Enum.TextXAlignment.Left
langTitle.ZIndex = 22

local langFrame = Instance.new("Frame", styleContent)
langFrame.Size = UDim2.new(1, 0, 0, 50)
langFrame.Position = UDim2.new(0, 0, 0, 175)
langFrame.BackgroundTransparency = 1
langFrame.ZIndex = 25

local function refreshAllText()
    -- Заголовки и вкладки
    headerTitle.Text = L("header")
    for n, key in pairs(tabKeys) do
        tabButtons[n].Text = L(key)
    end
    bigSub.Text = L("current_weight")
    speedTitle.Text = L("speed_title")
    playerTitle.Text = L("player_title")
    extraTitle.Text = L("extra_title")
    styleTitle.Text = L("style_title")
    langTitle.Text = L("lang_title")
    tpTitle.Text = L("tp_title")
    searchBox.PlaceholderText = L("search")
    topText.Text = L("top_weight") .. formatWeight(state.weight)
    topToggle.Text = state.topBarVisible and L("hide_top") or L("show_top")
    resetAll.Text = L("reset")
    forceBtn.Text = state.forceSpeed and L("force_on") or L("force_off")
    -- Кнопки фишек игрока
    for _, e in ipairs(playerBtnKeys) do
        local stateOn = e.flag and flags[e.flag]
        e.btn.Text = L(e.key) .. (stateOn and L("on") or L("off"))
    end
    -- Кнопки фишек extra
    for _, e in ipairs(extraBtnKeys) do
        local flagName = ({esp="esp", follow="lookAtPlayer"})[e.key]
        local stateOn = flagName and flags[flagName]
        e.btn.Text = L(e.key) .. (stateOn and L("on") or L("off"))
    end
    -- Языковые кнопки
    for k, lb in pairs(langButtons) do
        lb.BackgroundColor3 = (k == currentLang) and state.accent or state.bg2
        lb.TextColor3 = (k == currentLang) and Color3.new(1,1,1) or state.text
    end
end

local function setLang(lang)
    currentLang = lang
    refreshAllText()
end

local function makeLangBtn(text, lang, x)
    local b = Instance.new("TextButton", langFrame)
    b.Size = UDim2.new(0, 120, 0, 42)
    b.Position = UDim2.new(0, x, 0, 0)
    b.BackgroundColor3 = state.bg2
    b.TextColor3 = state.text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = text
    b.ZIndex = 30
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() setLang(lang) end)
    langButtons[lang] = b
end

makeLangBtn("🇷🇺 Русский", "ru", 0)
makeLangBtn("🇬🇧 English", "en", 130)

langButtons["ru"].BackgroundColor3 = state.accent
langButtons["ru"].TextColor3 = Color3.new(1,1,1)

-- ================== НИЖНИЕ КНОПКИ ==================
local bottomFrame = Instance.new("Frame", panel)
bottomFrame.Size = UDim2.new(1, -20, 0, 40)
bottomFrame.Position = UDim2.new(0, 10, 1, -50)
bottomFrame.BackgroundTransparency = 1
bottomFrame.ZIndex = 25

local topToggle, resetAll

local function makeBottomBtn(text, xP, xW, color, callback)
    local b = Instance.new("TextButton", bottomFrame)
    b.Size = UDim2.new(xW, 0, 1, 0)
    b.Position = UDim2.new(xP, 0, 0, 0)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = text
    b.ZIndex = 26
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
    return b
end

topToggle = makeBottomBtn(L("hide_top"), 0, 0.48, Color3.fromRGB(60,90,160), function()
    state.topBarVisible = not state.topBarVisible
    topBar.Visible = state.topBarVisible
    topToggle.Text = state.topBarVisible and L("hide_top") or L("show_top")
end)

resetAll = makeBottomBtn(L("reset"), 0.52, 0.48, state.danger, function()
    if setSliderFromWeight then setSliderFromWeight(100) end
    if updateSpeedValue then updateSpeedValue(16) end
end)

-- ================== ПОЛЗУНКИ ==================
local function percentToWeight(p)
    if p >= 0.999 then return math.huge end
    return 1 + (p*p*p*1e12)
end
local function weightToPercent(w)
    if w == math.huge then return 1 end
    local p = ((w-1)/1e12)^(1/3)
    return math.clamp(p, 0, 1)
end

setSliderFromWeight = function(weight)
    local p = weightToPercent(weight)
    sliderFill.Size = UDim2.new(p, 0, 1, 0)
    knob.Position = UDim2.new(p, -13, 0.5, -13)
    bigValue.Text = formatWeight(weight)
    if state.topBarVisible then
        topText.Text = L("top_weight") .. formatWeight(weight)
    end
    applyWeight(weight)
end

local function updateSlider(percent)
    percent = math.clamp(percent, 0, 1)
    local value = percentToWeight(percent)
    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
    knob.Position = UDim2.new(percent, -13, 0.5, -13)
    bigValue.Text = formatWeight(value)
    if state.topBarVisible then
        topText.Text = L("top_weight") .. formatWeight(value)
    end
    applyWeight(value)
end

local function updateSpeedSlider(percent)
    percent = math.clamp(percent, 0, 1)
    local value = math.floor(10 + percent*190)
    speedFill.Size = UDim2.new(percent, 0, 1, 0)
    speedKnob.Position = UDim2.new(percent, -13, 0.5, -13)
    updateSpeedValue(value)
end

local function getPercentFromX(x, slider)
    return (x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
end

local activeDrag = nil
local function bindSlider(slider, knobEl, callback)
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = {slider = slider, callback = callback}
            callback(getPercentFromX(input.Position.X, slider))
        end
    end)
    knobEl.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            activeDrag = {slider = slider, callback = callback}
        end
    end)
end

bindSlider(sliderBg, knob, updateSlider)
bindSlider(speedSliderBg, speedKnob, updateSpeedSlider)

UserInputService.InputChanged:Connect(function(input)
    if activeDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        activeDrag.callback(getPercentFromX(input.Position.X, activeDrag.slider))
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        activeDrag = nil
    end
end)

-- ================== ЦИКЛЫ ФИШЕК ==================
task.spawn(function()
    while true do
        if flags.noclip then
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        if flags.noGravity then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.Gravity = 0 end) end
            end
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        if flags.autoJump then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.Jump = true end) end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if flags.highJump then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.UseJumpPower = true hum.JumpPower = 150 end) end
            end
        end
        task.wait(0.3)
    end
end)

task.spawn(function()
    while true do
        if flags.moonJump then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum.UseJumpPower = true hum.JumpPower = 200 hum.Gravity = 50 end) end
            end
        end
        task.wait(0.3)
    end
end)

task.spawn(function()
    while true do
        if flags.hover then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bf = hrp:FindFirstChild("HoverForce")
                    if not bf then
                        bf = Instance.new("BodyForce", hrp)
                        bf.Name = "HoverForce"
                    end
                    bf.Force = Vector3.new(0, workspace.Gravity * hrp:GetMass(), 0)
                end
            end
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        if flags.fastFall then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        local v = hrp.Velocity
                        if v.Y < 0 then hrp.Velocity = Vector3.new(v.X, v.Y*2, v.Z) end
                    end)
                end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if flags.spin then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function() hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(15), 0) end)
                end
            end
        end
        task.wait(0.03)
    end
end)

task.spawn(function()
    local hue = 0
    while true do
        if flags.rainbowChar then
            local char = player.Character
            if char then
                hue = (hue + 0.02) % 1
                local color = Color3.fromHSV(hue, 1, 1)
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then pcall(function() part.Color = color end) end
                end
            end
        end
        task.wait(0.05)
    end
end)

task.spawn(function()
    while true do
        if flags.autoHeal then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health < hum.MaxHealth then
                    pcall(function() hum.Health = hum.MaxHealth end)
                end
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        if flags.infStamina then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function()
                        if hum:FindFirstChild("Stamina") then
                            hum.Stamina.Value = hum.Stamina.MaxValue
                        end
                    end)
                end
            end
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    while true do
        if flags.antiAFK then
            local vu = game:GetService("VirtualUser")
            pcall(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end)
        end
        task.wait(60)
    end
end)

task.spawn(function()
    while true do
        if flags.walkOnWater then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local ray = Ray.new(hrp.Position, Vector3.new(0,-10,0))
                    local part = workspace:FindPartOnRay(ray, char)
                    if part and part.Material == Enum.Material.Water then
                        pcall(function() hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.3, 0) end)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if flags.esp then
            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                if p ~= player and p.Character then
                    local hl = p.Character:FindFirstChildOfClass("Highlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Parent = p.Character
                        hl.FillColor = Color3.fromRGB(255,0,0)
                        hl.OutlineColor = Color3.fromRGB(255,255,255)
                        hl.FillTransparency = 0.5
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                end
            end
        else
            for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
                if p.Character then
                    local hl = p.Character:FindFirstChildOfClass("Highlight")
                    if hl then hl:Destroy() end
                end
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if flags.lookAtPlayer and _G.__camTarget and _G.__camTarget.Character then
            local hrp = _G.__camTarget.Character:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if hrp then cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position) end
        end
        task.wait(0.1)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if flags.infJump then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
        end
    end
end)

-- ================== КНОПКА СКОРОСТИ ==================
forceBtn.MouseButton1Click:Connect(function()
    state.forceSpeed = not state.forceSpeed
    forceBtn.Text = state.forceSpeed and L("force_on") or L("force_off")
    forceBtn.BackgroundColor3 = state.forceSpeed and state.success or Color3.fromRGB(120,120,120)
end)

-- ================== ОТКРЫТИЕ/ЗАКРЫТИЕ ==================
local function openMenu()
    state.menuOpen = true
    panel.Visible = true
    panel.Size = UDim2.new(0, 360, 0, 490)
    panel.BackgroundTransparency = 1
    TweenService:Create(panel, TweenInfo.new(CONFIG.ANIM_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 540),
        BackgroundTransparency = state.menuTransparency,
    }):Play()
    openBtn.Text = "✕"
    openBtn.BackgroundColor3 = state.danger
end
local function closeMenu()
    state.menuOpen = false
    local t = TweenService:Create(panel, TweenInfo.new(CONFIG.ANIM_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 360, 0, 490),
        BackgroundTransparency = 1,
    })
    t:Play()
    t.Completed:Connect(function() panel.Visible = false end)
    openBtn.Text = "⚖"
    openBtn.BackgroundColor3 = state.accent
end
openBtn.MouseButton1Click:Connect(function()
    if state.menuOpen then closeMenu() else openMenu() end
end)
closeBtn.MouseButton1Click:Connect(closeMenu)

-- ================== ПЕРЕТАСКИВАНИЕ ==================
local dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = nil
    end
end)

-- ================== АВТОПРИМЕНЕНИЕ ==================
player.CharacterAdded:Connect(function()
    task.wait(1)
    if flags.autoReset then
        state.weight = 100
        if setSliderFromWeight then setSliderFromWeight(100) end
    end
    applyWeight(state.weight)
end)

setSliderFromWeight(100)
updateSpeedValue(16)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚖ Weight v205",
        Text = "RU / EN | 5 вкладок",
        Duration = 3
    })
end)
