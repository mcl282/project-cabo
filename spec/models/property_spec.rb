require 'rails_helper'

RSpec.describe Property, type: :model do
    it "has a valid property" do
      property = build(:property)
    expect(property).to be_valid
  end
end
