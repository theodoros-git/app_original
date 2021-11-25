class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|

      t.string :fullname
      t.string :address
      t.string :ville
      t.string :profession
      t.string :phone
      t.string :card_id
      t.boolean :terms_of_use
      t.timestamps
    end
  end
end
