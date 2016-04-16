#|
 This file is a part of ld35
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.ld35)
(in-readtable :qtools)

(define-subject colleen (located-subject textured-subject savable)
  ((velocity :initarg :velocity :accessor velocity)
   (frame :initform 0 :accessor frame))
  (:default-initargs
   :texture "colleen-walking.png"
   :velocity (vec 0 0 0)
   :location (vec 0 0 0)
   :name :player))

(define-handler (colleen tick) (ev)
  (nv+ (location colleen) (velocity colleen)))

(define-handler (colleen movement) (ev)
  (typecase ev
    (start-left (setf (vx (velocity colleen)) -5))
    (start-right (setf (vx (velocity colleen)) 5))
    (start-up (setf (vz (velocity colleen)) -5))
    (start-down (setf (vz (velocity colleen)) 5))
    (stop-left (when (< (vx (velocity colleen)) 0)
                 (setf (vx (velocity colleen)) 0)))
    (stop-right (when (< 0 (vx (velocity colleen)))
                  (setf (vx (velocity colleen)) 0)))
    (stop-up (when (< (vz (velocity colleen)) 0)
               (setf (vz (velocity colleen)) 0)))
    (stop-down (when (< 0 (vz (velocity colleen)))
                 (setf (vz (velocity colleen)) 0)))))

(defmethod paint ((colleen colleen) target)
  (let ((w (* 4 5.41)) (h (* 4 7.74)))
    (setf (frame colleen) (mod (1+ (frame colleen)) 7))
    (let ((frame (frame colleen)))
      (with-primitives :quads
        (gl:tex-coord 0 (* frame 1/7))
        (gl:vertex (- (/ w 2)) 0 0)
        (gl:tex-coord 1 (* frame 1/7))
        (gl:vertex (+ (/ w 2)) 0 0)
        (gl:tex-coord 1 (* (1+ frame) 1/7))
        (gl:vertex (+ (/ w 2)) h)
        (gl:tex-coord 0 (* (1+ frame) 1/7))
        (gl:vertex (- (/ w 2)) h)))))
