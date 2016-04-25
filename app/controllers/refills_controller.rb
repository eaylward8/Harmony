class RefillsController < ApplicationController
  skip_before_action :authorized?

  def update
    @prescription = Prescription.find(params[:id])
    @prescription.refill
    if @prescription.ending_within_week?
      @formatted_date = @prescription.format_date(@prescription.end_date)
      render(json: {prescription: @prescription, expSoon: true, expDate: @formatted_date}, include: [:drug])
    else
      render(json: {prescription: @prescription}, include: [:drug])
    end
  end
end