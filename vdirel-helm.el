;;; vdirel-helm.el --- Manipulate vdir (i.e., vCard) repositories

;; Copyright (C) 2015-2018 Damien Cassou

;; Author: Damien Cassou <damien@cassou.me>
;; Version: 0.2.0
;; Url: https://github.com/DamienCassou/vdirel
;; Package-Requires: ((vdirel "0.2.0") (helm "1.7.0"))
;; Created: 09 Dec 2015

;; This file is not part of GNU Emacs.

;;; License:
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; helm interface for manipulating vdir (i.e., vCard) collections from Emacs

;;; Code:
(require 'vdirel)
(require 'helm)

(defun vdirel-helm--open-file (candidate)
  "Open files associated with selected contacts.
CANDIDATE is ignored."
  (ignore candidate)
  (mapcar (lambda (entry) (find-file (caddr entry))) (helm-marked-candidates)))

(defun vdirel-helm--insert-contact-email (candidate)
  "Print selected contacts as comma-separated text.
CANDIDATE is ignored."
  (ignore candidate)
  (insert (mapconcat (lambda (pair)
                       (format "\"%s\" <%s>"
                               (car pair)
                               (cadr pair)))
                     (helm-marked-candidates)
                     ", ")))

;;;###autoload
(defun vdirel-helm-select-email (&optional refresh repository)
  "Select email address and optionally `REFRESH' the `REPOSITORY'."
  (interactive
   (list (cond ((equal '(16) current-prefix-arg) 'server)
               ((consp current-prefix-arg) 'cache))
         (vdirel--repository)))
  (vdirel--ensure-cache-ready refresh repository)
  (helm
   :prompt "Contacts: "
   :sources
   (helm-build-sync-source "Contacts"
                           :candidates (vdirel--email-candidates (vdirel--cache-contacts repository))
                           :action (helm-make-actions
                                    "Insert" #'vdirel-helm--insert-contact-email
                                    "Open file" #'vdirel-helm--open-file))))

(provide 'vdirel-helm)

;;; vdirel-helm.el ends here
