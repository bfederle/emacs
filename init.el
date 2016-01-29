;;
;; Basic setup
;;
(ido-mode t)
(setq ido-enable-flex-matching t)
(menu-bar-mode -1)
(global-auto-revert-mode t)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR." t)
(set-face-attribute 'default nil
  :family "Source Code Pro Light")

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'saveplace)
(setq-default save-place t)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "M-z") 'zap-up-to-char)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(setq x-select-enable-clipboard t
  x-select-enable-primary t
  save-interprogram-paste-before-kill t
  apropos-do-all t
  mouse-yank-at-point t
  require-final-newline t
  visible-bell nil
  load-prefer-newer t
  ediff-window-setup-function 'ediff-setup-windows-plain
  save-place-file (concat user-emacs-directory "places")
  backup-directory-alist `(("." . ,(concat user-emacs-directory
                                     "backups"))))

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
    (lambda (package)
      (if (package-installed-p package)
        nil
        (package-install package)))
    packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
  (package-refresh-contents))

;; Activate installed packages
(package-initialize)

;; Assuming you wish to install "iedit" and "magit"
(ensure-package-installed
  'projectile
  'editorconfig
  'iedit
  'magit
  'solarized-theme
  'web-mode
  'paredit
  'haml-mode
  'emmet-mode
  'scss-mode)

(editorconfig-mode 1)

;;
;; Web dev
;;
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;
;; Paredit
;;
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

;;
;; Indent on paste
;;
(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
           (and (not current-prefix-arg)
             (let ((mark-even-if-inactive transient-mark-mode))
               (indent-according-to-mode (region-beginning) (region-end) nil))))))

;;
;; Post-package configs
;;
(load-theme 'solarized-dark t)

;;
;; Emmet
;;
(add-hook 'web-mode-hook 'emmet-mode)
(defun custom-emmet-expand-line ()
  (interactive)
  (setq emmet-expand-jsx-className? nil)
  (if (equal web-mode-content-type "jsx")
    (setq emmet-expand-jsx-className? t))
  (emmet-expand-line nil))
(add-hook 'web-mode-hook
  (lambda ()
    (local-set-key (kbd "C-S-j") 'custom-emmet-expand-line)))

;;
;; Keymaps
;;
(global-set-key (kbd "C-c m") 'magit-status)
(global-set-key (kbd "C-k") 'paredit-kill)
(global-set-key (kbd "C-c f") 'projectile-find-file)
