class Ability
  include CanCan::Ability

  def super_admin_role
    can :manage,  [Admin::Permission, Admin::AccountPermission]
  end

  def initialize(user)
    alias_action  [:area_nodes],  to: :read

    can :read,  Core::Area
    can :manage, [Core::Stock, Core::StockProduct, Core::StockBill, Core::StockInBill, Core::StockOutBill]
    
    user.permissions.each do |permission|
      if permission.ability_method.present?
        can permission.action_name.to_sym, permission.subject_class.constantize do |obj|
          obj.send(permission.ability_method)
        end
      else
        can permission.action_name.to_sym, permission.subject_class.constantize
      end

      super_admin_role if user.is_superadmin?
    end


    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
