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

describe Admin::PermissionsController do

  # This should return the minimal set of attributes required to create a valid
  # Admin::Permission. As you add validations to Admin::Permission, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "module_name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::PermissionsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all admin_permissions as @admin_permissions" do
      permission = Admin::Permission.create! valid_attributes
      get :index, {}, valid_session
      assigns(:admin_permissions).should eq([permission])
    end
  end

  describe "GET show" do
    it "assigns the requested admin_permission as @admin_permission" do
      permission = Admin::Permission.create! valid_attributes
      get :show, {:id => permission.to_param}, valid_session
      assigns(:admin_permission).should eq(permission)
    end
  end

  describe "GET new" do
    it "assigns a new admin_permission as @admin_permission" do
      get :new, {}, valid_session
      assigns(:admin_permission).should be_a_new(Admin::Permission)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_permission as @admin_permission" do
      permission = Admin::Permission.create! valid_attributes
      get :edit, {:id => permission.to_param}, valid_session
      assigns(:admin_permission).should eq(permission)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::Permission" do
        expect {
          post :create, {:admin_permission => valid_attributes}, valid_session
        }.to change(Admin::Permission, :count).by(1)
      end

      it "assigns a newly created admin_permission as @admin_permission" do
        post :create, {:admin_permission => valid_attributes}, valid_session
        assigns(:admin_permission).should be_a(Admin::Permission)
        assigns(:admin_permission).should be_persisted
      end

      it "redirects to the created admin_permission" do
        post :create, {:admin_permission => valid_attributes}, valid_session
        response.should redirect_to(Admin::Permission.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_permission as @admin_permission" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Permission.any_instance.stub(:save).and_return(false)
        post :create, {:admin_permission => { "module_name" => "invalid value" }}, valid_session
        assigns(:admin_permission).should be_a_new(Admin::Permission)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Permission.any_instance.stub(:save).and_return(false)
        post :create, {:admin_permission => { "module_name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_permission" do
        permission = Admin::Permission.create! valid_attributes
        # Assuming there are no other admin_permissions in the database, this
        # specifies that the Admin::Permission created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin::Permission.any_instance.should_receive(:update).with({ "module_name" => "MyString" })
        put :update, {:id => permission.to_param, :admin_permission => { "module_name" => "MyString" }}, valid_session
      end

      it "assigns the requested admin_permission as @admin_permission" do
        permission = Admin::Permission.create! valid_attributes
        put :update, {:id => permission.to_param, :admin_permission => valid_attributes}, valid_session
        assigns(:admin_permission).should eq(permission)
      end

      it "redirects to the admin_permission" do
        permission = Admin::Permission.create! valid_attributes
        put :update, {:id => permission.to_param, :admin_permission => valid_attributes}, valid_session
        response.should redirect_to(permission)
      end
    end

    describe "with invalid params" do
      it "assigns the admin_permission as @admin_permission" do
        permission = Admin::Permission.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Permission.any_instance.stub(:save).and_return(false)
        put :update, {:id => permission.to_param, :admin_permission => { "module_name" => "invalid value" }}, valid_session
        assigns(:admin_permission).should eq(permission)
      end

      it "re-renders the 'edit' template" do
        permission = Admin::Permission.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Permission.any_instance.stub(:save).and_return(false)
        put :update, {:id => permission.to_param, :admin_permission => { "module_name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_permission" do
      permission = Admin::Permission.create! valid_attributes
      expect {
        delete :destroy, {:id => permission.to_param}, valid_session
      }.to change(Admin::Permission, :count).by(-1)
    end

    it "redirects to the admin_permissions list" do
      permission = Admin::Permission.create! valid_attributes
      delete :destroy, {:id => permission.to_param}, valid_session
      response.should redirect_to(admin_permissions_url)
    end
  end

end
