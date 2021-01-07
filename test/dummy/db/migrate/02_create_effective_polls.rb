class CreateEffectivePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.string :title

      t.datetime :start_at
      t.datetime :end_at

      t.boolean :secret, default: false

      t.string :audience
      t.text :audience_scope

      t.datetime :updated_at
      t.datetime :created_at
    end
  end
end
