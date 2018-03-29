class CreateNewsposts < ActiveRecord::Migration[5.1]
  def change
    create_table :newsposts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
