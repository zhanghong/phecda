# encoding: utf-8
require 'spec_helper'

describe Tb::Property do
  before do
    @brandy_property_1 = create(:brandy_property_1)
  end

  context "belongs_to association" do
    [:shop].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:values].each do |name|
      it { should have_many(name).dependent(:destroy) }
    end
  end
end
