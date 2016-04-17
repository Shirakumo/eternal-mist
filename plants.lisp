#|
This file is a part of ld35
(c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
Author: Janne Pakarinen <gingeralesy@gmail.com>
|#

(in-package #:org.shirakumo.fraf.ld35)

(define-subject flora-subject (pivoted-subject bound-subject textured-subject clocked-subject)
  ((name :initarg :name :accessor name)
   (family :initarg :family :accessor family))
  (:default-initargs
   :name NIL
   :family NIL))

(define-subject seed-subject (flora-subject)
  ((plant :initarg :plant :accessor plant))
  (:default-initargs
   :plant (error "Define plant class for this seed to grow into.")))

(defmethod plant-seed ((seed seed-subject) field)
  (let ((plant (change-class seed (plant seed)))
        (scene (scene *main*)))
    (leave seed scene)
    (enter plant scene)
    (add-object (player-tile field) plant)))

(define-subject plant-subject (flora-subject)
  ((produce :initarg :produce :accessor produce)
   (final-stage :initarg :final-stage :accessor final-stage)
   (stage-time :initform 0 :accessor stage-time))
  (:default-initargs
   :produce NIL))

(defmethod enter :after ((plant plant-subject) scene)
  (start plant))

(defmethod stage ((plant plant-subject))
  (mod (clock plant) (stage-time plant)))

(defmethod make-produce ((plant plant-subject))
  (when (<= (final-stage plant) (stage plant))
    (loop for prod in (produce plant) ;; Figure this one out later
          do (make-instance prod :location (location plant)))
    (leave plant (scene *main*))))

(define-subject produce-subject (flora-subject)) ;; TODO: add whatever statistics produce have

(defmacro define-flora-subject (name direct-superclasses direct-slots &rest options)
  ;; TODO: Macro for defining new plants with seeds and produce
  )
