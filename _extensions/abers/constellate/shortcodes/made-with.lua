local function identity(file, alt, label, name, url)
  return pandoc.Div({
    pandoc.Para({
      pandoc.Image(
        { pandoc.Str(alt) },
        pandoc.path.make_relative(
          quarto.utils.resolve_path("../assets/" .. file),
          pandoc.path.directory(quarto.doc.input_file),
          true
        )
      ),
    }),
    pandoc.Para({
      pandoc.Str(label),
      pandoc.Space(),
      pandoc.Link({ pandoc.Str(name) }, url, "", pandoc.Attr("", { "identity-name" })),
    }),
  }, pandoc.Attr("", { "constell-identity" }))
end

return {
  ["constell-made-with"] = function()
    local result = pandoc.Blocks({})
    if quarto.doc.is_format("revealjs") then
      result:insert(pandoc.HorizontalRule())
    end
    result:insert(pandoc.Div({
      identity("quarto-logo.svg", "Quarto logo", "Made with", "Quarto", "https://quarto.org/"),
      identity("cat-logo.png", "Catppuccin logo", "Colour scheme", "Catppuccin", "https://catppuccin.com/"),
    }, pandoc.Attr("", { "colophon" })))
    return result
  end,
}
