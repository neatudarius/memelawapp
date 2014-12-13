json.array!(@memes) do |meme|
  json.extract! meme, :id, :url, :author, :copy_count, :title, :tags, :likes_count, :favs_count, :req_count
  json.url meme_url(meme, format: :json)
end
