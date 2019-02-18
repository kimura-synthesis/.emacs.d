;;;; Look and feel
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

(cond
 ((find-font (font-spec :name "Inconsolata"))
  (set-face-attribute 'default nil :family "Inconsolata" :height 120))
 ((find-font (font-spec :name "courier"))
  (set-face-attribute 'default nil :famlly "courier" :height 120)))

(cond
 ((find-font (font-spec :name "Migu 1M"))
  (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Migu 1M"))))

(if (>= emacs-major-version 26)
    (global-display-line-numbers-mode))

(setq custom-file (locate-user-emacs-file "custom.el"))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)

(when (require 'use-package nil 'noerror)
  (package-install 'use-package))

(use-package bind-key
  :ensure t
  :config
  (bind-key* "C-h" 'delete-backward-char))

(use-package cmake-mode
  :ensure t)

(use-package company
  :ensure t
  :init (add-hook 'prog-mode-hook #'company-mode)
  :bind (:map company-mode-map
	      ([remap completion-at-point] . company-complete))
  :bind (:map company-active-map
	      ("C-p" . company-select-previous)
	      ("C-n" . company-select-next)))

(use-package company-lsp
  :ensure t
  :defer t
  :after (company)
  :init (push 'company-lsp company-backends)
  :config
  (defun lsp//enable()
    (condition-case nil
	(lsp)
      (user-error nil))))

(use-package cquery
  :ensure t
  :after (company-lsp company)
  :defer t
  :init
  (add-hook 'c-mode-hook #'lsp//enable)
  (add-hook 'c++-mode-hook #'lsp//enable)
  :config
  (setq cquery-extra-init-params
	'(:index (:comments 2) :cacheFormat "msgpack"
		 :completion (:detailedLabel t)))
  (setq company-transformers nil
	company-lsp-async t
	company-lsp-cache-candidates nil))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-buffers-list))
  :config
  (setq helm-buffers-fuzzy-matching t)
  (helm-mode 1))

(use-package leuven-theme
  :ensure t)

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1)
  (setq yas-prompt-functions '(yas-ido-prompt)))

(use-package yasnippet-snippets
  :ensure t
  :after (yasnippet))

(use-package skk
  :ensure ddskk
  :bind ("C-x C-j" . skk-mode))

(use-package markdown-mode
  :ensure t
  :config
  (set-face-attribute 'markdown-code-face nil :inherit 'default))

