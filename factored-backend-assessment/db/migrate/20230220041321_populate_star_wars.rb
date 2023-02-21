class PopulateStarWars < ActiveRecord::Migration[7.0]
  def change
    source = File.open "db/migrate/Populate_Star_Wars.sql", "r"
    source.readlines.each do |line|
      line.strip!
      next if line.empty? # ensure that rows that contains newlines and nothing else does not get processed
      execute line
    end
    source.close
  end
end
