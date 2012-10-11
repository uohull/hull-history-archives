require 'tree'


require "#{File.dirname(__FILE__)}/archive_utils"
require "#{File.dirname(__FILE__)}/hydra_utils"

root_directory = ARGV[0]

puts "Root directory is #{root_directory}"


directory_tree = ArchiveUtils.build_tree(root_directory)

HydraUtils.deposit_tree_of_disk_assets(directory_tree)




def process_folder(folder)
	

end

def deposit_folder_to_hydra(folder)
  folder
end

def deposit_file_to_hydra(file)
	file
end




