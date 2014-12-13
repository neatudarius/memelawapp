json.array!(@tags) do |tag|
	json.extract! tag, :id, :tag
	json.url post_url(post, format: :json)
end