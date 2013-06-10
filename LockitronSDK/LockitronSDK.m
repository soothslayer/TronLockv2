//
//  Lockitron.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "LockitronSDK.h"
#import "LTOAuthenticator.h"
#import "AFNetworking.h"
#import "NSDictionary+URLEncoding.h"

#import "LTLock.h"
#import "LTUser.h"
#import "LTKey.h"

@interface LockitronSDK () <LTOAuthenticatorDelegate>

@property (strong) LTOAuthenticator *authenticator;
@property (strong) NSOperationQueue *queue;
@property (assign) BOOL isReady;

@end

@implementation LockitronSDK

static LockitronSDK *_instance = nil;

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret
{
    if (_instance == nil)
    {
        LTOAuthenticator *authenticator = [[LTOAuthenticator alloc] init];
        authenticator.clientID = clientID;
        authenticator.clientSecret = clientSecret;
        
        _instance = [[LockitronSDK alloc] init];
        _instance.authenticator = authenticator;
        authenticator.delegate = _instance;
    }
    
    [_instance.authenticator startAuthentication];
}

+ (void)handleOpenURL:(NSURL *)url
{
    NSArray *pathComponents = [[url absoluteString] componentsSeparatedByString:@"?code="];
    [_instance.authenticator authenticationCodeReceived:pathComponents[1]];
}

- (id)init
{
    if (self == [super init])
    {
        _isReady = NO;
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

#pragma mark -
#pragma mark LTOAuthenticator delegate

- (void)authenticationIsDone
{
    NSLog(@"Authentication is done.");
    _isReady = YES;
}

#pragma mark -
#pragma mark API methods

+ (NSURLRequest *)requestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters method:(NSString *)method
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = url;
    request.HTTPMethod = method;
    request.HTTPBody = [[parameters encodeForURL] dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}

+ (void)locksGranted:(void (^)(NSArray *locks))locks
{
    if (!_instance.isReady)
    {
        NSLog(@"The authentication process is not completed yet.");
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.lockitron.com/v1/locks?access_token=%@", _instance.authenticator.access_token]]];
    NSLog(@"request: %@", request);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        NSMutableArray *locks = [[NSMutableArray alloc] init];
        
        for (NSDictionary *item in JSON)
        {
            LTLock *lock = [[LTLock alloc] init];
            lock.id = [[item objectForKey:@"lock"] objectForKey:@"id"];
            lock.latitude = [[item objectForKey:@"lock"] objectForKey:@"latitude"];
            lock.longitude = [[item objectForKey:@"lock"] objectForKey:@"longitude"];
            lock.name = [[item objectForKey:@"lock"] objectForKey:@"name"];

            if ([[item objectForKey:@"lock"] objectForKey:@"status"] == [NSNull null])
            {
                lock.state = LockitronSDKLockNotConfigured;
            }
            else
            {
                lock.state = ([[[item objectForKey:@"lock"] objectForKey:@"status"] isEqualToString:@"unlock"]) ? LockitronSDKLockOpen : LockitronSDKLockClosed;
            }
                        
            NSMutableArray *keys = [[NSMutableArray alloc] init];
            
            for (NSDictionary *itemKey in [[item objectForKey:@"lock"] objectForKey:@"keys"])
            {
                LTKey *key = [[LTKey alloc] init];
                key.id = [itemKey objectForKey:@"id"];
                key.role = ([[itemKey objectForKey:@"role"] isEqualToString:@"guest"]) ? LockitronSDKUserGuest : LockitronSDKUserAdmin;
                key.isValid = [[itemKey objectForKey:@"valid"] boolValue];
                key.isVisible = [[itemKey objectForKey:@"visible"] boolValue];
                
                LTUser *user = [[LTUser alloc] init];
                user.id = [[itemKey objectForKey:@"user"] objectForKey:@"id"];
                user.isActivated = [[[itemKey objectForKey:@"user"] objectForKey:@"activated"] boolValue];
                user.firstName = [[itemKey objectForKey:@"user"] objectForKey:@"first_name"];
                user.lastName = [[itemKey objectForKey:@"user"] objectForKey:@"last_name"];
                user.fullName = [[itemKey objectForKey:@"user"] objectForKey:@"full_name"];
                user.bestName = [[itemKey objectForKey:@"user"] objectForKey:@"best_name"];
                user.email = [[itemKey objectForKey:@"user"] objectForKey:@"email"];
                user.phoneNumber = [[itemKey objectForKey:@"user"] objectForKey:@"phone"];
                user.humanPhoneNumber = [[itemKey objectForKey:@"user"] objectForKey:@"human_phone"];
                
                key.user = user;
                
                [keys addObject:key];
            }
            
            lock.keys = keys;
            
            [locks addObject:lock];
        }
        
        locks(locks);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"Locks request failed with error: %d %@", response.statusCode, [error localizedDescription]);
    }];
    
    [_instance.queue addOperation:operation];
}

@end
