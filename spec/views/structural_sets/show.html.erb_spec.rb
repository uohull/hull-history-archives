require 'spec_helper'

describe "structural_sets/show" do
  before(:each) do
    @structural_set = assign(:structural_set, stub_model(StructuralSet))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
