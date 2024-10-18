import XCTest

class APITests: XCTestCase {

    func testFetchDataFromAPI() throws {
        // L'URL de l'API que tu veux tester
        let url = URL(string: "https://api.jikan.moe/v4/top/anime")!
        
        // Créer une expectation pour attendre la réponse
        let expectation = self.expectation(description: "API Response Received")
        
        // Effectuer la requête réseau
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Vérifie s'il y a des données
            XCTAssertNotNil(data, "Aucune donnée reçue de l'API")
            XCTAssertNil(error, "Il y a une erreur : \(error?.localizedDescription ?? "erreur inconnue")")
            
            if let httpResponse = response as? HTTPURLResponse {
                XCTAssertEqual(httpResponse.statusCode, 200, "Le statut de la réponse n'est pas 200 OK")
            }
            
            // Vérifie que les données peuvent être décodées en JSON
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    XCTAssertNotNil(json, "La réponse JSON est invalide")
                } catch {
                    XCTFail("Échec lors du parsing JSON : \(error.localizedDescription)")
                }
            }
            
            // Indiquer que l'attente est terminée
            expectation.fulfill()
        }
        
        task.resume()
        
        // Attendre jusqu'à 10 secondes que la requête soit terminée
        wait(for: [expectation], timeout: 10.0)
    }
}
