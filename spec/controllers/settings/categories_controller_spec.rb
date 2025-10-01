require "rails_helper"

describe Settings::CategoriesController do
  let(:user) { create(:user) }
  let(:category) { create(:category, user:) }
  model = Category

  before { sign_in user }

  render_views

  describe "#index" do
    it "should be ok" do
      category # create
      get :index
      expect(response).to be_ok
      expect(assigns(:categories)).to eq [category]
    end
  end # describe "#index"

  describe "#new" do
    it "should be ok" do
      get :new
      expect(response).to be_ok
    end
  end # describe "#new"

  describe "#create" do
    valid_params = { name: "test" }

    it "should be ok" do
      expect do
        post :create, params: { category: valid_params }
      end.to change(model, :count).by(1)

      expect(response).to be_redirect
    end

    it "should render errors" do
      expect do
        post :create
      end.to_not change(model, :count)

      expect(response).to render_template(:new)
    end
  end # describe "#create"

  describe "#show" do
    it "should redirect to edit" do
      category = create(:category, user:)
      get :show, params: { id: category }
      expect(response).to redirect_to(action: :edit)
    end
  end # describe "#show"

  describe "#edit" do
    it "should be ok" do
      get :edit, params: { id: category }
      expect(response).to be_ok
    end
  end # describe "#edit"

  describe "#update" do
    it "should be ok" do
      valid_params = { name: "new name" }

      patch :update, params: { id: category, category: valid_params }

      expect(response).to be_redirect
      expect(category.reload.name).to eq "new name"
    end

    it "should render errors" do
      invalid_params = { name: "" }

      patch :update, params: { id: category, category: invalid_params }

      expect(response).to render_template(:edit)
    end
  end # describe "#update"

  describe "#destroy" do
    it "should destroy category" do
      category = create(:category, user:)
      get :destroy, params: { id: category }
      expect { category.reload }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to redirect_to(action: :index)
    end

    it "should NOT destroy category with feeds" do
      category = create(:feed, user:).category
      get :destroy, params: { id: category }
      expect { category.reload }.to_not raise_error
      expect(response).to redirect_to(action: :index)
    end
  end # describe "#destroy"
end
