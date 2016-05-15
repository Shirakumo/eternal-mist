#|
 This file is a part of eternal-mist
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:eternal-mist
  (:nicknames #:org.shirakumo.fraf.eternal-mist)
  (:use #:cl+qt #:trial)
  (:shadowing-import-from #:flare #:slot)
  (:shadow #:launch)
  (:export #:launch))
(in-package #:org.shirakumo.fraf.eternal-mist)
(in-readtable :qtools)
