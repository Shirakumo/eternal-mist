#|
 This file is a part of ld35
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.ld35)
(in-readtable :qtools)

(defun trial::setup-scene (scene)
  (enter (make-instance 'skybox) scene)
  (enter (make-instance 'world) scene)
  (enter (make-instance 'space-axes) scene)
  (enter (make-instance 'colleen) scene)
  (enter (make-instance 'following-camera
                        :name :camera
                        :target (unit :player scene)
                        :location (vec 0 150 250)) scene)
  (let ((field (make-instance 'tilemap
                              :location (vec 0 0 0)
                              :bounds (vec 200 1 200)
                              :width 10
                              :height 10)))
    (enter field scene)
    (dotimes (x 10)
      (dotimes (y 10)
        (let ((sprout (make-instance 'turnip-sprout)))
          (start sprout)
          (add-tile-object field sprout x y))))))

(defun launch (&optional standalone)
  (setf *root* (if standalone
                   (uiop:argv0)
                   (asdf:system-source-directory :ld35)))
  (trial:launch))
