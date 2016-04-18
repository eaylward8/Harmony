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
        this.end_date = end_date;
        app.prescription.model.all.push(this);
      };
      prescription.prototype.prescriptionEl = function() {
        return '<div class="row drug-row"><a data-toggle="collapse" href="#collapsed-details-'+this.id+'" aria-expanded="false" aria-control="collapsed-details-'+this.id+'"><div class="prescription col-md-8 col-md-offset-2"><h2>'+this.drug.name+' <small id="prescription-'+this.id+'" drug-id="'+this.drug.id+'"> '+this.start_date+' </small></h2>'+this.detailsDiv()+'</div></a>';
      };
      prescription.prototype.detailsDiv = function(){
        return '<div class="collapse" id="collapsed-details-'+this.id+'"><p>Dose Size: '+this.dose_size+'</p><p>Refills: '+this.refills+'</p><p>Fill Duration: '+this.fill_duration+'</p><p>Start date: '+this.start_date+'</p><p>End date: '+this.end_date+'</p><p>Dr. '+this.doctor.first_name+ " "+this.doctor.last_name+'</p><p>Pharmacy: '+this.pharmacy.name+ " - " +this.pharmacy.location+'</p></div>';
      };
      prescription.prototype.build = function() {
        if (app.prescription.model.createDate(this.end_date) > Date.now()) {
          $('#active-prescriptions').append(this.prescriptionEl());  
        } else {
          $('#inactive-prescriptions').append(this.prescriptionEl());
        }        
      };
      prescription.prototype.build_first = function() {
        $('#prescriptions').prepend(this.prescriptionEl());
      };
      return prescription;
    }()),

    createDate: function(dateStr) {
      var year = Number(dateStr.split('-')[0]);
      var month = Number(dateStr.split('-')[1]) - 1;
      var day = Number(dateStr.split('-')[2]);
      return new Date(year, month, day);
    }
  },
};