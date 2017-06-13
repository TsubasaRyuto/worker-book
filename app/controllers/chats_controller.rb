# == Schema Information
#
# Table name: chats
#
#  id                :integer          not null, primary key
#  agreement_id      :integer          not null
#  sender_username   :string(255)      not null
#  receiver_username :string(255)      not null
#  message           :text(65535)      not null
#  read_flg          :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_chats_on_agreement_id  (agreement_id)
#

class ChatsController < ApplicationController
  before_action :signed_in_client, only: [:show]
  before_action :correct_agreement_chats, only: [:show]

  def show
    if @partner_user
      @agreement = (@partner_user.client.agreements & current_user.agreements).first if current_user_type_worker
      @agreement = (@partner_user.agreements & current_user.client.agreements).first if current_user_type_client_user
      @chats = @agreement.chats.all.includes(client: :client_users)
    end
    @agreements = @current_user.agreements.includes(:job_content, job_content: { client: :client_users }) if current_user_type_worker
    @agreements = @current_user.client.agreements if current_user_type_client_user
  end

  private

  def signed_in_client
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('views.common.info.danger.not_signed_in')
      redirect_to sign_in_url
    end
  end

  def correct_agreement_chats
    @current_user = current_user
    @partner_user = Worker.find_by(username: params[:partner_username]) || ClientUser.find_by(username: params[:partner_username])
    if @current_user.class == @partner_user.class
      flash[:danger] = I18n.t('views.common.info.danger.invalid_username')
      redirect_to '/chat/messages/@workerbook'
      return
    end
    invalid_receiver_of_client_user_parameter if current_user_type_worker
    invalid_receiver_of_worker_parameter if current_user_type_client_user
  end

  def current_user_type_worker
    @current_user.class == Worker
  end

  def current_user_type_client_user
    @current_user.class == ClientUser
  end

  def invalid_receiver_of_worker_parameter
    unless params[:partner_username] == 'workerbook' || (@partner_user.agreements & @current_user.client.agreements).present?
      flash[:danger] = I18n.t('views.common.info.danger.invalid_username')
      redirect_to '/chat/messages/@workerbook'
    end
  end

  def invalid_receiver_of_client_user_parameter
    unless params[:partner_username] == 'workerbook' || (@partner_user.client.agreements & @current_user.agreements).present?
      flash[:danger] = I18n.t('views.common.info.danger.invalid_username')
      redirect_to '/chat/messages/@workerbook'
    end
  end
end
