//
//  NSDictionary+DateAdditions.m
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import "NSDictionary+Selfie.h"

@implementation NSDictionary (Selfie)


- (NSString *)selfieLowResolutionURL
{
    NSDictionary *dic = self[@"low_resolution"];
    NSString *low = dic[@"url"];
    return low;
}

- (NSString *)selfieThumbnailURL
{
    NSArray *ar = self[@"thumbnail"];
    NSDictionary *dict = ar[0];
    return dict[@"url"];
}

- (NSString *)selfieStandardResolutionURL
{
    NSArray *ar = self[@"standard_resolution"];
    NSDictionary *dict = ar[0];
    return dict[@"url"];
}

@end
