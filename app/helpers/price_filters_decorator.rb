module PriceFiltersDecorator
    Spree::FrontendHelper.module_eval do
        def price_filter_values
            [
                "#{I18n.t('activerecord.attributes.spree/product.less_than')} $#{(5000)}",
                "$#{5001} - $#{10000}",
                "$#{10001} - $#{15000}",
                "$#{15001} - $#{20000}",           
                "$#{20001} - $#{30000}"           
            ]
        end
    end
end