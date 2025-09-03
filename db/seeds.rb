categories = [
  "Action",
  "Adventure",
  "Comedy",
  "Drama",
  "Fantasy",
  "Horror",
  "Mecha",
  "Romance",
  "Sci-Fi",
  "Slice of Life",
  "Sports",
  "Supernatural",
  "Thriller",
  "Isekai",
  "Manga",
  "Shounen",
  "Shoujo",
  "Seinen",
  "Josei",
  "Martial Arts",
  "Magic",
  "Psychological"
]

categories.each do |category_name|
  Category.find_or_create_by(name: category_name)
end

puts "✅ Seeded #{categories.count} anime categories."
