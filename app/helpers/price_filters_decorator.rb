module PriceFiltersDecorator
    Spree::FrontendHelper.module_eval do
        def price_filter_values
            [
                "#{"Menos de"} $#{(5000)}",
                "$#{5000} - $#{10000}",
                "$#{10000} - $#{15000}",
                "$#{15000} - $#{20000}",
                "$#{20000} - $#{30000}",
                "$#{30000} - $#{50000}"
            ]
        end
    end
end
