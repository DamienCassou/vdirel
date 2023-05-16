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

(when (require 'undercover nil t)
  (undercover "*.el"))

(require 'vdirel)

(describe "vdirel"
  (describe "knows how to extract a contact's fullname"
    (it "when defined through N"
      (expect (vdirel-contact-fullname '(("N" . "Damien;Cassou")
                                         ("EMAIL" . "me@foo.bar")))
              :to-equal "Damien Cassou"))

    (it "when defined through FN"
      (expect (vdirel-contact-fullname '(("FN" . "Damien Cassou")
                                         ("EMAIL" . "me@foo.bar")))
              :to-equal "Damien Cassou"))

    (it "when missing, shows email"
      (expect (vdirel-contact-fullname '(("EMAIL" . "foo@bar.com")))
              :to-equal "foo@bar.com")))

  (describe "contact-property"
    (it "returns entry if property is found"
      (expect (vdirel--contact-property "FN" '(("FN" . "Damien Cassou")))
              :to-equal "Damien Cassou"))

    (it "returns nil if property is not found"
      (expect (vdirel--contact-property "ZZ" '(("FN" . "Damien Cassou")))
              :to-be nil)))

  (describe "contact-properties"
    (it "returns 1 element if 1 found"
      (expect (vdirel--contact-properties "FN" '(("FN" . "Damien Cassou")))
              :to-equal '("Damien Cassou")))

    (it "returns several elements if several found"
      (expect (vdirel--contact-properties "FN"
                                          '(("FN" . "Damien")
                                            ("FN" . "Cassou")))
              :to-equal '("Damien" "Cassou")))

    (it "returns nil if none found"
      (expect (vdirel--contact-properties "ZZ" '(("FN" . "Damien Cassou")))
              :to-equal nil)))

  (describe "contact-emails"
    (it "find every emails"
      (expect (vdirel-contact-emails
               '(("EMAIL" . "me@foo.com")
                 ("EMAIL;TYPE=home" . "me@bar.eu")))
              :to-equal '("me@foo.com" "me@bar.eu"))))

  (describe "email-candidates"
    (it "list all emails of a contact"
      (expect (vdirel--email-candidates
               '((("FN" . "Damien Cassou")
                  ("EMAIL" . "me@foo.com")
                  ("EMAIL;TYPE=home" . "me@bar.eu"))))
              :to-equal
              '(("Damien Cassou <me@foo.com>" . ("Damien Cassou" "me@foo.com"))
                ("Damien Cassou <me@bar.eu>" . ("Damien Cassou" "me@bar.eu")))))))

(provide 'vdirel-test)

;;; vdirel-test.el ends here
