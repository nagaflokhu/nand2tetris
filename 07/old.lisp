(defun handle (line)
    (let* ((line (make-string-input-stream line))
           (command (string-downcase (read line nil)))
           (args))
          (do ((el (read line nil) (read line nil)))
              ((null el))
              (setf args (append args `(,el))))
          (funcall (symbol-function
                    (find-symbol
                     (string-upcase
                         (concatenate 'string "handle-" (string command)))))
                   args)))

(defun handle-add (args)
    '(@1 D=A @SP AM=M-D D=M @x M=D ; SP-- x=*SP 
       @1 D=A @SP AM=M-D D=M @x D=D+M @SP A=M M=D)) ;SP-- D=*SP D=D+x *SP=D

(defun handle-pop (args)
    (let ((segment (car args))
          (num (cadr args)))
         (funcall (symbol-function
                   (find-symbol
                    (string-upcase
                        (concatenate 'string "pop-" (string segment)))))
                  num)))

(defun pop-local (offset)
    `(@1 D=A @SP M=M-D ; SP--
       @LCL D=M ; D = LCL
       ,(intern (concatenate 'string "@" (princ-to-string offset))) ; @ offset
       D=D+A @addr M=D ; addr = LCL + offset
       @SP A=M D=M @addr A=M M=D)) ;*addr = *SP

(defun handle-push (args)
    (let ((segment (car args))
          (num (cadr args)))
         (funcall (symbol-function
                   (find-symbol
                    (string-upcase
                        (concatenate 'string "push-" (string segment)))))
                  num)))

(defun push-local (offset)
    `(,(intern (concatenate 'string "@" (princ-to-string offset))) ; @offset
       D=A @LCL A=M+D D=M ; D = *(LCL + offset)
       @SP A=M M=D ; *SP=D
       @1 D=A @SP M=M+D)) ; SP++

(defun main (args)
    (setf filename (car args))
    (print (with-open-file (code filename)
        (let ((final))
            (do ((line (read-line code nil) (read-line code nil)))
                ((null line) final)
                (let* ((//? (search "//" line))
                       (empty? (or (eq //? 0)
                                   (string= line ""))))
                       (unless empty?
                           (setf final (concatenate 'string final 
                                                    (handle line)
                                                    '(#\newline))))))))))