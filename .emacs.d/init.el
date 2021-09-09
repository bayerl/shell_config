(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    elpy
    flycheck
    py-autopep8
    magit
    cyberpunk-theme
    )
  )

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

(load-theme 'cyberpunk t)       
(global-linum-mode t)
(ido-mode t)
(setq linum-format "%d ")
(setq inhibit-startup-message t)
(setq column-number-mode t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)


;; Don't clutter up directories with files~
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
;; Don't clutter with #files either
(setq auto-save-file-name-transforms
                `((".*" ,temporary-file-directory t)))


;; ============================
;; DEVELOPMENT SETUP
;; ============================
(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
  ;; (add-hook 'elpy-mode-hook 'flycheck-mode)
  ;; (add-hook 'flycheck-mode-hook #'flycheck-virtualenv-setup))


(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(setenv "WORKON_HOME" "/home/db/venv")
(setq elpy-rpc-virtualenv-path 'current)
;; (setq elpy-rpc-virtualenv-path 'default)
;; (setq elpy-rpc-python-command "/usr/bin/python3")
;; (setq python-shell-interpreter "/usr/bin/python3"
;;       python-shell-interpreter-args "-i")


;; ====================================
;; Org Mode Setup
;; ====================================
(require 'org)
;; Make Org mode work with files ending in .org
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))


;; ====================================
;; Custom aliases
;; ====================================
(defalias 'act 'pyvenv-workon)


;; ====================================
;; Configure window management
;; ====================================
;; (setq split-height-threshold 200)
;; (setq split-width-threshold 0)
(defun adjust-window-split-thresholds nil 
  "Adjust split thresholds so that popup windows always split vertically in a tall frame, horizontally in a wide frame, with a maximum of two columns"
  (interactive)
  (if (>= (frame-pixel-width) (frame-pixel-height))
      ; wide frame
      (progn
        (setq split-height-threshold (frame-height))
        (setq split-width-threshold  (/ (frame-width) 2))
        )
      ; tall frame
      (progn
        (setq split-height-threshold (frame-height))
        (setq split-width-threshold  (frame-width))
        ))
  )
(add-hook 'window-configuration-change-hook 'adjust-window-split-thresholds)
;; (remove-hook 'window-configuration-change-hook 'adjust-window-split-thresholds)


(defun toggle-frame-split ()
  "If the frame is split vertically, split it horizontally or vice versa. Assumes that the frame is only split into two."
  (interactive)
  (unless (= (length (window-list)) 2) (error "Can only toggle a frame split in two"))
  (let ((split-vertically-p (window-combined-p)))
    (delete-window) ; closes current window
    (if split-vertically-p
        (split-window-horizontally)
      (split-window-vertically)) ; gives us a split with the other window twice
    (switch-to-buffer nil))) ; restore the original window in this part of the frame

;; I don't use the default binding of 'C-x 5', so use toggle-frame-split instead
(global-set-key (kbd "C-x 5") 'toggle-frame-split)

;;---TRY IF THE ABOVE SCREWS UP BUFFERS----
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))
(global-set-key (kbd "C-x |") 'toggle-window-split)
;; (define-key ctl-x-4-map "t" 'toggle-window-split)


;; ====================================
;; Emacs daemon
;; ====================================
;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )


;; ==============================
;; END USER-DEFINED INIT.EL 
;; ==============================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-idle-delay 0.01)
 '(ido-ignore-buffers (quote ("^magit" "\\` ")))
 '(package-selected-packages
   (quote
    (whitespace-cleanup-mode ess auctex cyberpunk-theme magit py-autopep8 flycheck elpy better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
