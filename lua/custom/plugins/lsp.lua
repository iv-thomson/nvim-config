-- Not compatible with yarn Berry
-- Use nodeLinker: node-modules
-- TODO: investigate if possible to integrate with yarn berry. See https://github.com/yarnpkg/berry/issues/170
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'saghen/blink.cmp',
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local lsp_keymaps = function(_, bufnr)
      local opts = { buffer = bufnr }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<leader>dl', '<cmd>Telescope diagnostics<cr>', opts)
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>fr', require('telescope.builtin').lsp_references, opts)
      vim.keymap.set('n', '<leader>e', function()
        vim.diagnostic.open_float(nil, { focusable = true, scope = 'line', max_width = 80, border = 'single' })
      end, opts)
    end

    local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
    local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = "~/.npm-global/lib/node_modules/@vue/language-server",
        languages = { "vue" },
    }
    vim.lsp.config('tsserver', {
      capabilities = capabilities,
      on_attach = lsp_keymaps,
      -- links to global language server
      cmd = { "typescript-language-server", "--stdio" }
      -- Uncomment for local setup (needs to be install locally)
      -- cmd = { "yarn", "typescript-language-server", "--stdio" };
    })

    vim.lsp.config('vtsls', {
      capabilities = capabilities,
      on_attach = lsp_keymaps,
      filetypes = { 'vue' },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              vue_plugin,
            },
         },
        },
      },
    })

    vim.lsp.config('vue_ls', {
        capabilities = capabilities,
        on_attach = lsp_keymaps,
    })

    vim.lsp.config('sourcekit', {
      capabilities = capabilities,
      on_attach = lsp_keymaps,
    })

    vim.lsp.enable {
      'tsserver',
      'vtsls',
      'vue_ls',
      'sourcekit',
    }
  end,
}
