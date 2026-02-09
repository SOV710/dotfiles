;;; $DOOMDIR/lisp/ime.el -*- lexical-binding: t; -*-

;; Configure Rime input method after the rime package has been loaded
(after! rime
  ;; Path to the shared Rime data directory used by fcitx5
  ;; This typically contains schemas, dictionaries, and other shared resources
  (setq rime-share-data-dir "~/.local/share/fcitx5/rime/")

  ;; Directory for user-specific Rime data (e.g. user dictionaries, history)
  ;; Stored under Doom's cache directory for better isolation and portability
  (setq rime-user-data-dir (expand-file-name "rime/" doom-cache-dir))

  ;; Set the default Rime schema to a double-pinyin layout
  (setq rime-default-schema "rime_frost_double_pinyin")

  ;; Display Rime candidates using a posframe (floating child frame)
  ;; instead of the minibuffer
  (setq rime-show-candidate 'posframe)

  ;; Set Rime as the default Emacs input method
  (setq default-input-method "rime")

  ;; Conditions under which Rime should be temporarily disabled
  ;; to improve editing experience, especially when writing code
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p                 ; disable in Evil normal/visual states
          rime-predicate-after-alphabet-char-p       ; disable after ASCII letters
          rime-predicate-space-after-cc-p            ; disable after space following CJK chars
          rime-predicate-current-uppercase-letter-p  ; disable when typing uppercase letters
          )))

;; In insert state, bind C-; to toggle the current input method (Rime on/off)
(map! :i "C-;" #'toggle-input-method)

(use-package! sis
  :config
  ;; 设置英文输入法（通常是键盘布局）
  (sis-ism-lazyman-config
   "1"  ; 英文输入法的标识
   "2"  ; 中文输入法的标识，需要根据你的系统调整
   'fcitx5)  ; 或 'fcitx, 'ibus 等

  ;; 启用光标颜色模式，不同输入法显示不同颜色
  (sis-global-cursor-color-mode t)
  
  ;; 启用 respect 模式，在特定 mode 下自动切换
  (sis-global-respect-mode t)
  
  ;; 启用 context 模式，根据上下文自动切换
  (sis-global-context-mode t)
  
  ;; 启用 inline 模式，在行内英文时自动切换
  (sis-global-inline-mode t))
