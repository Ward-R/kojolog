
require 'rails_helper'

RSpec.describe Unit, type: :model do
  # Test case 1: Unit is invalid without a name
  it 'is invalid without a name' do
    unit = Unit.new(
      name: nil,
      description: 'Power Generation Area',
    )
    expect(unit).not_to be_valid
    expect(unit.errors[:name]).to include("can't be blank")
  end
  it 'is invalid with a duplicate name' do
    Unit.create!(
      name: 'Boiler',
      description: 'Power Generation Area'
    )
    unit = Unit.new(
      name: 'Boiler',
      description: 'Power Generation Area'
    )
    expect(unit).not_to be_valid
    expect(unit.errors[:name]).to include("has already been taken")
  end
end
