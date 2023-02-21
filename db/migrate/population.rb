class CreateandPopulateTables < ActiveRecord::Migration[7.0]
    def change
      execute(File.read(Rails.root.join('db/migrate/Create_Star_Wars.sql')))
      execute(File.read(Rails.root.join('db/migrate/Populate_Star_Wars.sql')))
    end
  end
  