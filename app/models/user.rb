class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :email, type: String
  field :password, type: String
  field :DOB, type: String

  has_many :transactions, dependent: :destroy

  validates_uniqueness_of :email, message: "Email already exists"

  # def serializable_hash(options={})
  #   {
  #     id: id,
  #   name: name,
  #   email: email,
  #     transactions: transactions.inject([]) { |acc, m| acc << m.serializable_hash; acc }
  #   }
  # end
end
