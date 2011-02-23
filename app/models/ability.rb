class Ability  
	include CanCan::Ability  
	   
	def initialize(current_user)
		current_user ||= User.new
		user = current_user 
		
		if user.role == "Admin"  
			can :manage, :all  
 		else  
			can :read, :all

			if user.role == "Moderator"
				can :create, Post 
				can :update, Post
				can :destroy, Post
				can :create, Comment 
				can :update, Comment
				can :destroy, Comment 
			end	
			
			if user.role == "Mitarbeiter"
				can :create, Post  
				can :update, Post do |post|  
					post.user_id == user.id 
				end
				can :destroy, Post do |post|  
					post.user_id == user.id 
				end
				can :create, Comment  
				can :update, Comment do |comment|  
					post.user_id == user.id 
				end
				can :destroy, Comment do |comment|  
					comment.user_id == user.id 
				end
			end
			
			if user.role == "Kunde"
				can :create, Post  
				can :update, Post do |post|  
					post.user_id == user.id 
				end
				can :create, Comment  
				can :update, Comment do |comment|  
					comment.user_id == user.id 
				end
			end
			
		end # :read, :all
	end  
end