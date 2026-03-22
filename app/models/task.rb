class Task < ApplicationRecord
  belongs_to :user

  enum :status, { created: "created", in_progress: "in_progress", done: "done" }
end
