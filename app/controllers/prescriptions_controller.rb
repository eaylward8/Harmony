class PrescriptionsController < ApplicationController
  # before_filter :authorized?

  def index
    @user = current_user
    @prescriptions = current_user.prescriptions.all
    @prescription = Prescription.new
    
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
    # binding.pry
    # respond_to do |format|
    #   format.html {
    #     render_to_string(partial: 'new_presciption_form')
    #   }
    # end
    render :partial => "/prescriptions/new_prescription_form", :locals => { :prescription => @prescription }
  end

  def edit
    # Form to edit a prescription
    @prescription = Prescription.find(params[:id])

  end

  def create
    @prescription = Prescription.new(prescription_params)
    @prescription.user = current_user
    new_drug = Adapters::DrugClient.find_by_name(drug_params[:name])
    new_drug_params = {name: new_drug.name, rxcui: new_drug.rxcui}
    @prescription.drug = Drug.find_or_create_by(new_drug_params)
    @prescription.drug.persist_interactions(current_user)
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
    # redirect_to prescription_path(@prescription)
    # @user = current_user
    # render :partial => "/users/pillbox_cells", :locals => { :user => @user }
    @user = current_user
    respond_to do |format|
      format.html { redirect_to @user, notice: 'User was successfully created.' }
      format.js {}
      format.json { render json: @user, status: :created, location: @user }
    end
    # render(json: {prescription: @prescription}, include: [:drug, :user, :doctor, :pharmacy, :scheduled_doses])
    # render json: {prescription: @prescription}
    # redirect_to user_path(current_user)
    # Creates a new prescription
  end

  def update
    # Updates a prescription
    @prescription = Prescription.find(params[:id])

    if params[:refill]
      @prescription.refills -= 1
      @prescription.end_date += @prescription.fill_duration
      @prescription.save
      redirect_to current_user
    else
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
