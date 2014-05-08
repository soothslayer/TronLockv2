//
//  LTOAuthenticator.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#define kLockitronSDKRedirectURI    "lockitronsdk://urlcallback"

#import "LTOAuthenticator.h"
#import "AFNetworking.h"

@implementation LTOAuthenticator
{
    NSOperationQueue *_queue;
}

- (id)init
{
    if (self == [super init])
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)startAuthentication
{
    NSData *tokenData = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    _access_token = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
    
    NSData *expirationData = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiration"];
    NSDate *dateExpiration = [NSKeyedUnarchiver unarchiveObjectWithData:expirationData];
    
    NSComparisonResult result = [dateExpiration compare:[NSDate date]];
    
    if (result == NSOrderedAscending)
    {
        _access_token = nil;
    }

    if (_access_token == nil)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.lockitron.com/v1/oauth/authorize?client_id=%@&response_type=code&redirect_uri=%s", _clientID, kLockitronSDKRedirectURI]];
        NSLog(@"%@", url);
        
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(authenticationIsDone)])
        {
            [_delegate authenticationIsDone];
        }
    }
}

- (void)authenticationCodeReceived:(NSString *)code
{
    NSURL *url = [NSURL URLWithString:@"https://api.lockitron.com/v1/oauth/token"];
    
    NSString *postData = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@&grant_type=authorization_code&redirect_uri=%s", _clientID, _clientSecret, code, kLockitronSDKRedirectURI];
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        _access_token = [JSON objectForKey:@"access_token"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_access_token] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([_delegate respondsToSelector:@selector(authenticationIsDone)])
        {
            [_delegate authenticationIsDone];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [_queue addOperation:operation];
}

@end
