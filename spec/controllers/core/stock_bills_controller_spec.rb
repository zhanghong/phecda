require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Core::StockBillsController do

  # This should return the minimal set of attributes required to create a valid
  # Core::StockBill. As you add validations to Core::StockBill, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "stock_id" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Core::StockBillsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all core_stock_bills as @core_stock_bills" do
      stock_bill = Core::StockBill.create! valid_attributes
      get :index, {}, valid_session
      assigns(:core_stock_bills).should eq([stock_bill])
    end
  end

  describe "GET show" do
    it "assigns the requested core_stock_bill as @core_stock_bill" do
      stock_bill = Core::StockBill.create! valid_attributes
      get :show, {:id => stock_bill.to_param}, valid_session
      assigns(:core_stock_bill).should eq(stock_bill)
    end
  end

  describe "GET new" do
    it "assigns a new core_stock_bill as @core_stock_bill" do
      get :new, {}, valid_session
      assigns(:core_stock_bill).should be_a_new(Core::StockBill)
    end
  end

  describe "GET edit" do
    it "assigns the requested core_stock_bill as @core_stock_bill" do
      stock_bill = Core::StockBill.create! valid_attributes
      get :edit, {:id => stock_bill.to_param}, valid_session
      assigns(:core_stock_bill).should eq(stock_bill)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Core::StockBill" do
        expect {
          post :create, {:core_stock_bill => valid_attributes}, valid_session
        }.to change(Core::StockBill, :count).by(1)
      end

      it "assigns a newly created core_stock_bill as @core_stock_bill" do
        post :create, {:core_stock_bill => valid_attributes}, valid_session
        assigns(:core_stock_bill).should be_a(Core::StockBill)
        assigns(:core_stock_bill).should be_persisted
      end

      it "redirects to the created core_stock_bill" do
        post :create, {:core_stock_bill => valid_attributes}, valid_session
        response.should redirect_to(Core::StockBill.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved core_stock_bill as @core_stock_bill" do
        # Trigger the behavior that occurs when invalid params are submitted
        Core::StockBill.any_instance.stub(:save).and_return(false)
        post :create, {:core_stock_bill => { "stock_id" => "invalid value" }}, valid_session
        assigns(:core_stock_bill).should be_a_new(Core::StockBill)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Core::StockBill.any_instance.stub(:save).and_return(false)
        post :create, {:core_stock_bill => { "stock_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested core_stock_bill" do
        stock_bill = Core::StockBill.create! valid_attributes
        # Assuming there are no other core_stock_bills in the database, this
        # specifies that the Core::StockBill created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Core::StockBill.any_instance.should_receive(:update).with({ "stock_id" => "MyString" })
        put :update, {:id => stock_bill.to_param, :core_stock_bill => { "stock_id" => "MyString" }}, valid_session
      end

      it "assigns the requested core_stock_bill as @core_stock_bill" do
        stock_bill = Core::StockBill.create! valid_attributes
        put :update, {:id => stock_bill.to_param, :core_stock_bill => valid_attributes}, valid_session
        assigns(:core_stock_bill).should eq(stock_bill)
      end

      it "redirects to the core_stock_bill" do
        stock_bill = Core::StockBill.create! valid_attributes
        put :update, {:id => stock_bill.to_param, :core_stock_bill => valid_attributes}, valid_session
        response.should redirect_to(stock_bill)
      end
    end

    describe "with invalid params" do
      it "assigns the core_stock_bill as @core_stock_bill" do
        stock_bill = Core::StockBill.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Core::StockBill.any_instance.stub(:save).and_return(false)
        put :update, {:id => stock_bill.to_param, :core_stock_bill => { "stock_id" => "invalid value" }}, valid_session
        assigns(:core_stock_bill).should eq(stock_bill)
      end

      it "re-renders the 'edit' template" do
        stock_bill = Core::StockBill.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Core::StockBill.any_instance.stub(:save).and_return(false)
        put :update, {:id => stock_bill.to_param, :core_stock_bill => { "stock_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested core_stock_bill" do
      stock_bill = Core::StockBill.create! valid_attributes
      expect {
        delete :destroy, {:id => stock_bill.to_param}, valid_session
      }.to change(Core::StockBill, :count).by(-1)
    end

    it "redirects to the core_stock_bills list" do
      stock_bill = Core::StockBill.create! valid_attributes
      delete :destroy, {:id => stock_bill.to_param}, valid_session
      response.should redirect_to(core_stock_bills_url)
    end
  end

end
