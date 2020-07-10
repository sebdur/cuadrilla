# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Spree::Core::Engine.load_seed if defined?(Spree::Core)
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
#
require 'csv'

# poblar la bd con los productos + propiedades(autor,editorial,genero)

 Spree::Product.delete_all
 Spree::Property.delete_all
 Spree::ProductProperty.delete_all
 Spree::ShippingCategory.delete_all

 editorial_prop = Spree::Property.where(name: 'editorial', presentation: 'Editorial').first_or_create
 autor_prop = Spree::Property.where(name: 'autor', presentation: 'Autor').first_or_create
 genero_prop = Spree::Property.where(name: 'genero', presentation: 'Género').first_or_create

sku = 1600000


CSV.foreach(Rails.root.join('lib/catalogofinal.csv'), headers: false, col_sep: '|' ) do |row|

   p = Spree::Product.create name: row[0], price: row[3], description: row[5], available_on: Time.current, sku: sku, height: 200, weight: 200, shipping_category: Spree::ShippingCategory.where(name: 'Type B').first_or_create

   p.set_property("autor", row[1])
   p.set_property("editorial", row[2])
   p.set_property("genero", row[4])

   p.save

  sku += 10

end

#valores de envio poblando la bd


QuoteCost.delete_all

 CSV.foreach(Rails.root.join('lib/cotizador.csv'), headers: true, col_sep: ',' ) do |row|

   q = QuoteCost.create name: row[0], code: row[1], cost: row[3], service_delivery_code: row[4], region: row[2]

   q.save

 end

# # poblar la bd con los productos + propiedades(autor,editorial,genero)
#  Spree::Product.delete_all
#  Spree::Property.delete_all
#  Spree::ProductProperty.delete_all
#  Spree::ShippingCategory.delete_all
#
#  editorial_prop = Spree::Property.where(name: 'editorial', presentation: 'Editorial').first_or_create
#  autor_prop = Spree::Property.where(name: 'autor', presentation: 'Autor').first_or_create
#  genero_prop = Spree::Property.where(name: 'genero', presentation: 'Género').first_or_create
#
#  sku = 1000099991024382947239847239749
#
#  CSV.foreach(Rails.root.join('lib/catalogofinal.csv'), headers: false, col_sep: '|' ) do |row|
#
#    p = Spree::Product.create name: row[0], price: row[3], description: row[5], available_on: Time.current, sku: sku, height: 200, weight: 200, shipping_category: Spree::ShippingCategory.where(name: 'Type B').first_or_create
#
#    p.set_property("autor", row[1])
#    p.set_property("editorial", row[2])
#    p.set_property("genero", row[4])
# #
#    p.save
#    sku += 40
#
# end

#valores de envio poblando la bd

 # QuoteCost.delete_all
 # CSV.foreach(Rails.root.join('lib/cotizador.csv'), headers: true, col_sep: ',' ) do |row|
 #   q = QuoteCost.create name: row[0], code: row[1], cost: row[3], service_delivery_code: row[4], region: row[2]
 #   q.save
 # end



#asignacion de taxon(genero) a su libro correspondiente

generos = Spree::Taxon.all.pluck(:name)
genero_property_id = Spree::Property.find_by(name: "genero").id.to_i
generos.each do |genero|
	next if genero == 'Géneros'
  #next if genero == "Generos"
  libros = Spree::ProductProperty.where(property_id: genero_property_id, value: genero.upcase)
  libros_genero = libros.map { |libro| libro.product_id }
  libros_genero.each do |libro|
    Spree::Product.find(libro).taxons = Spree::Taxon.where(name: genero)
  end
end
