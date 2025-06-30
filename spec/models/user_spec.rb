
require 'rails_helper'

RSpec.describe User, type: :model do
  # Test case 1: User is invalid without a first name
  it 'is invalid without a first name' do
    user = User.new(
      first_name: nil,
      last_name: "Suzuki",
      email: 'suzukisan@email.com',
    )
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
  end
    it 'is invalid without a last name' do
    user = User.new(
      first_name: "Takeshi",
      last_name: nil,
      email: 'suzukisan@email.com',
    )
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("can't be blank")
  end
    it 'is invalid without an email' do
    user = User.new(
      first_name: "Takeshi",
      last_name: "Suzuki",
      email: nil,
    )
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

   it 'is invalid with duplicate email' do
    User.create!(
      first_name: "Takeshi",
      last_name: "Suzuki",
      email: 'suzukisan@email.com',
      password: "123456",
    )
    user = User.new(
      first_name: "Takeshi",
      last_name: "Suzuki",
      email: 'suzukisan@email.com',
    )
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end
end
