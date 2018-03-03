class Chapter < ApplicationRecord

  attr_accessor :rooms_count

  has_many :rooms, dependent: :destroy
  has_many :edges, dependent: :destroy

  validate :uniq_active
  validate :room_limits
  validate :unique_number

  #it is possible to create a new chapter without selecting active, need to enforce rule 7.
  before_create :make_active

  #change this to after create so that I have an id... nothing in the rules say it needs to be created before saving.
  after_create :generate_rooms_and_edges

  #this scope is not chainable, and returns the whole data set if it fails to find one. If it does find one it's returns as an ActiveRecord set instead of a single record
  #scope :current_active, -> { where(active: true).first }

  def self.active
    where(active: true).last
  end

  private

  def generate_rooms_and_edges
    (1..self.rooms_count.to_i).to_a.each do |i|
      room = self.rooms.create(number: i, final: i == self.rooms_count.to_i)
    end

    room_numbers = (1..self.rooms_count.to_i-1).to_a

    adj_matrix = Matrix.build(self.rooms_count.to_i){0}
    adj_arr = adj_matrix.to_a
    
    #build path
    path_steps = rand(1..self.rooms_count.to_i-1)
    current_room = 1

    (1..path_steps-1).each do
      next_room = (room_numbers - [current_room]).sample
      adj_arr[current_room-1][next_room-1] = 1
      current_room = next_room
    end

    #terminate path
    adj_arr[current_room-1][self.rooms_count.to_i-1] = 1

    #randomize other edges
    room_numbers.each do |room_number|
      unused_rooms = room_numbers + [self.rooms_count.to_i] - [room_number]
      edge_count = rand(1..self.rooms_count.to_i-1)
      (1..edge_count).each do
        next_room = unused_rooms.sample
        adj_arr[room_number-1][next_room-1] = 1
        unused_rooms = unused_rooms - [next_room]
      end
    end

    #build edges from adjacency array
    adj_arr.each_with_index do |row, i|
      parent_room = self.rooms.where(number: i+1).first
      row.each_with_index do |col, j|
        if col == 1
          child_room = self.rooms.where(number: j+1).first
          self.edges.create(parent_room: parent_room, child_room: child_room)
        end
      end
    end
  end

  def make_active
    self.active = true
  end

  def unique_number
    if Chapter.where(number: self.number).first.present?
      errors.add(:number, 'there is already a chapter with that number')
    end
  end

  def uniq_active
    if self.active && Chapter.active
      errors.add(:active, 'only 1 active chapter may exists in the system')
    end
  end

  def room_limits
    if 2 > self.rooms_count.to_i || 45 < self.rooms_count.to_i
      errors.add(:rooms_count, 'must have between 2 and 45 rooms in a chapter')
    end
  end
end
