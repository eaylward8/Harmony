class PrescriptionsController < ApplicationController
  # before_filter :authorized?

  def index
    @prescriptions = current_user.prescriptions.all
    # View of all prescriptions for a user
    # - includes complete details about prescriptions
    # and (in JS) the option to view old prescriptions

  end

  def show
    @prescription = Prescription.find(params[:id])
  end

  def new
    # Form to enter a new prescription
    @prescription = Prescription.new

  end

  def edit
    # Form to edit a prescription
    @prescription = Prescription.find(params[:id])

  end

  def create
    @prescription = Prescription.create(prescription_params)
    new_drug_params = Drug.new.find_by(drug_params[:name])
    @prescription.drug = Drug.find_or_create_by(new_drug_params)
    @prescription.doctor = Doctor.find_or_create_by(doctor_params)
    @prescription.pharmacy = Pharmacy.find_or_create_by(pharmacy_params)
    
    scheduled_doses_params.each do |time_of_day, count|
      count.to_i.times do
        ScheduledDose.create(time_of_day: time_of_day, prescription_id: @prescription.id)
      end
    end

    @prescription.save
    redirect_to @prescription
    # Creates a new prescription
  end

  def update
    # Updates a prescription
    @prescription = Prescription.find(params[:id])
    new_drug_params = Drug.new.find_by(drug_params[:name])
    @prescription.drug = Drug.find_or_create_by(new_drug_params)
    @prescription.doctor = Doctor.find_or_create_by(doctor_params)
    @prescription.pharmacy = Pharmacy.find_or_create_by(pharmacy_params)

    scheduled_doses_params.each do |time_of_day, count|
      count.to_i.times do
        ScheduledDose.create(time_of_day: time_of_day, prescription_id: @prescription.id)
      end
    end
    redirect_to @prescription
  end

  def destroy
    # Destroys a prescription
  end

  private

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name)
  end

  def pharmacy_params
    params.require(:pharmacy).permit(:name)
  end

  def drug_params
    params.require(:drug).permit(:name)
  end

  def prescription_params
    params.require(:prescription).permit(:fill_duration, :refills, :start_date, :dose_size)
  end

  def scheduled_doses_params
    params.require(:scheduled_doses).permit(:morning, :afternoon, :evening, :bedtime)
  end
end
