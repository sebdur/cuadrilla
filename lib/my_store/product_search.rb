module MyStore
  class ProductSearch < Spree::Core::Search::Base


    def get_products_conditions_for(base_scope, query)
      author_id = Spree::Property.find_by(name: 'autor').id
      unless query.blank?
        base_scope = base_scope.like_any([:name, :description], [query])
        if base_scope.blank?
          author_book_search_id = Spree::ProductProperty.where(property_id: author_id, value: query.upcase).pluck(:product_id)
          new_query = []
          author_book_search_id.each do |num|
             new_query << Spree::Product.find_by(id: num).name
          end
          #base_scope = base_scope.like_any([:name, :description], [new_query])
          #base_scope = base_scope.where(name: new_query)
          base_scope = Spree::Product.where(name: new_query)
        end
      end
      base_scope
    end
  end
end
