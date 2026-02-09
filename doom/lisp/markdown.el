(after! markdown-mode
  ;; Math Syntax Highlighting
  (setq markdown-enable-math t)

  ;; 启用 GFM 扩展 (任务列表等)
  (setq markdown-make-gfm-checkboxes-buttons t)

  ;; 图片内联显示
  (setq markdown-display-remote-images t)
  (setq markdown-max-image-size '(800 . 600))

  ;; 标题视觉优化
  (setq markdown-fontify-whole-heading-line t)
  (setq markdown-enable-highlighting-syntax t)

  ;; 使用 pandoc 支持更多语法
  (setq markdown-command "pandoc --katex --standalone -f gfm")

  ;; 自动启用图片内联
  (add-hook 'markdown-mode-hook #'markdown-toggle-inline-images)

  ;; 自动对齐表格
  ;; (add-hook 'markdown-mode-hook #'markdown-toggle-gfm-table-mode)
  ;;
  ;; ;; TAB 键在表格中自动对齐
  ;; (setq markdown-table-align-p t)
  ;;
  (setq markdown-hide-markup t)  ; 隐藏 **bold** 等标记
  (setq markdown-hide-urls t))   ; 隐藏 URL

;; 2. LaTeX 公式内联预览 - org-latex-impatient
;; (use-package! org-latex-impatient
;;   :hook (markdown-mode . org-latex-impatient-mode)
;;   :config
;;   (setq org-latex-impatient-tex2svg-bin
;;         "~/node_modules/mathjax-node-cli/bin/tex2svg")
;;   (setq org-latex-impatient-delay 0.5)  ; 延迟 0.5 秒后渲染
;;   (setq org-latex-impatient-scale 1.5)) ; 调整预览大小

;; 3. 增强图片内联 (可选)
;; (use-package! markdown-inline-images
;;   :hook (markdown-mode . markdown-inline-images-mode))

;; 4. 阅读体验优化 (可选,类似 Obsidian 的专注模式)
;; (use-package! olivetti
;;   :hook (markdown-mode . olivetti-mode)
;;   :config
;;   (setq-default olivetti-body-width 100))

