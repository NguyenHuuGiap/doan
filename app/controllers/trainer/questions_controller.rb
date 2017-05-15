class Trainer::QuestionsController < TrainerController
  before_action :load_questions, only: :index
  before_action :load_question, except: [:new, :create, :index]
  before_action :load_categories, only: [:new, :create, :edit, :update]

  def index
  end

  def new
    @question = Question.new
    @question.answers.build
  end

  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = t "question_admin.create_success"
      redirect_to trainer_questions_path
    else
      flash[:danger] = t "question_admin.create_fail"
      render :new
    end
  end

  def edit;end

  def update
    if @question.update_attributes question_params
      flash[:success] = "Update success"
      redirect_to trainer_questions_path
    else
      flash[:danger] = "Update Faild"
      render :edit
    end
  end

  def destroy
    if @question.destroy
      respond_to do |format|
        format.html {redirect_to questions_url}
        format.js
      end
    end
  end

  private

  def load_questions
    @questions = Question.all
  end

  def question_params
    params.require(:question).permit :content, :level, :subject_id,
      answers_attributes: [:id, :content, :is_correct]
  end

  def load_question
    @question = Question.find_by id: params[:id]
    if @question.nil?
      flash[:success] = t "question_admin.not_found"
      redirect_to admin_root_path
    end
  end

  def load_categories
    @subjects = Subject.all
  end
end
