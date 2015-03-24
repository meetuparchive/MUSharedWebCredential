//
//  MUSharedWebCredential.m
//  MeetupApp
//
//  Created by Phil Tang on 9/1/14.
//  Copyright (c) 2014 Meetup, Inc. All rights reserved.
//

#import "MUSharedWebCredential.h"

NSString * const MUSharedWebCredentialErrorDomain = @"MUSharedWebCredentialErrorDomain";
const NSInteger MUSharedWebCredentialNotSupportedErrorCode = 9001;

@implementation MUSharedWebCredential

+ (void)requestCredentialWithSuccess:(MUSharedWebCredentialSuccessBlock)success
                             failure:(MUSharedWebCredentialFailureBlock)failure
{
    [self requestCredentialForDomain:nil withUsername:nil success:success failure:failure];
}

+ (void)requestCredentialForDomain:(NSString *)domain
                      withUsername:(NSString *)username
                           success:(MUSharedWebCredentialSuccessBlock)success
                           failure:(MUSharedWebCredentialFailureBlock)failure
{
#ifdef _SECURITY_SECSHAREDCREDENTIAL_H_
    if (!SecRequestSharedWebCredential) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{ failure([self notSupportedError]); });
        }
        return;
    }
    SecRequestSharedWebCredential((__bridge CFStringRef)domain, (__bridge CFStringRef)username,
        ^(CFArrayRef credentials, CFErrorRef error) {
            if (error) {
                if (failure) {
                    NSError *failError = (__bridge NSError *)error;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(failError);
                    });
                }
                return;
            }   
            
            NSDictionary *credential = ((__bridge NSArray *)credentials).firstObject;
            NSString *account = credential[(__bridge id)kSecAttrAccount];
            NSString *password = credential[(__bridge id)kSecSharedPassword];
            NSString *server = credential[(__bridge id)kSecAttrServer];
  
            if ([account length] > 0 && [password length] > 0) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(account, password, server);
                    });
                }
            }
            else {
                if (failure) {
                    NSError *failError = (__bridge NSError *)error;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(failError);
                    });
                }
            }
        });
#else
    if (failure) {
        dispatch_async(dispatch_get_main_queue(), ^{ failure([self notSupportedError]); });
    }
#endif
}


+ (void)saveCredentialWithUsername:(NSString *)username
                          password:(NSString *)password
                            domain:(NSString *)domain
                        completion:(void(^)(NSError *error))completion
{
#ifdef _SECURITY_SECSHAREDCREDENTIAL_H_
    if (!SecAddSharedWebCredential) {
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{ completion([self notSupportedError]); });
        }
        return;
    }
    SecAddSharedWebCredential((__bridge CFStringRef)domain, (__bridge CFStringRef)username, (__bridge CFStringRef)password,
        ^(CFErrorRef error) {
            if (completion) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  completion((__bridge NSError *)error);
              });
            }
        });
#else
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{ completion([self notSupportedError]); });
    }
#endif
}

+ (void)deleteCredentialWithUsername:(NSString *)username domain:(NSString *)domain completion:(void(^)(NSError *error))completion {
    return [self saveCredentialWithUsername:username password:nil domain:domain completion:completion];
}

+ (NSString *)randomPassword {
#ifdef _SECURITY_SECSHAREDCREDENTIAL_H_
    if (!SecCreateSharedWebCredentialPassword) return nil;
    
    return (__bridge_transfer NSString *)SecCreateSharedWebCredentialPassword();
#else
    return nil;
#endif
}


+ (NSError *)notSupportedError {
    NSString *notSupported = NSLocalizedString(@"This SDK does not support access to passwords in Safari AutoFill.", nil);
    return [NSError errorWithDomain:MUSharedWebCredentialErrorDomain
                               code:MUSharedWebCredentialNotSupportedErrorCode
                           userInfo:@{NSLocalizedFailureReasonErrorKey: notSupported}];
}

@end
