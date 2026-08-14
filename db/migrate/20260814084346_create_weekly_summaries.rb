class CreateWeeklySummaries < ActiveRecord::Migration[8.1]
  def change
    create_table :weekly_summaries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.jsonb :metrics, null: false, default: {}
      t.text :content

      t.timestamps
    end
  end
end
