# encoding: utf-8
require 'spec_helper'

describe Tb::AppToken do
  before do
    @brandy_store_token = create(:brandy_store_token)
  end

  context "belongs_to association" do
    [:shop].each do |name|
      it { should belong_to(name) }
    end
  end
end
