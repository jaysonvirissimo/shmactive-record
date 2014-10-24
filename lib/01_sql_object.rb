require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    query = <<-SQL
    SELECT
      *
    FROM
      #{table_name}
    LIMIT
      1
    SQL
    column_names = DBConnection.execute2(query).first.collect(&:intern)
  end

  # Call finalize! at the end of any subclasses of SQLObject.
  def self.finalize!
    columns.each do |column_name|    
      define_method(column_name) do
        self.attributes[column_name]
      end
      define_method("#{column_name}=") do |value|
        self.attributes[column_name] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.collect.each do |attr_name, value|
      unless attributes.keys.include?(attr_name.intern)
        raise "unknown attribute '#{attr_name}'"
      end
      # self.send("attr_name=".intern, value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
