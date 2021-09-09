;; .emacs

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(diff-switches "-u")
 '(require-final-newline t)
 '(temporary-file-directory "/zfs1/walsaidi/djb184/tmp_emacs/"))

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

(setq column-number-mode t)   
(global-linum-mode t)                                                   
(ido-mode t)
(setq linum-format "%d ")
(setq inhibit-startup-message t)

;; Don't clutter up directories with files~
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
;; Don't clutter with #files either
(setq auto-save-file-name-transforms
                `((".*" ,temporary-file-directory t)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
