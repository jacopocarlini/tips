class StaticPagesController < ApplicationController

  def home
	@pois={}
	@pois[:recent] = Poi.order(updated_at: :desc).limit(4)
	#@pois[:popular] += Poi.order(updated_at: :desc).limit(5)
	@pois
  end

  def my_profile
  end

	
  def profile
    @user = User.find(params[:id])
  end

  def list_users
	@users = User.where("username LIKE ? ", "%#{params[:user]}%").or(User.where("email LIKE ? ", "%#{params[:user]}%"))
  end
	
  def find_users	
  end
  
 

end
