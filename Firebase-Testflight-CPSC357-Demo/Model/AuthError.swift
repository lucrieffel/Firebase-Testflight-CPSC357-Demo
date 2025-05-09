//
//  AuthError.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import Foundation
import Firebase
import FirebaseAuth

enum AuthError: Error {
    case invalidEmail
    case wrongPassword
    case userNotFound
    case userDisabled
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case tooManyRequests
    case invalidCredential
    case operationNotAllowed
    case internalError
    case keychainError
    case requiresRecentLogin
    case malformedCredential
    case unknown
    
    init(authErrorCode: AuthErrorCode) {
        switch authErrorCode {
        case .invalidEmail:
            self = .invalidEmail
        case .wrongPassword:
            self = .wrongPassword
        case .userNotFound:
            self = .userNotFound
        case .userDisabled:
            self = .userDisabled
        case .emailAlreadyInUse:
            self = .emailAlreadyInUse
        case .weakPassword:
            self = .weakPassword
        case .networkError:
            self = .networkError
        case .tooManyRequests:
            self = .tooManyRequests
        case .credentialAlreadyInUse, .invalidCredential:
            self = .invalidCredential
        case .operationNotAllowed:
            self = .operationNotAllowed
        case .internalError:
            self = .internalError
        case .keychainError:
            self = .keychainError
        case .requiresRecentLogin:
            self = .requiresRecentLogin
        case .invalidUserToken, .userTokenExpired, .malformedJWT:
            self = .malformedCredential
        default:
            print("Unhandled Firebase error code: \(authErrorCode.rawValue)")
            self = .unknown
        }
    }
    
    var description: String {
        switch self {
        case .invalidEmail:
            return "The email you entered is invalid. Please try again."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .userNotFound:
            return "No account found with this email. Would you like to create a new account?"
        case .weakPassword:
            return "Your password must be at least 6 characters in length. Please try again."
        case .emailAlreadyInUse:
            return "The email address is already in use. Please use a different email."
        case .internalError:
            return "An internal error occurred. Please try again."
        case .networkError:
            return "Internet connection is required for authentication. Please check your connection and try again."
        case .malformedCredential:
            return "The supplied auth credential is malformed or has expired. Please check your credentials and try again."
        case .unknown:
            return "This account does not exist. Please create a new account and try again."
        default:
            return "Your password was incorrect. Please try again."
//            return "An unknown error occurred. Please try again with different credentials or create a new account if you continue to receive errors. "
        }
    }
    
    var title: String {
        switch self {
        case .invalidEmail:
            return "Invalid Email"
        case .wrongPassword:
            return "Incorrect Password"
        case .userNotFound:
            return "Account Not Found"
        case .weakPassword:
            return "Password Too Weak"
        case .emailAlreadyInUse:
            return "Email Already in Use"
        case .internalError:
            return "System Error"
        case .networkError:
            return "No Internet Connection"
        case .malformedCredential:
            return "Invalid Credential"
        case .unknown:
            return "Unknown Error"
        default:
            return "Incorrect Password"
        }
    }
}

//
///// Error codes used by Firebase Auth.
//@objc(FIRAuthErrorCode) public enum AuthErrorCode: Int, Error {
//  /// Indicates a validation error with the custom token.
//  case invalidCustomToken = 17000
//
//  /// Indicates the service account and the API key belong to different projects.
//  case customTokenMismatch = 17002
//
//  /// Indicates the IDP token or requestUri is invalid.
//  case invalidCredential = 17004
//
//  /// Indicates the user's account is disabled on the server.
//  case userDisabled = 17005
//
//  /// Indicates the administrator disabled sign in with the specified identity provider.
//  case operationNotAllowed = 17006
//
//  /// Indicates the email used to attempt a sign up is already in use.
//  case emailAlreadyInUse = 17007
//
//  /// Indicates the email is invalid.
//  case invalidEmail = 17008
//
//  /// Indicates the user attempted sign in with a wrong password.
//  case wrongPassword = 17009
//
//  /// Indicates that too many requests were made to a server method.
//  case tooManyRequests = 17010
//
//  /// Indicates the user account was not found.
//  case userNotFound = 17011
//
//  /// Indicates account linking is required.
//  case accountExistsWithDifferentCredential = 17012
//
//  /// Indicates the user has attempted to change email or password more than 5 minutes after
//  /// signing in.
//  case requiresRecentLogin = 17014
//
//  /// Indicates an attempt to link a provider to which the account is already linked.
//  case providerAlreadyLinked = 17015
//
//  /// Indicates an attempt to unlink a provider that is not linked.
//  case noSuchProvider = 17016
//
//  /// Indicates user's saved auth credential is invalid the user needs to sign in again.
//  case invalidUserToken = 17017
//
//  /// Indicates a network error occurred (such as a timeout interrupted connection or
//  /// unreachable host). These types of errors are often recoverable with a retry. The
//  /// `NSUnderlyingError` field in the `NSError.userInfo` dictionary will contain the error
//  /// encountered.
//  case networkError = 17020
//
//  /// Indicates the saved token has expired for example the user may have changed account
//  /// password on another device. The user needs to sign in again on the device that made this
//  /// request.
//  case userTokenExpired = 17021
//
//  /// Indicates an invalid API key was supplied in the request.
//  case invalidAPIKey = 17023
//
//  /// Indicates that an attempt was made to reauthenticate with a user which is not the current
//  /// user.
//  case userMismatch = 17024
//
//  /// Indicates an attempt to link with a credential that has already been linked with a
//  /// different Firebase account.
//  case credentialAlreadyInUse = 17025
//
//  /// Indicates an attempt to set a password that is considered too weak.
//  case weakPassword = 17026
//
//  /// Indicates the App is not authorized to use Firebase Authentication with the
//  /// provided API Key.
//  case appNotAuthorized = 17028
//
//  /// Indicates the OOB code is expired.
//  case expiredActionCode = 17029
//
//  /// Indicates the OOB code is invalid.
//  case invalidActionCode = 17030
//
//  /// Indicates that there are invalid parameters in the payload during a
//  /// "send password reset email" attempt.
//  case invalidMessagePayload = 17031
//
//  /// Indicates that the sender email is invalid during a "send password reset email" attempt.
//  case invalidSender = 17032
//
//  /// Indicates that the recipient email is invalid.
//  case invalidRecipientEmail = 17033
//
//  /// Indicates that an email address was expected but one was not provided.
//  case missingEmail = 17034
//
//  // The enum values 17035 is reserved and should NOT be used for new error codes.
//
//  /// Indicates that the iOS bundle ID is missing when a iOS App Store ID is provided.
//  case missingIosBundleID = 17036
//
//  /// Indicates that the android package name is missing when the `androidInstallApp` flag is set
//  /// to `true`.
//  case missingAndroidPackageName = 17037
//
//  /// Indicates that the domain specified in the continue URL is not allowlisted in the Firebase
//  /// console.
//  case unauthorizedDomain = 17038
//
//  /// Indicates that the domain specified in the continue URI is not valid.
//  case invalidContinueURI = 17039
//
//  /// Indicates that a continue URI was not provided in a request to the backend which requires one.
//  case missingContinueURI = 17040
//
//  /// Indicates that a phone number was not provided in a call to
//  /// `verifyPhoneNumber:completion:`.
//  case missingPhoneNumber = 17041
//
//  /// Indicates that an invalid phone number was provided in a call to
//  /// `verifyPhoneNumber:completion:`.
//  case invalidPhoneNumber = 17042
//
//  /// Indicates that the phone auth credential was created with an empty verification code.
//  case missingVerificationCode = 17043
//
//  /// Indicates that an invalid verification code was used in the verifyPhoneNumber request.
//  case invalidVerificationCode = 17044
//
//  /// Indicates that the phone auth credential was created with an empty verification ID.
//  case missingVerificationID = 17045
//
//  /// Indicates that an invalid verification ID was used in the verifyPhoneNumber request.
//  case invalidVerificationID = 17046
//
//  /// Indicates that the APNS device token is missing in the verifyClient request.
//  case missingAppCredential = 17047
//
//  /// Indicates that an invalid APNS device token was used in the verifyClient request.
//  case invalidAppCredential = 17048
//
//  // The enum values between 17048 and 17051 are reserved and should NOT be used for new error
//  // codes.
//
//  /// Indicates that the SMS code has expired.
//  case sessionExpired = 17051
//
//  /// Indicates that the quota of SMS messages for a given project has been exceeded.
//  case quotaExceeded = 17052
//
//  /// Indicates that the APNs device token could not be obtained. The app may not have set up
//  /// remote notification correctly or may fail to forward the APNs device token to Auth
//  /// if app delegate swizzling is disabled.
//  case missingAppToken = 17053
//
//  /// Indicates that the app fails to forward remote notification to FIRAuth.
//  case notificationNotForwarded = 17054
//
//  /// Indicates that the app could not be verified by Firebase during phone number authentication.
//  case appNotVerified = 17055
//
//  /// Indicates that the reCAPTCHA token is not valid.
//  case captchaCheckFailed = 17056
//
//  /// Indicates that an attempt was made to present a new web context while one was already being
//  /// presented.
//  case webContextAlreadyPresented = 17057
//
//  /// Indicates that the URL presentation was cancelled prematurely by the user.
//  case webContextCancelled = 17058
//
//  /// Indicates a general failure during the app verification flow.
//  case appVerificationUserInteractionFailure = 17059
//
//  /// Indicates that the clientID used to invoke a web flow is invalid.
//  case invalidClientID = 17060
//
//  /// Indicates that a network request within a SFSafariViewController or WKWebView failed.
//  case webNetworkRequestFailed = 17061
//
//  /// Indicates that an internal error occurred within a SFSafariViewController or WKWebView.
//  case webInternalError = 17062
//
//  /// Indicates a general failure during a web sign-in flow.
//  case webSignInUserInteractionFailure = 17063
//
//  /// Indicates that the local player was not authenticated prior to attempting Game Center signin.
//  case localPlayerNotAuthenticated = 17066
//
//  /// Indicates that a non-null user was expected as an argument to the operation but a null
//  /// user was provided.
//  case nullUser = 17067
//
//  /// Indicates that a Firebase Dynamic Link is not activated.
//  case dynamicLinkNotActivated = 17068
//
//  /// Represents the error code for when the given provider id for a web operation is invalid.
//  case invalidProviderID = 17071
//
//  /// Represents the error code for when an attempt is made to update the current user with a
//  /// tenantId that differs from the current FirebaseAuth instance's tenantId.
//  case tenantIDMismatch = 17072
//
//  /// Represents the error code for when a request is made to the backend with an associated tenant
//  /// ID for an operation that does not support multi-tenancy.
//  case unsupportedTenantOperation = 17073
//
//  /// Indicates that the Firebase Dynamic Link domain used is either not configured or is
//  /// unauthorized for the current project.
//  case invalidDynamicLinkDomain = 17074
//
//  /// Indicates that the provided Firebase Hosting Link domain is not owned by the current project.
//  case invalidHostingLinkDomain = 17214
//
//  /// Indicates that the credential is rejected because it's malformed or mismatching.
//  case rejectedCredential = 17075
//
//  /// Indicates that the GameKit framework is not linked prior to attempting Game Center signin.
//  case gameKitNotLinked = 17076
//
//  /// Indicates that the second factor is required for signin.
//  case secondFactorRequired = 17078
//
//  /// Indicates that the multi factor session is missing.
//  case missingMultiFactorSession = 17081
//
//  /// Indicates that the multi factor info is missing.
//  case missingMultiFactorInfo = 17082
//
//  /// Indicates that the multi factor session is invalid.
//  case invalidMultiFactorSession = 17083
//
//  /// Indicates that the multi factor info is not found.
//  case multiFactorInfoNotFound = 17084
//
//  /// Indicates that the operation is admin restricted.
//  case adminRestrictedOperation = 17085
//
//  /// Indicates that the email is required for verification.
//  case unverifiedEmail = 17086
//
//  /// Indicates that the second factor is already enrolled.
//  case secondFactorAlreadyEnrolled = 17087
//
//  /// Indicates that the maximum second factor count is exceeded.
//  case maximumSecondFactorCountExceeded = 17088
//
//  /// Indicates that the first factor is not supported.
//  case unsupportedFirstFactor = 17089
//
//  /// Indicates that the a verified email is required to changed to.
//  case emailChangeNeedsVerification = 17090
//
//  /// Indicates that the request does not contain a client identifier.
//  case missingClientIdentifier = 17093
//
//  /// Indicates that the nonce is missing or invalid.
//  case missingOrInvalidNonce = 17094
//
//  /// Raised when a Cloud Function returns a blocking error. Will include a message returned from
//  /// the function.
//  case blockingCloudFunctionError = 17105
//
//  /// Indicates that reCAPTCHA Enterprise integration is not enabled for this project.
//  case recaptchaNotEnabled = 17200
//
//  /// Indicates that the reCAPTCHA token is missing from the backend request.
//  case missingRecaptchaToken = 17201
//
//  /// Indicates that the reCAPTCHA token sent with the backend request is invalid.
//  case invalidRecaptchaToken = 17202
//
//  /// Indicates that the requested reCAPTCHA action is invalid.
//  case invalidRecaptchaAction = 17203
//
//  /// Indicates that the client type is missing from the request.
//  case missingClientType = 17204
//
//  /// Indicates that the reCAPTCHA version is missing from the request.
//  case missingRecaptchaVersion = 17205
//
//  /// Indicates that the reCAPTCHA version sent to the backend is invalid.
//  case invalidRecaptchaVersion = 17206
//
//  /// Indicates that the request type sent to the backend is invalid.
//  case invalidReqType = 17207
//
//  /// Indicates that the reCAPTCHA SDK is not linked to the app.
//  case recaptchaSDKNotLinked = 17208
//
//  /// Indicates that the reCAPTCHA SDK site key wasn't found.
//  case recaptchaSiteKeyMissing = 17209
//
//  /// Indicates that the reCAPTCHA SDK actions class failed to create.
//  case recaptchaActionCreationFailed = 17210
//
//  /// Indicates an error occurred while attempting to access the keychain.
//  case keychainError = 17995
//
//  /// Indicates an internal error occurred.
//  case internalError = 17999
//
//  /// Raised when a JWT fails to parse correctly. May be accompanied by an underlying error
//  /// describing which step of the JWT parsing process failed.
//  case malformedJWT = 18000
//
//  var errorDescription: String {
//    switch self {
//    case .invalidCustomToken:
//      return kErrorInvalidCustomToken
//    case .customTokenMismatch:
//      return kErrorCustomTokenMismatch
//    case .invalidEmail:
//      return kErrorInvalidEmail
//    case .invalidCredential:
//      return kErrorInvalidCredential
//    case .userDisabled:
//      return kErrorUserDisabled
//    case .emailAlreadyInUse:
//      return kErrorEmailAlreadyInUse
//    case .wrongPassword:
//      return kErrorWrongPassword
//    case .tooManyRequests:
//      return kErrorTooManyRequests
//    case .accountExistsWithDifferentCredential:
//      return kErrorAccountExistsWithDifferentCredential
//    case .requiresRecentLogin:
//      return kErrorRequiresRecentLogin
//    case .providerAlreadyLinked:
//      return kErrorProviderAlreadyLinked
//    case .noSuchProvider:
//      return kErrorNoSuchProvider
//    case .invalidUserToken:
//      return kErrorInvalidUserToken
//    case .networkError:
//      return kErrorNetworkError
//    case .keychainError:
//      return kErrorKeychainError
//    case .missingClientIdentifier:
//      return kErrorMissingClientIdentifier
//    case .userTokenExpired:
//      return kErrorUserTokenExpired
//    case .userNotFound:
//      return kErrorUserNotFound
//    case .invalidAPIKey:
//      return kErrorInvalidAPIKey
//    case .credentialAlreadyInUse:
//      return kErrorCredentialAlreadyInUse
//    case .internalError:
//      return kErrorInternalError
//    case .userMismatch:
//      return FIRAuthErrorMessageUserMismatch
//    case .operationNotAllowed:
//      return kErrorOperationNotAllowed
//    case .weakPassword:
//      return kErrorWeakPassword
//    case .appNotAuthorized:
//      return kErrorAppNotAuthorized
//    case .expiredActionCode:
//      return kErrorExpiredActionCode
//    case .invalidActionCode:
//      return kErrorInvalidActionCode
//    case .invalidSender:
//      return kErrorInvalidSender
//    case .invalidMessagePayload:
//      return kErrorInvalidMessagePayload
//    case .invalidRecipientEmail:
//      return kErrorInvalidRecipientEmail
//    case .missingIosBundleID:
//      return kErrorMissingIosBundleID
//    case .missingAndroidPackageName:
//      return kErrorMissingAndroidPackageName
//    case .unauthorizedDomain:
//      return kErrorUnauthorizedDomain
//    case .invalidContinueURI:
//      return kErrorInvalidContinueURI
//    case .missingContinueURI:
//      return kErrorMissingContinueURI
//    case .missingEmail:
//      return kErrorMissingEmail
//    case .missingPhoneNumber:
//      return kErrorMissingPhoneNumber
//    case .invalidPhoneNumber:
//      return kErrorInvalidPhoneNumber
//    case .missingVerificationCode:
//      return kErrorMissingVerificationCode
//    case .invalidVerificationCode:
//      return kErrorInvalidVerificationCode
//    case .missingVerificationID:
//      return kErrorMissingVerificationID
//    case .invalidVerificationID:
//      return kErrorInvalidVerificationID
//    case .sessionExpired:
//      return kErrorSessionExpired
//    case .missingAppCredential:
//      return kErrorMissingAppCredential
//    case .invalidAppCredential:
//      return kErrorInvalidAppCredential
//    case .quotaExceeded:
//      return kErrorQuotaExceeded
//    case .missingAppToken:
//      return kErrorMissingAppToken
//    case .notificationNotForwarded:
//      return kErrorNotificationNotForwarded
//    case .appNotVerified:
//      return kErrorAppNotVerified
//    case .captchaCheckFailed:
//      return kErrorCaptchaCheckFailed
//    case .webContextAlreadyPresented:
//      return kErrorWebContextAlreadyPresented
//    case .webContextCancelled:
//      return kErrorWebContextCancelled
//    case .invalidClientID:
//      return kErrorInvalidClientID
//    case .appVerificationUserInteractionFailure:
//      return kErrorAppVerificationUserInteractionFailure
//    case .webNetworkRequestFailed:
//      return kErrorWebRequestFailed
//    case .nullUser:
//      return kErrorNullUser
//    case .invalidProviderID:
//      return kErrorInvalidProviderID
//    case .invalidDynamicLinkDomain:
//      return kErrorInvalidDynamicLinkDomain
//    case .invalidHostingLinkDomain:
//      return kErrorInvalidHostingLinkDomain
//    case .webInternalError:
//      return kErrorWebInternalError
//    case .webSignInUserInteractionFailure:
//      return kErrorAppVerificationUserInteractionFailure
//    case .malformedJWT:
//      return kErrorMalformedJWT
//    case .localPlayerNotAuthenticated:
//      return kErrorLocalPlayerNotAuthenticated
//    case .gameKitNotLinked:
//      return kErrorGameKitNotLinked
//    case .secondFactorRequired:
//      return kErrorSecondFactorRequired
//    case .missingMultiFactorSession:
//      return FIRAuthErrorMessageMissingMultiFactorSession
//    case .missingMultiFactorInfo:
//      return FIRAuthErrorMessageMissingMultiFactorInfo
//    case .invalidMultiFactorSession:
//      return FIRAuthErrorMessageInvalidMultiFactorSession
//    case .multiFactorInfoNotFound:
//      return FIRAuthErrorMessageMultiFactorInfoNotFound
//    case .adminRestrictedOperation:
//      return FIRAuthErrorMessageAdminRestrictedOperation
//    case .unverifiedEmail:
//      return FIRAuthErrorMessageUnverifiedEmail
//    case .secondFactorAlreadyEnrolled:
//      return FIRAuthErrorMessageSecondFactorAlreadyEnrolled
//    case .maximumSecondFactorCountExceeded:
//      return FIRAuthErrorMessageMaximumSecondFactorCountExceeded
//    case .unsupportedFirstFactor:
//      return FIRAuthErrorMessageUnsupportedFirstFactor
//    case .emailChangeNeedsVerification:
//      return FIRAuthErrorMessageEmailChangeNeedsVerification
//    case .dynamicLinkNotActivated:
//      return kErrorDynamicLinkNotActivated
//    case .rejectedCredential:
//      return kErrorRejectedCredential
//    case .missingOrInvalidNonce:
//      return kErrorMissingOrInvalidNonce
//    case .tenantIDMismatch:
//      return kErrorTenantIDMismatch
//    case .unsupportedTenantOperation:
//      return kErrorUnsupportedTenantOperation
//    case .blockingCloudFunctionError:
//      return kErrorBlockingCloudFunctionReturnedError
//    case .recaptchaNotEnabled:
//      return kErrorRecaptchaNotEnabled
//    case .missingRecaptchaToken:
//      return kErrorMissingRecaptchaToken
//    case .invalidRecaptchaToken:
//      return kErrorInvalidRecaptchaToken
//    case .invalidRecaptchaAction:
//      return kErrorInvalidRecaptchaAction
//    case .missingClientType:
//      return kErrorMissingClientType
//    case .missingRecaptchaVersion:
//      return kErrorMissingRecaptchaVersion
//    case .invalidRecaptchaVersion:
//      return kErrorInvalidRecaptchaVersion
//    case .invalidReqType:
//      return kErrorInvalidReqType
//    case .recaptchaSDKNotLinked:
//      return kErrorRecaptchaSDKNotLinked
//    case .recaptchaSiteKeyMissing:
//      return kErrorSiteKeyMissing
//    case .recaptchaActionCreationFailed:
//      return kErrorRecaptchaActionCreationFailed
//    }
//  }
//
//  /// The error code. It's redundant but implemented for compatibility with the Objective-C
//  /// implementation.
//  public var code: Self {
//    return self
//  }
//
//  var errorCodeString: String {
//    switch self {
//    case .invalidCustomToken:
//      return "ERROR_INVALID_CUSTOM_TOKEN"
//    case .customTokenMismatch:
//      return "ERROR_CUSTOM_TOKEN_MISMATCH"
//    case .invalidEmail:
//      return "ERROR_INVALID_EMAIL"
//    case .invalidCredential:
//      return "ERROR_INVALID_CREDENTIAL"
//    case .userDisabled:
//      return "ERROR_USER_DISABLED"
//    case .emailAlreadyInUse:
//      return "ERROR_EMAIL_ALREADY_IN_USE"
//    case .wrongPassword:
//      return "ERROR_WRONG_PASSWORD"
//    case .tooManyRequests:
//      return "ERROR_TOO_MANY_REQUESTS"
//    case .accountExistsWithDifferentCredential:
//      return "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL"
//    case .requiresRecentLogin:
//      return "ERROR_REQUIRES_RECENT_LOGIN"
//    case .providerAlreadyLinked:
//      return "ERROR_PROVIDER_ALREADY_LINKED"
//    case .noSuchProvider:
//      return "ERROR_NO_SUCH_PROVIDER"
//    case .invalidUserToken:
//      return "ERROR_INVALID_USER_TOKEN"
//    case .networkError:
//      return "ERROR_NETWORK_REQUEST_FAILED"
//    case .keychainError:
//      return "ERROR_KEYCHAIN_ERROR"
//    case .missingClientIdentifier:
//      return "ERROR_MISSING_CLIENT_IDENTIFIER"
//    case .userTokenExpired:
//      return "ERROR_USER_TOKEN_EXPIRED"
//    case .userNotFound:
//      return "ERROR_USER_NOT_FOUND"
//    case .invalidAPIKey:
//      return "ERROR_INVALID_API_KEY"
//    case .credentialAlreadyInUse:
//      return "ERROR_CREDENTIAL_ALREADY_IN_USE"
//    case .internalError:
//      return "ERROR_INTERNAL_ERROR"
//    case .userMismatch:
//      return "ERROR_USER_MISMATCH"
//    case .operationNotAllowed:
//      return "ERROR_OPERATION_NOT_ALLOWED"
//    case .weakPassword:
//      return "ERROR_WEAK_PASSWORD"
//    case .appNotAuthorized:
//      return "ERROR_APP_NOT_AUTHORIZED"
//    case .expiredActionCode:
//      return "ERROR_EXPIRED_ACTION_CODE"
//    case .invalidActionCode:
//      return "ERROR_INVALID_ACTION_CODE"
//    case .invalidMessagePayload:
//      return "ERROR_INVALID_MESSAGE_PAYLOAD"
//    case .invalidSender:
//      return "ERROR_INVALID_SENDER"
//    case .invalidRecipientEmail:
//      return "ERROR_INVALID_RECIPIENT_EMAIL"
//    case .missingIosBundleID:
//      return "ERROR_MISSING_IOS_BUNDLE_ID"
//    case .missingAndroidPackageName:
//      return "ERROR_MISSING_ANDROID_PKG_NAME"
//    case .unauthorizedDomain:
//      return "ERROR_UNAUTHORIZED_DOMAIN"
//    case .invalidContinueURI:
//      return "ERROR_INVALID_CONTINUE_URI"
//    case .missingContinueURI:
//      return "ERROR_MISSING_CONTINUE_URI"
//    case .missingEmail:
//      return "ERROR_MISSING_EMAIL"
//    case .missingPhoneNumber:
//      return "ERROR_MISSING_PHONE_NUMBER"
//    case .invalidPhoneNumber:
//      return "ERROR_INVALID_PHONE_NUMBER"
//    case .missingVerificationCode:
//      return "ERROR_MISSING_VERIFICATION_CODE"
//    case .invalidVerificationCode:
//      return "ERROR_INVALID_VERIFICATION_CODE"
//    case .missingVerificationID:
//      return "ERROR_MISSING_VERIFICATION_ID"
//    case .invalidVerificationID:
//      return "ERROR_INVALID_VERIFICATION_ID"
//    case .sessionExpired:
//      return "ERROR_SESSION_EXPIRED"
//    case .missingAppCredential:
//      return "MISSING_APP_CREDENTIAL"
//    case .invalidAppCredential:
//      return "INVALID_APP_CREDENTIAL"
//    case .quotaExceeded:
//      return "ERROR_QUOTA_EXCEEDED"
//    case .missingAppToken:
//      return "ERROR_MISSING_APP_TOKEN"
//    case .notificationNotForwarded:
//      return "ERROR_NOTIFICATION_NOT_FORWARDED"
//    case .appNotVerified:
//      return "ERROR_APP_NOT_VERIFIED"
//    case .captchaCheckFailed:
//      return "ERROR_CAPTCHA_CHECK_FAILED"
//    case .webContextAlreadyPresented:
//      return "ERROR_WEB_CONTEXT_ALREADY_PRESENTED"
//    case .webContextCancelled:
//      return "ERROR_WEB_CONTEXT_CANCELLED"
//    case .invalidClientID:
//      return "ERROR_INVALID_CLIENT_ID"
//    case .appVerificationUserInteractionFailure:
//      return "ERROR_APP_VERIFICATION_FAILED"
//    case .webNetworkRequestFailed:
//      return "ERROR_WEB_NETWORK_REQUEST_FAILED"
//    case .nullUser:
//      return "ERROR_NULL_USER"
//    case .invalidProviderID:
//      return "ERROR_INVALID_PROVIDER_ID"
//    case .invalidDynamicLinkDomain:
//      return "ERROR_INVALID_DYNAMIC_LINK_DOMAIN"
//    case .invalidHostingLinkDomain:
//      return "ERROR_INVALID_HOSTING_LINK_DOMAIN"
//    case .webInternalError:
//      return "ERROR_WEB_INTERNAL_ERROR"
//    case .webSignInUserInteractionFailure:
//      return "ERROR_WEB_USER_INTERACTION_FAILURE"
//    case .malformedJWT:
//      return "ERROR_MALFORMED_JWT"
//    case .localPlayerNotAuthenticated:
//      return "ERROR_LOCAL_PLAYER_NOT_AUTHENTICATED"
//    case .gameKitNotLinked:
//      return "ERROR_GAME_KIT_NOT_LINKED"
//    case .secondFactorRequired:
//      return "ERROR_SECOND_FACTOR_REQUIRED"
//    case .missingMultiFactorSession:
//      return "ERROR_MISSING_MULTI_FACTOR_SESSION"
//    case .missingMultiFactorInfo:
//      return "ERROR_MISSING_MULTI_FACTOR_INFO"
//    case .invalidMultiFactorSession:
//      return "ERROR_INVALID_MULTI_FACTOR_SESSION"
//    case .multiFactorInfoNotFound:
//      return "ERROR_MULTI_FACTOR_INFO_NOT_FOUND"
//    case .adminRestrictedOperation:
//      return "ERROR_ADMIN_RESTRICTED_OPERATION"
//    case .unverifiedEmail:
//      return "ERROR_UNVERIFIED_EMAIL"
//    case .secondFactorAlreadyEnrolled:
//      return "ERROR_SECOND_FACTOR_ALREADY_ENROLLED"
//    case .maximumSecondFactorCountExceeded:
//      return "ERROR_MAXIMUM_SECOND_FACTOR_COUNT_EXCEEDED"
//    case .unsupportedFirstFactor:
//      return "ERROR_UNSUPPORTED_FIRST_FACTOR"
//    case .emailChangeNeedsVerification:
//      return "ERROR_EMAIL_CHANGE_NEEDS_VERIFICATION"
//    case .dynamicLinkNotActivated:
//      return "ERROR_DYNAMIC_LINK_NOT_ACTIVATED"
//    case .rejectedCredential:
//      return "ERROR_REJECTED_CREDENTIAL"
//    case .missingOrInvalidNonce:
//      return "ERROR_MISSING_OR_INVALID_NONCE"
//    case .tenantIDMismatch:
//      return "ERROR_TENANT_ID_MISMATCH"
//    case .unsupportedTenantOperation:
//      return "ERROR_UNSUPPORTED_TENANT_OPERATION"
//    case .blockingCloudFunctionError:
//      return "ERROR_BLOCKING_CLOUD_FUNCTION_RETURNED_ERROR"
//    case .recaptchaNotEnabled:
//      return "ERROR_RECAPTCHA_NOT_ENABLED"
//    case .missingRecaptchaToken:
//      return "ERROR_MISSING_RECAPTCHA_TOKEN"
//    case .invalidRecaptchaToken:
//      return "ERROR_INVALID_RECAPTCHA_TOKEN"
//    case .invalidRecaptchaAction:
//      return "ERROR_INVALID_RECAPTCHA_ACTION"
//    case .missingClientType:
//      return "ERROR_MISSING_CLIENT_TYPE"
//    case .missingRecaptchaVersion:
//      return "ERROR_MISSING_RECAPTCHA_VERSION"
//    case .invalidRecaptchaVersion:
//      return "ERROR_INVALID_RECAPTCHA_VERSION"
//    case .invalidReqType:
//      return "ERROR_INVALID_REQ_TYPE"
//    case .recaptchaSDKNotLinked:
//      return "ERROR_RECAPTCHA_SDK_NOT_LINKED"
//    case .recaptchaSiteKeyMissing:
//      return "ERROR_RECAPTCHA_SITE_KEY_MISSING"
//    case .recaptchaActionCreationFailed:
//      return "ERROR_RECAPTCHA_ACTION_CREATION_FAILED"
//    }
//  }
//}
