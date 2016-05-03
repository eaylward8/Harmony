class PrescriptionsController < ApplicationController
  skip_before_action :authorized?

  def index
    @user = current_user
    @prescriptions = current_user.prescriptions.all
    @prescription = Prescription.new
  end

  def show
    @prescription = Prescription.find(params[:id])
  end

  def new
    @user = current_user
    @prescription = Prescription.new
    render :partial => "/prescriptions/new_prescription_form",
    :locals => { :prescription => @prescription, :user => @user }
  end

  def edit
    @user = current_user
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
    @prescription = Prescription.find(params[:id])
    @prescription.update(prescription_params)
    drug = Adapters::DrugClient.find_by_name(drug_params[:name])
    drug.save
    @prescription.drug = drug
    find_or_create_doctor
    find_or_create_pharmacy
    @prescription.save
    @prescription.scheduled_doses.clear
    create_scheduled_doses
    render(json: {prescription: @prescription}, include: [:drug, :user, :doctor, :pharmacy, :scheduled_doses])
  end

  def destroy
    prescription = Prescription.find(params[:id])
    prescription.end_date = Date.today() - 1
    prescription.save
    redirect_to current_user
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