 //
//  ParallaxSliderViewController.m
//  ParallaxSlider
//
//  Created by Simone Fantini on 03/07/15.
//  Copyright (c) 2015 BSDSoftware. All rights reserved.
//

#import "ParallaxSliderViewController.h"

@interface ParallaxSliderViewController ()

@property (nonatomic, readwrite) ParallaxSliderState state;
@property (nonatomic, assign) CGFloat lastYPoint;
@property (nonatomic, assign) BOOL movingUpwards;

@end

@implementation ParallaxSliderViewController

const CGFloat InvalidLastYPoint = -1;

- (void)awakeFromNib {
	[super awakeFromNib];
	self.parallaxEnabled = YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (!self.parallaxEnabled)
		return;
	
	self.state = ParallaxSliderStateFullBackgroundVisible;
	self.slidingFactor = 0.5f;
	self.lastYPoint = InvalidLastYPoint;
	[self ricalcolaDimensioni];
}

- (void)ricalcolaDimensioni {
	[self.view layoutIfNeeded];
	CGFloat backgroundViewHeight = [self backgroundViewHeight];
	self.backgroundViewHeightConstraint.constant = backgroundViewHeight;
	self.slidingViewMarginConstraint.constant = backgroundViewHeight;
	self.slidingViewHeightConstraint.constant = [self slideViewHeight];
	[self.view layoutIfNeeded];
}

- (void)setState:(ParallaxSliderState)state {
	if (_state != state) {
		[self onStateChange:state fromState:_state];
		_state = state;
	}
}

- (CGFloat)backgroundViewHeight {
	return 0.0f;
}

- (CGFloat)slideViewHeight {
	return 0.0f;
}

- (void)scrollToTopAnimated:(BOOL)animated {
	if (self.slidingViewMarginConstraint.constant == 0)
		return;
	
	CGFloat deltaScroll = -self.slidingViewMarginConstraint.constant;
	[self scrollByDelta:deltaScroll];
	if (animated) {
		[UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
			[self.view layoutIfNeeded];
		} completion:nil];
	} else {
		[self.view layoutIfNeeded];
	}
}

- (void)scrollByDelta:(CGFloat)delta {
	CGFloat parallaxDelta = delta * self.slidingFactor;
	self.backgroundViewMarginConstraint.constant += parallaxDelta;
	self.slidingViewMarginConstraint.constant += delta;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	CGPoint locationInView = [touch locationInView:self.view];
	self.lastYPoint = locationInView.y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	CGPoint locationInView = [touch locationInView:self.view];
	if (self.lastYPoint != InvalidLastYPoint) {
		CGFloat delta = locationInView.y - self.lastYPoint;
		CGFloat parallaxDelta = delta * self.slidingFactor;
		if (self.backgroundViewMarginConstraint.constant + parallaxDelta <= 0 && self.slidingViewMarginConstraint.constant + delta >= 0) {
			self.backgroundViewMarginConstraint.constant += parallaxDelta;
			self.slidingViewMarginConstraint.constant += delta;
			self.state = ParallaxSliderStateMiddle;
		} else {
			if (self.backgroundViewMarginConstraint.constant == 0) {
				self.state = ParallaxSliderStateFullBackgroundVisible;
			} else {
				self.state = ParallaxSliderStateFullSlidingVisibile;
			}
		}
	}
	self.movingUpwards = (locationInView.y - self.lastYPoint) < 0;
	self.lastYPoint = locationInView.y;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	CGPoint locationInView = [touch locationInView:self.view];
	

	CGFloat direction = self.movingUpwards ? -1 : 1;
	
	CGFloat delta = direction * locationInView.y / self.lastYPoint * 50;
	if (self.movingUpwards) {
		if (self.slidingViewMarginConstraint.constant < [self backgroundViewHeight] / 2) {
			delta = -self.slidingViewMarginConstraint.constant; //scroll to top
		} else if (self.slidingViewMarginConstraint.constant + delta <= 0) {
			delta = self.slidingViewMarginConstraint.constant *-1;
		}
	} else {
		if (self.backgroundViewMarginConstraint.constant + delta >= 0) {
			delta = self.backgroundViewMarginConstraint.constant *-1;
		}
	}
	
	CGFloat parallaxDelta = delta * self.slidingFactor;

	[UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.backgroundViewMarginConstraint.constant += parallaxDelta;
		self.slidingViewMarginConstraint.constant += delta;
		[self.view layoutIfNeeded];
	} completion:^(BOOL finished) {
		self.lastYPoint = InvalidLastYPoint;
	}];
}

- (void)onStateChange:(ParallaxSliderState)newState fromState:(ParallaxSliderState)oldState { }

@end
