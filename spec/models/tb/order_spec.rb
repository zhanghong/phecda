require 'spec_helper'

describe Tb::Order do
  context "belongs_to association" do
    [:trade].each do |name|
      it { should belong_to(name) }
    end
  end
end