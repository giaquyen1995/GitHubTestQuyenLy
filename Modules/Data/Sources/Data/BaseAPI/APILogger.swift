import Foundation

public enum APILogger {
    static func log(request: URLRequest) {
        print("\n - - - - - - - - - - REQUEST - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlAsString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        Method: \(method)
        Host: \(host)
        Path: \(path)
        Query: \(query)
        """
        
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\nHeader: \(key): \(value)"
        }
        
        if let body = request.httpBody {
            if let bodyString = String(data: body, encoding: .utf8) {
                logOutput += "\n\nBody: \(bodyString)"
            }
        }
        
        print(logOutput)
    }
    
    static func log(response: URLResponse?, data: Data?, error: Error?) {
        print("\n - - - - - - - - - - RESPONSE - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let logOutput = generateLogOutput(response: response, data: data, error: error)
        print(logOutput)
    }
    
    private static func generateLogOutput(response: URLResponse?, data: Data?, error: Error?) -> String {
        var output = ""
        
        if let httpResponse = response as? HTTPURLResponse {
            output += "Status Code: \(httpResponse.statusCode)\n"
        }
        
        if let responseData = data {
            if let jsonString = formatJSON(from: responseData) {
                output += "\nResponse Body:\n\(jsonString)"
            }
        }
        
        if let responseError = error {
            output += "\nError: \(responseError.localizedDescription)"
        }
        
        return output
    }
    
    private static func formatJSON(from data: Data) -> String? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8)
        } catch {
            return String(data: data, encoding: .utf8)
        }
    }
}
