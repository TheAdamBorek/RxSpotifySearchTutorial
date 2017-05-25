//: Playground - noun: a place where people can play







func transform(_ integer: Int?) -> String? {
    return integer
        .map { integer in
            return "\(integer)"
    }
}














func transform(_ string: String?) -> Int? {
    let 🙈: String?? = string
        .map { Int($0) }
}














let observable = getSomeObservable()
observable
    .flatmap { return anotherObservable() } // Observable<Observable<SomeType>>



















































