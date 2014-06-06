require 'spec_helper'

describe "Tb::Products" do
  describe "GET /tb_products" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tb_products_path
      response.status.should be(200)
    end
  end
end
