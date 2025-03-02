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
(setq doom-font (font-spec :family "Fira Code" :size 16))
(setq doom-theme 'doom-solarized-light)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/Shared/pcloud/bestiary/")
;; (setq org-directory "P:/_en1/journal/")
;; (setq org-directory "~/Shared/pcloud/_en1/journal/")
;; (setq org-roam-directory "P:/_en1/bestiary/")
;; (setq org-directory "~/Shared/pcloud/_en1/journal/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(display-time-mode 1)
(setq display-time-day-and-date t)
;;(setq projectile-project-search-path '("~/Troll/"))
;;

(setq org-agenda-clockreport-parameter-plist
 '(:fileskip0 t :link t :maxlevel 2 :formula "$5=($3+$4)*(60/25);t"))

(setq org-pomodoro-length 50)
(setq org-pomodoro-short-break-length 10)
(setq org-pomodoro-long-break-length 20)


(setq org-books-file (concat org-directory "books.org"))


(use-package! org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
                  :config
                  (setq org-fancy-priorities-list '("MUST" "SHOULD" "COULD")))

(setq  org-deadline-warning-days 93)


(use-package! org-super-agenda
  :after org-agenda
  :config
    (require 'org-habit)
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("c" "Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Quartal"
                                :and (:todo "OUTCOME" :tag "quartal")
                                :order 1)
                           (:name "Sprint"
                                :and (:todo "OUTCOME" :tag "sprint")
                                :order 2)
                            (:name "Weekly"
                                   :and (:todo "OUTCOME" :tag "weekly")
                                   :order 3)
                            (:name "Daily"
                                   :and (:todo "OUTCOME" :tag "daily")
                                   :order 4)
                            (:name "Habits"
                                  :habit t
                                  :order 5)
                             (:name "Today"
                                  :time-grid t
                                  :date today
                                  :order 5)
                            (:name "Reading"
                                   :todo "READING"
                                   :order 6)
                            ))))
            ))))
  :config
  (org-super-agenda-mode))

;; (setq org-roam-graph-executable "C:/Program Files (x86)/Graphviz2.38/bin/dot.exe")


(after! org
  (setq org-todo-keywords '((sequence "TODO(t)" "OUTCOME(o)" "INPROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)" "FAILED(f)")))
  )


(after! org
  (setq org-capture-templates
      `(("t" "Task" entry (file+headline, (concat org-directory "inbox.org"), "Task")
         "* TODO %?")
        ("n" "Note" entry (file+headline, (concat org-directory "inbox.org"), "Notes")
         "* %?")
        )))

(after! org
  (setq org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-targets '(("next.org" :level . 0)
                             ("someday.org" :level . 0)
                             ("projects.org" :maxlevel . 1)))
)

;; ^(after! add-hook 'after-init-hook 'org-roam-mode)
