class CreateComandas < ActiveRecord::Migration
  def change
    create_table :comandas do |t|
      t.integer :cartao_id
      t.string :cartao_nome, limit: 10
      t.integer :persona_id
      t.text :obs

      t.timestamps
    end
  end
end
