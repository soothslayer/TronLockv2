//
//  HMLockitronAccount.m
//  TronLockv2
//
//  Created by Hanlon Miller on 8/14/14.
//  Copyright (c) 2014 Hanlon Miller Inc. All rights reserved.
//

#import "HMLockitronAccount.h"
#import "HMAuthenticator.h"
#import "HMLockitronStatic.h"

@interface HMLockitronAccount () <HMAuthenticatorDelegate>

@property (strong) HMAuthenticator *authenticator;
@property (strong) NSOperationQueue *queue;
@property (assign) BOOL isReady;
@property (weak) id<HMLockitronAccountDelegate> delegate;
@property (strong) NSArray *locks;
@property (strong) LTUser *user;
@property (strong) NSUserDefaults *sharedDefaults;
//@property (copy) id JSONdata;
@end


@implementation HMLockitronAccount

static HMLockitronAccount *_instance = nil;

+ (void)startWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret URIcallback:(NSString *)URIcallback delegate:(id<HMLockitronAccountDelegate>)delegate {
    if (_instance == nil)
    {
        NSLog(@"Instance of HMLockitronAccount is nil");
        HMAuthenticator *authenticator = [[HMAuthenticator alloc] initWithURIcallback:URIcallback];
        authenticator.clientID = clientID;
        authenticator.clientSecret = clientSecret;
        
        _instance = [HMLockitronAccount new];
        _instance.authenticator = authenticator;
        authenticator.delegate = _instance;
        
        _instance.delegate = delegate;
        //_instance.queue = [NSOperationQueue new];
    }
    NSLog(@"HMLockitronAccount sending startAuthentication to authenticator instance");
    [_instance.authenticator startAuthentication];
}
- (id)init {
    if (self == [super init]) {
        _isReady = NO;
        //_queue = [NSOperationQueue new];
    }
    return self;
}
+ (void)handleOpenURL:(NSURL *)url
{
    NSArray *pathComponents = [[url absoluteString] componentsSeparatedByString:@"?code="];
    [_instance.authenticator authenticationCodeReceived:pathComponents[1]];
}
- (void)authenticationIsDone {
    NSLog(@"HMLockitronAccount received authenticationIsDone");
    NSLog(@"HMLockitronAccount is requesting locks");
    
    _isReady = YES;
    [self requestLocksv2];
}
+ (void)refreshLocks {
    [_instance requestLocksv2];
}
//- (void)requestLocks
//{
//    //create a url for the locks request
//    NSString *urlString = [NSString stringWithFormat:@"%@?access_token=%@", lockitronCommandURL, _authenticator.access_token];
//    //turn the url into a request
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.0];
//    [urlRequest setHTTPMethod:@"POST"];
//    
////    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
//    //then make an async connection with completion handler
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        //turn the nsdata into a json object
//        id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//        //store the object into shared defaults
//        [_sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:JSON] forKey:@"JSON"];
//        [_sharedDefaults synchronize];
//        //load the locks from JSON data
//        [self loadLocksfromJSONdata:JSON];
//        
//        if ([_delegate respondsToSelector:@selector(lockitronIsReady)])
//        {
//            NSLog(@"Request Locks Finished Lockitron is ready");
//            [_delegate lockitronIsReady];
//        }
//        
//    }];
//    
//}
- (void)requestCurrentUser {
    NSData *currentuserRequest = [self lockitronAPIRequestforLocksorUsers:@"users" withRequestMethod:@"GET" andDirectory:@"me" andAruments:nil];
    NSError *error = nil;
    id JSON = [NSJSONSerialization JSONObjectWithData:currentuserRequest options:NSJSONReadingAllowFragments error:&error];
    _instance.user = [self getUserInfoFromJSONdata:JSON];
}
- (LTUser *)getUserInfoFromJSONdata:(id)JSONdata {
    LTUser *user = [[LTUser alloc] init];
    user.isActivated = [[JSONdata objectForKey:@"activated"] boolValue];
    user.avatar_url = [NSURL URLWithString:[JSONdata objectForKey:@"avatar_url"]];
    NSLog(@"avatar url is:%@", user.avatar_url);
    user.changing_email = [[JSONdata objectForKey:@"changing_email"] boolValue];
    user.changing_phone = [[JSONdata objectForKey:@"changing_phone"] boolValue];
    user.email = [JSONdata objectForKey:@"email"];
    user.facebook = [[JSONdata objectForKey:@"facebook"] boolValue];
    user.firstName = [JSONdata objectForKey:@"first_name"];
    user.fullName = [JSONdata objectForKey:@"full_name"];
    user.id = [JSONdata objectForKey:@"id"];
    user.lastName = [JSONdata objectForKey:@"last_name"];
    user.phoneNumber = [JSONdata objectForKey:@"phone"];
    return user;
}
- (void)requestLocksv2
{
    //create a url for the locks request
    NSString *urlString = [NSString stringWithFormat:@"%@v2/locks?access_token=%@", lockitronBaseURL, _authenticator.access_token];
    //turn the url into a request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.0];
    [urlRequest setHTTPMethod:@"GET"];
    
    //    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    //then make an async connection with completion handler
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data == nil) {
            NSLog(@"data is nil. Loading data from sharedDefaults");
            NSData *JSONdata = [_sharedDefaults objectForKey:@"JSON"];
            if (JSONdata != nil) {
                NSLog(@"JSON data from shared defaults is:%@", JSONdata);
                //id JSON = [NSKeyedUnarchiver unarchiveObjectWithData:JSONdata];
            }
        }
        //turn the nsdata into a json object
        id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        //NSLog(@"JSONv2:%@", JSON);
        //store the object into shared defaults
        [_sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:JSON] forKey:@"JSON"];
        [_sharedDefaults synchronize];
        //load the locks from JSON data
        [self loadLocksfromJSONdatav2:JSON];
        
        if ([_delegate respondsToSelector:@selector(lockitronIsReady)])
        {
            NSLog(@"Request Locks Finished Lockitron is ready");
            [_delegate lockitronIsReady];
        }
        
    }];
    //[self requestCurrentUser];

}
- (NSArray *)loadLocksfromJSONdatav2:(id)JSON {
    NSMutableArray *locks = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    for (NSDictionary *item in JSON)
    {
        LTLock *lock = [[LTLock alloc] init];
        lock.delegate = self;
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        if ([item objectForKey:@"avr_update_progress"] != [NSNull null]) {
            lock.avr_update_progress = [[item objectForKey:@"avr_update_progress"] intValue];
        }
        if ([item objectForKey:@"ble_update_progress"] != [NSNull null]) {
            lock.ble_update_progress = [[item objectForKey:@"ble_update_progress"] intValue];
        }
        lock.button_type = [item objectForKey:@"button_type"];
        lock.handedness = [item objectForKey:@"handedness"];
        lock.id = [item objectForKey:@"id"];
        
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        
        for (NSDictionary *itemKey in [item objectForKey:@"keys"])
        {
            LTKey *key = [[LTKey alloc] init];
            if ([itemKey objectForKey:@"access_key"] != [NSNull null]) {
                key.access_key = [itemKey objectForKey:@"access_key"];
            }
            if ([itemKey objectForKey:@"expiration_date"] != [NSNull null]) {
                key.expiration_date = [dateFormatter dateFromString:[itemKey objectForKey:@"expiration_date"]];
            }
            key.id = [itemKey objectForKey:@"id"];
            key.role = ([[itemKey objectForKey:@"role"] isEqualToString:@"guest"]) ? 0 : 1;
            if ([itemKey objectForKey:@"sms_pin"] != [NSNull null]) {
                key.sms_pin = [itemKey objectForKey:@"sms_pin"];
            }
            if ([itemKey objectForKey:@"start_date"] != [NSNull null]) {
                key.start_date = [dateFormatter dateFromString:[itemKey objectForKey:@"start_date"]];
            }
            
            LTUser *user = [[LTUser alloc] init];
            user.isActivated = [[[itemKey objectForKey:@"user"] objectForKey:@"activated"] boolValue];
            user.avatar_url = [NSURL URLWithString:[[itemKey objectForKey:@"user"] objectForKey:@"avatar_url"]];
            user.changing_email = [[[itemKey objectForKey:@"user"] objectForKey:@"changing_email"] boolValue];
            user.changing_phone = [[[itemKey objectForKey:@"user"] objectForKey:@"changing_phone"] boolValue];
            user.email = [[itemKey objectForKey:@"user"] objectForKey:@"email"];
            user.facebook = [[[itemKey objectForKey:@"user"] objectForKey:@"facebook"] boolValue];
            user.firstName = [[itemKey objectForKey:@"user"] objectForKey:@"first_name"];
            user.fullName = [[itemKey objectForKey:@"user"] objectForKey:@"full_name"];
            user.id = [[itemKey objectForKey:@"user"] objectForKey:@"id"];
            user.lastName = [[itemKey objectForKey:@"user"] objectForKey:@"last_name"];
            user.phoneNumber = [[itemKey objectForKey:@"user"] objectForKey:@"phone"];
            
            key.user = user;
            
            key.isValid = [[itemKey objectForKey:@"valid"] boolValue];
            key.isVisible = [[itemKey objectForKey:@"visible"] boolValue];

            [keys addObject:key];
        } //end of iterating through the keys
        
        lock.keys = keys;
        
        lock.name = [item objectForKey:@"name"];
        if ([item objectForKey:@"next_wake"] != [NSNull null]) {
            lock.next_wake = [dateFormatter dateFromString:[item objectForKey:@"next_wake"]];
        }
        //NSLog(@"pending activity:%@", [item objectForKey:@"pending_activity"]);
        lock.pending_activity = [item objectForKey:@"pending_activity"];
        lock.serial_number = [item objectForKey:@"serial_number"];
        if ([item objectForKey:@"sleep_period"] == [NSNull null]) {
            lock.sleep_period = 0;
        } else {
            lock.sleep_period = [[item objectForKey:@"sleep_period"] intValue];
        }
        lock.sms = [[item objectForKey:@"sms"] boolValue];
        if ([item objectForKey:@"state"] == [NSNull null])
        {
            lock.state = LockitronSDKLockNotConfigured;
        } //end of check to see if the lock is configured
        else
        {
            lock.state = ([[item objectForKey:@"state"] isEqualToString:@"unlock"]) ? LockitronSDKLockOpen : LockitronSDKLockClosed;
        } //end of lock/unlock check
        lock.time_zone = [item objectForKey:@"time_zone"];
        lock.updated_at = [dateFormatter dateFromString:[item objectForKey:@"updated_at"]];
//        NSLog(@"Raw data:%@", lock.updated_at);
//        NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
//        [gmtDf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
//        NSLog(@"date before timezone:%@", [gmtDf dateFromString:lock.updated_at]);
//        [gmtDf setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//        NSDate* gmtDate = [gmtDf dateFromString:lock.updated_at];
//        NSLog(@"date after UTC:%@",gmtDate);
//        [gmtDf setTimeZone:[NSTimeZone timeZoneWithName:lock.time_zone]];
//        NSLog(@"data after ETC in string:%@", [gmtDf stringFromDate:gmtDate]);
//        
//        NSDateFormatter* estDf = [[NSDateFormatter alloc] init];
//        [estDf setTimeZone:[NSTimeZone timeZoneWithName:lock.time_zone]];
//        [estDf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
//        NSString *estDateString = [estDf stringFromDate:gmtDate];
//        NSLog(@"EST string:%@", estDateString);
//        NSDate *estDate = [estDf dateFromString:estDateString];
//        NSLog(@"ETC:%@",estDate);

        [locks addObject:lock];
    } //end of iterating through the locks
    
    _locks = locks;
    NSLog(@"Finished loading locks");
    return locks;
}
- (NSArray *)loadLocksfromJSONdata:(id)JSON {
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
            lock.state = -1;
        } //end of check to see if the lock is configured
        else
        {
            lock.state = ([[[item objectForKey:@"lock"] objectForKey:@"status"] isEqualToString:@"unlock"]) ? 0 : 1;
        } //end of lock/unlock check
        
        NSMutableArray *keys = [[NSMutableArray alloc] init];
        
        for (NSDictionary *itemKey in [[item objectForKey:@"lock"] objectForKey:@"keys"])
        {
            LTKey *key = [[LTKey alloc] init];
            key.id = [itemKey objectForKey:@"id"];
            key.role = ([[itemKey objectForKey:@"role"] isEqualToString:@"guest"]) ? 0 : 1;
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
        } //end of iterating through the keys
        
        lock.keys = keys;
        
        [locks addObject:lock];
    } //end of iterating through the locks
    
    _locks = locks;
    NSLog(@"Finished loading locks");
    return locks;
}
- (NSData *)lockitronAPIRequestforLocksorUsers:(NSString *)locksOrUsers withRequestMethod:(NSString *)requestMethod andDirectory:(NSString *)directory andAruments:(NSDictionary *)arguments {
    //set up the base url
    NSString *urlString = [NSString stringWithFormat:@"%@v2", lockitronBaseURL];
    //add the locks or users subdirectory
    if ([locksOrUsers isEqualToString:@"locks"] || [locksOrUsers isEqualToString:@"users"]) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"/%@/", locksOrUsers]];
    } else {
        NSLog(@"lockitronAPI request wasn't for locks or users");
    }
    //add any other subdirectories
    if (directory != nil) {
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@/", directory]];
    }
    //now add the access token
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?access_token=%@", _authenticator.access_token]];
    //now add any arguments
    if (arguments != nil) {
        for (NSString *argument in [arguments allKeys]) {
            urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", argument, [arguments objectForKey:argument]]];
        }
    }
    NSLog(@"sending api request:%@", urlString);
    //set up the request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.0];
    //make sure the request is correct
    if ([requestMethod isEqualToString:@"GET"] || [requestMethod isEqualToString:@"PUT"] || [requestMethod isEqualToString:@"POST"] || [requestMethod isEqualToString:@"DELETE"]) {
        [urlRequest setHTTPMethod:requestMethod];
    } else {
        NSLog(@"lockitronAPI request method wasn't correct");
    }
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (data != nil) {
        return data;
    }
    return nil;
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error) {
//        if (data) {
//            _JSONdata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            if (_JSONdata) {
//                [self lockitronAPIRequestCompletedWithJSONdata];
//            } else {
//                NSLog(@"JSON parsing error");
//            }
//        } else {
//            NSLog(@"Error description:%@", error.description);
//        }
//    }];
}
- (void)lockitronAPIRequestCompletedWithJSONdata {
    
}
- (void)sendCommand:(NSString *)command toLock:(LTLock *)lock
{
    NSString *urlString = [NSString stringWithFormat:@"%@v2/locks/%@?access_token=%@&state=%@", lockitronBaseURL, lock.id, _authenticator.access_token, command];
    NSLog(@"sending command:%@", urlString);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [urlRequest setHTTPMethod:@"PUT"];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if ([[JSON objectForKey:@"state"] isEqualToString:@"unlock"]) {
                lock.state = LockitronSDKLockOpen;
                
                if ([_delegate respondsToSelector:@selector(lockitronChangedLockState:to:)])
                {
                    [_delegate lockitronChangedLockState:lock to:lock.state];
                }
            } else if ([[JSON objectForKey:@"state"] isEqualToString:@"lock"]) {
                lock.state = LockitronSDKLockClosed;
                if ([_delegate respondsToSelector:@selector(lockitronChangedLockState:to:)])
                {
                    [_delegate lockitronChangedLockState:lock to:lock.state];
                }
            }
        } else {
            NSLog(@"Error description:%@", error.description);
            if (error.code == -1001) {
                NSLog(@"it did it!!!!");
            }
        }
    }];
    
}
- (void)changeSleepInterval:(NSString *)command toLock:(LTLock *)lock
{
    NSString *urlString = [NSString stringWithFormat:@"%@v2/locks/%@?access_token=%@&sleep_period=%@", lockitronBaseURL, lock.id, _authenticator.access_token, command];
    NSLog(@"sending command:%@", urlString);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [urlRequest setHTTPMethod:@"PUT"];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if ([JSON objectForKey:@"sleep_period"] == [command integerValue]) {
                NSLog(@"Success");
            } else {
                NSLog(@"Sleep period requested was:%@ and now is:%@", command, [JSON objectForKey:@"sleep_period"]);
            }
        } else {
            NSLog(@"Error description:%@", error.description);
            if (error.code == -1001) {
                NSLog(@"it did it!!!!");
            }
        }
    }];
    
}
+ (NSArray *)locksList
{
    return _instance.locks;
}
- (void)saveLocks {
    [_sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_instance.locks] forKey:@"locks"];
    [_sharedDefaults synchronize];
}
+ (LTUser *)userAuthenticated
{
    return _instance.user;
}
+ (NSArray *)loadLocksfromUserDefaults {
    NSData *lockData = [[[NSUserDefaults alloc] initWithSuiteName:[NSString stringWithFormat:@"%@", suiteName]] objectForKey:@"locks"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:lockData];
}
@end
