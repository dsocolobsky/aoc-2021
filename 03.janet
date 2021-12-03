(defn transpose [list] (apply map tuple list))
(defn ascii-to-digit [number] (match number 48 "0" 49 "1"))
(defn digit-to-ascii [number] (match number "0" 48 "1" 49))
(defn translate-a-line [line] (map ascii-to-digit line))
(defn appearances [char number] (count (fn [x] (= x char)) number))
(defn bin-to-dec [binary] (scan-number (string/format "2r%s" binary)))
(defn process [lines] (map most-popular (map translate-a-line (transpose lines))))

(defn most-popular [number]
    (if (> (appearances "0" number) (appearances "1" number))
        "0"
        "1"))

(defn least-popular [number]
    (if (> (appearances "0" number) (appearances "1" number))
        "1"
        "0"))



(with [fl (file/open "03.input")]
    (def gamma (bin-to-dec (string/join(process (string/split "\n" (file/read fl :all))))))
    (def epsilon (bxor gamma 2r111111111111))
    (* gamma epsilon))

(defn apply-criteria-at-pos [pos list-of-numbers criteria]
    (def only-positions (map ascii-to-digit (map (fn [x] (get x pos)) list-of-numbers)))
    (criteria only-positions))

(defn filter-with-digit-in-pos [pos digit list-of-numbers]
    (filter (fn [number] (= digit (get number pos))) list-of-numbers))

(defn filter-at-pos [pos list-of-numbers criteria]
    (def most-popular (apply-criteria-at-pos pos list-of-numbers criteria))
    (filter-with-digit-in-pos pos (digit-to-ascii most-popular) list-of-numbers))

(defn oxygen-generator-rating-aux [list-of-numbers idx criteria]
    (if (= 1 (length list-of-numbers)) list-of-numbers
        (oxygen-generator-rating-aux (filter-at-pos idx list-of-numbers criteria) (+ 1 idx) criteria)))

(defn oxygen-generator-rating [list-of-numbers criteria]
    (bin-to-dec (get (oxygen-generator-rating-aux list-of-numbers 0 criteria) 0)))

(with [fl (file/open "03.input")]
    (def input (string/split "\n" (file/read fl :all)))
    (def oxygen-rating (oxygen-generator-rating input most-popular))
    (def C02-rating (oxygen-generator-rating input least-popular))
    (* oxygen-rating C02-rating))