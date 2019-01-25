require "rails_helper"

describe FeedPolicy do
  describe "scope" do
    let(:current_user) { create(:user) }

    def scope
      Pundit.policy_scope!(current_user, Feed)
    end

    it "should return only my feeds" do
      feed1 = create(:feed, user: current_user)
      feed2 = create(:feed)

      expect(scope).to eq [feed1]
    end
  end
end
