
#hint: try ?builder

library(shiny)

states <- c("AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", 
            "FL", "FSM", "GA", "GU", "HI", "IA","ID", "IL", "IN", "KS", 
            "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MP", "MS", 
            "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "NYC",
            "OH", "OK", "OR", "PA", "PR", "PW", "RI", "RMI","SC", "SD", 
            "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid-19 US Data Visualizer"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(

        sidebarPanel(
                h3("Options:"),

        dateRangeInput("dates",
                "Select date range:",
                 start = "2020-01-22",
                 end = "2020-12-13"),

        selectInput("yvar", "Select graph type:",
                    choices = list("Total cases", "New cases", "Total death", "New death", "Death/total ratio"),
                    selected = "Total cases",
                    multiple = FALSE, selectize = TRUE),

        checkboxGroupInput("states",
                           "Select state(s)/region(s):",
                           choiceNames = as.list(states),
                           choiceValues = as.list(states),
                           selected = c("AK", "AL", "AR"),
                           inline = TRUE
                           ),
        
        actionButton("all","Select All"),
        actionButton("none","Unselect All"),
        actionButton("refresh","Refresh",
                     icon("refresh")),

        width = 4
        ),

        mainPanel(
            h4(textOutput("text1")),
            h5("Last update: 12-17-2020"),
            plotOutput("plot1"),
            em("Note: this app is created as a project for the Coursera Developing Data Products 
                course.
               The dataset is obtained from the CDC (Centers for Disease Control and Prevention) website."),
            h3(" "),
            em(tagList("Data source:", a("CDC Covid-19 Data", 
                              href="https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36"))),
            width = 8
            )
        )
    )
)
