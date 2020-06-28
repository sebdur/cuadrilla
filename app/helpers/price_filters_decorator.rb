module PriceFiltersDecorator
    Spree::FrontendHelper.module_eval do
        def price_filter_values
            [
                "#{"Menos de"} $#{(5000)}",
                "$#{5001} - $#{10000}",
                "$#{10001} - $#{15000}",
                "$#{15001} - $#{20000}",
                "$#{20001} - $#{30000}"
            ]
        end
    end
end
