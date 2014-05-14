require 'mongoid'

class Organization
  include Mongoid::Document
  include Mongoid::Timestamps

  field :address1
  field :address2
  field :city
  field :state
  field :zipcode
  field :phone_number

end