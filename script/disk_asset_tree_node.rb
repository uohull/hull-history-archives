require 'tree' 

class DiskAssetTreeNode < Tree::TreeNode
	attr_accessor :collection_reference_code, :accession_number
	
	def initialize(name, content, collection_reference_code = nil, accession_number = nil)
		super(name, content)
		@collection_reference_code, @accession_number = collection_reference_code, accession_number
	end

	 def save_to_disk(directory)
	 	file_path = directory << @collection_reference_code << "-" << @accession_number
	 	formatted_file_path = DiskAssetTreeNode.format_file_path(file_path)
	
	 	File.open(formatted_file_path, "wb") do |f| 
	 		f.write(marshal_dump)
	 	end
	end
	
	def self.load_from_disk(directory, collection_reference_code, accession_number )
	 	file_path = directory << collection_reference_code << "-" << accession_number
	 	formatted_file_path = format_file_path(file_path)

	 	disk_asset_tree_node_obj = nil

	 	if File.exists?(formatted_file_path)
	 		contents = File.open(formatted_file_path, "rb") do |f| 
	 			f.read
	 		end
	 		#Use marhall_load to take the array - Eval will turn "[1,2,3]" to [1,2,3]
			disk_asset_tree_node_obj =marshal_load(eval(contents))
	 	end

	 	return disk_asset_tree_node_obj
	end

	private

	def marshal_dump
		#Call TreeNode marshal_dump to get the array rep of the Tree
		dump = super
		#Insert the data from this class
		dump.insert(0, {:collection_reference_code => @collection_reference_code, :accession_number => @accession_number })
		return dump
	end

	def self.marshal_load(dumped_disk_tree_node)
		datn_obj = nil
		#First create a new DiskAssetTreeNode from the data dump..
		if dumped_disk_tree_node.size > 0 
			datn_hash = dumped_disk_tree_node[0]

			#Create an instance of DiskAssetTreeNode with the collection_reference_code and accession_number
			datn_obj = DiskAssetTreeNode.new("","", datn_hash[:collection_reference_code], datn_hash[:accession_number] )

			#Delete the DiskAssetTreeNode element from the dump
			dumped_disk_tree_node.delete_at(0)

			#Run the Tree::TreeNode.marshal_load method
			datn_obj.marshal_load(dumped_disk_tree_node)
		end
		
		return datn_obj
	end


	def self.format_file_path(file_path)
		file_path.gsub(' ', '_')
	end

end