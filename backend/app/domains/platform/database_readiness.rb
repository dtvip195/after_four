module Platform
  class DatabaseReadiness
    def self.call
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        connection.select_value("SELECT 1") == 1
      end
    end
  end
end
