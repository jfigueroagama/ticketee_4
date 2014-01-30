class Project < ActiveRecord::Base
  validates :name, presence: true
  # If we have callbacks use dependent: :destroy
  has_many :tickets, dependent: :delete_all
  # the as: options links your projects to the thing polymorphic association (thing_type => project)
  has_many :permissions, as: :thing
  # the joins method performs a INNER JOIN between permissions and projects (thing_id => project.id)
  # then we query on both tables columns with the where method. The query returns projects with
  # containing a related permission in the permissions table that has the action field = "view"
  # and the user.id of the user passed to the scope
  scope :viewable_by, ->(user) do
    joins(:permissions).where(permissions: { action: "view", user_id: user.id })
  end
  
  scope :for, ->(user) do
    user.admin? ? Project.all : Project.viewable_by(user)
  end
  
  def last_ticket
    # tickets is the method defined by the association between project -> tickets
    tickets.last
  end
end
