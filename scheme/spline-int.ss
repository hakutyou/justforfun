#lang scheme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Author: kelifrisk
;; Mail: kelifrisk@gmail.com
;; Date: 2015-11-20
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spline Interpolation

(require plot)
(require math/matrix)

(define (tri x)
  (* x x x))

(define (diff-quote a)
  (define (nth-diff-quote mid-res n)
    (let* [(mid-res-f (drop mid-res 1))
           (mid-res-l (drop-right mid-res 1))
           (drop-f (drop a n))
           (drop-l (drop-right a n))]
      (map (lambda (x y z w)
             (/ (- x y)
                (- (car z) (car w))))
           mid-res-f mid-res-l drop-f drop-l)))
  (let* [(res-1 (nth-diff-quote (map cadr a) 1))
         (res-2 (nth-diff-quote res-1 2))]
    (list res-1 res-2)))

(define (spline aa S)
  (let* [(a (sort aa (lambda (x y) (< (car x) (car y)))))
         (size (length a))
         (h (map - (drop (map car a) 1)
                 (drop-right (map car a) 1)))
         (mid-f (diff-quote a))
         (f-first (* (/ 6 (car h)) (- (caar mid-f) (car S))))
         (f-last (* (/ 6 (car (take-right h 1)))
                    (- (cdr S) (car (take-right (car mid-f) 1)))))
         (f (append (list f-first)
                    (map (lambda (x) (* 6 x)) (cadr mid-f))
                    (list f-last)))
         (miu (append (let [(hn-1 (drop-right h 1))
                            (hn (drop h 1))]
                        (map (lambda (x y) (/ x (+ x y))) hn-1 hn)) '(1)))
         (lam (append '(1)
                      (let [(hn-1 (drop-right h 1))
                            (hn (drop h 1))]
                        (map (lambda (x y) (/ y (+ x y))) hn-1 hn))))]
    (define (iter x y mat)
      (cond [(>= x size) (iter 0 (+ y 1) mat)]
            [(>= y size) mat]
            [(= y x) (iter (+ 1 x) y (append mat '(2)))]
            [(= y (+ x 1)) (iter (+ 1 x) y (append mat (list (car (drop miu x)))))]
            [(= y (- x 1)) (iter (+ 1 x) y (append mat (list (car (drop lam y)))))]
            [else (iter (+ 1 x) y (append mat (list 0)))]))
    (define (part-func x)
      (define (pos iter-a c)
        (if (or (null? (cddr iter-a))
                (> (cadr iter-a) x))
            c
            (pos (cdr iter-a) (+ c 1))))
      (let* [(xx (map car a))
             (y (map cadr a))
             (M (matrix->list (matrix*
                               (matrix-inverse (list->matrix size size (iter 0 0 '())))
                               (list->matrix size 1 f))))
             (j (pos xx 0))
             (Mj (car (drop M j)))
             (Mj+1 (car (drop M (+ j 1))))
             (xj (car (drop xx j)))
             (xj+1 (car (drop xx (+ j 1))))
             (yj (car (drop y j)))
             (yj+1 (car (drop y (+ j 1))))
             (hj (car (drop h j)))]
        (+ (* Mj (/ (tri (- xj+1 x))
                    (* 6 hj)))
           (* Mj+1 (/ (tri (- x xj))
                      (* 6 hj)))
           (* (- yj (/ (* Mj (sqr hj)) 6))
              (/ (- xj+1 x)
                 hj))
           (* (- yj+1 (/ (* Mj+1 (sqr hj)) 6))
              (/ (- x xj)
                 hj)))))
    part-func))

(define (list->point-label lst)
  (define (iter lst-point lst)
    (if (null? lst)
        lst-point
        (iter (append lst-point (list (point-label (car lst)))) (cdr lst))))
  (iter '() lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Example
(define a '((27.7 4.1) (28 4.3) (29 4.1)
                       (30 3.0)))
(define S '(3.0 . -4.0)) ;; (= x 27.7)时的导数3.0; (= x -4.0)时的导数-4.0

(define i (spline a S))

(plot #:x-min 27.5 #:x-max 30.5 #:y-min 0 #:y-max 10
      (append (list->point-label a)
              (list (function i 27.5 30.5))))