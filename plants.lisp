#|
This file is a part of ld35
(c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
Author: Janne Pakarinen <gingeralesy@gmail.com>
|#

(in-package #:org.shirakumo.fraf.ld35)

(define-subject flora-subject (pivoted-subject bound-subject sprite-subject clocked-subject)
  ((name :initarg :name :accessor name)
   (family :initarg :family :accessor family))
  (:default-initargs
   :name NIL
   :family NIL))

(define-subject seed-subject (flora-subject)
  ((sprout :initarg :sprout :accessor sprout))
  (:default-initargs
   :sprout (error "Define sprout class for this seed to grow into.")))

(defmethod plant-seed ((seed seed-subject) field)
  (let ((sprout (change-class seed (sprout seed)))
        (scene (scene *main*)))
    (leave seed scene)
    (enter sprout scene)
    (add-object (player-tile field) sprout)))

(defmacro define-seed (name direct-superclasses direct-slots &rest options))

(define-subject sprout-subject (flora-subject)
  ((produce :initarg :produce :accessor produce)
   (final-stage :initarg :final-stage :accessor final-stage)
   (stage-time :initform 0 :accessor stage-time))
  (:default-initargs
   :produce NIL))

(defmethod enter :after ((sprout sprout-subject) scene)
  (start sprout))

(defmethod stage ((sprout sprout-subject))
  (mod (clock sprout) (stage-time sprout)))

(defmethod make-produce ((sprout sprout-subject))
  (when (<= (final-stage sprout) (stage sprout))
    (loop for prod in (produce sprout) ;; Figure this one out later
          do (make-instance prod :location (location sprout)))
    (leave sprout (scene *main*))))

(defmacro define-sprout (name direct-superclasses direct-slots &rest options))

(define-subject produce-subject (flora-subject)) ;; TODO: add whatever statistics produce have

(defmacro define-produce (name direct-superclasses direct-slots &rest options))

;; REMOVE STUFF BELOW SOMEDAY

(defclass turnip (produce-subject)
  ()
  (:default-initargs
   :animations '((idle 1.0 1 :texture "turnip.png" :width 20 :height 20))))

(defclass turnip-sprout (sprout-subject)
  ()
  (:default-initargs
   :produce 'turnip
   :animations '((idle 1.0 1 :texture "turnip-sprout.png" :width 20 :height 20))))

(defclass turnip-seed (seed-subject)
  ()
  (:default-initargs
   :sprout 'turnip-sprout
   :animations '((idle 1.0 1 :texture "turnip-seed.png" :width 20 :height 20))))
