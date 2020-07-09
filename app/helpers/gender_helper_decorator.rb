module GenderFiltersDecorator
    Spree::FrontendHelper.module_eval do
        def gender_filter_values
            [
                "#{"Verde Animal"}", "#{"Terror y Suspenso"}",
                "#{"Sociología"}", "#{"Psicología"}",
                "#{"Principiante"}", "#{"Poesía"}",
                "#{"Música"}", "#{"Mitología"}",
                "#{"Literatura Universal"}", "#{"Literatura Latinoamericana"}",
                "#{"Literatura Chilena"}", "#{"Infantil"}",
                "#{"Ilustración"}", "#{"Historia"}",
                "#{"Historia de Chile"}", "#{"Filosofía"}",
                "#{"Feminismo"}", "#{"Ensayo"}",
                "#{"Deporte"}", "#{"Cine"}",
                "#{"Ciencia Ficción"}", "#{"Biografía"}",
                "#{"Astrología"}", "#{"Novela"}",
                "#{"Novela Romántica"}", "#{"Comic"}"
            ]
        end
    end
end
