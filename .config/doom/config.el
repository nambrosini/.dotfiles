;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

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
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 18))

;; nerd-icons defaults to "Symbols Nerd Font Mono", which isn't installed on
;; this machine; use the installed JetBrainsMono Nerd Font so icons in the
;; modeline, dired, dashboard etc. render instead of tofu boxes.
(setq nerd-icons-font-family "JetBrainsMono Nerd Font")
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme '(doom-gruvbox    . doom-gruvbox-light))
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup
        :n "M-j" #'org-metaleft
        :n "M-h" #'org-metaright)
  (setq org-directory "~/org/"
        org-log-done 'time
        org-log-into-drawer t
        org-agenda-files (list "~/org/school.org"
                                "~/org/home.org"
                                "~/org/work.org")))

(after! projectile
  (setq projectile-project-search-path '("~/work")))

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

;; LSP/eglot may also be slow: don't wait on idle timers.
(after! eglot (setq eglot-send-changes-idle-time 0.1))
(after! lsp-mode (setq lsp-idle-delay 0.1))


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;Compilation command on save for rust
(after! rustic
  (setq rustic-format-on-save t))

;;; Java: jdtls via eglot.
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

(after! org
  (setq org-directory "~/org/"
        org-agenda-files (directory-files-recursively org-directory "\\.org$")))

(use-package org-modern
  :hook (org-mode . org-modern-mode))
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
