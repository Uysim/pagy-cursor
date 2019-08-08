class Post < ApplicationRecord
  
  before_create :set_uuid # for test with uuid

  def set_uuid
    self.id = SecureRandom.uuid
  end
end
