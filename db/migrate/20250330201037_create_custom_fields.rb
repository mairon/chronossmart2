class CreateCustomFields < ActiveRecord::Migration
  using_group(:slave_group_a)
  def change
    create_table :custom_fields do |t|
      t.string :label
      t.string :internal_name, limit: 80
      t.string :tabela, limit: 50
      t.string :field_type, default: 0, limit: 2, null: false
      t.text :description

      t.timestamps
    end
       add_index :custom_fields, %i[internal_name], unique: true
  end
end
