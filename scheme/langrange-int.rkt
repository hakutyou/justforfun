#lang scheme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: kelifrisk
;; Mail: kelifrisk@gmail.com
;; Date: 2015-11-15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lagrange Interpolation

(require plot)

(define (lang t a)
  (let* [(lst-rest (map car (append (take a (- t 1)) (drop a t))))
         (lst-drop (car (take (drop a (- t 1)) 1)))
         (n (car lst-drop))]
    (define (part-func x)
      (* (cadr lst-drop)
         (/ (apply * (map (lambda (m) (- x m)) lst-rest))
            (apply * (map (lambda (m) (- n m)) lst-rest)))))
    part-func))

(define (lang-int a)
  (define (iter t sum-func)
    (if (= t 0)
        sum-func
        (iter (- t 1)
              (lambda (x)
                (+ (sum-func x) ((lang t a) x))))))
  (iter (length a) (lambda (x) 0)))

(define (list->point-label lst)
  (define (iter lst-point lst)
    (if (null? lst)
        lst-point
        (iter (append lst-point (list (point-label (car lst)))) (cdr lst))))
  (iter '() lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example
(define a '((0.4 0.41075) (0.55 0.57815) (0.65 0.69675)
                          (0.80 0.88811) (0.90 1.02652) (1.05 1.25382)))

(define i (lang-int a))

(plot #:x-min 0 #:x-max 2 #:y-min 0 #:y-max 2
      (append (list->point-label a)
              (list (function i -2 2))))
