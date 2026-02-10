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

;; Auto-insert template for new Org files
(defun +org/insert-file-template ()
  "Insert metadata template when opening a new empty Org file."
  (when (and (buffer-file-name)           ; file is backed by disk
             (string-suffix-p ".org" (buffer-file-name)) ; is a .org file
             (= (buffer-size) 0))         ; file is empty
    (let ((title (read-string "Title: ")))
      (insert "#+title: " title "\n"
              "#+author: SOV710\n"
              "#+date: " (format-time-string "%Y-%m-%d %T") "\n"
              "#+description: ")
      (save-excursion (insert "\n")))))   ; leave cursor after #+description:

(add-hook 'org-mode-hook #'+org/insert-file-template)
