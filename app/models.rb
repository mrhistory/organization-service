require 'mongoid'

class Organization
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :address1
  field :address2
  field :city
  field :state
  field :zipcode
  field :phone_number
  field :admins, type: Array

  validates_presence_of :name

  has_many :applications
end

class Application
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :url
  field :icon_image_url

  validates_presence_of :name

  belongs_to :organization
end