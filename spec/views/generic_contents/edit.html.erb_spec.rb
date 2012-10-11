require 'spec_helper'

describe "generic_contents/edit" do
  before(:each) do
    @generic_content = assign(:generic_content, stub_model(GenericContent))
  end

  it "renders the edit generic_content form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => generic_contents_path(@generic_content), :method => "post" do
    end
  end
end
