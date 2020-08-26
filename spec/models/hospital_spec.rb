require 'rails_helper'

RSpec.describe Hospital, type: :model do
  it "should has many doctors" do
    t = Hospital.reflect_on_association(:doctors)
    expect(t.macro).to eq(:has_many)
  end
end
