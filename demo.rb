require './lib/db_connection'
require './lib/sql_object'

DBConnection.reset

class Turtle < SQLObject
  belongs_to :owner, class_name: "Human"
  has_one_through :house, :owner, :house

  finalize!
end

class Human < SQLObject
  belongs_to :house
  has_many :turtles, foreign_key: :owner_id

  self.table_name = "humans"

  finalize!
end

class House < SQLObject
  has_many :inhabitants, class_name: "Human"

  finalize!
end
