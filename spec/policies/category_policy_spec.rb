require "rails_helper"

describe CategoryPolicy do
  describe "scope" do
    let(:current_user) { create(:user) }

    def scope
      Pundit.policy_scope!(current_user, Category)
    end

    it "should return only my entries" do
      category1 = create(:category, user: current_user)
      category2 = create(:category)

      expect(scope).to eq [category1]
    end
  end
end
