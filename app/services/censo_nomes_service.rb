require "uri"
require "net/http"
require "json"
require_relative "../repositories/censo_nomes_repository"

class CensoNomesService
  def initialize(nome, sexo)
    @nome = nome
    @sexo = sexo
  end

  def call
    url = URI("https://servicodados.ibge.gov.br/api/v2/censos/nomes/#{@nome}?sexo=#{@sexo.upcase}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    response = https.request(request)

    ibge_data = JSON.parse(response.body)

    Rails.logger.info "IBGE Data: #{ibge_data.inspect}"

    censo_nomes = []

    ibge_data.each do |entry|
      entry['res'].each do |res|
        decada = res['periodo'][1, 4]
        frequencia = res['frequencia']
        
        Rails.logger.info "Criando CensoNome com nome: #{@nome}, decada: #{decada}, frequencia: #{frequencia}, sexo: #{@sexo}"
        
        censo_nome = CensoNome.new(nome: @nome, decada: decada, frequencia: frequencia, sexo: @sexo)
        
        if censo_nome.valid?
          censo_nomes << censo_nome
        else
          Rails.logger.error "Erro de validação: #{censo_nome.errors.full_messages.join(", ")}"
        end
      end
    end

    Rails.logger.info "CensoNomes criados: #{censo_nomes.inspect}"

    save_result = CensoNomesRepository.save_all(censo_nomes)

    if save_result[:success]
      { success: true, censo_nomes: censo_nomes }
    else
      Rails.logger.error "Erro ao salvar censo_nomes: #{save_result[:error]}"
      { success: false, error: save_result[:error] }
    end
  rescue StandardError => e
    Rails.logger.error "Erro ao chamar o serviço: #{e.message}"
    { success: false, error: e.message }
  end
end
