;;; ob-q.el --- Babel Functions for q      -*- lexical-binding: t; -*-

;; Copyright (c) 2016 Abhinav Tushar

;; Author: Abhinav Tushar <abhinav.tushar.vs@gmail.com>
;; Version: 0.2
;; Keywords: csv, sql
;; URL: https://github.com/lepisma/ob-q.el

;;; Commentary:

;; ob-q.el provides simple block execution of q commands in org-mode
;; This file is not a part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Code:
(require 'ob)

(defvar org-babel-default-header-args:q
  '((:results . "output"))
  "Default arguments to use when evaluating a q source block.")

(defun org-babel-q-interpolate (body csv)
  "Return text with $csv replaced."
  (replace-regexp-in-string (regexp-quote "$csv")
                            csv
                            body nil 'literal))

(defun org-babel-execute:q (body params)
  "Execute a block of q command with org-babel. This function is
called by `org-babel-execute-src-block'."
  (message "executing q source code block")
  (let ((csv (cdr (assq :csv params)))
        (delim (cdr (assq :delim params)))
        (out-file (org-babel-temp-file "q-output-")))
    (with-output-to-string
      (shell-command (concat "q -H -d ,"
                            " \""
                            (org-babel-q-interpolate body csv)
                            "\" > " (org-babel-process-file-name out-file))))
    (with-temp-buffer (insert-file-contents out-file) (buffer-string))))

(defun org-babel-prep-session:q (_session _params)
  (error "q does not support sessions"))

(provide 'ob-q)

;;; ob-q.el ends here
