// # == Schema Information
// #
// # Table name: prescriptions
// #
// #  id            :integer          not null, primary key
// #  refills       :integer
// #  fill_duration :integer
// #  start_date    :date
// #  end_date      :date
// #  doctor_id     :integer
// #  pharmacy_id   :integer
// #  user_id       :integer
// #  drug_id       :integer
// #  created_at    :datetime         not null
// #  updated_at    :datetime         not null
// #  dose_size     :string



app.prescription = {
  model: {
    all: [],
    new: (function () {
      var prescription = function Prescription(fill_duration, refills, start_date, dose_size, drug, doctor, pharmacy, user, id){
        this.drug = drug;
        this.fill_duration = fill_duration;
        this. refills = refills;
        this.start_date = start_date;
        this.dose_size = dose_size;
        this.id = id;
        this.doctor = doctor;
        this.pharmacy = pharmacy;
        this.user = user;
        this.end_date = start_date + fill_duration;
        app.prescription.model.all.push(this);
      };
      prescription.prototype.prescriptionEl = function() {
        // return '<div class="prescription"><h2><button class="destroy-prescription">x</button><a href="/prescriptions/'+this.id+'">'+this.name+'</a></h2><ul id="prescription-'+this.id+'" data-id="'+this.id+'"></ul></div>';
        // return '<div class="prescription"><h2><a href="/prescriptions/'+this.drug.name+'">'+this.user.first_name+'</a></h2><ul id="prescription-'+this.id+'" data-id="'+this.id+'"></ul></div>';
        return '<div class="prescription"><h2><a href="/prescriptions/'+this.id+'">'+this.drug.name+'</a></h2><ul id="prescription-'+this.id+'" drug-id="'+this.drug.id+'"><li>Dr. '+this.doctor.first_name+' '+this.doctor.last_name+'</li></ul></div>';
      };      
      prescription.prototype.build = function() {
         $('#prescriptions').append(this.prescriptionEl());
         // $('#task_prescription_id').append(this.optionEl());
      };
      return prescription;
    }())


  },
  controller: {
    new: (function () {
      var controller = function PrescriptionController() {
        // body...l
      }
      controller.prototype.init = function() {
        var that = this;

      };
    })
  }
}