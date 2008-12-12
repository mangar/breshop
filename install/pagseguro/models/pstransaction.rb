# == Schema Information
# Schema version: 20081130150919
#
# Table name: pstransactions
#
#  id             :integer         not null, primary key
#  transaction_id :string(255)
#  seller_email   :string(255)
#  ref            :string(255)
#  freight_type   :string(255)
#  freight_value  :string(255)
#  extras         :string(255)
#  annotation     :string(255)
#  payment_type   :string(255)
#  status         :string(255)
#  cli_name       :string(255)
#  cli_address    :string(255)
#  cli_email      :string(255)
#  cli_number     :string(255)
#  cli_complement :string(255)
#  cli_district   :string(255)
#  cli_city       :string(255)
#  cli_state      :string(255)
#  cli_zip        :string(255)
#  cli_phone      :string(255)
#  count_itens    :string(255)
#  checked        :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Pstransaction < ActiveRecord::Base
  has_many :psproducts
end
