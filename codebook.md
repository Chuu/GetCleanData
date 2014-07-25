Interpreting Column Names
-------------------------
Each column names consists of a prefix signifying what domain the data belongs to.  Interpreting the rest of the column name depends on what the prefix was.  There are currently three prefixes -- "t", "f", and "a".  These correspond to "Time Domain", "Frequency Domain", and "Angle".  Time Domain and Frequency Domain are interpreted in one way, Angle a separate way.

# Time Domain / Frequency Domain Variable Convention

If the variable name beings with a "t" or "f", then the full name can be broken into four parts.  They correspond to:

- A single lower-case "t" or "f" signifying if the data point is in the Time or Frequency Domain
- The type signal being measured
- The specific statistic of the signal being measured
- The domain specifier

The last three fields are separated via a period.  The first field (i.e. t or f) is not.  Some example names following this convention are below:

- tGravityAcc.mean.X
- tBodyGyroJerk.std.Z
- fBodyGyro.std.Y

The naming convention for the statistic being measured is as below:

- mean: Mean value
- std: Standard deviation
- mad: Median absolute deviation 
- max: Largest value in array
- min: Smallest value in array
- sma: Signal magnitude area
- energy: Energy measure. Sum of the squares divided by the number of values. 
- iqr: Interquartile range 
- entropy: Signal entropy
- arCoeff: Autorregresion coefficients with Burg order equal to 4
- correlation: correlation coefficient between two signals
- maxInds: index of the frequency component with largest magnitude
- meanFreq: Weighted average of the frequency components to obtain a mean frequency
- skewness: skewness of the frequency domain signal 
- kurtosis: kurtosis of the frequency domain signal 
- bandsEnergy: Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle: Angle between to vectors.

# Angle Domain Variable Convention

If the variable name begins with an "a", then the full name is broken into three parts.  They correspond to:

- The prefix "a" that notes this measurement is in the "angle" domain"
- The first vector element
- The second vector element

The last two fields are separated via a period.  The first field (i.e. "a") is not.  Some example names following this convention are below:

- atBodyAccMean.gravity
- atBodyGyroJerkMean.gravityMean
