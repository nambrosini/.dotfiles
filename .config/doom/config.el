;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; Appearance ----------------------------------------------------------------

(setq doom-font
      (font-spec :family "JetBrainsMono Nerd Font" :size 18
                 :weight 'semi-light)
      doom-big-font
      (font-spec :family "JetBrainsMono Nerd Font" :size 22)
      doom-serif-font
      (font-spec :family "JetBrainsMono Nerd Font" :weight 'light)
      doom-variable-pitch-font
      (font-spec :family "JetBrainsMono Nerd Font" :size 18))

;; nerd-icons defaults to "Symbols Nerd Font Mono", which isn't installed on
;; this machine; use the installed JetBrainsMono Nerd Font so icons render
;; instead of tofu boxes.
(setq nerd-icons-font-family "JetBrainsMono Nerd Font")
(setq doom-nerd-icons-font-family "JetBrainsMono Nerd Font")

;; Dark/light pair; Doom picks based on system light/dark setting.
(setq doom-theme '(modus-vivendi . modus-operandi))

(setq display-line-numbers-type t)

;;; Org -----------------------------------------------------------------------

(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup
        :n "M-j" #'org-metaleft
        :n "M-h" #'org-metaright)
  (setq org-directory "~/org/"
        org-log-done 'time
        org-log-into-drawer t
        org-agenda-files (directory-files-recursively org-directory "\\.org$")
        org-modern-star '("◉" "○" "◈" "◇" "*")))

(use-package org-modern
  :hook (org-mode . org-modern-mode))
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;;; Study file templates ------------------------------------------------------

(defvar my/study-root "~/org/school/"
  "Root folder containing one folder per module.")

(defvar my/study-templates
  '(("Lesson notes"  . ("~/.config/doom/templates/lesson-notes.org"  "Lessons"))
    ("Active recall" . ("~/.config/doom/templates/active-recall.org" "Reviews"))
    ("Self-test"     . ("~/.config/doom/templates/self-test.org"     "Self-Test"))))

(defun my/new-study-file ()
  "Prompt for module, template and file name; create a new org file
from the chosen template in the module's subfolder."
  (interactive)
  (let* ((all-entries (directory-files my/study-root t nil nil))
         (dirs (seq-filter #'file-directory-p all-entries))
         (modules (seq-remove
                   (lambda (d) (string-match-p "/\\.\\.?$" d))
                   (mapcar #'file-name-nondirectory dirs)))
         (module (completing-read "Module: " modules nil nil))
         (choice (completing-read "Template: " (mapcar #'car my/study-templates)))
         (tpl (cdr (assoc choice my/study-templates)))
         (dir (expand-file-name (cadr tpl)
                                (expand-file-name module my/study-root)))
         (lesson (read-string "Lesson (e.g. l3, blank to skip): "))
         (file (read-string (format "File name (in %s): " dir)))
         (path (expand-file-name file dir)))
    (when (file-exists-p path)
      (user-error "File already exists: %s" path))
    (make-directory dir t)
    (with-temp-file path
      (insert-file-contents (car tpl))
      (goto-char (point-min))
      (while (search-forward "{{MODULE}}" nil t)
        (replace-match module t t))
      (goto-char (point-min))
      (while (search-forward "{{LESSON}}" nil t)
        (replace-match lesson t t)))
    (find-file path)))

(map! :leader :desc "New study file" "n b" #'my/new-study-file)

;;; Completion ----------------------------------------------------------------

;; Corfu shows candidates in a child frame, which terminal Emacs (emacsclient
;; -t) doesn't support on Emacs < 31, so as-you-type completion never fires
;; there. corfu-terminal swaps in an overlay-based popup on TTY frames;
;; `corfu-terminal-disable-on-gui' (t by default) keeps the child-frame popup
;; in GUI frames.
(after! corfu
  (corfu-terminal-mode +1)
  ;; Pop up completion quickly (Doom defaults: delay 0.24s, prefix 2).
  (setq corfu-auto-delay 0.05
        corfu-auto-prefix 1))

;;; LSP -----------------------------------------------------------------------

;; Don't wait on idle timers.
(after! eglot (setq eglot-send-changes-idle-time 0.1))
(after! lsp-mode (setq lsp-idle-delay 0.1))

;;; Java: jdtls via eglot -----------------------------------------------------
;; Doom's :lang java module only wires up lsp-mode, so with (lsp +eglot) nothing
;; starts a server for Java buffers. Hook eglot in and configure jdtls here.

(defvar +java-jdtls-java
  "/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home/bin/java"
  "JDK used to *run* jdtls. jdtls 1.63+ requires Java 25 (osgi.ee=JavaSE 25);
it fails with exit status 13 on older JDKs. 25 is LTS.
Projects can still target any JDK; jdtls reads that from Maven/Gradle.")

;; Update with:
;;   curl -fL -o ~/.local/share/lombok/lombok.jar https://projectlombok.org/downloads/lombok.jar
(defvar +java-lombok-jar
  (or (let ((f (expand-file-name "~/.local/share/lombok/lombok.jar")))
        (and (file-exists-p f) f))
      (car (last (sort (file-expand-wildcards
                        "~/.m2/repository/org/projectlombok/lombok/1.18.*/lombok-1.18.*.jar" t)
                       #'version<))))
  "Lombok jar passed to jdtls as a javaagent.")

(add-hook! '(java-mode-local-vars-hook java-ts-mode-local-vars-hook)
           #'eglot-ensure)

(after! eglot
  (setf (alist-get '(java-mode java-ts-mode) eglot-server-programs nil nil #'equal)
        `("jdtls"
          ,(concat "--java-executable=" +java-jdtls-java)
          ,@(when +java-lombok-jar
              (list (concat "--jvm-arg=-javaagent:"
                            (expand-file-name +java-lombok-jar)))))))

;;; Languages -----------------------------------------------------------------

(after! rustic
  (setq rustic-format-on-save t))

(after! projectile
  (setq projectile-project-search-path '("~/work")))

;;; Pomodoro ------------------------------------------------------------------

(use-package org-pomodoro
  :config
  (setq org-pomodoro-length 25
        org-pomodoro-short-break-length 5
        org-pomodoro-long-break-length 30
        ;; clock into the heading when pomodoro starts
        org-pomodoro-start-to-clock t
        org-pomodoro-finished-to-clock-out t
        org-pomodoro-play-sounds t
        org-pomodoro-audio-player "mpv"
        org-pomodoro-audio-working-sound "~/.config/emacs/.local/straight/repos/org-pomodoro/resources/bell.wav"
        org-pomodoro-audio-overtime-sound "~/.config/emacs/.local/straight/repos/org-pomodoro/resources/bell.wav"
        org-pomodoro-audio-break-sound "~/.config/emacs/.local/straight/repos/org-pomodoro/resources/bell-multiple.wav")
        org-pomodoro-ticking-sound "~/.config/emacs/.local/straight/repos/org-pomodoro/resources/tick.wav"
  :bind ("C-c C-p" . org-pomodoro))

;;; Notifications -------------------------------------------------------------

(use-package alert
  :config
  ;; Linux: DBus notifications; macOS: terminal-notifier; Windows: toast
  (setq alert-default-style 'notifications))

;;; Terminal ------------------------------------------------------------------

(use-package vterm
  :ensure t
  :bind (("C-c v" . vterm)
         :map vterm-mode-map
         ("M-p" . vterm-send-up)      ;; Replicates standard shell/ESS history up
         ("M-n" . vterm-send-down)    ;; Replicates standard shell/ESS history down
         ("C-c c" . vterm-copy-mode)) ;; Quick toggle for Emacs text selection
  :custom
  (vterm-max-scrollback 100000)       ;; Prevents truncation of long AI outputs
  (vterm-kill-buffer-on-exit t)
  :config
  ;; Distinct, high-contrast dark canvas for the terminal buffer
  (add-hook 'vterm-mode-hook
            (lambda ()
              (face-remap-add-relative 'default :background "#263238"))))

;;; Keybindings ---------------------------------------------------------------

(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "s-!") 'shell-command)
