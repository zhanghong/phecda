# encoding: utf-8
require 'spec_helper'

describe Account do
	context "has_many association" do
    [:tb_shops].each do |name|
      it { should have_many(name).dependent(:destroy)}
    end
  end
end