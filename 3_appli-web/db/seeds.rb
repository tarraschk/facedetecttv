# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

stream_pluzz = Streams::Pluzz.create()

Chaine.create(name: "France 1", stream: stream_pluzz)
Chaine.create(name: "France 2", stream: stream_pluzz)
Chaine.create(name: "France 3", stream: stream_pluzz)
Chaine.create(name: "France 4", stream: stream_pluzz)
Chaine.create(name: "France 5", stream: stream_pluzz)
Chaine.create(name: "France Ô", stream: stream_pluzz)


