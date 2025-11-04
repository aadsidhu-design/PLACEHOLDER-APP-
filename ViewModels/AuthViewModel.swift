import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated = false
    
    private let firebaseService = FirebaseService.shared
    
    func signUp() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await firebaseService.signUp(email: email, password: password, displayName: displayName)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signIn() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await firebaseService.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try firebaseService.signOut()
            isAuthenticated = false
            email = ""
            password = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
