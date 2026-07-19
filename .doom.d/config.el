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

(require 'acp)
(require 'agent-shell)

(setq doom-font (font-spec :family "Fira Code" :size 36))
(setq doom-theme 'doom-sourcerer)

(setq display-line-numbers-type t)
(display-time-mode 1)
(setq display-time-day-and-date t)

;; Start maximalized
(add-hook 'window-setup-hook 'toggle-frame-maximized t)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


(setq org-directory "~/Data/base/20_notes/21_kontur")
(setq denote-directory "~/Data/base/20_notes/21_kontur")

;(desktop-save-mode 1)

;; Dired
(after! dired
  (setq dired-auto-revert-buffer nil))
(setq directory-free-space-program nil)

;; Auto tangle
(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(after! org
  (require 'org-xopp)
  (org-xopp-setup))

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


;; Katalog
;; Katalog path for eshell
(push (expand-file-name "~/.local/bin") exec-path)
(setenv "PATH" (concat (expand-file-name "~/.local/bin") ":" (getenv "PATH")))

;; Katalog - document management
(defvar katalog-inbox "~/Data/base/00_inbox/docs/")
(defvar katalog-catalog "~/Data/base/30_docs/")

(defun katalog-import ()
  (interactive)
  (compile (format "%s %s" (expand-file-name "~/.local/bin/katalog") katalog-inbox)))

(defun katalog-inbox ()
  (interactive)
  (dired katalog-inbox))

(defun katalog-catalog ()
  (interactive)
  (dired katalog-catalog))

(defun katalog-move-to-inbox ()
  (interactive)
  (let ((files (dired-get-marked-files nil nil nil t))
        (dest (expand-file-name katalog-inbox)))
    (dolist (file files)
      (rename-file file
                   (expand-file-name (file-name-nondirectory file) dest)
                   t))
    (message "Moved %d file(s) to %s" (length files) dest)))

(defun katalog-search ()
  "Search catalog contents with Consult Recoll."
  (interactive)
  (let ((result
         (catch 'katalog-recoll-export
           (minibuffer-with-setup-hook
               (lambda ()
                 (local-set-key (kbd "C-c C-o") #'katalog-recoll-to-dired))
             (consult-recoll nil)))))
    (when (and (consp result) (eq (car result) 'dired))
      (katalog-recoll-open-dired (cdr result)))))

(use-package! consult-recoll
  :commands consult-recoll
  :config
  (setq consult-recoll-inline-snippets t)
  

  ;; Filter results to PDFs only (use .txt sidecars for matching, not display)
  (defun katalog-recoll-filter-pdf (orig-fn str)
    "Skip non-PDF results from recollq."
    (if (and (string-match consult-recoll--line-rx str)
             (not (string= (match-string 1 str) "application/pdf")))
        nil
      (funcall orig-fn str)))
  (advice-add 'consult-recoll--transformer :around #'katalog-recoll-filter-pdf)

  (defun katalog-recoll-open-dired (files)
    "Open FILES in Dired."
    (let ((default-directory (expand-file-name katalog-catalog)))
      (if files
          (dired (cons default-directory files))
        (message "No matching PDFs"))))

  (defun katalog-recoll-to-dired ()
    "Exit Consult and open all matching PDFs in Dired."
    (interactive)
    (let ((files
           (delete-dups
            (delq nil
                  (mapcar (lambda (candidate)
                            (let ((path (get-text-property 0 'url candidate)))
                              (and path
                                   (string-suffix-p ".pdf" path)
                                   (file-exists-p path)
                                   path)))
                          (all-completions ""
                                           minibuffer-completion-table
                                           minibuffer-completion-predicate))))))
      (throw 'katalog-recoll-export (cons 'dired files))))

  (after! embark
    (consult-recoll-embark-setup)))

(map! :leader
      (:prefix ("k" . "katalog")
       :desc "Import documents" "i" #'katalog-import
       :desc "Open inbox" "I" #'katalog-inbox
       :desc "Open catalog" "k" #'katalog-catalog
       :desc "Move marked files to inbox" "c" #'katalog-move-to-inbox
       :desc "Search documents" "s" #'katalog-search))

(map! :after dired
      :map dired-mode-map
      :prefix ("k" . "katalog")
      :desc "Move to inbox" "i" #'katalog-move-to-inbox)



;; Agent shell 
;; Make OpenCode visible to Emacs, Eshell and subprocesses.
(let ((opencode-dir (expand-file-name "~/.opencode/bin")))
  (add-to-list 'exec-path opencode-dir)
  (setenv "PATH"
          (concat opencode-dir path-separator (getenv "PATH"))))



  ;; Let OpenCode inherit HOME, PATH and the rest of Emacs's environment.
 ;; (setq agent-shell-opencode-environment
   ;;     (agent-shell-make-environment-variables :inherit-env t)))

(after! agent-shell
  (setq agent-shell-header-style 'text
        agent-shell-show-welcome-message t))

;; Gptel config

(use-package! gptel
  :config
  (setq gptel-openai-oauth-login-method 'device
        gptel-backend
        (gptel-make-openai-oauth "ChatGPT Subscription")
        gptel-model 'gpt-5.5))
