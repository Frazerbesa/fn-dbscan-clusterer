library(dplyr)

function(centroids, dist) {
  
  # Voronoi tesselation
  voronoi <- 
    centroids %>% 
    st_geometry() %>%
    st_union() %>%
    st_voronoi() %>%
    st_collection_extract()
  
  # Put them back in their original order
  voronoi <-
    voronoi[unlist(st_intersects(centroids,voronoi))]
  
  # Keep the attributes
  result <- centroids
  
  # Intersect voronoi zones with buffer zones
  st_geometry(result) <-
    mapply(function(x,y) st_intersection(x,y),
           st_buffer(st_geometry(centroids),dist), 
           voronoi,
           SIMPLIFY=FALSE) %>%
    st_sfc(crs=st_crs(centroids))
  
  # Dissolve by cluster_id
  result <-
    result %>%
    st_set_precision(1000) %>% 
    group_by(cluster_id) %>% 
    summarise(cluster_id = mean(cluster_id, na.rm = TRUE))
  
  result
}
