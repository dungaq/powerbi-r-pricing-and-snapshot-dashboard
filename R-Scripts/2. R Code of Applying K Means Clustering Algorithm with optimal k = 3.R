library(dplyr)
library(cluster)

df <- dataset

svc_col  <- "servicerequired"        
hour_col <- "projectEstimatedHours"     

need <- c("projectId","Status","projectEstimatedCost", svc_col, hour_col)
miss <- setdiff(need, names(df))

to_num <- function(x){
  x <- gsub("[^0-9\\.-]", "", as.character(x))
  suppressWarnings(as.numeric(x))
}

safe_scale <- function(m){
  m <- as.matrix(m)
  for (j in seq_len(ncol(m))) {
    mu <- mean(m[, j], na.rm = TRUE)
    sdv <- sd(m[, j], na.rm = TRUE)
    if (is.na(sdv) || sdv == 0) sdv <- 1
    m[, j] <- (m[, j] - mu) / sdv
  }
  m
}

df2 <- df %>%
  mutate(
    projectId_chr = as.character(projectId),
    svc           = .data[[svc_col]],
    cost_num      = to_num(projectEstimatedCost),
    hrs_num       = to_num(.data[[hour_col]]),
    is_closed     = Status == "Closed",
    cost_ok       = is.finite(cost_num) & cost_num > 0,
    hrs_ok        = is.finite(hrs_num) & hrs_num >= 0,     
    svc_ok        = !is.na(svc) & nzchar(as.character(svc))
  )

work <- df2 %>% filter(is_closed & cost_ok & hrs_ok & svc_ok)

cluster_one <- function(g){
  if (nrow(g) < 3) {
    return(data.frame(projectId_chr=g$projectId_chr,
                      Complexity_Label=NA_integer_,
                      Complexity_NA_Reason="group<3"))
  }
  X <- safe_scale(g[, c("cost_num","hrs_num")])
  set.seed(42); km <- kmeans(X, centers=3, nstart=50)
  
  centers <- km$centers
  score <- rowMeans(centers)              
  ord <- order(score); map <- integer(3); map[ord] <- 1:3
  lbl <- as.integer(map[km$cluster])
  
  data.frame(projectId_chr=g$projectId_chr,
             Complexity_Label=lbl,
             Complexity_NA_Reason=NA_character_)
}

lab_list  <- lapply(split(work, work$svc), cluster_one)
labels_df <- if (length(lab_list)) dplyr::bind_rows(lab_list) else
  data.frame(projectId_chr=character(), Complexity_Label=integer(),
             Complexity_NA_Reason=character())

reasons <- df2 %>%
  filter(is_closed) %>%
  mutate(Complexity_NA_Reason = case_when(
    !svc_ok  ~ "missing_service",
    !cost_ok ~ "invalid_cost",
    !hrs_ok  ~ "invalid_actual_hours",    
    TRUE     ~ NA_character_
  )) %>%
  select(projectId_chr, Complexity_NA_Reason)

output <- df %>%
  mutate(projectId_chr = as.character(projectId)) %>%
  left_join(labels_df %>% select(projectId_chr, Complexity_Label), by="projectId_chr") %>%
  left_join(reasons, by="projectId_chr") %>%
  select(-projectId_chr)