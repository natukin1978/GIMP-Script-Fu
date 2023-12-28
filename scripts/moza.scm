(define (mosaic-script image drawable)
  (let* ((width (car (gimp-drawable-width drawable)))
         (height (car (gimp-drawable-height drawable)))
         (tile-size 7))
    (plug-in-pixelize RUN-NONINTERACTIVE image drawable tile-size)
    (gimp-displays-flush)))

(define (hue-chroma-script image drawable)
  (let* ((hue-range HUE-RANGE-ALL)
         (hue-offset -20)
         (lightness 5)
         (saturation -5))
    (gimp-hue-saturation drawable hue-range hue-offset lightness saturation)
    (gimp-displays-flush)))

(define (save-and-close-image image drawable)
  (let* ((filename (car (gimp-image-get-filename image))))
    (gimp-file-save RUN-NONINTERACTIVE image drawable filename filename)
    (gimp-image-clean-all image)
    (gimp-image-delete image)))

(define (apply-effects image drawable)
  (gimp-image-undo-group-start image)
  (mosaic-script image drawable)
  (hue-chroma-script image drawable)
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
  (save-and-close-image image drawable))

(script-fu-register "apply-effects"
                    "<Image>/Filters/MyScripts/Moza"
                    "Apply mosaic and adjust hue-saturation, then save and close"
                    "Your Name"
                    "Your Name"
                    "2023"
                    "*"
                    SF-IMAGE "Image" 0
                    SF-DRAWABLE "Drawable" 0)
