class Player < ActiveRecord::Base
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  has_many :aktions  
  has_many :teams_created, foreign_key: :creator_id

  has_many :team_memberships
  has_many :teams, through: :team_memberships
  has_many :project_memberships
  has_many :projects, through: :project_memberships
  has_many :role_assignments
  has_many :roles, through: :role_assignments

  def admin?
    role == 'admin'
  end

  def first_name
    name.split(' ').first
  end

  def gravatar(size = 24)
    gravatar_id = Digest::MD5.hexdigest(email.downcase) unless email.blank?
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=monsterid"
  end

  def init
    team = Team.initialize_for(self)
    return team if team.is_a? String
    [
      team,
      Role.initialize_for(team),
      Project.initialize_for(team)
    ]
  end

  def set_default_role
    if Player.count == 0
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
      end
    end
  end
end
