# Loading libraries
library(shiny)
library(tidyverse)

# Loading data
streaming <- read_delim("data/streaming-platform-data.csv")
streaming_services <- c("Netflix", "Hulu", "Prime Video", "Disney+")


# UI
ui <- fluidPage(
  
  # Title
  titlePanel("PS6 Shiny App"),
  
  tabsetPanel(
    
    # Info Panel
    tabPanel("Info",
             titlePanel("Streaming Services"),
             h3("Dataset Information:"),
             p("This is the same dataset that my group chose for the final project."),
             p("The dataset covers four notable streaming services; ", 
               em("Netflix, Hulu, Prime Video, and Disney+.")),
             p("The dataset was collected through data scraping 
               from these four streaming services in 2021 through early 2022 
               and published on ",
               a("Kaggle", href= 'https://www.kaggle.com/datasets/ruchi798/movies-on-netflix-prime-video-hulu-and-disney')),
             p("It contains the entire movie catalog of the four streaming services, 
               with information of the movie name, 
               what year it was from, the age rating, 
               Rotten tomatoes rating, 
               and whether it was available on that particular service 
               (represented with 1 or 0)."),
             p("Here is a small random sample of data:"),
             tableOutput("sample_table")
             ),
    
    # Plot Panel
    tabPanel("Plot", 
             titlePanel("Plot"),
             p("Histogram Description:"),
             p("These histograms contain data of each streaming service's movie catalog in 2021 to early 2022. 
        The histogram's bins on the x axis represent the Rotten Tomatoes rating given to each movie. Ratings are points from 0 to 100.
        The histogram's bins on the x axis represent the ",
            a("Rotten Tomatoes rating", href= 'https://www.rottentomatoes.com/about#:~:text=When%20at%20least%2060%25%20of,to%20indicate%20its%20Fresh%20status.&text=When%20less%20than%2060%25%20of,to%20indicate%20its%20Rotten%20status.'),
            "given to each movie. Ratings are points from 0 to 100.
        The height of each bin corresponds to how many movies have gotten that rating.
        The color scale on the bins are another way to depict the ratings. Green corresponds to higher ratings while red are lower ratings."),
    
             sidebarLayout(
      
      # Widgets
      sidebarPanel(
        
        # Choose service
        selectInput("service", "Streaming service:", streaming_services,
                    selected = "Netflix"),
        
        # Choose color fill
        radioButtons("palette1", "Choose color for low end:",
                     choices = c("red", "orange", "yellow"),
                     selected = "red"),
        
        radioButtons("palette2", "Choose color for high end:",
                     choices = c("green", "blue", "purple"),
                     selected = "green")
        ),
      
      # Plot
      mainPanel(plotOutput("distPlot")
        )
      ),
      
      # Text that changes according to what option is selected
      h2(textOutput("selected_service"))
      
      ),
    
    # Table Panel
    tabPanel("Table",
             titlePanel("Table"),
             p("This is where plot goes"),
             sidebarLayout(
               
               # Widgets
               sidebarPanel(
                 
                 # Select service
                 selectInput("service", "Streaming service:", streaming_services,
                                        selected = "Netflix")
               ),
               
               # Table
               mainPanel(dataTableOutput("table"))
               )
             )
    )
  )

#Server
server <- function(input, output, session) {
  
  streaming$modified_ratings <- as.numeric(
    str_remove(streaming$`Rotten Tomatoes`, "/100"))
  
  # Reactive text in plot panel
  output$selected_service <- renderText({
    paste("You have selected the", input$service, "histogram.")
  })
  
  # Creating histogram plot
  output$distPlot <- renderPlot({
    
    # generate streaming service name based on input$service from ui.R
    service <- input$service
    
    # generate color palette
    palette1 <- input$palette1
    palette2 <- input$palette2
    
    # draw the histogram for the specified streaming service
    streaming %>% 
      filter(!is.na(modified_ratings)) %>% 
      filter(!!as.symbol(service) == 1) %>% 
      ggplot(aes(x = modified_ratings))+
      geom_bar(stat = "count", aes(fill = ..x..))+
      scale_fill_gradient(low=palette1, high=palette2) +
      labs(title=service,
           x = "Rotten Tomatoes Rating",
           y = 'Movie count',
           fill = "Ratings")
  })
  
  # Sample table for info panel
  output$sample_table <- renderTable({
    streaming %>% 
      sample_n(5) %>% 
      select(Title, Age, Year, `Rotten Tomatoes`, Netflix, Hulu, `Prime Video`, `Disney+`)
  })
  
  # Table panel
  output$table <- renderDataTable({
    
    # Service input
    service <- input$service
    
    # Table
    streaming %>% 
      filter(!is.na(modified_ratings)) %>% 
      filter(!!as.symbol(service) == 1) %>% 
      group_by(Year) %>% 
      summarise(avg_rating = mean(modified_ratings)) %>% 
      arrange(Year)
  })
}

# Load shiny app
shinyApp(ui = ui, server = server)

