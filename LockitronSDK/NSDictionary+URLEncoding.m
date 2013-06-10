//
//  NSDictionary+URLEncoding.m
//  LockitronSDKExample
//
//  Created by Sebastien Thiebaud on 6/10/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "NSDictionary+URLEncoding.h"

@implementation NSDictionary (URLEncoding)

static NSString *toString (id object) {
    return [NSString stringWithFormat:@"%@", object];
}

static NSString *urlEncode (id object) {
    return [toString(object) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeForURL
{
    NSMutableArray *parts = [NSMutableArray array];
    
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    
    return [parts componentsJoinedByString:@"&"];
}

@end
