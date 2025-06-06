;; ======================
;; UI & Basic Settings
;; ======================

(setq gc-cons-threshold (* 100 1024 1024))

(use-package gcmh
  :init
  (gcmh-mode 1))


(setq inhibit-startup-message t)
(tool-bar-mode -1)	
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)

(global-font-lock-mode 1)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

(setq scroll-conservatively 10)
(setq scroll-margin 10)

(setq make-backup-files nil)

(set-face-attribute 'default nil
                    :family "Iosevka Nerd Font Mono"
                    :height 120
                    :weight 'regular)

(setq-default tab-width 4)
(setq ring-bell-function 'ignore)
(setq shell-file-name "/bin/bash")

;; ======================
;; Package Management
;; ======================

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; ================
;; Themes & Looks
;; ================

;;  (load-theme 'gruber-darker t))

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-hard t)
  (add-hook 'after-load-theme-hook
            (lambda ()
              (set-face-attribute 'region nil :background "#2d2d2d" :foreground nil))))


(let ((bg (face-attribute 'default :background)))
  (set-face-attribute 'line-number nil :background bg)
  (set-face-attribute 'line-number-current-line nil :background bg :foreground "#DEC20B" :weight 'bold) )

(with-eval-after-load 'lsp-mode
  (set-face-attribute 'lsp-face-highlight-textual nil :background "#2d2d2d" :foreground nil)
  (set-face-attribute 'lsp-face-highlight-read nil :background "#2d2d2d" :foreground nil)
  (set-face-attribute 'lsp-face-highlight-write nil :background "#2d2d2d" :foreground nil))



;; ==================
;; Dashboard
;; ==================

(use-package dashboard
  :config
  (setq dashboard-banner-logo-title "“Il faut imaginer Sisyphe heureux.”  — Albert Camus"
        dashboard-center-content t
        dashboard-items '((recents  . 5)
                          (projects . 5)))
  (dashboard-setup-startup-hook))

;; ==================
;; Company Autocomplete
;; ==================

(use-package company
  :hook ((prog-mode . company-mode)
         (lsp-mode . company-mode))
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        
        
        company-frontends '(company-pseudo-tooltip-frontend)
        
        
        company-show-quick-access t
        company-tooltip-minimum-width 40
        company-tooltip-align-annotations t
        company-tooltip-flip-when-above t
        
        
        company-show-numbers t
        company-echo-metadata-frontend nil))

;; ==================
;; LSP Support
;; ==================


(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((go-mode . lsp-deferred)
         (js-mode . lsp-deferred)
		 (php-mode . lsp-deferred)
		 (php-ts-mode-run-php-webserver . lsp-deferred)
		 (php-ts-mode . lsp-deferred)
         (typescript-ts-mode . lsp-deferred)  
         (typescript-ts-base-mode . lsp-deferred)  
		 (web-mode . lsp-deferred)
		 (typescript-mode . lsp-deferred)
		 )
  :config
  (setq lsp-enable-snippet t
        lsp-prefer-flymake nil
        lsp-completion-enable t
        lsp-auto-guess-root t
        lsp-enable-file-watchers nil
		lsp-eldoc-hook nil
		lsp-eldoc-enable-hover nil
		lsp-signature-auto-activate nil
        lsp-headerline-breadcrumb-enable nil
		lsp-signature-render-documentation nil
		lsp-clients-php-server-command t
		lsp-php-composer-dir t
		
		))

 (setq lsp-intelephense-stubs
        ["apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", 
         "curl", "date", "dba", "dom", "enchant", "exif", "fileinfo", "filter", 
         "fpm", "ftp", "gd", "hash", "iconv", "imap", "interbase", "intl", "json", 
         "ldap", "libxml", "mbstring", "mysqli", "oci8", "odbc", "openssl", "pcntl", 
         "pcre", "PDO", "pdo_ibm", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", 
         "Phar", "posix", "pspell", "readline", "recode", "Reflection", "regex", 
         "session", "shmop", "SimpleXML", "snmp", "soap", "sockets", "sodium", 
         "SPL", "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem", 
         "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", 
         "xsl", "zip", "zlib"])
  
  ;; Enable PHP LSP by default
  (with-eval-after-load 'php-mode
    (require 'lsp-mode)
    (add-hook 'php-mode-hook #'lsp-deferred))


(global-eldoc-mode -1)
(setq eldoc-echo-area-use-multiline-p nil)
(remove-hook 'eldoc-documentation-functions #'lsp-eldoc-function)
(setq eldoc-message-function #'ignore)

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  
  (setq
   lsp-ui-doc-enable t
   lsp-ui-doc-position 'at-point
  
  ))

(unless (package-installed-p 'go-mode)
  (package-install 'go-mode))

(unless (package-installed-p 'company-go)
  (package-install 'company-go))

;; ==================
;; PDF Tools (Lazy Load)
;; ==================

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (pdf-loader-install))

;; ==================
;; EMMS (Music Player)
;; ==================

(use-package emms
  :defer t
  :config
  (require 'emms-setup)
  (emms-all)
  (setq emms-player-list '(emms-player-vlc)
        emms-source-file-default-directory "~/Music/"
        emms-mode-line-mode t
        emms-playing-time-display-mode t)
  (emms-mode-line 1))

;; ==================
;; Exec path (Mac/NS/X only)
;; ==================

(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))

;; ==================
;; Org-mode & Markdown Preview
;; ==================

(setq org-agenda-files '("~/org/"))

(defun markdown-html (buffer)
  (princ
   (with-current-buffer buffer
     (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\">%s</xmp><script src=\"http://ndossougbe.github.io/strapdown/dist/strapdown.js\"></script></html>"
             (buffer-substring-no-properties (point-min) (point-max))))
   (current-buffer)))

;; ===========================
;; Custom Shortcut or whatever
;; ===========================

(use-package multi-term
  :ensure t
  :config
  (setq multi-term-program shell-file-name)


  (defun my-term-split-below ()
    "Open multi-term in split below, or switch to existing term."
    (interactive)
    (let ((terms (cl-remove-if-not
                  (lambda (buf)
                    (with-current-buffer buf
                      (derived-mode-p 'term-mode)))
                  (buffer-list))))
      (split-window-below)
      (other-window 1)
      (if terms
          (switch-to-buffer (car terms))
        (multi-term))))
  
  (defun my-term-new ()
  (interactive)
  (multi-term))

  (global-set-key (kbd "C-c n") #'multi-term-next)
  (global-set-key (kbd "C-c p") #'multi-term-prev)
  
  
  (global-set-key (kbd "C-c t") 
    (lambda ()
      (interactive)
      (if (term-in-line-mode)
          (term-char-mode)
        (term-line-mode))))
  
  (global-set-key (kbd "C-c m") #'my-term-new)  
  (global-set-key (kbd "C-c s") #'my-term-split-below))


;; like "yy p" in vim
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  )
(global-set-key (kbd "C-,") 'duplicate-line)

;; like "o" in vim
(defun make-newline-below()
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))
(global-set-key (kbd "C-o") 'make-newline-below)

;; like "O" in vim

(defun make-newline-above()
  (interactive)
  (unless (bolp)
	(beginning-of-line))
  (newline)
  (forward-line -1)
  (indent-according-to-mode))
(global-set-key (kbd "C-S-o") 'make-newline-above)

;; Multiple cursor
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))


; ==================
;; treemacs
;; ==================
(use-package treemacs
  :ensure t
  :defer t
  :bind
  (:map global-map
        ("<f8>" . treemacs)) ;; Tekan F8 buat toggle sidebar
  :config
  (setq treemacs-width 30
        treemacs-follow-after-init t
        treemacs-silent-refresh t
        treemacs-show-hidden-files t))

(add-hook 'treemacs-mode-hook (lambda () (display-line-numbers-mode -1)))


(use-package nerd-icons
  :ensure t)

(use-package treemacs-nerd-icons
  :after treemacs
  :ensure t
  :config
  (treemacs-load-theme "nerd-icons"))



  ;; (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
  ;; (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-go dashboard dirvish doom-themes emms exec-path-from-shell
				flymake-go gcmh go-autocomplete gruber-darker-theme
				gruvbox-theme impatient-mode lsp-ui multi-term
				multiple-cursors neotree pdf-tools php-mode
				treemacs-all-the-icons treemacs-nerd-icons
				typescript-mode typespec-ts-mode typit web-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
