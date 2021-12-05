(def readings @[174 180 179 186 184 176 177 190])

(defn map-indexed [f ds]
    (map f (range 0 (length ds)) ds))

(defn is-a-decrease [previous reading] 
    (or (= nil previous) (< reading previous)))

(defn process-single-reading [previous reading]
    (if (is-a-decrease previous reading)
        'decreased
        'increased))

(defn process-readings [ds]
    (map-indexed (fn [i v] (process-single-reading (get ds (- i 1)) v)) ds))

(defn count-increases [ds] 
    (length (filter (fn [x] (= 'increased x)) ds)))

(defn solve-exercise [input] 
    (count-increases (process-readings input)))

(solve-exercise readings)
