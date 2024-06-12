class CensoNomesRepository
  def self.save_all(censo_nomes)
    CensoNome.transaction do
      censo_nomes.each do |censo_nome|
        if censo_nome.save
          Rails.logger.info "CensoNome salvo com sucesso: #{censo_nome.inspect}"
        else
          Rails.logger.error "Erro ao salvar CensoNome: #{censo_nome.errors.full_messages.join(", ")}"
          raise ActiveRecord::RecordInvalid.new(censo_nome)
        end
      end
    end
    { success: true }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, error: e.record.errors.full_messages.join(", ") }
  end
end
