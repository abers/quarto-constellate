# Constellate Extension For Quarto

Personal Quarto brand and theming extension. [Catppuccin](https://catppuccin.com/) is used for the colour scheme. Aim is comprehensive and accessible theming across Quarto, its features, and extensions I commonly use - alongside providing additional helpers and small features.

**WARNING**: This extension is very much "work-in-progress" and will require a heavy refactor. It contains a mix of good old-fashioned iterative explorative human coding slop and - with regret - AI slop. Encountered a lot of limitations with brand.yml and Quarto in general working on the customisation, whereby some of the initial code was written based on assuming other design implementations were going to be possible. (For example, brand.yml is not contributing very much to the final design compared to what I originally thought possible). AI was used to figure out graph theming, edge cases, do consistency reviews, and, figuring out workarounds for any hard barriers encountered. Done good few passes reviewing, refactoring, and removing the most egregious outright slop - reducing lines of code by around 50% whilst maintaining the same end customisation and features! What is left is still not to a standard I would normally be comfortable making public - in general, I am against polluting public repos with AI slop as anyone can produce that, making it worthless unlike human maintainable code - but doing so as using the extension for my own sites whilst continue working on the extension. This warning will stay in place until the code has been fully refactored to remove the remaining AI slop.

Another limitation - stemming more from the human side - is a lot of it at present assumes the extended Catppuccin colour scheme which is used as the defaults. Long-term, aim will be to refactor the files to support customising the colour schemes.

## Installing

To install:

```bash
quarto add abers/quarto-constellate
```

This will install the extension under `_extensions/abers/constellate`.

**NOTE**: Due to limitations with Quarto extensions - unless adding some convoluted mechanisms - some features require some manual setup. This repo contains template files for these that can copy into a project as well as relevant info below of any manual config also needed.

## Using

This extension installs a [brand.yml](https://posit-dev.github.io/brand-yml/) configuration, additional theming, filters, scripts, and more to provide comprehensive Catppuccin theming for Quarto HTML and RevealJS. Catppuccin light uses a "Cortado" variant of Latte with font colours adjusted to meet accessible contrast ratios.

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

**NOTE**: I need to update the example pages with all the themed components the current example pages in this repo are limited to core Quarto markup.

## Custom Formats

For HTML and websites:

```yml
format: constellate-html
```

For RevealJS:

```yml
format: constellate-revealjs
```

## Slides Folder

The extension provides scripts for rendering dark and light mode versions of slides. These assume that slides are within specific folder(s). For slides included as part of websites, it modifies the links to slides so the version opened follows the site's light/dark mode toggle. A Python script is also provided as a short wrapper for creating standalone versions of slides with embedded resources.

Create a top-level `_quarto-slides.yml` file and add:

```yml
project:
  render:
    - slides/**
```

Then within `slides/` folder add `_metadata.yml` with:

```yml
format: constellate-revealjs
```

Add to `_quarto.yml`:

```yml
project:
  type: website
  post-render:
    - python3 _extensions/abers/constellate/scripts/render-slides.py --post-render

slides-follow-theme: true
```

Copy `_quarto-slides-light.yml` and `export-slides.py` from this repo into your project beside `_quarto.yml`.

After that you can `quarto render` with the normal render creating the dark mode version and the post-render creating light mode version with `-light` postfix added to the filenames.

**Note**: This setup does not work when running incremental preview so run a full render first if wishing to check light and dark versions of slides. Another limitation is that slides opened via Quarto's search tool do not follow the light/dark mode toggle.

A short Python script can render standalone versions of slides with embedded resources:

```bash
# All slides in configured folder(s)
python3 export-slides.py

# Selected slides only
python3 export-slides.py slides/week-1.qmd slides/week-2.qmd
```

Standalone slides are placed in `slides-export/` folder.

## Constellate Website Layout Config

The extension provides options for configuring the site layout which can be included in `_quarto.yml`.

Example configuration:

```yml
constellate:
  layout:
    article-card: true
    hero-overlap: none
    toc-background: sidebar
    light-surround: false
```

- **article-card** - whether to use an article card (true) or flat style (false)
- **hero-overlap** - whether `none`, `sidebar`, or `both` sidebar and toc overlap the page's hero banner
- **toc-background** - whether the toc background colour matches `surround` (background colour used around article cards), `article`, or `sidebar`.
- **light-surround** - whether to use a lighter background colour in light mode for the surround background colour.

## Constellate Group Colours

The extension provides options to configure group colours used in docked sidebars and (optionally) the hero.

Example options to use in `_quarto.yml`.

```yml
constellate:
  sidebar:
    grouped: true
    hero-colour: true
    active-group-colour: false
    collapsed-colour: true
```

- **grouped** - whether to use group colours or not
- **hero-colour** - whether the hero colour for a page should match the group colour
- **active-group-colour** - whether the font colour for active pages in the side bar use the group colour or the default active font colour
- **collapsed-colour** - whether the group background colour is always displayed in the sidebar or only when the group is expanded.

Groups are created via adding a `section:` to the sidebar. By default grouped sections use lavender. Other colours can be declared with `.constell-group-COLOUR`. For example:

```yml
website:
  sidebar:
    contents:
      - section: "[A Section]{.constell-group-pink}"
        contents:
          - page-one.qmd
          - page-two.qmd
```

Colour options are `flamingo`, `pink`, `mauve`, `red`, `maroon`, `peach`, `yellow`, `green`, `teal`, and `sky`.

**NOTE**: At present, section titles are plain text only and cannot be a link to a page.

## Slide metadata

The title slide partial includes regular Quarto metadata fields and additional teaching related ones:

```yml
title:
subtitle:

author:
  - name:
    email:
    url:
    roles: []
    affiliations:
      - name:

date: YYYY-MM-DD

module:
module-code:
week: 3
```

## Image helper

A custom div exists for whether images with options for if to use rounded corners, add a border, or render the image in duotone (catppuccin) colours.

```markdown
::: {.constell-image rounded="true" border="true" duotone="false"}
![Alt-text](image.png)
:::
```

## Shortcodes

Currently there is only one shortcode:

```markdown
{{< constell-made-with >}}
```

This produces a "Made with Quarto" and "Colour scheme Catppuccin" acknowledgements with logos and links.

## Extension classes

Custom extension classes exist for Mermaid and Graphviz due to limitations theming the Quarto built-in classes directly.

They can be used with `.constell-mermaid` and `.constell-dot`.

Option diagram classes include:

- `accent-COLOUR`
- `node-soft-COLOUR`
- `node-solid-COLOUR`
- `edge-COLOUR`

Colour options are `blue`, `pink`, `green`, `peach`, `mauve`, `yellow`, `teal`, `red`, `lavender`.

**Warning**: The Mermaid and Graphviz implementations are code sections mostly likely to change. Given the numerous limitations encountered trying to theme Quarto's native Mermaid and Graphviz blocks, AI was used to find workarounds. I have _heavily_ de-slopped the code, but I will likely made further substantial changes.

**Note**: Graphviz requires the `dot` executable.

## Install fonts locally

Graphviz, ggplot2, and Matplotlib need the fonts used installed locally (Open Sans, Overpass, and Inconsolata) on the machine used for rendering. On Linux, quick way to do this is copy the TTF files for the fonts to `~/.local/share/fonts/` and run `fc-cache -f`.

## ggplot2

To setup Constellate ggplot2 theming site wide add a `.Rprofile` beside `_quarto.yml` (- or in a setup cell per page):

```r
source("_extensions/abers/constellate/visualisation/ggplot-html.R", chdir = TRUE)
```

To have graphs that follow the light/dark theme, also add `#| renderings: [light, dark]` to each ggplot code chunk in HTML and RevealJS files so graphs.

## Matplotlib

I could not find as easy a solution for Matplotlib as ggplot where can setup theming once rather than per code block. Solution found relies on R's `reticulate` package so can use knitr to run Python. After `install.packages("reticulate")` -

Add to `.Rprofile` beside `_quarto.yml`:

```r
source("_extensions/abers/constellate/visualisation/matplotlib.R", chdir = TRUE)
```

Pages with both R and Python chunks will select knitr automatically. For pages or slides containing only Python, add to the file's YAML:

```yaml
engine: knitr
```

Then can do same as ggplot of writing regular code chunks with `#| renderings: [light, dark]`.

## Theme file regeneration

Plot tokens and Matplotlib styles are generated from Sass colours and brand fonts. These need to be regenerated manually after any colour/font changes (requires a `sass` executable and Python PyYAML):

```bash
python3 _extensions/abers/constellate/scripts/generate-themes.py
```

At present this assumes the Catppuccin colour palettes being used, but the plan is this will eventually also support generating theme files from custom palettes.

## exams2forms

The extension includes customisation for exams2forms (HTML only at present).

To install exams2forms:

```r
install.packages("exams2forms")
```

To use the extension's exams2forms customisation include the following in `_quarto.yml`:

```yml
format:
  constellate-html:
    css: _extensions/abers/constellate/assets/exams2forms/webex.css
    include-after-body: _extensions/abers/constellate/assets/exams2forms/webex.js
```

However, a better setup is to only use the relevant files on pages that actually use exams2forms. In which case, for each file that uses exams2forms -

Add to its YAML:

```yml
css: /_extensions/abers/constellate/assets/exams2forms/webex.css
```

And then in the main content use the shortcode:

```markdown
{{< include /_extensions/abers/constellate/assets/exams2forms/webex.js >}}
```

**NOTE**: The `/` at the start of a path does not work with `include-after-body` in per page YAML, creating annoying issues of managing relative paths if have folders. So, the include shortcode is easiest workaround.

## quarto-live

The extension includes customisation for quarto-live (HTML only at present).

To install quarto-live:

```shell
quarto add r-wasm/quarto-live
```

Then for pages that use quarto-live add to YAML:

```yml
filters: [live]
ojs-engine: true
engine: knitr
```

And before the main page content add the shortcode:

```markdown
{{< include /_extensions/r-wasm/live/_knitr.qmd >}}
```

**NOTE**: The leading `/` makes this work from any page in the project.

It's possible to use Constellate's callouts with quarto-live (replace `ex_1` with the exercise's ID):

```markdown
::: {.hint exercise="ex_1"}
::: {.callout-tip title="Hint"}
Hint text or code.
:::
:::

::: {.solution exercise="ex_1"}
::: {.callout-note title="Solution"}
Solution text or code.
:::
:::
```

## Limitations

(This section is more notes to self.)

Quarto extensions can include other extensions, but - at present - these are installed inside the extension's folder and not available to other extensions. In other words, if multiple extensions have the same dependency, they all install a copy of it.

I have avoided that. So, to add the usual footers I use, first install fontawesome:

```shell
quarto add quarto-ext/fontawesome
```

And then add to `_quarto.yml`:

```yml
website:
  page-footer:
    left: "Made with {{< fa brands r-project >}} and [![Quarto](/_extensions/abers/constellate/assets/quarto-logo.svg){height=1em} Quarto](https://quarto.org)"
    center: "Licensed under {{< fa brands creative-commons >}} {{< fa brands creative-commons-by >}} {{< fa brands creative-commons-sa >}} [Creative Commons BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)"
    right: "Colour scheme [![Catppuccin](/_extensions/abers/constellate/assets/cat-logo.png){height=1em} Catppuccin](https://catppuccin.com/palette/)"
```
