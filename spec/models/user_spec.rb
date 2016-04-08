# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  first_name :string
#  last_name  :string
#

require 'rails_helper'

RSpec.describe User, type: :model do 

  it "needs a first and last name to be created" do
    user = User.create!(first_name: "Erik", last_name: "Aylward")
    expect(user).to be_valid
  end

  it "is invalid with no first name" do
    user = User.new(last_name: "Smith")
    expect(user).to be_invalid
  end

  it "is invalid with no last name" do
    user = User.new(first_name: "john")
    expect(user).to be_invalid
  end

end
