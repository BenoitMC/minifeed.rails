require "rails_helper"

describe EntryPolicy do
  describe "scope" do
    let(:current_user) { create(:user) }

    def scope
      Pundit.policy_scope!(current_user, Entry)
    end

    it "should return only my entries" do
      entry1 = create(:entry, user: current_user)
      entry2 = create(:entry)

      expect(scope).to eq [entry1]
    end
  end
end
