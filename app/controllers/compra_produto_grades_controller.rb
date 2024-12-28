class CompraProdutoGradesController < ApplicationController
  # GET /compra_produto_grades
  # GET /compra_produto_grades.json
  def index
    @compra_produto_grades = CompraProdutoGrade.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @compra_produto_grades }
    end
  end

  # GET /compra_produto_grades/1
  # GET /compra_produto_grades/1.json
  def show
    @compra_produto_grade = CompraProdutoGrade.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @compra_produto_grade }
    end
  end

  # GET /compra_produto_grades/new
  # GET /compra_produto_grades/new.json
  def new
    @compra_produto_grade = CompraProdutoGrade.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @compra_produto_grade }
    end
  end

  # GET /compra_produto_grades/1/edit
  def edit
    @compra_produto_grade = CompraProdutoGrade.find(params[:id])
  end

  # POST /compra_produto_grades
  # POST /compra_produto_grades.json
  def create
    @compra_produto_grade = CompraProdutoGrade.new(params[:compra_produto_grade])

    respond_to do |format|
      if @compra_produto_grade.save
        format.html { redirect_to "/compras_produtos/#{@compra_produto_grade.compras_produto_id}" }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /compra_produto_grades/1
  # PUT /compra_produto_grades/1.json
  def update
    @compra_produto_grade = CompraProdutoGrade.find(params[:id])
    respond_to do |format|
      if @compra_produto_grade.update_attributes(params[:compra_produto_grade])
        format.html { redirect_to "/compras_produtos/#{@compra_produto_grade.compras_produto_id}" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /compra_produto_grades/1
  # DELETE /compra_produto_grades/1.json
  def destroy
    @compra_produto_grade = CompraProdutoGrade.find(params[:id])
    @compra_produto_grade.destroy

    respond_to do |format|
      format.html { redirect_to "/compras_produtos/#{@compra_produto_grade.compras_produto_id}" }
    end
  end
end
