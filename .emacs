;;;;;;;;; simplicity ;;;;;;;;;

(when (< emacs-major-version 27)
  (package-initialize))
(setq debug-on-error t)

;; initial height and width
(add-to-list 'default-frame-alist '(height . 50))
(add-to-list 'default-frame-alist '(width . 90))

(add-to-list 'load-path "/backup/emacs.d/") ; yasnippets etc.

(column-number-mode 1) ;display line number below
(show-paren-mode 1) ; highlight paired braces
(save-place-mode 1) ; emacs25.1+, goto last place where u previously visit
(delete-selection-mode 1) ;replace selected text when typing
(desktop-save-mode 1) ;save sessions
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)
(transient-mark-mode 1) ;selection highlight
(global-set-key "\C-z" 'set-mark-command)
(electric-pair-mode 1)  ;emacs24+
(recentf-mode 1) ;recent opened files
(global-set-key [f12] 'recentf-open-files)
(global-unset-key (kbd "C-x C-z")) ;suspend frame
(fset 'yes-or-no-p 'y-or-n-p)
(global-font-lock-mode 1)
(auto-save-mode 1)
;; The  default is in the current dir with name #file#s, cluttered
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs-backups"))
(setq large-file-warning-threshold 100000000) ;warning if >100MB
(setq password-cache-expiry nil) ;never forget passwd,
;;"fbounup symbol": return t if the symbol has an object in it's function
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(setq scroll-margin 6
      scroll-conservatively 10000)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; '/usr/share/emacs/site-lisp/default.el' may override this
(setq frame-title-format '(buffer-file-name "%f" (dired-directory dired-directory "%b"))) ;full file path
(global-set-key "\M-/" 'hippie-expand) ;try different way of expanding

;; (featurep 'tramp) nil will cause "waiting for prompts from remote shell" message holding
;; C-x f /ssh:root@1.1.1.1:/..... ;; /su::/etc/hosts
(require 'tramp) ; for older emacs version

;; TAB
(setq-default indent-tabs-mode nil)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100))

;; unique buffer name
;; you might locate the default.el to remove the default
(require 'uniquify)
(setq uniquify-non-file-buffer-names t)
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "\\`\\*")

(if (>= emacs-major-version 27)
    (fido-mode 1)
  (icomplete-mode 1) ;; M-x search commands conveniently
  (ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)) ;; C-x C-f support

;; ibuffer, emacs 22+
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-saved-filter-groups
      '(("home"
         ("Org" (or (mode . org-mode) (filename . "OrgMode")))
         ("LaTeX" (or (mode . latex-mode) (filename . "\*.tex")))
         ("GO"  (mode . go-mode))
         ("Py"  (mode . python-mode))
         ("TXT" (mode . text-mode))
         ("Web Dev" (or (mode . html-mode)(mode . css-mode)(mode . nxhtml-mode)))
         ("emacs-config" (or (filename . ".emacs.d") (filename . "emacs-config")))
         ;; ("Subversion" (name . "\*svn"))
         ("Help" (or (name . "\*Help\*")(name . "\*Apropos\*")(name . "\*info\*"))))))
(add-hook 'ibuffer-mode-hook
          '(lambda ()
           (ibuffer-switch-to-saved-filter-groups "home")))

;;; Org-mode
(add-hook 'org-mode-hook 'turn-on-visual-line-mode) ; more readable for word wrap
(add-hook 'org-mode-hook 'org-indent-mode) ;cleaner outline view

;; coding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8) ; between Emacs and X windows, x-copy
(when (eq system-type 'windows-nt) ; Copy in windows use utf-16-le
  (set-next-selection-coding-system 'utf-16-le)
  (set-selection-coding-system 'utf-16-le)
  (set-clipboard-coding-system 'utf-16-le))

;; Theme: "tsdh-dark" "tango-dark"
(when (locate-file "tango-dark-theme.el"
                 (custom-theme--load-path) ; C-h f load-theme to find the path
                 '("" "c")) (load-theme 'tango-dark))

;; Set default font. (Move cursor to font)M-x describe-char
(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (when (member "Consolas" (font-family-list))
    (set-frame-font "Consolas-14" t t)))
 ((string-equal system-type "darwin") ; macOS
  (when (member "Menlo" (font-family-list))
    (set-frame-font "Menlo-12" t t)))
 ((string-equal system-type "gnu/linux") ; linux
  (when (member "DejaVu Sans Mono" (font-family-list))
    (set-frame-font "DejaVu Sans Mono-12" t t))))

;; Chinese font
(if (string-equal system-type "windows-nt")
 (set-fontset-font
  t
  '(#x4e00 . #x9fff) ; a range of characters
  (cond
   ((member "Microsoft YaHei" (font-family-list)) "Microsoft YaHei")
   ((member "PMingLiU" (font-family-list)) "PMingLiU")
   ((member "Microsoft YaHei UI" (font-family-list)) "Microsoft YaHei UI")
   ((member "MingLiU" (font-family-list)) "MingLiU")
   ((member "DengXian" (font-family-list)) "DengXian"))))

;; Transpose lines - use the shipped C-x C-t, keyboard macro
(global-set-key [(meta up)] "\C-x\C-t\C-p\C-p\C-a")
(global-set-key [(meta down)] "\C-n\C-x\C-t\C-p\C-a")

;; ---------------- snippets ----------------------
;; Proxy
;; To test: M-x eww then google.com, https://google.com
(defun toggle-proxy ()
  "Toggle http/https proxy"
  (interactive)
  (when (eq system-type 'windows-nt)  ;both http and https works
    (if url-proxy-services
        (setq url-proxy-services nil)
      (let ((port (read-string "set the port or use the default 10809: " nil nil "10809")))
        (setq url-proxy-services (list (cons "http" (concat "127.0.0.1:" port ))
                                       (cons "https" (concat "127.0.0.1:" port ))))
        (message "win's proxy is: %s " url-proxy-services))))
  (when (eq system-type 'gnu/linux) ; http's ok, not the https, use proxychains???
    (if (eq url-gateway-method 'native)
        (let ((port (read-string "Linux: set the port or use the default 1081: " nil nil "1081")))
          (setq url-gateway-method 'socks)
          (setq socks-server (list "Default server" "127.0.0.1" port 5))
          (message "linux's proxy 127.0.0.1:%s." port))
      (setq url-gateway-method 'native)
      (message "url-gateway-method native"))))

;; delete leading whitespace at each line in region 
(defun delete-leading-whitespace (start end)
  (interactive "*r")
  (save-excursion
    (if (not (bolp)) (forward-line 1))
    (delete-whitespace-rectangle (point) end nil)))
;; ---------------- end snippets ------------------

;; ================================================================
;; The followings need to use use-package
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; setting use-package
(eval-when-compile (require 'use-package))

;; ---------------- golang gopls lsp-ui company yasnippet -------
;; First u need to install gopls //https://github.com/golang/tools/blob/master/gopls/doc/user.md
;; go get golang.org/x/tools/gopls@latest // don't use -u

(use-package go-mode
  :ensure t
  :commands go-mode)

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package lsp-ui  ; Optional - provides fancier overlays.
  :ensure t
  :commands lsp-ui-mode)

;; Company mode is a standard completion package that works well with lsp-mode.
(use-package company
  :ensure t
  :config
  ;; Optionally enable completion-as-you-type behavior.
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

(use-package yasnippet  ; Optional for go - provides snippet support.
  :ensure t
  :config
  (setq yas-snippet-dirs '("/backup/emacs.d/yas-snippets/"))
  (yas-global-mode 1)) ;better globally

(add-to-list 'auto-mode-alist '("\\.gtpl\\'" . html-mode))
;; ---------------- end golang gopls lsp-ui company yasnippet ----------------

;;---------------------------------latex---------------------------------
;;Requirement: Tex Live(recommended)
(use-package auctex
  :defer t
  :ensure t
  :config
  (setq Tex-auto-save t)
  (setq Tex-parse-self t)
  (setq-default TeX-master nil) ; query for master file
  (setq-default TeX-engine 'xetex)) ; default engine

;; Used with AUCTeX to speedup insertion of environment and math templates
;; Also, you can do it with yasnippet
(use-package cdlatex
  :ensure t
  :config
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
  (add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode
  (setq cdlatex-paired-parens "$[{(")) ; Default is "$[{", cos like (0,1])
;;---------------------------------End latex------------------------------

;; (use-package auto-package-update
;;   :ensure t
;;   :config
;;   ;; (setq auto-package-update-delete-old-versions t)
;;   ;; (setq auto-package-update-hide-results t)
;;   (auto-package-update-at-time "03:00")
;;   (setq auto-package-update-prompt-before-update t)
;;   (setq auto-package-update-delete-old-versions t)             
;;   (auto-package-update-maybe))

;;-------------------------------------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (cdlatex auctex auto-package-update yasnippet company lsp-ui lsp-mode use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

