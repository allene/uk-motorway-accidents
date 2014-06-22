
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

title <- "UK Road accidents - Shiny application"

# load data for UI elements
# TODO : try to get these details from server
dataset <-read.csv("./accidents_subset.csv",sep=",",head=T)
uiyears <- c('-All-',sort (unique(unlist(dataset[1])),decreasing = TRUE))

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(title),
  
  # Sidebar with a UI components
  sidebarPanel (
    
    selectInput('year','Select Year', uiyears),
    
    radioButtons("xaxis", "X-axis:",
                 c("Year" = "byyear",
                   "Motorway" = "bymotorway",
                   "Month" = "bymonth"
                 )
                ),
    tags$div(class="header", checked=NA),
    tags$u("This shiny application crated for coursera project."),
    tags$p("Main objective of this application is to breakdown all accedents happend on UK Motorways scince 1979."),
    tags$p("Usage"),
    tags$ol(tags$li("Select year from dropdown (By default all is data is selected)"),
            tags$li("Select how you want to breakdown the data ( x-axis).")),
    tags$p("Data used for this shiny app is extract from ",
           tags$a(href="http://data.dft.gov.uk.s3.amazonaws.com/road-accidents-safety-data/Stats19-Data1979-2004.zip", "data.gov.uk")),
    tags$a(href="http://en.wikipedia.org/wiki/List_of_motorways_in_the_United_Kingdom", "Wiki page about UK Moterways")
  
  ),
  
  # Show a plot of the generated distribution
  
  mainPanel(
    plotOutput('plot',height="700px")
    )
)
)
