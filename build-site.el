;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)
(package-install 'ob-mermaid)
(package-install 'direnv)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />"
      org-publish-use-timestamps-flag t
      org-publish-timestamp-directory "./.org-cache/"
      org-export-with-section-numbers nil
      org-export-use-babel t
      org-export-with-smart-quotes t
      org-export-with-sub-superscripts nil
      org-export-with-tags 'not-in-toc
      org-html-htmlize-output-type 'css
      org-html-prefer-user-labels t
      org-html-link-use-abs-url t
      org-html-link-org-files-as-html t
      org-html-html5-fancy t
      org-html-self-link-headlines t
      org-export-with-toc nil
      make-backup-files nil
      )

(require 'ob-mermaid)
(require 'direnv)

(setq org-confirm-babel-evaluate 'nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (mermaid . t)
   (shell . t)))


(setq my/export-dir (expand-file-name "./public"))

;; (setq org-attach-dir-relative t)
;; (setq org-export-output-directory-prefix 'my/export-dir)
;; (defadvice org-export-output-file-name (before org-add-export-dir activate)
;;   "Modifies org-export to place exported files in a different directory"
;;   (when (not pub-dir)
;;       (setq pub-dir (concat org-export-output-directory-prefix (substring extension 1)))
;;       (when (not (file-directory-p pub-dir))
;;        (make-directory pub-dir))))

;; (defun my/org-babel-tangle-rename ()
;;     (let* ((tangledir my/export-dir)
;;           (tanglefile (buffer-file-name))
;;           (finalfile (concat tangledir "/" (file-name-nondirectory (buffer-file-name))))
;;           )
;;         (rename-file tanglefile finalfile t)))

;; (defun my/run-before-save-hooks ()
;;   (my/org-babel-tangle-rename)
;;   (save-buffer)
;;   )

;; (add-hook 'org-babel-post-tangle-hook 'my/run-before-save-hooks)

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:main"
             :recursive nil
             :base-directory "./content"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public"
             :with-author nil           ;; Don't include author name
             :with-creator nil          ;; Include Emacs and Org versions in footer
             :with-toc nil                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil       ;; Don't include time stamp in file
             :exclude "/.direnv/"
             :auto-sitemap nil
             )
       (list "org-site:posts"
             :recursive t
             :base-directory "./content/posts"
             :publishing-function 'org-html-publish-to-html
             :publishing-directory "./public/posts"
             :with-author nil           ;; Don't include author name
             :with-creator nil          ;; Include Emacs and Org versions in footer
             :with-toc t                ;; Include a table of contents
             :section-numbers nil       ;; Don't include section numbers
             :time-stamp-file nil       ;; Don't include time stamp in file
             :exclude "/.direnv/"
             :auto-sitemap nil
             )
       (list "org-site:static"
        :recursive t
        :base-extension 'any
        :base-directory "./content/"
        :publishing-directory "./public/"
        :exclude "/.direnv/"
        :publishing-function 'org-publish-attachment
        )
       )
      )

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
