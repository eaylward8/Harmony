class DrugsController < ApplicationController
  skip_before_action :authorized?

  def create
    drug_validity = Drug.is_valid_drug?(params[:drug_name].capitalize)
    render json: {validity: drug_validity}
  end
end