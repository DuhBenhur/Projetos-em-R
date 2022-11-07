pacotes <- c("jsonlite","plotly","tidyverse","cluster","dendextend","factoextra","fpc",
             "gridExtra", "magrittr","esquisse","knitr","kableExtra")


if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for (i in 1:length(instalador)){
    install.packages(instalador, dependencies = T)
    break()
  }
  sapply(pacotes, require, character = T)
}else{
  sapply(pacotes, require, character = T)
}


json_base <- fromJSON('feminized_seeds.json')

summary(json_base)
glimpse(json_base)

json_base <- filter(json_base,Strain != "AlaskanThunderFuck" & Strain != "SweetIslandSkunkSeeds")

json_base$THC <- as.numeric(sub("%","",json_base$THC))

json_base$CBD <- as.numeric(sub("%","",json_base$CBD))

json_base$CBG <- as.numeric(sub("%","",json_base$CBG))

json_base$CBN <- as.numeric(sub("%","",json_base$CBN))

feminized_seeds <- select(json_base, everything(), -id) 

sum(is.na(feminized_seeds$CBD))
sum(is.na(feminized_seeds$CBN))
sum(is.na(feminized_seeds))

feminized_seeds <- feminized_seeds %>% 
  replace(is.na(.),0)




glimpse(feminized_seeds)

rownames(feminized_seeds) <- feminized_seeds[,1]
feminized_seeds <- feminized_seeds[,-1]

feminized_seeds.padronizado <- scale(feminized_seeds)


#Percentil

percentil_var <- function(x){
  percentil <- quantile(x, probs=c(0.25,0.50,0.75), type = 5, na.rm=T)
  return(percentil)
}


percentil_var(feminized_seeds$THC)
percentil_var(feminized_seeds$CBD)
#Calculando matriz de distancias

d <- dist(feminized_seeds.padronizado, method = "euclidean")
d


#DEFININDO O CLUSTER A PARTIR DO METODO ESCOLHIDO
#metodos disponiveis "average", "single", "complete" e "ward.D"

hc1 <- hclust(d, method = "single" )
hc2 <- hclust(d, method = "complete" )
hc3 <- hclust(d, method = "average" )
hc4 <- hclust(d, method = "ward.D" )

#DESENHANDO O DENDOGRAMA
plot(hc1, cex = 0.6, hang = -1)
plot(hc2, cex = 0.6, hang = -1)
plot(hc3, cex = 0.6, hang = -1)
plot(hc4, cex = 0.6, hang = -1)

rect.hclust(hc4, k = 3)

#COMPARANDO DENDOGRAMAS
#comparando o metodo average com ward

dend3 <- as.dendrogram(hc3)
dend4 <- as.dendrogram(hc4)
dend_list <- dendlist(dend3, dend4) 
#EMARANHADO, quanto menor, mais iguais os dendogramas sao
tanglegram(dend3, dend4, main = paste("Emaranhado =", round(entanglement(dend_list),2)))

#agora comparando o metodo single com complete
dend1 <- as.dendrogram(hc1)
dend2 <- as.dendrogram(hc2)
dend_list2 <- dendlist(dend1, dend2) 
#EMARANHADO, quanto menor, mais iguais os dendogramas sao
tanglegram(dend1, dend2, main = paste("Emaranhado =", round(entanglement(dend_list2),2)))


#Cluster não hierarquico

feminized_seeds.k2 <- kmeans(feminized_seeds.padronizado, centers = 2)

#Visualizar os clusters

fviz_cluster(feminized_seeds.k2, data = feminized_seeds.padronizado, main = "Cluster k2")


#Criando Clusters

feminized_seeds.k3 <- kmeans(feminized_seeds.padronizado, centers = 3)
feminized_seeds.k4 <- kmeans(feminized_seeds.padronizado, centers = 4)
feminized_seeds.k5 <- kmeans(feminized_seeds.padronizado, centers = 5)
feminized_seeds.k6 <- kmeans(feminized_seeds.padronizado, centers = 6)

tipo_geom <- "points"
#Criar graficos
G2 <- fviz_cluster(feminized_seeds.k2, geom = "text", data = feminized_seeds.padronizado) + ggtitle("k = 2")
G22 <- fviz_cluster(feminized_seeds.k2, geom = tipo_geom, data = feminized_seeds.padronizado) + ggtitle("k = 2")
G3 <- fviz_cluster(feminized_seeds.k3, geom = tipo_geom, data = feminized_seeds.padronizado) + ggtitle("k = 3")
G4 <- fviz_cluster(feminized_seeds.k4, geom = tipo_geom, data = feminized_seeds.padronizado) + ggtitle("k = 4")
G5 <- fviz_cluster(feminized_seeds.k5, geom = tipo_geom, data = feminized_seeds.padronizado) + ggtitle("k = 5")
G6 <- fviz_cluster(feminized_seeds.k6, geom = tipo_geom, data = feminized_seeds.padronizado) + ggtitle("k = 6")


#Imprimir graficos na mesma tela
grid.arrange(G2, G3, G4, G5, G6, nrow = 2)

grid.arrange(G2, G22, nrow = 2)

#VERIFICANDO ELBOW 
fviz_nbclust(feminized_seeds.padronizado, kmeans, method = "wss")+
  geom_vline(xintercept = 4, linetype = 6)


#Average silhouette for kmeans


fviz_nbclust(feminized_seeds.padronizado, kmeans, method = "silhouette")


fit <- data.frame(feminized_seeds.k4$cluster)

feminized_seeds_fit <- cbind(feminized_seeds, fit)


resumo_medio <- feminized_seeds_fit %>% 
  group_by(feminized_seeds.k4.cluster) %>% 
  summarise(n = n(),
            THC = mean(THC),
            CBD = mean(CBD),
            CBG = mean(CBG),
            CBN = mean(CBN)) %>% 
  ungroup() %>% droplevels(.)



resumo_mediano <- feminized_seeds_fit %>% 
  group_by(feminized_seeds.k4.cluster) %>% 
  summarise(n = n(),
            THC = median(THC),
            CBD = median(CBD),
            CBG = median(CBG),
            CBN = median(CBN)) %>% 
  ungroup() %>% droplevels(.)

clusGap(feminized_seeds.padronizado)

fviz_gap_stat(
  feminized_seeds.padronizado,
  linecolor = "azul de aço",
  maxSE = lista(método = "firstSEmax", SE.factor = 1)
)


gap_stat <- clusGap(feminized_seeds.padronizado, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 300)
print(gap_stat, method = "firstmax")
fviz_gap_stat(gap_stat)

