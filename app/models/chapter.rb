class Chapter < ApplicationRecord

  attr_accessor :rooms_count

  has_many :rooms
  has_many :edges

  validate :uniq_active

  before_create :generate_rooms_and_edges

  scope :active, -> { where(active: true).first }

  def self.active
    where(active: true).last
  end

  def generate_rooms_and_edges
    max_room = self.rooms_count.to_i
    new_room_list = []
    (1..max_room).each do |room_number|
      final = room_number == max_room
      new_room = self.rooms.build number: room_number, final: final
      new_room_list << new_room
    end
    
    order = if max_room == 2
              [1, 2]
            else
              [1] + (2..(max_room - 1)).to_a.shuffle + [max_room]
            end

    edges = {}
    order.each_with_index do |room_number, index|
      edges[room_number] = if room_number == max_room
                             [order&.[](index+1)].compact
                           else
                             random_pick_count = rand(1..max_room - 2)
                             random_edges = ((1..(max_room - 1)).to_a - [room_number]).sample(random_pick_count)
                             ([order&.[](index+1)] + random_edges).compact.uniq
                           end
    end

    edges.each do |parent_room_number, values|
      values.each do |child_room_number|
        parent_room = new_room_list[parent_room_number.to_i - 1]
        child_room  = new_room_list[child_room_number.to_i - 1]
    
        self.edges.build parent_room: parent_room, child_room: child_room
      end
    end
  end

  def uniq_active
    if self.active && Chapter.where(active: true).first
      errors.add(:active, 'only 1 active chapter may exists in the system')
    end
  end
end
