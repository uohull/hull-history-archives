module ArchivedAssetsModelMethods

  extend ActiveSupport::Concern
  def update_content_metadata(opts={})

    pid = self.pid
    size_attr = self.datastreams["content"].size
  	label = self.datastreams["content"].dsLabel
  	mime_type = self.datastreams["content"].mimeType
    format =  mime_type[mime_type.index("/") + 1...mime_type.length]
  	service_def = "afmodel:FileAsset"
  	service_method = "getContent"

    content_metadata_opts = {:object_id => pid, :ds_id=> "content", :file_size=>size_attr, :url => "http://hydra.hull.ac.uk/assets/" + pid + "/content", :display_label=>label, :id => label, :mime_type => mime_type, :format => format, :service_def => service_def, :service_method => service_method}
    content_metadata_opts.merge!(opts)

    #Get the checksum and type from fedora and store in contentMetadata...
    checksum_type = self.datastreams["content"].checksumType		
    checksum = self.datastreams["content"].checksum
    content_metadata_opts.merge!({:checksum => checksum, :checksum_type => checksum_type})

    self.contentMetadata.insert_resource(content_metadata_opts)

    self.datastreams["contentMetadata"].serialize!
  end

  def update_desc_metadata()
      update_hash = { "descMetadata"=> { [:physical_description,:extent]=> "Filesize: " + self.bits_to_human_readable(self.datastreams["content"].size.to_i),
  										[:physical_description,:mime_type]=>self.datastreams["content"].mimeType,
  							       [:location,:raw_object]=> "http://hydra.hull.ac.uk/assets/" + self.pid + "/content" }
  								  }		
		  self.update_datastream_attributes( update_hash )
      self.save
    end

  def bits_to_human_readable(num)
    ['bytes','KB','MB','GB','TB'].each do |x|
      if num < 1024.0
        return "#{num.to_i} #{x}"
      else
        num = num/1024.0
      end
    end
  end
end