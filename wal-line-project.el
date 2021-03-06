;;; wal-line-project.el --- Indicate project -*- lexical-binding: t; -*-

;; Author: Krister Schuchardt <krister.schuchardt@gmail.com>
;; Homepage: https://github.com/Walheimat/wal-line
;; Version: 0.2.0
;; Package-Requires: ((emacs "28.1"))
;; Keywords: faces mode-line

;;; Commentary:

;; Show project information using `project' or `projectile'.

;;; Code:

(require 'projectile nil t)
(require 'wal-line)

(declare-function wal-line--spacer "wal-line.el")
(declare-function project-root "ext:project.el")

;;;; Customization:

(defcustom wal-line-project-provider
  (if (bound-and-true-p projectile-mode)
      'projectile
    'project)
  "The project provider."
  :group 'wal-line
  :type '(choice (const projectile)
                 (const project)))

;;;; Functionality:

(defvar wal-line-project--regexp ".+\\(\\/.+\\)\\/$")

(defun wal-line-project--segment ()
  "Get the project or root segment."
  (let ((p-root (cond
                 ((eq wal-line-project-provider 'projectile)
                  (projectile-project-root))
                 ((eq wal-line-project-provider 'project)
                  (project-root (project-current)))
                 (t nil))))
    (if (and p-root
             (buffer-file-name)
             (string-match-p wal-line-project--regexp p-root))
        (progn
          (string-match wal-line-project--regexp p-root)
          (concat
           (wal-line--spacer)
           (propertize (substring (match-string 1 p-root) 1) 'face 'wal-line-emphasis)))
      "")))

(defvar wal-line--segments)
(wal-line-add-segment project)

(provide 'wal-line-project)

;;; wal-line-project.el ends here
