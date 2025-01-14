require "rails_helper"

RSpec.describe "Doctors Show Page", type: :feature do
  before :each do
    @hospital1 = Hospital.create!(name: "Grey Sloan Memorial Hospital")
    @hospital2 = Hospital.create!(name: "Seaside Health & Wellness Center")

    @doctor1 = Doctor.create!(hospital_id: @hospital1.id, name: "Meredith Grey", specialty: "General Surgery", university: "Harvard University")
    @doctor2 = Doctor.create!(hospital_id: @hospital2.id, name: "Alex Karev", specialty: "Pediatric Surgery", university: "Johns Hopkins University")

    @patient1 = Patient.create!(name: "Katie Bryce", age: 24)
    @patient2 = Patient.create!(name: "Denny Duquette", age: 39)
    @patient3 = Patient.create!(name: "Rebecca Pope", age: 32)

    PatientDoctor.create!(patient_id: @patient1.id, doctor_id: @doctor1.id)
    PatientDoctor.create!(patient_id: @patient1.id, doctor_id: @doctor2.id)
    PatientDoctor.create!(patient_id: @patient2.id, doctor_id: @doctor1.id)
    PatientDoctor.create!(patient_id: @patient3.id, doctor_id: @doctor2.id)
  end

  #US1
  describe "As a visitor" do
    describe "When I visit a doctors show page" do
      describe "I see all that doctors information (name, specialty, university)" do
        it "And I see the name of their hospital and the names of their patients this doctor has" do
         
          visit "/doctors/#{@doctor1.id}"

          expect(page).to have_content(@doctor1.name)
          expect(page).to have_content(@doctor1.specialty)
          expect(page).to have_content(@doctor1.university)

          expect(page).to have_content(@doctor1.hospital.name)

          expect(page).to have_content(@patient1.name)
          expect(page).to have_content(@patient2.name)

          expect(page).to_not have_content(@doctor2.name)
          expect(page).to_not have_content(@patient3.name)
          expect(page).to_not have_content(@hospital2.name)
        end
      end

      #US2
      describe "Next to each patient's name, I see a button to remove that patient from that doctors caseload" do
        describe "When I click that button for one patient I'm brought back to the doctors show page" do
          describe "And I no longer see that patient listed" do
            it "when I visit a different doctors show page caring for the same patient, I still see that patient on their caseload" do

              visit "/doctors/#{@doctor1.id}"

              expect(page).to have_content(@patient1.name)
              expect(page).to have_content(@patient2.name)

              expect(page).to have_button("Remove #{@patient1.name}")
              expect(page).to have_button("Remove #{@patient2.name}")
              
              click_button("Remove #{@patient1.name}")

              expect(current_path).to eq("/doctors/#{@doctor1.id}")

              expect(page).to_not have_content(@patient1.name)

              visit "/doctors/#{@doctor2.id}"

              expect(page).to have_content(@patient1.name)
            end
          end
        end
      end
    end
  end
end