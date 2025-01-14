
import Foundation
import CommonCrypto
import CryptoKit

class SSLPinningDelegate: NSObject {
    
    let publicKeyPinning: Bool
    let localPublicKey: String = "APLQaubWxXwi8z//KwSLRQMIa0z01eii9bB7iJk7UAY="
    
    
    override init() {
        publicKeyPinning = true
    }
    
}

extension SSLPinningDelegate: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Get the server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust  else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server didn't present trust")
            return
        }
        
        // Get the server certificates: if the trust of the server contains a certificate array at identifies the server
        let serverCertificates: [SecCertificate]?
        serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]
        // Unwrap server certificate, if not available, then SSLPinning error
        guard let serverCertificate = serverCertificates?.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server certificate is nil")
            return
        }
        
        if publicKeyPinning {
            // publicKeyPinning
            // obtenemos la public key del servidor
            guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: server certificate is nil")
                return
            }
            
            // transformamos public key a data
            guard let serverPublicKeyRep = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: unable to convert server public key to data")
                return
            }
            let serverPublicKeyData: Data = serverPublicKeyRep as Data
            
            let serverHashPKBase64 = sha256CryptoKit(data: serverPublicKeyData)
            print("Public Key: \(serverHashPKBase64)")
            
            if serverHashPKBase64 == localPublicKey {
                completionHandler(.useCredential, URLCredential(trust:serverTrust))
                print("SSLPinning OK")
                
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: public key does not match")
            }
        } else {
            // Comparar serverCertificate con localCertificate
            // creamos una política de verificación del nombre del servidor
            let policies = NSMutableArray()
            let sslPolicy = SecPolicyCreateSSL(true, "thecocktaildb.com" as CFString)
            policies.add(sslPolicy)
            
            // evaluamos las políticas para el server trust
            SecTrustSetPolicies(serverTrust, policies) // eL certificado del servidor tiene que llamarse thecocktaildb.com
            
            // evaluamos el certificado
            let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
            
            let remoteCertificateData: NSData = SecCertificateCopyData(serverCertificate)
            
            // local certificado data
            guard let localCertificatePath = Bundle.main.path(forResource: "thecocktaildb.com", ofType: "cer"),
                  let localCertificateData = NSData(contentsOfFile: localCertificatePath) else {
                      completionHandler(.cancelAuthenticationChallenge, nil)
                      print("SSLPinning error: local certificate data not found")
                      return
                  }
            // comparamos certificado local con remoto si isServerTrusted es true
            if isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data) {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
                print("SSLPinning success: server certificate is valid")
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("SSLPinning error: local and server certificates don't match")
            }
        }
    }
}


//MARK: - SSLPinning extension: SHA
extension SSLPinningDelegate{
    /// Create a SHA256 representation of the data passed as parameter (crypto kit)
    /// - Parameter data: The data that will be converted to SHA256.
    /// - Returns: The SHA256 representation of data.
    private func sha256CryptoKit(data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return Data(hash).base64EncodedString()
    }
}
