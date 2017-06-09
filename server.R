if (!require("shiny")) install.packages('shiny')
if (!require("markdown")) install.packages('markdown')
if (!require("data.table")) install.packages('data.table')
if (!require("plotly")) install.packages('plotly')
if (!require("corrplot")) install.packages('corrplot')
if (!require("DT")) install.packages('DT')
if (!require("GGally")) install.packages('GGally')

options(shiny.maxRequestSize=10*1024^2)

shinyServer(function(input, output, session) {

    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## [Output]: Load Data
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  data_set <- reactive({inFile <- input$file1
  if (is.null(inFile))
    return(NULL)
  read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote, stringsAsFactors = F)
  })      
  
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Content of loaded dataset
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$contents <- DT::renderDataTable({
      DT::datatable(data_set())
    })

    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Get list of dataset column names
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    observe({
      updateSelectizeInput(session, 'inSelectInput', choices = names(data_set()), server = TRUE)
    })

    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Input]: Univariate statistics - Selected attribute
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Select input
    output$choose_columns <- renderUI({
      # If missing input, return to avoid error later in function
      if(is.null(input$dataset))
        return()
      
      # Get the data set with the appropriate name
      
      colnames <- names(data_set())
      
      # Create the checkboxes and select them all by default
      selectInput("attrs", "Choose a", 
                  choices  = colnames,
                  selected = colnames)
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Summary statistics
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    output$summary <- renderTable({
      dt = data_set()
      Attribute = input$inSelectInput
      Class = class(dt[,Attribute])
      Basic_Type = '-'
      Minimum = '-'
      First_Quartile = '-'
      Median = '-'
      Third_Quartile = '-'
      Maximum = '-'
      if( Class == 'character' || Class == 'factor') { 
        Minimum = '-'
        First_Quartile = '-'
        Median = '-'
        Third_Quartile = '-'
        Maximum = '-'
        Standard_Deviation = '-'
      }
      if( Class == 'numeric' || Class == 'integer'){
        Minimum = round(summary(dt[,Attribute])[[1]], 4)
        First_Quantile = round(summary(dt[,Attribute])[[2]], 4)
        Median = round(summary(dt[,Attribute])[[3]], 4)
        Third_Quantile = round(summary(dt[,Attribute])[[4]], 4)
        Maximum = round(summary(dt[,Attribute])[[5]], 4)
        Standard_Deviation = round(sd(dt[,Attribute], na.rm = FALSE), 4)
      }
      if( Class == 'character' || Class == 'factor') { Basic_Type = 'categorical'}
      if( Class == 'numeric')                   { Basic_Type = 'continuous'}
      if ( Class == 'integer')                     { Basic_Type = 'discrete'}
      df = data.frame(Attribute, Class, Basic_Type, Minimum, First_Quartile, Median, Third_Quartile, Maximum, Standard_Deviation)
      df
      })
  
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Histogram
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$histPlot <- renderPlotly({
      dt = data_set()
      subdf = dt[,input$inSelectInput]
      
      minx <- min(subdf)
      maxx <- max(subdf)    
      
      # size of the bins depend on the input 'bins'
      size <- (maxx - minx) / input$bins
      
      # a simple histogram of movie ratings
      p <- plot_ly(dt, x = subdf, autobinx = F, type = "histogram",
                   xbins = list(start = minx, end = maxx, size = size))
      # style the xaxis
      layout(p, xaxis = list(title = input$inSelectInput, range = c(minx, maxx), autorange = T,
                             autotick = F, tick0 = minx, dtick = size))
      
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Heatmap
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$heatPlot <- renderPlotly({
      data = data_set()[,input$inSelectInput]
      plot_ly(z = volcano, type = "heatmap")
      
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Heatmap
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$boxPlot <- renderPlotly({
      data = data_set()[,input$inSelectInput]
      ### adding jittered points
      plot_ly(y = data, data = data_set(),  type = "box", boxpoints = "all", jitter = 0.3, pointpos = -1.8)
      
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Get list of dataset pairs of column names
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    observe({
      updateSelectizeInput(session, 'inSelectPairInputx', choices = names(data_set()), server = TRUE)
      updateSelectizeInput(session, 'inSelectPairInputy', choices = names(data_set()), server = TRUE)
    })
    
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Scatterplot
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    output$scatPlot <- renderPlotly({
      x = data_set()[, input$inSelectPairInputx]
      y = data_set()[, input$inSelectPairInputy]
      level = unique(y)
        
      title = paste0('(X) ',input$inSelectPairInputx, ' - (Y) ', input$inSelectPairInputy)
      p <- plot_ly(x = x, y = y, mode = "markers", color = level, colors = "Set1")
              
      # style the xaxis
      layout(p, xaxis = list(title = input$inSelectPairInputx, autorange = T, autotick = F), yaxis = list(title = input$inSelectPairInputy, autorange = T, autotick = F))
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Basic Time Series Plot with Loess Smooth
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$timeloessPlot <- renderPlotly({
      x = data_set()[, input$inSelectPairInputx]
      y = data_set()[, input$inSelectPairInputy]
      
      p <- plot_ly(data_set(), x = x, y = y, name = input$inSelectPairInputy)
      # style the xaxis
      layout(p, xaxis = list(title = input$inSelectPairInputx, autorange = T, autotick = F), yaxis = list(title = input$inSelectPairInputy, autorange = T, autotick = F))
      p %>% add_trace(y = fitted(loess(y ~ as.numeric(x))), x = x, name = 'Loess Smooth')
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Line Interpolation Options
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$linePlot <- renderPlotly({
      x = data_set()[, input$inSelectPairInputx]
      y = data_set()[, input$inSelectPairInputy]
      p <- plot_ly(x = x, y = y, name = "linear", line = list(shape = "linear")) %>%
        add_trace(x = x, y = y + 5, name = "spline", line = list(shape = "spline")) %>%
        add_trace(x = x, y = y + 10, name = "vhv", line = list(shape = "vhv")) %>%
        add_trace(x = x, y = y + 15, name = "hvh", line = list(shape = "hvh")) %>%
        add_trace(x = x, y = y + 20, name = "vh", line = list(shape = "vh")) %>%
        add_trace(x = x, y = y + 25, name = "hv", line = list(shape = "hv"))
      layout(p, xaxis = list(title = input$inSelectPairInputx, autorange = T, autotick = F), yaxis = list(title = input$inSelectPairInputy, autorange = T, autotick = F))
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Pair Correlation
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$corrpairPlot <- renderPlotly({
      ggpairs(data_set()[, c(input$inSelectPairInputx, input$inSelectPairInputy)], 
              upper = list(continuous = wrap("cor", size = 10)), 
              lower = list(continuous = "smooth"))
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Get list of dataset column names for multivariate analysis
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    observe({
      updateSelectizeInput(session, 'inSelectMultiInputx', choices = names(data_set()), server = TRUE)
      updateSelectizeInput(session, 'inSelectMultiInputy', choices = names(data_set()), server = TRUE)
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Multi Correlation
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$boxmultiPlot <- renderPlotly({
      ### several box plots
      #plot_ly(data_set()[, c(input$inSelectPairInputx, input$inSelectPairInputy)], y = price, color = cut, type = "box")
      data = data_set()
      #x = data_set()[, input$inSelectMultiInputx]
      #y = data_set()[, input$inSelectMultiInputy]
      x = as.factor(input$inSelectMultiInputx)
      y = input$inSelectMultiInputy
      #col = names(data)
      #col = col[-input$inSelectMultiInputy]
      plot_ly(data, y = y, color = x, type = "box")
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Multi-Correlation
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$corrmultiPlot <- renderPlot({
      ggpairs(data_set(), 
              upper = list(continuous = wrap("cor", size = 5)), 
              lower = list(continuous = "smooth"))
    })
    
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ## [Output]: Multi-Correlation 2
    ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    output$corrmultiPlot2 <- renderPlot({
      corrplot(cor(data_set()), method="number")
    })
    
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## End of Shiny Server Script
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
})
