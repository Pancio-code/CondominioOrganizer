class UpdateAdmin < ActiveRecord::Migration[6.1]
  def change
    User.find(2).update(is_admin: true)
  end
end
