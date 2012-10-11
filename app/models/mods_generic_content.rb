class ModsGenericContent < ActiveFedora::NokogiriDatastream

	#ModsGenericContent constants
	MODS_NS = 'http://www.loc.gov/mods/v3'
	MODS_SCHEMA = 'http://www.loc.gov/standards/mods/v3/mods-3-2.xsd'
	MODS_PARAMS = {
		'version'				=> '3.2',
		'xmlns:xlink'			=> 'http://www.w3.org/1999/xlink',
		'xmlns:xsi'				=> 'http://www.w3.org/2001/XMLSchema-instance',
		'xmlns'					=> MODS_NS,
		'xsi:schemaLocation'	=> '#{MODS_NS} #{MODS_SCHEMA}'
	}

	set_terminology do |t|
		t.root :path => 'mods', :xmlns => MODS_NS

		t.titleInfo(:path=>"titleInfo") {
      		t.title(:path=>"title", :label=>"title", :index_as=>[:facetable])
    	} 
    	t.name  {
      		t.namePart
      		t.role {
        		t.roleTerm
      		}
    	}
   
    	# Description is stored in the 'abstract' field 
    	t.description(:path=>"abstract")   
   
  		t.subject(:path=>"subject", :attributes=>{:authority=>"UoH"}) {
     		t.topic(:index_as=>[:facetable])
     		t.temporal
     		t.geographic
    	}

    	t.physical_description(:path=>"physicalDescription") {
	      	t.extent
    	  	t.mime_type(:path=>"internetMediaType")
      		t.digital_origin(:path=>"digitalOrigin")
    	}
    	t.admin_note(:path=>"note", :attributes=>{:type=>"admin"}) 
    	t.additional_notes(:path=>"note", :attributes=>{:type=>"additionalNotes"})

    	t.record_info(:path=>"recordInfo") {
	    	t.record_creation_date(:path=>"recordCreationDate", :attributes=>{:encoding=>"w3cdtf"})
	      	t.record_change_date(:path=>"recordChangeDate", :attributes=>{:encoding=>"w3cdtf"}) 
      	}
	end

	def self.xml_template
		Nokogiri::XML::Builder.new do |xml|
      		xml.mods(MODS_PARAMS) {
      			xml.titleInfo(:lang=>"") {
            		xml.title
             	}
             	xml.name {
          			xml.namePart
          			xml.role {
            			xml.roleTerm
          			}
        		}
        		xml.subject(:authority=>"UoH") {
               		xml.topic
             	}
             	xml.abstract
             	xml.recordInfo {
	               	xml.recordContentSource "Hull History Centre"
	               	xml.recordCreationDate(Time.now.strftime("%Y-%m-%d"), :encoding=>"w3cdtf")
	               	xml.recordChangeDate(:encoding=>"w3cdtf")
	               	xml.languageOfCataloging {
	                	xml.languageTerm("eng", :authority=>"iso639-2b")  
	               	}
             	}
      		}
      	end.doc
	end
end