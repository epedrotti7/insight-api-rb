class CreateCensosNomes < ActiveRecord::Migration[7.0]
  def change
    create_table :censos_nomes do |t|
      t.string :nome, null: false
      t.string :decada, null: false
      t.integer :frequencia, null: false
      t.string :sexo, limit: 1

      t.timestamps
    end
  end
end