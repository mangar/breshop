# == Schema Information
# Schema version: 20081130150919
#
# Table name: psproducts
#
#  id               :integer         not null, primary key
#  pstransaction_id :string(255)
#  product_id       :string(255)
#  description      :string(255)
#  price            :string(255)
#  quantity         :string(255)
#  freight_value    :string(255)
#  extra            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Psproduct < ActiveRecord::Base
  belongs_to :pstransaction
end
