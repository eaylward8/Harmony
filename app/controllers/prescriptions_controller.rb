class PrescriptionsController < ApplicationController
  before_filter :authorize, only: [:edit, :update]

  def index
    u = User.all.first
    u.doses_by_time_of_day('morning')
    @prescriptions = current_user.prescriptions.all
    # View of all prescriptions for a user
    # - includes complete details about prescriptions
    # and (in JS) the option to view old prescriptions

  end

  def show
    @prescription = User.first.prescriptions.first
  end

  def new
    # Form to enter a new prescription
    @prescription = Prescription.new
  end

  def edit
    # Form to edit a prescription
  end

  def create
    byebug
    # Creates a new prescription
  end

  def update
    # Updates a prescription
  end

  def destroy
    # Destroys a prescription
  end
end
