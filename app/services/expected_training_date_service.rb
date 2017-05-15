class ExpectedTrainingDateService
  def initialize course
    @course = course
  end

  def expected_training_end_date
    @course.load_trainees.includes(:profile).each do |trainee|
      trainee.profile.update_attributes finish_training_date: @course.end_date
    end
  end
end
