require "#{File.dirname(__FILE__)}/disk_asset"
require 'ruby-debug'

class HydraUtils
	
	def self.deposit_tree_of_disk_assets(tree_of_disk_assets)

 		ActiveFedora.init(:fedora_config_path => "../config/fedora.yml")

		if tree_of_disk_assets.is_a? Tree::TreeNode
			# ..... This is a depth-first and L-to-R pre-ordered traversal.
			tree_of_disk_assets.each do |node| 
				#Lets go through and turn each into a respective Fedora object...
				deposit_asset(node)
				#deposit
				tree_of_disk_assets.save_to_disk("/opt/Test/")
			end
		end

		tree_of_disk_assets
	end
 
 	private 

 	def self.deposit_asset(disk_asset_node) 

 		#puts "Parent node:" +  disk_asset_node.parent.to_s
 		disk_asset = disk_asset_node.content 

 		#Lets get the node's parents object pid (unless it's the root node...)
 		unless disk_asset_node.is_root? 
 			parent_disk_asset_node =  disk_asset_node.parent
 			parent_fedora_pid = parent_disk_asset_node.content.fedora_pid
 		end
		
 		if (disk_asset.is_directory)
 	
 			set = StructuralSet.new

 			set.title = disk_asset.asset_name
 			add_relationship(set, :is_member_of, parent_fedora_pid) unless parent_fedora_pid.nil? 

 			#Save the changes...
 			save_success = set.save

 			if save_success
	 			disk_asset.fedora_pid =  set.pid
 			end

 		else
 			generic_content = GenericContent.new

 			generic_content.title = disk_asset.asset_name
			f = File.new(disk_asset.path, "r")

 			add_relationship(generic_content, :is_member_of, parent_fedora_pid) unless parent_fedora_pid.nil? 
 			add_file_ds(generic_content, disk_asset.asset_name, f, "content")

 			#We need to save the object so that Fedora generates some metadata...
 			generic_content.save

 			#Add last modified/access dates to object	
 			mod_date = f.mtime.iso8601
 			acc_date = f.atime.iso8601
			mod_date = "" if mod_date.nil? 
			acc_date = "" if acc_date.nil? 
			
			opts = {:last_modified => mod_date, :last_accessed => acc_date}

			generic_content.update_content_metadata(opts)
			generic_content.update_desc_metadata

 			save_success = generic_content.save

 			if save_success
 				disk_asset.fedora_pid = generic_content.pid
 			end

 		end
 	end

 	def self.add_relationship(hydra_asset, relationship, target)
 		hydra_asset.add_relationship(relationship, "info:fedora/" + target)
 	end

 	def self.add_file_ds(hydra_asset, file_name, file_location, dsid)
 		options = {:label=>file_name, :mimeType=>mime_type(file_name)}
 		options[:dsid] = dsid
 		hydra_asset.add_file_datastream(file_location, options)
 	end


 	def self.deposit
 		puts "Path: "
 	end

 	private
	# Return the mimeType for a given file name
	# @param [String] file_name The filename to use to get the mimeType
	# @return [String] mimeType for filename passed in. Default: application/octet-stream if mimeType cannot be determined
	def self.mime_type file_name
		mime_types = MIME::Types.of(file_name)
		mime_type = mime_types.empty? ? "application/octet-stream" : mime_types.first.content_type
	end
end

