
load('htShiny.RData')
chooseCRANmirror(ind = 1)
setRepositories(ind = 1:2)
if(!requireNamespace('InteractiveComplexHeatmap', quietly = TRUE)) {
	install.packages('InteractiveComplexHeatmap')
}
library(shiny)
suppressPackageStartupMessages(library(InteractiveComplexHeatmap))
suppressPackageStartupMessages(library(ComplexHeatmap))
ui = fluidPage(
	title,
	description,
	if(hline) hr() else NULL,
	InteractiveComplexHeatmapOutput(heatmap_id = heatmap_id, title1 = title1, title2 = title2,
		width1 = width1, height1 = height1, width2 = width2, height2 = height2, layout = layout, compact = compact,
		action = action, cursor = cursor, response = response, brush_opt = brush_opt, output_ui_float = output_ui_float), 
	html
)

server = function(input, output, session) {
	makeInteractiveComplexHeatmap(input, output, session, ht_list, 
		sub_heatmap_cell_fun = sub_heatmap_cell_fun, sub_heatmap_layer_fun = sub_heatmap_layer_fun)
}

cat('If the shiny app is not automatically opened in the browser, you can manually copy the following link and paste it to the browser.');
print(shinyApp(ui, server))

