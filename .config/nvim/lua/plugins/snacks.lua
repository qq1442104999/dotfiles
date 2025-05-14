return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          cmd = "fd",
          args = { "--type", "f", "--hidden", "--no-ignore", "--follow" },
          hidden = true,     -- 显示隐藏文件
          ignored = false,   -- 不忽略 .gitignore
          follow = true,     -- 跟随符号链接
        },
        explorer = {
          hidden = true,         -- 显示隐藏文件
          ignored = false,       -- 不忽略 .gitignore
          follow = true,         -- 跟随符号链接
          git_untracked = true,  -- 显示未追踪文件
          tree = true,
          watch = true,
          diagnostics = true,
        },
      },
    },
  },
}


