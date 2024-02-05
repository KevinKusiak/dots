
;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/org-babel-tangle-config ()
  "Automatically tangle our Emacs.org config file when we save it. Credit to Emacs From Scratch for this one!"
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(require 'use-package-ensure) ;; This line is currenly needed, there is a bug with always-ensure, it doesn't get loaded if we just setq t
(setq use-package-always-ensure t) ;; always ensures that a package is installed
(setq package-archives '(("melpa" . "https://melpa.org/packages/") ;; Sets default package repositories
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/"))) ;; For Eat Terminal

(use-package evil
  :init ;; tweak evil's configuration before loading it
  (setq evil-want-keybinding nil) ;; Disable evil bindings in other modes (It's not consistent and not good)
  (setq evil-want-C-u-scroll t) ;; Set  C-u to scrool up
  (setq evil-want-C-i-jump nil) ;; Disables C-i jump
  (setq evil-undo-system 'undo-redo) ;; C-r to redo
  (setq org-return-follows-link  t) ;; Sets RETURN key in org-mode to follow links
  (evil-mode))
(use-package evil-collection
  :after evil
  :config
  ;; Setting where to use evil-collection
  (setq evil-collection-mode-list '(dired ibuffer magit corfu))
  (evil-collection-init))
;; Unmap keys in 'evil-maps. If not done, (setq org-return-follows-link t) will not work
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))

(use-package general
  :config
  (general-evil-setup)
  ;; set up 'SPC' as the global leader key
  (general-create-definer start/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "C-SPC") ;; access leader in insert mode

  (start/leader-keys
    "." '(find-file :wk "Find file")
    "TAB" '(comment-line :wk "Comment lines")
    "p" '(projectile-command-map :wk "Projectile command map"))

  (start/leader-keys
    "f" '(:ignore t :wk "Find")
    "f c" '((lambda () (interactive) (find-file "~/.config/emacs/init.el")) :wk "Edit emacs config")
    "f r" '(counsel-recentf :wk "Recent files"))

  (start/leader-keys
    "b" '(:ignore t :wk "Buffer Bookmarks")
    "b i" '(ibuffer :wk "Ibuffer")
    "b b" '(switch-to-buffer :wk "Switch buffer")
    "b d" '(kill-this-buffer :wk "Kill this buffer")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b R" '(rename-buffer :wk "Rename buffer")
    "b j" '(bookmark-jump :wk "Bookmark jump"))

  (start/leader-keys
    "d" '(:ignore t :wk "Dired")
    "d v" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current"))

  (start/leader-keys
    "g" '(:ignore t :wk "Git")
    "g g" '(magit-status :wk "Magit status"))

  (start/leader-keys
    "k" '(:ignore t :wk "Splitters")
    "k o" '(split-window-below :wk "Split Window Below")
    "k k" '(split-window-right :wk "Split Window Right"))

  (start/leader-keys
    "h" '(:ignore t :wk "Help")
    "h r" '((lambda () (interactive)
              (load-file "~/.config/emacs/init.el"))
            :wk "Reload emacs config"))

  (start/leader-keys
    "s" '(:ignore t :wk "Show")
    "s e" '(eat :wk "Show Eat"))

  (start/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t t" '(visual-line-mode :wk "Toggle truncated lines (wrap)")))

(delete-selection-mode 1)    ;; You can select text and delete it by typing.
(electric-indent-mode -1)    ;; Turn off the weird indenting that Emacs does by default.
(electric-pair-mode 1)       ;; Turns on automatic parens pairing

(global-auto-revert-mode t)  ;; Automatically reload file and show changes if the file has changed
(global-display-line-numbers-mode 1) ;; Display line numbers
(global-visual-line-mode t)  ;; Enable truncated lines
(menu-bar-mode -1)           ;; Disable the menu bar
(scroll-bar-mode -1)         ;; Disable the scroll bar
(tool-bar-mode -1)           ;; Disable the tool bar

;; (setq mouse-wheel-progressive-speed nil) ;; Disable progressive speed when scrolling
(setq scroll-conservatively 10) ;; Smooth scrolling when going down with scroll margin
(setq scroll-margin 8)

(setq make-backup-files nil) ; Stop creating ~ backup files
;; Move customization variables to a separate file and load it, avoid filling up init.el with unnecessary variables
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(global-set-key [escape] 'keyboard-escape-quit) ;; Makes Escape quit prompts (Minibuffer Escape)
(blink-cursor-mode 0) ;; Don't blink cursor
(add-hook 'prog-mode-hook (lambda () (hs-minor-mode t))) ;; Enable folding hide/show globally

(setq org-edit-src-content-indentation 4) ;; Set src block automatic indent to 4 instead of 2.
(setq-default tab-width 2)

(load-theme 'wheatgrass t)

(add-to-list 'default-frame-alist '(alpha-background . 90)) ; For all new frames henceforth

(set-face-attribute 'default nil
                    :font "Ubuntu Mono Nerd Font" ;; Set your favorite type of font or download JetBrains Mono
                    :height 175
                    :weight 'medium)
;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
;; (add-to-list 'default-frame-alist '(font . "JetBrains Mono")) ;; Set your favorite font
(setq-default line-spacing 0.12)

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25      ;; sets modeline height
        doom-modeline-bar-width 5    ;; sets right bar width
        doom-modeline-persp-name t   ;; adds perspective name to modeline
        doom-modeline-persp-icon t)) ;; adds folder icon next to persp name

(use-package projectile
  :config
  (projectile-mode 1)
  :init
  (setq projectile-switch-project-action #'projectile-dired)
  (setq projectile-project-search-path '("~/projects/" ("~/projs" . 1)))) ;; . 1 means only search first subdirectory level for projects
;; Use Bookmarks for non git projects


;; Automatically start eglot for a given file type.
;;(use-package eglot
;;  :ensure nil ;; Don't install eglot because It's now build in
;;  :hook (('c-mode . 'eglot-ensure) ;; Autostart lsp servers
;;         ('c++-mode . 'eglot-ensure)
;;         ('lua-mode . 'eglot-ensure)) ;; Lua-mode needs to be installed
;;  :config
;;  (add-to-list 'eglot-server-programs
;;               `(lua-mode . ("PATH_TO_THE_LSP_FOLDER/bin/lua-language-server" "-lsp"))) ;; Adds our lua lsp server to eglot's server list
;;  )

(use-package yasnippet-snippets
  :hook (prog-mode . yas-minor-mode))

(add-hook 'org-mode-hook 'org-indent-mode) ;; Indent text

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :after org)

(with-eval-after-load 'org
  (require 'org-tempo))

(use-package eat
  :hook ('eshell-load-hook #'eat-eshell-mode))

(use-package nerd-icons
  :if (display-graphic-p))

(use-package nerd-icons-dired
  :hook (dired-mode . (lambda () (nerd-icons-dired-mode t))))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package magit
  :commands magit-status)

(use-package diff-hl
  :hook ((magit-pre-refresh-hook . diff-hl-magit-pre-refresh)
         (magit-post-refresh-hook . diff-hl-magit-post-refresh))
  :init (global-diff-hl-mode))

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-prefix 2)          ;; Minimum length of prefix for auto completion.

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete))

(use-package nerd-icons-corfu
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package counsel
  :after ivy
  :diminish
  :config (counsel-mode))

(use-package ivy
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish 

	:custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  
:config
  (ivy-mode))

(use-package nerd-icons-ivy-rich
  :init
  (nerd-icons-ivy-rich-mode 1)
  (ivy-rich-mode 1))

(use-package ivy-rich
  :after ivy
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
                          ivy-rich-switch-buffer-align-virtual-buffer t
                          ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))
(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package diminish)

(use-package which-key
  :init
  (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit nil
        which-key-separator " → " ))


;; Make gc pauses faster by decreasing the threshold.
; Increase the amount of data which Emacs reads from the process
(setq read-process-output-max (* 1024 1024)) ;; 1mb


;; Neotree Stuff

(add-to-list 'load-path "~/.config/emacs/neotree")
(require 'neotree)
  (global-set-key [f8] 'neotree-toggle)

(setq neo-smart-open t)


;; (defun neotree-project-dir ()
;;   "Open NeoTree using the git root."
;;   (interactive)
;;   (let ((project-dir (ffip-project-root))
;;         (file-name (buffer-file-name)))
;;     (if project-dir
;;         (progn
;;           (neotree-dir project-dir)
;;           (neotree-find file-name))
;;       (message "Could not find git project root."))))

;; (define-key map (kbd "C-c C-p") 'neotree-project-dir)

(defun neotree-project-dir ()
	"Open NeoTree using the git root."
	(interactive)
	(let ((project-dir (projectile-project-root))
				(file-name (buffer-file-name)))
		(neotree-toggle)
		(if project-dir
				(if (neo-global--window-exists-p)
						(progn
							(neotree-dir project-dir)
							(neotree-find file-name)))
			(message "Could not find git project root."))))

(global-set-key [f9] 'neotree-project-dir)

(setq neo-window-fixed-size nil)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(defun neotree--fit-window (type path c)
  "Resize neotree window to fit contents based on TYPE, with PATH and C as unused variables as far as this function is concerned."
  (if (eq type 'directory)
      (neo-buffer--with-resizable-window
       (let ((fit-window-to-buffer-horizontally t))
         (fit-window-to-buffer)))))
(add-hook 'neo-enter-hook #'neotree--fit-window)

(setq neo-window-width 50)


(add-hook 'neotree-mode-hook
					(lambda ()
						(define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
						(define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
						(define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
						(define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
						(define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
						(define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
						(define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
						(define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
						(define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))

