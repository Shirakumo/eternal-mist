#|
This file is a part of ld35
(c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
Author: Janne Pakarinen <gingeralesy@gmail.com>
|#

(in-package #:org.shirakumo.fraf.ld35)

(define-subject flora-subject (face-subject tile-subject)
  ((name :initarg :name :accessor name)
   (family :initarg :family :accessor family))
  (:default-initargs
   :name NIL
   :family NIL
   :bounds (vec 20 20 1)))

(define-subject seed-subject (flora-subject)
  ((sprout :initarg :sprout :accessor sprout))
  (:default-initargs
   :sprout (error "Define sprout class for this seed to grow into.")))

(defmethod plant-seed ((seed seed-subject) field)
  (let ((sprout (change-class seed (sprout seed)))
        (scene (scene *main*)))
    (leave seed scene)
    (start sprout)
    (add-object (player-tile field) sprout)))

(defmethod paint ((seed seed-subject) field)
  ;; Seeds lie flat on the ground
  (with-pushed-matrix
    (gl:rotate 90 1 0 0)
    (call-next-method)))

(define-subject sprout-subject (flora-subject clocked-subject)
  ((produce :initarg :produce :accessor produce)
   (final-stage :initarg :final-stage :accessor final-stage)
   (stage-time :initform 0 :accessor stage-time))
  (:default-initargs
   :produce NIL))

(defmethod stage ((sprout sprout-subject))
  (mod (clock sprout) (stage-time sprout)))

(defmethod make-produce ((sprout sprout-subject))
  (when (<= (final-stage sprout) (stage sprout))
    ;; FIXME: multiple produce items? Continuous production?
    (make-instance (produce sprout) :location (location sprout))
    (leave sprout (scene *main*))))

(define-subject produce-subject (flora-subject)
  ()) ;; TODO: add whatever statistics produce have

;; REMOVE STUFF BELOW SOMEDAY

(define-subject turnip-produce (produce-subject)
  ()
  (:default-initargs
   :texture "turnip-produce.png"))

(define-subject turnip-sprout (sprout-subject)
  ()
  (:default-initargs
   :produce 'turnip-produce
   :texture "sprout.png"))

(define-subject turnip-seed (seed-subject)
  ()
  (:default-initargs
   :sprout 'turnip-sprout
   :texture "seed.png"))
