require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'
require 'active_support/inflector'

class SQLObject
  extend Searchable, Associatable

  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    @columns[0].map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) { attributes[column] }
      define_method(column.to_s + "=") { |val| attributes[column] = val }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  # Takes rows of table data as an argument and returns Ruby objects
  def self.parse_all(results)
    objects = []
    results.each do |obj_attributes|
      objects << self.new(obj_attributes)
    end
    objects
  end

  def self.all
    table_data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
    SQL
    parse_all(table_data)
  end


  def self.find(id)
    object_data = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
    SQL
    parse_all(object_data)[0]
  end

  def initialize(params = {})
    params.each do |param|
      attr_name, value = param
      unless columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end

      send("#{attr_name.to_s}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    columns.map { |attribute| send(attribute) }
  end

  def insert
    question_marks = (["?"] * columns.size).join(",")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{table_name} (#{columns.join(",")})
      VALUES
        (#{question_marks})
    SQL

    attributes[:id] = DBConnection.last_insert_row_id
  end

  def update
    cols_w_ques_marks = columns.drop(1).map { |col| "#{col}=?" }

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      UPDATE
        #{table_name}
      SET
        #{cols_w_ques_marks.join(",")}
      WHERE
        id = #{id}
    SQL
  end

  def save
    id.nil? ? insert : update
  end

  private

  def columns
    self.class.columns
  end

  def table_name
    self.class.table_name
  end
end

# calls finalize! on a SQLObject classes at time of definition
TracePoint.new(:end) do |tp|
  klass = tp.binding.receiver
  klass.finalize! if klass.respond_to?(:finalize!)
end.enable
