class Room < ApplicationRecord

  include ActiveChapter

  belongs_to :chapter
  belongs_to :door

  has_many :edges, foreign_key: 'room_parent_id'

  validates :door_id, presence: true
  validates :chapter, presence: true
  validates :number , presence: true,
                      numericality: {
                                      greater_than_or_equal_to: 1,
                                      less_than_or_equal_to: 45
                                    }

  before_validation :assign_door
  
  #dont need this, can use associations
  #before_validation :assign_chapter

  scope :active, -> (chapter_id) { where(chapter_id: chapter_id) }

  delegate :thumbnail, to: :door, prefix: false, allow_nil: true

  def assign_door
    door  = if self.final
              Door.where(final: true).first
            else
              door_id = ( Door.all_ids - used_door_ids ).sample
              Door.where(id: door_id).try(:first)
            end

    self.door = door
  end

  def used_door_ids
    Room.where(chapter_id: self.chapter_id).pluck(:door_id)
  end

  def available_rooms
    Room.where( id: self.edges.pluck(:room_child_id) )
  end

end
