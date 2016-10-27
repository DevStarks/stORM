## stORM

#### Overview
stORM is an Object-Relational Mapping library inspired by ActiveRecord. stORM provides a base class `SQLObject` that, when inherited from, allows Ruby classes to easily query their related database table and return Ruby objects representing that data. These database-connected subclasses can be mapped to each other using associations.

#### Features
- A simple interface for generating SQL queries
- Cross table referencing for object associations
- Infers table-names, primary-keys, and foreign-keys when making associations resulting in elegant method calls

#### General usage:

Mapped classes inherit from `SQLObject` and call finalize! to generate getters and setters for object attributes:
```Ruby
class Cat < SQLObject
  finalize!
end
```

SQLObjects can query the database:
- Returns all objects from the respective table
```Ruby
Cat.all
# => [[#<Cat:0x007f @attributes={:id=>1, :name=>"Breakfast"}>,
 #<Cat:0x007f @attributes={:id=>2, :name=>"Earl"}>,]
 ```
- Queries using any object attribute
```Ruby
 Cat.where({name: "Earl"})
 # => [#<Cat:0x007f @attributes={:id=>2, :name=>"Earl">]
```

Associations can be defined between SQLObjects:
```Ruby
class Cat < SQLObject
  belongs_to :human, foreign_key: :owner_id

  finalize!
end

earl = Cat.where({name: "Earl"})

earl.human
# => #<Human:0x007f9ba @attributes={:id=>2, :fname=>"Matt", :lname=>"Rubens"}>
```

## Demo
To try out stORM, run the following command from within this directory:

```Ruby
irb -r ./demo.rb
```  
These are the defined associations:
```Ruby
class Turtle < SQLObject
  belongs_to :owner, class_name: :human
  has_one_through :house, :owner, :house
end

class Human < SQLObject
  belongs_to :house
  has_many :turtles
end

class House < SQLObject
  has_many :inhabitants, class_name: :human
end
```
...and the database schema:
##### turtles
column name     | data type | details
----------------|-----------|-----------------------
id              | integer   | primary key
name            | string    |
owner_id        | integer   | foreign key

##### humans
column name     | data type | details
----------------|-----------|-----------------------
id              | integer   | primary key
fname           | string    |
lname           | string    |
house_id        | integer   | foreign key

##### houses
column name     | data type | details
----------------|-----------|-----------------------
id              | integer   | primary key
address         | string    |


## Docs

#### General Methods

##### columns
Returns an array of the related table's column names
```Ruby
Human.columns
# => [:id, :fname, :lname, :house_id]
```

##### finalize!
Defines getter and setter instance methods for all attributes. Must be called to enable querying and associations

##### table_name
Returns the inferred name for the related table. Can be set with `table_name=` if incorrect
```Ruby
House.table_name
# => "houses"

SpeedBoat.table_name
# => "speed_boats"

Human.table_name
# => "humen"

Human.table_name = "humans"
Human.table_name
# => "humans"
```
#### Querying

##### all
The `all` method returns an array of all objects from the respective table

```Ruby
House.all
# => [#<House:0x007f9ba186de88 @attributes={:id=>1, :address=>"18 N.10th"}>,
 #<House:0x007f9ba186dac8 @attributes={:id=>2, :address=>"765 State Rd"}>...]
```

##### find(:id)
The `find` method returns an object whose id matches `:id`

```Ruby
House.find(2)
# => #<House:0x007f9ba147c220 @attributes={:id=>2, :address=>"123 Main St"}>
```

##### find\_by_:attribute(value)
The `find_by_:attribute` method returns an object whose `:attribute` matches the given `value`. This method is applicable to any valid database column name in the related table

```Ruby
House.find_by_address("400 Broadway")
# => #<House:0x007f9ba147c220 @attributes={:id=>5, :address=>"400 Broadway"}>
```

##### where({ params })
The `where` method returns an array of all objects who fit the criteria given in `{ params }`

```Ruby
Human.where({ fname: "Matt", house_id: 1 })
# => #<Human:0x007f9ba1645278 @attributes={:id=>2, :fname=>"Matt", :lname=>"Rubens", :house_id=>1}>
```

#### Associations
An association class method defines a method on the class that calls it. This new method represents an association with another table and returns one or more new objects.
\*The `:primary_key`, `:foreign_key`, and `:class_name` options are all inferred by SQLObject. These can be overridden if the inferences are incorrect.

##### belongs_to
Used for a class that holds the foreign_key in an association

```Ruby
class Laptop < SQLObject
  belongs_to :owner,
    class_name: :Human,
    foreign_key: :owner_id,
    primary_key: :id

  finalize!
end

laptop = Laptop.find(2)
owner = laptop.owner
# => #<Human:0x007f9ba1c861f0 @attributes={:id=>4, :fname=>"Hazel", :lname=>"Peters"}>

laptop.owner_id == owner
# => true
```

##### has_one
Used for a class whose primary key is stored as the foreign_key of another object

```Ruby
class Human < SQLObject
  has_one :house

  finalize!
end

human = Human.find(1)
human.house
# => #<House:0x007f9ba @attributes={:id=>7, :address=>"999 North 5th"}>
```

##### has_many
Used for a class whose primary key is stored as the foreign_key of multiple other objects that share a class

```Ruby
class Human < SQLObject
  has_many :cats, foreign_key: :owner_id

  finalize!
end

human = Human.find(1)
human.cats
# => [#<Cat:0x007f9ba1667710 @attributes={:id=>9, :name=>"Supper", :owner_id=>1}>,
 #<Cat:0x007f9ba1667558 @attributes={:id=>14, :name=>"Grapejuice", :owner_id=>1}>]
```

##### has_one_through
Used for a class that has a secondary association to another class

```Ruby
class House < SQLObject
  has_many :dwellers, class_name: :human

  finalize!
end

class Human < SQLObject
  belongs_to :house

  finalize!
end

class Dog < SQLObject
  belongs_to :owner, class_name: :Human
  has_one_through :house, :owner, :house

  finalize!
end

```
