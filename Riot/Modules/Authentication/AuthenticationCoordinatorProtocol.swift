// File created from ScreenTemplate
// $ createScreen.sh Onboarding Authentication
/*
 Copyright 2021 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

/// `AuthenticationCoordinatorProtocol` is a protocol describing a Coordinator that handle's the authentication navigation flow.
protocol AuthenticationCoordinatorProtocol: Coordinator, Presentable {
    var completion: (() -> Void)? { get set }
    
    /// Update the screen to display registration or login.
    func update(authenticationType: MXKAuthenticationType)
    
    /// Force a registration process based on a predefined set of parameters from a server provisioning link.
    /// For more information see `AuthenticationViewController.externalRegistrationParameters`.
    func update(externalRegistrationParameters: [AnyHashable: Any])
    
    /// Update the screen to use any credentials to use after a soft logout has taken place.
    func update(softLogoutCredentials: MXCredentials)
    
    /// Set up the authentication screen with the specified homeserver and/or identity server.
    func updateHomeserver(_ homeserver: String?, andIdentityServer identityServer: String?)
    
    /// When SSO login succeeded, when SFSafariViewController is used, continue login with success parameters.
    func continueSSOLogin(withToken loginToken: String, transactionID: String) -> Bool
}
