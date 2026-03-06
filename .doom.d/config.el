;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.s

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

(setq doom-font (font-spec :family "Fira Code" :size 36))
(setq doom-theme 'doom-horizon)

(setq display-line-numbers-type t)
(display-time-mode 1)
(setq display-time-day-and-date t)

;; Start maximalized
(add-hook 'window-setup-hook 'toggle-frame-maximized t)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


(setq org-directory "~/Data/20_kontur")
(setq denote-directory "~/Data/20_kontur")

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

;; Use eshell for opening a terminal window
(map! :leader
      :desc "Toggle Eshell popup"
      "o t" #'+eshell/toggle)

;; Human readable dired size 
(setq dired-listing-switches "-alh")
(setq dired-human-readable t)
