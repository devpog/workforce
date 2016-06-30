# Source hub

folders <- list.files(source_dir, full.names = T)

for(folder in folders)
  for(f in list.files(folder, full.names = T, pattern = "\\.R$"))
    source(f, local = T)