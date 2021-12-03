(defn transpose [list]
    (apply map tuple list))

(defn ascii-to-digit [number]
    (match number 48 "0" 49 "1"))

(defn translate-a-line [line]
    (map ascii-to-digit line))

(defn appearances [char number]
    (count (fn [x] (= x char)) number))

(defn bin-to-dec [binary]
    (scan-number (string/format "2r%s" binary)))

(defn most-popular [number]
    (if (> (appearances "1" number) (appearances "0" number))
        "1"
        "0"))

(defn process [lines]
    (map most-popular (map translate-a-line (transpose lines))))

(with [fl (file/open "03.input")]
    (def gamma (bin-to-dec (string/join(process (string/split "\n" (file/read fl :all))))))
    (def epsilon (bxor gamma 2r111111111111))
    (* gamma epsilon))