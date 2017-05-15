class Trainer::TestsController < TrainerController
  before_action :load_tests, only: :index

  def index
  end

  def update
    array_answer_ids = []
    array_result_ids = []
    hash_mutiple = {}
    hash_temp = {}
    hash_result = {}
    hash_temp_result = {}
    @test = Test.find_by id: params[:id]
    @result_test = @test.results
    @question_test = @test.question
    @question_test.each do |question|
      if question.single?
        array_answer_ids << question.answers.where(is_correct: true).ids
      else
        hash_temp[question.id] = question.answers.where(is_correct: true).ids.sort
        hash_mutiple = hash_mutiple.merge(hash_temp)
      end
    end
    array_answer_ids = array_answer_ids.flatten.to_a
    @result_test.each do |result|
      if result.question.single?
        array_result_ids << JSON.parse(result.answer_ids)
      else
        hash_temp_result[result.question.id] = JSON.parse(result.answer_ids)
        hash_result = hash_result.merge(hash_temp_result)
      end
    end
    answer_correct_hash_multiple = hash_result.select{|k,x|  hash_mutiple.has_key?(k) && hash_mutiple.has_value?(x.sort)}
    array_result_ids = array_result_ids.flatten.to_a
    array_answer_correct_single = array_result_ids.select{|x| array_answer_ids.include?(x)}
    binding.pry
    array_answer_correct = answer_correct_hash_multiple.count + array_answer_correct_single.count
    @message = if @test.update_attributes(score: array_answer_correct, status: 3)
      "Complete the test mark"
    else
      "Unfinished test mark"
    end
    respond_to do |format|
      format.js { render template: "trainer/tests/index.js.erb" }
    end
  end

  private

  def load_tests
    @trainees = current_user.trainees
    @tests = []
    if @trainees
      @trainees.each do |trainee|
        array_ids = trainee.user_subjects.ids
        @tests << Test.where(user_subject_id: array_ids)
      end
    end
  end
end
