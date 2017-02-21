;;; vdirel-tests.el --- Tests for vdirel.el

;; Copyright (C) 2013 Damien Cassou

;; Author: Damien Cassou <damien@cassou.me>

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

;; Tests for vdirel.el

;;; Code:

(require 'ert)
(require 'test-helper)

(ert-deftest vdirel-shouldUseFForFullnameWhenFNAbsent ()
  (should (string= "Damien Cassou"
                   (vdirel-contact-fullname '(("N" . "Damien;Cassou"))))))

(ert-deftest vdirel-shouldUseFNForFullnameWhenPresent ()
  (should (string= "Damien Cassou"
                   (vdirel-contact-fullname '(("FN" . "Damien Cassou"))))))

(ert-deftest vdirel-contactPropertyShouldReturnValueIfFound ()
  (should (equal
           "Damien Cassou"
           (vdirel--contact-property "FN"
                                     '(("FN" . "Damien Cassou"))))))

(ert-deftest vdirel-contactPropertyShouldReturnNilIfNotFound ()
  (should (null
           (vdirel--contact-property "ZZ"
                                     '(("FN" . "Damien Cassou"))))))

(ert-deftest vdirel-contactPropertiesShouldReturn1ElementIfFound ()
  (should (equal
           '("Damien Cassou")
           (vdirel--contact-properties "FN"
                                       '(("FN" . "Damien Cassou"))))))

(ert-deftest vdirel-contactPropertiesShouldReturnElementsIfFound ()
  (should (equal
           '("Damien" "Cassou")
           (vdirel--contact-properties "FN"
                                       '(("FN" . "Damien")
                                         ("FN" . "Cassou"))))))

(ert-deftest vdirel-contactPropertiesShouldReturnEmptyIfNotFound ()
  (should (null
           (vdirel--contact-properties "ZZ"
                                       '(("FN" . "Damien Cassou"))))))

(ert-deftest vdirel-contact-emails-find-every-emails ()
  (should (equal
           '("me@foo.com" "me@bar.eu")
           (vdirel-contact-emails
            '(("EMAIL" . "me@foo.com")
              ("EMAIL;TYPE=home" . "me@bar.eu"))))))

(ert-deftest vdirel--helm-email-candidates ()
  (should
   (equal
    '(("Damien Cassou <me@foo.com>" . ("Damien Cassou" "me@foo.com"))
      ("Damien Cassou <me@bar.eu>" . ("Damien Cassou" "me@bar.eu")))
    (vdirel--helm-email-candidates
     '((("FN" . "Damien Cassou")
        ("EMAIL" . "me@foo.com")
        ("EMAIL;TYPE=home" . "me@bar.eu")))))))

(provide 'vdirel-tests)
;;; vdirel-tests.el ends here
