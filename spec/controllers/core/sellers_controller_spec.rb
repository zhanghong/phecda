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

describe Core::SellersController do

  # This should return the minimal set of attributes required to create a valid
  # Core::Seller. As you add validations to Core::Seller, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "parent_id" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Core::SellersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all core_sellers as @core_sellers" do
      seller = Core::Seller.create! valid_attributes
      get :index, {}, valid_session
      assigns(:core_sellers).should eq([seller])
    end
  end

  describe "GET show" do
    it "assigns the requested core_seller as @core_seller" do
      seller = Core::Seller.create! valid_attributes
      get :show, {:id => seller.to_param}, valid_session
      assigns(:core_seller).should eq(seller)
    end
  end

  describe "GET new" do
    it "assigns a new core_seller as @core_seller" do
      get :new, {}, valid_session
      assigns(:core_seller).should be_a_new(Core::Seller)
    end
  end

  describe "GET edit" do
    it "assigns the requested core_seller as @core_seller" do
      seller = Core::Seller.create! valid_attributes
      get :edit, {:id => seller.to_param}, valid_session
      assigns(:core_seller).should eq(seller)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Core::Seller" do
        expect {
          post :create, {:core_seller => valid_attributes}, valid_session
        }.to change(Core::Seller, :count).by(1)
      end

      it "assigns a newly created core_seller as @core_seller" do
        post :create, {:core_seller => valid_attributes}, valid_session
        assigns(:core_seller).should be_a(Core::Seller)
        assigns(:core_seller).should be_persisted
      end

      it "redirects to the created core_seller" do
        post :create, {:core_seller => valid_attributes}, valid_session
        response.should redirect_to(Core::Seller.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved core_seller as @core_seller" do
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Seller.any_instance.stub(:save).and_return(false)
        post :create, {:core_seller => { "parent_id" => "invalid value" }}, valid_session
        assigns(:core_seller).should be_a_new(Core::Seller)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Seller.any_instance.stub(:save).and_return(false)
        post :create, {:core_seller => { "parent_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested core_seller" do
        seller = Core::Seller.create! valid_attributes
        # Assuming there are no other core_sellers in the database, this
        # specifies that the Core::Seller created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Core::Seller.any_instance.should_receive(:update).with({ "parent_id" => "MyString" })
        put :update, {:id => seller.to_param, :core_seller => { "parent_id" => "MyString" }}, valid_session
      end

      it "assigns the requested core_seller as @core_seller" do
        seller = Core::Seller.create! valid_attributes
        put :update, {:id => seller.to_param, :core_seller => valid_attributes}, valid_session
        assigns(:core_seller).should eq(seller)
      end

      it "redirects to the core_seller" do
        seller = Core::Seller.create! valid_attributes
        put :update, {:id => seller.to_param, :core_seller => valid_attributes}, valid_session
        response.should redirect_to(seller)
      end
    end

    describe "with invalid params" do
      it "assigns the core_seller as @core_seller" do
        seller = Core::Seller.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Seller.any_instance.stub(:save).and_return(false)
        put :update, {:id => seller.to_param, :core_seller => { "parent_id" => "invalid value" }}, valid_session
        assigns(:core_seller).should eq(seller)
      end

      it "re-renders the 'edit' template" do
        seller = Core::Seller.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Core::Seller.any_instance.stub(:save).and_return(false)
        put :update, {:id => seller.to_param, :core_seller => { "parent_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested core_seller" do
      seller = Core::Seller.create! valid_attributes
      expect {
        delete :destroy, {:id => seller.to_param}, valid_session
      }.to change(Core::Seller, :count).by(-1)
    end

    it "redirects to the core_sellers list" do
      seller = Core::Seller.create! valid_attributes
      delete :destroy, {:id => seller.to_param}, valid_session
      response.should redirect_to(core_sellers_url)
    end
  end

end
