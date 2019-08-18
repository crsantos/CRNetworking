//
//  CRNetworking.swift
//  CRNetworking
//
//  Created by Carlos Santos on 28/12/2017.
//  Copyright © 2017 crsantos.info. All rights reserved.
//

import Foundation

public protocol AuthenticatableConfig {

    var accessToken: String { get }
}

public protocol APIError: Error {

    associatedtype ErrorModel: Codable

    init(response: HTTPURLResponse, data: Data) throws

    var errorModel: ErrorModel? { get }
}

public typealias APICompletion<T: Codable, E: APIError> = (Result<T, NetworkingError<E>>) -> ()

open class CRNetworking {

    private let requester: HTTPRequester = HTTPRequester()
    private let requestSerializer: RequestSerializable

    init(with config: AuthenticatableConfig,
         requestSerializerType: RequestSerializable.Type) {

        self.requestSerializer = requestSerializerType.init(with: config)
    }

    func request<
        T: Codable,
        E: APIError> (with resourceRequest: URLResourceRequestConvertible,
                      completion: @escaping APICompletion<T, E>) {

        let request = self.requestSerializer.serializeResource(resourceRequest)

        self.requester.request(with: request) { data, response, error in

            self.handleDataTaskResponse(data: data, response: response, error: error, completion: completion)
        }
    }
}

// MARK: - Private

private extension CRNetworking {

    func handleDataTaskResponse<
        T: Codable,
        E: APIError> (data: Data?,
                      response: URLResponse?,
                      error: Error?,
                      completion: APICompletion<T, E>) {

        // 1. Check if there is an error, if so, fail immediately
        if let error = error as NSError? {

            completion(.failure(.underlyingError(error)))
            return
        }

        // 2. check if response is HTTPURLResponse, otherwise we cannot use it, fail right there
        guard let response = response as? HTTPURLResponse else {

            completion(.failure(.generic))
            return
        }

        // 2.1 - check if data exists
        guard case let .data(data) = data.unwrapped else {

            completion(.failure(.emptyData))
            return
        }

        // 2.2 - check acceptable status codes
        guard response.hasAcceptableStatusCode else {

            self.handleErrorData(data, response: response, completion: completion)
            return
        }

        // Finally attempt to parse a valid response
        self.parse(data, completion: completion)
    }

    func handleErrorData<T: Codable,E: APIError> (_ data: Data,
                                                  response: HTTPURLResponse,
                                                  completion: APICompletion<T, E>) {

        do {

            let httpAPIError = try E(response: response, data: data)
            completion(.failure(.apiError(httpAPIError)))

        } catch let error {

            completion(.failure(.parsingError(.decode(error))))
        }
    }

    func parse<T: Codable, E: APIError> (_ data: Data,
                                         completion: APICompletion<T, E>) {

        do {

            let object = try JSONDecoder().decode(T.self, from: data)
            completion(.success(object))

        } catch let error {

            completion(.failure(.parsingError(.decode(error))))
        }
    }

    func parseError<T: Codable, E: APIError> (_ data: Data,
                                              completion: APICompletion<T, E>) {

        self.parse(data, completion: completion)
    }
}
