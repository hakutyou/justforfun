#lang scheme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: kelifrisk
;; Mail: kelifrisk@gmail.com
;; Date: 2015-11-19
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Piecewise Hermite Interpolation

(require plot)

(define (piece-hermite a)
  (let* [(y (sort a (lambda (x y) (< (car x) (car y)))))
         (car-y (map car y))]
    (define (part-func x)
      (define (iter iter-a c)
        (if (or (null? (cddr iter-a))
                (> (cadr iter-a) x))
            (take (drop y c) 2)
            (iter (cdr iter-a) (+ c 1))))
      (let* [(two-point (iter car-y 0))
             ;(k (/ (apply - (map cadr two-point))
             ;      (apply - (map car two-point))))
             (1st-point (car two-point))
             (2rd-point (cadr two-point))
             (xk (car 1st-point))
             (xk+1 (car 2rd-point))
             (fk (cadr 1st-point))
             (fk+1 (cadr 2rd-point))
             (fkp (caddr 1st-point))
             (fk+1p (caddr 2rd-point))
             ;(b (- (cadr first-point) (* k (car first-point))))
             ]
        (+ (* (sqr (/ (- x xk+1)
                      (- xk xk+1)))
              (+ 1 (* 2 (/ (- x xk) (- xk+1 xk))))
              fk)
           (* (sqr (/ (- x xk)
                      (- xk+1 xk)))
              (+ 1 (* 2 (/ (- x xk+1) (- xk xk+1))))
              fk+1)
           (* (sqr (/ (- x xk+1)
                      (- xk xk+1)))
              (- x xk)
              fkp)
           (* (sqr (/ (- x xk)
                      (- xk+1 xk)))
              (- x xk+1)
              fk+1p))
      ))
    part-func))

(define (list->point-label lst)
  (define (iter lst-point lst)
    (if (null? lst)
        lst-point
        (iter (append lst-point (list (point-label (car lst)))) (cdr lst))))
  (iter '() lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example
(define a '((0 0 0) (1 1 1) (2 4 4) (3 9 6)))
(define i (piece-hermite a))

(plot #:x-min 0 #:x-max 9 #:y-min 0 #:y-max 9
      (append (list->point-label a)
              (list (function i 0 9))))

