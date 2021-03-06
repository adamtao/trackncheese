class Ability 
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    user ||= User.new

    can :create, Project # even guests can create projects
    can :manage, Project do |p|
      user.projects.include?(p)
    end

    can :create, Song # even guests can create songs
    can :manage, Song do |s|
      user.projects.include?(s.project)
    end

    can :manage, Task do |t|
      if t.project
        user.projects.include?(t.project)
      elsif t.song
        user.projects.include?(t.song.project)
      end
    end

    can :manage, SongAttachment do |sa|
      if sa.song && sa.song.project
        user.projects.include?(sa.song.project)
       end
    end

  end
end
