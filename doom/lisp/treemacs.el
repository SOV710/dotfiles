;;; $DOOMDIR/lisp/treemacs.el -*- lexical-binding: t; -*-

;; project.el
(after! project
  (setq project-vc-extra-root-markers
        '(".project" ".project.el" ".projectile"
          "go.mod" "Cargo.toml" "pyproject.toml"
          "compile_commands.json" "CMakeLists.txt")))

;; inline images rendering
;; (setq org-startup-with-inline-images t)

;; toggle treemacs
(map! :after treemacs
      :leader
      :desc "Treemacs select window"
      "e" #'treemacs-select-window)
