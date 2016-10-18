
require 'active_support/inflector'


class AssocOptions
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    class_name.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
    @foreign_key = options[:foreign_key] || (name.to_s + "_id").to_sym
    @primary_key = options[:primary_key] || :id
  end
end

class HasOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
    @foreign_key = options[:foreign_key] ||
      (self_class_name.downcase + "_id").to_sym
    @primary_key = options[:primary_key] || :id
  end
end
