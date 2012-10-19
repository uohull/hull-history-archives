require 'tree'                 # Load the library
require "#{File.dirname(__FILE__)}/disk_asset"
require "#{File.dirname(__FILE__)}/disk_asset_tree_node"

class DiskAssetTreeBuilder

	attr_accessor :collection_reference_code, :accession_number, :directory

	def initialize(directory, collection_reference_code, accession_number)
		@directory, @collection_reference_code, @accession_number = directory, collection_reference_code, accession_number
	end

	def build_tree
		root_disk_asset = DiskAsset.new(@directory, true, nil)
		root_node = DiskAssetTreeNode.new(root_disk_asset.asset_name, root_disk_asset, @collection_reference_code, @accession_number )
		
		walk_tree(directory, root_node)
		root_node
	end


	def walk_tree(directory, tree_node)
		Dir.open(directory).each do |name|	
			#Filter /. and /.. directories items
			unless (name.eql? "." ) || (name.eql? ".." )
				is_directory = File.directory?("#{directory}/#{name}")

				#sub_node = Tree::TreeNode.new(name, DiskAsset.new("#{directory}/#{name}", is_directory, nil), @collection_reference_code, @accession_number )
				sub_node = DiskAssetTreeNode.new(name, DiskAsset.new("#{directory}/#{name}", is_directory, nil), @collection_reference_code, @accession_number )
			
				tree_node <<  sub_node

				#If the disk_asset is a directory, walk the tree...
				if is_directory
					walk_tree("#{directory}/#{name}",  sub_node	  )					
				end

			end
		end

	end

end