(defun expand-file-user-directory (filename)
  (expand-file-name filename user-emacs-directory))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(savehist-mode)
(save-place-mode)

(setq display-line-numbers-type 'relative)
(column-number-mode)
(global-display-line-numbers-mode 1)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(set-face-attribute 'default nil :font "Maple Mono NF" :height 120)

(setq visible-bell t)
(setq scroll-margin 8)
(setq scroll-conservatively 101)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default tab-width 4)

(setq savehist-file (expand-file-user-directory "files/history"))
(setq backup-directory-alist `((".*" . ,(expand-file-user-directory "files/backups"))))
(make-directory (expand-file-user-directory "files/autosaves/") t)
(setq auto-save-list-file-prefix (expand-file-user-directory "files/autosaves/sessions/.saves-"))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-user-directory "files/autosaves/") t)))
(setq create-lockfiles nil)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(setq catppuccin-flavor 'macchiato)
(unless (package-installed-p 'catppuccin)
  (message "ctp not installed -> installing")
  (package-install 'catppuccin-theme))
(load-theme 'catppuccin t)


(use-package vertico
  :init (vertico-mode)
  :custom (vertico-cycle t))
(use-package marginalia
  :after vertico
  :init (marginalia-mode))
(use-package orderless
  :custom
  (completion-styles '(orderless basic)))
(use-package consult
  :bind (
	 ("C-x b" . consult-buffer)
	 ("C-x p b" . consult-project-buffer)
	 ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
	 ("M-s f" . consult-fd)
	 ("M-s s" . consult-ripgrep)
         ("M-s l" . consult-line)))
(use-package corfu
    :custom 
             (corfu-auto t)
             (corfu-auto-delay 0.1)
             (corfu-auto-prefix 2)
             :init
             (global-corfu-mode)
             )
(use-package nerd-icons)
(setq nerd-icons-font-family "Maple Mono NF")
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package nerd-icons-dired)
(use-package nerd-icons-completion)
(nerd-icons-completion-mode)
(add-hook 'dired-mode-hook #'nerd-icons-dired-mode)
(load-file (expand-file-user-directory "init/languages.el"))


;; (prefer-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-language-environment 'utf-8)
;; (set-selection-coding-system 'utf-8)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c4df9006b9eb32599d758800a32f3487c2cdf13826084511783b47d419024af2"
     default))
 '(enable-recursive-minibuffers t)
 '(package-selected-packages nil)
 '(package-vc-selected-packages
   '((svelte-ts-mode :url "https://github.com/leafOfTree/svelte-ts-mode")))
 '(read-extended-command-predicate 'command-completion-default-include-p))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
