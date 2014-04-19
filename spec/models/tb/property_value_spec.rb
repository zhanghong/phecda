# encoding: utf-8
require 'spec_helper'

describe Tb::PropertyValue do
  before do
    @brandy_weight_70 = create(:brandy_weight_70)
  end

  context "belongs_to association" do
    [:shop, :property].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:sku_properties].each do |name|
      it { should have_many(name) }
    end
  end
end
