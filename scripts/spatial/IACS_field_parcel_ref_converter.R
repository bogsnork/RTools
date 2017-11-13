#Convert IACS parcel ref to and from grid ref
#see: http://www.natureonthemap.naturalengland.org.uk/Help_iacs.htm

#Grid Ref: e.g. NY12344321 format = paste0("LL", "xx1", "xx2", "yy1", "yy2")
#Parcel ref; e.g. NY12433412 format = paste0("LL", "xx1", "yy1", "xx2", "yy2")

#Import data

fep_data <- read.csv("some_fep_data.csv", header = TRUE)

#make vector to convert

parcel_refs <-    fep_data$Parcel.Reference #a vector of parcel references
 
   #or
#grid_refs <-      #a vector of grid references
  

#convert vector  

grid_refs <-  paste0(substr(parcel_refs, 1, 4), #grid letters and first two x coords 
                     substr(parcel_refs, 7, 8), #next two x coords 
                     substr(parcel_refs, 5, 6), #first two y coords
                     substr(parcel_refs, 9, 10))#next two y coords

# parcel_refs <- paste0(substr(grid_refs, 1, 4),  #grid letters and first two parcel ref numbers 
#                        substr(grid_refs, 7, 8), #next two parcel ref
#                        substr(grid_refs, 5, 6), #next two parcel ref
#                        substr(grid_refs, 9, 10))#next two parcel ref
