
require 'rails_helper'

RSpec.describe LogEntry, type: :model do
  # These let! blocks create valid associated records before each test.
  # We are assuming User, Unit, and Log models have been set up
  # and that their basic validations (like presence) are met by these creations.
  # Adjust attributes as needed based on your actual model validations.
  let!(:user) do
    User.create!(
      email: "test_user_#{SecureRandom.hex(4)}@example.com",
      password: "password",
      password_confirmation: "password",
      first_name: "Test",
      last_name: "User"
    )
  end
  let!(:unit) { Unit.create!(name: "Test Unit #{SecureRandom.hex(4)}") }
  let!(:log)  { Log.create!(title: "Test Log for Entry #{SecureRandom.hex(4)}", date: Date.today, status: :open, shift_type: "Day Shift", unit: unit) }

  # Test case 1: LogEntry is valid with all required content
  it 'is valid with content' do
    entry = LogEntry.new(
      content: 'This is a valid log entry.',
      entry_type: :normal, # Using an enum string
      section_identifier: 'General Notes',
      is_editable_section: true,
      log: log,
      user: user
    )
    expect(entry).to be_valid
  end

  # Test case 2: LogEntry is invalid without content (testing presence validation)
  it 'is invalid without content' do
    entry = LogEntry.new(
      content: nil, # This explicitly sets content to nil to test the validation
      entry_type: :critical,
      section_identifier: 'Critical Observation',
      is_editable_section: false,
      log: log,
      user: user
    )
    expect(entry).not_to be_valid
    expect(entry.errors[:content]).to include("can't be blank")
  end

  # Test case 3: LogEntry is invalid without an entry_type (testing presence validation)
  it 'is invalid without an entry_type' do
    entry = LogEntry.new(
      content: 'Some content here.',
      entry_type: nil, # Test case: entry_type is nil
      section_identifier: 'Section X',
      is_editable_section: false,
      log: log,
      user: user
    )
    expect(entry).not_to be_valid
    expect(entry.errors[:entry_type]).to include("can't be blank")
  end

  # Test case 4: LogEntry is invalid without an associated log
  it 'is invalid without a log' do
    entry = LogEntry.new(
      content: 'Some content here.',
      entry_type: :info,
      section_identifier: 'Section Y',
      is_editable_section: true,
      log: nil, # Test case: log association is nil
      user: user
    )
    expect(entry).not_to be_valid
    # Rails 5+ adds `presence: true` to `belongs_to` by default,
    # so the error message will reflect this.
    expect(entry.errors[:log]).to include("must exist")
  end

  # Test case 5: LogEntry is invalid without an associated user
  it 'is invalid without a user' do
    entry = LogEntry.new(
      content: 'Some content here.',
      entry_type: :maintenance,
      section_identifier: 'Section Z',
      is_editable_section: false,
      log: log,
      user: nil # Test case: user association is nil
    )
    expect(entry).not_to be_valid
    expect(entry.errors[:user]).to include("must exist")
  end

  # Test case 6: entry_type enum accepts valid values
  it 'accepts valid entry_type enum values' do
    LogEntry.entry_types.keys.each do |type|
      entry = LogEntry.new(
        content: 'Content for enum test.',
        entry_type: type, # Test each valid enum key
        section_identifier: 'Enum Test',
        is_editable_section: false,
        log: log,
        user: user
      )
      expect(entry).to be_valid
    end
  end

end
