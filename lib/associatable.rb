require_relative 'assoc_options'

module Associatable

  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      model_class = options.model_class
      foreign_key = self.send(options.foreign_key)

      model_class.where({options.primary_key => foreign_key}).first
    end
    assoc_options[name.to_sym] = options
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      model_class = options.model_class
      model_class.where({options.foreign_key => id})
    end
  end

  def assoc_options
    @options ||= {}
  end

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name
      through_primary = through_options.primary_key.to_s
      through_foreign = through_options.foreign_key.to_s

      source_table = source_options.table_name
      source_primary = source_options.primary_key.to_s
      source_foreign = source_options.foreign_key.to_s

      data = DBConnection.execute(<<-SQL)
        SELECT
          DISTINCT s.*
        FROM
          #{table_name} self
        JOIN
          #{through_table} t ON t.#{through_primary} = self.#{through_foreign}
        JOIN
          #{source_table} s ON s.#{source_primary} = t.#{source_foreign}
        WHERE
          self.id = #{id}
      SQL
      source_options.model_class.parse_all(data).first
    end
  end
end
