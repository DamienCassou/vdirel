;;; vdirel-helm.el --- Manipulate vdir (i.e., vCard) repositories

;; Copyright (C) 2015-2018 Damien Cassou

;; Author: Damien Cassou <damien@cassou.me>
;; Version: 0.2.0
;; Url: https://github.com/DamienCassou/vdirel
;; Package-Requires: ((emacs "24.4") (org-vcard "0.1.0") (helm "1.7.0") (seq "1.11"))
;; Created: 09 Dec 2015

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Manipulate vdir (i.e., vCard) repositories from Emacs

;;; Code:
(require 'vdirel)
(require 'helm)

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
  "Let user choose an email address from (REFRESH'ed) REPOSITORY."
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
              "Insert" #'vdirel--helm-insert-contact-email
              "Open file" #'vdirel--open-file))))

(provide 'vdirel-helm)

;;; vdirel-helm.el ends here

;;  LocalWords:  vCard alist vdirsyncer