require 'faker'

if Rails.env.development? || Rails.env.test?
  hospitals = [
    {
    name: 'RS Adven',
    address: 'Jalan Cihampelas No. 161, Kota Bandung, Jawa Barat'
    },
    {
    name: 'Rumah Sakit Santo Borromeus',
    address: 'Jl. Ir. H. Juanda No.100, Lebakgede, Kecamatan Coblong, Kota Bandung, Jawa Barat'
    },
    {
    name: 'RS Hasan Sadikin',
    address: 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung, Jawa Barat'
    },
    {
    name: 'RS. Sariningsih',
    address: 'Jl. L. L. R.E. Martadinata No.9, Citarum, Kec. Bandung Wetan, Kota Bandung, Jawa Barat '
    }
  ]

  hospitals.each do |hospital|
    hospital = Hospital.create(name: hospital[:name], address: hospital[:address])
    (1..5).to_a.each do |i|
      doctor = hospital.doctors.create(name: "Dr. #{Faker::Name.name}")
      doctor.schedules.create(day: i, start_time: "10:00", end_time: "13:00")
    end
  end
end
