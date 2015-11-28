#lang scheme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: kelifrisk
;; Mail: kelifrisk@gmail.com
;; Date: 2015-11-15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Newton Interpolating polynomial

(require plot)

(define (car-diff af ab)
  (map - (map car af) (map car ab)))

(define (newton-int a)
  (define (iter mid-res t res-lst)
    (let* [(mid-res-f (drop mid-res 1))
           (mid-res-l (drop-right mid-res 1))
           (res (map / (map - mid-res-f mid-res-l)
                     (car-diff (drop a t) (drop-right a t))))]
      (if (null? (cdr res))
          (append res-lst res)
          (iter res (+ t 1) (append res-lst (list (car res)))))))
  (define result (iter (map cadr a) 1 (list (cadar a))))
  (define (temp-func x)
    (define (iter left-result left-x sum)
      (if (null? left-x)
          sum
          (iter (cdr left-result)
                (cdr left-x)
                (+ sum (* (car left-result)
                          (apply * (map
                                    (lambda (lval)
                                      (- x lval)) left-x)))))))
    (iter (reverse result) (drop (reverse (map car a)) 1) (car result)))
  temp-func)

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

(define i (newton-int a))

(plot #:x-min 0 #:x-max 2 #:y-min 0 #:y-max 2
      (append (list->point-label a)
              (list (function i -2 2))))

