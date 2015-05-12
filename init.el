(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;;disable toolbar
(tool-bar-mode -1)

;;load theme
;;(load-theme 'professional t)

;; face font size
(set-face-attribute 'default nil :height 110)
;;line numbers mode globally
(global-linum-mode t)

;;neotree
(add-to-list 'load-path "/home/novak/.emacs.d/elpa/neotree-20150206.1900/")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; auto-complete
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-20150201.150")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20150201.150/dict")
(ac-config-default)
;; add the emacs-eclim source
(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)

;;additional commads
(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(control shift return)] 'smart-open-line-above)

;;projectile
(projectile-global-mode)
(setq projectile-enable-caching t)
;;enable projectile-rails alongside projectile-mode
(add-hook 'projectile-mode-hook 'projectile-rails-on)
;; ;;flx-ido
;; (require 'flx-ido)
;; (ido-mode 1)
;; (ido-everywhere 1)
;; (flx-ido-mode 1)
;; ;; disable ido faces to see flx highlights.
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)
;; ;;enabel recentf-mode
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
;;enable occur
(global-set-key (kbd "C-c o") 'occur)

;;web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; robe, documentation lookup and completion for Ruby
(require 'robe)
(add-hook 'ruby-mode-hook 'robe-mode)
;; ;; integration with rvm (seems it works already)
;; (defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
;;   (rvm-activate-corresponding-ruby))
;; ;; end integration with rvm
;; auto-complete
;; (add-hook 'robe-mode-hook 'ac-robe-setup)
;; use company mode for completion
(add-to-list 'load-path "./elpa/company-20150306.1548/")
(autoload 'company-mode "company" nil t)
(add-hook 'after-init-hook 'global-company-mode)
;;(push 'company-robe company-backends) ;; from dgutov/robe
;; set company-robe on ruby-mode-hook
(add-hook 'ruby-mode-hook
        (lambda ()
          (setq-local company-backends '((company-robe)))))
;; end robe setup

;;rvm
(require 'rvm)
(rvm-use-default) ;; use rvm's default ruby for the current Emacs session
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("26614652a4b3515b4bbbb9828d71e206cc249b67c9142c06239ed3418eff95e2" "e56f1b1c1daec5dbddc50abd00fcd00f6ce4079f4a7f66052cf16d96412a09a9" "cbef37d6304f12fb789f5d80c2b75ea01465e41073c30341dc84c6c0d1eb611d" "dc758223066a28f3c6ef6c42c9136bf4c913ec6d3b710794252dc072a3b92b14" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "e35ef4f72931a774769da2b0c863e11d94e60a9ad97fb9734e8b28c7ee40f49b" default)))
 '(eclim-eclipse-dirs (quote ("/opt/eclipse")))
 '(eclim-executable "~/.eclipse/org.eclipse.platform_4.4.0_1473617060_linux_gtk_x86_64/eclim")
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("/media/novak/Storage/Emacs/plans.org" "/media/novak/Storage/Emacs/org-mode/tutorial.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;saving emacs session
(desktop-save-mode 1)
;;winner mode, for saving window configuration settings
    (when (fboundp 'winner-mode)
      (winner-mode 1))

;; duplicate current line or region
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated. However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))
;; bind global key
(global-set-key (kbd "C-c q") 'duplicate-current-line-or-region)

;; show parenthesis the one I'm looking at
;;(show-paren-mode 1)
;; smartparens
(add-to-list 'load-path "/home/novak/.emacs.d/elpa/smartparens-20150208.233/")
(require 'smartparens-config)
(show-smartparens-global-mode +1)

;; eclipse like commenting
(defun comment-eclipse ()
  (interactive)
  (let ((start (line-beginning-position))
        (end (line-end-position)))
    (when (or (not transient-mark-mode) (region-active-p))
      (setq start (save-excursion
                    (goto-char (region-beginning))
                    (beginning-of-line)
                    (point))
            end (save-excursion
                  (goto-char (region-end))
                  (end-of-line)
                  (point))))
    (comment-or-uncomment-region start end)))
;; bind global key
(define-key ctl-x-map [(control ?\;)] 'comment-eclipse)

;; rubocop emacs integration
(add-to-list 'load-path "/home/novak/.emacs.d/elpa/rubocop-20141221.1329/")
(require 'rubocop)

;; ruby-debug
(add-to-list 'load-path "/home/novak/.emacs.d/packages/")
(require 'ruby-debug)

;; Anything that writes to the buffer while the region is active will overwrite it, including paste, but also simply typing something or hitting backspace
(delete-selection-mode 1)

;; emacs-eclim
(require 'eclim)
(global-eclim-mode)

(require 'eclimd)

(setq help-at-pt-display-when-idle t)
(setq help-at-pt-timer-delay 0.05)
(help-at-pt-set-timer)

(global-set-key (kbd "C-<") 'eclim-complete)

;; java indent fix
    (add-hook 'java-mode-hook (lambda ()
                                (setq c-basic-offset 4
                                      tab-width 4
                                      indent-tabs-mode t)))
;; emacs-eclim end

;; auto reload all buffers when file is changed on disk
(global-auto-revert-mode t)

;; emacs markdow-mode
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; bar cursor
(setq-default cursor-type 'bar)

;; highlight current line
(global-hl-line-mode 1)

;; nxml-slash-auto-complete-flag for "</" to end closest tag
(setq nxml-slash-auto-complete-flag t)

;; Helm is an Emacs incremental and narrowing framework
;; Helm is "alternative" to Ido
(require 'helm-config)
(helm-mode 1)
(helm-autoresize-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq projectile-completion-system 'helm)

;; smart-mode-line
(setq powerline-arrow-shape 'curve)
(setq powerline-default-separator-dir '(right . left))
(setq sml/theme 'powerline)
(sml/setup)

;; custom-themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'zenburn t)

;; switch between windows using SHIFT-{left, up, down, right}
;;(windmove-default-keybindings 'meta)
;;(setq windmove-wrap-around t)
;; using M instead of SHIFT
(global-set-key (kbd "M-<left>")  'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<up>")    'windmove-up)
(global-set-key (kbd "M-<down>")  'windmove-down)

;; Unique buffer names
(require 'uniquify)
(setq 
 uniquify-buffer-name-style 'forward 
 uniquify-separator "/")

;; Yasnippet
(add-to-list 'load-path
	    "~/home/novak/.emacs.d/elpa/yasnippet-20150212.240/")
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-snippet-dirs 
      '("./elpa/yasnippet-20150212.240/snippets/"))

;; flymake-ruby syntax on fly checking
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)

;; CIDER basic configuration
(add-hook 'cider-mode-hook #'eldoc-mode)
(setq nrepl-log-messages t)
(setq nrepl-hide-special-buffers t)
(add-hook 'cider-repl-mode-hook #'smartparens-strict-mode)

(electric-pair-mode 1) ;; electric-pair is built in
;; to add paredit's wrap around in smartparens
(sp-pair "(" ")" :wrap "C-(")
(sp-pair "[" "]")
(sp-pair "\"" "\"")

;; Hide show minor mode enable on startup - preinstalled
;; (hs-minor-mode t)

;; Org-mode configuration
(setq org-agenda-files (list "/media/novak/Storage/Emacs/org-mode/"))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-todo-keywords
      '((sequence "TODO(t)" "FEEDBACK(f)" "VERIFY(v)" "|" "DONE(d)" "DELEGATED(l)")))
(setq org-enforce-todo-dependencies t)

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; To save the clock history across Emacs sessions
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)
