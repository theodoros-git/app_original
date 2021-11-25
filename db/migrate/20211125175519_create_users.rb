class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|

      t.string :phone
      t.string :password_digest
      t.timestamps
      t.boolean :is_admin
      t.boolean :is_customer
      t.boolean :is_active
      t.boolean :is_provider
    end
  end
end
