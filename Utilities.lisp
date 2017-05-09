(defun remove-comments (code)
    "Given a string, returns the same string as a stream without any section of a line following
    a //."
    (let ((new nil))
         (do ((line (read-line code nil) (read-line code nil)))
             ((null line) (make-string-input-stream new))
             (let ((pos (search "//" line)))
                  (cond ((eql pos nil)
                         (setf new (concatenate 'string new line '(#\newline))))
                        (t (setf new (concatenate 'string new
                                                  (subseq line 0 pos) '(#\newline)))))))))

(defun remove-blanks (code)
    "Given a string, returns the same string as a stream without any blank lines and without
    space characters on the sides of the lines."
    (let ((new nil))
         (do ((line (read-line code nil) (read-line code nil)))
             ((null line) (make-string-input-stream new))
             (unless (string= line "")
                 (setf new (concatenate 'string new (trim #\space line)
                                        '(#\newline)))))))