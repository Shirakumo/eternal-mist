#|
 This file is a part of eternal-mist
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#


(asdf:defsystem eternal-mist
  :version "1.0.0"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :license "zlib"
  :description "Entry for the Ludum Dare 35"
  :homepage "https://github.com/Shirakumo/trial"
  :serial T
  :defsystem-depends-on (:qtools)
  :components ((:file "package")
               (:file "player")
               (:file "world")
               (:file "tilemap")
               (:file "plants")
               (:file "main"))
  :depends-on (:trial)
  :build-operation "qt-program-op"
  :build-pathname "eternal-mist"
  :entry-point "eternal-mist:launch")
