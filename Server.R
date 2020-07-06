library("shiny")
library("readr")
pelanggan <- read.csv("https://academy.dqlab.id/dataset/customer_segments.txt",sep="\t")
#mymodel<-svm(Target~., data=mydata, kernel="radial")
# Define server logic required to generate and plot a random distribution
shinyServer(function (input,output) {
  observeEvent(input$do, {
    databaru <- 
      data.frame("Umur"=input$Age,
                 "Jenis.Kelamin"=input$Gender,
                 "Profesi"=input$Prof,
                 "Tipe.Residen"=input$Tipe.Res,
                 "NilaiBelanjaSetahun"=input$shop
                  )
      #Konversi data menjadi numerik
      pelanggan_matrix <- data.matrix(pelanggan[c("Jenis.Kelamin", "Profesi", "Tipe.Residen")])
      #Penggabungan data
      pelanggan <- data.frame(pelanggan, pelanggan_matrix)
      #Normalisasi Nilai
      pelanggan$NilaiBelanjaSetahun <- pelanggan$NilaiBelanjaSetahun/1000000
      #Mengisi data master
      Profesi <- unique(pelanggan[c("Profesi","Profesi.1")])
      Jenis.Kelamin <- unique(pelanggan[c("Jenis.Kelamin","Jenis.Kelamin.1")])
      Tipe.Residen <- unique(pelanggan[c("Tipe.Residen","Tipe.Residen.1")])
      #Bagian K-Means
      atribut_yang_digunakan = c("Jenis.Kelamin.1", "Umur", "Profesi.1", "Tipe.Residen.1", "NilaiBelanjaSetahun")
      set.seed(100)
      #fungsi kmeans untuk membentuk 5 cluster dengan 25 skenario random dan simpan ke dalam variable segmentasi
      segmentasi <- kmeans(x=pelanggan[atribut_yang_digunakan], centers=5, nstart=25)
      Segmen.Pelanggan <- data.frame(cluster=c(1,2,3,4,5), Nama.Segmen=c("Diamond Senior Member", "Silver Mid Professional",  "Silver Youth Gals", "Diamond Professional",  "Gold Young Professional"))
      #Menggabungkan seluruh aset ke dalam variable Identitas.Cluster
      Identitas.Cluster <- list(Profesi=Profesi, Jenis.Kelamin=Jenis.Kelamin, Tipe.Residen=Tipe.Residen, Segmentasi=segmentasi, Segmen.Pelanggan=Segmen.Pelanggan, atribut_yang_digunakan=atribut_yang_digunakan)
      
      databaru <- merge(databaru, Identitas.Cluster$Profesi)
      databaru <- merge(databaru, Identitas.Cluster$Jenis.Kelamin)
      databaru <- merge(databaru, Identitas.Cluster$Tipe.Residen)
      Prediksi <- Identitas.Cluster$Segmen.Pelanggan[which.min(sapply( 1:5, function( x ) sum( ( databaru[Identitas.Cluster$atribut_yang_digunakan] - Identitas.Cluster$Segmentasi$centers[x,])^2 ) )),]
      output$Pred <- DT::renderDataTable(DT::datatable(Prediksi))
      #output$Pred <- renderPrint(databaru)
  })
   
   
})