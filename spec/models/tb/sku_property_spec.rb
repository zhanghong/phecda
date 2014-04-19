# encoding: utf-8
require 'spec_helper'

describe Tb::SkuProperty do
  before do
    @brandy_sku_1_weight_70 = create(:brandy_sku_1_weight_70)
  end

  context "belongs_to association" do
    [:sku, :property_value].each do |name|
      it { should belong_to(name) }
    end
  end
end
