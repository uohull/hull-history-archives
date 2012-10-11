describe GenericContent do

	before(:each) do
		@genericContent = GenericContent.new
	end

	it 'should have the specified datastreams' do
		@genericContent.datastreams.keys.should include('descMetadata')
		@genericContent.descMetadata.should be_kind_of GenericContentModsDatastream

		@genericContent.datastreams.keys.should include('rightsMetadata')
		@genericContent.rightsMetadata.should be_kind_of Hydra::RightsMetadata 
	end


end