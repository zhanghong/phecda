# encoding: utf-8
require 'spec_helper'

describe Tb::Category do
  before do
    @brandy_cat_1 = create(:brandy_cat_1)
  end

  context "belongs_to association" do
    [:shop].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:products].each do |name|
      it { should have_many(name) }
    end
  end
end
