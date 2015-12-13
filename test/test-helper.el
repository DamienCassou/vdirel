;;; test-helper --- Test helper for vdirel

;;; Commentary:
;; test helper inspired from https://github.com/tonini/overseer.el/blob/master/test/test-helper.el

;;; Code:

(require 'f)

(defvar cpt-path
  (f-parent (f-this-file)))

(defvar vdirel-test-path
  (f-dirname (f-this-file)))

(defvar vdirel-root-path
  (f-parent vdirel-test-path))

(defvar vdirel-sandbox-path
  (f-expand "sandbox" vdirel-test-path))

(when (f-exists? vdirel-sandbox-path)
  (error "Something is already in %s. Check and destroy it yourself" vdirel-sandbox-path))

(defmacro within-sandbox (&rest body)
  "Evaluate BODY in an empty sandbox directory."
  `(let ((default-directory vdirel-sandbox-path))
     (when (f-exists? vdirel-sandbox-path)
       (f-delete default-directory :force))
     (f-mkdir vdirel-sandbox-path)
     ,@body
     (f-delete default-directory :force)))

(require 'ert)

(require 'undercover)
(undercover "*.el" "vdirel/*.el"
            (:exclude "*-test.el")
            ;; (:send-report nil)
            (:report-file "/tmp/undercover-report.json"))

(require 'vdirel)

(provide 'test-helper)
;;; test-helper.el ends here
