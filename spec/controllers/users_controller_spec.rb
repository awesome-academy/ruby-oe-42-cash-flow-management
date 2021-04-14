require "rails_helper"

RSpec.describe UsersController, type: :controller do

  describe "#new" do
    it "render :new" do
      new_user = FactoryBot.build :user
      get :new, params: {
        user: {
          id: new_user.id,
          name: new_user.name,
          email: new_user.email,
          password: new_user.password,
        }
      }
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    it "redirects to root_path" do
      correct_user = User.new(name: "newusername2928", email: "email@correo.com", password: "correct123")
      post :create, params: {
        user: {
          name: correct_user.name,
          email: correct_user.email,
          password: correct_user.password,
          password_confirmation: correct_user.password,
        }
      }
      expect(correct_user.save).to be true
    end

    it "render :new" do
      invalid_user = User.new(name: "Invalid user", email: "invalid email", password: "")
      post :create, params: {
        user: {
          name: invalid_user.name,
          email: invalid_user.email,
          password: invalid_user.password,
          password_confirmation: invalid_user.password,
        }
      }
      expect(invalid_user.save).to be false
    end
  end

  describe "#show" do
    it "should return the user with given id" do
      show_user = User.new(id: 15, name: "showusername2928", email: "email@correo.com")
      get :show, params: { id: show_user.id }
      expect(assigns(:show_user)).should equal?(show_user)
    end

    it "return a nill user if cannot find user" do
      get :show, params: { id: -1 }
      expect(@user.nil?).to be true
    end
  end

end
