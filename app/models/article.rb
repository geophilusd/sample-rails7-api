class Article < ApplicationRecord
  belongs_to :user

  before_save :calculate_word_count

  validates :subject, presence: true

  private

  def calculate_word_count
    self.word_count = description&.split(' ')&.size || 0
  end
end
