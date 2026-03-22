class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true, inclusion: { in: %w[todo in_progress done] }

  attribute :status, :string, default: "todo"
end
