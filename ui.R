library("shiny")
library("shinythemes")

# Define UI for application
shinyUI(
  fluidPage(theme = shinytheme("cerulean"),
    headerPanel(h1("Customer Segmentation", align='center')),
    #titlePanel("Masukan Data"),
        tabsetPanel(type = 'tabs',
                                
            tabPanel('Clustering', 
                     sidebarLayout(position = "left",
                                   sidebarPanel(
                                     textInput("Customer_ID", "Masukan Costumer ID"),
                                     textInput("Nama_Pelanggan", "Masukan Nama Pelanggan"),
                                     checkboxGroupInput(inputId='Gender', label='Gender', c('Pria','Wanita'), selected = NULL, inline = FALSE,width = NULL),
                                     numericInput(inputId='Age',label='Age', value = 5,min = NA, max = NA, step = NA,width = NULL),
                                     selectInput(inputId="Prof", label='profesi', c("Ibu Rumah Tangga","Mahasiswa","Pelajar","Professional","Wiraswasta")),
                                     selectInput(inputId="Tipe.Res", label='tipe_residen', c("Cluster","Sector")),
                                     numericInput(inputId='shop',label='nilai_belanja_setahun', value = 3.5,min = NA, max = NA, step = NA,width = NULL),
                                     actionButton("do", "Predict",class = "btn-primary")
                                   ),
                                   mainPanel( # output
                                     DT::dataTableOutput("Pred")
                                   )
                     )
                     
                     ),
                tabPanel('About')
                    
                    #textOutput("Pred")
                    ),
    hr(),
    print("Aar Riana 2020")
  )
)