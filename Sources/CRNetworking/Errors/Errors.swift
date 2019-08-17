//
//  Errors.swift
//  CRNetworking
//
//  Created by Carlos Santos on 17/08/2019.
//  Copyright © 2019 crsantos.info. All rights reserved.
//

import Foundation

public enum NetworkingError<APIHTTPError>: Error {

    case generic
    case emptyData
    case underlyingError(Error)
    case parsingError(ParseError)
    case apiError(APIHTTPError)
}

public enum ParseError: Error {

    case emptyResponse
    case decode(Error)
}
