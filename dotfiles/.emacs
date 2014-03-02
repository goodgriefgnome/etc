(add-to-list 'load-path "~/etc/emacs.d")

(setq-default fill-column 80)
(global-auto-revert-mode)
(tool-bar-mode 0)
(column-number-mode 1)
(winner-mode 1)
(setq tramp-mode nil)

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)
(setq ido-use-url-at-point nil)
(setq ido-enable-tramp-completion nil)
(ido-mode 1)

(setq dabbrev-case-fold-search nil)
(setq-default indent-tabs-mode nil)
(setq-default require-final-newline 'ask)
(global-set-key (kbd "M-/") 'dabbrev-completion)
(global-set-key (kbd "C-M-/") 'dabbrev-expand)
(global-set-key (kbd "C-M-_") 'dabbrev-expand)
(global-set-key (kbd "ESC M-w") 'clipboard-kill-ring-save)
(global-set-key (kbd "M-r") 'isearch-backward-regexp)
(global-set-key (kbd "M-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-c q q") 'query-replace)
(global-set-key (kbd "C-c q w") 'query-replace-regexp)
(global-set-key (kbd "C-x C-b") 'buffer-menu)

;(setq font-lock-maximum-decoration 2)
(setq jit-lock-chunk-size 100)
(setq jit-lock-context-time 10)
(setq jit-lock-defer-time 2)
(setq jit-lock-stealth-load 90)
(setq jit-lock-stealth-nice 0.05)
(setq jit-lock-stealth-time 1)

(setq compilation-scroll-output 'first-error)

(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs_saves"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

(setq default-frame-alist
      '((tool-bar-lines . nil)
	(vertical-scroll-bars . nil)
	(background-mode . dark)
	(font . "Monospace-10")
	(foreground-color . "white")
	(background-color . "black")
        ))

(require 'ffap)
(defun ffap-near-mouse-other-window (e)
  (interactive "e")
  (mouse-set-point e)
  (ffap-other-window))
(global-unset-key [C-down-mouse-1])
(global-set-key [C-mouse-1] 'ffap-near-mouse-other-window)

(defun setup-window-system-frame-options (&optional frame)
  (set-frame-parameter frame 'fullscreen 'maximized)
  (set-cursor-color "#888888"))

(defadvice log-edit-done (around keep-windows activate)
  "Stop vc from closing my windows."
  (save-window-excursion
    ad-do-it))

(require 'server)
(defadvice server-create-window-system-frame (after custom-options activate)
  "Setup custom frame options."
  (setup-window-system-frame-options))
(add-hook 'after-make-frame-functions 'setup-window-system-frame-options t)

(require 'whole-line-or-region)
(defadvice whole-line-or-region-kill-region (before read-only-ok activate)
  (interactive "p")
  (unless kill-read-only-ok (barf-if-buffer-read-only)))
(whole-line-or-region-mode 1)

(global-font-lock-mode 1)
(setq-default transient-mark-mode t)
(setq require-final-newline t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;(setenv "TERM" "dumb")
;(setenv "COLORTERM" "dumb")
(setq find-file-visit-truename t)

(set-variable 'confirm-kill-emacs nil)

(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not."
  (interactive)
  (let* ((window (selected-window))
	 (dedicated (not (window-dedicated-p window))))
    (set-window-dedicated-p window dedicated)
    (message "Window '%s' is %s"
	     (current-buffer)
	     (if dedicated "dedicated" "normal"))))
(global-set-key "\C-\M-z" 'toggle-window-dedicated)

(require 'multi-term)
(setq term-default-fg-color "white")
(setq term-default-bg-color "black")
(setq multi-term-program "/bin/zsh")
(defun term-send-esc ()
  "Send ESC in term mode."
  (interactive)
  (term-send-raw-string "\e"))
(setq-default term-buffer-maximum-size 99999)

(setq term-bind-key-alist
      '(("C-c C-c" . term-interrupt-subjob)
	("ESC ESC" . term-send-esc)
	("C-r" . term-send-reverse-search-history)
        ("C-y" . term-paste)
;	("C-m" . term-send-raw)
;	("M-f" . term-send-forward-word)
;	("M-b" . term-send-backward-word)
	("C-<right>" . term-send-forward-word)
	("C-<left>" . term-send-backward-word)
;	("M-o" . term-send-backspace)
;	("M-p" . term-send-up)
;	("M-n" . term-send-down)
;	("M-M" . term-send-forward-kill-word)
;	("M-N" . term-send-backward-kill-word)
        ("C-<delete>" . term-send-forward-kill-word)
;       ("M-<backspace>" . term-send-backward-kill-word)
;	("M-r" . isearch-backward)
;	("M-," . term-send-input)
	("M-." . comint-dynamic-complete)))

(defun setup-mode-width (width)
  "Sets up width parameters for the mode"
  (font-lock-set-up-width-warning width)
  (set-fill-column width))

(add-hook 'c-mode-common-hook '(lambda () (setup-mode-width 80)))
(add-hook 'python-mode-hook '(lambda () (setup-mode-width 80)))
(add-hook 'java-mode-hook '(lambda () (setup-mode-width 100)))

(defun set-subword-mode ()
  "Sets subword mode"
  (if (fboundp 'subword-mode)
      (subword-mode 1)
      (c-subword-mode 1)))

(add-hook 'c-mode-common-hook 'set-subword-mode)
(add-hook 'python-mode-hook 'set-subword-mode)

(add-hook 'go-mode '(lambda () (setq tab-width 2)))

(defun get-buffer-create-temp (name)
  "Creates/gets a temporary buffer named name"
  (let ((buffer (get-buffer-create name)))
    (save-current-buffer
      (set-buffer buffer)
      (toggle-read-only t)
      (help-mode))
    buffer))

; braindead stuff that trigger regexps of death easily.
(compilation-minor-mode 0)
(delete 'watcom compilation-error-regexp-alist)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(setq wg-switch-on-load nil)
(setq wg-morph-on nil)
(setq wg-mode-line-on nil)
(workgroups-mode 1)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
