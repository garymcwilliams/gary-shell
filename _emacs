;; Gary's emacs file, based on various submissions

;; add the jde path
(add-to-list 'load-path (expand-file-name "D:/tools/emacs-lisp/jde-2.3.2/lisp"))
(add-to-list 'load-path (expand-file-name "D:/tools/emacs-lisp/eieio-0.17"))
(add-to-list 'load-path (expand-file-name "D:/tools/emacs-lisp/semantic-1.4.4"))
(add-to-list 'load-path (expand-file-name "D:/tools/emacs-lisp/elib-1.0"))

;; First try to load default colors
(if (file-exists-p "H:/shell/.emacs-d-colors")
    (load-file "H:/shell/.emacs-d-colors"))

;; php syntax highlighting
(require 'php-mode)

;; default = use syntax highlighting
(global-font-lock-mode t)

;; Set the variable default-tab-width.
(setq default-tab-width 4)

;; Set the 'highlight line with point' mode
(load "hl-line")
(setq hl-line-mode t)

;; These are my settings for 17 inch monitor running 1024 x 768
;; resolution. If you change font sizes, you'll probably have to tweak
;; this.
(set-frame-height (selected-frame) 40)
(set-frame-width (selected-frame) 100)

;; do NOT add newlines if I cursor past last line in file
(setq next-line-add-newlines nil)

;; Set the frame's title. %b is the name of the buffer. %+ indicates
;; the state of the buffer: * if modified, % if read only, or -
;; otherwise. Two of them to emulate the mode line. %f for the file
;; name. Incredibly useful!
(setq frame-title-format "%b %+%+ %f")

;; highlight regions
;;(transient-mark-mode t)


;; Sets emacs to behave more like a windows app
;;(pc-selection-mode)
(require 'cua)
(CUA-mode t)
;;(CUA-mode 'emacs)


; Convert from DOS > UNIX
(defun dos-unix ()
  (interactive)
    (goto-char (point-min))
      (while (search-forward "\r" nil t) (replace-match "")))

; Convert from UNIX > DOS
(defun unix-dos ()
  (interactive)
    (goto-char (point-min))
      (while (search-forward "\n" nil t) (replace-match "\r\n")))

; Select everything
(defun select-all ()
  (interactive)
  (set-mark (point-min))
  (goto-char (point-max)))

; Select everything
;;(global-set-key "\C-a" 'select-all)

; Ctrl-Tab switches buffers
(global-set-key [(ctrl tab)] 'bury-buffer)

; Key bindings
(global-set-key "\C-g" 'goto-line)
(global-set-key [(f4)] 'revert-buffer)


;; For use of Bash shell via Cygwin on Windows 2000 (or NT), available from:
;;	     http://www.cygwin.com/
	(setq exec-path (cons "D:/cygwin/bin" exec-path))
	(setenv "PATH" (concat "D:\\cygwin\\bin;" (getenv "PATH")))
	;;
	;; NT-emacs assumes a Windows command shell, which you change
	;; here.
	;;
	(setq process-coding-system-alist '(("bash" . undecided-unix)))
	(setq binary-process-input t) 
	(setq w32-quote-process-args ?\")
	(setq shell-file-name "bash")
	(setenv "SHELL" shell-file-name) 
	(setq explicit-shell-file-name shell-file-name) 
	(setq explicit-sh-args '("-login" "-i"))

	;;
	;; This removes unsightly ^M characters that would otherwise
	;; appear in the output of java applications.
	;;
	(add-hook 'comint-output-filter-functions
		  'comint-strip-ctrl-m)
;; End of bash shell use via Cygwin section.

;; This removes unsightly ^M characters that would otherwise
;; appear in the output of java applications.
;;
(add-hook 'comint-output-filter-functions
	  'comint-strip-ctrl-m)


;; Set start-up directory with cygwin nomenclature:
(setq startup-directory "~/Personal/code/")

;; use jde for Java dev
;;(require 'jde)
;;(set-face-foreground 'jde-java-font-lock-link-face "Gold")

;; For css-mode: (from http://www.garshol.priv.no/download/software/css-mode/)
 (autoload 'css-mode "css-mode.el")
 (setq auto-mode-alist	     
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))

;; add xsd to file type supported as xml mode
(add-to-list 'auto-mode-alist '("\\.xsd\\'" . xml-mode))

;;; Bracket/brace/parentheses highlighting:
   ;; The following is the command for Emacs 20.1 and later:
(show-paren-mode 1)
   ;; * Here is some Emacs Lisp that will make the % key show the matching
   ;; parenthesis, like in vi.	In addition, if the cursor isn't over a
   ;; parenthesis, it simply inserts a % like normal.  (`Parenthesis' actually
   ;;  includes and character with `open' or `close' syntax, which usually means
   ;;  "()[]{}".)

      ;; By an unknown contributor

      (global-set-key "%" 'match-paren)

      (defun match-paren (arg)
	"Go to the matching parenthesis if on parenthesis otherwise insert %."
	(interactive "p")
	(cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	      ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	      (t (self-insert-command (or arg 1)))))

;; Made by Joe Casadonte (joc)
(defun joc-bounce-sexp ()
  "Will bounce between matching parens just like % in vi"
  (interactive)
  (let ((prev-char (char-to-string (preceding-char)))
	(next-char (char-to-string (following-char))))
	(cond ((string-match "[[{(<]" next-char) (forward-sexp 1))
		  ((string-match "[\]})>]" prev-char) (backward-sexp 1))
		  (t (error "%s" "Not on a paren, brace, or bracket")))))

(global-set-key [(control =)] 'joc-bounce-sexp)

;; Then override with local colors
(if (file-exists-p ".emacs-colors")
    (load-file ".emacs-colors"))

  ;; The following line is only if you have the JDE installed:
(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(global-hl-line-mode t nil (hl-line))
 '(jde-compiler (quote ("javac" "/d/j2sdk_1.4.1_01"))))
