module MyStore
  class ProductSearch < Spree::Core::Search::Base


    def get_products_conditions_for(base_scope, query)
      author_id = Spree::Property.find_by(name: 'autor').id
      unless query.blank?
        base_scope = base_scope.like_any([:name, :description], [query])
        if base_scope.blank?
          set_query = query.split(' ').join(", ")
          set_author_book_search_id = Spree::ProductProperty.where(property_id: author_id)
          author_book_search_id = set_author_book_search_id.where("value LIKE ?", "%#{set_query.strip.upcase}%").pluck(:product_id)

          new_query = []
          author_book_search_id.each do |num|
             new_query << Spree::Product.find_by(id: num).name
          end
          base_scope = Spree::Product.where(name: new_query)
        end
      end
      base_scope
    end
  end
end
