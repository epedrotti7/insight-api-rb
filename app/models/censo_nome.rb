class CensoNome < ApplicationRecord
  validates :nome, presence: true
  validates :decada, presence: true
  validates :frequencia, presence: true
  validates :sexo, length: { is: 1 }, allow_blank: true

  Rails.logger.info "Modelo CensoNome carregado com sucesso"
end
