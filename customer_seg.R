#read data
pelanggan <- read.csv("customer_segments.txt",sep="\t")
summary(pelanggan)
#convert to numeric
pelanggan_matrix <- data.matrix(pelanggan[c("Jenis.Kelamin", "Profesi", "Tipe.Residen")])
#merge data
pelanggan <- data.frame(pelanggan, pelanggan_matrix)
pelanggan
#Normalize
pelanggan$NilaiBelanjaSetahun <- pelanggan$NilaiBelanjaSetahun/1000000
#Mengisi data master
Profesi <- unique(pelanggan[c("Profesi","Profesi.1")])
Jenis.Kelamin <- unique(pelanggan[c("Jenis.Kelamin","Jenis.Kelamin.1")])
Tipe.Residen <- unique(pelanggan[c("Tipe.Residen","Tipe.Residen.1")])
Profesi
#Bagian K-Means
atribut_yang_digunakan = c("Jenis.Kelamin.1", "Umur", "Profesi.1", "Tipe.Residen.1", "NilaiBelanjaSetahun")
set.seed(100)
#find the best k for clustering
sse <- sapply(1:10,
              function(param_k)
              {
                kmeans(pelanggan[atribut_yang_digunakan], param_k, nstart=25)$tot.withinss
              }
)
jumlah_cluster_max <- 10
ssdata = data.frame(cluster=c(1:jumlah_cluster_max),sse)
ggplot(ssdata, aes(x=cluster,y=sse)) +
  geom_line(color="red") + geom_point() +
  ylab("Within Cluster Sum of Squares") + xlab("Jumlah Cluster") +
  geom_text(aes(label=format(round(sse, 2), nsmall = 2)),hjust=-0.2, vjust=-0.5) +
  scale_x_discrete(limits=c(1:jumlah_cluster_max))
#fungsi kmeans untuk membentuk 5 cluster dengan 25 skenario random dan simpan ke dalam variable segmentasi
segmentasi <- kmeans(x=pelanggan[atribut_yang_digunakan], centers=5, nstart=25)
#tampilkan hasil k-means
segmentasi
#Penggabungan hasil cluster
segmentasi$cluster
pelanggan$cluster <- segmentasi$cluster
str(pelanggan)
#Analisa hasil
#Filter cluster ke-1
which(pelanggan$cluster == 1)
length(which(pelanggan$cluster == 2))
#Melihat data cluster ke-1
pelanggan[which(pelanggan$cluster == 2),]
#Melihat cluster means dari objek 
segmentasi$centers

Segmen.Pelanggan <- data.frame(cluster=c(1,2,3,4,5), Nama.Segmen=c("Diamond Senior Member", "Silver Mid Professional",  "Silver Youth Gals", "Diamond Professional",  "Gold Young Professional"))
Segmen.Pelanggan
#Menggabungkan seluruh aset ke dalam variable Identitas.Cluster
Identitas.Cluster <- list(Profesi=Profesi, Jenis.Kelamin=Jenis.Kelamin, Tipe.Residen=Tipe.Residen, Segmentasi=segmentasi, Segmen.Pelanggan=Segmen.Pelanggan, atribut_yang_digunakan=atribut_yang_digunakan)
Identitas.Cluster
#menimpan objek dlm bentuk file
saveRDS(Identitas.Cluster,"cluster.rds")
