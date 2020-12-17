
library(shiny)
library(dplyr)
library(ggplot2)

covidOT <- read.csv("covid_over_time.csv")
covidOT$submission_date <- as.Date(covidOT$submission_date, "%m/%d/%Y")
states <- c("AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", 
            "FL", "FSM", "GA", "GU", "HI", "IA","ID", "IL", "IN", "KS", 
            "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MP", "MS", 
            "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "NYC",
            "OH", "OK", "OR", "PA", "PR", "PW", "RI", "RMI","SC", "SD", 
            "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY")

Theme = theme(
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    legend.title = element_text(size = 14)
    )

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    observeEvent(input$all, {
        updateCheckboxGroupInput(session, "states",
                                 label = "this is label",
                                 choices = as.list(states),
                                 selected = states,
                                 inline = TRUE)
        selection <- as.vector(input$states)
    })  
    
    observeEvent(input$none, {
        updateCheckboxGroupInput(session, "states",
                                 label = "this is label",
                                 choices = as.list(states),
                                 selected = NULL,
                                 inline = TRUE)
        selection <- as.vector(input$states)
    })
    
    # Default parameters
    v <- reactiveValues()
    v$d1 <- as.Date("2020-01-22")
    v$d2 <- as.Date("2020-12-13")
    v$graphType <- "Total cases"
    v$selection <- c("AK", "AL", "AR")
    
    # Refresh button changes default parameters
    observeEvent(input$refresh, {
        v$d1 <- as.Date(input$dates[1])
        v$d2 <- as.Date(input$dates[2])
        v$graphType <- input$yvar
        v$selection <- as.vector(input$states)
    }) 

    # Define plot output
    output$plot1 <- renderPlot({
        
        subdata <- covidOT[covidOT$state %in% v$selection,]
        subdata <- subdata[subdata$submission >= v$d1 & subdata$submission <= v$d2,]
        
        if(v$graphType == "Total cases"){
            # Total cases over time
            p <- ggplot(subdata, aes(x = submission_date, y = tot_cases, color = state)) + 
                geom_line() + xlab("Date") + ylab("Total Cases") + Theme
        }
        
        else if(v$graphType == "New cases"){
            # New cases over time:
            p <- ggplot(subdata, aes(x = submission_date, y = new_case, color = state)) + 
                geom_line() + xlab("Date") + ylab("New Cases") + Theme
        }
        
        else if(v$graphType == "Total death"){
            # Total death over time:
            p <- ggplot(subdata, aes(x = submission_date, y = tot_death, color = state)) + 
                geom_line() + xlab("Date") + ylab("Total Death") + Theme
        }
        
        else if(v$graphType == "New death"){
            # New death over time:
            p <- ggplot(subdata, aes(x = submission_date, y = new_death, color = state)) + 
                geom_line() + xlab("Date") + ylab("New Death") + Theme 
        }
        
        else{
            # Total death to cases ratio
            subdata$ratioTotal <- subdata$tot_death/subdata$tot_cases
            p <- ggplot(subdata, aes(x = submission_date, y = ratioTotal, color = state)) + 
                geom_line() + xlab("Date") + ylab("Cumulative Death to Total Cases Ratio") + Theme

        }
        p
    })
    
    output$text1 <- renderText(paste("Plot of Covid-19", tolower(input$yvar), "over time:"))

})
