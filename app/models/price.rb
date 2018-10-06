class Price < ApplicationRecord
  belongs_to :to_currency, class_name: "Currency", foreign_key: "to_currency_id"
  belongs_to :from_currency, class_name: "Currency", foreign_key: "from_currency_id"
end
