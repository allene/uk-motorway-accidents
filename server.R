
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(ggplot2)

dataset <-read.csv("./accidents_subset.csv",sep=",",head=T)
acc_by_year <- aggregate(dataset$accidents, by=list(Year=dataset$year), FUN=sum)
colnames(acc_by_year)[2] <- "Accidents"

shinyServer(function(input, output) {
   
  output$plot <- renderPlot({
    
    if(input$xaxis == 'byyear') {
      
        if(input$year == '-All-') {
          title <- "UK Motorway accidents by year"
          details <- paste ("Total accidents on UK Moterways between 1979 and 2004 :",
                            sum(acc_by_year$Accidents))
          p <- ggplot(acc_by_year, aes(Year, Accidents)) 
          p <- p + geom_bar(stat = "identity",fill=acc_by_year$Year) 
          p <- p + theme(axis.text=element_text(size=12),
                         axis.title=element_text(size=14,face="bold"))
          p <- p + annotate("text", x = 1990, y = 10000,
                            label = details,
                            colour = "blue",face='bold', size=7)
          p <- p + ggtitle(title )
          p <- p + theme(plot.title = element_text(lineheight=.8, face="bold"))
        } else {
          acc_in_selected_year = acc_by_year[acc_by_year$Year == input$year,][,2]
          title <- paste ("UK Motorway accidents in year ",input$year) 
          details <- paste ("Total accidents on UK Moterways in ",
                            input$year, " : ", acc_in_selected_year)
          subset <- acc_by_year
          subset$Accidents <-0
          subset[subset$Year == input$year,2] <-acc_in_selected_year
          p <- ggplot(subset, aes(Year, Accidents)) 
          p <- p + geom_bar(stat = "identity",fill=subset$Year) 
          p <- p + theme(axis.text=element_text(size=12),
                         axis.title=element_text(size=14,face="bold"))
          p <- p + annotate("text", x = 1990, y = 10000,
                                       label = details,
                            colour = "blue",face='bold', size=7)
          p <- p + ggtitle(title )
          p <- p + theme(plot.title = element_text(lineheight=.8, face="bold"))
        }
    } else if(input$xaxis == 'bymotorway') {
      
      if(input$year == '-All-') {
        acc_by_motorway <- aggregate(dataset$accidents, by=list(Motorway=dataset$motorway), FUN=sum)
        colnames(acc_by_motorway)[2] <- "Accidents"
        mw <- acc_by_motorway$Motorway [order (acc_by_motorway$Accidents, decreasing = TRUE)]
        top10 = subset(acc_by_motorway, Motorway %in% mw [1:10])
        
        title <- "UK Worst 10 motorways 1979-2004"
        details <- paste ("Total accidents on UK Moterways between 1979 and 2004 :", sum(acc_by_year$Accidents))
        p <- ggplot(top10, aes(x=reorder(Motorway, -Accidents), Accidents)) 
        p <- p + geom_bar(stat = "identity",fill=as.numeric(top10$Motorway))
        p <- p + theme(axis.text=element_text(size=9,face="bold"),
                       axis.title=element_text(size=14,face="bold"),
                       axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
        p <- p + xlab("Moterway")
        p <- p + ggtitle(title )
        p <- p + theme(plot.title = element_text(lineheight=.8, face="bold"))
        p <- p + annotate("text", x=7 , y=25000,label = details,
                          colour = "blue",face='bold', size=7)          
      } else {
        title <- paste("UK Worst 10 motorways - ",input$year)
        acc = acc_by_year[acc_by_year$Year == input$year,][,2]
        acc_in_selected_year <- dataset[dataset$year == input$year, ]
        acc_in_selected_year_gp <- aggregate(acc_in_selected_year$accidents, by=list(Motorway=acc_in_selected_year$motorway), FUN=sum)
        colnames(acc_in_selected_year_gp)[2] <- "Accidents"
        details <- paste ("Total accidents on UK Moterways in ",input$year, " : ", acc)
        mw <- acc_in_selected_year_gp$Motorway [order (acc_in_selected_year_gp$Accidents, decreasing = TRUE)]
        top10 = subset(acc_in_selected_year_gp, Motorway %in% mw [1:10])
        p <- ggplot(top10, aes(x=reorder(Motorway, -Accidents), Accidents)) 
        p <- p + geom_bar(stat = "identity",fill=as.numeric(top10$Motorway)) 
        p <- p + theme(axis.text=element_text(size=9, face="bold"),
                       axis.title=element_text(size=14,face="bold"),
                       axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
        #p <- p + annotate("text", x = 1990, y = 10000,
        #                  label = details,
        #                  colour = "blue",face='bold', size=7)
        p <- p + xlab("Moterway")
        p <- p + ggtitle(title )
        p <- p + theme(plot.title = element_text(lineheight=.8, face="bold"))
        p <- p + annotate("text", x=7 , y=1500,label = details,
                          colour = "blue",face='bold', size=7)          
        
      }
      } else if(input$xaxis == 'bymonth') {
        
        if(input$year == '-All-') {
          acc_by_month <- aggregate(dataset$accidents, by=list(Month=dataset$month), FUN=sum)
          colnames(acc_by_month)[2] <- "Accidents"
          title <- "UK Motorway accidents by month"
          details <- paste ("Total accidents on UK Moterways between 1979 and 2004 :", sum(acc_by_year$Accidents))
          p <- ggplot(acc_by_month, aes(x=Month, Accidents)) 
          p <- p + geom_bar(stat = "identity",fill=acc_by_month$Month)
          p <- p + theme(axis.text=element_text(size=9,face="bold"),
                         axis.title=element_text(size=14,face="bold"),
                         axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
          p <- p + xlab("Month")
          p <- p + ggtitle(title )
          p <- p + theme(plot.title = element_text(lineheight=.8, face="bold"))
          p <- p + annotate("text", x=7 , y=20000,label = details,
                            colour = "blue",face='bold', size=7)          
        } else {
          title <- paste("UK Motorway accidents by month in ",input$year)
          acc = acc_by_year[acc_by_year$Year == input$year,][,2]
          acc_in_selected_year <- dataset[dataset$year == input$year, ]
          acc_in_selected_year_gp <- aggregate(acc_in_selected_year$accidents, by=list(Month=acc_in_selected_year$month), FUN=sum)
          colnames(acc_in_selected_year_gp)[2] <- "Accidents"
          details <- paste ("Total accidents on UK Moterways in ",input$year, " : ", acc)
          p <- ggplot(acc_in_selected_year_gp, aes(x=Month, Accidents)) 
          p <- p + geom_bar(stat = "identity", fill=factor(acc_in_selected_year_gp$Month))
          p <- p + scale_fill_hue(l=40)
          p <- p + theme(axis.text=element_text(size=9, face="bold"),
                         axis.title=element_text(size=14,face="bold"),
                         axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
          #p <- p + annotate("text", x = 1990, y = 10000,
          #                  label = details,
          #                  colour = "blue",face='bold', size=7)
          p <- p + xlab("Month")
          p <- p + ggtitle(title )
          p <- p + theme(plot.title = element_text(lineheight=.8, face="bold"))
          p <- p + annotate("text", x=7 , y=1000,label = details,
                            colour = "blue",face='bold', size=7)          
          
        }
      }  
    print(p)
    
    
  })
  
})
