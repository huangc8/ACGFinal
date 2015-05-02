Sketch name: saliency_gbvs

- How to run saliency generation on different images
    1. Go to saliency_gbvs.pde, change the String variable <filename> at line 7
       to the image name you want to run;

    2. Go to gabor.pde, the <lambda> value at line 23 decides the sampling wavelength
       and kernel size of the Gabor filer. For images smaller than 200x200px, 5.0 is
       fine; for larger ones up to 600x600px, 10.0 - 15.0 should be good. I..haven't
       tested on larger ones.

    3. Go to sample.pde, if your image is smaller than 200x200px, you could test around
       with the <sample_size> variable at line 17 set to 5 instead of 9. Please use odd
       number.

- The extraction result will be saved to gabor_<filename>, the downsampled final result
  will be saved to sal_<filename>. eg. running the algorithm on "MB.jpg" will result
  in "gabor_MB.jpg" and "sal_MB.jpg".