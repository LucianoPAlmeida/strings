
import Benchmark
import strings

func random(ofLength length: Int) -> String {
  guard length > 0 else { return "" }
  let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  var randomString = ""
  for _ in 1...length {
      randomString.append(base.randomElement()!)
  }
  return randomString
}

benchmark("Levenshtein distance", settings: Iterations(500)) {
  let s1 = "djaslkdjakldjsakldjaskljdaklsjdklasjdlkasjdlkasjdklsajdlkasjdklasjdlkjsakld"
  let s2 = "ej;kqwejwklqiwoqpieopwieopwqieopwqiecjsdk;lajkljsalkd;adkajskldjsklajdakls;djl;dasjkldasljdklsa;ds"
  
  let _ = s1.levenshteinDistance(to: s2)
}

benchmark("Levenshtein distance with equal start and end", settings: Iterations(500)) {
  let s1 = "djaslkdjakldjsakldjaskljdaklsjdklasjdlkasjdlkasjdklsajdlkasjdklasjdlkjsakld"
  let s2 = "djaslkdjakldjsakldjaskljdaklopwqieopwqiecjsdk;lajkljsalkd;adkajskldjsklajdakls;djl;dklasjdlkjsakld"
  
  let _ = s1.levenshteinDistance(to: s2)
}

let string1 = random(ofLength: 1_000)
let string2 = random(ofLength: 1_200)

benchmark("Levenshtein distance random large string", settings: Iterations(100)) {
  let _ = string1.levenshteinDistance(to: string2)
}

let longString1 = random(ofLength: 5_000)
let longString2 = random(ofLength: 6_000)

benchmark("Levenshtein distance random super large string", settings: Iterations(1)) {
  let _ = longString1.levenshteinDistance(to: longString2)
}

Benchmark.main()
