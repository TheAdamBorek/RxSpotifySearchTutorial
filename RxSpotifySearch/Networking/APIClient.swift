//
// Created by Adam Borek on 05.02.2018.
// Copyright (c) 2018 Adam Borek. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol API {
    func request(_ request: APIRequest) -> Single<Data>
}

final class APIClient: API {
    private let moyaProvider = MoyaProvider<MoyaRequest>()

    func request(_ request: APIRequest) -> Single<Data> {
        return moyaProvider.rx
                .request(request.asMoyaRequest())
                .map { try $0.filterSuccessfulStatusCodes().data }
    }
}

protocol APIRequest {
    var baseURL: URL { get }
    var path: String { get }
    var method: Moya.Method { get }
    var headers: [String: String]? { get }
    var params: [String: Any] { get }
    var paramsEncoder: ParameterEncoding { get }
}

extension APIRequest {
    var headers: [String: String]? {
        return nil
    }
}

private struct MoyaRequest: TargetType {
    let baseURL: URL
    let path: String
    let method: Moya.Method
    let headers: [String: String]?
    let task: Task
    var sampleData: Data {
        return Data()
    }
}

private extension APIRequest {
    func asMoyaRequest() -> MoyaRequest {
        return MoyaRequest(baseURL: baseURL, path: path, method: method, headers: headers, task: .requestParameters(parameters: params, encoding: paramsEncoder))
    }
}
