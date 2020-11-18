function(points_with_cluster_id,
         max_dist){

  buffers <- st_buffer(st_as_sf(points_with_cluster_id),max_dist/2) 
  buffers <- buffers %>% dplyr::group_by(cluster) %>%
    summarise(cluster_id = mean(cluster, na.rm = TRUE))
  
  as(buffers, "Spatial")
  
}
