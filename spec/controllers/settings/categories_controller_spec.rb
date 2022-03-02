require "rails_helper"

describe Settings::CategoriesController do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "#show" do
    it "should redirect to edit" do
      category = create(:category, user:)
      get :show, params: {id: category}
      expect(response).to redirect_to(action: :edit)
    end
  end # describe "#show"

  describe "#destroy" do
    it "should destroy category" do
      category = create(:category, user:)
      get :destroy, params: {id: category}
      expect { category.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(action: :index)
    end

    it "should NOT destroy category with feeds" do
      category = create(:feed, user:).category
      get :destroy, params: {id: category}
      expect { category.reload }.to_not raise_error
      expect(response).to redirect_to(action: :index)
    end
  end # describe "#destroy"
end
