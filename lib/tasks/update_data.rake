namespace :db do
  require "business_time"
  desc "rake update data"
  task update_data: :environment do
    Rake::Task["db:rake_course_location"].invoke
    Rake::Task["db:rake_trainee_progress"].invoke
    Rake::Task["db:rake_training_end_date"].invoke
  end

  task rake_course_location: :environment do
    Course.all.each do |course|
      location_id = course.load_trainers.first.try :profile_location_id
      course.update_attributes location_id: location_id
    end
    puts "Update location success"
  end

  task rake_trainee_progress: :environment do
    User.trainees.each do |trainee|
      user_subjects = UserSubject.where(user_id: trainee.id).order 'updated_at DESC'
      if user_subjects.size > 0
        if user_subject = user_subjects.finish.first
          user_subject.update_attributes current_progress: true
        elsif user_subject = user_subjects.progress.first
          user_subject.update_attributes current_progress: true
        end
      end
    end
    puts "Update current progress success"
  end

  task rake_training_end_date: :environment do
    User.trainees.each do |trainee|
      start_date = trainee.profile.start_training_date
      working_day = trainee.profile.working_day
      if start_date
        finish_date = (40*7/((working_day && working_day > 0) ? working_day : 5) - 1)
          .to_i.business_days.after start_date
        trainee.profile.update_attributes finish_training_date: finish_date
      end
    end
    puts "Update finish training date complete"
  end
end
