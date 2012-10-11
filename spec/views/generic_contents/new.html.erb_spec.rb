require 'spec_helper'

describe "generic_contents/new" do
  before(:each) do
    assign(:generic_content, stub_model(GenericContent).as_new_record)
  end

  it "renders new generic_content form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => generic_contents_path, :method => "post" do
    end
  end
end
