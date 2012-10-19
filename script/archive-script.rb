# encoding: utf-8

require '../config/environment'

require 'tree'
require "#{File.dirname(__FILE__)}/archive_utils"
require "#{File.dirname(__FILE__)}/hydra_utils"
require "#{File.dirname(__FILE__)}/disk_asset_tree_builder"
require "#{File.dirname(__FILE__)}/disk_asset_tree_node"

puts "Enter the directory that you want to Archive [/opt/test/]:"
root_directory = $stdin.gets.chomp

puts "Enter the archive collection reference code:"
col_ref_code = $stdin.gets.chomp

puts "Enter the archive accession number:"
acc_no = $stdin.gets.chomp


#Tree Builder takes the root director, collection reference number and the accession number
tree_builder = DiskAssetTreeBuilder.new(root_directory, col_ref_code, acc_no)
#Builds the tree of directories and files....
disk_asset_tree = tree_builder.build_tree

#Lets save it to the disk...
disk_asset_tree.save_to_disk("/opt/Test/")


disk_asset_tree.print_tree

puts "Would you like to import this directory tree into Hydra [y/n]? "
continue = $stdin.gets.chomp

if continue.downcase == "y"
	HydraUtils.deposit_tree_of_disk_assets(disk_asset_tree)
end

#@structural_set = StructuralSet.new(params[:structural_set])
puts "Would you like to see file listing [y/n]? "
continue = $stdin.gets.chomp

if continue.downcase == "y"
	disk_asset_tree.each do |node| 
		puts "Path: #{node.content.path} | Directory: #{node.content.is_directory} | Fedora PID: #{node.content.fedora_pid} " 
	end	
end



def process_folder(folder)
	

end

def deposit_folder_to_hydra(folder)
  folder
end

def deposit_file_to_hydra(file)
	file
end




