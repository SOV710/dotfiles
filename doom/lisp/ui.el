;;; $DOOMDIR/lisp/ui.el -*- lexical-binding: t; -*-

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept.

(setq doom-font (font-spec :family "Smile Nerd Font Mono" :size 22)
      doom-variable-pitch-font (font-spec :family "LXGW Wenkai" :size 22)
      doom-symbol-font (font-spec :family "Symbols Nerd Font" :size 22))

;; 使用 doom-init-fonts-h 钩子，确保在所有字体初始化之后执行
(add-hook! 'doom-init-ui-hook
  (defun +my-setup-fonts ()
    ;; CJK fallback
    (dolist (charset '(kana han cjk-misc bopomofo))
      (set-fontset-font t charset (font-spec :family "LXGW Wenkai")))
    
    ;; Emoji fallback - 使用 Noto Emoji（单色版本）
    ;; 注意：彩色 Emoji 需要 Emacs 编译时支持
    (set-fontset-font t 'emoji (font-spec :family "Noto Color Emoji") nil 'prepend)
    (set-fontset-font t 'symbol (font-spec :family "Noto Color Emoji") nil 'append) ; 用 append 避免覆盖其他符号
    
    ;; 覆盖所有 Emoji Unicode 范围
    (set-fontset-font t '(#x1F000 . #x1FAFF) (font-spec :family "Noto Color Emoji") nil 'prepend)
    (set-fontset-font t '(#x2600 . #x27BF) (font-spec :family "Noto Color Emoji") nil 'prepend)))



;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(after! display-line-numbers
  (dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
    (add-hook hook (lambda () (setq-local display-line-numbers 'relative)))))

;; scolling smoothly but not paging
(setq scroll-margin 5                    ; 光标距离顶部/底部 5 行时开始滚动
      scroll-conservatively 101          ; 每次只滚动一行，不跳页
      scroll-preserve-screen-position t  ; 保持光标在屏幕中的相对位置
      scroll-step 1                      ; 每次滚动 1 行
      auto-window-vscroll nil)           ; 禁用自动垂直滚动优化（提高性能）

;; 鼠标滚轮平滑滚动
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))  ; 每次滚动 1 行
      mouse-wheel-progressive-speed nil              ; 禁用滚轮加速
      mouse-wheel-follow-mouse t)                    ; 滚轮跟随鼠标位置


