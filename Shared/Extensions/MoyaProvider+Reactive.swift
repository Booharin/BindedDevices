//
//  Moya+Rx.swift
//  SharedServices
//
//  Created by Попов Владислав on 16.09.2020.
//

import Moya
import RxSwift

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {

    /// Designated request-making method.
    ///
    /// - Parameters:
    ///   - token: Entity, which provides specifications necessary for a `MoyaProvider`.
    ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Single response object.
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Result<Moya.Response, Moya.MoyaError>> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                single(.success(result))
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }

    func request<T>(_ token: Base.Target,
                    type: T.Type,
                    callbackQueue: DispatchQueue? = nil,
                    intercepter: @escaping (Result<Moya.Response, Moya.MoyaError>) -> Result<T, Error>) -> Single<T> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                let convertedResult = intercepter(result)
                switch convertedResult {
                case .success(let data):
                    single(.success(data))
                case .failure(let error):
                    single(.error(error))
                }
            }

            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}
