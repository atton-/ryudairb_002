(define (each arr block)
  (let ((item  (car arr))
        (items (cdr arr)))
    (if (null? items)
      (block item)
      (begin (block item)
             (each items block)))))

(define arr '(1 1 2 3 5))
(define block (lambda (item) (begin (display item) (newline))))

(each arr block)

; =>
; 1
; 1
; 2
; 3
; 5
