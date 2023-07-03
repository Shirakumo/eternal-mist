(in-package #:org.shirakumo.fraf.eternal-mist)
(in-readtable :qtools)

(define-subject colleen (sprite-subject collidable-subject rotated-subject pivoted-subject savable)
  ((velocity :initarg :velocity :accessor velocity)
   (facing :initarg :facing :accessor facing))
  (:default-initargs
   :velocity (vec 0 0 0)
   :location (vec 0 0 0)
   :bounds (vec 50 80 10)
   :pivot (vec -25 0 5)
   :facing :left
   :name :player
   :animations '((idle 2.0 20 :texture "colleen-idle.png")
                 (walk 0.7 20 :texture "colleen-walking.png"))))

(defun nvclamp (vec x y z)
  (vsetf vec
         (max (- x) (min x (vx vec)))
         (max (- y) (min y (vy vec)))
         (max (- z) (min z (vz vec)))))

(defmethod initialize-instance :after ((colleen colleen) &key)
  (setf *player* colleen))

(define-handler (colleen tick) (ev)
  (with-slots (location velocity angle facing) colleen
    (let* ((ang (* (/ angle 180) PI))
           (vec (nvrot (vec -1 0 0) (vec 0 1 0) ang)))
      (when (< 0.01 (abs (- (vx vec) (ecase facing (:left -1) (:right 1)))))
        (incf angle 20)))
    (nv+ location velocity)
    (nvclamp location 230 0 230)))

(define-handler (colleen movement) (ev)
  (with-slots (location velocity facing) colleen
    (typecase ev
      (start-left
       (setf facing :left)
       (setf (vx velocity) -7))
      (start-right
       (setf facing :right)
       (setf (vx velocity) 7))
      (start-up
       (setf (vz velocity) -7))
      (start-down
       (setf (vz velocity) 7))
      (stop-left
       (when (< (vx velocity) 0)
         (setf (vx velocity) 0)))
      (stop-right
       (when (< 0 (vx velocity))
         (setf (vx velocity) 0)))
      (stop-up
       (when (< (vz velocity) 0)
         (setf (vz velocity) 0)))
      (stop-down
       (when (< 0 (vz velocity))
         (setf (vz velocity) 0))))
    (if (< 0 (vlength velocity))
        (setf (animation colleen) 'walk)
        (setf (animation colleen) 'idle))))

(defmethod paint ((colleen colleen) target)
  (call-next-method))
