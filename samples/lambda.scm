(define (each arr block)
  (if (null? (cdr arr))
    (block (car arr))
    (begin (block (car arr))
           (each (cdr arr) block))))

(define arr '(1 1 2 3 5))
(define block (lambda (item) (begin (display item) (newline))))

(each arr block)
