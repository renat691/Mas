-- ============================================
-- ⚖ WEIGHT CONTROL v208 — STABLE
-- Музыка и профиль через pcall (не ломают скрипт)
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local CONFIG = { DEFAULT_WEIGHT = 100, ANIM_SPEED = 0.25 }

local state = {
    weight = CONFIG.DEFAULT_WEIGHT,
    menuOpen = false,
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
    menuTransparency = 0.05,
    activeTab = "main",
}

-- ================== ПРОВЕРКА ФУНКЦИЙ ==================
local HAS_WRITE = pcall(function() return writefile ~= nil end)
local HAS_ASSET_API = pcall(function()
    return game:GetService("AssetService") ~= nil
end)

-- ================== ЛОКАЛИЗАЦИЯ ==================
local LOCALES = {
    ru = {
        header="⚖ WEIGHT ULTIMATE", tab_weight="ВЕС", tab_speed="СКОР",
        tab_player="ИГРОК", tab_extra="ФИШКИ", tab_teleport="ТП",
        tab_effects="ЭФФ", tab_profile="ПРОФ", tab_music="МУЗ", tab_style="СТИЛЬ",
        current_weight="ТЕКУЩИЙ ВЕС", top_weight="⚖ ВЕС: ",
        speed_title="🏃 СКОРОСТЬ БЕГА", player_title="👤 УПРАВЛЕНИЕ",
        extra_title="✨ ФИШКИ", style_title="🎨 ЦВЕТА",
        lang_title="🌍 ЯЗЫК", tp_title="📍 ТЕЛЕПОРТ",
        effects_title="✨ ЭФФЕКТЫ", profile_title="💾 ПРОФИЛЬ",
        music_title="🎵 МУЗЫКА",
        search="🔍 Поиск по нику...", music_search="🔍 Поиск трека...",
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
        tp_down="⬇ Телепорт вниз (-50)", respawn="💀 Респавн",
        disable_all="🛑 Выключить ВСЕ",
        esp="👁 ESP игроков", follow="👀 Следить за игроком",
        xray="🔦 X-Ray", speed_hack="💨 Спидхак",
        jump_hack="🦵 Джампхак", headless="👤 Headless",
        big_head="🗿 Большая голова", long_neck="🦒 Длинная шея",
        floating="🎈 Парение", freeze="❄ Заморозка",
        neon_body="💡 Неоновое тело", auto_dance="💃 Авто-танец",
        auto_punch="👊 Авто-удар",
        matrix="🟢 Matrix", fire_trail="🔥 Огненный след",
        sparkle_trail="✨ След из искр", rainbow_trail="🌈 Радужный след",
        kick_all="🦵 Оттолкнуть всех", grab_all="🫳 Притянуть всех",
        snow="❄ Снег", rain="🌧 Дождь", lightning="⚡ Молния",
        explosion="💥 Взрыв", portal="🌀 Портал", tornado="🌪 Торнадо",
        blackhole="🕳 Чёрная дыра", fireworks="🎆 Фейерверк",
        laser="🔴 Лазер", forcefield="🛡 Силовое поле",
        beam="📡 Луч", shockwave="💫 Ударная волна", disco="🕺 Диско",
        save_profile="💾 СОХРАНИТЬ", load_profile="📂 ЗАГРУЗИТЬ",
        reset_profile="🔄 СБРОСИТЬ", my_profiles="📁 Мои профили",
        music_stop="⏹ Стоп", music_volume="Громкость",
        music_loading="Поиск...", music_none="Музыка недоступна на клиенте",
        save_ok="✅ Сохранено", save_err="❌ Ошибка",
        load_err="❌ Не найдено",
    },
    en = {
        header="⚖ WEIGHT ULTIMATE", tab_weight="WEIGHT", tab_speed="SPEED",
        tab_player="PLAYER", tab_extra="FEATURES", tab_teleport="TP",
        tab_effects="FX", tab_profile="PROFILE", tab_music="MUSIC", tab_style="STYLE",
        current_weight="CURRENT WEIGHT", top_weight="⚖ WEIGHT: ",
        speed_title="🏃 WALK SPEED", player_title="👤 CONTROL",
        extra_title="✨ FEATURES", style_title="🎨 COLORS",
        lang_title="🌍 LANGUAGE", tp_title="📍 TELEPORT",
        effects_title="✨ EFFECTS", profile_title="💾 PROFILE",
        music_title="🎵 MUSIC",
        search="🔍 Search by name...", music_search="🔍 Search track...",
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
        tp_down="⬇ Teleport Down (-50)", respawn="💀 Respawn",
        disable_all="🛑 Disable ALL",
        esp="👁 Player ESP", follow="👀 Follow Player",
        xray="🔦 X-Ray", speed_hack="💨 Speed hack",
        jump_hack="🦵 Jump hack", headless="👤 Headless",
        big_head="🗿 Big Head", long_neck="🦒 Long Neck",
        floating="🎈 Floating", freeze="❄ Freeze",
        neon_body="💡 Neon Body", auto_dance="💃 Auto Dance",
        auto_punch="👊 Auto Punch",
        matrix="🟢 Matrix", fire_trail="🔥 Fire Trail",
        sparkle_trail="✨ Sparkle Trail", rainbow_trail="🌈 Rainbow Trail",
        kick_all="🦵 Kick All", grab_all="🫳 Grab All",
        snow="❄ Snow", rain="🌧 Rain", lightning="⚡ Lightning",
        explosion="💥 Explosion", portal="🌀 Portal", tornado="🌪 Tornado",
        blackhole="🕳 Black Hole", fireworks="🎆 Fireworks",
        laser="🔴 Laser", forcefield="🛡 Forcefield",
        beam="📡 Beam", shockwave="💫 Shockwave", disco="🕺 Disco",
        save_profile="💾 SAVE", load_profile="📂 LOAD",
        reset_profile="🔄 RESET", my_profiles="📁 My profiles",
        music_stop="⏹ Stop", music_volume="Volume",
        music_loading="Searching...", music_none="Music not available on client",
        save_ok="✅ Saved", save_err="❌ Error",
        load_err="❌ Not found",
    }
}
local currentLang = "ru"
local function L(key)
    local loc = LOCALES[currentLang] or LOCALES.ru
    return loc[key] or key
end

-- ================== ФЛАГИ ==================
local flags = {
    autoJump=false, infJump=false, autoReset=false, noclip=false,
    antiAFK=false, walkOnWater=false, noGravity=false, fullBright=false,
    spin=false, tinyChar=false, rainbowChar=false, highJump=false,
    esp=false, autoHeal=false, infStamina=false, hover=false,
    moonJump=false, fastFall=false, cameraZoom=false, fireAura=false,
    sparklesAura=false, lookAtPlayer=false, ghostMode=false,
    xray=false, speedHack=false, jumpHack=false, headless=false,
    floating=false, freeze=false, matrix=false,
    fireTrail=false, sparkleTrail=false, neonBody=false, rainbowTrail=false,
    autoDance=false, bigHead=false, longNeck=false, autoPunch=false,
}
local effectFlags = {
    snow=false, rain=false, lightning=false, explosion=false,
    portal=false, tornado=false, blackhole=false, fireworks=false,
    laser=false, forcefield=false, beam=false, shockwave=false, disco=false,
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
    if not targetPlayer then return end
    local char = player.Character
    if not char then return end
    local myHrp = char:FindFirstChild("HumanoidRootPart")
    local myHum = char:FindFirstChildOfClass("Humanoid")
    local tries = 0
    while (not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart")) and tries < 10 do
        task.wait(0.1)
        tries = tries + 1
    end
    if not targetPlayer.Character then return end
    local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHrp or not myHrp then return end
    for i = 1, 3 do
        pcall(function()
            myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
            myHrp.Velocity = Vector3.zero
        end)
        task.wait(0.05)
    end
    if myHum then
        pcall(function() myHum:MoveTo(targetHrp.Position + Vector3.new(0, 3, 0)) end)
    end
end

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

-- ================== UI ==================
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
panel.Size = UDim2.new(0, 420, 0, 580)
panel.Position = UDim2.new(0.5, -210, 0.5, -290)
panel.BackgroundColor3 = state.bg
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 20
panel.ClipsDescendants = true
panel.Active = true
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 18)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Color = state.accent
panelStroke.Thickness = 2
panelStroke.Transparency = 0.2

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
tabsFrame.Size = UDim2.new(1, -20, 0, 30)
tabsFrame.Position = UDim2.new(0, 10, 0, 48)
tabsFrame.BackgroundColor3 = state.bg2
tabsFrame.BorderSizePixel = 0
tabsFrame.ZIndex = 21
Instance.new("UICorner", tabsFrame).CornerRadius = UDim.new(0, 8)

local tabsLayout = Instance.new("UIListLayout", tabsFrame)
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabsLayout.Padding = UDim.new(0, 2)

local tabButtons = {}
local contentFrames = {}
local tabKeys = {}

local function createTab(name, key, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 42, 0, 24)
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
    f.Size = UDim2.new(1, -20, 1, -140)
    f.Position = UDim2.new(0, 10, 0, 84)
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
createTab("teleport","tab_teleport",5)
createTab("effects","tab_effects",6)
createTab("profile","tab_profile",7)
createTab("music","tab_music",8)
createTab("style","tab_style",9)

local mainContent = createContent("main")
local speedContent = createContent("speed")
local playerContent = createContent("player")
local extraContent = createContent("extra")
local teleportContent = createContent("teleport")
local effectsContent = createContent("effects")
local profileContent = createContent("profile")
local musicContent = createContent("music")
local styleContent = createContent("style")

tabButtons["main"].BackgroundColor3 = state.accent
tabButtons["main"].TextColor3 = Color3.new(1,1,1)
mainContent.Visible = true

-- ================== ВЕС ==================
local card = Instance.new("Frame", mainContent)
card.Size = UDim2.new(1, 0, 0, 70)
card.Position = UDim2.new(0, 0, 0, 5)
card.BackgroundColor3 = state.bg2
card.BorderSizePixel = 0
card.ZIndex = 22
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

local bigValue = Instance.new("TextLabel", card)
bigValue.Size = UDim2.new(1, -20, 0, 45)
bigValue.Position = UDim2.new(0, 10, 0, 5)
bigValue.BackgroundTransparency = 1
bigValue.Text = formatWeight(state.weight)
bigValue.TextColor3 = state.accent
bigValue.Font = Enum.Font.GothamBold
bigValue.TextScaled = true
bigValue.ZIndex = 23

local bigSub = Instance.new("TextLabel", card)
bigSub.Size = UDim2.new(1, -20, 0, 18)
bigSub.Position = UDim2.new(0, 10, 0, 50)
bigSub.BackgroundTransparency = 1
bigSub.Text = L("current_weight")
bigSub.TextColor3 = state.subtext
bigSub.Font = Enum.Font.Gotham
bigSub.TextScaled = true
bigSub.ZIndex = 23

local sliderBg = Instance.new("Frame", mainContent)
sliderBg.Size = UDim2.new(1, 0, 0, 14)
sliderBg.Position = UDim2.new(0, 0, 0, 90)
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
quickFrame.Position = UDim2.new(0, 0, 0, 120)
quickFrame.BackgroundTransparency = 1
quickFrame.ZIndex = 25

local setSliderFromWeight
local BW, BH, GX, GY = 84, 42, 8, 10

local function makeQuickBtn(text, weight, col, row)
    local b = Instance.new("TextButton", quickFrame)
    b.Size = UDim2.new(0, BW, 0, BH)
    b.Position = UDim2.new(0, col*(BW+GX), 0, row*(BH+GY))
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

-- ================== СКОРОСТЬ ==================
local speedTitle = Instance.new("TextLabel", speedContent)
speedTitle.Size = UDim2.new(1, 0, 0, 24)
speedTitle.Position = UDim2.new(0, 0, 0, 5)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = L("speed_title")
speedTitle.TextColor3 = state.subtext
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextScaled = true
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 22

local speedValueLabel = Instance.new("TextLabel", speedContent)
speedValueLabel.Size = UDim2.new(1, 0, 0, 40)
speedValueLabel.Position = UDim2.new(0, 0, 0, 35)
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Text = tostring(state.speedValue)
speedValueLabel.TextColor3 = state.success
speedValueLabel.Font = Enum.Font.GothamBold
speedValueLabel.TextScaled = true
speedValueLabel.ZIndex = 22

local speedSliderBg = Instance.new("Frame", speedContent)
speedSliderBg.Size = UDim2.new(1, 0, 0, 14)
speedSliderBg.Position = UDim2.new(0, 0, 0, 85)
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
speedQuick.Position = UDim2.new(0, 0, 0, 125)
speedQuick.BackgroundTransparency = 1
speedQuick.ZIndex = 25

for i,v in ipairs({16,50,100,200}) do
    local b = Instance.new("TextButton", speedQuick)
    b.Size = UDim2.new(0, 84, 0, 40)
    b.Position = UDim2.new(0, (i-1)*92, 0, 0)
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
forceBtn.Position = UDim2.new(0, 0, 0, 175)
forceBtn.BackgroundColor3 = state.success
forceBtn.TextColor3 = Color3.new(1,1,1)
forceBtn.Font = Enum.Font.GothamBold
forceBtn.TextScaled = true
forceBtn.Text = L("force_on")
forceBtn.ZIndex = 25
forceBtn.AutoButtonColor = false
Instance.new("UICorner", forceBtn).CornerRadius = UDim.new(0, 8)

-- ================== ИГРОК ==================
local playerTitle = Instance.new("TextLabel", playerContent)
playerTitle.Size = UDim2.new(1, 0, 0, 20)
playerTitle.Position = UDim2.new(0, 0, 0, 5)
playerTitle.BackgroundTransparency = 1
playerTitle.Text = L("player_title")
playerTitle.TextColor3 = state.subtext
playerTitle.Font = Enum.Font.GothamBold
playerTitle.TextScaled = true
playerTitle.TextXAlignment = Enum.TextXAlignment.Left
playerTitle.ZIndex = 22

local playerScroll = Instance.new("ScrollingFrame", playerContent)
playerScroll.Size = UDim2.new(1, 0, 1, -30)
playerScroll.Position = UDim2.new(0, 0, 0, 30)
playerScroll.BackgroundTransparency = 1
playerScroll.BorderSizePixel = 0
playerScroll.ScrollBarThickness = 4
playerScroll.ScrollBarImageColor3 = state.accent
playerScroll.CanvasSize = UDim2.new(0, 0, 0, 2000)
playerScroll.ZIndex = 25

local playerLayout = Instance.new("UIListLayout", playerScroll)
playerLayout.Padding = UDim.new(0, 6)

local playerBtnKeys = {}

local function makePlayerBtn(key, flagName, onClick)
    local b = Instance.new("TextButton", playerScroll)
    b.Size = UDim2.new(1, -8, 0, 38)
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
    table.insert(playerBtnKeys, {btn = b, key = key, flag = flagName})
    return b
end

local function toggleFlag(flagName)
    return function(btn)
        flags[flagName] = not flags[flagName]
        btn.Text = L(flagName) .. (flags[flagName] and L("on") or L("off"))
        btn.BackgroundColor3 = flags[flagName] and state.success or state.bg2
    end
end

makePlayerBtn("noclip", "noclip", toggleFlag("noclip"))
makePlayerBtn("no_gravity", "noGravity", toggleFlag("noGravity"))
makePlayerBtn("hover", "hover", toggleFlag("hover"))
makePlayerBtn("inf_jump", "infJump", toggleFlag("infJump"))
makePlayerBtn("auto_jump", "autoJump", toggleFlag("autoJump"))
makePlayerBtn("high_jump", "highJump", toggleFlag("highJump"))
makePlayerBtn("moon_jump", "moonJump", toggleFlag("moonJump"))
makePlayerBtn("water_walk", "walkOnWater", toggleFlag("walkOnWater"))
makePlayerBtn("ghost", "ghostMode", function(btn)
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
end)
makePlayerBtn("spin", "spin", toggleFlag("spin"))
makePlayerBtn("tiny", "tinyChar", function(btn)
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
end)
makePlayerBtn("rainbow", "rainbowChar", toggleFlag("rainbowChar"))
makePlayerBtn("auto_heal", "autoHeal", toggleFlag("autoHeal"))
makePlayerBtn("stamina", "infStamina", toggleFlag("infStamina"))
makePlayerBtn("anti_afk", "antiAFK", toggleFlag("antiAFK"))
makePlayerBtn("fullbright", "fullBright", function(btn)
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
end)
makePlayerBtn("fast_fall", "fastFall", toggleFlag("fastFall"))
makePlayerBtn("zoom", "cameraZoom", function(btn)
    flags.cameraZoom = not flags.cameraZoom
    btn.Text = L("zoom") .. (flags.cameraZoom and L("on") or L("off"))
    btn.BackgroundColor3 = flags.cameraZoom and state.success or state.bg2
    workspace.CurrentCamera.FieldOfView = flags.cameraZoom and 120 or 70
end)
makePlayerBtn("fire", "fireAura", toggleFlag("fireAura"))
makePlayerBtn("sparkles", "sparklesAura", toggleFlag("sparklesAura"))
makePlayerBtn("floating", "floating", toggleFlag("floating"))
makePlayerBtn("freeze", "freeze", toggleFlag("freeze"))
makePlayerBtn("auto_punch", "autoPunch", toggleFlag("autoPunch"))
makePlayerBtn("tp_up", nil, function()
    local c = player.Character
    if c then
        local h = c:FindFirstChild("HumanoidRootPart")
        if h then h.CFrame = h.CFrame + Vector3.new(0,50,0) end
    end
end)
makePlayerBtn("tp_down", nil, function()
    local c = player.Character
    if c then
        local h = c:FindFirstChild("HumanoidRootPart")
        if h then h.CFrame = h.CFrame - Vector3.new(0,50,0) end
    end
end)
makePlayerBtn("respawn", nil, function()
    local c = player.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.Health = 0 end
    end
end)
makePlayerBtn("disable_all", nil, function()
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
    for _, e in ipairs(playerBtnKeys) do
        e.btn.BackgroundColor3 = state.bg2
        if e.flag then
            e.btn.Text = L(e.key) .. L("off")
        end
    end
end)

playerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerLayout.AbsoluteContentSize.Y + 10)
end)

-- ================== ФИШКИ ==================
local extraTitle = Instance.new("TextLabel", extraContent)
extraTitle.Size = UDim2.new(1, 0, 0, 20)
extraTitle.Position = UDim2.new(0, 0, 0, 5)
extraTitle.BackgroundTransparency = 1
extraTitle.Text = L("extra_title")
extraTitle.TextColor3 = state.subtext
extraTitle.Font = Enum.Font.GothamBold
extraTitle.TextScaled = true
extraTitle.TextXAlignment = Enum.TextXAlignment.Left
extraTitle.ZIndex = 22

local extraScroll = Instance.new("ScrollingFrame", extraContent)
extraScroll.Size = UDim2.new(1, 0, 1, -30)
extraScroll.Position = UDim2.new(0, 0, 0, 30)
extraScroll.BackgroundTransparency = 1
extraScroll.BorderSizePixel = 0
extraScroll.ScrollBarThickness = 4
extraScroll.ScrollBarImageColor3 = state.accent
extraScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
extraScroll.ZIndex = 25

local extraLayout = Instance.new("UIListLayout", extraScroll)
extraLayout.Padding = UDim.new(0, 6)

local extraBtnKeys = {}

local function makeExtraBtn(key, flagName, onClick)
    local b = Instance.new("TextButton", extraScroll)
    b.Size = UDim2.new(1, -8, 0, 38)
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
    table.insert(extraBtnKeys, {btn = b, key = key, flag = flagName})
    return b
end

makeExtraBtn("esp", "esp", toggleFlag("esp"))
makeExtraBtn("follow", "lookAtPlayer", toggleFlag("lookAtPlayer"))
makeExtraBtn("xray", "xray", toggleFlag("xray"))
makeExtraBtn("speed_hack", "speedHack", toggleFlag("speedHack"))
makeExtraBtn("jump_hack", "jumpHack", toggleFlag("jumpHack"))
makeExtraBtn("matrix", "matrix", toggleFlag("matrix"))
makeExtraBtn("fire_trail", "fireTrail", toggleFlag("fireTrail"))
makeExtraBtn("sparkle_trail", "sparkleTrail", toggleFlag("sparkleTrail"))
makeExtraBtn("rainbow_trail", "rainbowTrail", toggleFlag("rainbowTrail"))
makeExtraBtn("kick_all", nil, function()
    local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - myHrp.Position).Magnitude < 50 then
                pcall(function()
                    local dir = (hrp.Position - myHrp.Position).Unit
                    hrp.Velocity = dir * 200 + Vector3.new(0, 100, 0)
                end)
            end
        end
    end
end)
makeExtraBtn("grab_all", nil, function()
    local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - myHrp.Position).Magnitude < 100 then
                pcall(function()
                    local dir = (myHrp.Position - hrp.Position).Unit
                    hrp.Velocity = dir * 150
                end)
            end
        end
    end
end)

extraLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    extraScroll.CanvasSize = UDim2.new(0, 0, 0, extraLayout.AbsoluteContentSize.Y + 10)
end)

-- ================== ТЕЛЕПОРТ ==================
local tpTitleContent = Instance.new("TextLabel", teleportContent)
tpTitleContent.Size = UDim2.new(1, 0, 0, 20)
tpTitleContent.Position = UDim2.new(0, 0, 0, 5)
tpTitleContent.BackgroundTransparency = 1
tpTitleContent.Text = L("tp_title")
tpTitleContent.TextColor3 = state.subtext
tpTitleContent.Font = Enum.Font.GothamBold
tpTitleContent.TextScaled = true
tpTitleContent.TextXAlignment = Enum.TextXAlignment.Left
tpTitleContent.ZIndex = 22

local searchBox = Instance.new("TextBox", teleportContent)
searchBox.Size = UDim2.new(1, 0, 0, 34)
searchBox.Position = UDim2.new(0, 0, 0, 30)
searchBox.BackgroundColor3 = state.bg2
searchBox.TextColor3 = state.text
searchBox.PlaceholderText = L("search")
searchBox.PlaceholderColor3 = state.subtext
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 25
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

local playerList = Instance.new("ScrollingFrame", teleportContent)
playerList.Size = UDim2.new(1, 0, 1, -75)
playerList.Position = UDim2.new(0, 0, 0, 72)
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.ScrollBarImageColor3 = state.accent
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ZIndex = 25

local listLayout = Instance.new("UIListLayout", playerList)
listLayout.Padding = UDim.new(0, 6)

local function refreshPlayerList(filter)
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    filter = string.lower(filter or "")
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            if filter == "" or string.find(string.lower(p.Name), filter, 1, true) then
                local btn = Instance.new("TextButton", playerList)
                btn.Size = UDim2.new(1, -8, 0, 38)
                btn.BackgroundColor3 = state.bg2
                btn.TextColor3 = state.text
                btn.Font = Enum.Font.GothamBold
                btn.TextScaled = true
                btn.Text = "👤 " .. p.Name
                btn.ZIndex = 30
                btn.AutoButtonColor = false
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
                btn.MouseButton1Click:Connect(function()
                    teleportToPlayer(p)
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

Players.PlayerAdded:Connect(function() task.wait(0.5) refreshPlayerList(searchBox.Text) end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) refreshPlayerList(searchBox.Text) end)

refreshPlayerList("")

-- ================== ЭФФЕКТЫ ==================
local effectsTitle = Instance.new("TextLabel", effectsContent)
effectsTitle.Size = UDim2.new(1, 0, 0, 20)
effectsTitle.Position = UDim2.new(0, 0, 0, 5)
effectsTitle.BackgroundTransparency = 1
effectsTitle.Text = L("effects_title")
effectsTitle.TextColor3 = state.subtext
effectsTitle.Font = Enum.Font.GothamBold
effectsTitle.TextScaled = true
effectsTitle.TextXAlignment = Enum.TextXAlignment.Left
effectsTitle.ZIndex = 22

local effectsScroll = Instance.new("ScrollingFrame", effectsContent)
effectsScroll.Size = UDim2.new(1, 0, 1, -30)
effectsScroll.Position = UDim2.new(0, 0, 0, 30)
effectsScroll.BackgroundTransparency = 1
effectsScroll.BorderSizePixel = 0
effectsScroll.ScrollBarThickness = 4
effectsScroll.ScrollBarImageColor3 = state.accent
effectsScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
effectsScroll.ZIndex = 25

local effectsLayout = Instance.new("UIListLayout", effectsScroll)
effectsLayout.Padding = UDim.new(0, 6)

local function makeEffectBtn(key, onClick)
    local b = Instance.new("TextButton", effectsScroll)
    b.Size = UDim2.new(1, -8, 0, 38)
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
    return b
end

makeEffectBtn("snow", function(btn)
    effectFlags.snow = not effectFlags.snow
    btn.Text = L("snow") .. (effectFlags.snow and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.snow and state.success or state.bg2
end)
makeEffectBtn("rain", function(btn)
    effectFlags.rain = not effectFlags.rain
    btn.Text = L("rain") .. (effectFlags.rain and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.rain and state.success or state.bg2
end)
makeEffectBtn("lightning", function(btn)
    effectFlags.lightning = not effectFlags.lightning
    btn.Text = L("lightning") .. (effectFlags.lightning and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.lightning and state.success or state.bg2
end)
makeEffectBtn("explosion", function(btn)
    effectFlags.explosion = not effectFlags.explosion
    btn.Text = L("explosion") .. (effectFlags.explosion and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.explosion and state.success or state.bg2
end)
makeEffectBtn("portal", function(btn)
    effectFlags.portal = not effectFlags.portal
    btn.Text = L("portal") .. (effectFlags.portal and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.portal and state.success or state.bg2
end)
makeEffectBtn("tornado", function(btn)
    effectFlags.tornado = not effectFlags.tornado
    btn.Text = L("tornado") .. (effectFlags.tornado and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.tornado and state.success or state.bg2
end)
makeEffectBtn("blackhole", function(btn)
    effectFlags.blackhole = not effectFlags.blackhole
    btn.Text = L("blackhole") .. (effectFlags.blackhole and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.blackhole and state.success or state.bg2
end)
makeEffectBtn("fireworks", function(btn)
    effectFlags.fireworks = not effectFlags.fireworks
    btn.Text = L("fireworks") .. (effectFlags.fireworks and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.fireworks and state.success or state.bg2
end)
makeEffectBtn("laser", function(btn)
    effectFlags.laser = not effectFlags.laser
    btn.Text = L("laser") .. (effectFlags.laser and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.laser and state.success or state.bg2
end)
makeEffectBtn("forcefield", function(btn)
    effectFlags.forcefield = not effectFlags.forcefield
    btn.Text = L("forcefield") .. (effectFlags.forcefield and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.forcefield and state.success or state.bg2
end)
makeEffectBtn("beam", function(btn)
    effectFlags.beam = not effectFlags.beam
    btn.Text = L("beam") .. (effectFlags.beam and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.beam and state.success or state.bg2
end)
makeEffectBtn("shockwave", function(btn)
    effectFlags.shockwave = not effectFlags.shockwave
    btn.Text = L("shockwave") .. (effectFlags.shockwave and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.shockwave and state.success or state.bg2
end)
makeEffectBtn("disco", function(btn)
    effectFlags.disco = not effectFlags.disco
    btn.Text = L("disco") .. (effectFlags.disco and L("on") or L("off"))
    btn.BackgroundColor3 = effectFlags.disco and state.success or state.bg2
end)

effectsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    effectsScroll.CanvasSize = UDim2.new(0, 0, 0, effectsLayout.AbsoluteContentSize.Y + 10)
end)

-- ================== ПРОФИЛЬ (безопасный) ==================
local profileTitle = Instance.new("TextLabel", profileContent)
profileTitle.Size = UDim2.new(1, 0, 0, 20)
profileTitle.Position = UDim2.new(0, 0, 0, 5)
profileTitle.BackgroundTransparency = 1
profileTitle.Text = L("profile_title")
profileTitle.TextColor3 = state.subtext
profileTitle.Font = Enum.Font.GothamBold
profileTitle.TextScaled = true
profileTitle.TextXAlignment = Enum.TextXAlignment.Left
profileTitle.ZIndex = 22

local profileStatus = Instance.new("TextLabel", profileContent)
profileStatus.Size = UDim2.new(1, 0, 0, 18)
profileStatus.Position = UDim2.new(0, 0, 0, 28)
profileStatus.BackgroundTransparency = 1
profileStatus.Text = HAS_WRITE and "" or "⚠ writefile недоступен"
profileStatus.TextColor3 = state.subtext
profileStatus.Font = Enum.Font.Gotham
profileStatus.TextScaled = true
profileStatus.TextXAlignment = Enum.TextXAlignment.Left
profileStatus.ZIndex = 22

local saveBtn = Instance.new("TextButton", profileContent)
saveBtn.Size = UDim2.new(1, 0, 0, 40)
saveBtn.Position = UDim2.new(0, 0, 0, 50)
saveBtn.BackgroundColor3 = state.success
saveBtn.TextColor3 = Color3.new(1,1,1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextScaled = true
saveBtn.Text = L("save_profile")
saveBtn.ZIndex = 25
saveBtn.AutoButtonColor = false
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)

local loadBtn = Instance.new("TextButton", profileContent)
loadBtn.Size = UDim2.new(1, 0, 0, 40)
loadBtn.Position = UDim2.new(0, 0, 0, 98)
loadBtn.BackgroundColor3 = state.accent
loadBtn.TextColor3 = Color3.new(1,1,1)
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextScaled = true
loadBtn.Text = L("load_profile")
loadBtn.ZIndex = 25
loadBtn.AutoButtonColor = false
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 8)

local resetProfileBtn = Instance.new("TextButton", profileContent)
resetProfileBtn.Size = UDim2.new(1, 0, 0, 40)
resetProfileBtn.Position = UDim2.new(0, 0, 0, 146)
resetProfileBtn.BackgroundColor3 = state.danger
resetProfileBtn.TextColor3 = Color3.new(1,1,1)
resetProfileBtn.Font = Enum.Font.GothamBold
resetProfileBtn.TextScaled = true
resetProfileBtn.Text = L("reset_profile")
resetProfileBtn.ZIndex = 25
resetProfileBtn.AutoButtonColor = false
Instance.new("UICorner", resetProfileBtn).CornerRadius = UDim.new(0, 8)

local PROFILE_FILE = "weight_profile.json"

saveBtn.MouseButton1Click:Connect(function()
    if not HAS_WRITE then
        profileStatus.Text = "❌ writefile недоступен"
        return
    end
    local data = {
        weight = state.weight, speed = state.speedValue,
        forceSpeed = state.forceSpeed, topBarVisible = state.topBarVisible,
        lang = currentLang, flags = flags,
    }
    local ok = pcall(function() writefile(PROFILE_FILE, HttpService:JSONEncode(data)) end)
    profileStatus.Text = ok and L("save_ok") or L("save_err")
    task.delay(2, function() profileStatus.Text = "" end)
end)

loadBtn.MouseButton1Click:Connect(function()
    if not HAS_WRITE then
        profileStatus.Text = "❌ writefile недоступен"
        return
    end
    local ok, content = pcall(function() return readfile(PROFILE_FILE) end)
    if ok and content then
        local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
        if ok2 and data then
            if data.weight then state.weight = data.weight if setSliderFromWeight then setSliderFromWeight(data.weight) end end
            if data.speed then state.speedValue = data.speed if updateSpeedValue then updateSpeedValue(data.speed) end end
            if data.lang then currentLang = data.lang refreshAllText() end
            if data.flags then for k, v in pairs(data.flags) do if flags[k] ~= nil then flags[k] = v end end end
            profileStatus.Text = "✅ OK"
        end
    else
        profileStatus.Text = L("load_err")
    end
    task.delay(2, function() profileStatus.Text = "" end)
end)

resetProfileBtn.MouseButton1Click:Connect(function()
    if HAS_WRITE then pcall(function() delfile(PROFILE_FILE) end) end
    state.weight = 100
    state.speedValue = 16
    state.forceSpeed = true
    currentLang = "ru"
    for k in pairs(flags) do flags[k] = false end
    if setSliderFromWeight then setSliderFromWeight(100) end
    if updateSpeedValue then updateSpeedValue(16) end
    refreshAllText()
    profileStatus.Text = "✅ Reset"
    task.delay(2, function() profileStatus.Text = "" end)
end)

-- ================== МУЗЫКА (безопасная) ==================
local musicTitle = Instance.new("TextLabel", musicContent)
musicTitle.Size = UDim2.new(1, 0, 0, 20)
musicTitle.Position = UDim2.new(0, 0, 0, 5)
musicTitle.BackgroundTransparency = 1
musicTitle.Text = L("music_title")
musicTitle.TextColor3 = state.subtext
musicTitle.Font = Enum.Font.GothamBold
musicTitle.TextScaled = true
musicTitle.TextXAlignment = Enum.TextXAlignment.Left
musicTitle.ZIndex = 22

local musicSearchBox = Instance.new("TextBox", musicContent)
musicSearchBox.Size = UDim2.new(1, 0, 0, 34)
musicSearchBox.Position = UDim2.new(0, 0, 0, 30)
musicSearchBox.BackgroundColor3 = state.bg2
musicSearchBox.TextColor3 = state.text
musicSearchBox.PlaceholderText = L("music_search")
musicSearchBox.PlaceholderColor3 = state.subtext
musicSearchBox.Font = Enum.Font.Gotham
musicSearchBox.TextSize = 14
musicSearchBox.Text = ""
musicSearchBox.ClearTextOnFocus = false
musicSearchBox.ZIndex = 25
Instance.new("UICorner", musicSearchBox).CornerRadius = UDim.new(0, 8)

local musicStatus = Instance.new("TextLabel", musicContent)
musicStatus.Size = UDim2.new(1, 0, 0, 18)
musicStatus.Position = UDim2.new(0, 0, 0, 68)
musicStatus.BackgroundTransparency = 1
musicStatus.Text = HAS_ASSET_API and "" or "⚠ Asset API недоступен"
musicStatus.TextColor3 = state.subtext
musicStatus.Font = Enum.Font.Gotham
musicStatus.TextScaled = true
musicStatus.TextXAlignment = Enum.TextXAlignment.Left
musicStatus.ZIndex = 22

local musicResults = Instance.new("ScrollingFrame", musicContent)
musicResults.Size = UDim2.new(1, 0, 1, -180)
musicResults.Position = UDim2.new(0, 0, 0, 90)
musicResults.BackgroundTransparency = 1
musicResults.BorderSizePixel = 0
musicResults.ScrollBarThickness = 4
musicResults.ScrollBarImageColor3 = state.accent
musicResults.CanvasSize = UDim2.new(0, 0, 0, 0)
musicResults.ZIndex = 25

local musicListLayout = Instance.new("UIListLayout", musicResults)
musicListLayout.Padding = UDim.new(0, 6)

local stopMusicBtn = Instance.new("TextButton", musicContent)
stopMusicBtn.Size = UDim2.new(1, 0, 0, 40)
stopMusicBtn.Position = UDim2.new(0, 0, 1, -50)
stopMusicBtn.BackgroundColor3 = state.danger
stopMusicBtn.TextColor3 = Color3.new(1,1,1)
stopMusicBtn.Font = Enum.Font.GothamBold
stopMusicBtn.TextScaled = true
stopMusicBtn.Text = L("music_stop")
stopMusicBtn.ZIndex = 26
stopMusicBtn.AutoButtonColor = false
Instance.new("UICorner", stopMusicBtn).CornerRadius = UDim.new(0, 8)

local currentSound = nil
local function stopMusic()
    if currentSound then
        pcall(function() currentSound:Stop() currentSound:Destroy() end)
        currentSound = nil
    end
end
stopMusicBtn.MouseButton1Click:Connect(stopMusic)

local function searchMusic(query)
    for _, child in ipairs(musicResults:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    if query == "" then musicStatus.Text = "" return end
    if not HAS_ASSET_API then
        musicStatus.Text = "⚠ Asset API недоступен в Delta"
        return
    end
    musicStatus.Text = L("music_loading")

    local ok, result = pcall(function()
        local params = Instance.new("AudioSearchParams")
        params.SearchKeyword = query
        params.AudioSubType = Enum.AudioSubType.Music
        return game:GetService("AssetService"):SearchAudioAsync(params)
    end)

    if not ok or not result then
        musicStatus.Text = "❌ Ошибка поиска"
        return
    end

    musicStatus.Text = ""
    local page = result:GetCurrentPage()

    for _, audio in ipairs(page) do
        local btn = Instance.new("TextButton", musicResults)
        btn.Size = UDim2.new(1, -8, 0, 44)
        btn.BackgroundColor3 = state.bg2
        btn.TextColor3 = state.text
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.Text = "🎵 " .. (audio.Title or "?") .. " — " .. (audio.Artist or "?")
        btn.ZIndex = 30
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(function()
            stopMusic()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(audio.Id)
            sound.Volume = 0.5
            sound.Parent = game:GetService("SoundService")
            sound:Play()
            currentSound = sound
        end)
    end

    if #page == 0 then musicStatus.Text = "Ничего не найдено" end
    task.wait(0.05)
    musicResults.CanvasSize = UDim2.new(0, 0, 0, musicListLayout.AbsoluteContentSize.Y + 10)
end

local searchDebounce = nil
musicSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if searchDebounce then task.cancel(searchDebounce) end
    searchDebounce = task.delay(0.6, function() searchMusic(musicSearchBox.Text) end)
end)

-- ================== СТИЛЬ ==================
local styleTitle = Instance.new("TextLabel", styleContent)
styleTitle.Size = UDim2.new(1, 0, 0, 20)
styleTitle.Position = UDim2.new(0, 0, 0, 5)
styleTitle.BackgroundTransparency = 1
styleTitle.Text = L("style_title")
styleTitle.TextColor3 = state.subtext
styleTitle.Font = Enum.Font.GothamBold
styleTitle.TextScaled = true
styleTitle.TextXAlignment = Enum.TextXAlignment.Left
styleTitle.ZIndex = 22

local colorPresets = {
    {name="Синий", a=Color3.fromRGB(120,160,255), b=Color3.fromRGB(200,100,255)},
    {name="Красный", a=Color3.fromRGB(255,80,80), b=Color3.fromRGB(255,150,50)},
    {name="Зелёный", a=Color3.fromRGB(80,220,130), b=Color3.fromRGB(50,200,180)},
    {name="Розовый", a=Color3.fromRGB(255,100,200), b=Color3.fromRGB(255,150,180)},
    {name="Золотой", a=Color3.fromRGB(255,200,50), b=Color3.fromRGB(255,150,20)},
    {name="Белый", a=Color3.fromRGB(230,230,240), b=Color3.fromRGB(180,180,200)},
}

local colorFrame = Instance.new("Frame", styleContent)
colorFrame.Size = UDim2.new(1, 0, 0, 100)
colorFrame.Position = UDim2.new(0, 0, 0, 30)
colorFrame.BackgroundTransparency = 1
colorFrame.ZIndex = 25

local langButtons = {}

for i, preset in ipairs(colorPresets) do
    local col = (i-1) % 3
    local row = math.floor((i-1) / 3)
    local b = Instance.new("TextButton", colorFrame)
    b.Size = UDim2.new(0, 128, 0, 42)
    b.Position = UDim2.new(0, col*135, 0, row*50)
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
    b.MouseButton1Click:Connect(function()
        state.accent = preset.a
        state.accent2 = preset.b
        openBtn.BackgroundColor3 = preset.a
        openStroke.Color = preset.b
        panelStroke.Color = preset.a
        topStroke.Color = preset.a
        sliderFill.BackgroundColor3 = preset.a
        knobStroke.Color = preset.a
        bigValue.TextColor3 = preset.a
        for _, tab in pairs(tabButtons) do
            if tab.BackgroundColor3 ~= state.bg2 then tab.BackgroundColor3 = preset.a end
        end
    end)
end

local langTitle = Instance.new("TextLabel", styleContent)
langTitle.Size = UDim2.new(1, 0, 0, 20)
langTitle.Position = UDim2.new(0, 0, 0, 140)
langTitle.BackgroundTransparency = 1
langTitle.Text = L("lang_title")
langTitle.TextColor3 = state.subtext
langTitle.Font = Enum.Font.GothamBold
langTitle.TextScaled = true
langTitle.TextXAlignment = Enum.TextXAlignment.Left
langTitle.ZIndex = 22

local langFrame = Instance.new("Frame", styleContent)
langFrame.Size = UDim2.new(1, 0, 0, 50)
langFrame.Position = UDim2.new(0, 0, 0, 165)
langFrame.BackgroundTransparency = 1
langFrame.ZIndex = 25

local function refreshAllText()
    headerTitle.Text = L("header")
    for n, key in pairs(tabKeys) do tabButtons[n].Text = L(key) end
    bigSub.Text = L("current_weight")
    speedTitle.Text = L("speed_title")
    playerTitle.Text = L("player_title")
    extraTitle.Text = L("extra_title")
    styleTitle.Text = L("style_title")
    langTitle.Text = L("lang_title")
    tpTitleContent.Text = L("tp_title")
    effectsTitle.Text = L("effects_title")
    profileTitle.Text = L("profile_title")
    musicTitle.Text = L("music_title")
    searchBox.PlaceholderText = L("search")
    musicSearchBox.PlaceholderText = L("music_search")
    stopMusicBtn.Text = L("music_stop")
    topText.Text = L("top_weight") .. formatWeight(state.weight)
    if topToggle then topToggle.Text = state.topBarVisible and L("hide_top") or L("show_top") end
    if resetAll then resetAll.Text = L("reset") end
    forceBtn.Text = state.forceSpeed and L("force_on") or L("force_off")
    saveBtn.Text = L("save_profile")
    loadBtn.Text = L("load_profile")
    resetProfileBtn.Text = L("reset_profile")
    for _, e in ipairs(playerBtnKeys) do
        if e.flag then
            e.btn.Text = L(e.key) .. (flags[e.flag] and L("on") or L("off"))
        else
            e.btn.Text = L(e.key)
        end
    end
    for _, e in ipairs(extraBtnKeys) do
        if e.flag then
            e.btn.Text = L(e.key) .. (flags[e.flag] and L("on") or L("off"))
        else
            e.btn.Text = L(e.key)
        end
    end
    for k, lb in pairs(langButtons) do
        lb.BackgroundColor3 = (k == currentLang) and state.accent or state.bg2
        lb.TextColor3 = (k == currentLang) and Color3.new(1,1,1) or state.text
    end
end

local function makeLangBtn(text, lang, x)
    local b = Instance.new("TextButton", langFrame)
    b.Size = UDim2.new(0, 128, 0, 42)
    b.Position = UDim2.new(0, x, 0, 0)
    b.BackgroundColor3 = state.bg2
    b.TextColor3 = state.text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Text = text
    b.ZIndex = 30
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        currentLang = lang
        refreshAllText()
    end)
    langButtons[lang] = b
end

makeLangBtn("🇷🇺 Русский", "ru", 0)
makeLangBtn("🇬🇧 English", "en", 138)

langButtons["ru"].BackgroundColor3 = state.accent
langButtons["ru"].TextColor3 = Color3.new(1,1,1)

-- ================== НИЖНИЕ КНОПКИ ==================
local bottomFrame = Instance.new("Frame", panel)
bottomFrame.Size = UDim2.new(1, -20, 0, 36)
bottomFrame.Position = UDim2.new(0, 10, 1, -46)
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

-- ================== ЦИКЛЫ ==================
task.spawn(function() while true do if flags.noclip then local c = player.Character if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then pcall(function() p.CanCollide = false end) end end end end task.wait(0.2) end end)
task.spawn(function() while true do if flags.noGravity then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.Gravity = 0 end) end end end task.wait(0.2) end end)
task.spawn(function() while true do if flags.autoJump then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.Jump = true end) end end end task.wait(0.1) end end)
task.spawn(function() while true do if flags.highJump then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.UseJumpPower = true h.JumpPower = 150 end) end end end task.wait(0.3) end end)
task.spawn(function() while true do if flags.moonJump then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.UseJumpPower = true h.JumpPower = 200 h.Gravity = 50 end) end end end task.wait(0.3) end end)
task.spawn(function() while true do if flags.hover then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local b = h:FindFirstChild("HF") if not b then b = Instance.new("BodyForce", h) b.Name = "HF" end b.Force = Vector3.new(0, workspace.Gravity * h:GetMass(), 0) end end end task.wait(0.2) end end)
task.spawn(function() while true do if flags.fastFall then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then pcall(function() local v = h.Velocity if v.Y < 0 then h.Velocity = Vector3.new(v.X, v.Y*2, v.Z) end end) end end end task.wait(0.1) end end)
task.spawn(function() while true do if flags.spin then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then pcall(function() h.CFrame = h.CFrame * CFrame.Angles(0, math.rad(15), 0) end) end end end task.wait(0.03) end end)
task.spawn(function() local hue = 0 while true do if flags.rainbowChar then local c = player.Character if c then hue = (hue + 0.02) % 1 local col = Color3.fromHSV(hue, 1, 1) for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.Color = col end) end end end end task.wait(0.05) end end)
task.spawn(function() while true do if flags.autoHeal then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h and h.Health < h.MaxHealth then pcall(function() h.Health = h.MaxHealth end) end end end task.wait(0.5) end end)
task.spawn(function() while true do if flags.infStamina then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() if h:FindFirstChild("Stamina") then h.Stamina.Value = h.Stamina.MaxValue end end) end end end task.wait(0.2) end end)
task.spawn(function() while true do if flags.antiAFK then local v = game:GetService("VirtualUser") pcall(function() v:CaptureController() v:ClickButton2(Vector2.new()) end) end task.wait(60) end end)
task.spawn(function() while true do if flags.walkOnWater then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local ray = Ray.new(h.Position, Vector3.new(0,-10,0)) local pt = workspace:FindPartOnRay(ray, c) if pt and pt.Material == Enum.Material.Water then pcall(function() h.CFrame = h.CFrame + Vector3.new(0, 0.3, 0) end) end end end end task.wait(0.1) end end)
task.spawn(function() while true do if flags.esp then for _, p in ipairs(Players:GetPlayers()) do if p ~= player and p.Character then local hl = p.Character:FindFirstChildOfClass("Highlight") if not hl then hl = Instance.new("Highlight") hl.Parent = p.Character hl.FillColor = Color3.fromRGB(255,0,0) hl.OutlineColor = Color3.fromRGB(255,255,255) hl.FillTransparency = 0.5 hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end end end else for _, p in ipairs(Players:GetPlayers()) do if p.Character then local hl = p.Character:FindFirstChildOfClass("Highlight") if hl then hl:Destroy() end end end end task.wait(1) end end)
task.spawn(function() while true do if flags.speedHack then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.WalkSpeed = 100 end) end end end task.wait(0.2) end end)
task.spawn(function() while true do if flags.jumpHack then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.UseJumpPower = true h.JumpPower = 300 end) end end end task.wait(0.3) end end)
task.spawn(function() while true do if flags.matrix then for _, p in ipairs(Players:GetPlayers()) do if p.Character then local hl = p.Character:FindFirstChild("MatrixHL") if not hl then hl = Instance.new("Highlight") hl.Name = "MatrixHL" hl.Parent = p.Character hl.FillColor = Color3.fromRGB(0,255,0) hl.OutlineColor = Color3.fromRGB(0,200,0) hl.FillTransparency = 0.6 hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end end end else for _, p in ipairs(Players:GetPlayers()) do if p.Character then local hl = p.Character:FindFirstChild("MatrixHL") if hl then hl:Destroy() end end end end task.wait(1) end end)
task.spawn(function() while true do if flags.xray then local c = player.Character if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then pcall(function() p.Transparency = 0.7 end) end end end end task.wait(0.5) end end)
task.spawn(function() while true do if flags.lookAtPlayer and _G.__camTarget and _G.__camTarget.Character then local h = _G.__camTarget.Character:FindFirstChild("HumanoidRootPart") local cam = workspace.CurrentCamera if h then cam.CFrame = CFrame.new(cam.CFrame.Position, h.Position) end end task.wait(0.1) end end)
task.spawn(function() while true do if flags.lookAtPlayer and not _G.__camTarget then local t = {} for _, p in ipairs(Players:GetPlayers()) do if p ~= player and p.Character then table.insert(t, p) end end if #t > 0 then _G.__camTarget = t[math.random(1,#t)] end end task.wait(2) end end)
task.spawn(function() while true do if flags.fireTrail or flags.sparkleTrail then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then if flags.fireTrail then local f = Instance.new("Fire", h) task.delay(1, function() if f then f:Destroy() end end) end if flags.sparkleTrail then local s = Instance.new("Sparkles", h) task.delay(1, function() if s then s:Destroy() end end) end end end end task.wait(0.1) end end)
task.spawn(function() while true do if flags.floating then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local b = h:FindFirstChild("FloatF") if not b then b = Instance.new("BodyForce", h) b.Name = "FloatF" end b.Force = Vector3.new(0, workspace.Gravity * h:GetMass() * 1.2, 0) end end end task.wait(0.2) end end)
task.spawn(function() while true do if flags.freeze then local c = player.Character if c then local h = c:FindFirstChildOfClass("Humanoid") if h then pcall(function() h.WalkSpeed = 0 end) end end end task.wait(0.2) end end)
task.spawn(function() while true do if flags.autoPunch then local c = player.Character if c then local t = c:FindFirstChildOfClass("Tool") if t then pcall(function() t:Activate() end) end end end task.wait(0.3) end end)

-- Эффекты (сокращённо для стабильности)
task.spawn(function() while true do if effectFlags.snow then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local p = Instance.new("Part") p.Size = Vector3.new(0.5,0.5,0.5) p.Position = h.Position + Vector3.new(math.random(-30,30), 40, math.random(-30,30)) p.Anchored = true p.CanCollide = false p.Color = Color3.new(1,1,1) p.Parent = workspace TweenService:Create(p, TweenInfo.new(5, Enum.EasingStyle.Linear), {Position = p.Position - Vector3.new(0,50,0)}):Play() task.delay(5, function() if p then p:Destroy() end end) end end end task.wait(0.1) end end)
task.spawn(function() while true do if effectFlags.rain then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local p = Instance.new("Part") p.Size = Vector3.new(0.1,3,0.1) p.Position = h.Position + Vector3.new(math.random(-40,40), 40, math.random(-40,40)) p.Anchored = true p.CanCollide = false p.Color = Color3.fromRGB(100,150,255) p.Transparency = 0.3 p.Parent = workspace TweenService:Create(p, TweenInfo.new(2, Enum.EasingStyle.Linear), {Position = p.Position - Vector3.new(0,60,0)}):Play() task.delay(2, function() if p then p:Destroy() end end) end end end task.wait(0.05) end end)
task.spawn(function() while true do if effectFlags.lightning then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local p = Instance.new("Part") p.Size = Vector3.new(0.5,100,0.5) p.Position = h.Position + Vector3.new(math.random(-50,50), 50, math.random(-50,50)) p.Anchored = true p.CanCollide = false p.Material = Enum.Material.Neon p.Color = Color3.fromRGB(255,255,0) p.Parent = workspace task.delay(0.2, function() if p then p:Destroy() end end) end end end task.wait(3) end end)
task.spawn(function() while true do if effectFlags.explosion then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local e = Instance.new("Explosion") e.Position = h.Position + Vector3.new(math.random(-20,20), 0, math.random(-20,20)) e.BlastRadius = 10 e.BlastPressure = 0 e.Parent = workspace end end end task.wait(2) end end)
task.spawn(function() while true do if effectFlags.portal then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then for i = 1, 15 do local a = (i/15) * math.pi * 2 local p = Instance.new("Part") p.Shape = Enum.PartType.Ball p.Size = Vector3.new(0.5,0.5,0.5) p.Position = h.Position + Vector3.new(math.cos(a)*5, math.sin(a)*5, math.sin(a)*5) p.Anchored = true p.CanCollide = false p.Material = Enum.Material.Neon p.Color = Color3.fromHSV(i/15, 1, 1) p.Parent = workspace task.delay(0.5, function() if p then p:Destroy() end end) end end end end task.wait(0.5) end end)
task.spawn(function() while true do if effectFlags.tornado then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then for i = 1, 8 do local p = Instance.new("Part") p.Size = Vector3.new(0.3,0.3,0.3) p.Position = h.Position + Vector3.new(math.random(-5,5), i*2, math.random(-5,5)) p.Anchored = true p.CanCollide = false p.Material = Enum.Material.Neon p.Color = Color3.fromRGB(150,150,150) p.Parent = workspace task.delay(0.3, function() if p then p:Destroy() end end) end end end end task.wait(0.1) end end)
task.spawn(function() while true do if effectFlags.fireworks then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then for i = 1, 20 do local p = Instance.new("Part") p.Shape = Enum.PartType.Ball p.Size = Vector3.new(0.3,0.3,0.3) p.Position = h.Position + Vector3.new(0,10,0) p.Anchored = true p.CanCollide = false p.Material = Enum.Material.Neon p.Color = Color3.fromHSV(math.random(), 1, 1) p.Parent = workspace local d = Vector3.new(math.random(-1,1), math.random(0,1), math.random(-1,1)).Unit TweenService:Create(p, TweenInfo.new(2, Enum.EasingStyle.Linear), {Position = p.Position + d*20}):Play() task.delay(2, function() if p then p:Destroy() end end) end end end end task.wait(3) end end)
task.spawn(function() while true do if effectFlags.disco then local l = game:GetService("Lighting") local hue = tick() % 1 l.Ambient = Color3.fromHSV(hue, 1, 1) l.OutdoorAmbient = Color3.fromHSV(hue, 1, 0.5) end task.wait(0.1) end end)
task.spawn(function() while true do if effectFlags.shockwave then local c = player.Character if c then local h = c:FindFirstChild("HumanoidRootPart") if h then local p = Instance.new("Part") p.Shape = Enum.PartType.Ball p.Size = Vector3.new(1,1,1) p.Position = h.Position p.Anchored = true p.CanCollide = false p.Material = Enum.Material.Neon p.Color = Color3.new(1,1,1) p.Transparency = 0.5 p.Parent = workspace TweenService:Create(p, TweenInfo.new(1, Enum.EasingStyle.Linear), {Size = Vector3.new(30,30,30), Transparency = 1}):Play() task.delay(1, function() if p then p:Destroy() end end) end end end task.wait(2) end end)

UserInputService.JumpRequest:Connect(function()
    if flags.infJump then
        local c = player.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
        end
    end
end)

-- ================== КНОПКА СКОРОСТИ ==================
forceBtn.MouseButton1Click:Connect(function()
    state.forceSpeed = not state.forceSpeed
    forceBtn.Text = state.forceSpeed and L("force_on") or L("force_off")
    forceBtn.BackgroundColor3 = state.forceSpeed and state.success or Color3.fromRGB(120,120,120)
end)

-- ================== ОТКРЫТИЕ ==================
local function openMenu()
    state.menuOpen = true
    panel.Visible = true
    panel.Size = UDim2.new(0, 380, 0, 530)
    panel.BackgroundTransparency = 1
    TweenService:Create(panel, TweenInfo.new(CONFIG.ANIM_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 580),
        BackgroundTransparency = state.menuTransparency,
    }):Play()
    openBtn.Text = "✕"
    openBtn.BackgroundColor3 = state.danger
end
local function closeMenu()
    state.menuOpen = false
    local t = TweenService:Create(panel, TweenInfo.new(CONFIG.ANIM_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 380, 0, 530),
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
refreshAllText()

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚖ Weight v208",
        Text = "Стабильная версия. 9 вкладок.",
        Duration = 3
    })
end)
