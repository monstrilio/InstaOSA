//
//  NSDictionary+DateAdditions.h
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Selfie)

- (NSString *)selfieLowResolutionURL;
- (NSString *)selfieThumbnailURL;
- (NSString *)selfieStandardResolutionURL;

@end
