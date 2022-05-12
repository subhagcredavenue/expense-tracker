class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :amount, type: Integer
  field :type, type: String
  field :category, type: String
  field :date, type: Date

  belongs_to :user 
 
  validates :title, presence: true
  validates :amount, presence: true, numericality:{greater_than: 0, :message =>"%{value} :Amount should be > 0"}
  validates :type, inclusion: {in: ["DEBIT","CREDIT"], :message =>"Transaction type not valid"}
end
