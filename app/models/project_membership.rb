class ProjectMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :player
end
