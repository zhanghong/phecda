require 'spec_helper'

describe "Sys::Products" do
  describe "GET /sys_products" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get sys_products_path
      response.status.should be(200)
    end
  end
end
