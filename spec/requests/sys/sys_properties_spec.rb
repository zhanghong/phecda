require 'spec_helper'

describe "Sys::Properties" do
  describe "GET /sys_properties" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get sys_properties_path
      response.status.should be(200)
    end
  end
end
