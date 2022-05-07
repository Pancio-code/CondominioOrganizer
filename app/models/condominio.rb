class Condominio < ApplicationRecord
  belongs_to :fk_utenti_condo
  belongs_to :fk_superutenti_condo
end
