class GenericContent < ActiveFedora::Base

  #include Hydra::ModelMixins::CommonMetadata
  #include Hydra::ModelMethods

  has_metadata :name => 'descMetadata', :type => ModsGenericContent

  has_file_datastream :name => 'content', :type => ActiveFedora::Datastream

  delegate :title, :to => 'descMetadata', :at => [:mods, :titleInfo, :title], :unique => true
  delegate :author, :to => 'descMetadata', :at => [:name, :namePart], :unique => true
  delegate :description, :to => 'descMetadata', :at => [:description], :unique => true
  delegate :admin_note, :to => 'descMetadata', :at => [:admin_note], :unique => true
  delegate :additional_notes, :to => 'descMetadata', :at => [:additional_notes], :unique => true


end