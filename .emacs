;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

;; custom thems
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (jungle)))
 '(custom-safe-themes
   (quote
    ("a21be90bf7f37922e647eb3c5b8fbaa250b3b0db9daee4dbf510863a4f9006a4" default)))
 '(package-selected-packages
   (quote
    (use-package highlight-parentheses cider bind-key tabbar evil-paredit paredit company slime evil-surround)))
 '(tabbar-background-color "gray20")
 '(tabbar-separator (quote (0.5)))
 '(tabbar-use-images nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; save auto-save and backup files somewhere else
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))
(require 'use-package)

;; global linenumbers
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))


;; dired directory sorting
(setq dired-listing-switches "-alX  --group-directories-first")

;; tabs as spaces
(progn
  (setq-default indent-tabs-mode nil))

;; Evil mode
(setq evil-want-C-u-scroll t)
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
;;allow tabs in evil mode
(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
(evil-mode 1)

;; evil-surround
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))
;; compatibility with paredit
(add-to-list 'evil-surround-operator-alist
             '(evil-paredit-change . change))
(add-to-list 'evil-surround-operator-alist
             '(evil-paredit-delete . delete))

;; cider stuff
(setq cider-prompt-for-symbol nil)

;; company-mode in all buffers
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key "\t" 'company-complete-common)
(setq company-idle-delay 0) ; start completions immediately
;; paredit hooks
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)
(add-hook 'cider-repl-mode-hook       #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook            #'enable-paredit-mode)
;; evil paredit
;(add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)
;(add-hook 'eval-expression-minibuffer-setup-hook #'evil-paredit-mode)
;(add-hook 'ielm-mode-hook             #'evil-paredit-mode)
;(add-hook 'lisp-mode-hook             #'evil-paredit-mode)
;(add-hook 'lisp-interaction-mode-hook #'evil-paredit-mode)
;(add-hook 'scheme-mode-hook           #'evil-paredit-mode)
;(add-hook 'clojure-mode-hook          #'evil-paredit-mode)
;(add-hook 'cider-repl-mode-hook       #'evil-paredit-mode)
;(add-hook 'slime-repl-mode-hook            #'evil-paredit-mode)
;; highlight parentheses
(require 'highlight-parentheses)
(defun highlight-parentheses-fun ()
  (highlight-parentheses-mode t))
(add-hook 'emacs-lisp-mode-hook #'highlight-parentheses-fun)
(add-hook 'eval-expression-minibuffer-setup-hook #'highlight-parentheses-fun)
(add-hook 'ielm-mode-hook             #'highlight-parentheses-fun)
(add-hook 'lisp-mode-hook             #'highlight-parentheses-fun)
(add-hook 'lisp-interaction-mode-hook #'highlight-parentheses-fun)
(add-hook 'scheme-mode-hook           #'highlight-parentheses-fun)
(add-hook 'clojure-mode-hook          #'highlight-parentheses-fun)
(add-hook 'cider-repl-mode-hook       #'highlight-parentheses-fun)
(add-hook 'slime-repl-mode-hook            #'highlight-parentheses-fun)

;; make normal mode the default
(setq evil-emacs-state-modes nil)

;; new empty without prompting for a name
(defun new-empty-buffer ()
  "Create a new empty buffer.
New buffer will be named “untitled” or “untitled<2>”, “untitled<3>”, etc.

It returns the buffer (for elisp programing).

URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
Version 2017-11-01"
  (interactive)
  (let (($buf (generate-new-buffer "untitled")))
    (switch-to-buffer $buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)
    $buf))

;; slime stuff
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq slime-contribs '(slime-fancy))


;; tabbar stuff
(require 'tabbar)
(tabbar-mode 1)
(defun my-tabbar-buffer-groups () ;; customize to show all normal files in one group
  "Returns the name of the tab group names the current buffer belongs to.
    There are two groups: Emacs buffers (those whose name starts with '*', plus
    dired buffers), and the rest.  This works at least with Emacs v24.2 using
    tabbar.el v1.7."
  (list (cond ((string-equal "*" (substring (buffer-name) 0 1)) "emacs")
        ((eq major-mode 'dired-mode) "emacs")
        (t "user"))))
(setq tabbar-buffer-groups-function 'my-tabbar-buffer-groups)

;(setq *tabbar-ignore-buffers* '("*scratch*" "*Messages*" "*GNU Emacs*"
                                ;"*inferior-lisp*" "*slime-events*"))
;(setq *tabbar-ignore-buffers* '())
;(defun remove-unwanted-buffers ()
  ;(buffer-list))

;(setq tabbar-buffer-list-function 'remove-unwanted-buffers)

;(setq tabbar-buffer-list-function
      ;(lambda ()
        ;;(buffer-list)
        ;(remove-if
                  ;(lambda (buffer) nil
                    ;;(and (not (eq (current-buffer) buffer)) ; Always include the current buffer.
                         ;;(loop for name in *tabbar-ignore-buffers* ;remove buffer name in this list.
                               ;;thereis (string-equal (buffer-name buffer) name))
                         ;;)
                    ;)
                  ;(buffer-list)
                  ;)
        ;))

;; customize Tab Bar look
(customize-set-variable 'tabbar-background-color "gray20")
(customize-set-variable 'tabbar-separator '(0.5))
(customize-set-variable 'tabbar-use-images nil)

;; My preferred keys
(define-key global-map (kbd "M-j") 'kill-this-buffer)
(define-key global-map (kbd "M-k") 'new-empty-buffer)
(define-key global-map (kbd "<M-left>") 'tabbar-backward-tab)
(define-key global-map (kbd "<M-right>") 'tabbar-forward-tab)
(define-key global-map (kbd "M-h") 'tabbar-backward-group)
(define-key global-map (kbd "M-l") 'tabbar-forward-group)

;; Colors
(set-face-attribute 'tabbar-default nil
        :background "gray20" :foreground
        "gray60" :distant-foreground "gray50"
        :family "DejaVu Sans Mono" :box nil)
(set-face-attribute 'tabbar-unselected nil
        :background "gray80" :foreground "black" :box nil)
(set-face-attribute 'tabbar-modified nil
        :foreground "red4" :box nil
        :inherit 'tabbar-unselected)
(set-face-attribute 'tabbar-selected nil
        :background "#4090c0" :foreground "white" :box nil)
(set-face-attribute 'tabbar-selected-modified nil
        :inherit 'tabbar-selected :foreground "GoldenRod2" :box nil)
(set-face-attribute 'tabbar-button nil
        :box nil)

(add-to-list 'load-path "~/.emacs.d/powerline")
;; Use Powerline to make tabs look nicer
;; (this needs to run *after* the colors are set)
(require 'powerline)
(defvar my/tabbar-height 20)
(defvar my/tabbar-left (powerline-wave-right 'tabbar-default nil my/tabbar-height))
(defvar my/tabbar-right (powerline-wave-left nil 'tabbar-default my/tabbar-height))
(defun my/tabbar-tab-label-function (tab)
  (powerline-render (list my/tabbar-left
        (format " %s  " (car tab))
        my/tabbar-right)))
(setq tabbar-tab-label-function #'my/tabbar-tab-label-function)

(set-cursor-color "#ef330e")
