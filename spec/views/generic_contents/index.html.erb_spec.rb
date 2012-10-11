require 'spec_helper'

describe "generic_contents/index" do
  before(:each) do
    assign(:generic_contents, [
      stub_model(GenericContent),
      stub_model(GenericContent)
    ])
  end

  it "renders a list of generic_contents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
