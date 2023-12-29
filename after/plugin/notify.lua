require("notify").setup({
    render= "compact",
    animation="fade_in_slide_out",
    timeout= 3000
}
)

Input = require("nui.input")

function Notify_Output(command, opts)
  local output = ""
  local notification
  local notify = function(msg, level)
    local notify_opts = vim.tbl_extend(
      "keep",
      opts or {},
      { title = table.concat(command, " "), replace = notification }
    )
    notification = require("notify")(msg, level, notify_opts)
  end
  local on_data = function(_, data)
    output = output .. table.concat(data, "\n")
    notify(output, "info")
  end
  vim.fn.jobstart(command, {
    on_stdout = on_data,
    on_stderr = on_data,
    on_exit = function(_, code)
      if #output == 0 then
        notify("No output of command, exit code: " .. code, "warn")
      end
    end,
  })
end

local command = Input({
    position = "50%",
    size = {
        width = 50,
    },
    border = {
        style = "rounded",
        text = {
            top = "Notify Output",
            top_align = "center",
        },
    },
    win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
}, {
    prompt = "> ",
    on_close = function()
        print("Closed")
    end,
    on_submit = function(text)
        local spaceIndex = string.find(text, " ") -- Find the index of the space
        local command = string.sub(text, 1, spaceIndex-1) -- Extract "echo"
        local opts = string.sub(text, spaceIndex+1) -- Extract "hello world"
        Notify_Output({ command, opts })
    end,
})

function Notify_Command()
  command:mount()
end

function Notify_Close()
    command:unmount()
end

vim.api.nvim_set_keymap("n", "<leader>no", ":lua Notify_Command()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<Esc>" or "<CR>", ":lua Notify_Close()<CR>", {noremap = true, silent = true})
