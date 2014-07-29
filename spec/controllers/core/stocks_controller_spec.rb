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

describe Core::StocksController do

  # This should return the minimal set of attributes required to create a valid
  # Core::Stock. As you add validations to Core::Stock, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Core::StocksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all core_stocks as @core_stocks" do
      stock = Core::Stock.create! valid_attributes
      get :index, {}, valid_session
      assigns(:core_stocks).should eq([stock])
    end
  end

  describe "GET show" do
    it "assigns the requested core_stock as @core_stock" do
      stock = Core::Stock.create! valid_attributes
      get :show, {:id => stock.to_param}, valid_session
      assigns(:core_stock).should eq(stock)
    end
  end

  describe "GET new" do
    it "assigns a new core_stock as @core_stock" do
      get :new, {}, valid_session
      assigns(:core_stock).should be_a_new(Core::Stock)
    end
  end

  describe "GET edit" do
    it "assigns the requested core_stock as @core_stock" do
      stock = Core::Stock.create! valid_attributes
      get :edit, {:id => stock.to_param}, valid_session
      assigns(:core_stock).should eq(stock)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Core::Stock" do
        expect {
          post :create, {:core_stock => valid_attributes}, valid_session
        }.to change(Core::Stock, :count).by(1)
      end

      it "assigns a newly created core_stock as @core_stock" do
        post :create, {:core_stock => valid_attributes}, valid_session
        assigns(:core_stock).should be_a(Core::Stock)
        assigns(:core_stock).should be_persisted
      end

      it "redirects to the created core_stock" do
        post :create, {:core_stock => valid_attributes}, valid_session
        response.should redirect_to(Core::Stock.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved core_stock as @core_stock" do
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Stock.any_instance.stub(:save).and_return(false)
        post :create, {:core_stock => { "name" => "invalid value" }}, valid_session
        assigns(:core_stock).should be_a_new(Core::Stock)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Stock.any_instance.stub(:save).and_return(false)
        post :create, {:core_stock => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested core_stock" do
        stock = Core::Stock.create! valid_attributes
        # Assuming there are no other core_stocks in the database, this
        # specifies that the Core::Stock created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Core::Stock.any_instance.should_receive(:update).with({ "name" => "MyString" })
        put :update, {:id => stock.to_param, :core_stock => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested core_stock as @core_stock" do
        stock = Core::Stock.create! valid_attributes
        put :update, {:id => stock.to_param, :core_stock => valid_attributes}, valid_session
        assigns(:core_stock).should eq(stock)
      end

      it "redirects to the core_stock" do
        stock = Core::Stock.create! valid_attributes
        put :update, {:id => stock.to_param, :core_stock => valid_attributes}, valid_session
        response.should redirect_to(stock)
      end
    end

    describe "with invalid params" do
      it "assigns the core_stock as @core_stock" do
        stock = Core::Stock.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Stock.any_instance.stub(:save).and_return(false)
        put :update, {:id => stock.to_param, :core_stock => { "name" => "invalid value" }}, valid_session
        assigns(:core_stock).should eq(stock)
      end

      it "re-renders the 'edit' template" do
        stock = Core::Stock.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Stock.any_instance.stub(:save).and_return(false)
        put :update, {:id => stock.to_param, :core_stock => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested core_stock" do
      stock = Core::Stock.create! valid_attributes
      expect {
        delete :destroy, {:id => stock.to_param}, valid_session
      }.to change(Core::Stock, :count).by(-1)
    end

    it "redirects to the core_stocks list" do
      stock = Core::Stock.create! valid_attributes
      delete :destroy, {:id => stock.to_param}, valid_session
      response.should redirect_to(core_stocks_url)
    end
  end

end