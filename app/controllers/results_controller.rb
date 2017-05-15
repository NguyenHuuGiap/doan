class ResultsController < ApplicationController

  def index
    @array_questions = []
    @test = Test.find_by id: params[:id_test]
    result_test = @test.results
    result_test.each do |result|
      answer_ids = result.question.answers.where(is_correct: true).ids.sort
      answer_result_ids = JSON.parse(result.answer_ids).sort
      if answer_ids == answer_result_ids
        @array_questions << result.question.id
      end
    end
  end
end
