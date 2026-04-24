return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim', -- ADDED: Bridges mason and lspconfig
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('fmt', vim.lsp.buf.format, '[F]ormat')
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gca', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('gtD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gtd', vim.lsp.buf.definition, '[G]oto [D]efinition')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Define all your servers and their specific configurations here.
    -- nvim-lspconfig already knows exactly which filetypes map to these servers.
    local servers = {
      -- clangd = {},
      -- gopls = {},
      pyright = {},
      bashls = {},
      html = {},

      -- Moved your custom Lua config into this table
      lua_ls = {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
              path = { 'lua/?.lua', 'lua/?/init.lua' },
            },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file('', true),
            },
          })
        end,
        settings = { Lua = {} },
      },
    }

    -- 1. Initialize Mason
    require('mason').setup()

    -- 2. Ensure formatters and linters are installed (Mason Tool Installer)
    -- We extract the LSP server names and add the non-LSP tools.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'autopep8',
      'clangd',
      'stylua',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    -- Source - https://stackoverflow.com/a/79656109

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })

    -- 3. Configure Mason-LSPConfig to handle dynamic filetype attachment
    require('mason-lspconfig').setup {
      -- This automatically installs the LSPs defined in the `servers` table if they are missing
      automatic_installation = true,

      -- This setup_handlers block is the magic. It loops through your installed
      -- servers, injects your blink capabilities, and calls `lspconfig.setup()`.
      -- `lspconfig` handles attaching it to the correct buffer filetype automatically.
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
