//
//  InstagramService.m
//  InstaOSA
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import "InstagramService.h"
static NSString * const InstagramAccessToken = @"YOUR ACCESS TOKEN";
static NSString * const InstagramURLString = @"https://api.instagram.com/v1/tags/selfie/media/";

@implementation InstagramService


+ (InstagramService *)sharedInstagramHTTPClient
{
    static InstagramService *_sharedInstagramHTTPClient = nil;
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstagramHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:InstagramURLString]];
    });
    
    return _sharedInstagramHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}


-(void)loadPictures:(NSString *)withNextPage completion:(void(^)(void))completion
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = InstagramAccessToken;
    
    if ([withNextPage length] != 0) {
        parameters[@"max_tag_id"] = withNextPage;
    }
    
    [self GET:@"recent" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(instagramService:didUpdateWithPictures:completion:)]) {
            [self.delegate instagramService:self didUpdateWithPictures:responseObject completion:completion];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(instagramService:didFailWithError:completion:)]) {
            [self.delegate instagramService:self didFailWithError:error completion:completion];
        }
    }];
    
}


@end
