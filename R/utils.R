# Shared plotting constants for the nonlinear trends vignette.

# Six colors from the ltc "reading" palette (ltc::ltc("reading")), keyed to
# the original six case-study analytes so each keeps one color across every
# figure it appears in. A seventh, "#A85751" (muted brick red), was added by
# hand for Total Copper — not drawn from the ltc palette, chosen to stay
# visually distinct from the terracotta already in use.
project_palette <- c(
  "#57717C", "#5F97A4", "#919F89", "#C97B63", "#B8A34C", "#8C6FA0", "#A85751"
)

analyte_colors <- c(
  "Total Nitrogen"        = project_palette[1],
  "Specific Conductance"  = project_palette[2],
  "Total Phosphorus"      = project_palette[3],
  "Dissolved Oxygen"      = project_palette[4],
  "Total Chloride"        = project_palette[5],
  "Total Zinc"            = project_palette[6],
  "Total Copper"          = project_palette[7]
)

analyte_levels <- names(analyte_colors)

order_analytes <- function(data) {
  dplyr::mutate(data, analyte = factor(analyte, levels = analyte_levels))
}

# Banner color for figure titles, matching the sibling vignettes' convention.
banner_fill <- "#C8CFD6"
banner_text_color <- "black"

nlt_theme <- ggplot2::theme_bw() +
  ggplot2::theme(
    panel.grid.minor.x = ggplot2::element_blank(),
    panel.grid.minor.y = ggplot2::element_blank(),
    axis.line.x = ggplot2::element_line(colour = "black", linewidth = 0.2),
    axis.line.y = ggplot2::element_line(colour = "black", linewidth = 0.2),
    panel.background = ggplot2::element_blank(),
    axis.title.x = ggplot2::element_text(colour = "black", size = 10, vjust = -0.5),
    axis.title.y = ggplot2::element_text(colour = "black", size = 10, vjust = 0.3),
    axis.text.x = ggplot2::element_text(colour = "black", size = 9),
    axis.text.y = ggplot2::element_text(colour = "black", size = 9),
    legend.position = "none",
    plot.title = ggtext::element_textbox_simple(
      fill = banner_fill,
      color = banner_text_color,
      face = "bold",
      halign = 0.5,
      padding = ggplot2::margin(5.5, 5.5, 5.5, 5.5),
      margin = ggplot2::margin(b = 5.5),
      box.colour = "black",
      linetype = 1,
      linewidth = 0.3
    )
  )
