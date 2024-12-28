class ProdutosGradesController < ApplicationController
  # GET /produtos_grades
  # GET /produtos_grades.json
  def index
    @produtos_grades = ProdutosGrade.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @produtos_grades }
    end
  end

  # GET /produtos_grades/1
  # GET /produtos_grades/1.json
  def show
    @produtos_grade = ProdutosGrade.find(params[:id])

    render layout: false
  end

  # GET /produtos_grades/new
  # GET /produtos_grades/new.json
  def new
    @produtos_grade = ProdutosGrade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @produtos_grade }
    end
  end

  # GET /produtos_grades/1/edit
  def edit
    @produtos_grade = ProdutosGrade.find(params[:id])
  end

  # POST /produtos_grades
  # POST /produtos_grades.json
  def create
    @produtos_grade = ProdutosGrade.new(params[:produtos_grade])


    respond_to do |format|
      if @produtos_grade.save
        format.html { redirect_to "/produtos/#{@produtos_grade.produto_id}" }
        format.json { render json: @produtos_grade, status: :created, location: @produtos_grade }
      else
        format.html { render action: "new" }
        format.json { render json: @produtos_grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /produtos_grades/1
  # PUT /produtos_grades/1.json
  def update
    @produtos_grade = ProdutosGrade.find(params[:id])

    respond_to do |format|
      if @produtos_grade.update_attributes(params[:produtos_grade])
        format.html { redirect_to "/produtos/#{@produtos_grade.produto_id}" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @produtos_grade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos_grades/1
  # DELETE /produtos_grades/1.json
  def destroy
    @produtos_grade = ProdutosGrade.find(params[:id])
    @produtos_grade.destroy

    respond_to do |format|
      format.html { redirect_to "/produtos/#{@produtos_grade.produto_id}" }
      format.json { head :no_content }
    end
  end
end
