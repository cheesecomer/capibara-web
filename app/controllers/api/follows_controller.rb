class Api::FollowsController < Api::ApplicationController
  def index
    @follows = current_user.follows.joins(:target)
  end

  def create
    @follow = Follow.create! create_params.merge(owner: current_user)
    render :show
  end

  def destroy
    follow = Follow.find params[:id]
    raise Forbidden if follow.owner != current_user
    follow.destroy!
    head :no_content
  end

  def create_params
    params.require(:follow).permit(:target_id)
  end
end