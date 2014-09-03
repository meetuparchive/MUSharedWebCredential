MUSharedWebCredential
=====================

MUSharedWebCredential is a little class that takes all the pain out of working with passwords saved by Safari AutoFill. It lets you work with those passwords in Swift apps, and neatly hides the fact that the necessary API methods don't exist in iOS 7 and Xcode 5.

----

#### How to use this class

Before you can use this class, you must set up your app-website association. See the 2014 WWDC video [“Your App, Your Website, and Safari”](https://developer.apple.com/videos/wwdc/2014/#506) for instructions.

**Requesting a password from Safari AutoFill**
_requires user approval_
```objective-c
[MUSharedWebCredential requestCredentialWithSuccess:^(NSString *username, NSString *password, NSString *domain) {
    [MULoginManager logInWithUsername:username password:password];
} failure:^(NSError *error) {
    [self showError:error];
}];
```

**Saving a password in Safari AutoFill**
_requires user approval if editing an existing credential_
```objective-c
[MUSharedWebCredential saveCredentialWithUsername:username
                                         password:password
                                           domain:@"meetup.com"
                                       completion:NULL];
```

**Deleting a password from Safari AutoFill**
_requires user approval_
```objective-c
[MUSharedWebCredential deleteCredentialWithUsername:username
                                             domain:@"meetup.com"
                                         completion:NULL];
```

**Generating a strong, unique password**
```objective-c
NSString *randomPassword = [MUSharedWebCredential randomPassword];
```