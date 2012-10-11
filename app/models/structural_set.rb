require 'tree'

class StructuralSet < ActiveFedora::Base

	#include Hydra::ModelMixins::CommonMetadata
	#include Hydra::ModelMethods
	has_metadata :name => 'descMetadata', :type => ModsGenericContent

	delegate :title, :to => 'descMetadata', :at => [:mods, :titleInfo, :title], :unique => true
	delegate :author, :to => 'descMetadata', :at => [:name, :namePart], :unique => true
	delegate :description, :to => 'descMetadata', :at => [:description], :unique => true
	delegate :admin_note, :to => 'descMetadata', :at => [:admin_note], :unique => true
	delegate :additional_notes, :to => 'descMetadata', :at => [:additional_notes], :unique => true

	def self.tree
	    hits = retrieve_structural_sets
	    sets = build_array_of_parents_and_children(hits)
    	root_node = build_children(Tree::TreeNode.new("Root set", "info:fedora/hull:rootSet"), sets)
  	end

	private 
	def self.retrieve_structural_sets
		fields = "has_model_s:info\\:fedora/afmodel\\:StructuralSet"
    	options = {:field_list=>["id", "id_t", "title_t", "is_member_of_s"], :rows=>10000, :sort=>[{"system_create_dt"=>:ascending}]}
    	ActiveFedora::SolrService.instance.conn.query(fields,options).hits
	end

	def self.structural_set_pids
		retrieve_structural_sets.map {|hit| "info:fedora/#{hit["id_t"]}" }
	end

	def self.build_array_of_parents_and_children hits
	    pids = hits.map {|hit| "info:fedora/#{hit["id_t"]}" }
	    sets = hits.each.inject({}) do |hash,hit|
	      if  hit["id_t"].first  != "hull:rootSet"
	        parent_pid = hit["is_member_of_s"].first if hit.fetch("is_member_of_s",nil)
	        if parent_pid && pids.include?( parent_pid )
	          hash[parent_pid] = {:children=>[]} unless hash[parent_pid]
	          hash[parent_pid][:children] << hit
	        end
	      end
	      hash
	    end
	end

	def self.build_children node, nodes
	    if nodes.fetch(node.content,nil)
	      nodes[node.content][:children].each do |child|
	        child_node = Tree::TreeNode.new(child["title_t"].first,"info:fedora/#{child["id_t"].first}")
	        node << build_children(child_node, nodes)
	      end
	    end
	    node
  	end
end  	

class Tree::TreeNode
	def options_for_nested_select(options=[],level=0)
		if is_root?
			pad = ''
		else
			pad = ('-' * (level - 1) * 2) + '--'
		end

		options <<  ["#{pad}#{name}", "#{content}"]

		#Sort the children - defaults on name sort
		children.sort! if !children.nil?	

		children { |child| child.options_for_nested_select(options,level + 1)}

		options
	end

	def unordered_list(options=[],level=0)

	end
end