class Person < ActiveRecord::Base
  acts_as :contact
  acts_as_superclass
end
