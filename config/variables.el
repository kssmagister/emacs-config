#+TITLE: Emacs Configuration Variables
#+PROPERTY: header-args:emacs-lisp :tangle ./variables.el

* System Detection and Path Variables
#+begin_src emacs-lisp
  ;; Betriebssystemerkennung
  (defvar is-windows (eq system-type 'windows-nt))
  (defvar is-linux (eq system-type 'gnu/linux))

  ;; Windows-Username ermitteln
  (defun get-windows-username ()
    (when is-windows
      (getenv "USERNAME")))

  ;; Home-Verzeichnis setzen
  (defvar my-home-directory
    (cond (is-windows (concat "C:/Users/" (get-windows-username) "/"))
	  (is-linux "~/")
	  (t (getenv "HOME"))))

  ;; Syncthing-Verzeichnis setzen
  (defvar my-syncl-directory
    (cond 
     (is-windows "C:/Users/SyncthingServiceAcct/Syncl/") ;; Immer auf diesen Ordner zugreifen, egal welcher Benutzer
     (is-linux (expand-file-name "Syncl/" my-home-directory))
     (t nil)))

  ;; Dropbox-Verzeichnis setzen, wenn als RutzD eingeloggt
  (defvar my-dropbox-directory
    (when (and is-windows (string= (get-windows-username) "RutzD"))
      "C:/Users/RutzD/Dropbox/"))


(defvar my-org-agenda-directory
  (cond
   (is-windows
    (let ((directories '()))
      (when (and my-dropbox-directory (file-exists-p my-dropbox-directory))
	(push (expand-file-name "orgmode/agendafiles/" my-dropbox-directory) directories))
      (when (and my-syncl-directory (file-exists-p my-syncl-directory))
	(push (expand-file-name "orgmode/agendafiles/" my-syncl-directory) directories))
      directories))
   (is-linux
    (let ((directory (expand-file-name "orgmode/agendafiles/" my-home-directory)))
      (if (file-exists-p directory)
	  (list directory)
	nil)))
   (t nil)))

  ;; Org-roam-Verzeichnis setzen
  (defvar my-orgroam-directory
    (when my-syncl-directory
      (expand-file-name "orgroam/" my-syncl-directory)))

  ;; Config-Verzeichnis innerhalb des Emacs-Directories setzen
  (defvar my-config-dir (expand-file-name "Config" user-emacs-directory))
#+end_src

(defvar my-user-full-name "Daniel Rutz")
(defvar my-user-mail-address "daniel.rutz@kantisargans.ch")
