//
//  NSDictionary+selfie_package.m
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import "NSDictionary+selfie_package.h"

@implementation NSDictionary (selfie_package)

- (NSString *)nextPage
{
    NSDictionary *dict = self[@"pagination"];
    return dict[@"next_max_tag_id"];
}

- (NSDictionary *)request
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"request"];
    return ar[0];
}

- (NSArray *)arraySelfies
{
    return [self valueForKeyPath:@"data.images"];
}

- (NSArray *)arraySelfiesLow
{
    NSArray *ar = [self valueForKeyPath:@"data.images.low_resolution.url"];
    
    return ar;
}

@end
