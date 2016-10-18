require_relative 'db_connection'

module Searchable
  def where(params)
    conditions = params.keys.map { |attri| "#{attri}=?" }.join(" AND ")

    object_data = DBConnection.execute(<<-SQL, *params.values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{conditions}
    SQL

    parse_all(object_data)
  end

  def method_missing(method, *args)
    if method[/^find_by_/]
      self.where(method[8..-1] => args.first)
    else
      super
    end
  end
end
