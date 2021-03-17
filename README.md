# strings

Just playing around with strings...
A collection of string algorithms implemented in order to learn a bit more about them.

## Levenshtein 

An implementation of `Levenshtein` distance algorithm with a few algorithms and swift optimization.
Step by step:

* An optimization by trimming equal prefixes and suffixes from source and destination and since it doesn't affect the result and we can reduce the cost. Example `"abcd" -> "auid"` == `"bc" -> "ui"`.

* Early exit for empty cases.

* Allocate two rows (current and previous) which at the initial stage of the algorithm is first and second row initialized accordingly the first row is `0...destination.count` and second row is `1` at initial position and all zeros. Note that the [original algorithm pseudo code](https://en.wikipedia.org/wiki/Levenshtein_distance) describes a matrix `source.count` x `destination.count` but since though the algorithm iterations it only operates in terms of the current row and the previous a size allocation optimization can be done.

* Iterate through "all the rows" calculating the minimum of insertion, deletion and substitution + 1. 
Pseudo code:

```
if s[i] = t[j]:
    substitutionCost := 0
else:
    substitutionCost := 1

d[i, j] := minimum(d[i-1, j] + 1,                   // deletion
                   d[i, j-1] + 1,                   // insertion
                   d[i-1, j-1] + substitutionCost)  // substitution
```

Given that we don't have the whole matrix, the iteration is done by at the end of operating the current row we swap the previous and current so the previous row becomes the current a we reuse the area which was the previous(that will be discarded) for operate the new current initializing the first position of the current accordingly.

* After operate in all rows we get the distance.

* Reference: 
    * https://en.wikipedia.org/wiki/Levenshtein_distance

## Jaro and Jaro-Winkler

* Reference: 
    * https://www.geeksforgeeks.org/jaro-and-jaro-winkler-similarity/

## Hamming

* The Hamming distance between two strings of equal length is the count of positions in which the caracter is different in the 
between the two.

## Others
* Implement other algorithms e.g. Hamming distance and Damerau–Levenshtein(differs from the Levenshtein by including also transponsitions on the calculation in addition to the insertion, substitution and deletion).
