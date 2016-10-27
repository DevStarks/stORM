require './lib/db_connection'
require './lib/sql_object'

DBConnection.reset

class Turtle < SQLObject
  belongs_to :owner, class_name: "Human"
  has_one_through :house, :owner, :house
end

class Human < SQLObject
  belongs_to :house
  has_many :turtles, foreign_key: :owner_id
  has_one_through :neighborhood, :house, :neighborhood

  self.table_name = "humans"
end

class House < SQLObject
  has_many :inhabitants, class_name: "Human"
  belongs_to :neighborhood
end

class Neighborhood < SQLObject
  has_many :houses, class_name: "House"
end
