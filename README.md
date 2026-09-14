-- Script Menu Auto Headshot & Aim Assist Free Fire
local script_menu = {
    ["Auto Headshot"] = {
        enabled = false,
        circle_size = 50, -- Kích thước vòng tròn (từ 30-100 pixel)
        speed = 0.5, -- Tốc độ điều chỉnh (0.1-1.0: chậm đến nhanh)
        aim_lock = true,
        esp = true
    },
    ["Aim Assist"] = {
        enabled = false,
        sensitivity = 1.5,
        fov = 120 -- Góc nhìn tìm mục tiêu
    }
}

-- Hàm khởi tạo menu
function loadFFScriptMenu()
    local choice = gg.multiChoice({
        "Bật/Tắt Auto Headshot",
        "Cài Đặt Kích Thước Vòng Tròn: " .. script_menu["Auto Headshot"].circle_size,
        "Cài Đặt Tốc Độ: " .. script_menu["Auto Headshot"].speed,
        "Bật/Tắt Aim Lock",
        "Bật/Tắt ESP",
        "Bật/Tắt Aim Assist",
        "Cài Đặt Độ Nhạy: " .. script_menu["Aim Assist"].sensitivity,
        "Cài Đặt Góc FOV: " .. script_menu["Aim Assist"].fov,
        "Thoát Menu"
    }, nil, "MENU SCRIPT FREE FIRE - AIM HEADSHOT")
    
    if choice == nil then return end
    
    -- Xử lý lựa chọn
    if choice == 1 then
        script_menu["Auto Headshot"].enabled = not script_menu["Auto Headshot"].enabled
        gg.toast("Auto Headshot: " .. (script_menu["Auto Headshot"].enabled and "BẬT" or "TẮT"))
    elseif choice == 2 then
        local size = gg.input("Nhập kích thước vòng tròn (30-100):", tostring(script_menu["Auto Headshot"].circle_size))
        if size and tonumber(size) then
            script_menu["Auto Headshot"].circle_size = math.clamp(tonumber(size), 30, 100)
        end
    elseif choice == 3 then
        local speed = gg.input("Nhập tốc độ điều chỉnh (0.1-1.0):", tostring(script_menu["Auto Headshot"].speed))
        if speed and tonumber(speed) then
            script_menu["Auto Headshot"].speed = math.clamp(tonumber(speed), 0.1, 1.0)
        end
    elseif choice == 4 then
        script_menu["Auto Headshot"].aim_lock = not script_menu["Auto Headshot"].aim_lock
        gg.toast("Aim Lock: " .. (script_menu["Auto Headshot"].aim_lock and "BẬT" or "TẮT"))
    elseif choice == 5 then
        script_menu["Auto Headshot"].esp = not script_menu["Auto Headshot"].esp
        gg.toast("ESP: " .. (script_menu["Auto Headshot"].esp and "BẬT" or "TẮT"))
    elseif choice == 6 then
        script_menu["Aim Assist"].enabled = not script_menu["Aim Assist"].enabled
        gg.toast("Aim Assist: " .. (script_menu["Aim Assist"].enabled and "BẬT" or "TẮT"))
    elseif choice == 7 then
        local sens = gg.input("Nhập độ nhạy (0.5-3.0):", tostring(script_menu["Aim Assist"].sensitivity))
        if sens and tonumber(sens) then
            script_menu["Aim Assist"].sensitivity = math.clamp(tonumber(sens), 0.5, 3.0)
        end
    elseif choice == 8 then
        local fov = gg.input("Nhập góc FOV (60-180):", tostring(script_menu["Aim Assist"].fov))
        if fov and tonumber(fov) then
            script_menu["Aim Assist"].fov = math.clamp(tonumber(fov), 60, 180)
        end
    elseif choice == 9 then
        os.exit()
    end
    loadFFScriptMenu()
end

-- Chạy menu khi script được tải
loadFFScriptMenu()
