#|
This file is a part of ld35
(c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
Author: Janne Pakarinen <gingeralesy@gmail.com>
|#

(in-package #:org.shirakumo.fraf.ld35)

(define-subject tile (subject)
  ((objects :initform (flare-queue:make-queue) :accessor objects)))

(defmethod add-object ((tile tile) (object textured-subject))
  (flare-queue:enqueue object (objects tile)))

(defmethod paint ((tile tile) target)
  (let* ((old-queue (objects tile))
         (new-queue (flare-queue:make-queue))
         (object (flare-queue:dequeue old-queue)))
    (loop while object do
          (paint object target)
          (flare-queue:enqueue object new-queue)
          (setf object (flare-queue:dequeue old-queue)))
    (setf (objects tile) new-queue)))

(defmethod top-object ((tile tile))
  (flare-queue:queue-last (objects tile)))

(defmethod remove-top-object ((tile tile))
  ;; I don't really like this because it iterates through the entire thing
  (let ((obj (top-object tile)))
    (flare-queue:queue-remove obj (objects tile))))

(define-subject tilemap (bound-subject)
  ((width :initarg :width :accessor width)
   (height :initarg :height :accessor height)
   (depth :initform 0)
   (tiles :initform NIL :accessor tiles))
  (:default-initargs
   :width (error "Please define width.")
   :height (error "Please define height.")))

(defmethod initialize-instance ((map tilemap) &key)
  (unless (and (< 0 (height map)) (< 0 (width map)))
    (error "Invalid dimensions."))
  (setf (tiles map) (make-array `(,(width map) ,(height map))
                                :fill-pointer 0)))

(defmethod depth ((map tilemap))
  (slot-value map 'depth))

(defmethod paint ((map tilemap) target)
  (dotimes (x (width map))
    (dotimes (y (height map))
      (let ((tile (aref (tiles map) x y)))
        (when tile (paint tile target))))))

(defmethod tile ((map tilemap) x y)
  (aref (tiles map) x y))

(defmethod top-tile-object ((map tilemap) x y)
  (let ((tile (tile map x y)))
    (when tile (top-object tile))))

(defmethod remove-top-tile-object ((map tilemap) x y)
  (let ((tile (tile map x y)))
    (when tile (remove-top-object tile))))
