json.array!(@memes) do |meme|
	json.extract! meme, :url, :title, :author, :tags
end