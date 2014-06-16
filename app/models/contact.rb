class Contact < ActiveRecord::Base
  acts_as_superclass
  validates_presence_of :name, :email

  def to_s
    "#{name} <#{email}>"
  end
end