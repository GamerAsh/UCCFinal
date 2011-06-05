class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.text :aboutme
      t.string :course
      t.text :faveclasses
      t.text :interests

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
