#|
This file is a part of ld35
(c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
Author: Janne Pakarinen <gingeralesy@gmail.com>
|#

(in-package #:org.shirakumo.fraf.ld35)

(define-subject tile (subject)
  ((objects :initform (flare-queue:make-queue) :accessor objects)
   (player-p :initform NIL :accessor player-p)
   (x :initarg :x :accessor x)
   (y :initarg :y :accessor y))
  (:default-initargs
   :x (error "Please provide x coordinate.")
   :y (error "Please provide y coordinate.")))

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
   (tiles :initform NIL :accessor tiles)
   (player-tile :initform NIL :accessor player-tile))
  (:default-initargs
   :width (error "Please define width.")
   :height (error "Please define height.")))

(defmethod initialize-instance ((map tilemap) &key)
  (unless (and (< 0 (height map)) (< 0 (width map)))
    (error "Invalid dimensions."))
  (setf (tiles map) (make-array `(,(width map) ,(height map))
                                :fill-pointer 0)))

(defmethod add-tile-object ((map tilemap) (object textured-subject) x y)
  (let ((tile (tile map x y)))
    (unless tile
      (setf tile (make-instance 'tile :x x :y y))
      (setf (tile map x y) tile))
    (add-object tile object)))

(defmethod depth ((map tilemap))
  (slot-value map 'depth))

(defmethod paint ((map tilemap) target)
  (dotimes (x (width map))
    (dotimes (y (height map))
      (let ((tile (tile map x y)))
        (when tile (paint tile target))))))

(defmethod tile ((map tilemap) x y)
  (aref (tiles map) x y))

(defmethod (setf tile) ((tile tile) (map tilemap) x y)
  (setf (aref (tiles map) x y) tile))

(defmethod top-tile-object ((map tilemap) x y)
  (let ((tile (tile map x y)))
    (when tile (top-object tile))))

(defmethod remove-top-tile-object ((map tilemap) x y)
  (let ((tile (tile map x y)))
    (when tile (remove-top-object tile))))

(define-handler (tilemap tick) (ev)
  (let ((isection (intersects tilemap (unit :player (scene *main*)))))
    (if isection
      (let* ((point (v- (v+ (location isection) (v/ (bounds isection) 2))
                        (location tilemap)))
             (tile-coords (v/ point (bounds tilemap))))
        (setf (player-tile tilemap) (tile tilemap (floor (vx tile-coords)) (floor (vy tile-coords)))))
      (setf (player-tile tilemap) NIL))))
