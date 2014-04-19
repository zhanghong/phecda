# encoding: utf-8
require 'spec_helper'

describe Tb::Shop do
  before do
    @brandy_store = create(:brandy_store)
  end

  context "belongs_to association" do
    [:account].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:app_tokens, :categories, :products, :skus, :properties, :property_values].each do |name|
      it { should have_many(name) }
    end
  end
end
