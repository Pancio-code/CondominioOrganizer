class Request < ApplicationRecord
    validates_uniqueness_of :condominio_id, :scope => [:user_id]
end
