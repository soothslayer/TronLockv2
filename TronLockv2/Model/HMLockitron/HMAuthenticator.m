//
//  HMAuthenticator.m
//  TronLockv2
//
//  Created by Hanlon Miller on 8/14/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import "HMAuthenticator.h"
#import "HMLockitronStatic.h"

@interface HMAuthenticator ()
@property (strong) NSString *URIcallback;

@end

@implementation HMAuthenticator {
    NSOperationQueue *_queue;
    NSUserDefaults *_sharedDefaults;
}

- (id)initWithURIcallback:(NSString *)URIcallback {
    self = [super init];
    _queue = [NSOperationQueue new];
    _sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:[NSString stringWithFormat:@"%@", suiteName]];
    _URIcallback = URIcallback;
    
    return self;
}

- (void)startAuthentication
{
    
    NSData *tokenData = [_sharedDefaults objectForKey:@"access_token"];
    _access_token = [NSKeyedUnarchiver unarchiveObjectWithData:tokenData];
    
    NSData *expirationData = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiration"];
    NSDate *dateExpiration = [NSKeyedUnarchiver unarchiveObjectWithData:expirationData];
    NSLog(@"expiration date is:%@", dateExpiration);
    NSComparisonResult result = [dateExpiration compare:[NSDate date]];
    
    if (result == NSOrderedAscending)
    {
        _access_token = nil;
    }
    
    if (_access_token == nil)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@oauth/authorize?client_id=%@&response_type=code&redirect_uri=%@", lockitronURL, _clientID, _URIcallback]];
        NSLog(@"Access token is nil. Requesting one from:");
        NSLog(@"%@", url);
        
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        NSLog(@"Access token is:%@", _access_token);
        if ([_delegate respondsToSelector:@selector(authenticationIsDone)])
        {
            NSLog(@"HMAuthenticator sending authentication is done to delegate");
            [_delegate authenticationIsDone];
        }
    }
}

- (void)authenticationCodeReceived:(NSString *)code
{
    NSLog(@"Authentication code received by HMAuthenticator");
    NSString *urlString = [NSString stringWithFormat:@"%@oauth/token?client_id=%@&client_secret=%@&code=%@&grant_type=authorization_code&redirect_uri=%@", lockitronURL, _clientID, _clientSecret, code, _URIcallback];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [urlRequest setHTTPMethod:@"POST"];
    NSOperationQueue *quere = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:quere completionHandler:^(NSURLResponse *response,
                                                                                        NSData *data,
                                                                                        NSError *error) {
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        _access_token = [JSON objectForKey:@"access_token"];
        [_sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_access_token] forKey:@"access_token"];
        [_sharedDefaults synchronize];
        NSLog(@"HMAuthenticator saving access token");
        
        if ([_delegate respondsToSelector:@selector(authenticationIsDone)])
        {
            NSLog(@"HMAuthenticator sending authenticator is done");
            [_delegate authenticationIsDone];
        }
    }];
    
}

@end
