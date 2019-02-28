<!--<img src="vxd-logo.gif" width="215" height="84" /> -->


## MINUS: MInimial problem NUmerical continuation Solver
This package originated in solving medium-sized  (degree > 100) square problems
(ie, exactly-determined, 0-dimensional), notably in computer vision where
trifocal minimal problems from points and lines are of importance (as in
curve-based structure from motion, where lines are tangents to curves).
As of this date, such problems are too high degree to be solved symbolically.
 
For more details, see the
[website](http://multiview-3d-drawings.sourceforge.net)

## Usage
For use in your program, we provide a header-only library.
Simply do:
```
#include <minus>
```

Examples are avaialble in the tests/ subfolder
In your program, you can then use

```
  ptrack<14>(&VNAG_DEFAULT, start_sols, params, solutions);

```
To solve a 14x14 precompiled trifocal problem from lines on points ("Chicago").
You do need to know the size of the system in advance, for efficiency reasons.
This is not dynamic code, so no allocations are performed.

## Hacking

Every single advanced development tool works best under Linux.

### Mem leak with AddressSanitizer from Google

https://github.com/google/sanitizers/wiki/AddressSanitizer

You can build release with this
This is very fast
Highly recommended for developing efficient code using vectors, pointers and buffers

Add this to `MINUS_EXTRA_CMAKE_CXX_FLAGS`:
```-fsanitize=address -fno-omit-frame-pointer```

Now recompile minus and simply run it.
If nothing happens, you're golden. In the event of any memleak, there will be
a colorful output showing where it came from, specially under Linux.

### Profiling

The best way is with kcachegrind + valgrind, by far. 
See https://www.blogger.com/comment.g?blogID=7395958&postID=116062684092668856&bpli=1&pli=1

In any system without valgrind or kcachegrind (eg, Macs), the easiest way is with gprof

Expect your program to take very very long - so reduce the problem / iterations
before running.

### Compilers

This was extensively tested with GCC 5
Do not use GCC 4

Intel ICC compiler with the same optimization flags as usual in Minus provided
a 2x DECREASE in speed. TODO: try other ICC-specific optimization flags


## Authors

Adapted and improved over Anton Leykin's and Timothy Duff's codes from Macaulay2 by
Ricardo Fabbri. The core code grew out of Macaulay2/e/NAG.cpp.

## Acknowledgements
This grew as part of ICERM's 2018 Nonlinear Algebra Program (Computer Vision
Working group) and 2019 Algebraic Vision research cluster. Both co-organized by
the authors.
