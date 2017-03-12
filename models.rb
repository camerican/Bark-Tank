# models.rb
require './uploader/image_uploader'

class User < ActiveRecord::Base
  enum role: [:staff, :hotsource, :spartan]
  enum status: [:pending, :active, :inactive]
  mount_uploader :photo, ImageUploader
  has_many :project_members
  has_many :teams, through: :project_members, source: :project
  has_many :project_ratings
  has_many :reviews, through: :project_ratings, source: :project

  def name
    "#{self.name_first} #{self.name_last}"
  end
end
class Project < ActiveRecord::Base
  mount_uploader :logo, ImageUploader
  has_many :project_members
  has_many :members, through: :project_members, source: :user
  has_many :project_reviewers
  has_many :reviewers, through: :project_ratings, source: :user
end
class ProjectMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end
class ProjectRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
end
