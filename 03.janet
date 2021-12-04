(defn ascii-to-digit   [number]      (match number 48 "0" 49 "1"))
(defn digit-to-ascii   [number]      (match number "0" 48 "1" 49))
(defn appearances      [char number] (count (fn [x] (= x char)) number))
(defn bin-to-dec       [binary]      (scan-number (string/format "2r%s" binary)))
(defn transpose        [list]        (apply map tuple list))
(defn translate-a-line [line]        (map ascii-to-digit line))

(defn most-popular [number]
    (if (> (appearances "0" number) (appearances "1" number))
        "0"
        "1"))

(defn least-popular [number]
    (if (> (appearances "0" number) (appearances "1" number))
        "1"
        "0"))

(defn exercise-1 [lines]
    (def result (map most-popular (map translate-a-line (transpose lines))))
    (def gamma (bin-to-dec (string/join result)))
    (def epsilon (bxor gamma 2r111111111111))
    (* gamma epsilon))

(defn filter-with-digit-in-pos [pos digit list-of-numbers]
    (filter (fn [number] (= digit (get number pos))) list-of-numbers))

(defn apply-criteria-at-pos [criteria pos list-of-numbers]
    (def only-positions (map ascii-to-digit (map (fn [x] (get x pos)) list-of-numbers)))
    (criteria only-positions))

(defn filter-at-pos [criteria pos list-of-numbers]
    (def most-popular (apply-criteria-at-pos criteria pos list-of-numbers))
    (filter-with-digit-in-pos pos (digit-to-ascii most-popular) list-of-numbers))

(defn get-rating-aux [criteria list-of-numbers pos]
    (if (= 1 (length list-of-numbers)) list-of-numbers
        (get-rating-aux criteria (filter-at-pos criteria pos list-of-numbers) (+ 1 pos))))

(defn get-rating [criteria list-of-numbers]
    (bin-to-dec (get (get-rating-aux criteria list-of-numbers 0) 0)))

(defn exercise-2 [lines]
    (def oxygen-rating (get-rating most-popular lines))
    (def C02-rating (get-rating least-popular lines))
    (* oxygen-rating C02-rating))

(defn file-to-lines [fl] (string/split "\n" (file/read fl :all)))
(with [fl (file/open "03.input")]
    (def input (file-to-lines fl))
    (def res-1 (exercise-1 input))
    (def res-2 (exercise-2 input))
    (tuple res-1 res-2))
