require 'sqlite3'

module Kijiji
  module DB
    FILE = './db/kijiji.sqlite3'

    class << self
      extend Forwardable
      def_delegator :db, :execute

      def db
        @db ||= SQLite3::Database.new(FILE)
      end

      def insert(table:, attributes:)
        query = <<-SQL
          INSERT INTO #{table} (#{attributes.keys.join(', ')})
          VALUES (#{attributes.values.count.times.map { '?' }.join(', ')})
        SQL
        execute query, attributes.values
      end

      def query(table:, attributes:)
        query = <<-SQL
          SELECT * FROM #{table}
          WHERE #{attributes.keys.map { |k| "#{k} = ?" }.join(' AND ')}
        SQL
        execute query, attributes.values
      end

      def setup
        setup_ads rescue STDERR.puts "ads already set up"
      end

      def setup_ads
        execute <<-SQL
          CREATE TABLE ads (
            postal_code_6 VARCHAR(6),
            latitude REAL,
            longitude REAL,
            phone_number INTEGER,
            price REAL,
            published_time INTEGER,
            url TEXT
          );
        SQL
      end
    end
  end
end

require_relative 'db/ad'