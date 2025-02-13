# strings

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://opensource.org/licenses/MIT)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-16.0-blue.svg)](https://developer.apple.com/xcode)
[![SPM](https://img.shields.io/badge/SPM-orange.svg)](https://swift.org/package-manager/)
[![Swift](https://github.com/LucianoPAlmeida/strings/actions/workflows/swift.yml/badge.svg)](https://github.com/LucianoPAlmeida/strings/actions/workflows/swift.yml)

Just playing around with strings...
It started as a collection of string algorithms implemented in order to learn a bit more about them.

Making it a package so people can import if they find useful.

## Algorithms Available
### Levenshtein 

An implementation of `Levenshtein` distance algorithm with a few algorithms and swift optimization.
Step by step:

* An optimization by trimming equal prefixes and suffixes from source and destination and since it doesn't affect the result and we can reduce the cost. Example `"abcd" -> "auid"` == `"bc" -> "ui"`.

* Early exit for empty cases.

* Allocate two rows (current and previous) which at the initial stage of the algorithm is first and second row initialized accordingly the first row is `0...destination.count` and second row is `1` at initial position and all zeros. Note that the [original algorithm pseudo code](https://en.wikipedia.org/wiki/Levenshtein_distance) describes a matrix `source.count` x `destination.count` but since through the algorithm iterations it only operates in terms of the current and the previous rows a size allocation optimization can be done.

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

### Jaro and Jaro-Winkler

* Reference: 
    * https://www.geeksforgeeks.org/jaro-and-jaro-winkler-similarity/

### Hamming

* The Hamming distance between two strings of equal length is the count of positions in which the caracter is different in the 
between the two.

### TODO
* Implement other algorithms e.g. Damerau–Levenshtein(differs from the Levenshtein by including also transponsitions on the calculation in addition to the insertion, substitution and deletion).

## Usage

Is very simple to use...

```swift
import strings

"friend".levenshteinDistance(to: "fresh") // 3
"adlsajdlsa".jaroDistance(to: "asv") // ~= 0.6222
"friend".hammingDistance(to: "frinnd") // 1
```

## Instalation

You can use The Swift Package Manager to install by adding the proper description to your `Package.swift`
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .package(url: "https://github.com/LucianoPAlmeida/strings.git", from: "0.0.1")
    ]
)
```
Then add the target as dependency

```
.target(
    name: "YOUR_TARGET_NAME",
    dependencies: [
        "strings", ... 
    ]
),

```

Or you can manually just copy the implementations into your project.

## Benchmarks 
Benchmark was there to make us strive to the most performant implementation given the knowledge of the algorithms and of the swift language.

## References 
* [.NET Conf 2020 Maximising Algorithm Performance in .NET: Levenshtein Distance by James Turner](https://www.youtube.com/watch?v=JiOYajl2Mds)
* https://en.wikipedia.org/wiki/Levenshtein_distance
* https://www.geeksforgeeks.org/jaro-and-jaro-winkler-similarity/

## Licence
**strings** is released under the [MIT License](https://opensource.org/licenses/MIT).
