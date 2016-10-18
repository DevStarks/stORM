## stORM

#### Overview
stORM is Object-Relational Mapping library inspired by ActiveRecord. stORM provides a base class `SQLObject` that, when inherited from, allows Ruby classes to easily query their related database table and return Ruby objects representing that data. These database-connected subclasses can be mapped to each other using associations.

#### Features
- a simple interface for generating SQL queries
- cross table referencing for object associations
- infers table-names, primary-keys, and foreign-keys when making associations resulting in elegant method calls

#### General usage:

Mapped classes inherit from `SQLObject` and call finalize! to generate getters and setters for object attributes:
```Ruby
class Cat < SQLObject
  finalize!
end
```

SQLObjects can query the database:
- returns all objects from the respective table
```Ruby
Cat.all
# => [[#<Cat:0x007f @attributes={:id=>1, :name=>"Breakfast"}>,
 #<Cat:0x007f @attributes={:id=>2, :name=>"Earl"}>,]
 ```
- queries using any object attribute
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

##### has_one

```Ruby
class Laptop < SQLObject
  belongs_to :owner, class_name: :Human

  finalize!
end

macbook = Laptop.find(1)

macbook.owner
# => #<Human:0x007f9ba @attributes={:id=>2, :fname=>"Matt", :lname=>"Rubens"}>
```
