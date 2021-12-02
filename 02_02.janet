(def submarine-command
    '{:command (+ "down" "up" "forward")
    :main (* (<- :command) " " (<- :d+))})

(defn move-down [[horizontal-pos vertical-pos aim] amount]
    (tuple horizontal-pos vertical-pos (+ aim amount)))

(defn move-up [[horizontal-pos vertical-pos aim] amount]
    (tuple horizontal-pos vertical-pos (- aim amount)))

(defn move-forward [[horizontal-pos vertical-pos aim] amount]
    (tuple (+ horizontal-pos amount) (+ vertical-pos (* aim amount)) aim))

(defn process-single-command [positions command amount]
    (cond
        (= "down" command) (move-down positions amount)
        (= "up" command) (move-up positions amount)
        (= "forward" command) (move-forward positions amount)
        positions))

(defn process-commands [positions [command amount]]
    (process-single-command positions command (parse amount)))
    
(with [fl (file/open "02_01.input")]
(var positions '(0 0 0))
    (loop [line :iterate (file/read fl :line)]
        (set positions (process-commands positions (peg/match submarine-command line)))
    )
    (def [horizontal-pos vertical-pos _] positions)
    (* horizontal-pos vertical-pos))
