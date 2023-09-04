;;; vdirel-ivy.el --- Manipulate vdir (i.e., vCard) repositories

;; Copyright (C) 2015-2018 Damien Cassou

;; Author: Damien Cassou <damien@cassou.me>
;; Version: 0.2.0
;; Url: https://github.com/DamienCassou/vdirel
;; Package-Requires: ((vdirel "0.2.0") (ivy "1.0.0"))
;; Created: 09 Dec 2015

;; This file is not part of GNU Emacs.

;;; License:
;;
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:

;; ivy interface for manipulating vdir (i.e., vCard) collections from Emacs

;;; Code:
(require 'vdirel)
(require 'ivy)

(defun vdirel-ivy--insert-contact-email (contact)
  "Print selected CONTACT with a comma."
  (with-ivy-window
   (insert
    (format " %s, " (car contact)))))

;;;###autoload
(defun vdirel-ivy-select-email (&optional refresh repository)
  "Select email address and optionally `REFRESH' the `REPOSITORY'."
  (interactive)
  (vdirel--ensure-cache-ready refresh repository)
  (ivy-read "Contacts: "
            (vdirel--email-candidates (vdirel--cache-contacts repository))
            :require-match t
            :action '(1
                      ("i" vdirel-ivy--insert-contact-email))))

(provide 'vdirel-ivy)

;;; vdirel-ivy.el ends here
