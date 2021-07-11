(defun C:befo_plot()
(setvar "cmdecho" 0)
(setvar "regenmode" 0)
(setq id (load_dialog "h:/lisp/hdr_a4"))
(new_dialog "frame" id)
(setq des1 "    "
     des2 "    "
     drn "    "
     chk "    "
     appd "    "
     ref "    "
     tot_sh "  "
     sh_no "  "
     wk_no "  "
     drg_no "   ")
(setq hdr_yn "Y")
(action_tile "cancel" "(done_dialog) (setq hdr_yn \"N\")")
(action_tile "des1" "(setq des1 (get_tile \"des1\"))")
(action_tile "des2" "(setq des2 (get_tile \"des2\"))")
(action_tile "wk_no" "(setq wk_no (get_tile \"wk_no\"))")
(action_tile "sh_no" "(setq sh_no (get_tile \"sh_no\"))")
(action_tile "tot_sh" "(setq tot_sh (get_tile \"tot_sh\"))")
(action_tile "ref" "(setq ref (get_tile \"ref\"))")
(action_tile "drn" "(setq drn (get_tile \"drn\"))")
(action_tile "chk" "(setq chk (get_tile \"chk\"))")
(action_tile "appd" "(setq appd (get_tile \"appd\"))")
(action_tile "drg_no" "(setq drg_no (get_tile \"drg_no\"))")
(action_tile "accept"  "(done_dialog)")
(start_dialog)
(unload_dialog id)

(if (/= hdr_yn "N")
(progn
	(command "color" 8 
		"style" "romans" "romans" "" "0.85" "" "" "" ""
;               "erase" '(128 18) '(128 9.5) '(128 40) '(128 34) '(199 8)
;               '(25 42) '(58 42) '(91 42) '(47 45) '(80 45) '(112 45) ""
		"text" '(126 16) "4.0" 0 (strcase ref)
	        "chprop" "l" "" "layer" "0" ""
		"text" '(126 7.5) "4.0" 0 (strcase drg_no)
		"text" '(126 38) "3.5" 0 (strcase des1)
		"text" '(126 32) "3.5"  0 (strcase des2)
	        "chprop" "l" "" "layer" "0" ""
		"text" '(198 7) "2.25"  0 sh_no
		"text" '(198 16) "2.25"  0 tot_sh
		"text" '(23 41) "2.25" 0 (strcase drn)
	        "chprop" "l" "" "layer" "0" ""
		"text" '(56 41) "2.25" 0 (strcase chk)
	        "chprop" "l" "" "layer" "0" ""
		"text" '(89 41) "2.25" 0 (strcase appd)
	        "chprop" "l" "" "layer" "0" ""
		"text" '(109 46) "1.5" 0 wk_no
		"text" '(77 46) "1.5" 0 wk_no
		"color" 7
	)
;	(if (/= (ssget "x" (list (cons 62 8))) nil)
;	(command "chprop" (ssget "x" (list (cons 62 8))) "" "layer" "0" "")
;	)
	(command "style" "standard" "txt" "" "0.9" "" "" "" "")
)
)
)
