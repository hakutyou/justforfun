#lang scheme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: kelifrisk
;; Mail: kelifrisk@gmail.com
;; Date: 2015-11-19
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Piecewise Linear Interpolation

(require plot)

(define (piece-line a)
  (let* [(y (sort a (lambda (x y) (< (car x) (car y)))))
         (car-y (map car y))]
    (define (part-func x)
      (define (iter iter-a c)
        (if (or (null? (cddr iter-a))
                (> (cadr iter-a) x))
            (take (drop y c) 2)
            (iter (cdr iter-a) (+ c 1))))
      (let* [(two-point (iter car-y 0))
             (k (/ (apply - (map cadr two-point))
                   (apply - (map car two-point))))
             (first-point (car two-point))
             (b (- (cadr first-point) (* k (car first-point))))]
        (+ b (* x k))))
    part-func))

(define (list->point-label lst)
  (define (iter lst-point lst)
    (if (null? lst)
        lst-point
        (iter (append lst-point (list (point-label (car lst)))) (cdr lst))))
  (iter '() lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example
(define a '((1 2) (3 2) (2 1) (4 2) (5 3)))
(define i (piece-line a))

(plot #:x-min 0 #:x-max 5 #:y-min 0 #:y-max 5
      (append (list->point-label a)
              (list (function i 0 5))))