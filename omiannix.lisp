
(in-package :om)



(defvar *iannix-files* nil)
(setf  *iannix-files* '("iannix-objects"))

(mapc #'(lambda (file) (compile&load (om-relative-path '("sources") file)))
	*iannix-files*)


;--------------------------------------------------
; OM subpackages initialization
; ("sub-pack-name" subpacke-lists class-list function-list class-alias-list)
;--------------------------------------------------
(defvar *pack-iannix* nil)
(setf *pack-iannix*
      '(("Iannix Objects" nil (NxEnv NxCurve NxTraject NxTrigger NxCursor) (IanniXML NXpartition) nil)
        ("Iannix Control" nil nil nil nil)
        ))


(om::fill-library *pack-iannix*)


