json.array!(@memes) do |meme|
	json.extract! meme, :id, :url, :title, :author, :tags, :copy_count
end