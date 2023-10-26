require "rails_helper"

describe ApiControllerConcern, type: :controller do
  model = User

  controller(ActionController::Base) do
    include ApiControllerConcern

    def index
    end
  end

  def action(&)
    controller.define_singleton_method(:index, &)
    get :index
  end

  it "allow to call #render_json without argument" do
    action { render_json }
    expect(response).to be_ok
    expect(json_response).to eq("current_user" => nil)
  end

  it "allow to call #render_json with json" do
    action { render_json(data: :val) }
    expect(response).to be_ok
    expect(json_response).to eq("current_user" => nil, "data" => "val")
  end

  it "allow to call #render_json with options" do
    action { render_json({}, {status: :not_found}) }
    expect(response).to be_not_found
  end

  it "should call serializer with current_user in both data and options" do
    expect(SimpleSerializer).to receive(:call)
      .with({current_user: nil}, {current_user: nil})
      .and_call_original
      .ordered

    expect(SimpleSerializer).to receive(:call)
      .and_call_original
      .at_least(:once)
      .ordered

    action { render_json }
  end

  it "should pass data and options to serializer" do
    expect(SimpleSerializer).to receive(:call)
      .with({data: :val, current_user: nil}, {opt: :val, current_user: nil})
      .and_call_original
      .ordered

    expect(SimpleSerializer).to receive(:call)
      .and_call_original
      .at_least(:once)
      .ordered

    action { render_json({data: :val}, {opt: :val}) }
  end

  it "should render not found" do
    action { render_not_found }
    expect(response).to be_not_found
    expect(json_response).to eq(
      "current_user" => nil,
      "error"        => "Page not found",
    )
  end

  it "should render forbiddden" do
    action { render_forbidden }
    expect(response).to be_forbidden
    expect(json_response).to eq(
      "current_user" => nil,
      "error"        => "You must log in to access this page",
    )
  end

  it "should render unauthorized" do
    action { render_unauthorized }
    expect(response).to be_unauthorized
    expect(json_response).to eq(
      "current_user" => nil,
      "error"        => "You are not authorized to access this page",
    )
  end

  it "should render unau if not logged in" do
    allow(controller).to receive(:current_user).and_return(nil)
    action { render_forbidden_or_unauthorized }
    expect(response).to be_unauthorized
  end

  it "should render forbidden if logged in" do
    allow(controller).to receive(:current_user).and_return("user")
    action { render_forbidden_or_unauthorized }
    expect(response).to be_forbidden
  end

  it "should render error with default status" do
    action { render_json_error "my_err" }
    expect(response.status).to eq 422
  end

  it "should render error with custom status" do
    action { render_json_error "my_err", status: :internal_server_error }
    expect(response.status).to eq 500
  end

  it "should render error with object" do
    expect(controller).to receive(:json_error_string_for_model) \
      .with(instance_of(model)).at_least(:once).and_return("aaa")

    expect(controller).to receive(:json_errors_hash_for_model) \
      .with(instance_of(model)).at_least(:once).and_return("bbb")

    action {
      render_json_error model.new
    }

    expect(response.status).to eq 422
    expect(json_response).to eq(
      "current_user" => nil,
      "error"        => "aaa",
      "model_errors" => "bbb",
    )
  end

  it "json_errors_hash_for_model should return errors and keep only first error of each attr" do
    action {
      instance = model.new
      instance.errors.add(:base, "my model error")
      instance.errors.add(:name, :blank)
      instance.errors.add(:name, :invalid)
      render_json json_errors_hash_for_model(instance)
    }

    expect(json_response).to eq(
      "current_user" => nil,
      "base" => {
        "message"     => "my model error",
        "full_message"=> "my model error",
      },
      "name" => {
        "message"      => "can't be blank",
        "full_message" => "Name can't be blank",
      },
    )
  end

  it "json_error_string_for_model should return errors and keep only first error of each attr" do
    action {
      instance = model.new
      instance.errors.add(:base, "my model error")
      instance.errors.add(:name, :blank)
      instance.errors.add(:name, :invalid)
      render_json error: json_error_string_for_model(instance)
    }

    expect(json_response).to eq(
      "current_user" => nil,
      "error"        => "my model error, Name can't be blank",
    )
  end

  it "should render error with json" do
    action { render_json_error custom_error_key: "my custom error" }
    expect(response.status).to eq 422
    expect(json_response).to eq(
      "current_user"     => nil,
      "custom_error_key" => "my custom error",
    )
  end

  it "should render not found on ActiveRecord not found error" do
    action { model.find(123_456_789) }
    expect(json_response).to eq(
      "current_user" => nil,
      "error"        => "Page not found",
    )
  end
end
