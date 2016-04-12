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
    @prescription = Prescription.new(prescription_params)
    @prescription.user = current_user
    new_drug = Drug.new.find_by(drug_params[:name])
    new_drug_params = {name: new_drug.name, rxcui: new_drug.rxcui}
    @prescription.drug = Drug.find_or_create_by(new_drug_params)
    # logic for doctor creation or associaton
    if params[:doc_type] == "new"
      @prescription.doctor = Doctor.find_or_create_by(doctor_params)
    else
      @prescription.doctor = Doctor.find(params[:doctor][:doctor].split(" ").first.to_i)
    end

    if params[:pharm_type] == "new"

      @prescription.pharmacy = Pharmacy.find_or_create_by(pharmacy_params)
    else
      @prescription.pharmacy = Pharmacy.find(params[:pharmacy][:pharmacy].split(" ").first.to_i)
    end

    @prescription.save

    scheduled_doses_params.each do |time_of_day, count|
      count.to_i.times do
    
        ScheduledDose.create(time_of_day: time_of_day, prescription_id: @prescription.id)
      end
    end

    
    @prescription.calculate_end_date
    redirect_to user_path(current_user)
    # Creates a new prescription
  end

  def update
    # Updates a prescription
    @prescription = Prescription.find(params[:id])
    new_drug = Drug.new.find_by(drug_params[:name])
    new_drug_params = {name: new_drug.name, rxcui: new_drug.rxcui}
    @prescription.drug = Drug.find_or_create_by(new_drug_params)
    @prescription.doctor = Doctor.find_or_create_by(doctor_params)
    @prescription.pharmacy = Pharmacy.find_or_create_by(pharmacy_params)
    @prescription.scheduled_doses.clear
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
    params.require(:doctor).permit(:first_name, :last_name, :location)
  end

  def pharmacy_params
    params.require(:pharmacy).permit(:name, :location)
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
