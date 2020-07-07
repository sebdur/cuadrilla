module GenderFiltersDecorator
    Spree::FrontendHelper.module_eval do
        def gender_filter_values
            [
                "#{"Verde Animal"}", "#{"Terror y Suspenso"}",
                "#{"Sociologia"}", "#{"Psicología"}",
                "#{"Principiante"}", "#{"Poesía"}",
                "#{"Música"}", "#{"Mitologia"}",
                "#{"Literatura Universal"}", "#{"Literatura Latinoamericana"}",
                "#{"Literatura Chilena"}", "#{"Infantil"}",
                "#{"Ilustración"}", "#{"Historia"}",
                "#{"Historia de Chile"}", "#{"Filosofia"}",
                "#{"Feminismo"}", "#{"Ensayo"}",
                "#{"Deporte"}", "#{"Cine"}",
                "#{"Ciencia Ficción"}", "#{"Biografía"}",
                "#{"Astrologia"}", "#{"Novela"}",
                "#{"Novela Romantica"}"
            ]
        end
    end
end
