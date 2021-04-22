require "rails_helper"

RSpec.describe UsersController, type: :controller do

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
