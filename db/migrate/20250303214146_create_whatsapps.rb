# frozen_string_literal: true

# class responsible for create Whatsapp table
class CreateWhatsapps < ActiveRecord::Migration
  def change
    create_table :whatsapps do |t|
      t.string :instance
      t.string :token
      t.integer :status

      t.references :unidade, index: true

      t.timestamps
    end
  end
end
