json.extract! request, :id, :condominio_id, :user_id, :created_at, :updated_at
json.url request_url(request, format: :json)
