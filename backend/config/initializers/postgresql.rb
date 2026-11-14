require "active_record/connection_adapters/postgresql_adapter"

# PostgreSQL should preserve instant semantics at the storage boundary. Rails
# still reads and writes application times in UTC.
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz
