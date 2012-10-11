require 'active-fedora'
require "#{File.dirname(__FILE__)}/disk_asset"
#Include all the models and files...
Dir.glob(File.dirname(__FILE__) + '../app/models/*') {|file| require file}

require "../app/models/mods_generic_content"
require '../app/models/generic_content'
require "../app/models/mods_generic_content"
require '../app/models/structural_set'

class HydraUtils
	
	def self.deposit_tree_of_disk_assets(tree_of_disk_assets)

		if tree_of_disk_assets.is_a? Tree::TreeNode
			# ..... This is a depth-first and L-to-R pre-ordered traversal.
			tree_of_disk_assets.each do |node| 
				#Lets go through and turn each into a respective Fedora object...
				deposit_asset(node)
				#deposit
			end
		end


		 #@structural_set = StructuralSet.new(params[:structural_set])	

	end
 
 	private 

 	def self.deposit_asset(disk_asset_node) 

 		ActiveFedora.init(:fedora_config_path => "../config/fedora.yml")

 		#puts "Parent node:" +  disk_asset_node.parent.to_s
 		disk_asset = disk_asset_node.content 

 		puts "Asset name: #{disk_asset.asset_name}"
 		#puts "Path: #{disk_asset.path} | Name: #{disk_asset.asset_name} | Directory: #{disk_asset.is_directory} | Fedora PID: #{disk_asset.fedora_pid} " 
		
 		if (disk_asset.is_directory)
 			# => set = StructuralSet.new



 		else


 		end

		#GenericContent.new
		

#		test = GenericContent.new

#		test.save 
 	end

 	def self.deposit
 		puts "Path: "
 	end
end

