json.array!(@tags) do |tag|
	json.extract! tag, :tag, :popularity
end