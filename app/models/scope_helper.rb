module ScopeHelper
  def self.included(base)
    base.class_eval do
      default_scope -> { where(account_id: Account.current_id, deleter_id: 0)}

      belongs_to  :account
      belongs_to  :updater,   class_name: "User"
      belongs_to  :deleter,   class_name: "User"

      validates :account_id,  presence: true
    end
  end

  def updater_name
    updater.try(:name)
  end

  def deleter_name
    deleter.try(:name)
  end

  def destroy
    update_attributes!(deleted_at: Time.now, deleter_id: User.current_id)
  end
end
