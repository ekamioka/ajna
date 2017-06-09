if (!require("shiny")) install.packages('shiny')
if (!require("markdown")) install.packages('markdown')
if (!require("data.table")) install.packages('data.table')
if (!require("plotly")) install.packages('plotly')
if (!require("corrplot")) install.packages('corrplot')
if (!require("DT")) install.packages('DT')
if (!require("GGally")) install.packages('GGally')

shinyUI(navbarPage(title = "Ajna - Data Science",
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## HTML Layout Settings
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   ## Use a customized bootstrap theme
                   theme = 'bootstrap.css',
                   collapsible = TRUE,
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "About"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   tabPanel("About", includeMarkdown("doc/intro.md"), tags$style('.leaflet {height: 600px;}')),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "Load Data"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   tabPanel("Load data", tags$style('.leaflet {height: 600px;}'),
                            sidebarLayout(
                              sidebarPanel(
                                fileInput('file1', 'Choose CSV File',
                                          accept=c('text/csv', 
                                                   'text/comma-separated-values,text/plain', 
                                                   '.csv')),
                                tags$hr(),
                                checkboxInput('header', 'Header', TRUE),
                                radioButtons('sep', 'Separator',
                                             c(Comma=',',
                                               Semicolon=';',
                                               Tab='\t'),
                                             ','),
                                radioButtons('quote', 'Quote',
                                             c(None='',
                                               'Double Quote'='"',
                                               'Single Quote'="'"),
                                             '"'),
                                tags$hr()#,
                                #conditionalPanel(
                                #  'input.dataset === "Dataset"',
                                #  checkboxGroupInput('show_vars', 'Columns in dataset to show:',
                                #                     names(tableOutput('names')), selected = names(tableOutput('names'))
                                #                     )
                                #)
                              ),
                              mainPanel(
                                tags$hr(),
                                  tabPanel('Dataset', DT::dataTableOutput('contents'))
                              )
                            )
                          ),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "Univariate Analysis"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   tabPanel("Univariate Analysis",
                            sidebarLayout(
                              sidebarPanel(
                                selectizeInput('inSelectInput', "Choose an attribute:", choices = names(tableOutput('contents')))
                              ),
                              mainPanel(
                                tags$hr(),
                                h1('Summary'),
                                tags$hr(),
                                tableOutput("summary"), 
                                tags$hr(),
                                h1('Histogram'),
                                tags$hr(),
                                sliderInput("bins", "Number of bins:", min = 1, max = 50, value = 10),
                                plotlyOutput("histPlot"),
                                tags$hr(),
                                h1('Box plot'),
                                tags$hr(),
                                plotlyOutput("boxPlot")
                              )
                            )
                    ),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "Bivariate Analysis"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   tabPanel("Bivariate Analysis",
                            sidebarLayout(
                              sidebarPanel(
                                selectizeInput('inSelectPairInputx', "Choose the explanatory variable (X axis):", choices = names(tableOutput('contents'))),
                                selectizeInput('inSelectPairInputy', "Choose the response variable (Y axis):", choices = names(tableOutput('contents')))
                              ),
                              mainPanel(
                                tags$hr(),
                                h1('Scatter Plot'),
                                tags$hr(),
                                plotlyOutput("scatPlot"),
                                tags$hr(),
                                h1('Basic Time Series Plot with Loess Smooth'),
                                tags$hr(),
                                plotlyOutput("timeloessPlot"),
                                tags$hr(),
                                h1('Line Interpolation Options Plot'),
                                tags$hr(),
                                plotlyOutput("linePlot"),
                                tags$hr(),
                                h1('Pair Correlation Plot'),
                                tags$hr(),
                                plotlyOutput("corrpairPlot"),
                                tags$hr()
                              )
                            )
                   ),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "Multivariate Analysis"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   
                   tabPanel("Multivariate Analysis",
                            #sidebarLayout(
                              #sidebarPanel(
                              #  selectizeInput('inSelectMultiInputx', "Choose the X variable:", choices = names(tableOutput('contents'))),
                              #  selectizeInput('inSelectMultiInputy', "Choose the Y variable:", choices = names(tableOutput('contents')))
                              #),
                              mainPanel(
                                #tags$hr(),
                                #h1('Box plot - Multi'),
                                #plotlyOutput('boxmultiPlot'),
                                tags$hr(),
                                p('Please wait ... it takes some seconds to load the plots.'),
                                tags$hr(),
                                h1('Correlation Plot'),
                                tags$hr(),
                                plotOutput("corrmultiPlot"),
                                tags$hr(),
                                h1('Correlation Plot 2'),
                                tags$hr(),
                                plotOutput("corrmultiPlot2"),
                                tags$hr()
                              )
                            #)
                   ),
                   
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   ## Tab "More"
                   ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                   
                   navbarMenu("More", 
                              tabPanel("Code", includeMarkdown("doc/code.md")),
                              tabPanel("Contact", includeMarkdown("doc/contact.md"))
                   )
                   
))
