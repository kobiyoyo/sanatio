require 'rails_helper'

RSpec.describe Search, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:status) }
  end
end
