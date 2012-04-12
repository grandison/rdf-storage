class CreateDrugParts < ActiveRecord::Migration
  def change
    create_table :drug_parts do |t|

      t.timestamps
    end
  end
end
