(import ./01_01 :prefix "")

(defn three-from [ds i] 
    (array/slice ds i (+ i 3)))

(defn sum-three-from [ds i] 
    (sum (three-from ds i)))

(defn out-of-bounds? [ds i] 
    (> (+ i 3) (length ds)))

(defn window-sum-from [ds i] 
    (if (out-of-bounds? ds i)
        0
        (sum-three-from ds i)))

(defn window-sums [input]
    (map-indexed (fn [i v] (window-sum-from input i)) input))

(solve-exercise (window-sums readings))
