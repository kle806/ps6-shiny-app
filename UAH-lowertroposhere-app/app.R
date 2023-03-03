# Loading libraries
library(shiny)
library(tidyverse)

# Load data
UAH <- read_delim("data/UAH-lower-troposphere-long.csv.bz2")
# Region names variable
regions <- c("aust", "globe", "globe_land", "globe_ocean", "nh", "nh_land", "nh_ocean",
             "noext", "noext_land", "noext_ocean", "nopol", "nopol_land", "nopol_ocean",
             "sh","sh_land", "sh_ocean", "soext", "soext_land", "soext_ocean", "sopol",
             "sopol_land", "sopol_ocean", "trpcs", "trpcs_land", "trpcs_ocean",
             "usa48", "usa49")

# UI
ui <- fluidPage(
  titlePanel("PS6 Shiny App"),
  
  #Info Panel
  tabsetPanel(
    tabPanel("Info", 
             titlePanel("Information"),
             p("This dataset was provided from the PS6 canvas assignment page."),
             p("The dataset contains information about global temperatures from 1978 to 2023."),
             p("Data points are taken from each month, each year at various different regions."),
             p("The regions are also split up into land and ocean temperatures.")
             ),
    
  #Plot Panel
    tabPanel("Plot", sidebarLayout(
      
      # Interactive widgets
      sidebarPanel(
        
        # Check boxes for regions
        checkboxGroupInput("region", label = "Choose region(s)",
                           choices = regions,
                           selected = "aust"
        ),
        
        #Slider range for year
        sliderInput("year_range", label = "Year Range",
                    min = min(UAH$year),
                    max = max(UAH$year),
                    value = c(1990,2010)
        )
      ),
      
      # Plot area
      mainPanel(
        plotOutput("plot")
        )
      )
    ),
    
    #Table panel
    tabPanel("Table", sidebarLayout(
      
      # Interactive widgets
      sidebarPanel(
        
        # Check boxes for regions
        checkboxGroupInput("region", label = "Choose region(s)",
                           choices = regions,
                           selected = "aust"
        ),
        
        #Slider range for year
        sliderInput("year_range", label = "Year Range",
                    min = min(UAH$year),
                    max = max(UAH$year),
                    value = c(1990,2010)
                    )
        ),
      mainPanel(
        dataTableOutput("table")
        )
      )
    )
  )
)

# Server
server <- function(input, output, region) {
  
  # Average temperature change over years by region line plot
  output$plot <- renderPlot({
    
    # Creating input
    region <- input$region
    
    # Plot of temperature by year by region
    UAH %>% 
      filter(region %in% input$region) %>% 
      filter(year >= input$year_range[1],
             year <= input$year_range[2]) %>% 
      group_by(year, region) %>%
      summarize(avg_temp_yearly = mean(temp)) %>% 
      ggplot(aes(x=year, y=avg_temp_yearly, color = factor(region)))+
      geom_line()+
      labs(x = "Year",
           y = "Average temperature",
           color = "Region")
  })
  
  # Interactive data table
  output$table <- renderDataTable({
    UAH %>% 
      filter(region %in% input$region) %>% 
      filter(year >= input$year_range[1],
             year <= input$year_range[2]) %>% 
      group_by(year, region) %>%
      summarize(avg_temp_yearly = mean(temp))
    
  })
}

# Run app
shinyApp(ui = ui, server = server)
