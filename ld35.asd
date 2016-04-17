#|
 This file is a part of ld35
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:cl-user)
(asdf:defsystem ld35
  :version "1.0.0"
  :author "Nicolas Hafner <shinmera@tymoon.eu>"
  :maintainer "Nicolas Hafner <shinmera@tymoon.eu>"
  :license "Artistic"
  :description "Entry for the Ludum Dare 35"
  :homepage "https://github.com/Shirakumo/trial"
  :serial T
  :defsystem-depends-on (:qtools)
  :components ((:file "package")
               (:file "player")
               (:file "world")
               (:file "tilemap")
               (:file "main"))
  :depends-on (:trial)
  :build-operation "qt-program-op"
  :build-pathname "ld35"
  :entry-point "ld35:launch")
