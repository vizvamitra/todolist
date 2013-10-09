class Need < ActiveRecord::Base
  validates :text, presence: true
end
