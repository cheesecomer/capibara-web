class UsersController < ApplicationController
    layout 'admin'

    def index
      @users = User.includes(:reports)
    end
  end
