# encoding: utf-8
require 'spec_helper'

describe Tb::PropertyValue do
  before do
    #
  end

  context "belongs_to association" do
    [:shop, :property].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:sku_properties].each do |name|
      it { should have_many(name).dependent(:destroy) }
    end
  end
end
