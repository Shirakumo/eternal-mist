#|
 This file is a part of ld35
 (c) 2016 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(defpackage #:ld35
  (:nicknames #:org.shirakumo.fraf.ld35)
  (:use #:cl+qt #:trial)
  (:shadowing-import-from #:flare #:slot)
  (:shadow #:launch)
  (:export #:launch))
(in-package #:org.shirakumo.fraf.ld35)
(in-readtable :qtools)
