class CensoNomesController < ApplicationController
    def hello
      render json: { message: 'Hello, World!' }
    end
  
    def create
      nome = params[:nome]
      sexo = params[:sexo]
  
      result = CensoNomesService.new(nome, sexo).call
  
      if result[:success]
        render json: { message: 'Dados salvos com sucesso!', censo_nomes: result[:censo_nomes] }, status: :created
      else
        render json: { error: result[:error] }, status: :unprocessable_entity
      end
    end
  end
  