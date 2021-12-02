(def submarine-command
    '{:command (+ "down" "up" "forward")
        :main (* (<- :command) " " (<- :d+))})

(defn process-single-command [[horizontal-pos vertical-pos] command number]
    (cond
        (= "down" command) (tuple horizontal-pos (+ vertical-pos number))
        (= "up" command) (tuple horizontal-pos (- vertical-pos number))
        (= "forward" command) (tuple (+ horizontal-pos number) vertical-pos)
        '(horizontal-pos vertical-pos)))

(defn process-commands [positions [command number]]
    (process-single-command positions command (parse number)))
        
(with [fl (file/open "02_01.input")]
    (var positions '(0 0))
    (loop [line :iterate (file/read fl :line)]
        (set positions (process-commands positions (peg/match submarine-command line))))
    (def [horizontal-pos vertical-pos] positions)
    (* horizontal-pos vertical-pos))
