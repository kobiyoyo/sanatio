json.extract! search, :id, :first_name, :last_name, :url, :created_at, :updated_at
json.url search_url(search, format: :json)
