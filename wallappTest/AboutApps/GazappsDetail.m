//
//  AppDetail.m
//  GazApps
//
//  Created by sebastiao Gazolla Costa Junior on 20/12/11.
//  Copyright (c) 2011 iPhone and Java developer. All rights reserved.
//

#import "GazappsDetail.h"

@implementation GazappsDetail

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"_name"];
        _owner = [coder decodeObjectForKey:@"_owner"];
        _price = [coder decodeObjectForKey:@"_price"];
        _url = [coder decodeObjectForKey:@"_url"];
        _urlIcon = [coder decodeObjectForKey:@"_urlIcon"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"_name"];
    [coder encodeObject:self.owner forKey:@"_owner"];
    [coder encodeObject:self.price forKey:@"_price"];
    [coder encodeObject:self.url forKey:@"_url"];
    [coder encodeObject:self.urlIcon forKey:@"_urlIcon"];
}

@end
