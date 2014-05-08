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
@property (weak) id<LockitronSDKDelegate> delegate;
@property (strong) NSArray *locks;
@property (strong) LTUser *user;

- (void)requestLocks;

@end

@implementation LockitronSDK

static LockitronSDK *_instance = nil;

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret delegate:(id<LockitronSDKDelegate>)delegate
{
    if (_instance == nil)
    {
        LTOAuthenticator *authenticator = [[LTOAuthenticator alloc] init];
        authenticator.clientID = clientID;
        authenticator.clientSecret = clientSecret;
        
        _instance = [[LockitronSDK alloc] init];
        _instance.authenticator = authenticator;
        authenticator.delegate = _instance;
        
        _instance.delegate = delegate;
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
    
    [self requestLocks];
}

#pragma mark -
#pragma mark API methods

#pragma mark Private

- (void)requestLocks
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.lockitron.com/v1/locks?access_token=%@", _authenticator.access_token]]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
         NSMutableArray *locks = [[NSMutableArray alloc] init];
        
         for (NSDictionary *item in JSON)
         {
             LTLock *lock = [[LTLock alloc] init];
             lock.delegate = self;
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
         
        _locks = locks;
        
        if ([_delegate respondsToSelector:@selector(lockitronIsReady)])
        {
            [_delegate lockitronIsReady];
        }
        
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Locks request failed with error: %@", [error localizedDescription]);
     }];
    
    [_instance.queue addOperation:operation];
}

- (void)unlockDoor:(LTLock *)lock
{
    NSURLRequest *request = [LockitronSDK requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.lockitron.com/v1/locks/%@/unlock", lock.id]] parameters:@{@"lock_id": lock.id, @"access_token": _authenticator.access_token} method:@"POST"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON)
    {
        if (operation.response.statusCode == 200 && [[[JSON objectForKey:@"log"] objectForKey:@"type"] isEqualToString:@"lock-unlock"])
        {
            lock.state = LockitronSDKLockOpen;
            
            if ([_delegate respondsToSelector:@selector(lockitronChangedLockState:to:)])
            {
                [_delegate lockitronChangedLockState:lock to:LockitronSDKLockOpen];
            }
        }
        else if (operation.response.statusCode == 403)
        {
            if ([_delegate respondsToSelector:@selector(lockitronDeniedAccess:errorMessage:)])
            {
                [_delegate lockitronDeniedAccess:lock errorMessage:@"You don't have access to the lock."];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_delegate respondsToSelector:@selector(lockitronDeniedAccess:errorMessage:)])
        {
            [_delegate lockitronDeniedAccess:lock errorMessage:@"You don't have access to the lock."];
        }
    }];
    
    [_instance.queue addOperation:operation];
}

- (void)lockDoor:(LTLock *)lock
{
    NSURLRequest *request = [LockitronSDK requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.lockitron.com/v1/locks/%@/lock", lock.id]] parameters:@{@"lock_id": lock.id, @"access_token": _authenticator.access_token} method:@"POST"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON)
    {
        if (operation.response.statusCode == 200 && [[[JSON objectForKey:@"log"] objectForKey:@"type"] isEqualToString:@"lock-lock"])
        {
            lock.state = LockitronSDKLockClosed;
            
            if ([_delegate respondsToSelector:@selector(lockitronChangedLockState:to:)])
            {
                [_delegate lockitronChangedLockState:lock to:LockitronSDKLockClosed];
            }
        }
        else if (operation.response.statusCode == 403)
        {
            if ([_delegate respondsToSelector:@selector(lockitronDeniedAccess:errorMessage:)])
            {
                [_delegate lockitronDeniedAccess:lock errorMessage:@"You don't have access to the lock."];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([_delegate respondsToSelector:@selector(lockitronDeniedAccess:errorMessage:)])
        {
            [_delegate lockitronDeniedAccess:lock errorMessage:@"You don't have access to the lock."];
        }
    }];
    
    [_instance.queue addOperation:operation];
}

+ (NSURLRequest *)requestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters method:(NSString *)method
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.URL = url;
    request.HTTPMethod = method;
    request.HTTPBody = [[parameters encodeForURL] dataUsingEncoding:NSUTF8StringEncoding];
    
    return request;
}

#pragma mark Public

+ (NSArray *)locksList
{
    return _instance.locks;
}

+ (LTUser *)userAuthenticated
{
    return _instance.user;
}

@end
