require "#{File.dirname(__FILE__)}/disk_asset"
require 'ruby-debug'
require 'open3'
require 'time'

class HydraUtils
	
	def self.deposit_tree_of_disk_assets(tree_of_disk_assets)

 		ActiveFedora.init(:fedora_config_path => "../config/fedora.yml")

 		deposited_tree = true

		if tree_of_disk_assets.is_a? Tree::TreeNode

			puts "Depositing to Hydra"

			# This is a depth-first and L-to-R pre-ordered traversal.
			tree_of_disk_assets.each do |node| 

				#Lets go through and turn each into a respective Fedora object...
				if deposit_asset(node)
					tree_of_disk_assets.save_to_disk
					print "."
				else
					deposited_tree = false
					break
				end
			end

			puts ""

		end

		return deposited_tree
	end
 
 	private 

 	def self.deposit_asset(disk_asset_node) 

 		save_success = false

 		#puts "Parent node:" +  disk_asset_node.parent.to_s
 		disk_asset = disk_asset_node.content 

 		#If the disk_asset already has a fedora_pid, we shouldn't attempt to ingest! (crucial in deposit resumes)
 		if disk_asset.fedora_pid.nil?

	 		#Lets get the node's parents object pid (unless it's the root node...)
	 		unless disk_asset_node.is_root? 
	 			parent_disk_asset_node =  disk_asset_node.parent
	 			parent_fedora_pid = parent_disk_asset_node.content.fedora_pid
	 		end
		
	 		if (disk_asset.is_directory)
	 	
	 			begin 
		 			set = StructuralSet.new

		 			set.title = disk_asset.asset_name
		 			add_relationship(set, :is_member_of, parent_fedora_pid) unless parent_fedora_pid.nil? 

		 			#Save the changes...
		 			save_success = set.save

					#True if the object saves correctly...
		 			if save_success
		 				disk_asset.fedora_pid =  set.pid
	 				end

		 		rescue => e
		 			puts 'There was an issue depositing this asset to the Repository: "#{disk_asset.path}"' 
		 			puts e.to_s
		 		end
	 			
	 		else
	 			begin 
		 			generic_content = GenericContent.new

		 			generic_content.title = disk_asset.asset_name
					f = File.new(disk_asset.path, "r")

		 			add_relationship(generic_content, :is_member_of, parent_fedora_pid) unless parent_fedora_pid.nil? 
		 			add_file_ds(generic_content, disk_asset.asset_name, f, "content")

		 			#We need to save the object so that Fedora generates some metadata...
		 			generic_content.save
		
		 			mod_date = f.mtime.iso8601.nil? ? "" : f.mtime.iso8601
		 			acc_date = f.atime.iso8601.nil? ? "" : f.atime.iso8601
		 			created_date = f.ctime.iso8601.nil? ? "" : f.ctime.iso8601
					
					opts = {:date_last_modified => mod_date, :date_last_accessed => acc_date, :date_created => created_date }

					generic_content.update_content_metadata(opts)
					generic_content.update_desc_metadata

					#True if the object saves correctly...
		 			save_success = generic_content.save

		 			if save_success
		 				disk_asset.fedora_pid = generic_content.pid
		 			end

		 		rescue => e
		 			puts "There was an issue depositing this file to the Repository: " << disk_asset.path 
		 			puts e.to_s
		 		end
	 		end
	 	else
	 		#We set save success to true (even though it already existed within Fedora...)
	 		save_success = true
	 	end

 		return save_success
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

