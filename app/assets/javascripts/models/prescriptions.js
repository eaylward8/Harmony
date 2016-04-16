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
      var prescription = function Prescription(fill_duration, refills, start_date, dose_size, drug, doctor, pharmacy, user, id, end_date){
        this.drug = drug;
        this.fill_duration = fill_duration;
        this. refills = refills;
        this.start_date = start_date;
        this.dose_size = dose_size;
        this.id = id;
        this.doctor = doctor;
        this.pharmacy = pharmacy;
        this.user = user;
        this.end_date = end_date
        app.prescription.model.all.push(this);
      };
      prescription.prototype.prescriptionEl = function() {
        return '<div class="row drug-row"><a data-toggle="collapse" href="#collapsed-details-'+this.id+'" aria-expanded="false" aria-control="collapsed-details-'+this.id+'"><div class="prescription col-md-8 col-md-offset-2"><h2>'+this.drug.name+' <small id="prescription-'+this.id+'" drug-id="'+this.drug.id+'"> '+this.start_date+' </small></h2>'+this.detailsDiv()+'</div></a>'
      };  

      prescription.prototype.detailsDiv = function(){
        return '<div class="collapse" id="collapsed-details-'+this.id+'"><p>Dose Size: '+this.dose_size+'</p><p>Refills: '+this.refills+'</p><p>Fill Duration: '+this.fill_duration+'</p><p>Start date: '+this.start_date+'</p><p>End date: '+this.end_date+'</p><p>Dr. '+this.doctor.first_name+ " "+this.doctor.last_name+'</p><p>Pharmacy: '+this.pharmacy.name+ " - " +this.pharmacy.location+'</p></div>'
      }

      prescription.prototype.build = function() {
         $('#prescriptions').append(this.prescriptionEl());
         // $('#task_prescription_id').append(this.optionEl());
      };
      prescription.prototype.build_first = function() {
         $('#prescriptions').prepend(this.prescriptionEl());
         // $('#task_prescription_id').append(this.optionEl());
      };
      return prescription;
    }())


  },
  controller: {
    new: function PrescriptionController() {
      
    }
  }
}

app.prescription.controller.new.prototype.init = function() {
  $('#form-submit').click(function(event) {
    event.preventDefault();
    var formData = $('form').serializeArray();
    $.ajax({
    url: '/prescriptions',
    method: 'POST',
    data: formData
    }).success(function(data) {
      var doctor = new app.doctor.model.new(data.prescription.doctor.first_name, data.prescription.doctor.last_name, data.prescription.doctor.location, data.prescription.doctor.specialty, data.prescription.doctor.id)
      var user = new app.user.model.new(data.prescription.user.first_name, data.prescription.user.last_name, data.prescription.user.id)
      var pharmacy = new app.pharmacy.model.new(data.prescription.pharmacy.name, data.prescription.pharmacy.location, data.prescription.pharmacy.id)
      var drug = new app.drug.model.new(data.prescription.drug.name, data.prescription.drug.rxcui, data.prescription.drug.id)

      var prescription = new app.prescription.model.new(data.prescription.fill_duration, data.prescription.refills, data.prescription.start_date, data.prescription.dose_size, drug, doctor, pharmacy, user, data.prescription.id, data.prescription.end_date);
      prescription.build_first();
      $("#close").click();
  })
});
}

