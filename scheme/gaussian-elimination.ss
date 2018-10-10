#lang scheme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: kelifrisk
;; Mail: kelifrisk@gmail.com
;; Date: 2015-12-19
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gaussian Elimination

(define (gauss-elim A)
  (define (iter c ret-line left-line)
    (let ([res (let ([first-line (car left-line)]
                     [left-line (cdr left-line)])
                 (map (lambda (y)
                        (map (lambda (i j)
                               (- i j))
                             y
                             (map (lambda (x)
                                    (* x (/ 1 (list-ref first-line c))
                                       (list-ref y c)))
                                  first-line)))
                      left-line))])
      (if (null? res)
          ret-line
          (iter (+ c 1) (append ret-line (list (car res))) res))))
  (let ([sorted-A (sort A (lambda (x y) (> (car x) (car y))))])
    (iter 0 (list (car sorted-A)) sorted-A)))

(define (solve-value target-matrix)
  (define (list-ref-right x c)
    (list-ref (reverse x) c))

  (let ([reversed-A (reverse target-matrix)])
    (map (lambda (x c)
           (let iter ([res (list-ref-right x 0)]
                      [cc c])
             (/ (if (= 0 cc)
                    res
                    (iter
                     (- res (list-ref-right x cc))
                     (- cc 1)))
                (list-ref-right x (+ cc 1)))))
         reversed-A (range (length reversed-A)))))

(define A '((1 1 1 4)
            (4 5 6 6)
            (7 8 10 9)))

(solve-value (gauss-elim A))
