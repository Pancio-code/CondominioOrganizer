json.extract! task, :id, :title, :description, :start_date, :end_date, :event, :members, :user_id, :created_at, :updated_at
json.url task_url(task, format: :json)
