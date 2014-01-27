json.array!(@needs) do |need|
  json.extract! need, :text, :completed, :user_id
  json.url need_url(need, format: :json)
end
