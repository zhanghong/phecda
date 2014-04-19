# encoding: utf-8
require 'spec_helper'

describe Tb::Product do
  before do
    @brandy_product_1 = create(:brandy_product_1)
  end

  context "belongs_to association" do
    [:shop, :category].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:skus].each do |name|
      it { should have_many(name).dependent(:destroy) }
    end
  end
end
