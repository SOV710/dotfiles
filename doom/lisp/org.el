;;; $DOOMDIR/lisp/org.el -*- lexical-binding: t; -*-

;;; ZWS (Zero Width Space) solution for Org emphasis in CJK text
(after! org
  (defconst +org-zws "\u200b")

  (setq prettify-symbols-unprettify-at-point t)

  ;; Fast insert ZWS
  ;; Community uses M-SPC M-SPC; keep it as-is.
  (defun +org-insert-zws ()
    "Insert one ZERO WIDTH SPACE."
    (interactive)
    (insert +org-zws))

  ;; If you prefer inserting a *pair* of ZWS and keep cursor between them:
  (defun +org-insert-zws-pair ()
    "Insert two ZERO WIDTH SPACEs and move point between them."
    (interactive)
    (insert +org-zws +org-zws)
    (backward-char 1))

  ;; Optional alternative key (Doom localleader): SPC m z
  (map! :map org-mode-map
         :i "C-," #'+org-insert-zws
         :i "C-." #'+org-insert-zws-pair))


;; Wayland clipboard: strip ZWS when copying to system clipboard
;; (Only enables when wl-copy/wl-paste are available.)
(when (and (eq system-type 'gnu/linux)
           (executable-find "wl-copy")
           (executable-find "wl-paste"))
  (defvar +wl-copy-process nil
    "Process handle for the current wl-copy operation.")

  (defun +wl-copy (text)
    "Copy TEXT to Wayland clipboard, stripping zero-width spaces."
    (setq +wl-copy-process
          (make-process :name "wl-copy"
                        :buffer nil
                        :command '("wl-copy" "-f" "-n")
                        :connection-type 'pipe
                        :noquery t))
    (process-send-string +wl-copy-process
                         (replace-regexp-in-string "\u200b" "" text))
    (process-send-eof +wl-copy-process))

  (defun +wl-paste ()
    "Paste from Wayland clipboard, stripping carriage returns."
    (if (and +wl-copy-process (process-live-p +wl-copy-process))
        nil ; return nil if we're the current paste owner
      ;; Process the string in Emacs instead of shell to avoid escaping issues
      (let ((content (shell-command-to-string "wl-paste -n 2>/dev/null")))
        (when (> (length content) 0)
          (replace-regexp-in-string "\r" "" content)))))

  (setq interprogram-cut-function #'+wl-copy)
  (setq interprogram-paste-function #'+wl-paste))

;; indent
(setq org-list-indent-offset 4)

(setq org-startup-folded 'showall)

;; org-mode plugins
;;
;; org-modern
(after! org
  (setq org-modern-star 'replace
        org-modern-hide-stars nil
        org-modern-list '((?- . "•")
                          (?+ . "◦")
                          (?* . "▪")))
  (global-org-modern-mode))

;; org-appear
(after! org
  (setq org-hide-emphasis-markers t))

(add-hook 'org-mode-hook #'org-appear-mode)

;; org-fragtog
(add-hook 'org-mode-hook #'org-fragtog-mode)

(after! org
  (setq org-preview-latex-default-process 'dvisvgm)
  (plist-put org-format-latex-options :scale 1.25)

  (defvar org-latex-auto-preview-timer nil
    "Timer for debounced LaTeX preview.")
  
  (defun org-latex-auto-preview-visible ()
    "Automatically preview all visible LaTeX fragments with debouncing."
    (when org-latex-auto-preview-timer
      (cancel-timer org-latex-auto-preview-timer))
    (setq org-latex-auto-preview-timer
          (run-with-idle-timer
           0.1 nil
           (lambda ()
             (when (eq major-mode 'org-mode)
               (org-latex-preview '(16)))))))
  
  (add-hook 'org-mode-hook
            (lambda ()
              (org-latex-auto-preview-visible)
              (add-hook 'window-scroll-functions
                        (lambda (_win _start)
                          (org-latex-auto-preview-visible))
                        nil t))))

;; mixed-pitch
(add-hook 'org-mode-hook #'mixed-pitch-mode)

;; org-pretty-table
(add-hook 'org-mode-hook #'org-pretty-table-mode)

;; org-capture
(setq org-directory "~/org/")

;; 单独文件笔记存放的子目录
(defvar my/org-notes-dir (expand-file-name "notes/" org-directory)
  "存放独立笔记文件的目录。")


;; ─────────────────────────────────────────
;; 辅助函数：为 capture 生成新文件路径
;; 调用时提示输入标题，用标题生成文件名
;; ─────────────────────────────────────────
(defun my/org-capture-new-file ()
  "在 `my/org-notes-dir' 下生成一个新的 org 文件路径。
文件名格式：YYYYMMDDHHMMSS-slug.org"
  (unless (file-directory-p my/org-notes-dir)
    (make-directory my/org-notes-dir :parents))
  (let* ((title (read-string "笔记标题: "))
         (slug  (replace-regexp-in-string
                 "[^a-z0-9]+" "-"
                 (downcase (string-trim title))))
         (ts    (format-time-string "%Y%m%d%H%M%S"))
         (fname (format "%s-%s.org" ts slug)))
    ;; 把标题存进临时变量，供模板里 `%i' 替换占位符时使用
    (set (make-local-variable 'my/capture-title) title)
    (expand-file-name fname my/org-notes-dir)))

;; 让模板字符串能读到上面存的标题
(defun my/capture-get-title ()
  (if (boundp 'my/capture-title)
      my/capture-title
    (read-string "笔记标题: ")))


;; ─────────────────────────────────────────
;; org-capture 模板定义
;; ─────────────────────────────────────────
(after! org-capture
  (setq org-capture-templates
        `(
          ;; ── 分组标题（在 capture 菜单中显示） ──────────────
          ("n" "笔记类")

          ;; 1. 普通笔记 → 新建独立文件，含完整元信息
          ("nn" "新建笔记（独立文件）"
           plain
           (file my/org-capture-new-file)   ; 目标：函数返回的新文件
           ,(string-join
             '("#+title:    %(my/capture-get-title)"
               "#+author:   %n"             ; %n = user-full-name
               "#+date:     %U"             ; %U = 非激活时间戳 [yyyy-mm-dd]
               "#+lastmod:  Time-stamp: <>"
               "#+filetags: :%^{标签(用:分隔,可为空)}:"
               "#+language: zh-CN"
               ""
               "%?")                        ; 光标落点
             "\n")
           :empty-lines 1
           :jump-to-captured t)             ; 创建后自动跳到该文件

          ;; 2. 快速想法 → 追加到 inbox.org，无需新建文件
          ("ni" "快速收集 Inbox"
           entry
           (file ,(expand-file-name "inbox.org" org-directory))
           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
           :empty-lines 1)

          ;; ── 分组 ──────────────────────────────────────────
          ("t" "任务类")

          ;; 3. TODO 任务
          ("tt" "TODO"
           entry
           (file+headline ,(expand-file-name "tasks.org" org-directory) "Tasks")
           "* TODO %^{任务名}\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?"
           :empty-lines 1)

          ;; 4. 带截止日期的任务
          ("td" "有截止日期的 TODO"
           entry
           (file+headline ,(expand-file-name "tasks.org" org-directory) "Tasks")
           "* TODO %^{任务名}\nDEADLINE: %^{截止时间}T\n:PROPERTIES:\n:CREATED: %U\n:END:\n%?"
           :empty-lines 1)

          ;; ── 分组 ──────────────────────────────────────────
          ("j" "日志类")

          ;; 5. 每日日志 → 按日期分组追加
          ("jj" "日记"
           entry
           (file+olp+datetree ,(expand-file-name "journal.org" org-directory))
           "* %?\n:PROPERTIES:\n:CREATED: %T\n:END:\n"
           :empty-lines 1
           :tree-type week)

          ;; 6. 技术笔记（嵌入式/机器人领域）→ 新建独立文件
          ("nr" "技术笔记（Robotics / Embedded）"
           plain
           (file my/org-capture-new-file)
           ,(string-join
             '("#+title:    %(my/capture-get-title)"
               "#+author:   %n"
               "#+date:     %U"
               "#+lastmod:  Time-stamp: <>"
               "#+filetags: :tech:%^{细分标签}:"
               "#+language: zh-CN"
               "#+options:  toc:nil num:nil"
               ""
               "* 背景"
               "%?"
               ""
               "* 参考")
             "\n")
           :empty-lines 1
           :jump-to-captured t))))


;; ─────────────────────────────────────────
;; 保存时自动更新 #+lastmod 字段
;; 仅在 org-mode buffer 中生效
;; ─────────────────────────────────────────
(after! org
  ;; time-stamp 会在文件头 8000 字符内搜索 Time-stamp: <> 并填入当前时间
  (setq time-stamp-active   t
        time-stamp-start    "#\\+lastmod:[ \t]*"
        time-stamp-end      "$"
        time-stamp-format   "%Y-%m-%d %H:%M:%S")

  (add-hook 'org-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'time-stamp nil :local))))


;; ─────────────────────────────────────────
;; 快捷键（Doom 风格）
;; SPC n n  → 原 Doom 绑定，触发 org-capture
;; 这里额外绑一个直达"新建笔记"的键
;; ─────────────────────────────────────────
(map! :leader
      (:prefix ("N" . "笔记")
       :desc "新建笔记（独立文件）" "n" #'(lambda () (interactive)
                                              (org-capture nil "nn"))
       :desc "快速 Inbox"          "i" #'(lambda () (interactive)
                                              (org-capture nil "ni"))
       :desc "技术笔记"            "r" #'(lambda () (interactive)
                                              (org-capture nil "nr"))))
