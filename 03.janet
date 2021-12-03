(defn transpose [list]
    (apply map tuple list))

(defn ascii-to-digit [number]
    (match number 48 "0" 49 "1"))

(defn digit-to-ascii [number]
    (match number "0" 48 "1" 49))

(defn translate-a-line [line]
    (map ascii-to-digit line))

(defn appearances [char number]
    (count (fn [x] (= x char)) number))

(defn bin-to-dec [binary]
    (scan-number (string/format "2r%s" binary)))

(defn most-popular [number]
    (if (> (appearances "0" number) (appearances "1" number))
        "0"
        "1"))

(defn process [lines]
    (map most-popular (map translate-a-line (transpose lines))))

(with [fl (file/open "03.input")]
    (def gamma (bin-to-dec (string/join(process (string/split "\n" (file/read fl :all))))))
    (def epsilon (bxor gamma 2r111111111111))
    (* gamma epsilon))

(defn most-popular-at-pos [pos list-of-numbers]
    (def only-positions (map ascii-to-digit (map (fn [x] (get x pos)) list-of-numbers)))
    (most-popular only-positions))

(defn filter-with-digit-in-pos [pos digit list-of-numbers]
    (filter (fn [number] (= digit (get number pos))) list-of-numbers))

(defn filter-at-pos [pos list-of-numbers]
    (def most-popular (most-popular-at-pos pos list-of-numbers))
    (filter-with-digit-in-pos pos (digit-to-ascii most-popular) list-of-numbers))

(defn oxygen-generator-rating-aux [list-of-numbers idx]
    (if (> idx 4) list-of-numbers
        (oxygen-generator-rating-aux (filter-at-pos idx list-of-numbers) (+ 1 idx))))

(defn oxygen-generator-rating [list-of-numbers]
    (bin-to-dec (get (oxygen-generator-rating-aux list-of-numbers 0) 0)))

(with [fl (file/open "03.input")]
    (def input (string/split "\n" (file/read fl :all)))
    (printf "input: %Q" input)
    (def output (oxygen-generator-rating input))
    output)