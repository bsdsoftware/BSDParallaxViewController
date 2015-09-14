//
//  ParallaxSliderViewController.h
//  ParallaxSlider
//
//  Created by Simone Fantini on 03/07/15.
//  Copyright (c) 2015 BSDSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ParallaxSliderState) {
	ParallaxSliderStateFullBackgroundVisible,
	ParallaxSliderStateMiddle,
	ParallaxSliderStateFullSlidingVisibile
};

@interface ParallaxSliderViewController : UIViewController

@property (nonatomic, assign) BOOL parallaxEnabled;
@property (nonatomic, readonly) ParallaxSliderState state;
@property (nonatomic, assign) CGFloat slidingFactor;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backgroundViewMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backgroundViewHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *slidingViewMarginConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *slidingViewHeightConstraint;

/**
 Il valore deve essere calcolato dalla sottoclasse.
 */
- (CGFloat)backgroundViewHeight;

/**
 Il valore deve essere calcolato dalla sottoclasse.
 */
- (CGFloat)slideViewHeight;

- (void)onStateChange:(ParallaxSliderState)newState fromState:(ParallaxSliderState)oldState;

- (void)scrollByDelta:(CGFloat)delta;

- (void)scrollToTopAnimated:(BOOL)animated;

- (void)ricalcolaDimensioni;

@end
