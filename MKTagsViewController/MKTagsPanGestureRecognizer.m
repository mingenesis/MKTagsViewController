//
//  MKTagsPanGestureRecognizer.m
//  
//
//  Created by Mingenesis on 16/6/27.
//
//

#import "MKTagsPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MKTagsPanGestureRecognizer ()

@end

@implementation MKTagsPanGestureRecognizer

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint translation = [self translationInView:self.view];
    
    [super touchesMoved:touches withEvent:event];
    
    if (touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
    
    if (self.state == UIGestureRecognizerStateBegan) {
        if (translation.y > 0 && ABS(translation.x / translation.y) <= 1) {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint velocity = [self velocityInView:self.view];
    CGPoint translation = [self translationInView:self.view];
    
    if (velocity.x * translation.x < 0) {
        self.state = UIGestureRecognizerStateFailed;
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end
