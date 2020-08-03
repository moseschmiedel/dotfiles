(setq user-full-name "Mose Schmiedel")
(setq user-mail-address "mose.schmiedel@web.de")


(set-default-font "Iosevka Term SS14-11")

;; disable menubar and toolbar
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Ask "y" or "n" instead of "yes" or "no". Yes, laziness is great.
(fset 'yes-or-no-p 'y-or-n-p)

;; Highlight corresponding parentheses when cursor is on one
(show-paren-mode t)

;; Highlight tabulations
(setq-default highlight-tabs t)

;; Show trailing white spaces
(setq-default show-trailing-whitespace t)

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

;; Save backup files in a dedicated directory
(setq backup-directory-alist '(("." . "~/.saves")))

(require 'mu4e)
(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-maildir "~/mail")
(setq mu4e-drafts-folder "/web/Drafts")
(setq mu4e-sent-folder "/web/Sent")
(setq mu4e-trash-folder "/web/Trash")

(setq mu4e-maildir-shortcuts
      '( ("/web/INBOX" . ?i)
	 ("/web/Sent" . ?s)
	 ("/web/Trash" . ?t)))

(setq mu4e-get-mail-command "offlineimap")

(setq
 message-signature
 (concat
  "Mose Schmiedel\n"
  "Email: mose.schmiedel@web.de\n"))

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-stream-type 'starttls
      smtpmail-default-smtp-server "smtp.web.de"
      smtpmail-smtp-server "smtp.web.de"
      smtpmail-smtp-service 587)

(setq message-kill-buffer-on-exit t)


;; Set locale to UTF8
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

;; https://github.com/jwiegley/use-package
(require 'use-package)


;; https://www.emacswiki.org/emacs/UndoTree
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

;; https://github.com/emacs-evil/evil
(use-package evil
  :after undo-tree
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil))

;; https://github.com/emacs-evil/evil-collection
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(defun open-config ()
    (interactive)
  (find-file "~/.emacs.d/init.el"))

;; https://github.com/noctuid/general.el
(use-package general
  :ensure t
  :config
  (general-create-definer my-leader-def
    :prefix "SPC")
  (my-leader-def
    :states 'normal
    :keymaps 'override
    "e" 'find-file
    "b" 'switch-to-buffer
    "k" 'kill-buffer
    "x" 'eval-buffer
    "c" 'open-config
    "a" 'org-agenda)
)

(evil-mode 1)

;; https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

;; https://github.com/linktohack/evil-commentary
(use-package evil-commentary
  :ensure t
  :init
  (evil-commentary-mode))

;; https://github.com/redguardtoo/evil-nerd-commenter
(use-package evil-nerd-commenter
  :ensure evil-nerd-commenter
  :config
  (evilnc-default-hotkeys nil t))

;; https://magit.vc
(use-package magit
  :ensure t)

;; https://github.com/magit/forge
(use-package forge
  :ensure t
  :after magit)

;; https://github.com/dgutov/diff-hl
(use-package diff-hl
  :ensure t
  :hook
  ((magit-pre-refresh . diff-hl-magit-pre-refresh)
  (magit-post-refresh . diff-hl-magit-post-refresh)))

;; https://github.com/auto-complete/popup-el
(use-package popup
  :ensure t)

;; https://github.com/emacsorphanage/git-messenger
(use-package git-messenger
  :ensure t
  :after popup)

;; https://github.com/emacs-helm/helm
;; config from https://github.com/thierryvolpiatto/emacs-tv-config/blob/master/init-helm.el
(use-package helm-mode
  :config
  (helm-mode 1))

(use-package base16-theme
  :ensure nil
  :load-path "site-lisp/emacs"
  :init
  (add-to-list 'custom-theme-load-path "~/.emacs.d/site-lisp/emacs/build")
  :config
  (load-theme 'base16-snazzy-with-sweet t)
  (set-background-color "#1a1e21")
  )

;; Set the cursor color based on the evil state
(defvar my/base16-colors base16-snazzy-with-sweet-colors)
(setq evil-emacs-state-cursor   `(,(plist-get my/base16-colors :base0D) box)
      evil-insert-state-cursor  `(,(plist-get my/base16-colors :base0D) bar)
      evil-motion-state-cursor  `(,(plist-get my/base16-colors :base0E) box)
      evil-normal-state-cursor  `(,(plist-get my/base16-colors :base0B) box)
      evil-replace-state-cursor `(,(plist-get my/base16-colors :base08) bar)
      evil-visual-state-cursor  `(,(plist-get my/base16-colors :base09) box))
;; https://github.com/hlissner/emacs-doom-themes
;; (use-package doom-themes
;;   :ensure t
;;   :config
;;   ;; Global settings (defaults)
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;	doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   (load-theme 'doom-snazzy t)

;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)

;;   ;; Enable custom neotree theme (all-the-icons must be installed!)
;;   (doom-themes-neotree-config)
;;   ;; or for treemacs users
;;   (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
;;   (doom-themes-treemacs-config)

;;   ;; Corrects (and improves) org-mode's native fontification.
;;   (doom-themes-org-config))

;; https://github.com/seagle0128/doom-modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-modal-icon t))

;; https://github.com/domtronn/all-the-icons.el
(use-package all-the-icons
  :ensure t)

;; https://github.com/ema2159/centaur-tabs
(use-package centaur-tabs
  :ensure t
  :config
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-style "chamfer")
  (setq centaur-tabs-gray-out-icons 'buffer)
  (setq centaur-tabs-set-bar 'over)
  (setq centaur-tabs-set-modified-marker t)
  (centaur-tabs-group-by-projectile-project)
  :hook
  (which-key-mode . centaur-tabs-local-mode)
  :bind
  (:map evil-normal-state-map
	     ("g t" . centaur-tabs-forward)
	     ("g T" . centaur-tabs-backward)))

(centaur-tabs-mode)

(defun centaur-tabs-hide-tab (x)
    (let ((name (format "%s" x)))
	(or
	(string-prefix-p "*epc" name)
	(string-prefix-p "*helm" name)
	(string-prefix-p "*Helm" name)
	(string-prefix-p "*Compile-Log*" name)
	(string-prefix-p "*lsp" name)
	(string-prefix-p "*which" name)
	(and (string-prefix-p "magit" name)
	    (not (file-name-extension name))))))

;; https://github.com/purcell/page-break-lines
(use-package page-break-lines
  :ensure t)

;; https://github.com/bbatsov/projectile
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-project-search-path '("/media/devel"))
  (setq projectile-sort-order 'recentf)
  (setq projectile-switch-project-action #'projectile-dired)
  (setq projectile-completion-system 'helm))

;; https://github.com/emacs-dashboard/emacs-dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-banner-logo-title "Welcome back Mose!")
  (setq dashboard-startup-banner "/home/mose/.emacs.d/banner.png")
  (setq dashboard-items '((recents  . 5)
			(projects . 5)
			(bookmarks . 5)
			(agenda . 5)))
  (setq dashboard-center-content t))

(use-package frame-local
  :ensure t)

;; https://github.com/jtbm37/all-the-icons-dired
(use-package all-the-icons-dired
  :ensure t
  :hook
  (dired-mode . all-the-icons-dired-mode))

;; open file/directory without creating a new buffer
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))

;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

;; https://company-mode.github.io
(use-package company
  :ensure t
  :hook
  (after-init . global-company-mode)
  :bind
  ("C-SPC" . company-complete))

;; https://www.emacswiki.org/emacs/Yasnippet
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :ensure t)

;; https://elpa.gnu.org/packages/rainbow-mode.html
(use-package rainbow-mode
  :ensure t)

;; https://github.com/nschum/highlight-symbol.el
(use-package highlight-symbol
  :ensure t
  :config
  (global-set-key [(control f3)] 'highlight-symbol)
  (global-set-key [f3] 'highlight-symbol-next)
  (global-set-key [(shift f3)] 'highlight-symbol-prev)
  (global-set-key [(meta f3)] 'highlight-symbol-query-replace))

;; https://github.com/gregsexton/origami.el
(use-package origami
  :ensure t)

;; https://github.com/zk-phi/indent-guide
(use-package indent-guide
  :ensure t
  :config
  (indent-guide-global-mode)
  (set-face-foreground 'indent-guide-face "dimgray")
  (setq indent-guide-char ">"))

;; https://github.com/benma/visual-regexp.el
(use-package visual-regexp
  :ensure t)

(use-package evil-easymotion
  :ensure t
  :config
  (evilem-default-keybindings "g s"))

;; https://github.com/Fuco1/smartparens
(use-package smartparens
  :ensure t
  :hook
  (js-mode . smartparens-mode)
  (perl-mode . smartparens-mode)
  (c-mode . smartparens-mode)
  (TeX-mode . smartparens-mode)
  (haskell-mode . smartparens-mode))

;; https://github.com/cdominik/cdlatex
;; (use-package cdlatex
;;   :ensure t
;;   :config
;;   :hook
;;   (LaTeX-mode . cdlatex-mode))

;; https://github.com/haskell/haskell-mode
(use-package haskell-mode
  :ensure t)

(use-package raku-mode
  :defer t
  :ensure t)

(use-package cperl-mode
  :ensure t)

(use-package rust-mode
  :ensure t)

;; https://www.gnu.org/software/auctex/manual/auctex.html
(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-electric-sub-and-superscript t))

;; https://github.com/politza/pdf-tools
(use-package pdf-tools
  :ensure t)

;; https://www.emacswiki.org/emacs/LaTeXPreviewPane
(use-package latex-preview-pane
  :ensure t
  :config
  (latex-preview-pane-enable))

;; http://web-mode.org/
(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html.ep\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.svelte?\\'" . web-mode))
  )

(use-package php-mode
  :ensure t)


;; https://www.emacswiki.org/emacs/YamlMode
(use-package yaml-mode
  :ensure t)

(use-package circe
  :ensure t)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
	  treemacs-deferred-git-apply-delay      0.5
	  treemacs-directory-name-transformer    #'identity
	  treemacs-display-in-side-window        t
	  treemacs-eldoc-display                 t
	  treemacs-file-event-delay              5000
	  treemacs-file-extension-regex          treemacs-last-period-regex-value
	  treemacs-file-follow-delay             0.2
	  treemacs-file-name-transformer         #'identity
	  treemacs-follow-after-init             t
	  treemacs-git-command-pipe              ""
	  treemacs-goto-tag-strategy             'refetch-index
	  treemacs-indentation                   2
	  treemacs-indentation-string            " "
	  treemacs-is-never-other-window         nil
	  treemacs-max-git-entries               5000
	  treemacs-missing-project-action        'ask
	  treemacs-move-forward-on-expand        nil
	  treemacs-no-png-images                 nil
	  treemacs-no-delete-other-windows       t
	  treemacs-project-follow-cleanup        nil
	  treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
	  treemacs-position                      'left
	  treemacs-recenter-distance             0.1
	  treemacs-recenter-after-file-follow    nil
	  treemacs-recenter-after-tag-follow     nil
	  treemacs-recenter-after-project-jump   'always
	  treemacs-recenter-after-project-expand 'on-distance
	  treemacs-show-cursor                   nil
	  treemacs-show-hidden-files             t
	  treemacs-silent-filewatch              nil
	  treemacs-silent-refresh                nil
	  treemacs-sorting                       'alphabetic-asc
	  treemacs-space-between-root-nodes      t
	  treemacs-tag-follow-cleanup            t
	  treemacs-tag-follow-delay              1.5
	  treemacs-user-mode-line-format         nil
	  treemacs-user-header-line-format       nil
	  treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
		 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
	("M-0"       . treemacs-select-window)
	("C-x t 1"   . treemacs-delete-other-windows)
	("<f8>"   . treemacs)
	("C-x t B"   . treemacs-bookmark)
	("C-x t C-t" . treemacs-find-file)
	("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treeemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package fill-column-indicator
  :ensure t
  :config
  (setq fci-rule-width 4)
  (setq fci-rule-color "#C44E4E")
  )

(define-globalized-minor-mode global-fci-mode fci-mode
(lambda ()
    (if (and
	(not (string-match "^\*.*\*$" (buffer-name)))
	(not (eq major-mode 'dired-mode))
	(not (eq major-mode 'org-mode)))
	(fci-mode 1))))
(global-fci-mode 1)

(global-linum-mode)

;;** Org Mode
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
(setq org-hide-emphasis-markers t)

(font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			   (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; (let* ((variable-tuple
;;	(cond ((x-list-fonts "Iosevka")         '(:font "Iosevka"))
;;	      ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;	      ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;	      ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;	      ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;	      (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;        (base-font-color     (face-foreground 'default nil 'default))
;;        (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

;;   (custom-theme-set-faces
;;    'user
;;    `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;    `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
;;    `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
;;    `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
;;    `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
;;    `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

(use-package htmlize
  :ensure t)

(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "Iosevka SS14" :height 110))))
 '(fixed-pitch ((t (:family "Iosevka Term SS14" :height 110)))))

(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'org-mode-hook 'visual-line-mode)

(custom-theme-set-faces
 'user
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "Zathura"))))
 '(helm-completion-style (quote emacs))
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(org-agenda-files (quote ("/media/devel/jarvis/jarvis-todo.org")))
 '(package-selected-packages
   (quote
    (htmlize fill-column-indicator rust-mode dockerfile-mode base16-theme helm-mode raku-mode treemacs-icons-dired treemacs-magit treemacs-icon-dired treemacs-projectile circe php-mode evil-commentary evil-easymotion cdlatex which-key evil-leader yasnippet-snippets all-the-icons-dired yaml-mode visual-regexp yasnippet indent-guide origami highlight-symbol rainbow-mode web-mode pdf-tools latex-preview-pane multiple-cursors auctex haskell-mode frame-local ov dash-functional sublimity doom-themes powerline-evil git-messenger diff-hl forge use-package projectile magit helm evil-nerd-commenter evil-collection dashboard company centaur-tabs all-the-icons)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Iosevka Term SS14" :foundry "BE5N" :slant normal :weight normal :height 112 :width normal))))
 '(fixed-pitch ((t (:family "Iosevka Term SS14" :height 110))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-info ((t (:foreground "dark orange"))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
 '(org-link ((t (:foreground "royal blue" :underline t))))
 '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
 '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch)))))
 '(variable-pitch ((t (:family "Iosevka SS14" :height 110)))))
