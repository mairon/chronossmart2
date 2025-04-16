class AddCustomFieldsToPresupuestos < ActiveRecord::Migration
  using_group(:slave_group_a)
  def change
    add_column :presupuestos, :custom_fields, :jsonb, default: '{}'
    add_index  :presupuestos, :custom_fields, using: :gin
  end
end
