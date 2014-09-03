//
//  MUSharedWebCredential.h
//  MeetupApp
//
//  Created by Phil Tang on 9/1/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MUSharedWebCredentialErrorDomain;
extern const NSInteger MUSharedWebCredentialNotSupportedErrorCode;

typedef void (^MUSharedWebCredentialSuccessBlock)(NSString *username, NSString *password, NSString *domain);
typedef void (^MUSharedWebCredentialFailureBlock)(NSError *error);

@interface MUSharedWebCredential : NSObject

/**
 Request a password from Safari AutoFill.

 Asks the user to pick one credential from a list of all credentials saved
 for every domain allowed by the app entitlements.
 */
+ (void)requestCredentialWithSuccess:(MUSharedWebCredentialSuccessBlock)success
                             failure:(MUSharedWebCredentialFailureBlock)failure;

/**
 Request a specific password from Safari AutoFill.
 
 Asks the user to pick one credential from a list of credentials with the specified
 domain and username.

 @param domain      Limit the presented credential list to credentials with this
                    fully-qualified domain name. Pass nil to allow all domains
                    permitted by the app entitlements.
 @param username    Limit the presented credential list to credentials with this
                    username. Pass nil to allow all usernames.
 */
+ (void)requestCredentialForDomain:(NSString *)domain
                      withUsername:(NSString *)username
                           success:(MUSharedWebCredentialSuccessBlock)success
                           failure:(MUSharedWebCredentialFailureBlock)failure;


/**
 Save a new credential or, with user permission, modify an existing credential
 in Safari AutoFill.
 
 @param username    The username of the credential.
 @param password    The password of the credential.
 @param domain      The fully-qualified domain name of the website where
                    the credential can be used.
 @param completion  Called when the save completes, and does not contain
                    an error if permission is denied. Errors here tend
                    to mean that there's an issue with the app-website link.
 */
+ (void)saveCredentialWithUsername:(NSString *)username
                          password:(NSString *)password
                            domain:(NSString *)domain
                        completion:(void(^)(NSError *error))completion;

/**
 With user permission, delete a credential from Safari AutoFill.
 
 @param username    The username of the credential.
 @param domain      The fully-qualified domain name of the website where
                    the credential was used.
 @param completion  Called when the deletion completes, and does not contain
                    an error if permission is denied. Errors here tend
                    to mean that there's an issue with the app-website link.
 */
+ (void)deleteCredentialWithUsername:(NSString *)username
                              domain:(NSString *)domain
                          completion:(void(^)(NSError *error))completion;


/// Request a randomly-generated password from Safari Autofill. Returns `nil` on iOS 7.
+ (NSString *)randomPassword;

@end
