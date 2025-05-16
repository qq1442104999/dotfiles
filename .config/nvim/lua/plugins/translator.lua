return {
  "uga-rosa/translate.nvim",
  keys = {
    { "<leader>tr", "<cmd>Translate en<cr>", desc = "Translate to English" },
    { "<leader>tc", "<cmd>Translate zh<cr>", desc = "翻译成中文" },
    { "<leader>tv", "<cmd>Translate zh -output=replace<cr>", desc = "替换为中文" },
    { "<leader>tt", "<cmd>Translate<cr>", desc = "使用默认语言翻译" },
  },
  opts = {
    default = {
      command = "google",
      output = "floating",
    },
  },
}
