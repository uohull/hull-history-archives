require 'spec_helper'

describe "structural_sets/index" do
  before(:each) do
    assign(:structural_sets, [
      stub_model(StructuralSet),
      stub_model(StructuralSet)
    ])
  end

  it "renders a list of structural_sets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
