//
//  NSDictionary+selfie_package.h
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (selfie_package)

- (NSString *)nextPage;
-(NSDictionary *)request;
- (NSArray *)arraySelfies;
- (NSArray *)arraySelfiesLow;

@end
