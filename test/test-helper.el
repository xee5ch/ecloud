;;; test-helper.el --- Helpers for ecloud-test.el  -*- lexical-binding: t; -*-

(require 'f)
(require 'ht)

(eval-and-compile
  (defvar project-root
    (locate-dominating-file default-directory ".git"))
  (defvar this-directory
    (f-join project-root "test")))

;; Initialize test coverage.
(when (require 'undercover nil t)
  (with-no-warnings
    (undercover "*.el")))

;; Load package
(require 'ecloud (f-join project-root "ecloud.el"))

;; Resources
(defun test-helper-string-resource (name)
  (let ((path (f-join this-directory "resources" name)))
    (f-read-text path)))

(defun test-helper-json-resource (name)
  (let* ((path (f-join this-directory "resources" name))
         (sample-response (f-read-text path)))
    (json-read-from-string sample-response)))

;; Helpers

(defmacro should-assert (form)
  `(let ((debug-on-error nil))
     (should-error ,form :type 'cl-assertion-failed)))

(defmacro test-helper-with-empty-state (&rest body)
  (declare (indent 0))
  `(let ((ecloud-state--current-state (ht-create)))
     ,@body))

;;; test-helper.el ends here