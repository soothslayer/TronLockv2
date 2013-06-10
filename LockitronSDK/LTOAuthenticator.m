//
//  LTOAuthenticator.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/9/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#define kLockitronSDKRedirectURI    "lockitronsdk://oauth.code"

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
        NSLog(@"Token already acquired.");
    }
}

- (void)authenticationCodeReceived:(NSString *)code
{
    NSURL *url = [NSURL URLWithString:@"https://api.lockitron.com/v1/oauth/token"];
    
    NSString *postData = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@&grant_type=authorization_code&redirect_uri=%s", _clientID, _clientSecret, code, kLockitronSDKRedirectURI];
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
//        
//        NSDate *dateExpiration = [NSDate dateWithTimeIntervalSinceNow:[[JSON objectForKey:@"expires_in"] floatValue]];
//        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[JSON objectForKey:@"access_token"]] forKey:@"access_token"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:dateExpiration] forKey:@"expiration"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if ([_delegate respondsToSelector:@selector(authenticationIsDone)])
        {
            [_delegate authenticationIsDone];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    
    [_queue addOperation:operation];
}

@end
