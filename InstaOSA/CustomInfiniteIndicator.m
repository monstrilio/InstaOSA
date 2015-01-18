//
//  CustomInfiniteIndicator.m
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import "CustomInfiniteIndicator.h"

static NSString* const kSpinAnimationKey = @"SpinAnimation";

@implementation CustomInfiniteIndicator

- (void)startAnimating {
    [super startAnimating];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.fromValue = @(0.0);
    animation.toValue = @(2 * M_PI);
    animation.duration = 1.0f;
    animation.repeatCount = INFINITY;
    
    [self.layer addAnimation:animation forKey:kSpinAnimationKey];
}

- (void)stopAnimating {
    [super stopAnimating];
    
    [self.layer removeAnimationForKey:kSpinAnimationKey];
}

@end
