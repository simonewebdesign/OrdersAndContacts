class Order < ActiveRecord::Base
  belongs_to :contact

  # Accessing directly to a specific class
  # def contact
  #   super.specific
  # end
end
