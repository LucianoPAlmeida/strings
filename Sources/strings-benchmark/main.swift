
import Benchmark
import strings

benchmark("Levenshtein distance") {
  let s1 = "djaslkdjakldjsakldjaskljdaklsjdklasjdlkasjdlkasjdklsajdlkasjdklasjdlkjsakld"
  let s2 = "ej;kqwejwklqiwoqpieopwieopwqieopwqiecjsdk;lajkljsalkd;adkajskldjsklajdakls;djl;dasjkldasljdklsa;ds"
  
  let _ = s1.levenshteinDistance(to: s2)
}

benchmark("Levenshtein distance with equal start and end") {
  let s1 = "djaslkdjakldjsakldjaskljdaklsjdklasjdlkasjdlkasjdklsajdlkasjdklasjdlkjsakld"
  let s2 = "djaslkdjakldjsakldjaskljdaklopwqieopwqiecjsdk;lajkljsalkd;adkajskldjsklajdakls;djl;dklasjdlkjsakld"
  
  let _ = s1.levenshteinDistance(to: s2)
}

Benchmark.main()
