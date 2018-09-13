class CatRentalRequestsController < ApplicationController
  before_action :status_allowed
  helper_method :current_cat
  
  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end
  
  def status_allowed
    current_user.id == current_cat.user_id
  end
  
  def current_cat
    current_cat_rental_request.cat
  end

  private

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end
end
