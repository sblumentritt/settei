-- @module settings.lspsaga
local lspsaga = {}

local function gui_highlight(group, fg, bg, style)
    local highlight_parts = {group}

    table.insert(highlight_parts, "guifg=" .. fg)

    if bg then
        table.insert(highlight_parts, "guibg=" .. bg)
    else
        table.insert(highlight_parts, "guibg=none")
    end

    if style then
        table.insert(highlight_parts, "gui=" .. style)
    else
        table.insert(highlight_parts, "gui=none")
    end

    vim.cmd("highlight " .. table.concat(highlight_parts, " "))
end

function lspsaga.overwrite_highlight()
    gui_highlight("LspSagaBorderTitle", "#93b3a3")
    gui_highlight("DefinitionPreviewTitle", "#93b3a3")
    gui_highlight("LspSagaCodeActionTitle", "#93b3a3")

    gui_highlight("TargetFileName", "#e5dbd0")
    gui_highlight("DefinitionCount", "#d6c3a1")
    gui_highlight("DefinitionIcon", "#d6c3a1")
    gui_highlight("ReferencesCount", "#d6c3a1")
    gui_highlight("ReferencesIcon", "#d6c3a1")

    gui_highlight("DiagnosticError", "#da7c72")
    gui_highlight("DiagnosticWarning", "#dfa883")
    gui_highlight("DiagnosticInformation", "#93b3a3")
    gui_highlight("DiagnosticHint", "#9fb193")

    gui_highlight("LspSagaCodeActionContent", "#e5dbd0")
    gui_highlight("LspSagaRenamePromptPrefix", "#e5dbd0")

    gui_highlight("TargetWord", "#e5dbd0", "none", "bold")
    gui_highlight("HelpItem", "#998f85", "none", "italic")
    gui_highlight("SagaShadow", "#222222")

    local truncate_line_color = "#998f85"
    gui_highlight("ProviderTruncateLine", truncate_line_color)
    gui_highlight("DiagnosticTruncateLine", truncate_line_color)
    gui_highlight("LspSagaDocTruncateLine", truncate_line_color)
    gui_highlight("LspSagaCodeActionTruncateLine", truncate_line_color)
    gui_highlight("LspSagaShTruncateLine", truncate_line_color)
    gui_highlight("LineDiagTuncateLine", truncate_line_color)

    local border_color = "#998f85"
    gui_highlight("LspFloatWinBorder", border_color)
    gui_highlight("LspDiagErrorBorder", border_color)
    gui_highlight("LspDiagWarnBorder", border_color)
    gui_highlight("LspDiagInforBorder", border_color)
    gui_highlight("LspDiagHintBorder", border_color)
    gui_highlight("LspSagaRenameBorder", border_color)
    gui_highlight("LspSagaHoverBorder", border_color)
    gui_highlight("LspSagaSignatureHelpBorder", border_color)
    gui_highlight("LspSagaLspFinderBorder", border_color)
    gui_highlight("LspSagaCodeActionBorder", border_color)
    gui_highlight("LspSagaAutoPreview", border_color)
    gui_highlight("LspSagaDefPreviewBorder", border_color)
    gui_highlight("LspLinesDiagBorder", border_color)
end

return lspsaga
