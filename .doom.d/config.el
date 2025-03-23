;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.


(setq user-full-name "Andrej Golovskis"
      user-mail-address "andrej@golovskis.de")


;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:

(setq doom-font (font-spec :family "Fira Code" :size 24))
(setq doom-theme 'doom-vibrant)

(setq display-line-numbers-type t)
(display-time-mode 1)
(setq display-time-day-and-date t)

;; Start maximalized
(add-hook 'window-setup-hook 'toggle-frame-maximized t)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/Shared/pcloud/bestiary/")
;; (setq org-directory "P:/_en1/journal/")
;; (setq org-directory "~/Shared/pcloud/_en1/journal/")
;; (setq org-roam-directory "P:/_en1/bestiary/")
;; (setq org-directory "~/Shared/pcloud/_en1/journal/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.


(setq org-directory "~/org/")
(setq denote-directory "~/_9ILLI,uK")

;; Auto tangle
(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))


;; Pdf tools config
(use-package pdf-tools
  :defer t
  :commands (pdf-loader-install)
  :mode "\\.pdf\\'"
  :init (pdf-loader-install)
  :config (add-to-list 'revert-without-query ".pdf"))

(add-hook 'pdf-view-mode-hook #' (lambda () (interactive) (display-line-numbers-mode -1)))
