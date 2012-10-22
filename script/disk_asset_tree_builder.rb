require 'tree'                 # Load the library
require "#{File.dirname(__FILE__)}/disk_asset"
require "#{File.dirname(__FILE__)}/disk_asset_tree_node"

class DiskAssetTreeBuilder

	attr_accessor :collection_reference_code, :accession_number, :directory

	def initialize(directory, collection_reference_code, accession_number)
		@directory, @collection_reference_code, @accession_number = directory, collection_reference_code, accession_number
	end

	def build_tree

		build_tree = true
		resume_deposit = false

		#If a tree status file already exists retrieve it...
		if DiskAssetTreeNode.status_file_exists(local_temporary_directory, @collection_reference_code, @accession_number)
			#Retrieve and return
			root_node = DiskAssetTreeNode.load_from_disk(local_temporary_directory, collection_reference_code, accession_number )
			resume_deposit = true
		else
			begin
				root_disk_asset = DiskAsset.new(@directory, true, nil)
				root_node = DiskAssetTreeNode.new(root_disk_asset.asset_name, root_disk_asset, @collection_reference_code, @accession_number, local_temporary_directory )

				walk_tree(directory, root_node)			

			rescue => e
		 		puts "There was an issue building the Disk asset tree."
		 		build_tree = false
		 	end

		 	if build_tree
		 		begin 
					#Lets save it to the disk...
					root_node.save_to_disk
				rescue => e
					puts "There was an issue saving the status temporary file"
					puts e.to_s
					build_tree = false
				end
		 	end
		 end

		return build_tree, root_node, resume_deposit
	end


	def walk_tree(directory, tree_node)
		Dir.open(directory).each do |name|	
			#Filter /. and /.. directories items
			unless (name.eql? "." ) || (name.eql? ".." )
				is_directory = File.directory?("#{directory}/#{name}")

				#sub_node = Tree::TreeNode.new(name, DiskAsset.new("#{directory}/#{name}", is_directory, nil), @collection_reference_code, @accession_number )
				sub_node = DiskAssetTreeNode.new(name, DiskAsset.new("#{directory}/#{name}", is_directory, nil), @collection_reference_code, @accession_number, local_temporary_directory)
			
				tree_node <<  sub_node

				#If the disk_asset is a directory, walk the tree...
				if is_directory
					walk_tree("#{directory}/#{name}",  sub_node	  )					
				end

			end
		end
	end

	def local_temporary_directory
		"/opt/Test/"
	end

end