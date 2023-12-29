require("manas")

today = os.date("%d/%m/%Y")
require("notify")("Hi Manas! Today is " ..today)

f= io.open("/home/manas/.local/share/nvim/site/pack/packer/start/nvim-todo/lua/nvim-todo/todo.txt", "r")

while true do
    line = f:read()
    if line == nil then break end

    require("notify")(line)
end

f:close()
