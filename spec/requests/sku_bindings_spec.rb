require 'spec_helper'

describe "SkuBindings" do
  describe "GET /sku_bindings" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get sku_bindings_path
      response.status.should be(200)
    end
  end
end
