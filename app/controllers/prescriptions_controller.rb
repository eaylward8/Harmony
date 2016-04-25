class PrescriptionsController < ApplicationController
  # before_filter :authorized?

  def index
    @user = current_user
    @prescriptions = current_user.prescriptions.all
    @prescription = Prescription.new
  end

  def show
    @prescription = Prescription.find(params[:id])
  end

  def new
    # Form to enter a new prescription
    @prescription = Prescription.new
    render :partial => "/prescriptions/new_prescription_form", :locals => { :prescription => @prescription }
  end

  def edit
    # Form to edit a prescription
    @prescription = Prescription.find(params[:id])

  end

  def create
    @prescription = Prescription.new(prescription_params)
    @prescription.user = current_user
    find_or_create_drug
    @prescription.drug.persist_interactions(current_user)
    find_or_create_doctor
    find_or_create_pharmacy
    @prescription.save
    create_scheduled_doses
    @prescription.calculate_end_date
    @user = current_user
  end

  def update
    # Updates a prescription
   
    @prescription = Prescription.find(params[:id])

    if params[:refill]
      @prescription.refill
      if @prescription.ending_within_week?
        @formatted_date = @prescription.format_date(@prescription.end_date)
        render(json: {prescription: @prescription, expSoon: true, expDate: @formatted_date}, include: [:drug])
      else
        render(json: {prescription: @prescription}, include: [:drug])
      end
    else
      new_drug = Adapters::DrugClient.find_by_name(drug_params[:name])
      new_drug_params = {name: new_drug.name, rxcui: new_drug.rxcui}
      new_drug.save
      @prescription.drug = new_drug
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
      @prescription.refills =  prescription_params[:refills].to_i
      @prescription.fill_duration =  prescription_params[:fill_duration].to_i
      @prescription.start_date =  prescription_params[:start_date]
      @prescription.dose_size =  prescription_params[:dose_size]
      @prescription.scheduled_doses.clear
      scheduled_doses_params.each do |time_of_day, count|
        count.to_i.times do
          ScheduledDose.create(time_of_day: time_of_day, prescription_id: @prescription.id)
        end
      end
      @prescription.save
       render(json: {prescription: @prescription}, include: [:drug, :user, :doctor, :pharmacy, :scheduled_doses])
    end
  end

  def destroy
    # Destroys a prescription
    prescription = Prescription.find(params[:id])
    prescription.end_date = Date.today() - 1
    prescription.save
    redirect_to current_user
  end

  def json
    @prescriptions = current_user.prescriptions.sort_by { |p| p.end_date }
    render(json: {prescriptions: @prescriptions}, include: [:drug, :user, :doctor, :pharmacy, :scheduled_doses])
  end

  private

  def find_or_create_drug
    if Drug.find_by_name(drug_params[:name].capitalize)
      @prescription.drug = Drug.find_by_name(drug_params[:name].capitalize)
    else
      new_drug = Adapters::DrugClient.find_by_name(drug_params[:name])
      @prescription.drug = Drug.find_or_create_by({name: new_drug.name, rxcui: new_drug.rxcui})
    end
  end

  def find_or_create_doctor
    if params[:doc_type] == "new"
      @prescription.doctor = Doctor.create(doctor_params)
    else
      doctor_id = params[:doctor][:doctor].split(" ").first.to_i
      @prescription.doctor = Doctor.find(doctor_id)
    end
  end

  def find_or_create_pharmacy
    if params[:pharm_type] == "new"
      @prescription.pharmacy = Pharmacy.create(pharmacy_params)
    else
      pharmacy_id = params[:pharmacy][:pharmacy].split(" ").first.to_i
      @prescription.pharmacy = Pharmacy.find(pharmacy_id)
    end
  end

  def create_scheduled_doses
    scheduled_doses_params.each do |time_of_day, count|
      count.to_i.times do
        ScheduledDose.create(time_of_day: time_of_day, prescription_id: @prescription.id)
      end
    end
  end

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
