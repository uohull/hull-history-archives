require 'spec_helper'

describe "structural_sets/new" do
  before(:each) do
    assign(:structural_set, stub_model(StructuralSet).as_new_record)
  end

  it "renders new structural_set form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => structural_sets_path, :method => "post" do
    end
  end
end
