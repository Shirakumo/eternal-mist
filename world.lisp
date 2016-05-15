#|
 This file is a part of eternal-mist
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.fraf.eternal-mist)
(in-readtable :qtools)

(define-subject world (mesh-subject)
  ()
  (:default-initargs
   :mesh "world.obj"
   :name :world))

(defmethod paint ((world world) target)
  (gl:polygon-mode :back :line)
  (gl:cull-face :front)
  (gl:depth-func :lequal)
  (gl:color 0 0 0)
  (gl:line-width 5)
  (loop for mesh across (content (mesh world))
        do (loop for geom across (wavefront-loader:geometry mesh)
                 do (wavefront-loader:draw geom)))
  (gl:cull-face :back)
  (gl:polygon-mode :back :fill)
  (call-next-method))
