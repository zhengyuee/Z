class AddCityAndCollegeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :string
    add_column :users, :college, :string
  end
end
