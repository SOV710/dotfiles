;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "lisp/core.el")
(load! "lisp/ui.el")
(load! "lisp/org.el")
(load! "lisp/markdown.el")
(load! "lisp/treemacs.el")

(load! "lisp/sis.el")

(after! evil
  ;; Configure fcitx5 as the ISM backend
  (sis-ism-lazyman-config "1" "2" 'fcitx5)

  (sis-global-context-mode t)
  (sis-global-inline-mode t)

  ;; Enable cursor color mode
  (sis-global-cursor-color-mode t)

  ;; Enable respect mode (handles evil, prefix keys, buffer focus)
  (sis-global-respect-mode 1))
