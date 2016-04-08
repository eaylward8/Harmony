class PrescriptionsController < ApplicationController
  def index
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
    # Creates a new prescription
  end

  def update
    # Updates a prescription
  end

  def destroy
    # Destroys a prescription
  end
end
