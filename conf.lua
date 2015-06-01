function love.conf(t)
    t.identity = "pong"
    t.version = "0.9.1"
    t.console = false
 
    t.window.title = "Pong"
    t.window.icon = nil
    t.window.width = 480
    t.window.height = 320
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 480
    t.window.minheight = 320
    t.window.fullscreen = false
    t.window.fullscreentype = "normal"
    t.window.vsync = true
    t.window.fsaa = 0
    t.window.display = 1
    t.window.highdpi = false
    t.window.srgb = false
    t.window.x = nil
    t.window.y = nil
 
    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.window = true
    t.modules.thread = true
end