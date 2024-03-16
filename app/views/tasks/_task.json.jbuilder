json.extract! task, :id, :description, :is_complete, :list_id, :created_at, :updated_at
json.url task_url(task, format: :json)
