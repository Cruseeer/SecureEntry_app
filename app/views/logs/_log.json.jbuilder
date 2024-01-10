json.extract! log, :id, :time, :accessed, :user_id, :room_id, :created_at, :updated_at
json.url log_url(log, format: :json)
