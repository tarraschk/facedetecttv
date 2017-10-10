json.extract! image, :id, :filename, :video_id, :created_at, :updated_at
json.url image_url(image, format: :json)