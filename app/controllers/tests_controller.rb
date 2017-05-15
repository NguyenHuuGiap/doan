class TestsController < ApplicationController
  before_action :load_test, only: [:show, :update, :destroy]
  before_action :load_tests, only: :index

  def index;end

  def show;end

  def create
    if params[:test]
      user_subject = UserSubject.find_by id: params[:test][:user_subject]
      user_subject.tests.create(status: 0)
      redirect_to :back
    end
  end

  def update
    params[:test][:results_attributes].each do |_index, result_params|
      array_answer = if result_params[:answer_ids].kind_of?(Array)
        result_params[:answer_ids].delete_if{|x| x == "0"}.map!(&:to_i)
      else
        [result_params[:answer_ids].to_i]
      end
      result = Result.find_by id: result_params[:id]
      if result.update_attributes answer_ids: array_answer
        @test.update_attributes status: 2
      end
    end
    flash[:success] = "Exam success"
    redirect_to tests_path
  end

  private
  def test_params
    params.require(:test).permit :id,
      results_attributes: [answer_ids: []]
  end

  def load_test
    @test = Test.find_by id: params[:id]
  end

  def load_tests
    user_subjects = current_user.user_subjects.ids
    @tests = Test.where user_subject_id: user_subjects
  end
end
