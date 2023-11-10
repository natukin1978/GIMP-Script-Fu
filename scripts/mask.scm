(define (fill-areas image drawable)
  (let* ((selection (car (gimp-selection-save image)))) ; 選択領域を保存
    (gimp-context-push) ; 現在のコンテキスト（色などの設定）を保存

    ; 選択領域を背景色で塗りつぶす
    (gimp-edit-fill drawable BACKGROUND-FILL)

    ; 選択領域を反転（全体から選択領域を引くことで選択領域外を選択）
    (gimp-selection-invert image)

    ; 選択領域（元の選択領域の外側）を描画色で塗りつぶす
    (gimp-edit-fill drawable FOREGROUND-FILL)

    ; 元の選択領域を復元
    (gimp-selection-load selection)

    ; 選択領域を解除
    (gimp-selection-none image)

    (gimp-context-pop) ; 保存していたコンテキストを復元
    (gimp-displays-flush) ; 画面の更新
  )
)

(script-fu-register "fill-areas"
                    "<Image>/Filters/MyScripts/Create mask"
                    "Fill selected area with background color, and outside with foreground color"
                    "Your Name"
                    "Your Name"
                    "2023"
                    "*"
                    SF-IMAGE "Image" 0
                    SF-DRAWABLE "Drawable" 0)
