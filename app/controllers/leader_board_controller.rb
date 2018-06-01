# frozen_string_literal: true

class LeaderBoardController < ApplicationController
  def index
    users = User.where.not(auth_id: nil, active: false).joins(:role).merge(Role.non_admin)
    @leader_list = LeaderBoard.generate_list(users)
  end
end
