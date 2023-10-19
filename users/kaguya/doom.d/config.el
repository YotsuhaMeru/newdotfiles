;; Appearance
(setq doom-theme 'catppuccin
      doom-font (font-spec :family "Spleen" :size 16)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 10.0)
      doom-unicode-font (font-spec :family "Symbols Nerd Font Mono" :size 16.0))

(load-theme 'catppuccin t t)
(setq catppuccin-flavor 'mocha)
(catppuccin-reload)

(setq fancy-splash-image "~/.doom.d/splash.png")

;; Indent line
(setq highlight-indent-guides-method 'bitmap
      highlight-indent-guides-bitmap-function 'highlight-indent-guides--bitmap-line)
(setq display-line-numbers-type 'relative)

(setq centaur-tabs-style "chamfer")
(after! centaur-tabs
  (setq centaur-tabs-set-bar 'right))

(use-package! beacon)
(after! beacon (beacon-mode 1))

(use-package treemacs-projectile
  :after (treemacs projectile))
(after! (treemacs projectile)
  (treemacs-project-follow-mode 1))

(use-package volatile-highlights
  :diminish
  :hook
  (after-init . volatile-highlights-mode)
  :custom-face
  (vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))
