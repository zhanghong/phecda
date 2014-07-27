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

describe Admin::AccountPermissionsController do

  # This should return the minimal set of attributes required to create a valid
  # Admin::AccountPermission. As you add validations to Admin::AccountPermission, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "account_id" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::AccountPermissionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all admin_account_permissions as @admin_account_permissions" do
      account_permission = Admin::AccountPermission.create! valid_attributes
      get :index, {}, valid_session
      assigns(:admin_account_permissions).should eq([account_permission])
    end
  end

  describe "GET show" do
    it "assigns the requested admin_account_permission as @admin_account_permission" do
      account_permission = Admin::AccountPermission.create! valid_attributes
      get :show, {:id => account_permission.to_param}, valid_session
      assigns(:admin_account_permission).should eq(account_permission)
    end
  end

  describe "GET new" do
    it "assigns a new admin_account_permission as @admin_account_permission" do
      get :new, {}, valid_session
      assigns(:admin_account_permission).should be_a_new(Admin::AccountPermission)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_account_permission as @admin_account_permission" do
      account_permission = Admin::AccountPermission.create! valid_attributes
      get :edit, {:id => account_permission.to_param}, valid_session
      assigns(:admin_account_permission).should eq(account_permission)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::AccountPermission" do
        expect {
          post :create, {:admin_account_permission => valid_attributes}, valid_session
        }.to change(Admin::AccountPermission, :count).by(1)
      end

      it "assigns a newly created admin_account_permission as @admin_account_permission" do
        post :create, {:admin_account_permission => valid_attributes}, valid_session
        assigns(:admin_account_permission).should be_a(Admin::AccountPermission)
        assigns(:admin_account_permission).should be_persisted
      end

      it "redirects to the created admin_account_permission" do
        post :create, {:admin_account_permission => valid_attributes}, valid_session
        response.should redirect_to(Admin::AccountPermission.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_account_permission as @admin_account_permission" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::AccountPermission.any_instance.stub(:save).and_return(false)
        post :create, {:admin_account_permission => { "account_id" => "invalid value" }}, valid_session
        assigns(:admin_account_permission).should be_a_new(Admin::AccountPermission)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::AccountPermission.any_instance.stub(:save).and_return(false)
        post :create, {:admin_account_permission => { "account_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_account_permission" do
        account_permission = Admin::AccountPermission.create! valid_attributes
        # Assuming there are no other admin_account_permissions in the database, this
        # specifies that the Admin::AccountPermission created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin::AccountPermission.any_instance.should_receive(:update).with({ "account_id" => "MyString" })
        put :update, {:id => account_permission.to_param, :admin_account_permission => { "account_id" => "MyString" }}, valid_session
      end

      it "assigns the requested admin_account_permission as @admin_account_permission" do
        account_permission = Admin::AccountPermission.create! valid_attributes
        put :update, {:id => account_permission.to_param, :admin_account_permission => valid_attributes}, valid_session
        assigns(:admin_account_permission).should eq(account_permission)
      end

      it "redirects to the admin_account_permission" do
        account_permission = Admin::AccountPermission.create! valid_attributes
        put :update, {:id => account_permission.to_param, :admin_account_permission => valid_attributes}, valid_session
        response.should redirect_to(account_permission)
      end
    end

    describe "with invalid params" do
      it "assigns the admin_account_permission as @admin_account_permission" do
        account_permission = Admin::AccountPermission.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::AccountPermission.any_instance.stub(:save).and_return(false)
        put :update, {:id => account_permission.to_param, :admin_account_permission => { "account_id" => "invalid value" }}, valid_session
        assigns(:admin_account_permission).should eq(account_permission)
      end

      it "re-renders the 'edit' template" do
        account_permission = Admin::AccountPermission.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::AccountPermission.any_instance.stub(:save).and_return(false)
        put :update, {:id => account_permission.to_param, :admin_account_permission => { "account_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_account_permission" do
      account_permission = Admin::AccountPermission.create! valid_attributes
      expect {
        delete :destroy, {:id => account_permission.to_param}, valid_session
      }.to change(Admin::AccountPermission, :count).by(-1)
    end

    it "redirects to the admin_account_permissions list" do
      account_permission = Admin::AccountPermission.create! valid_attributes
      delete :destroy, {:id => account_permission.to_param}, valid_session
      response.should redirect_to(admin_account_permissions_url)
    end
  end

end
