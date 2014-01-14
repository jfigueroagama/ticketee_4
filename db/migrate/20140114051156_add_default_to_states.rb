class AddDefaultToStates < ActiveRecord::Migration
  def change
    # The :default => false option makes the default value of this attribute false
    add_column :states, :default, :boolean, :default => false
  end
end
