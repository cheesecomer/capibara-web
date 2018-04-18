class Api::FollowsController < Api::ApplicationController
  def index
    @follows = current_user.follows
  end

  def create
    Follow.create! create_params.merge(owner: current_user)
    @follows = current_user.follows
    render :index
  end

  def destroy
    follow = Follow.find params[:id]
    raise Forbidden if follow.owner != current_user
    follow.destroy!
  end

  def create_params
    params.require(:follow).permit(:target_id)
  end
end