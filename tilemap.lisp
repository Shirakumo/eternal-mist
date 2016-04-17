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
   :y (error "Please provide y coordinate.")
   :bounds (error "Please provide tile size.")))

(defmethod initialize-instance :after ((tile tile) &key)
  (setf (location tile)
        (vec )))

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
    (setf (objects tile) new-queue))
  (call-next-method))

(defmethod top-object ((tile tile))
  (flare-queue:queue-last (objects tile)))

(defmethod remove-top-object ((tile tile))
  ;; I don't really like this because it iterates through the entire thing
  (let ((obj (top-object tile)))
    (flare-queue:queue-remove obj (objects tile))))

(define-subject tilemap (bound-subject pivoted-subject)
  ((width :initarg :width :accessor width)
   (height :initarg :height :accessor height)
   (depth :initform 0)
   (tiles :initform NIL :accessor tiles)
   (player-tile :initform NIL :accessor player-tile))
  (:default-initargs
   :width (error "Please define width.")
   :height (error "Please define height.")))

(defmethod initialize-instance :after ((map tilemap) &key)
  (unless (and (< 0 (height map)) (< 0 (width map)))
    (error "Invalid dimensions."))
  (unless (v< 0 (bounds map))
    (error "Tilemap has no physical size."))
  (setf (tiles map) (make-array `(,(width map) ,(height map))
                                :initial-element NIL))
  (when (v= 0 (pivot map))
    (let ((size (v/ (bounds map) 2)))
      (setf (pivot map) (v- 0 (vec (vx size) 0 (vz size)))))))

(defmethod add-tile-object ((map tilemap) (object textured-subject) x y)
  (let ((tile (tile map x y))
        (tile-side (/ (width map) (bounds (vx map))))
        (map-location (location map)))
    (unless tile
      (setf tile (make-instance 'tile :x x :y y
                                      :bounds (vec tile-side 1 tile-side)
                                      :location (vec (+ (* x tile-side) (vx map-location))
                                                     (vy map-location)
                                                     (+ (* y tile-side) (vz map-location)))))
      (setf (tile map x y) tile))
    (add-object tile object)))

(defmethod depth ((map tilemap))
  (slot-value map 'depth))

(defmethod paint ((map tilemap) target)
  (dotimes (x (width map))
    (dotimes (y (height map))
      (let ((tile (tile map x y)))
        (when tile (paint tile target)))))
  (call-next-method))

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
  ;; NTS: Remember that the tile Y-coordinate is specified with the world Z-coordinate
  (let ((isection (intersects tilemap (unit :player (scene *main*)) :ignore-y T)))
    (if isection
        (let* ((point (v- (location isection) (location tilemap)))
               (tile-coords (v/ point (bounds tilemap))))
          (if (and (v<= 0 tile-coords) (< (vx tile-coords) (width tilemap)) (< (vz tile-coords) (height tilemap)))
              (setf (player-tile tilemap) (tile tilemap (floor (vx tile-coords)) (floor (vz tile-coords))))
              (setf (player-tile tilemap) NIL)))
      (setf (player-tile tilemap) NIL))))
