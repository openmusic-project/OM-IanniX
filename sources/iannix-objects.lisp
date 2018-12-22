(in-package :om)

;;; Convertit un objet Iannix en texte XML
(defmethod! Iannixml ((self t)) 
  :icon 10
  "")

;;;===========
;;; PARTITION
;;;===========
(defclass! NxEnv ()
  ((ID :accessor ID :initarg :ID :initform '("partition" 0 "undefined"))
   (network :accessor network :initarg :network :initform '("localhost" 1980 1979))
   (bounds :accessor bounds :initarg :bounds :initform '(10 10))
   (time-settings :accessor time-settings :initarg :time-settings :initform '(0 10 1.0))
   (bgcolor :accessor bgcolor :initarg :bgcolor :initform '(0 0 0))
   (comments :accessor comments :initarg :comments :initform ""))
  (:icon 1)
)

(defmethod! Iannixml ((self NxEnv)) 
  (let ((str (format nil " <NxEnv>~%")))
    
    (setf str (string+ str "  <Version v=\"0.631b\"/> ~%"))
    
    (setf str (string+ str (format nil "  <ID name=~s ID=\"~s\" path=~s visualMode=\"1\" oscOutMode=\"1\" oscInMode=\"0\"/>~%" 
                                   (nth 0 (ID self)) (nth 1 (ID self)) (nth 2 (ID self))
                                   )))
    
    (setf str (string+ str (format nil "  <Bounds length=\"~s\" height=\"~s\"/>~%"
                                   (nth 0 (bounds self)) (nth 1 (bounds self)) 
                                   )))

    (setf str (string+ str (format nil "  <Time circlesAlgo=\"0\" globalTempo=\"~s\" startTime=\"~s\" stopTime=\"~s\" displayStep=\"33\" schedulerStep=\"4\"/> ~%"
                                   (nth 2 (time-settings self)) (nth 0 (time-settings self)) (nth 1 (time-settings self)) 
                                   )))

    (setf str (string+ str (format nil "  <Network host=~s inPort=\"~s\" outPort=\"~s\" broadcastMode=\"0\" curvesOSC=\"/iannix/curves\" triggersOSC=\"/iannix/triggers\"/> ~%"
                                   (nth 0 (network self)) (nth 1 (network self)) (nth 2 (network self)) 
                                   )))
    
    (setf str (string+ str (format nil "  <BackgroundColor ID=\"0\" r=\"~s\" g=\"~s\" b=\"~s\" a=\"0\"/> ~%"
                                   (nth 0 (bgcolor self)) (nth 1 (bgcolor self)) (nth 2 (bgcolor self)) 
                                   )))

    (setf str (string+ str "  <Display zoom=\"1\" scoreDraw=\"1\" displayOn=\"0\" crossesDraw=\"1\"/> ~%"))
    (setf str (string+ str "  <ScoreColor ID=\"0\" r=\"0\" g=\"0\" b=\"0\" a=\"0\"/> ~%"))
    (setf str (string+ str "  <Render texturing=\"1\" transparency=\"1\" background=\"0\"/> ~%"))
    (setf str (string+ str "  <Grid showGrid=\"1\" snapGrid=\"0\" autoGridStep=\"1\" gridStep=\"0\"/> ~%"))
    
    (setf str (string+ str "  <Trajects show=\"1\"/> ~%"))
    (setf str (string+ str "  <Cursors show=\"1\" showCursorsArea=\"0\"/> ~%"))
    (setf str (string+ str "  <Curves show=\"1\" circlesDraw=\"0\" rectDraw=\"1\" mappingDefaultMin=\"0\" mappingDefaultMax=\"10\" defaultSpatialPeriod=\"20\"/> ~%"))
    (setf str (string+ str "  <Triggers show=\"1\" defaultIntValue=\"1\"/> ~%"))
		
    (setf str (string+ str (format nil " </NxEnv>~%~%" )))
    
    str))


(defmethod! NXScore ((env NxEnv) objects &optional dir-pathname)
  :icon 11
  (let* ((path (or dir-pathname (om-choose-directory-dialog)))
        (file (make-pathname :directory (pathname-directory path) :name (nth 0 (id env)) :type "xml")))
    (setf (nth 2 (id env)) (namestring path))
    (WITH-OPEN-FILE (out file :direction :output  :if-does-not-exist :create :if-exists :supersede)
      (format out "<NxScore>~%")
      (format out (Iannixml env))
      (loop for obj in (list! objects) 
            for i = 0 then (+ i 1) do
            (setf (id obj) i)
            (format out (Iannixml obj))
            (format out " ~%"))
      (format out "</NxScore>~%")
      )
    path))
  
  
;;;===========
;;; CURVE
;;;===========
(defclass! NxCurve ()
  ((IDs :accessor IDs :initarg :IDs :initform '(0 0))   ;; customID et groupID
   (ID :accessor ID :initform 0)  ;; real ID
   (objname :accessor objname :initarg :objname :initform "NxCurve")
   (bpf :accessor bpf :initarg :bpf :initform nil)
   (objpos :accessor objpos :initarg :objpos :initform '(0 0))
   (color :accessor color :initarg :color :initform '(255 0 0))
   (style :accessor style :initarg :style :initform 'spline)
   (realvals :accessor realvals :initarg :realvals :initform '(0 10))
   (network :accessor network :initarg :network :initform '("localhost" 1979)))
  (:icon 2))

(defmethod! Iannixml ((self NxCurve))
  (let ((str (format nil " <NxCurve ID=\"~s\" customID=\"~s\" groupID=\"~s\" layer=\"0\" name=~s active=\"1\" nbPoints=\"~s\" transparency=\"true\" texture_path=\"default\" shape=\"default\" drawType=\"~s\" angle=\"0\" realMin=\"~s\" realMax=\"~s\" scale=\"1\" spatialPeriod=\"20\" host=~s port=\"~s\"> ~%"
                    (ID self) (car (IDs self)) (cadr (IDs self)) (objname self)
                    (length (point-list (bpf self)))
                    (if (equal (style self) 'spline) 7 8)
                    (car (realvals self)) (cadr (realvals self))
                    (car (network self)) (cadr (network self))
                    )))
    (setf str (concatenate 'string str (format nil "  <color ID=\"0\" r=\"~s\" g=\"~s\" b=\"~s\" a=\"255\"/> ~%"
                                               (nth 0 (color self)) (nth 1 (color self)) (nth 2 (color self)) 
                                               )))
    (setf str (concatenate 'string str (format nil "  <color ID=\"0\" r=\"~s\" g=\"~s\" b=\"~s\" a=\"255\"/> ~%"
                                               (nth 0 (color self)) (nth 1 (color self)) (nth 2 (color self)) 
                                               )))

    (setf str (concatenate 'string str (format nil "  <Position ID=\"0\" x=\"~s\" y=\"~s\" z=\"0\"/> ~%"
                                               (nth 0 (objpos self)) (nth 1 (objpos self)) 
                                               )))
    
    (loop for point in (point-list (bpf self)) 
          for i = 0 then (+ i 1) do
          (setf str (concatenate 'string str 
                                 (format nil "  <NxPoint ID=~s x=~s y=~s z=\"0.0\"/>~%"
                                         (num2string i) 
                                         (num2string (float (/ (om-point-h point) (expt 10 (decimals (bpf self)))))) 
                                         (num2string (float (/ (om-point-v point) (expt 10 (decimals (bpf self)))))))
                                 )))
    (setf str (concatenate 'string str (format nil " </NxCurve>~%")))
))
          


;;;===========
;;; TRIGGER
;;;===========
(defclass! NxTrigger ()
  ((IDs :accessor IDs :initarg :IDs :initform '(0 0))   ;; customID et groupID
   (ID :accessor ID :initform 0)  ;; real ID
   (objname :accessor objname :initarg :objname :initform "NxCurve")
   (objpos :accessor objpos :initarg :objpos :initform '(0 0))
   (color :accessor color :initarg :color :initform '(255 0 0))
   (network :accessor network :initarg :network :initform '("localhost" 1979))
   (value :accessor value :initarg :value :initform 1)
   )
  (:icon 4))

(defmethod! Iannixml ((self NxTrigger)) 
  (let ((str (format nil " <NxTrigger ID=\"~s\" customID=\"~s\" groupID=\"~s\" layer=\"0\" name=~s active=\"1\" host=~s port=\"~s\" value=\"~s\"> ~%"
                    (ID self) (car (IDs self)) (cadr (IDs self)) (objname self)
                    (car (network self)) (cadr (network self))
                    (value self)
                    )))
    (setf str (concatenate 'string str (format nil "  <color ID=\"0\" r=\"~s\" g=\"~s\" b=\"~s\" a=\"255\"/> ~%"
                                               (nth 0 (color self)) (nth 1 (color self)) (nth 2 (color self)) 
                                               )))
    
    (setf str (concatenate 'string str (format nil "  <NxPoint ID=\"0\" x=\"~s\" y=\"~s\" z=\"0\"/> ~%"
                                               (nth 0 (objpos self)) (nth 1 (objpos self)) 
                                               )))
    
    (setf str (concatenate 'string str (format nil " </NxTrigger>~%")))
))



;;;===========
;;; TRAJECT
;;;===========
(defclass! NxTraject ()
  ()
  (:icon 3))

(defmethod! Iannixml ((self NxTraject)) "")
  

;;;===========
;;; CURSOR
;;;===========
(defclass! NxCursor () ()
  (:icon 5))

(defmethod! Iannixml ((self NxCursor)) "")
  





