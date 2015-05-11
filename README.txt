Final Project for Advanced Computer Graphics by Chi-Ning Huang and Xitu Chen
2015 Rensselaer Polytechnic Institute


- This is an interactive saccadic scanpath simulation program, together with
  saliency map generation and an eyeball saccades animation simulation. We
  implemented the saliency generation method mentioned in “Graphic-Based Visual
  Saliency”, Harel., Koch., Perona.NIPS*2007. Our scanpath generation is based off
  “Modeling of Human Saccadic Scanpaths Based on Visual Saliency”, L. Duan, H. Qiao,
  C. Wu, Z. Yeng, W. Ma, ICGEC 2013.

- All programs run on Windows 7, Processing 2.0. To run things, simply install
  Processing, then double click on any .pde file within the directory to launch
  the sketch.

- /CAT2000Samples: dataset from MIT with real human saccades data for comparison.

- /composite: Composited images each with 10 sets of data from 3 seconds of saccadic
  simulation to show trends.

- /eyeball: eye animation program; it parses a text file and outputs an animation
  sequence with specified fixation times and locations. Currently input.txt is
  default. It takes 3 seconds of saccades data for portrait_boy.jpg.

- /image_pool: sample pictures we used and generated.

- /misc_pics: miscellaneous images including gifs, bloopers, and equations used.

- /Saccadic_Scanpath: saccadic scanpath generation program

- /saliency_gbvs: saliency images generation program; please refer to
  /saliency_gbvs/README.txt if you'd like to run it.

Image sources:

* All source images used are from free and public resources. *

- Free Online Gabor filter open source Matlab implementation by N. Petkov and
  M.B. Wieling, University of Groningen,matlabserver.cs.rug.nl/edgedetectionweb/web/
- “Bo”, http://1x.com/photo/22666/category/portrait/popular-ever/bo
- “Taxi”, RyanMcGuire, http://pixabay.com/en/taxi-cab-taxicab-taxi-cab-new-york-238478/