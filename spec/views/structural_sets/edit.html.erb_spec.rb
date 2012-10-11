require 'spec_helper'

describe "structural_sets/edit" do
  before(:each) do
    @structural_set = assign(:structural_set, stub_model(StructuralSet))
  end

  it "renders the edit structural_set form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => structural_sets_path(@structural_set), :method => "post" do
    end
  end
end
