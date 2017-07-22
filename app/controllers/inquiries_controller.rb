class InquiriesController < ApplicationController
  def index
    @inquiry = Inquiry.new
  end

  def confirm
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.valid?
      render :confirm
    else
      render :index
    end
  end

  def thanks
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.send_inquiry_recieved_email
    @inquiry.send_inquiry_sended_email

    render :thanks
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :inquiry_title, :message)
  end
end
