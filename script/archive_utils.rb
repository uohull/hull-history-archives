require 'tree'                 # Load the library
require "#{File.dirname(__FILE__)}/disk_asset"

class ArchiveUtils

	def self.build_tree(directory)
		root_disk_asset = DiskAsset.new(directory, true, nil)
		root_node = Tree::TreeNode.new(root_disk_asset.asset_name, root_disk_asset)
		walk_tree(directory,root_node)
		root_node
	end


	def self.walk_tree(directory, tree_node)
		Dir.open(directory).each do |name|	
			#Filter /. and /.. directories items
			unless (name.eql? "." ) || (name.eql? ".." )
				is_directory = File.directory?("#{directory}/#{name}")

				if is_directory
					sub_node = Tree::TreeNode.new(name, DiskAsset.new("#{directory}/#{name}", is_directory, nil))
					tree_node <<  sub_node				
					walk_tree("#{directory}/#{name}",  sub_node	  )					
				end 
			end
		end

	end

end

