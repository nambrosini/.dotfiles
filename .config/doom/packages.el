;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t -*-

;;; Completion

;; Overlay-based popup for corfu in terminal Emacs (emacsclient -t) on
;; Emacs < 31, where child frames are unavailable.
(package! corfu-terminal)

;;; Org

(package! org-modern)
(package! org-super-agenda)
(package! org-pomodoro)

;;; Notifications

(package! alert)
