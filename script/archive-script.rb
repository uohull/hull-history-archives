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
success, disk_asset_tree, resume_deposit = tree_builder.build_tree

#If the tree built correctly... 
if success 

	if resume_deposit
		puts "The Archive Deposit tool has detected that an attempt was made to import these objects into Hydra previously"
		puts ""
		#Print to screen the list of all assets and associated pids
		disk_asset_tree.each do |node| 
			puts "Path: #{node.content.path} | Directory: #{node.content.is_directory} | Fedora PID: #{node.content.fedora_pid} " 
		end	

		puts "The above is the Disk asset listing along with the associated Fedora persistant identifier"
		puts "Do you want to continue the import from the last failure? [y/n]"
	else
		disk_asset_tree.print_tree
		puts "Would you like to import this directory tree into Hydra [y/n]? "
	end

	continue = $stdin.gets.chomp

	if continue.downcase == "y"

	 	if 	HydraUtils.deposit_tree_of_disk_assets(disk_asset_tree)
	 		puts "The Hydra archive deposit finished successfully"
	 		#Status file is deleted
	 		disk_asset_tree.delete_status_file
	 	else
	 		puts "There was an issue depositing the file asset collection."
	 		puts "To retry this process, restart the application and enter the same Archive directory/Collection reference code/Archive accession number"
	 	end
	end

	puts "Would you like to see the File listing and associated Fedora persistant identifier [y/n]? "
	continue = $stdin.gets.chomp

	if continue.downcase == "y"
		disk_asset_tree.each do |node| 
			puts "Path: #{node.content.path} | Directory: #{node.content.is_directory} | Fedora PID: #{node.content.fedora_pid} " 
		end	
	end
end