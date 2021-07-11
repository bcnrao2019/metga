;------------------------------------------------------------------------------
; This program facilitates automatic generation of Metering Cutout
; for DMSO Nasik
;------------------------------------------------------------------------------
(defun c:main()
	 (setq	oldcmd (getvar "cmdecho")
		oldrmd (getvar "regenmode")
	 )
         (setvar "cmdecho" 0)
         (setvar "regenmode" 0)
         (setvar "aperture" 3)
         (setvar "dimexe" 0)
         (setvar "dimscale" 1)
         (setvar "pdmode" 0)
	 (command "units" "2" "2" "" "" "" ""
                  "ltscale" 7.0
	          "style" "romans" "romans" "" "0.9" "" "" "" ""
	 )
       (chk)
       (textscr)
       (prompt "\n\n Panel Type	Height		 Door Type\n")
         (prompt "\nVHA12S   	 589 mm		VHA-12S1")
         (prompt "\nVHA12S   	 871 mm 	VHA-12S2")
         (prompt "\nVHA12S   	 951 mm		VHA-12S3")
         (prompt "\nVHA12    	 669 mm 	11KVSF1")
         (prompt "\nVHA12    	 951 mm 	11KVSF2")
         (prompt "\nVHE-800  	 744 mm 	11KVMO1")
         (prompt "\nVHE-800 	1000 mm 	11KVMO2")
         (prompt "\nVHE-950  	 744 mm 	11KVMO3")
         (prompt "\nVHE-950 	1000 mm 	11KVMO4")
         (prompt "\n22KVSF6  	 756 mm 	22KVSF")
;         (prompt "\n22KVMCOB 	 552 mm 	22KVMO")
        (prompt "\nVHA 36  	 724 mm 	VHA362")
        (prompt "\nVHA 36  	 524 mm 	VHA361")
 	 (prompt "\nUniSafe600   750 mm 	U600-1")
	 (prompt "\nUniSafe600 	1030 mm 	U600-2")
	 (prompt "\nUniSafe750   750 mm 	U750-1")
	 (prompt "\nUniSafe750  1030 mm 	U750-2")
         (prompt "\nVHA12D   	 661 mm 	VHA-12D1")
         (prompt "\nVHA12D   	 906 mm 	VHA-12D2\n\n")
	(setq add_yn "Y") 
;    (initget 1 "VHA-12D1 VHA-12D2 VHA-12S1 VHA-12S2 VHA-12S3 11KVMO1 11KVMO2 11KVMO3 11KVMO4 11KVSF1 11KVSF2  22KVSF VHA361 VHA362 U600-1 U600-2 U750-2 U750-1")
    (initget 1 "VHA-12D1 VHA-12D2 VHA-12S1 VHA-12S2 VHA-12S3 11KVMO1 11KVMO2 11KVMO3 11KVMO4 22KVSF VHA361 VHA362 U600-1 U600-2 U750-2 U750-1")
	(setq door_type(strcase (getkword "\nSelect Door Type : ")))
	(if (or (= door_type "VHE-800") (= door_type "VHE-950"))	(progn
	(initget 1 "744 1000")
	(setq	ht (getkword "\nDoor Height <744/1000> :"))
	(cond	((and (= door_type "VHE-800") (= ht "744"))
		 (setq door_type "11KVMO1")
		)
		((and (= door_type "VHE-800") (= ht "1000"))
		 (setq door_type "11KVMO2")
		)
		((and (= door_type "VHE-950") (= ht "744"))
		 (setq door_type "11KVMO3")
		)
		((and (= door_type "VHE-950") (= ht "1000"))
		 (setq door_type "11KVMO4")
		)
	)
	);end of progn
	);end if 
	(if (< (strlen door_type) 8)
	(SETQ door_type (strcat door_type (substr "        " 1 (- 8 (strlen door_type)))))
	)
;start drawing
       (prompt "Creating Drawing please wait .......")
;insertion point of door
       (setq sp     (list 50 125)
;starting point of dimension
             dp      (list (- (car sp) 1.4) (- (cadr sp) 1.4))
;define a list
             co_list (list)
             validity "N"
             cl_pt    "N" 
             ins_pt   nil
             tmp_cl_l 0
             tmp_cl_r 0
             plt_yn   "N"
       )
;create layer for marking minimum clearance required between apparatus
       (command "layer" "n" "bound"
                        "on" "bound"
                        "n" "cut_det"
                        "m" "cutout" 
			"m" "door" ""
       )
       (draw_out_limit)
       (command "layer" "s" "bound" ""
                "linetype" "s" "hidden" ""
       )
       (command "line" pt1 pt2 pt3 pt4 pt1 ""
                "linetype" "s" "bylayer" ""
                "layer" "m" "met_ga" ""
                "layer" "off" "cutout" ""
                "layer" "off" "cut_det" ""
       )
;insert metering door

;create layer for cutout
;insert sheet for cutout
       (ins_door)
       (cut_out)
       (cut_out_det)

	(command "layer" "s" "met_ga" ""
                "layer" "off" "cutout" ""
                "layer" "off" "cut_det" ""
	)
	(textscr)
	(prompt "\n\n\n\n\n\n\n\n\n\n\n\n\\nMetering DATA starting \n\n\n\n")

        (init_vars)

       (command "zoom" "w" '(25 100) '(225 240))
      (while (/= add_yn "N")
       (ins_met)

       (initget 1 "Y N")
       (setq add_yn (strcase (getkword "\nAdd more : <Y/N> : ")))
       (if (/= add_yn "N")
           (init_vars)
       )
      );end of while
       (command "layer" "off" "bound" "")
;       (close fd)
;       (close fdw)
(command "zoom" "p")
;(cond ((or (= door_type "11KVSF1 ") (= door_type "11KVSF2 ") (= door_type "11KVMO1 ") (= door_type "11KVMO2 ") (= door_type "11KVMO3 ") (= door_type "11KVMO4 ") (= door_type "VHA-12S1") (= door_type "VHA-12S2") (= door_type "VHA-12S3") (= door_type "22KVSF  "))
;	(command "scale" "c" '(50 105) '(195 250) "" '(50 125) "1.25")
;      )
;)

; insert first sheet for door cutout [ ADDED ON 980924 BY bn varade]
  (ins_std_door)

  (princ)
  (setvar "cmdecho" oldcmd)
  (setvar "regenmode" oldrmd)

);end of main defun
;------------------------------------------------------------------------------
(defun ins_door()
;	(befo_plot)
       (c:a4h)
       (command "insert" "h:/block/metga/table" '(70 260) 1 "" 0)
       (cond ((= door_type "11KVSF1 ")
              (command "insert" "h:/block/metga/11kvsf1" sp "" "" "0")
             )
             ((= door_type "11KVSF2 ")
              (command "insert" "h:/block/metga/11kvsf2" sp "" "" "0")
             )
             ((= door_type "11KVMO1 ")
              (command "insert" "h:/block/metga/11kvmo1" sp "" "" "0")
             )
             ((= door_type "11KVMO2 ")
              (command "insert" "h:/block/metga/11kvmo2" sp "" "" "0")
             )
             ((= door_type "11KVMO3 ")
              (command "insert" "h:/block/metga/11kvmo3" sp "" "" "0")
             )
             ((= door_type "11KVMO4 ")
              (command "insert" "h:/block/metga/11kvmo4" sp "" "" "0")
             )
             ((= door_type "22KVSF  ")
              (command "insert" "h:/block/metga/22kvsf" sp "" "" "0")
             )
             ((= door_type "22KVMO  ")
              (command "insert" "h:/block/metga/22kvmo" sp "" "" "0")
             )
             ((= door_type "VHA-12D1")
              (command "insert" "h:/block/metga/vha12d1" sp "" "" "0")
             )

             ((= door_type "VHA-12D2")
              (command "insert" "h:/block/metga/vha12d2" sp "" "" "0")
             )
             ((= door_type "VHA-12S1")
              (command "insert" "h:/block/metga/vha12s1" sp "" "" "0")
             )
             ((= door_type "VHA-12S2")
              (command "insert" "h:/block/metga/vha12s2" sp "" "" "0")
             )
             ((= door_type "VHA-12S3")
              (command "insert" "h:/block/metga/vha12s3" sp "" "" "0")
             )
             ((= door_type "VHA361  ")
              (command "insert" "h:/block/metga/VHA361" sp "1.0" "" "0")
             )
             ((= door_type "VHA362  ")
              (command "insert" "h:/block/metga/VHA362" sp "1.0" "" "0")
             )
             ((= door_type "36KVSF1 ")
              (command "insert" "h:/block/metga/36kvsf1" sp "" "" "0")
             )
             ((= door_type "36KVSF2 ")
              (command "insert" "h:/block/metga/33kvsf2" sp "" "" "0")
             )
             ((= door_type "U750-1  ")
              (command "insert" "h:/block/metga/U750-1" sp 1.0 1.0 "0")
             )
             ((= door_type "U750-2  ")
              (command "insert" "h:/block/metga/U750-2" sp 1.0 1.0 "0")
             )
             ((= door_type "U600-1  ")
              (command "insert" "h:/block/metga/U600-1" sp 1.0 1.0 "0")
             )
             ((= door_type "U600-2  ")
              (command "insert" "h:/block/metga/U600-2" sp 1.0 1.0 "0")
             )

       )
);defun for inserting door
;------------------------------------------------------------------------------
(defun cut_out()
       (setq	des1 "DOOR CUTOUTS" drg_no "")
       (while (= drg_no "")
       (setq drg_no (strcase (getstring "\nEnter Drg No.for Cutout Drawing < YN1V400104->: ")))
       )
       (SETQ    drg_no (strcat "YN1V400104-" drg_no))
       (command "layer" "s" "cutout" ""
		"text" '(126 7.5) "4" "" drg_no
		"text" '(126 38) "3.5" "" des1
		"text" '(198 7) "2.5"  "" "2"
		"text" '(198 16) "2.5"  "" "3"
       )
       (cond ((= door_type "11KVSF1 ")
              (command "insert" "h:/block/metga/11kvsc1" sp "" "" "0")
             )
             ((= door_type "11KVSF2 ")
              (command "insert" "h:/block/metga/11kvsc2" sp "" "" "0")
             )
             ((= door_type "11KVMO1 ")
              (command "insert" "h:/block/metga/11kvmc1" sp "" "" "0")
             )
             ((= door_type "11KVMO2 ")
              (command "insert" "h:/block/metga/11kvmc2" sp "" "" "0")
             )
             ((= door_type "11KVMO3 ")
              (command "insert" "h:/block/metga/11kvmc3" sp "" "" "0")
             )
             ((= door_type "11KVMO4 ")
              (command "insert" "h:/block/metga/11kvmc4" sp "" "" "0")
             )
             ((= door_type "22KVSF  ")
              (command "insert" "h:/block/metga/22kvsc" sp "" "" "0")
             )
             ((= door_type "22KVMO  ")
              (command "insert" "h:/block/metga/22kvmc" sp "" "" "0")
             )
             ((= door_type "VHA-12D1")
              (command "insert" "h:/block/metga/12D_c1" sp "" "" "0")
             )
             ((= door_type "VHA-12D2")
              (command "insert" "h:/block/metga/12D_c2" sp "" "" "0")
             )
             ((= door_type "VHA-12S1")
              (command "insert" "h:/block/metga/vha12c1" sp "" "" "0")
             )
             ((= door_type "VHA-12S2")
              (command "insert" "h:/block/metga/vha12c2" sp "" "" "0")
             )
             ((= door_type "VHA-12S3")
              (command "insert" "h:/block/metga/vha12c3" sp "" "" "0")
             )
             ((= door_type "VHA361  ")
              (command "insert" "h:/block/metga/VHA36c1" sp "0.1" "" "0")
             )
             ((= door_type "VHA362  ")
              (command "insert" "h:/block/metga/VHA36c2" sp "0.1" "" "0")
             )
             ((= door_type "36KVSF1 ")
              (command "insert" "h:/dev/36kvsfc1" sp "" "" "0")
             )
             ((= door_type "36KVSF2 ")
              (command "insert" "h:/dev/36kvsfc2" sp "" "" "0")
             )
             ((= door_type "U750-1  ")
              (command "insert" "h:/block/metga/U750-C1" sp 0.1 0.1 "0")
             )
             ((= door_type "U750-2  ")
              (command "insert" "h:/block/metga/U750-C2" sp 0.1 0.1 "0")
             )
             ((= door_type "U600-1  ")
              (command "insert" "h:/block/metga/U600-C1" sp 0.1 0.1 "0")
             )
             ((= door_type "U600-2  ")
              (command "insert" "h:/block/metga/U600-C2" sp 0.1 0.1 "0")
             )

       )
       (setq ref_1 (list (car dp) (- (cadr dp) 1.0))
            ref_2 (list (car dp) (+ (cadr dp) 1.0))
            ref_3 (list (- (car dp) 1.0) (cadr dp))
            ref_4 (list (+ (car dp) 1.0) (cadr dp))
            txt   (list (- (car dp) 2.0) (- (cadr dp) 2.0))
      )
      (command "line" ref_1 ref_2 ""
               "line" ref_3 ref_4 ""
               "text" txt "2.0" "0" "0"
      )
)defun for inserting cutout sheet
;------------------------------------------------------------------------------
(defun ins_met()
(trm)
(lim)
;whether apparatus is to be aligned with top/bottom/no edge of previous 
;apparatus
(prompt (strcat "\n" type ":-" item_desn))
(GRAPHSCR)
(cond ((or (= door_type "11KVSF1 ")
           (= door_type "11KVSF2 ")
           (= door_type "VHA-12D1")
           (= door_type "VHA-12D2")
           (= door_type "VHA-12S1")
           (= door_type "VHA-12S2")
           (= door_type "VHA-12S3")
;           (= door_type "22KVSF  ")
       )
       (cond ((or (= type "LR") (= type "L/R"))
             (setq type "LR" 
                   plt_yn (strcase (getstring "\nDo You Want To Mount On Plate(Y/N):"))
	     )
             (while (= plt_yn "")
                    (prompt "\nPlease Enter Y or N")
                    (setq plt_yn (strcase (getstring "\nDo You Want To Mount On Plate(Y/N):")))
             )
            )
            ((or (= type "BC") (= type "B/C"))
             (setq type "BC"
                   plt_yn (strcase (getstring "\nDo You Want To Mount On Plate(Y/N):"))
             )
             (while (= plt_yn "")
                    (prompt "\nPlease Enter Y or N")
                    (setq plt_yn (strcase (getstring "\nDo You Want To Mount On Plate(Y/N):")))
             )
            )
       );end of cond
      )
 );end of cond
 (if (= plt_yn "Y")
      (progn
           (cond ((= type "LR")
                  (setq ins_pt (list (+ (car sp) 8.0) (- (cadr sp) 8.0)))
                 )
                 ((= type "BC")
                  (setq ins_pt (list (+ (car sp) 47.0) (- (cadr sp) 8.0)))
                 )
            )
            (blk_ins)        
      );end of progn
      (progn
      (if (= ins_pt nil)
;          (setq align "R")
          (setq align (strcase (getstring "\nSelect Alignment Top/Bottom/Centre/Random(T/B/C/R):")))
      )
      (while (= align "")
             (prompt "\n(T/B/C/R) please")
             (setq align (strcase (getstring "\nSelect Alignment Top/Bottom/Centre/Random(T/B/C/R):")))
      )
      (if (or (= align "T") (= align "B") (= align "C"))
          (setq al_dir (strcase (getstring "\nSide Right/Left(R/L):")))
      )
      (cond ((= align "T")
             (cond ((= al_dir "R")
;                    (setq ins_pt (list (+ (car ins_pt) cl_l temp_wid met_wid) (- (+ (cadr ins_pt) temp_htt) tmet_ht)))
                    (setq ins_pt (list (+ (car old_pt) cl_l temp_wid met_wid) (- (+ (cadr old_pt) temp_htt) tmet_ht)))
                   )
                   ((= al_dir "L")
;                    (setq ins_pt (list (- (car ins_pt) cl_l temp_wid met_wid) (- (+ (cadr ins_pt) temp_htt) tmet_ht)))
                    (setq ins_pt (list (- (car old_pt) cl_l temp_wid met_wid) (- (+ (cadr old_pt) temp_htt) tmet_ht)))
                   )
             )
             (out_limit)
             (clear)
             (if (or (/= validity "Y") (/= cl_pt "Y"))
                 (progn
                 (prompt "\nApparatus cannot be placed here !!!!!")               
                 (setq align "R")
                 )
                 (blk_ins)
             );end of if
            )
            ((= align "B")
             (cond ((= al_dir "R")
;                    (setq ins_pt (list (+ (car ins_pt) cl_l temp_wid met_wid) (+ (- (cadr ins_pt) temp_htb) bmet_ht)))
                    (setq ins_pt (list (+ (car old_pt) cl_l temp_wid met_wid) (+ (- (cadr old_pt) temp_htb) bmet_ht)))
                   )
                   ((= al_dir "L")
;                    (setq ins_pt (list (- (car ins_pt) cl_l temp_wid met_wid) (+ (- (cadr ins_pt) temp_htb) bmet_ht)))
                    (setq ins_pt (list (- (car old_pt) cl_l temp_wid met_wid) (+ (- (cadr old_pt) temp_htb) bmet_ht)))
                   )
             )
             (out_limit)
             (clear)
             (if (or (/= validity "Y") (/= cl_pt "Y"))
                 (progn
                 (prompt "\nApparatus cannot be placed here !!!!!")               
                 (setq align "R")
                 )
                 (blk_ins)
             );end of if
            )
            ((= align "C")
             (cond ((= al_dir "R")
;                    (setq ins_pt (list (+ (car ins_pt) cl_l temp_wid (/ width 2.0)) (cadr ins_pt)))
                    (setq ins_pt (list (+ (car old_pt) cl_l temp_wid (/ width 2.0)) (cadr old_pt)))
                   )
                   ((= al_dir "L")
;                    (setq ins_pt (list (- (car ins_pt) cl_l temp_wid (/ width 2.0)) (cadr ins_pt)))
                    (setq ins_pt (list (- (car old_pt) cl_l temp_wid (/ width 2.0)) (cadr old_pt)))
                   )
             )
             (out_limit)
             (clear)
             (if (or (/= validity "Y") (/= cl_pt "Y"))
                 (progn
                 (prompt "\nApparatus cannot be placed here !!!!!")               
                 (setq align "R")
                 )
                 (blk_ins)
             );end of if
            )
        ); end of cond
        (if (= align "R")
              (progn
                 (adjust)
	         (out_limit)
        	 (clear)
                 (if (and (= validity "Y") (= cl_pt "Y"))
                     (blk_ins)
                     (prompt "\nApparatus cannot be placed here, Try again !!!!!")
                 );end of if
                 (while (or (/= validity "Y") (/= cl_pt "Y"))
                        (adjust)
                        (out_limit)
                        (clear)
                        (if (and (= validity "Y") (= cl_pt "Y"))
                            (blk_ins)
                            (prompt "\nApparatus cannot be placed here, Try again !!!!!")
                        );end of if
          	 );end of while
                 (setq okyn (strcase (getstring "\nShall we proceed ?(Y/N):")))
                 (while (= okyn "N")
			(if (or (= type "LAMP") (= type "PB"))
				(progn
				(command "erase" item_desn_pt ""
					 "erase" ins_pt "")
				(setq item_desn (strcat "D5 " item_desn))	
				)
			)
			(if (or (= type "BC") (= type "LR"))
				(command "erase" item_desn_pt ""
					 "erase" ins_pt ""
					 "erase" type_pt "") 
                        (command "erase" "l" "")
			)
                        (command "redraw")
;to restrict apparatus within permissible outer limits
                        (adjust)
                        (out_limit)
                        (clear)
                        (if (and (= validity "Y") (= cl_pt "Y"))
                            (blk_ins) 
                            (prompt "\nApparatus cannot be placed here, Try again !!!!!")
                        );end of if
                        (while (or (/= validity "Y") (/= cl_pt "Y"))
                               (adjust)
                               (out_limit)
                               (clear)
                               (if (and (= validity "Y") (= cl_pt "Y"))
                                   (blk_ins)
                                   (prompt "\nApparatus cannot be placed here, Try again!!!!!")
                               );end of if
                        );end of while
                        (setq okyn (strcase (getstring "\nShall we proceed ?(Y/N):")))
                  );end of while
           );end of progn
      ) ; end of if
      );end of progn
);end of if
(if (= text_flag "Y")
    (progn
          (setq item_desn_pt (list (car ins_pt) (+ (cadr ins_pt) 0.5))
                type_pt      (list (car ins_pt) (- (cadr ins_pt) 2.5))
          )
          (command "text" "c" type_pt "1.5" "0" type
                   "text" "c" item_desn_pt "1.5" "0" item_desn
          )
          (setq text_flag "N")
    )
);end of if
(setq temp_htt tmet_ht
      temp_htb bmet_ht
      temp_wid met_wid
      tmp_cl_l cl_l
      tmp_cl_r cl_r
)
(bound)
(if (= labelyn "Y")
    (progn
         (setq lab_pt (list (car ins_pt) (- (- (cadr ins_pt) (/ height 2.0)) 2.0)))
         (command "insert" "h:/block/metga/blk" lab_pt 4.8 1.4 0)
    )
)
(setq align "")
);defun for inserting apparatus
;------------------------------------------------------------------------------
(defun blk_ins()
   (if (or (= type "LMP") (= type "LAMP") (= type "PB") (= type "BC") (= type "LR"))
   (progn
   (cond ((= type "LAMP")
		(command "insert" "h:/block/metga/lmp" ins_pt "" "" 0)
		(setq	item_desn_pt (list (car ins_pt) (- (cadr ins_pt) 3.2))
	;		item_desn_pt (list (car ins_pt) (+ (cadr ins_pt) 4.1))
			item_desn (strcat (substr item_desn 4 2))
		)
		(command "text" "c" item_desn_pt "1.4" "" item_desn)
		(if (or (= (rtos (car ins_pt)) "56.15") (= (rtos (car ins_pt)) "55.65"))
		(progn
		(setq t_pt (list 50.75 (cadr item_desn_pt)))
		(command "text" t_pt "1.4" "" "D5 ")
		)
		)
	)
	((= type "PB") 
                (command "insert" "h:/block/metga/pb" ins_pt "" "" 0)
	        (setq 	item_desn_pt (list (car ins_pt) (+ (cadr ins_pt) 3.6))
			item_desn (strcat (substr item_desn 4 2)))
		(command "text" "c" item_desn_pt "1.4" "" item_desn)
		(if (or (= (rtos (car ins_pt)) "56.75") (= (rtos (car ins_pt)) "56.25"))
		(progn
		 (setq t_pt (list 50.75 (cadr item_desn_pt)))
		 (command "text" t_pt "1.4" "" "D5-")
		)
		);END OF IF
        )
        ((= type "BC")
               (command "insert" "h:/block/metga/bc" ins_pt "" "" 0)
	       (setq 	item_desn_pt (list (car ins_pt) (+ (cadr ins_pt) 5.5))
			type_pt (list (car ins_pt) (+ (cadr ins_pt) 2.5)))
	       (command "text" "c" item_desn_pt "1.5" "" item_desn
			"text" "c" type_pt "" "" type)
        )
        ((= type "LR")
               (command "insert" "h:/block/metga/bc" ins_pt "" "" 0)
	       (setq 	item_desn_pt (list (car ins_pt) (+ (cadr ins_pt) 5.5))
			type_pt (list (car ins_pt) (+ (cadr ins_pt) 2.5)))
	       (command "text" "c" item_desn_pt "1.5" "" item_desn
			"text" "c" type_pt "" "" "L/R")
        )
        );end of cond
   );end of progn
   (progn
   (command "insert" "h:/block/metga/blk" ins_pt width height 0)
   (setq text_flag "Y")
   );end of progn
 );end of if
)
;------------------------------------------------------------------------------
(defun draw_out_limit()
      (cond ((= door_type "11KVSF1 ")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 76.4) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 66.9) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "11KVSF2 ")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 76.4) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 95.1) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "11KVMO1 ")
             (setq pt1 (list (+ (car sp) 4.0) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 74.8) 7.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 70.4) 2.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "11KVMO2 ")
             (setq pt1 (list (+ (car sp) 4.0) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 74.8) 7.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 95.8) 2.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "11KVMO3 ")
             (setq pt1 (list (+ (car sp) 4.0) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 89.8) 7.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 70.4) 2.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "11KVMO4 ")
             (setq pt1 (list (+ (car sp) 4.0) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 89.8) 7.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 95.8) 2.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "22KVSF  ")
             (setq pt1 (list (+ (car sp) 4.0) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 109.8) 7.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 75.6) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "22KVMO  ")
             (setq pt1 (list (+ (car sp) 4.0) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 124.8) 7.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 55.2) 2.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA-12D1")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 66.9) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 66.1) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA-12D2")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 66.9) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 90.6) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA-12S1")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 76.4) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 58.9) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA-12S2")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 76.4) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 87.1) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA-12S3")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 76.4) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 95.1) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA-12S3")
             (setq pt1 (list (+ (car sp) 4.5) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 76.4) 8.2) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 95.1) 3.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "36KVSF2 ")
             (setq pt1 (list (+ (car sp) 7.0) (+ (cadr sp) 4.0))
                   pt2 (list (- (+ (car sp) 115.6) 10.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 72.0) 2.5))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA362  ")
             (setq pt1 (list (+ (car sp) 5.0) (+ (cadr sp) 3.0))
                   pt2 (list (- (+ (car sp) 116.4) 10.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 72.4) 3.0))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
            ((= door_type "VHA361  ")
             (setq pt1 (list (+ (car sp) 5.0) (+ (cadr sp) 3.0))
                   pt2 (list (- (+ (car sp) 116.4) 10.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 52.4) 3.0))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )

;;FOR UNISAFE
	    ((= door_type "U600-1  ")
             (setq pt1 (list (+ (car sp) 5.5) (+ (cadr sp) 6.0))
                   pt2 (list (- (+ (car sp) 58.5) 10.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 75.0) 4.0))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )

	    ((= door_type "U600-2  ")
             (setq pt1 (list (+ (car sp) 5.5) (+ (cadr sp) 6.0))
                   pt2 (list (- (+ (car sp) 58.5) 10.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 103.0) 4.0))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )
	    ((= door_type "U750-1  ")
             (setq pt1 (list (+ (car sp) 5.5) (+ (cadr sp) 6.0))
                   pt2 (list (- (+ (car sp) 73.5) 10.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 75.0) 4.0))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )

	    ((= door_type "U750-2  ")
             (setq pt1 (list (+ (car sp) 5.5) (+ (cadr sp) 6.0))
                   pt2 (list (- (+ (car sp) 73.5) 10.0) (cadr pt1))
                   pt3 (list (car pt2) (- (+ (cadr sp) 103.0) 4.0))
                   pt4 (list (car pt1) (cadr pt3))
             )
            )

      )      
)  ;end of defun
;------------------------------------------------------------------------------
(defun out_limit()
      (lim)
      (setq x_l  (fix (* (+ (car sp) l_cl met_wid) 100))
            x_r  (fix (* (- (+ (car sp) door_wid) (+ met_wid r_cl)) 100))
            y_b  (fix (* (+ (cadr sp) b_cl bmet_ht) 100))    
            y_t  (fix (* (- (+ (cadr sp) door_ht) (+ tmet_ht t_cl)) 100))
      )
      (setq cmp_ptx (fix (* (car ins_pt) 100)))
      (setq cmp_pty (fix (* (cadr ins_pt) 100)))
      (if (and (>= cmp_ptx x_l)
               (<= cmp_ptx x_r)
               (>= cmp_pty y_b)
               (<= cmp_pty y_t)
          )
          (setq validity "Y")
          (setq validity "N")
      )
)  ;end of defun
;------------------------------------------------------------------------------
(defun bound()
       (lim)
       (command "layer" "s" "bound" ""
                "linetype" "s" "hidden" ""
       )
       (setq b1 (list (+ (car ins_pt) met_wid cl_r) (+ (cadr ins_pt) tmet_ht))
             b2 (list (car b1) (- (cadr b1) height cl_bet))
             b3 (list (- (car b2) width cl_r cl_l) (cadr b2))
             b4 (list (car b3) (cadr b1))
             b5 (list (car b3) (+ (cadr b3) cl_bet))
             b6 (list (car b2) (cadr b5))
       )
       (command "line" b1 b2 b3 b4 b1 ""
                "line" b5 b6 ""
                "linetype" "s" "bylayer" ""
                "layer" "s" "met_ga" ""
       )
);draw boundary showing clearances
;------------------------------------------------------------------------------
(defun clear()
       (lim)
       (if (or (= type "BC") (= type "LR"))
           (progn
                (setq cl_pt1 (list (+ (- (car ins_pt) met_wid cl_l) tmp_cl_r 0.1) (+ (- (cadr ins_pt) bmet_ht) 0.1))
                       cl_pt2 (list (- (+ (car ins_pt) met_wid cl_r) tmp_cl_l 0.2) (- (+ (cadr cl_pt1) height) 0.2))
                )
           )
           (progn 
;                (setq cl_pt1 (list (+ (- (car ins_pt) met_wid) 0.1) (+ (- (cadr ins_pt) bmet_ht) 0.1))
;                     cl_pt2 (list (- (+ (car ins_pt) met_wid) 0.2) (- (+ (cadr cl_pt1) height) 0.2))
;CHANGED ON 2000-10-04                
;                 ) 
                (setq cl_pt1 (list (+ (- (car ins_pt) met_wid cl_l) 0.1) (+ (- (cadr ins_pt) bmet_ht) 0.1))
                     cl_pt2 (list (- (+ (car ins_pt) met_wid cl_r) 0.2) (- (+ (cadr cl_pt1) height) 0.2))
                )
           )
        );end of if
      (if (= (ssget "CP" (list cl_pt1 (LIST (CAR CL_PT1) (CADR CL_PT2)) 
                               cl_pt2 (LIST (CAR CL_PT2) (CADR CL_PT1)))
                                 (LIST (CONS 8 "MET_GA"))) nil)
           (setq cl_pt "Y")
           (setq cl_pt "N")
      ) ;CHANGED ON 2000-10-04 -bnv

;       (if (= (ssget "w" cl_pt1 cl_pt2) nil)
;           (setq cl_pt "Y")
;           (setq cl_pt "N")
;      )

       (gc)
)
;------------------------------------------------------------------------------
(defun adjust()
       (lim)
       (setq adj (strcase (getstring "\nFlush With :Corner/Edge/Middle(C/E/M)(N):")))
       (if (or (= adj "C") (= adj "E") (= adj "M"))
           (progn
             (cond ((= adj "C")
                    (command "osnap" "int")
                    (setq ins_a  (getpoint "\nPick The Corner To Be Flushed With:")
           
                          ins_pt (getpoint "\nIndicate Direction Of Insertion:")
                    )
                    (cond ((and (< (car ins_a) (car ins_pt)) (> (cadr ins_a) (cadr ins_pt)))
                                (if (or (= type "BC") (= type "LR"))
                                    (setq ins_pt (list (+ (car ins_a) met_wid (- cl_l tmp_cl_r)) (- (cadr ins_a) tmet_ht)))
                                    (setq ins_pt (list (+ (car ins_a) met_wid) (- (cadr ins_a) tmet_ht)))
                                )
                          )
                          ((and (> (car ins_a) (car ins_pt)) (> (cadr ins_a) (cadr ins_pt)))
                                (if (or (= type "BC") (= type "LR"))
                                    (setq ins_pt (list (- (car ins_a) met_wid (- cl_r tmp_cl_l)) (- (cadr ins_a) tmet_ht)))
                                    (setq ins_pt (list (- (car ins_a) met_wid) (- (cadr ins_a) tmet_ht)))
                                )
                          )
                          ((and (< (car ins_a) (car ins_pt)) (< (cadr ins_a) (cadr ins_pt)))
                                (if (or (= type "BC") (= type "LR"))
                                    (setq ins_pt (list (+ (car ins_a) met_wid (- cl_l tmp_cl_r)) (+ (cadr ins_a) bmet_ht cl_bet)))
                                    (setq ins_pt (list (+ (car ins_a) met_wid) (+ (cadr ins_a) bmet_ht cl_bet)))
                                )
                          )
                          ((and (> (car ins_a) (car ins_pt)) (< (cadr ins_a) (cadr ins_pt)))
                                (if (or (= type "BC") (= type "LR"))
                                    (setq ins_pt (list (- (car ins_a) met_wid (- cl_r tmp_cl_l)) (+ (cadr ins_a) bmet_ht cl_bet)))
                                    (setq ins_pt (list (- (car ins_a) met_wid) (+ (cadr ins_a) bmet_ht cl_bet)))
                                )
                          )
                    )
                    (command "osnap" "OFF")               
                   )
                   ((= adj "E")
                    (command "osnap" "nea")
                    (setq ins_av (getpoint "\nSelect Vertical Edge:")
                          ins_ah (getpoint "\nSelect Horizontal Edge:")
                    )
                    (setq xv (car ins_av)
                          yv (cadr ins_av)
                          xh (car ins_ah)
                          yh (cadr ins_ah)
                    )
                    (command "osnap" "OFF") 
                    (cond ((and (< xv xh) (< yv yh))
                           (if (or (= type "BC") (= type "LR"))
                               (setq ins_pt (list (+ xv met_wid (- cl_l tmp_cl_r)) (- yh tmet_ht)))
                               (setq ins_pt (list (+ xv met_wid) (- yh tmet_ht)))
                           )
                          )
                          ((and (> xv xh) (< yv yh))
                                (if (or (= type "BC") (= type "LR"))
                                    (setq ins_pt (list (- xv met_wid (- cl_r tmp_cl_l)) (- yh tmet_ht)))
                                    (setq ins_pt (list (- xv met_wid) (- yh tmet_ht)))
                                )
                          )
                          ((and (< xv xh) (> yv yh))
                                (if (or (= type "BC") (= type "LR"))
                                    (setq ins_pt (list (+ xv met_wid (- cl_l tmp_cl_r)) (+ yh bmet_ht)))
                                    (setq ins_pt (list (+ xv met_wid) (+ yh bmet_ht)))
                                )
                          )
                          ((and (> xv xh) (> yv yh))
                                (if (or (= type "BC") (= type "LR"))
                                    (setq ins_pt (list (- xv met_wid (- cl_r tmp_cl_l)) (+ yh bmet_ht)))
                                    (setq ins_pt (list (- xv met_wid) (+ yh bmet_ht)))
                                )
                          )
                    )
                   );end of edge condition
                   ((= adj "M")
                    (command "osnap" "nea")
                    (setq ins_a    (getpoint "\nPick Apparatus For Middle Point:")
                          ins_pt   (getpoint "\nPick The Edge To Be Flushed With:")
                          ins_aset (ssget ins_a)
                          ins_aent (entget (ssname ins_aset 0))
                          ins_a    (assoc 10 ins_aent)
                          ins_a    (list (nth 1 ins_a) (nth 2 ins_a))
                    )
                    (gc)
                    (command "osnap" "OFF")
                    (cond ((> (cadr ins_a) (cadr ins_pt))
                           (setq ins_pt (list (car ins_a) (- (cadr ins_pt) tmet_ht)))
                          )
                          ((< (cadr ins_a) (cadr ins_pt))
                           (setq ins_pt (list (car ins_a) (+ (cadr ins_pt) bmet_ht cl_bet )))
                          )
                    )
                   );end of middle cond
             );end of cond
           );end of progn
           (setq ins_pt (getpoint "\nEnter Insertion Of Apparatus:"))
        );end of if
);end of defun
;------------------------------------------------------------------------------
(defun init_var()

(WHILE (OR (= ITEM_DESN NIL) (= ITEM_DESN ""))
  (setq item_desn     (strcase (getstring T "\nItem Designation : ")))
)
(WHILE (OR (= TYPE NIL) (= TYPE ""))
  (setq type case_size);          (strcase (getstring T "Name of Relay : "))
)
(SETQ	plt_yn "N" old_pt ins_pt)

  (cond ((OR (= TYPE "LAMP") (= type "LMP")) (setq type "LAMP" width 3.3 height 5.3 labelyn "N"))
	((or (= type "B/C") (= type "L/R")) (setq type (strcat (substr type 1 1) (substr type 3 1))))
  )
(if (/= type "LAMP")
(progn	
  (initget (+ 1 2 4))
  (setq	     width         (/  (getreal "Width of Relay : ") 10.0))
  (initget (+ 1 2 4))
  (Setq	     height        (/  (getreal "Height of Relay : ") 10.0))
  (if (and (/= type "LR") (/= type "BC"))
  (progn
  (initget  1 "Y N")
  (setq      labelyn   (strcase (getkword "Lable required <Y/N> : ")))
  )
  (setq labelyn "N")
  )
)
);end of if -> type /= LMP
 
);initiate variables
;------------------------------------------------------------------------------
(defun trm()
  (setq st1  type
        sl1  (strlen st1)
        st2  item_desn
        sl2  (strlen st2)
  )
  (if (/= st1 "        ")
      (progn
        (while (= (substr st1 sl1 1) " ")
               (setq sl1 (1- sl1))
        )
      )
  )
  (if (/= st2 "        ")
      (progn
        (while (= (substr st2 sl2 1) " ")
               (setq sl2 (1- sl2))
        )
      )
  )
  (setq type      (substr st1 1 sl1)
        item_desn (substr st2 1 sl2)
  )
);remove blank spaces from type&item_desn
;------------------------------------------------------------------------------
(defun lim()
       (setq met_wid (/ width 2.0))
       (if (or (= type "LAMP") (= type "PB") (= type "BC") (= type "LR"))
           (progn
              (cond ((= type "LAMP")
                     (setq bmet_ht 3.7     ;;  1.6
                           tmet_ht 1.6     ;;  3.7
                     )
                    )
                    ((= type "PB") 
                     (setq bmet_ht 1.8
                           tmet_ht 3.2
                     )
                    )
                    ((or (= type "BC") (= type "LR"))
                     (setq bmet_ht 3.5
                           tmet_ht 4.8
                     )
                    )
               );end of cond
            );end of progn
            (progn
               (setq bmet_ht (/ height 2.0)
                     tmet_ht bmet_ht
               )
            );end of progn
       );end of if   
       (cond ((or (= door_type "11KVSF1 ")
                  (= door_type "11KVSF2 ")
                  (= door_type "VHA-12S1")
                  (= door_type "VHA-12S2")
                  (= door_type "VHA-12S3")
                  (= door_type "VHA-12D2")
                  (= door_type "VHA-12D1")
             )
             (setq l_cl    4.5
                   r_cl    8.2
                   b_cl    4.0
                   t_cl    3.5
             )
            )

           ((or (= door_type  "U600-1  ")
                 (= door_type "U600-2  ")
                 (= door_type "U750-1  ")
                 (= door_type "U750-2  ")
             )
             (setq l_cl    5.5
                   r_cl    10.0
                   b_cl    6.0
                   t_cl    4.0
             )
            )


            ((or (= door_type "11KVMO1 ")
                 (= door_type "11KVMO2 ")
                 (= door_type "11KVMO3 ")
                 (= door_type "11KVMO4 ")
             )
             (setq l_cl    4.0
                   r_cl    7.0
                   b_cl    4.0
                   t_cl    2.5
             )
            )
            ((= door_type "22KVSF  ")
             (setq l_cl    4.0
                   r_cl    7.0
                   b_cl    4.0
                   t_cl    3.5
             )
            )
            ((= door_type "22KVMO  ")
             (setq l_cl    4.0
                   r_cl    7.0
                   b_cl    4.0
                   t_cl    2.5
             )
            )
            ((or (= door_type "36KVSF1 ") (= door_type "36KVSF2 "))
             (setq l_cl    7.0
                   r_cl    10.0
                   b_cl    4.0
                   t_cl    2.5
             )
            )
            ((or (= door_type "VHA361  ") (= door_type "VHA362  "))
             (setq l_cl    5.0
                   r_cl    10.0
                   b_cl    3.0
                   t_cl    3.0
             )
            )


      );end of cond
      (if (= labelyn "Y")
          (setq cl_bet 4.0)
          (setq cl_bet 2.5)
      )
      (if (or (= type "BC") (= type "LR"))
              (progn
                (cond ((= type "BC")
                       (setq cl_l 4.0
                             cl_r 3.5
                             cl "Y"
                       )
                      )
                      ((= type "LR")
                       (setq cl_l 4.0
                             cl_r 4.0
                             cl "Y"
                       )
                      )
                );end of cond
               );end of progn
               (progn
                 (if (and (/= type "LR") (/= type "BC") (= cl "Y"))
                     (progn
                        (setq cl_l 3.5
                              cl "N"
                        )
                     );end of progn
                     (setq cl_l 1.2)
                 );end of if
                 (setq cl_r 1.2)
            );end of progn 
      );end of if
      (cond ((= door_type "11KVSF1 ")
             (setq door_wid 76.4 
                   door_ht  66.9
             )
            )
            ((= door_type "11KVSF2 ")
             (setq door_wid 76.4 
                   door_ht  95.1
             )
            )
            ((= door_type "11KVMO1 ")
             (setq door_wid 74.8 
                   door_ht  70.4
             )
            )
            ((= door_type "11KVMO2 ")
             (setq door_wid 74.8 
                   door_ht  95.8
             )
            )
            ((= door_type "11KVMO3 ")
             (setq door_wid 89.8 
                   door_ht  70.4
             )
            )
            ((= door_type "11KVMO4 ")
             (setq door_wid 89.8 
                   door_ht  95.8
             )
            )
            ((= door_type "VHA-12D1")
             (setq door_wid 66.9 
                   door_ht  66.1
             )
            )
            ((= door_type "VHA-12D2")
             (setq door_wid 66.9 
                   door_ht  90.6
             )
            )
            ((= door_type "VHA-12S1")
             (setq door_wid 76.4 
                   door_ht  58.9
             )
            )
            ((= door_type "VHA-12S2")
             (setq door_wid 76.4 
                   door_ht  87.1
             )
            )
            ((= door_type "VHA-12S3")
             (setq door_wid 76.4 
                   door_ht  95.1
             )
            )
            ((= door_type "22KVSF  ")
             (setq door_wid 109.8 
                   door_ht  75.6
             )
            )
            ((= door_type "22KVMO  ")
             (setq door_wid 124.8 
                   door_ht  55.2
             )
            )
            ((= door_type "22KVMO  ")
             (setq door_wid 124.8 
                   door_ht  55.2
             )
            )
            ((= door_type "VHA361  ")
             (setq door_wid 116.4 
                   door_ht  52.4
             )
            )
            ((= door_type "VHA362  ")
             (setq door_wid 116.4 
                   door_ht  72.4
             )
            )
            ((= door_type "36KVSF2 ")
             (setq door_wid 115.6 
                   door_ht  72.0
             )
            )

            ((= door_type "U600-1  ")
             (setq door_wid 58.5 
                   door_ht  75.0
             )
            )
            ((= door_type "U600-2  ")
             (setq door_wid 58.5 
                   door_ht  103.0
             )
            )
            ((= door_type "U750-1  ")
             (setq door_wid 73.5 
                   door_ht  75.0
             )
            )
            ((= door_type "U750-2  ")
             (setq door_wid 73.5 
                   door_ht  103.0
             )
            )


      );end of cond
);end of defun
;------------------------------------------------------------------------------
(defun cut_out_det()
       (command "layer" "s" "cut_det" ""
                "insert" "h:/block/metga/cut_det" '(50 275) 1 1 0
		"text" '(126 7.5) "4" "" drg_no
		"text" '(126 38) "3.5" "" des1
		"text" '(198 7) "2.5"  "" "3"
		"text" '(198 16) "2.5"  "" "3"
       )
)
;------------------------------------------------------------------------------

(defun chk()
(setq	abb_list (list "RHGX20" "RHGX12" "RHGX8" "RHGX4" "HALF" "PQ8CHU" "MIDOS" "SPA-140C" "SPA-310C" "ONE")
	my_size (LIST (LIST 470 210) (LIST 300 210) (LIST 216 210) (LIST 132 210) (LIST 102 158) (LIST 150 110) (LIST 103 177) (LIST 142 162) (LIST 226 162) (LIST 100 270))
	my_list abb_list
	ee_list (LIST "1DV" "1.5DV" "2DV" "3DH" "3DV" "QTRN" "HALFNH" "HALFNV")
	my_size (append my_size (LIST (LIST 170 233) (LIST 170 362) (LIST 170 422) (LIST 454 233) (LIST 170 524) (LIST 105 118) (LIST 153 124) (LIST 124 153)))
	my_list (append my_list ee_list)
	er_list	(LIST "1V" "3H" "1N" "3N")
	my_size (append my_size (LIST (LIST 168 243) (LIST 455 243) (LIST 73 128) (LIST 156 128)))
	my_list (append my_list er_list)
	mtr_list (LIST "KWH-ALPHA" "KWH-SIMCO" "KWH-IMP" "144SQ" "110SQ" "96SQ")
	my_size (append my_size (LIST (LIST 200 275) (LIST 170 267) (LIST 181 277) (LIST 144 144) (LIST 110 110) (LIST 96 96)))
	my_list (append my_list mtr_list)
	ann_list (list "YASH-6P" "YASH-8P" "YASH-10P" "240-SQ" "ALAN-6P" "ALAN-8P" "ALAN-11P" "ALAN-15P" "ALAN-19P" "ALAN-23P")
	my_size (append my_size (list (list 240 125) (list 310 125) (list 380 125) (list 240 240) (LIST 265 166) (LIST 265 166) (LIST 265 205) (LIST 315 183) (LIST 315 223) (LIST 315 263)))
	my_list (append my_list ann_list)
	SW_LIST (LIST "75SQ" "48SQ" "LR95" "LR75" "AM" "BC70X83" "BC95")
	my_size (append my_size (LIST (LIST 75 75) (LIST 48 48) (LIST 95 95) (list 75 75) (list 95 95) (LIST 70 83) (list 95 95)))
	my_list (append my_list sw_list)
	ttb_list (list "CD-TTB")
	my_size (append my_size (list (list 203 84)))
	my_list (append my_list ttb_list)
;	n1 0	
)
)

(defun init_vars()
(setq ptype type         ; for repeating last instrument
      pwidth width       ; to avoid entry of information
      pheight height     ; again and again for same instrument.
)
(setq type nil width nil height nil n1 0 n2 0 plt_yn "N" old_pt ins_pt)
(textscr)
(prompt "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nStandard Cases for ABB Make Relays : \n")
(while (/= (nth n1 abb_list) nil) (prompt (strcat (nth n1 abb_list) " , ")) (setq n1 (+ 1 n1) n2 (+ 1 n2)))
(setq n1 0)
(prompt "\n\nStandard Cases for EE Make Relays : \n")
(while (/= (nth n1 ee_list) nil) (prompt (strcat (nth n1 ee_list) " , ")) (setq n1 (+ 1 n1) n2 (+ 1 n2)))
(setq n1 0)
(prompt "\n\nStandard Cases for ER Make Relays : \n")
(while (/= (nth n1 er_list) nil)  (prompt (strcat (nth n1 er_list) " , ")) (setq n1 (+ 1 n1) n2 (+ 1 n2)))
(setq n1 0)
(prompt "\n\nStandard Meters : \n")
(while (/= (nth n1 mtr_list) nil) (prompt (strcat (nth n1 mtr_list) " , ")) (setq n1 (+ 1 n1) n2 (+ 1 n2)))
(setq n1 0)

(prompt "\n\nStandard Annunciations : \n")
(while (/= (nth n1 ann_list) nil) (prompt (strcat (nth n1 ann_list) " , ")) (setq n1 (+ 1 n1) n2 (+ 1 n2)))
(setq n1 0)

(prompt "\n\nStandard Switches : \n")
(while (/= (nth n1 sw_list) nil)  (prompt (strcat (nth n1 sw_list) " , ")) (setq n1 (+ 1 n1) n2 (+ 1 n2)))

(setq n1 0)
(prompt "\n\nStandard TTB : \n")
(while (/= (nth n1 ttb_list) nil)  (prompt (strcat (nth n1 ttb_list) " , ")) (setq n1 (+ 1 n1) n2 (+ 1 n2)))
(princ "\n")

;(setq	abb_list ee_list er_list mtr_list ann_list SW_LIST ttb_list)

(initget 1)
(setq	item_desn (strcase (getstring T "\nItem Designation : "))
	case_size (strcase (getstring T "Case Size of Apparatus : "))
	n 0
)
(while (or (= case_size "") (= case_size nil))
(setq	case_size (strcase (getstring T "Case Size of Apparatus : ")))
)

(if (= case_size "LAST") 
 (setq type ptype  width pwidth height pheight)
 
 (progn

	(while (and (/= (nth n my_list) nil) (/= case_size (nth n my_list))) (setq n (+ 1 n)))
	(if (= (nth n my_list) case_size) 
	  (setq width (* 0.1 (car (nth n my_size))) height (* 0.1 (cadr (nth n my_size))))
	)
	  (if (and (= width nil) (= height nil))
	 	(init_var)
	  	(progn
			(if (= (substr case_size 1 3) "KWH")  (setq type (substr case_size 1 3)))
			(if (= (substr case_size 1 4) "RHGX") (setq type (substr case_size 1 6)))
			(if (= type nil) (setq type (strcase (getstring T "Name of Apparatus : "))))
			(setq labelyn (strcase (getstring T "Lable Y/N : ")))
		 )
  	  )
 )
)
)
(DEFUN C:readd()
       (setvar "cmdecho" 0)
       (setvar "regenmode" 0)
       (initget 1 "Y N")
       (setq add_yn (strcase (getkword "\nAdd more : <Y/N> : ")))
       (if (/= add_yn "N")
        (init_vars)
	)
       (command "zoom" "w" '(25 100) '(225 240)
       		"layer" "on" "bound" "")
	(while (/= add_yn "N")
       (ins_met)
;       (create_list)
;       (if (= plt_yn "N")
;           (write_out_file1)
;           (setq plt_yn "N")
;       )
;       (if (= labelyn "Y")
;           (write_out_file2)
;       )
;       (setq iptstr (read-line fd))
       (initget 1 "Y N")
       (setq add_yn (strcase (getkword "\nAdd more : <Y/N> : ")))
       (if (/= add_yn "N")
           (init_vars)
       )
	);end of while
)
;************************** Insert First sheet for Door Cutout Drawing ***
(defun ins_std_door()
;;	(if (and (/= door_type "VHA-12D1") (/= door_type "VHA-12D2"))
;;	(progn
       (command "layer" "s" "door" "off" "met_ga" ""
		"text" '(126 7.5) "4" "0" drg_no
		"text" '(126 38) "3.5" "0" des1
		"text" '(198 7) "2.5" "0" "1"
		"text" '(198 16) "2.5" "0" "1"
       )
       (cond 
;	     ((= door_type "11KVSF1 ")
;             (command "insert" "h:/cutout/sf6-669" '(22 48) 0.8235 0.87 "0")
;             )
;             ((= door_type "11KVSF2 ")
;              (command "insert" "h:/cutout/sf6-951" '(22 48) 0.8235 0.87 "0")
;             )
             ((= door_type "VHA-12D1")
              (command "insert" "h:/cutout/12D_661" '(22 48) 0.08235 0.087 "0")
             )
             ((= door_type "VHA-12D2")
              (command "insert" "h:/cutout/12D_906" '(22 48) 0.08235 0.087 "0")
             )
             ((= door_type "11KVMO1 ")
              (command "insert" "h:/cutout/800-744" '(22 48) 0.8235 0.87 "0")
             )
             ((= door_type "11KVMO2 ")
              (command "insert" "h:/cutout/800-1000" '(22 48) 0.8235 0.87 "0")
             )

             ((= door_type "11KVMO3 ")
              (command "insert" "h:/cutout/950-744" '(22 48) 0.8235 0.87 "0")
             )
             ((= door_type "11KVMO4 ")
              (command "insert" "h:/cutout/950-1000" '(22 48) 0.8235 0.87 "0")
             )
             ((= door_type "22KVSF  ")
              (command "insert" "h:/cutout/22kvsf6" '(22 48) 0.8235 0.87 "0")
             )
             ((= door_type "22KVMO  ")
              (command "insert" "h:/cutout/22kvmo" '(22 48) 0.8235 0.87 0)
             )
             ((= door_type "VHA-12S1")
              (command "insert" "h:/cutout/12s-589" '(22 48) 0.8235 0.87 0)
             )
             ((= door_type "VHA-12S2")
              (command "insert" "h:/cutout/12s-871" '(22 48) 0.8235 0.87 0)
             )
             ((= door_type "VHA-12S3")
              (command "insert" "h:/cutout/12s-951" '(22 48) 0.8235 0.87 0)
             )
             ((= door_type "VHA361  ")
              (command "insert" "h:/cutout/36kv-524" '(22 48) 0.8235 0.87 0)
             )
             ((= door_type "VHA362  ")
              (command "insert" "h:/cutout/36kv-724" '(22 48) 0.8235 0.87 0)
             )

       )
       (command "layer" "s" "met_ga" "off" "door" "")

;;;;	))
)