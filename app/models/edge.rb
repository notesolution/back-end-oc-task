class Edge < ApplicationRecord

  include ActiveChapter

  belongs_to :chapter

  belongs_to :parent_room , class_name: 'Room', foreign_key: 'room_parent_id'
  belongs_to :child_room  , class_name: 'Room', foreign_key: 'room_child_id'

  #don't need this, can use asssociations
  #before_validation :assign_chapter

end
