class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.text :first_name
      t.text :last_name
      t.text :email_address

      t.timestamps
    end
  end
end
