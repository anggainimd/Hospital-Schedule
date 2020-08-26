class Api::V1::HospitalsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    hospitals = Hospital.all.map do |hospital|
      {
        id: hospital.id,
        name: hospital.name,
        address: hospital.address
      }
    end

    render json: {
      total: hospitals.count,
      results: hospitals
    }.to_json, status: :ok
  end

end
    