class CreateModeloContratos < ActiveRecord::Migration
  def change
    create_table :modelo_contratos do |t|
      t.string :nome, limit: 100
      t.text :modelo
      t.string :processo, limit: 100

      t.timestamps
    end
  end
end
