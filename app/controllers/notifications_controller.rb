class NotificationsController < ApplicationController
  def index
    @user_notifications = current_user.user_notifications.select_notifications
      .per_page_kaminari(params[:page]).per Settings.per_page
  end

  def update
    notifications = current_user.user_notifications.not_seen
    notifications.update_all seen: true
    respond_to do |format|
      format.js
    end
  end
end
