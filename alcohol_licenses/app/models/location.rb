class Location < ApplicationRecord
  KAZIMIERZ = [
    "Adama Chmielowskiego",
    "Augustiańska",
    ["Księdza Kordeckiego", "Księdza Augustyna Kordeckiego", "Księdza Kordeckiego", "Augustyna Kordeckiego"],
    "Bartosza",
    ["Berka Joselewicza", "Joselewicza"],
    "Bocheńska",
    "Bonifraterska",
    "Bożego Ciała",
    "Brzozowa",
    "Ciemna",
    "Dajwór",
    "Elizy Orzeszkowej",
    "Estery",
    "Gazowa",
    ["Hieronima Wietora", "Wietora"],
    "Izaaka",
    "Jakuba",
    "Józefa",
    "Krakowska",
    "Kupa",
    "Lewkowa",
    ["Beera Meiselsa", "Meiselsa"],
    "Miodowa",
    "Mostowa",
    "Na Przejściu",
    "Nowa",
    "Paulińska",
    "Piekarska",
    ["plac Nowy", "Nowy"],
    "Podbrzezie",
    "Podgórska",
    "Rybaki",
    "Skawińska",
    "Skałeczna",
    "Starowiślna",
    "Szeroka",
    "Trynitarska",
    ["Jonatana Warszauera", "Warszauera"],
    "Wąska",
    ["plac Wolnica", "Wolnica"],
    ["Świętego Sebastiana", "Św. Sebastiana", "Sebastiana"],
    "Świętego Stanisława",
    ["Świętego Wawrzyńca", "Św. Wawrzyńca", "Wawrzyńca"],
  ]

  has_many :alcohol_licenses
  belongs_to :transformed_location, optional: true

  # w tych adresach pierwsze cyfry to numer budynku
  # ^(\d+[ ]?)+(\/|lo|LO|LU|\.0|-|( i )+.*$|[MDCLXVI]*[ ]?[p]+.*$|$).*$
  # 
  # tylko lokal z literą na końcu
  # ^\d+[ ]?[a-zA-Z]$
  # 
  # lokal z literą i slashem lub spacją
  # ^\d+[ ]?[a-zA-Z](\/|[ ]).*$
  # 
  # przy bloku / koło bloku (nr)
  # /^(przy bl|koło bl|obok bl|przy bud|(k)[\/\.]bl).*$/
  #
  # ------------------
  #
  # pawilon
  # /^(paw|p paw).*$/
  # 
  # działka
  # /^(dz |dz.|dzi|DZ |DZ.|DZI).*$/
  scope :kazimierz, -> { where(address_1: KAZIMIERZ.flatten.map(&:upcase)) }
end
