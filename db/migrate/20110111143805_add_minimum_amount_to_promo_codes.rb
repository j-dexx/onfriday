class AddMinimumAmountToPromoCodes < ActiveRecord::Migration
  def self.up
    add_column :promo_codes, :minimum_amount, :float
  end

  def self.down
    remove_column :promo_codes, :minimum_amount
  end
end
