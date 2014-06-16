== README

Testing the [acts_as_relation](https://github.com/hzamani/acts_as_relation) gem that implements MTI (multi-table inheritance) in ActiveRecord.

The following are the steps I made:

```
$ rails new OrdersAndContacts --database=postgresql

order
  id
  contact_id

contact (acts_as_superclass)
  id
  name
  email

person (acts_as :contact)
  id
  age

company (acts_as :contact)
  id
  website

$ rails generate scaffold contact name email
$ rails generate scaffold person age:integer
$ rails generate scaffold company website
$ rails generate scaffold order contact:references
```

## Models

```
class Contact < ActiveRecord::Base
  acts_as_superclass
end

class Order < ActiveRecord::Base
  belongs_to :contact
end

class Person < ActiveRecord::Base
  acts_as :contact
end

class Company < ActiveRecord::Base
  acts_as :contact
end
```

## Edit migration

```
class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts, as_relation_superclass: true do |t|
      ...
    end
  end
end
```

## Running rake db:migrate

```
> rake db:migrate
== 20140616092921 CreateContacts: migrating ===================================
-- create_table(:contacts, {:as_relation_superclass=>true})
   -> 0.0354s
== 20140616092921 CreateContacts: migrated (0.0356s) ==========================

== 20140616092947 CreatePeople: migrating =====================================
-- create_table(:people)
   -> 0.0035s
== 20140616092947 CreatePeople: migrated (0.0036s) ============================

== 20140616093000 CreateCompanies: migrating ==================================
-- create_table(:companies)
   -> 0.0023s
== 20140616093000 CreateCompanies: migrated (0.0024s) =========================

== 20140616093243 CreateOrders: migrating =====================================
-- create_table(:orders)
   -> 0.0048s
== 20140616093243 CreateOrders: migrated (0.0049s) ============================
```

## Adding more functionality to Contact

```
class Contact < ActiveRecord::Base
  acts_as_superclass
  validates_presence_of :name, :email

  def to_s
    "#{name} <#{email}>"
  end
end
```

## Usage

Now you should be able to test the relation via the Rails console:

``` ruby
> Person.create name: "John", email: "john@doe.org", age: 42
   (0.2ms)  BEGIN
  SQL (0.4ms)  INSERT INTO "people" ("age", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"  [["age", 42], ["created_at", "2014-06-16 13:23:48.278377"], ["updated_at", "2014-06-16 13:23:48.278377"]]
  SQL (0.2ms)  INSERT INTO "contacts" ("as_contact_id", "as_contact_type", "created_at", "email", "name", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"  [["as_contact_id", 5], ["as_contact_type", "Person"], ["created_at", "2014-06-16 13:23:48.281915"], ["email", "john@doe.org"], ["name", "John"], ["updated_at", "2014-06-16 13:23:48.281915"]]
   (6.6ms)  COMMIT
=> #<Person id: 5, age: 42, created_at: "2014-06-16 13:23:48", updated_at: "2014-06-16 13:23:48">

> Contact.last
  Contact Load (0.5ms)  SELECT  "contacts".* FROM "contacts"   ORDER BY "contacts"."id" DESC LIMIT 1
=> #<Contact id: 11, as_contact_id: 5, as_contact_type: "Person", name: "John", email: "john@doe.org", created_at: "2014-06-16 13:23:48", updated_at: "2014-06-16 13:23:48">

> Contact.last.specific
  Contact Load (0.6ms)  SELECT  "contacts".* FROM "contacts"   ORDER BY "contacts"."id" DESC LIMIT 1
  SQL (0.4ms)  SELECT  "people"."id" AS t0_r0, "people"."age" AS t0_r1, "people"."created_at" AS t0_r2, "people"."updated_at" AS t0_r3, "contacts"."id" AS t1_r0, "contacts"."as_contact_id" AS t1_r1, "contacts"."as_contact_type" AS t1_r2, "contacts"."name" AS t1_r3, "contacts"."email" AS t1_r4, "contacts"."created_at" AS t1_r5, "contacts"."updated_at" AS t1_r6 FROM "people" INNER JOIN "contacts" ON "contacts"."as_contact_id" = "people"."id" AND "contacts"."as_contact_type" = 'Person' WHERE "people"."id" = $1 LIMIT 1  [["id", 5]]
=> #<Person id: 5, age: 42, created_at: "2014-06-16 13:23:48", updated_at: "2014-06-16 13:23:48">
irb(main):028:0>
```

## Database schema

The generated database schema is as follows:

                                     Table "companies"
   Column   |            Type             |                       Modifiers
------------+-----------------------------+--------------------------------------------------------
 id         | integer                     | not null default nextval('companies_id_seq'::regclass)
 website    | character varying(255)      |
 created_at | timestamp without time zone |
 updated_at | timestamp without time zone |
Indexes:
    "companies_pkey" PRIMARY KEY, btree (id)


                                        Table "contacts"
     Column      |            Type             |                       Modifiers
-----------------+-----------------------------+-------------------------------------------------------
 id              | integer                     | not null default nextval('contacts_id_seq'::regclass)
 as_contact_id   | integer                     |
 as_contact_type | character varying(255)      |
 name            | character varying(255)      |
 email           | character varying(255)      |
 created_at      | timestamp without time zone |
 updated_at      | timestamp without time zone |
Indexes:
    "contacts_pkey" PRIMARY KEY, btree (id)


                                     Table "orders"
   Column   |            Type             |                      Modifiers
------------+-----------------------------+-----------------------------------------------------
 id         | integer                     | not null default nextval('orders_id_seq'::regclass)
 contact_id | integer                     |
 created_at | timestamp without time zone |
 updated_at | timestamp without time zone |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
    "index_orders_on_contact_id" btree (contact_id)


                                     Table "people"
   Column   |            Type             |                      Modifiers
------------+-----------------------------+-----------------------------------------------------
 id         | integer                     | not null default nextval('people_id_seq'::regclass)
 age        | integer                     |
 created_at | timestamp without time zone |
 updated_at | timestamp without time zone |
Indexes:
    "people_pkey" PRIMARY KEY, btree (id)

