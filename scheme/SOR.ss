#lang racket
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: kelifrisk
;; Mail: kelifrisk@gmail.com
;; Date: 2015-12-25
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Successive Over Relaxation

(define (sor mat x vec times)
  (let* ([built-size (length vec)]
         [built-list (build-list built-size values)])
    (define (iter times)
      (if (= times 0)
          x
          (begin
            (map
             (lambda (c map-vec map-mat)
               (vector-set*!
                x
                c
                (- (vector-ref x c)
                   (/ 
                    (* omega
                       (- map-vec
                          (foldr + 0
                                 (map
                                  (lambda (c)
                                    (* (list-ref map-mat c)
                                       (vector-ref x c)))
                                  built-list))))
                    built-size))))
             built-list vec mat)
            (iter  (- times 1)))))
    (iter times)))

(define (norm-2times vec)
  (sqrt
   (apply + (vector->list
             (vector-map (lambda (x) (* x x))
                         vec)))))

(define (check-diff diff)
  (define (iter)
    (if (< (abs (- (norm-2times (sor mat init-vec vec 0))
                   (norm-2times (sor mat init-vec vec 1)))) diff)
        (sor mat init-vec vec 0) 
        (iter)))
  (iter))


(define omega 1.3)
(define mat '((-4 1 1 1)
              (1 -4 1 1)
              (1 1 -4 1)
              (1 1 1 -4)))
(define vec '(1 1 1 1))
(define init-vec (vector 0 0 0 0))

(check-diff 0.000001)
