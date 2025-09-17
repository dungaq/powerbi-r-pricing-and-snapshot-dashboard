library(dplyr)
library(cluster)
library(clusterCrit)
library(grid)

df <- dataset %>%
  filter(projectEstimatedCost > 0) %>%
  select(servicerequired, projectEstimatedCost, projectEstimatedHours) %>%
  na.omit()

results <- data.frame(servicerequired = character(),
                      K = integer(),
                      Silhouette = numeric(),
                      Davies_Bouldin = numeric())

for (service in unique(df$servicerequired)) {
  group_data <- df %>% filter(servicerequired == service)
  
  if (nrow(group_data) >= 3) {
    features <- scale(group_data[, c("projectEstimatedCost", "projectEstimatedHours")])
    
    max_k <- min(6, nrow(features) - 1)
    if (max_k >= 2) {
      for (k in 2:max_k) {
        km <- kmeans(features, centers = k, nstart = 25)
        sil_score <- silhouette(km$cluster, dist(features))
        sil_score <- mean(sil_score[, 3])
        db_index <- intCriteria(as.matrix(features),
                                as.integer(km$cluster),
                                "Davies_Bouldin")$davies_bouldin
        
        results <- rbind(results, data.frame(
          Service_Required = service,
          K = k,
          Silhouette = sil_score,
          Davies_Bouldin = db_index))
      }
    }
  }
}

grid::grid.newpage()
grid::grid.text(paste(capture.output(print(results)), collapse = "\n"),
                x = 0.05, y = 0.95, just = c("left", "top"))