class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :DOB, type: String

  has_many :transactions
end
