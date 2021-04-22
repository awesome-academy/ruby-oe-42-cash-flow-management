require "rails_helper"

 RSpec.describe BudgetsController, type: :controller do
  login_user

  describe "#new" do
    context "when not having parent_id" do
      it "renders new budget page" do
        get :new
        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
    end

    context "when having parent_id" do
      let!(:budget) {FactoryBot.create :budget, user_id: subject.current_user.id}
      context "when parent_id corrext" do
        it "renders new budget page with parent_id" do
          get :new, params: { parent_id: budget.id}
          expect(response).to be_successful
          expect(response).to render_template(:new)
          expect(assigns(:parent_budget)).to eql budget
        end
      end

      context "when parent_id uncorrect" do
        it "redirect_to root_path with flash" do
          get :new, params: {parent_id: Budget.last.id + 1}
          expect(response).to redirect_to(new_budget_path)
          expect(flash[:danger]).to eq(I18n.t "flash.not_found_budget")
        end
      end
    end
  end

  describe "#create" do
    context "when valid attributes" do
      it "creates a new budget" do
        expect{
          post :create, params: {budget: {name: "huy", money: 123}}
        }.to change(Budget,:count).by(1)
      end

      it "redirects to budgets page" do
        post :create, params: {budget: {name: "huy", money: 123}}
        expect(response).to redirect_to(budgets_path)
        expect(flash[:success]).to eq(I18n.t "flash.create_budget_success")
      end
    end

    context "when invalid attributes" do
      it "render new with params" do
        get :create, params: {budget: {name: "huy", money: -123}}
        expect(response).to be_successful
        expect(assigns(:budget).name).to eq "huy"
        expect(assigns(:budget).money).to eq -123
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#index" do
    let!(:budget1) {FactoryBot.create :budget, name: "luong", money: 51, user_id: subject.current_user.id}
    let!(:budget2) {FactoryBot.create :budget, name: "dien", money: 151, user_id: subject.current_user.id}
    let!(:budget3) {FactoryBot.create :budget, name: "nha", money: 1500, user_id: subject.current_user.id}
    context "when search by name" do
      it "render index page with budgets search by name" do
        get :index, params: {name: "luong"}
        expect(response).to be_successful
        expect(assigns(:budgets)).to eq [budget1]
      end
    end

    context "when search by from money" do
      it "render index page with budgets search by from money" do
        get :index,  params: {from_money: 55}
        expect(response).to be_successful
        expect(assigns(:budgets)).to eq [budget3, budget2]
      end
    end

    context "when search by to money" do
      it "render index page with budgets search by to money" do
        get :index,  params: {to_money: 55}
        expect(response).to be_successful
        expect(assigns(:budgets)).to eq [budget1]
      end
    end

    context "when search by valid money range" do
      it "render index page with budgets search by to money" do
        get :index,  params: {from_money: 50, to_money: 152}
        expect(response).to be_successful
        expect(assigns(:budgets)).to eq [budget2, budget1]
      end
    end

    context "when search by invalid money range" do
      it "render index page with budgets search by to money" do
        get :index,  params: {from_money: 500, to_money: 152}
        expect(response).to be_successful
        expect(flash.now[:danger]).to eq(I18n.t "budget.alert_money_error")
        expect(response).to render_template(:index)
        expect(assigns(:budgets)).to eq [budget3, budget2, budget1]
      end
    end
  end
end
