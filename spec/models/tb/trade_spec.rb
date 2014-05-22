require 'spec_helper'

describe Tb::Trade do
  context "belongs_to association" do
    [:shop].each do |name|
      it { should belong_to(name) }
    end
  end

  context "has_many association" do
    [:orders].each do |name|
      it { should have_many(name).dependent(:destroy) }
    end
  end
end
