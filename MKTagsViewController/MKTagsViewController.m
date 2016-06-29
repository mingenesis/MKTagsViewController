//
//  MKTagsViewController.m
//  
//
//  Created by Mingenesis on 16/6/24.
//
//

#import "MKTagsViewController.h"
#import "MKTagsPanGestureRecognizer.h"

@interface MKTagsViewController ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, weak) UIViewController *transitioningViewController;
@property (nonatomic) NSInteger transDirection;

@end

@implementation MKTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.clipsToBounds = YES;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:contentView];
    
    NSDictionary *vs = NSDictionaryOfVariableBindings(contentView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:vs]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:vs]];
    
    MKTagsPanGestureRecognizer *interactiveGR = [[MKTagsPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleInteractiveGR:)];
    interactiveGR.maximumNumberOfTouches = 1;
    [contentView addGestureRecognizer:interactiveGR];
    
    _contentView = contentView;
    _interactiveGestureRecognizer = interactiveGR;
    
    [self transitionFromViewController:nil toViewController:self.selectedViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)handleResignActiveNotification:(NSNotification *)noti {
    self.interactiveGestureRecognizer.enabled = NO;
    self.interactiveGestureRecognizer.enabled = YES;
}

- (void)handleInteractiveGR:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    UIViewController *transitioningVC = self.transitioningViewController;
    UIViewController *selectedVC = self.selectedViewController;
    CGRect selectedFrame = self.contentView.bounds;
    CGRect transFrame = self.contentView.bounds;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.transDirection = translation.x > 0 ? 1 : -1;
        
        [selectedVC beginAppearanceTransition:NO animated:YES];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (translation.x * self.transDirection < 0) {
            if (transitioningVC) {
                [transitioningVC beginAppearanceTransition:NO animated:NO];
                [transitioningVC.view removeFromSuperview];
                [transitioningVC endAppearanceTransition];
                
                transitioningVC = self.transitioningViewController = nil;
            }
        }
        
        if (!transitioningVC) {
            self.transDirection = translation.x > 0 ? 1 : -1;
            NSUInteger selectedIndex = [self.viewControllers indexOfObject:selectedVC];
            NSInteger transIndex = selectedIndex - self.transDirection;
            
            if (0 <= transIndex && transIndex < self.viewControllers.count) {
                transitioningVC = self.transitioningViewController = self.viewControllers[transIndex];
                
                [transitioningVC beginAppearanceTransition:YES animated:YES];
                transitioningVC.view.frame = transFrame;
                transitioningVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                [self.contentView addSubview:transitioningVC.view];
            }
        }
        
        if (self.transitioningViewController) {
            selectedFrame.origin.x = translation.x;
            transFrame.origin.x = translation.x - self.transDirection * (transFrame.size.width + 10);
            
            transitioningVC.view.frame = transFrame;
            selectedVC.view.frame = selectedFrame;
        } else {
            selectedFrame.origin.x = 0.5 * translation.x * selectedFrame.size.width / (selectedFrame.size.width + self.transDirection * translation.x);
            selectedVC.view.frame = selectedFrame;
        }
    }
    else {
        if (!self.transitioningViewController) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                selectedVC.view.frame = selectedFrame;
                
                [selectedVC beginAppearanceTransition:YES animated:YES];
            } completion:^(BOOL finished) {
                if (finished) {
                    [selectedVC endAppearanceTransition];
                }
            }];
            
            return;
        }
        
        self.transitioningViewController = nil;
        
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            _selectedViewController = transitioningVC;
            
            if ([self.delegate respondsToSelector:@selector(tagsViewController:didSelectViewController:)]) {
                [self.delegate tagsViewController:self didSelectViewController:self.selectedViewController];
            }
            
            selectedFrame.origin.x = self.transDirection * (selectedFrame.size.width + 10);
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                selectedVC.view.frame = selectedFrame;
                transitioningVC.view.frame = transFrame;
            } completion:^(BOOL finished) {
                [selectedVC.view removeFromSuperview];
                
                if (finished) {
                    [selectedVC endAppearanceTransition];
                    [transitioningVC endAppearanceTransition];
                }
            }];
        }
        else {
            transFrame.origin.x = - self.transDirection * (transFrame.size.width + 10);
            
            if (self.interactiveGestureRecognizer.enabled) {
                [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    selectedVC.view.frame = selectedFrame;
                    transitioningVC.view.frame = transFrame;
                    
                    [transitioningVC beginAppearanceTransition:NO animated:YES];
                    [selectedVC beginAppearanceTransition:YES animated:YES];
                } completion:^(BOOL finished) {
                    [transitioningVC.view removeFromSuperview];
                    
                    if (finished) {
                        [transitioningVC endAppearanceTransition];
                        [selectedVC endAppearanceTransition];
                    }
                }];
            }
            else {
                selectedVC.view.frame = selectedFrame;
                transitioningVC.view.frame = transFrame;
                
                [transitioningVC beginAppearanceTransition:NO animated:NO];
                [selectedVC beginAppearanceTransition:YES animated:NO];
                
                [transitioningVC.view removeFromSuperview];
                [transitioningVC endAppearanceTransition];
                [selectedVC endAppearanceTransition];
            }
        }
    }
}

- (void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController {
    if (fromViewController) {
        [fromViewController.view removeFromSuperview];
    }
    
    if (toViewController) {
        toViewController.view.frame = self.contentView.bounds;
        toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:toViewController.view];
    }
}

#pragma mark - Setter / Getter

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    UIViewController *fromSVC = self.selectedViewController;
    
    for (UIViewController *vc in _viewControllers) {
        [vc removeFromParentViewController];
    }
    
    _viewControllers = viewControllers;
    
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
    }
    
    if (fromSVC && [viewControllers containsObject:fromSVC]) {
        self.selectedViewController = fromSVC;
    }
    else {
        self.selectedViewController = viewControllers.firstObject;
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if (selectedViewController) {
        if (![self.viewControllers containsObject:selectedViewController]) {
            return;
        }
        
        if (selectedViewController == _selectedViewController) {
            return;
        }
    }
    
    if (self.interactiveGestureRecognizer) {
        self.interactiveGestureRecognizer.enabled = NO;
        self.interactiveGestureRecognizer.enabled = YES;
    }
    
    UIViewController *fromSVC = _selectedViewController;
    _selectedViewController = selectedViewController;
    
    if (self.contentView) {
        [self transitionFromViewController:fromSVC toViewController:selectedViewController];
    }
}

@end
