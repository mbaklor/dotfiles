(defun get-from-user-directory (filename)
  (concat user-emacs-directory filename))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(savehist-mode)
;; (set-fringe-mode 10)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(set-face-attribute 'default nil :font "Maple Mono NF" :height 120)

(setq visible-bell t)
(setq scroll-margin 8)
(setq scroll-conservatively 101)

(require 'package)

;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(load (get-from-user-directory "rc.el"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq catppuccin-flavor 'macchiato)
(rc/require-theme 'catppuccin)

(use-package vertico
  :init (vertico-mode))

;; (use-package smex)
;; (use-package ido-completing-read+)
;; (ido-mode)
;; (ido-everywhere)

;; (keymap-global-set "M-x" 'smex)
;; (keymap-global-set "C-c C-c M-x" 'execute-extended-command)

;; (use-package ivy
;;   :diminish
;;   :bind (("C-s" . swiper))
;;   :config
;;   (ivy-mode 1)
;;   (setq ivy-re-builders-alist
;; 	'((swiper . ivy--regex-plus)
;; 	  (t . ivy--regex-fuzzy))
;; 	))
;; (use-package counsel)

(use-package nerd-icons)
(setq nerd-icons-font-family "Maple Mono NF")
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; (prefer-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-language-environment 'utf-8)
;; (set-selection-coding-system 'utf-8)

;; TODO: add golang treesitter, add javascript typescript css html treesitter, auto start eglot
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(use-package svelte-ts-mode
  :vc (:url "https://github.com/leafOfTree/svelte-ts-mode"))
(add-to-list 'treesit-language-source-alist '(svelte "https://github.com/tree-sitter-grammars/tree-sitter-svelte"))

(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-ts-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(catppuccin-theme counsel dash-functional doom-modeline
		      ido-completing-read+ smex svelte-ts-mode vertico))
 '(package-vc-selected-packages
   '((svelte-ts-mode :url "https://github.com/leafOfTree/svelte-ts-mode"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
