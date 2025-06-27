require 'rails_helper'

RSpec.describe Log, type: :model do

  let!(:unit) { Unit.create!(name: "Test Unit #{SecureRandom.hex(4)}") }

# Test case 1: Log is valid with a content
  it 'is valid with all content' do
    log = Log.new(
      title: "Test Log for Entry",
      date: Date.today,
      status: :open,
      shift_type: "Day Shift",
      unit: unit
    )
    expect(log).to be_valid
  end

# Text case 2: Log is invalid without a date
it 'is invalid without a date' do
    log = Log.new(
      title: "Test Log for Entry",
      date: nil,
      status: :open,
      shift_type: "Day Shift",
      unit: unit
    )
    expect(log).not_to be_valid
    expect(log.errors[:date]).to include("can't be blank")
  end

# Test case 3: Log is has valid default status
it 'is valid with default status' do
    log = Log.new(
      title: "Test Log for Entry",
      date: Date.today,
      shift_type: "Day Shift",
      unit: unit
    )
    log.valid?
    expect(log.status).to eq("open")
    expect(log).to be_valid
  end

# Test case 4: Log is invalid without a shift_type
it 'is invalid without a date' do
    log = Log.new(
      title: "Test Log for Entry",
      date: nil,
      status: :open,
      shift_type: nil,
      unit: unit
    )
    expect(log).not_to be_valid
    expect(log.errors[:shift_type]).to include("can't be blank")
  end


it 'is invalid without a unit' do
    log = Log.new(
      title: "Test Log for Entry",
      date: Date.today,
      status: :open,
      shift_type: "Day Shift",
      unit: nil
    ) # Create a Log instance with unit set to nil
    expect(log).not_to be_valid      # Expect it to not be valid
    expect(log.errors[:unit]).to include("must exist") # Check for the specific error message
  end

end
