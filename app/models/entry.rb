class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :feed

  validates :user,        presence: true
  validates :feed,        presence: true
  validates :external_id, presence: true
  validates :name,        presence: true
  validates :is_read,     inclusion: {in: [true, false]}
  validates :is_starred,  inclusion: {in: [true, false]}
end
