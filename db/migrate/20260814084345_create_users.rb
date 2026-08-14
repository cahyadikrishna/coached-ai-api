class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :strava_id, null: false
      t.string :access_token
      t.string :refresh_token
      t.integer :token_expires_at

      t.timestamps
    end
    add_index :users, :strava_id, unique: true
  end
end
