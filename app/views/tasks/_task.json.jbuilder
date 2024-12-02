json.extract! task, :id, :task_category, :task_type, :description, :status, :created_at, :updated_at
json.url task_url(task, format: :json)
