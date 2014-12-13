json.array!(@tags) do |tag|
	json.extract! tag, :tag, :popularity
	json.url post_url(post, format: :json)
end