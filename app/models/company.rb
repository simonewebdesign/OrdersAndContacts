class Company < ActiveRecord::Base
  acts_as :contact, auto_join: true
end
