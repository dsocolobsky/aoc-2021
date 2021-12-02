(def submarine-command
    '{:command (+ "down" "up" "forward")
        :main (* (<- :command) " " (<- :d+))})

(defn move-down [[horizontal-pos vertical-pos aim] amount]
    (tuple horizontal-pos (+ vertical-pos amount)))

(defn move-up [[horizontal-pos vertical-pos aim] amount]
    (tuple horizontal-pos (- vertical-pos amount)))

(defn move-forward [[horizontal-pos vertical-pos aim] amount]
    (tuple (+ horizontal-pos amount) vertical-pos))

(defn move-down-2 [[horizontal-pos vertical-pos aim] amount]
    (tuple horizontal-pos vertical-pos (+ aim amount)))

(defn move-up-2 [[horizontal-pos vertical-pos aim] amount]
    (tuple horizontal-pos vertical-pos (- aim amount)))

(defn move-forward-2 [[horizontal-pos vertical-pos aim] amount]
    (tuple (+ horizontal-pos amount) (+ vertical-pos (* aim amount)) aim))

(defn process-single-command [positions command amount [fn1 fn2 f3]]
    (cond
        (= "down" command) (fn1 positions amount)
        (= "up" command) (fn2 positions amount)
        (= "forward" command) (fn3 positions amount)
        positions))

(defn process-commands [positions [command amount] functions]
    (process-single-command positions command (parse amount) functions))
        
(defn solve-with-fn [functions] (with [fl (file/open "02_01.input")]
    (var positions '(0 0 0))
    (loop [line :iterate (file/read fl :line)]
        (def pegline (peg/match submarine-command line))
        (set positions (process-commands positions pegline functions)))
    (def [horizontal-pos vertical-pos _] positions)
    (* horizontal-pos vertical-pos)))

(solve-with-fn process-single-command)
(solve-with-fn process-single-command-2)
