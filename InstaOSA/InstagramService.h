//
//  InstagramService.h
//  InstaOSA
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@protocol InstagramHTTPClientDelegate;

@interface InstagramService : AFHTTPSessionManager

@property (nonatomic, weak) id<InstagramHTTPClientDelegate>delegate;


+ (InstagramService *)sharedInstagramHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)loadPictures:(NSString *)withNextPage completion:(void(^)(void))completion;

@end

@protocol InstagramHTTPClientDelegate <NSObject>
@optional
-(void)instagramService:(InstagramService *)service didUpdateWithPictures:(id)pictures completion:(void(^)(void))completion;
-(void)instagramService:(InstagramService *)service didFailWithError:(NSError *)error completion:(void(^)(void))completion;
@end