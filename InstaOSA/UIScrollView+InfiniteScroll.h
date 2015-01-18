//
//  UIScrollView+InfiniteScroll.h
//  InstagramSelfie
//
//  Created by Oscar Sánchez Ayala on 18/01/15.
//  Copyright (c) 2015 OSA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (InfiniteScroll)

/**
 *  Infinite scroll activity indicator style (default: UIActivityIndicatorViewStyleGray)
 */
@property (nonatomic) UIActivityIndicatorViewStyle infiniteScrollIndicatorStyle;

/**
 *  Setup infinite scroll handler
 *
 *  @param handler a handler block
 */
- (void)addInfiniteScrollWithHandler:(void(^)(UIScrollView* scrollView))handler;

/**
 *  Unregister infinite scroll
 */
- (void)removeInfiniteScroll;

/**
 *  Finish infinite scroll animations
 *
 *  You must call this method from your infinite scroll handler to finish all
 *  animations properly and reset infinite scroll state
 *
 *  @param handler a completion block handler called when animation finished
 */
- (void)finishInfiniteScrollWithCompletion:(void(^)(UIScrollView* scrollView))handler;

/**
 *  Finish infinite scroll animations
 *
 *  You must call this method from your infinite scroll handler to finish all
 *  animations properly and reset infinite scroll state
 */
- (void)finishInfiniteScroll;

/**
 *  Set custom infinite indicator view
 *
 *  You may implement methods below to animate custom indicator:
 *
 *  * `- (void)startAnimating`
 *  * `- (void)stopAnimating`
 *
 *  Infinite scroll will call implemented methods during user interaction.
 *
 *  @param indicatorView a custom indicator view
 */
- (void)setInfiniteIndicatorView:(UIView*)indicatorView;

@end
