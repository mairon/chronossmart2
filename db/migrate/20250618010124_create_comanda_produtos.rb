class CreateComandaProdutos < ActiveRecord::Migration
  def change
    create_table :comanda_produtos do |t|
      t.integer :comanda_id
      t.integer :produto_id
      t.string :produto_nome, limit: 150
      t.decimal :quantidade, :precision => 15, :scale => 2, :default => 0
      t.text :obs
      t.integer :persona_id
      t.decimal :unit_gs, :precision => 15, :scale => 2, :default => 0
      t.decimal :tot_gs, :precision => 15, :scale => 2, :default => 0
      t.decimal :unit_us, :precision => 15, :scale => 2, :default => 0
      t.decimal :tot_us, :precision => 15, :scale => 2, :default => 0
      t.integer :moeda

      t.timestamps
    end
  end
end
