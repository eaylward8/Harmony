
# == Schema Information
#
# Table name: prescriptions
#
#  id            :integer          not null, primary key
#  refills       :integer
#  fill_duration :integer
#  start_date    :date
#  end_date      :date
#  doctor_id     :integer
#  pharmacy_id   :integer
#  user_id       :integer
#  drug_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  dose_size     :string
#
