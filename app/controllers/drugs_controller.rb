class DrugsController < ApplicationController
  skip_before_action :authorized?

  def create
    drug_validity = Drug.valid?(params[:drug_name])
    render json: { validity: drug_validity }
  end
end